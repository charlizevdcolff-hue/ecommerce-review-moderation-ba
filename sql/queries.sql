-- ======================================================
-- 1. DATABASE SCHEMA (DDL)
-- ======================================================

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY,
    age INT NOT NULL
);

CREATE TABLE IF NOT EXISTS products (
    clothing_id INT PRIMARY KEY,
    division_name VARCHAR(100),
    department_name VARCHAR(100),
    class_name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS reviews (
    review_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    clothing_id INT REFERENCES products(clothing_id),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    title VARCHAR(255),
    review_text TEXT,
    recommended_ind SMALLINT CHECK (recommended_ind IN (0, 1)),
    positive_feedback_count INT DEFAULT 0,
    moderation_status VARCHAR(20) DEFAULT 'PENDING_TRIAGE',
    resolution_tag VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ======================================================
-- 2. DATA TRANSFORMATION & SEEDING (FROM RAW IMPORT)
-- ======================================================

-- Populate Customers
INSERT INTO customers (customer_id, age)
SELECT DISTINCT 
    CAST("Customer ID" AS INT),
    CAST("Age" AS INT)
FROM raw_reviews
ON CONFLICT (customer_id) DO NOTHING;

-- Populate Products
INSERT INTO products (clothing_id, division_name, department_name, class_name)
SELECT DISTINCT 
    CAST("Clothing ID" AS INT),
    "Division Name",
    "Department Name",
    "Class Name"
FROM raw_reviews
ON CONFLICT (clothing_id) DO NOTHING;

-- Populate Reviews with automated moderation business rules
INSERT INTO reviews (
    customer_id,
    clothing_id,
    rating,
    title,
    review_text,
    recommended_ind,
    positive_feedback_count,
    moderation_status
)
SELECT 
    CAST("Customer ID" AS INT),
    CAST("Clothing ID" AS INT),
    CAST("Rating" AS INT),
    "Title",
    "Review Text",
    CAST("Recommended IND" AS INT),
    COALESCE(CAST("Positive Feedback Count" AS INT), 0),
    CASE 
        WHEN CAST("Rating" AS INT) <= 2 OR CAST("Recommended IND" AS INT) = 0 THEN 'PENDING_TRIAGE'
        ELSE 'APPROVED'
    END AS moderation_status
FROM raw_reviews;

-- ======================================================
-- 3. AUDIT & ANALYTICAL QUERIES
-- ======================================================

-- Query 1: Validate entity record counts
SELECT 
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM products) AS total_products,
    (SELECT COUNT(*) FROM reviews) AS total_reviews;

-- Query 2: Baseline sentiment analysis (recreating the 21.2% audit metric)
SELECT 
    CASE 
        WHEN recommended_ind = 1 THEN 'Satisfied (Recommended)'
        ELSE 'Dissatisfied (Not Recommended)'
    END AS customer_sentiment,
    COUNT(review_id) AS total_reviews,
    ROUND(COUNT(review_id) * 100.0 / SUM(COUNT(review_id)) OVER (), 1) AS percentage_share
FROM reviews
GROUP BY recommended_ind;

-- Query 3: Operational Support Triage Queue (retrieving held negative reviews)
SELECT 
    r.review_id,
    r.customer_id,
    c.age,
    p.clothing_id,
    p.department_name,
    p.class_name,
    r.rating,
    r.title,
    r.review_text,
    r.moderation_status
FROM reviews r
JOIN customers c ON r.customer_id = c.customer_id
JOIN products p ON r.clothing_id = p.clothing_id
WHERE r.moderation_status = 'PENDING_TRIAGE'
ORDER BY r.review_id ASC;

-- Query 4: Identify high-risk products (items with 2+ negative complaints)
SELECT 
    p.clothing_id,
    p.department_name,
    p.class_name,
    COUNT(r.review_id) AS total_complaints,
    ROUND(AVG(r.rating), 2) AS avg_rating
FROM reviews r
JOIN products p ON r.clothing_id = p.clothing_id
WHERE r.rating <= 2 OR r.recommended_ind = 0
GROUP BY p.clothing_id, p.department_name, p.class_name
HAVING COUNT(r.review_id) >= 2
ORDER BY total_complaints DESC;
