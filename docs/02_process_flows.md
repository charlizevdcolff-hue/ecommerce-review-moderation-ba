# Process Workflows: Customer Review Ingestion & Moderation

This document maps how customer reviews move through the store today (**Current State / As-Is**) versus how the proposed triage system will handle them (**Future State / To-Be**).

---

## 1. Current State ("As-Is") Workflow

Today, the review submission process is completely unmonitored. Every review goes live immediately, regardless of rating or customer frustration.

<img width="769" height="800" alt="As-Is drawio" src="https://github.com/user-attachments/assets/0bd99cbb-c8f0-41a6-96f0-96e4837b362d" />

## 2. Future State (To-Be) Workflow

In the new system, an automated moderation rules engine checks incoming reviews before they hit the live storefront.

<img width="800" height="1200" alt="To-be drawio" src="https://github.com/user-attachments/assets/9812bdff-f5cf-40e3-a89d-808d001216e5" />

## 3. Workflow Comparison & Key Changes

| Process Step | As-Is (Today) | To-Be (New System) |
| :--- | :--- | :--- |
| **Review Ingestion** | Goes live immediately | Saved with a status (`APPROVED` or `PENDING`) |
| **Negative Reviews** | Shown to all shoppers | Held in a private support queue |
| **Support Alerts** | None | Automatic ticket created for customer service |
| **Response Time** | Untracked / purely reactive | Outreach goal within 4 hours |
