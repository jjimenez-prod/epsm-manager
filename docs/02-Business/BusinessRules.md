# Business Rules

Project: EPSM Ecosystem

Primary Product: EPSM Manager OPS

Organization: È Pronto Si Mangia

Version: 2.0

Status: Approved

Last Updated: July 2026

---

# 1. Purpose

This document defines the operational business rules that govern the production process of È Pronto Si Mangia.

Its purpose is to describe how the business operates independently of any software implementation.

Business rules represent the operational reality of the organization.

Software is expected to implement these rules, not redefine them.

Whenever implementation and business rules conflict, business rules always take priority.

---

# 2. Business Philosophy

EPSM is designed around operational simplicity.

Operators are responsible for recording operational facts.

The platform is responsible for transforming those facts into reliable business information.

Business calculations are generated automatically.

Operational workflows should require the minimum amount of manual work while preserving complete traceability.

The objective is not simply to collect data.

The objective is to generate reliable operational knowledge capable of supporting future business decisions.

---

# 3. Business Entities

The production process is represented through a small number of business entities.

These entities define the operational language of the EPSM ecosystem.

Current business entities include:

- Dough Batch
- Recipe
- Product
- Production Item
- Operator
- Shift

Every business rule defined in this document applies to one or more of these entities.

Operational relationships between entities are described separately within the Data Model documentation.

---

# 4. Business Ownership

Operational responsibilities are clearly separated.

Operators are responsible for:

- Recording production events.
- Recording operational quantities.
- Recording observations when required.

The system is responsible for:

- Business calculations.
- KPI generation.
- Production evaluation.
- Production status.
- Historical consistency.
- Business reporting.

Manual business calculations are intentionally avoided.

Operational information is entered once and reused throughout the entire platform.
# 5. Production Model

Production is organized around Dough Batches.

A Dough Batch represents one complete dough preparation performed during a production shift.

Every production activity begins with the creation of a Dough Batch.

Every produced unit belongs to exactly one Dough Batch.

The Dough Batch is the primary operational entity of the production process.

---

# 6. Dough Batch

Each Dough Batch represents one production preparation.

A Dough Batch contains:

- Production date
- Shift
- Recipe
- Initial dough weight
- Operators
- Produced products
- Remaining dough
- Observations

A single Dough Batch may generate one or many different products.

All production information remains associated with its originating Dough Batch throughout its entire lifecycle.

---

# 7. Recipes

Recipes define the standard composition of a Dough Batch.

Recipe parameters are business configurations rather than software constants.

Business configuration may evolve without requiring software modifications.

---

## 7.1 Standard Recipes

Standard Recipes use predefined business parameters.

Operators are not required to manually enter recipe values.

The system automatically retrieves the corresponding configuration.

Business parameters include examples such as:

- Flour
- Water
- Dough weight

These parameters remain configurable.

---

## 7.2 Special Recipes

Special Recipes require manual operational input.

Operators provide the values defined by the business.

The system automatically calculates the resulting Dough Batch characteristics.

Manual input should be limited to operational facts only.

Derived values are always calculated by the platform.

---

# 8. Dough Weight

Every Dough Batch stores its actual initial dough weight.

The recorded weight represents the operational reality of that specific production.

Business reference values may change over time without affecting historical records.

Historical Dough Batch information must always preserve the values originally recorded.

---

# 9. Operators

One or more operators may participate in a Dough Batch.

Operators are selected from the business catalog.

Operators represent production participants.

They are not application users.

Operator information supports:

- Historical traceability
- Performance analysis
- Operational reporting
- Bonus eligibility

The number of participating operators is determined by the production process.

---

# 10. Production Registration

A Dough Batch may produce multiple products.

For every produced product the operator records:

- Product
- Quantity

Product characteristics such as grammage are obtained automatically from the product catalog.

Operators should never manually enter information already managed by the system.

Operational data should only be entered once.

---

# 11. Remaining Dough

A Dough Batch may generate remaining dough.

Whenever remaining dough exists, it must be recorded.

Operational information includes:

- Remaining weight
- Destination
- Optional observations

Remaining Dough becomes part of the permanent production history.

Future platform versions may manage Remaining Dough through dedicated inventory capabilities without changing the production workflow.

---

# 12. Shifts

Production is organized into operational shifts.

Current shifts include:

- Morning
- Afternoon
- Night

Every Dough Batch belongs to exactly one shift.

Shift definitions remain configurable and may evolve according to business needs.
# 13. Business Calculations

EPSM automatically transforms operational data into business information.

Operators never perform business calculations manually.

Operational facts are entered once and reused throughout the platform to generate business indicators.

Business calculations may evolve over time without modifying operational workflows.

---

## 13.1 Expected Production

Expected Production represents the theoretical production capacity of a Dough Batch.

The calculation is performed automatically by the platform.

Business inputs include:

- Initial dough weight
- Product target weight
- Business configuration

The result is expressed as the theoretical number of units that can be produced.

Operators never calculate this value manually.

Calculation methods may evolve while preserving historical consistency.

---

## 13.2 Production Tolerance

Expected Production always includes an acceptable operational tolerance.

Tolerance values are defined by business configuration.

Tolerance may vary according to product or future business requirements.

Typical tolerance parameters include:

- Target quantity
- Lower tolerance
- Upper tolerance

Tolerance evaluation is always performed automatically by the platform.

---

## 13.3 Production Status

Every production result receives a business status.

Possible statuses include:

- Below Expected
- Within Target
- Above Expected

Production Status is generated automatically using business rules.

Operators never evaluate production manually.

Production Status supports dashboards, KPIs and business reporting.

---

## 13.4 Waste

Waste represents the operational difference between expected production and actual production.

Waste is considered a business indicator rather than operational input.

Operators never record Waste manually.

Waste thresholds remain configurable.

Historical Waste calculations must remain reproducible.

---

## 13.5 Performance

Operator Performance is generated automatically using production information.

Performance calculations are based exclusively on operational data already recorded during production.

Operators never provide performance values manually.

Performance indicators support:

- Operational analysis
- Historical reporting
- Business dashboards
- Bonus eligibility

Performance calculation methods may evolve independently from the production workflow.

---

## 13.6 Bonus Eligibility

Bonus eligibility is determined automatically using business rules.

Operators never calculate bonus eligibility.

Eligibility criteria are configurable and may evolve over time.

Future business rules may incorporate additional operational indicators without modifying the production registration process.

---

# 14. KPI Philosophy

Operational information should be recorded only once.

Every KPI should be generated automatically from existing operational data.

The platform should never require additional manual input exclusively for reporting purposes.

A single production event should be capable of generating multiple business indicators.

Business reporting should always prioritize:

- Operational simplicity
- Data consistency
- Historical integrity
- Business value

Operational processes should never become more complex solely to satisfy analytical requirements.
# 15. Business Configuration

Business rules should be configurable whenever reasonably possible.

Operational parameters should be managed through business configuration instead of software modifications.

Typical configurable parameters include:

- Recipe parameters
- Standard dough weights
- Production tolerances
- Waste thresholds
- Performance thresholds
- Bonus eligibility rules

Configuration changes should preserve historical information.

Changes to business parameters must affect only future production unless explicitly defined otherwise.

---

# 16. Future Evolution

The production model has been intentionally designed to support future business capabilities.

Potential future extensions include:

- Dough Inventory Management
- Recipe Management
- Automatic Cost Analysis
- Advanced Bonus Calculation
- Predictive Production Planning
- Multi-Location Production
- Artificial Intelligence Assistance
- Advanced Business Intelligence

Future capabilities should extend the existing business model without modifying the operational workflow.

Operational simplicity should always remain the primary objective.

---

# 17. Business Rule Governance

Business Rules define how the business operates.

Software implementations must adapt to Business Rules.

Business Rules should never be modified simply to accommodate technical limitations.

Every significant modification to a Business Rule should:

- Be documented.
- Be reviewed.
- Be approved before implementation.
- Preserve historical consistency whenever possible.

Business Rules are considered long-term assets of the EPSM ecosystem.

---

# 18. Final Statement

Business Rules describe the operational reality of È Pronto Si Mangia.

User interfaces may evolve.

Software architecture may evolve.

Programming languages may change.

Infrastructure may change.

However, the business itself should remain consistently represented by these rules.

Every module within the EPSM ecosystem should implement these Business Rules consistently.

The objective of EPSM is not simply to automate production.

The objective is to faithfully represent the business, preserve operational knowledge and provide reliable information for future decision making.