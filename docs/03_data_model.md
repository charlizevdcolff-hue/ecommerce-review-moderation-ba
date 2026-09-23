# Step 3: Data Model & Database Design

This document explains how exactly we take the columns from our Excel review spreadsheet and organize them into clean database tables for the moderation system.

---

## 1. Why Separate the Data?
In the spreadsheet, all product, customer, and review details are mixed into a single row. In a live system, we split them into three tables so we don't repeat the same product or customer information every time a review is submitted:
* **Customers Table:** Stores customer info.
* **Products Table:** Stores clothing item details.
* **Reviews Table:** Stores the review text, ratings, and moderation flags.
<img width="600" height="847" alt="tables_ drawio" src="https://github.com/user-attachments/assets/2810ae4b-0111-4f40-b498-d296cf1fe6af" />

---

## 2. The Tables

### Table 1: Customers
Stores basic shopper information.

| Column Name | Type | Key | Description |
| :--- | :--- | :--- | :--- |
| `customer_id` | Number | Primary Key | Unique number for each customer (from `Customer No`). |
| `age` | Number | | Customer's age. |

---

### Table 2: Products
Stores clothing details so we don't repeat department names for every review.

| Column Name | Type | Key | Description |
| :--- | :--- | :--- | :--- |
| `clothing_id` | Number | Primary Key | Unique clothing ID from the catalog. |
| `division_name` | Text | | High-level division (e.g., General, Petite). |
| `department_name` | Text | | Department (e.g., Tops, Dresses, Bottoms). |
| `class_name` | Text | | Sub-category (e.g., Blouses, Pants). |

---

### Table 3: Reviews (Where Moderation Happens)
Stores the actual reviews and the status tags needed to hold or publish them.

| Column Name | Type | Key | Description |
| :--- | :--- | :--- | :--- |
| `review_id` | Number | Primary Key | Unique ID generated for every review. |
| `customer_id` | Number | Foreign Key | Connects the review to the customer who wrote it. |
| `clothing_id` | Number | Foreign Key | Connects the review to the clothing item. |
| `rating` | Number | | Star rating (1 to 5). |
| `title` | Text | | Review title / headline. |
| `review_text` | Text | | Full feedback written by the customer. |
| `recommended_ind`| Number | | `1` = Recommended, `0` = Not Recommended. |
| `positive_feedback_count` | Number | | How many people found the review helpful. |
| `moderation_status` | Text | | `APPROVED` (show on site) or `PENDING_TRIAGE` (hold for support). |
| `resolution_tag` | Text | | Support note (e.g., `SIZE_ISSUE`, `REFUNDED`, `RESOLVED`). |

---

## 3. How the Tables Connect
* One **Customer** can write many **Reviews**.
* One **Product** can receive many **Reviews**.
* The **Reviews** table connects both together and controls what shows up on the website using `moderation_status`.
