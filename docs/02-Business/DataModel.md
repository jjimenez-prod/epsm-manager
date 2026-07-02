# Data Model

**Project:** EPSM Manager

**Client:** È Pronto Si Mangia

**Version:** 1.0

**Status:** Approved

**Last Update:** 2026-07-02

---

# 1. Purpose

This document defines the business data model of EPSM Manager.

The objective is to represent the operational reality of È Pronto Si Mangia independently of any specific database technology.

The business model is the foundation of the database design.

---

# 2. Design Philosophy

The data model represents business entities rather than user interface components.

Every entity exists because it represents a real object or process within the company.

---

# 3. Core Business Entity

The primary entity of the platform is the Dough Batch.

Every production activity originates from one dough batch.

Everything else is related to it.

---

# 4. Business Entities

## Dough Batch

Represents one production batch.

Attributes include:

- Production date
- Shift
- Recipe type
- Initial dough weight
- Remaining dough weight
- Notes
- Status
- Creation date
- Last update

A dough batch may contain multiple products.

A dough batch may involve multiple operators.

---

## Product

Represents a commercial production item.

Attributes include:

- Name
- Grammage
- Active status

Product information is centrally managed.

Operators never modify product definitions.

---

## Operator

Represents a production worker.

Attributes include:

- Name
- Active status

Operators are selected during production registration.

They are not application users.

---

## Shift

Represents the production shift.

Current values:

- Morning
- Afternoon
- Night

Shift values are configurable.

---

## Recipe

Represents the dough recipe.

Current recipe types:

- Standard
- Special

Future versions may support additional recipes.

---

## Production Item

Represents one product produced within a dough batch.

Each Production Item contains:

- Product
- Quantity produced

A Dough Batch may contain many Production Items.

---

## Remaining Dough

Represents leftover dough after production.

Attributes include:

- Remaining weight
- Destination
- Notes

Future versions may convert remaining dough into inventory.

---

# 5. Relationships

One Dough Batch

↓

Many Production Items

One Dough Batch

↓

Many Operators

One Production Item

↓

One Product

One Dough Batch

↓

One Recipe

One Dough Batch

↓

One Shift

---

# 6. Calculated Information

The following information is calculated.

It should never be manually entered.

Examples include:

- Expected production
- Waste
- Production difference
- Performance
- Bonus eligibility
- KPIs

---

# 7. Historical Integrity

Operational data should never be deleted.

Whenever possible, historical information should be preserved.

Inactive records are preferred over physical deletion.

---

# 8. Audit Information

Every business entity should support audit information.

Recommended audit fields include:

- Created At
- Updated At
- Created By
- Updated By

Future versions may include change history.

---

# 9. Configuration Data

Business configuration should be stored separately from operational data.

Examples:

- Waste percentage
- Recipe definitions
- Product catalog
- Shift catalog
- Operator catalog

Configuration changes should not require software development.

---

# 10. Future Expansion

The model has been designed to support future entities without affecting existing production data.

Possible future entities include:

- Inventory
- Supplier
- Purchase Order
- Ingredient
- Cost Center
- Bonus
- Report
- Notification

---

# 11. Design Rules

The data model follows these rules:

- Avoid duplicated information.
- Store business facts.
- Calculate business indicators.
- Preserve historical data.
- Prefer relationships over duplicated fields.
- Keep entities independent whenever possible.