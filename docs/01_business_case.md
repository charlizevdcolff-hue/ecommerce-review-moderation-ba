# Business Case: Customer Review Moderation & Support Triage System

## 1. Overview
Currently, when a customer submits a review on the website, it publishes immediately to the product page. Nobody reviews or checks it first.

After analyzing a sample of 151 customer reviews, there is a clear issue:
* **21.2% of customers (32 reviews)** explicitly advise against buying the item (Recommended IND = 0).
* **13.9% of customers (21 reviews)** left a 1-star or 2-star rating.

Because these reviews go live instantly:
* Shoppers reading product pages see severe complaints about sizing, broken zippers, or poor fabric quality, which hurts sales.
* Customer Support has no visibility into dissatisfied buyers, meaning we miss the chance to reach out, resolve the issue, or offer an exchange.

---

## 2. Problem Statement
How can we intercept negative reviews when they are submitted so that Customer Support can resolve complaints, protect product sales, and keep dissatisfied shoppers from leaving the brand?

---

## 3. Project Goals
* **Intercept Negative Feedback:** Hold 100% of reviews with a rating of 1–2 stars or where recommendation is "No" before they appear on the live site.
* **Faster Response Times:** Ensure Customer Support contacts dissatisfied reviewers within 4 hours.
* **Customer Retention:** Retain at least 20% of unhappy customers by offering returns, exchanges, or assistance before their complaints go public.

---

## 4. Current State Data Analysis

We audited 151 reviews across 59 clothing items. 

To categorize sentiment, we added a calculated column based on the recommendation field:
`=IF(G2=1, "Satisfied", "Dissatisfied")`

### Review Breakdown

| Customer Sentiment | Review Count | Percentage | Current Workflow | Proposed Workflow |
| :--- | :---: | :---: | :--- | :--- |
| **Satisfied** (`Recommended IND = 1`) | 119 | 78.8% | Publishes immediately | Auto-approve and publish |
| **Dissatisfied** (`Recommended IND = 0`) | 32 | 21.2% | Publishes immediately | **Hold in support queue for review** |
| **Total** | **151** | **100.0%** | | |

**Key Takeaway:** Roughly 1 in 5 reviews comes from an unhappy buyer. Holding these 32 reviews allows support to step in before negative feedback scares off other prospective shoppers.

---

## 5. Team Roles (RACI)

* **Business Analyst:** Map the process flows, define the triage rules, and write user stories for the development team.
* **Engineering Team:** Build the logic that pauses negative reviews and routes them to the support queue.
* **Customer Support Lead:** Define the resolution steps and outreach policies for agents contacting unhappy shoppers.
* **Support Agents:** Handle incoming flagged reviews, contact customers, and log resolution notes.
