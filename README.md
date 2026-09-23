# E-Commerce Review Moderation & Customer Care Triage System

An end-to-end Systems & Business Analysis project modeling an automated review moderation pipeline for an online apparel retailer, transitioning from spreadsheet audits to a live relational database on Supabase.



##  Project Overview
Customer reviews previously published directly to storefront product detail pages without moderation. An audit of 151 customer submissions revealed that 21.2% of reviews (32 submissions) advise against purchasing, surfacing sizing inaccuracies and garment defects directly to prospective buyers.

This project delivers the business requirements, process flows, 3NF schema architecture, and SQL queries needed to intercept negative feedback upon submission, routing records to Customer Support for rapid resolution before public display.

---

## Repository Structure

| Directory / File | Focus Area | Description |
| :--- | :--- | :--- |
| **[01. Business Case](docs/01_business_case.md)** | Problem & Audit | Baseline data analysis, problem statement, and project OKRs. |
| **[02. Process Workflows](docs/02_process_flows.md)** | Gap Analysis | As-Is vs. To-Be process mapping visualized using Mermaid flowcharts. |
| **[03. Data Model](docs/03_data_model.md)** | Architecture | Relational database design splitting flat spreadsheet data into structured tables. |
| **[04. Agile User Stories](docs/04_user_stories.md)** | Delivery | Jira-ready user stories with Given-When-Then acceptance criteria. |
| **[Database Scripts](sql/queries.sql)** | Implementation | DDL table creation, data seeding logic, and analytical PostgreSQL queries. |

---

##  Key Insights & Technical Deliverables
* **Audit Finding:** 21.2% negative recommendation rate identified across 59 catalog items.
* **Database Design:** Normalized flat dataset into 3NF (`customers`, `products`, `reviews`) implemented on PostgreSQL (Supabase).
* **Operational SLA:** Automated status trigger (`PENDING_TRIAGE`) routing held reviews to support queues within a 4-hour target outreach window.
* **Storefront Integrity:** Conditional query logic ensuring only `APPROVED` reviews render on Product Detail Pages (PDP).

---

##  Tools & Technologies
* **Database & SQL:** PostgreSQL, Supabase (DDL, DML, relational joins, aggregate filtering)
* **Data Auditing:** Microsoft Excel (pivot tables, logical formulas)
* **Modeling & Specifications:** Markdown, Draw.io, Agile User Stories (Gherkin Given-When-Then)
