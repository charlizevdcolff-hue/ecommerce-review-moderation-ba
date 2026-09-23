# Step 4: Agile User Stories & Acceptance Criteria

This is the  document translates the business requirements and data logic into Jira-style user stories with clear acceptance criteria for developers and QA engineers.


I have made use of Given-When-Then acceptance criteria, as this scenario/business case consists of complex workflows and features that require step-by-step actions.


---
## Story 1: Automated Review Interception & Flagging

* **Story ID:** US-001
* **Epic:** Review Moderation Engine
* **Priority:** High

### User Story
As an **e-commerce store owner**,  
I want the system to automatically hold reviews with low ratings or "do not recommend" tags,  
So that negative feedback does not post publicly before Customer Support can look into the issue.

### Business Rules
* If `Rating <= 2` **OR** `Recommended IND == 0` &rarr; Set `moderation_status = 'PENDING_TRIAGE'`.
* If `Rating >= 3` **AND** `Recommended IND == 1` &rarr; Set `moderation_status = 'APPROVED'`.

### Acceptance Criteria
* **Scenario 1: Customer submits a negative review**
  * **Given** a customer submits a review with a 2-star rating and "Do Not Recommend",
  * **When** the review payload is saved to the database,
  * **Then** its `moderation_status` is set to `PENDING_TRIAGE`,
  * **And** it is hidden from the live product page.

* **Scenario 2: Customer submits a positive review**
  * **Given** a customer submits a review with a 5-star rating and "Recommend",
  * **When** the review payload is saved to the database,
  * **Then** its `moderation_status` is set to `APPROVED`,
  * **And** it is published immediately to the product page.

---

## Story 2: Customer Support Triage Queue

* **Story ID:** US-002
* **Epic:** Customer Care Operations
* **Priority:** High

### User Story
As a **Customer Support Agent**,  
I want a filtered support queue showing all reviews marked `PENDING_TRIAGE`,  
So that I can quickly contact unhappy customers and resolve their issues within 4 hours.

### Acceptance Criteria
* **Scenario 1: Viewing incoming held reviews**
  * **Given** new reviews are held by the system,
  * **When** the support agent opens the review triage dashboard,
  * **Then** only reviews with `moderation_status = 'PENDING_TRIAGE'` are displayed,
  * **And** the list is sorted with the newest reviews at the top.

* **Scenario 2: Escalation alert for slow responses**
  * **Given** a review has been in `PENDING_TRIAGE` for more than 4 business hours without an agent assigned,
  * **When** the dashboard refreshes,
  * **Then** the ticket is highlighted in red to alert team leads.

---

## Story 3: Review Resolution and Publishing

* **Story ID:** US-003
* **Epic:** Review Lifecycle Management
* **Priority:** Medium

### User Story
As a **Customer Support Agent**,  
I want to log a resolution note and update the review status after helping a customer,  
So that our records stay accurate and resolved reviews can be handled correctly.

### Acceptance Criteria
* **Scenario 1: Customer issue resolved with exchange or return**
  * **Given** an agent contacts a customer and resolves their complaint,
  * **When** the agent updates the ticket with a `resolution_tag` (e.g., `SIZE_ISSUE`, `REFUNDED`),
  * **And** changes the status from `PENDING_TRIAGE` to `APPROVED`,
  * **Then** the review becomes visible on the live product page,
  * **And** the customer profile logs that the ticket was closed.
