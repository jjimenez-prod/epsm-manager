# Business Questions

Project: EPSM Ecosystem

Primary Product: EPSM Manager OPS

Organization: È Pronto Si Mangia

Version: 2.0

Status: Active

Last Updated: July 2026

---

# 1. Purpose

This document defines the Business Questions that the EPSM ecosystem is expected to answer.

Business Questions represent the operational and managerial decisions that the platform supports.

Every Business Rule, Business Calculation, KPI and Dashboard should exist to answer one or more Business Questions.

If a feature does not contribute to answering a real business question, it should not be implemented.

Business Questions define the purpose of the platform.

---

# 2. Business Question Philosophy

Business Questions follow a common set of principles.

---

## 2.1 Business Driven

Every Business Question represents a real operational or managerial need.

Questions should originate from business requirements rather than software capabilities.

---

## 2.2 Decision Oriented

Every Business Question should support a business decision.

Questions that do not influence operational or managerial decisions should not become part of the platform.

---

## 2.3 Automatically Answered

Business Questions should be answered automatically using operational data.

Manual calculations should never be required.

---

## 2.4 Technology Independent

Business Questions remain valid regardless of:

- User Interface
- Database
- Dashboard
- Programming Language

Business Questions belong to the business.

---

## 2.5 Reusable

A single Business Question may be answered through multiple KPIs.

Likewise, one KPI may contribute to answering multiple Business Questions.

---

# 3. Business Question Lifecycle

Every Business Question follows the same reasoning process.

```text
Business Need

↓

Business Question

↓

Business Rule

↓

Business Calculation

↓

Business Indicator

↓

KPI

↓

Dashboard

↓

Business Decision
```

Business Questions initiate the analytical chain of the EPSM ecosystem.

---

# 4. Question Categories

Business Questions are grouped according to the type of business decision they support.

---

## Operational Questions

Questions related to daily production activities.

Examples:

- Production Overview
- Production Evolution

---

## Performance Questions

Questions comparing operational efficiency.

Examples:

- Operator Performance
- Recipe Performance
- Shift Performance

---

## Strategic Questions

Questions supporting continuous business improvement.

Examples:

- Improvement Opportunities
- Team Performance

---

## Predictive Questions

Reserved for future business capabilities.

Examples:

- Production Forecasting
- Capacity Planning
- Artificial Intelligence Recommendations

# 5. Operational Business Questions

Operational Business Questions provide visibility into the day-to-day execution of production.

They support production monitoring, operational control and short-term decision making.

---

# BQ-001 — Production Overview

## Business Question

How is production performing?

## Purpose

Provide management with a complete overview of production performance for a selected period.

## Stakeholders

- Owner
- Production Manager

## Typical Filters

- Today
- Yesterday
- This Week
- This Month
- Custom Period

## Expected KPIs

- Production Compliance
- Waste
- Waste Percentage
- Total Productions
- Production Trend

## Dependencies

- Business Rules
- Business Calculation Engine
- KPI Definitions

## Expected Business Decision

Determine whether production is operating within expected business parameters.

## Status

Approved.

---

# BQ-002 — Operator Performance

## Business Question

Which operators achieve the best production performance?

## Purpose

Identify operational excellence and opportunities for coaching or training.

## Stakeholders

- Owner
- Production Manager

## Typical Filters

- Date Range
- Operator
- Shift

## Expected KPIs

- Operator Performance
- Production Compliance
- Average Waste
- Historical Trend

## Dependencies

- Business Calculation Engine
- KPI Definitions

## Expected Business Decision

Identify high-performing operators and determine where operational improvements are required.

## Status

Approved.

---

# BQ-003 — Recipe Performance

## Business Question

Which recipes perform best?

## Purpose

Compare production efficiency across different recipes.

## Stakeholders

- Owner
- Production Manager

## Typical Filters

- Recipe
- Date Range

## Expected KPIs

- Recipe Performance
- Average Waste
- Compliance Rate
- Historical Trend

## Dependencies

- Business Calculation Engine
- KPI Definitions

## Expected Business Decision

Determine whether specific recipes require operational adjustments or optimization.

## Status

Approved.

# 6. Performance Business Questions

Performance Business Questions compare production efficiency across different operational dimensions.

These questions help identify operational strengths and opportunities for continuous improvement.

---

# BQ-004 — Shift Performance

## Business Question

Which production shifts perform best?

## Purpose

Compare operational performance across production shifts.

## Stakeholders

- Owner
- Production Manager

## Typical Filters

- Date Range
- Shift

## Expected KPIs

- Shift Performance
- Compliance Rate
- Average Waste

## Dependencies

- Business Calculation Engine
- KPI Definitions

## Expected Business Decision

Determine whether operational practices differ between shifts and identify opportunities for standardization.

## Status

Approved.

---

# BQ-005 — Production Evolution

## Business Question

How is production evolving over time?

## Purpose

Monitor long-term production behaviour and identify positive or negative operational trends.

## Stakeholders

- Owner
- Production Manager

## Typical Filters

- Week
- Month
- Quarter
- Year
- Custom Period

## Expected KPIs

- Production Trend
- Waste Trend
- Compliance Trend

## Dependencies

- Business Calculation Engine
- KPI Definitions

## Expected Business Decision

Determine whether production performance is improving, stable or deteriorating over time.

## Status

Approved.

---

# 7. Strategic Business Questions

Strategic Business Questions support continuous business improvement.

They focus on identifying priorities rather than monitoring daily operations.

---

# BQ-006 — Improvement Opportunities

## Business Question

Which products, recipes or operational areas represent the greatest opportunity for improvement?

## Purpose

Identify improvement initiatives capable of generating the highest operational impact.

## Stakeholders

- Owner
- Production Manager

## Typical Filters

- Product
- Recipe
- Date Range

## Expected Indicators

- High Waste
- High Variability
- Low Compliance
- Recurrent Operational Deviations

## Dependencies

- Business Calculation Engine
- KPI Definitions

## Expected Business Decision

Prioritize improvement initiatives based on measurable operational evidence.

## Status

Approved.

---

# BQ-007 — Team Performance

## Business Question

Which combinations of operators achieve the best production performance?

## Purpose

Evaluate production teams composed of multiple operators working together on the same Dough Batch.

## Stakeholders

- Owner
- Production Manager

## Typical Filters

- Team Composition
- Date Range
- Shift

## Expected KPIs

- Team Performance Score
- Team Compliance
- Average Waste
- Historical Performance

## Dependencies

- Business Calculation Engine
- KPI Definitions

## Expected Business Decision

Identify high-performing operator combinations and support future production planning.

## Notes

The current business model fully supports this analysis.

The feature is intentionally reserved for a future product version.

## Status

Future Ready.

# 8. Business Question Standards

Every Business Question implemented within the EPSM ecosystem should comply with the following standards.

---

## 8.1 Business Value

Every Business Question must represent a genuine business need.

Questions should never exist simply because the required data is available.

Business value always justifies implementation.

---

## 8.2 Decision Support

Every Business Question should support one or more operational or managerial decisions.

Questions that do not influence business decisions should not become part of the platform.

---

## 8.3 Technology Independence

Business Questions are independent from:

- Database implementation
- User Interface
- Dashboard design
- Programming language
- Software architecture

Business Questions belong to the business, not to the software.

---

## 8.4 Automatic Answers

Business Questions should be answered automatically using operational data.

Operators should never perform manual calculations to answer a Business Question.

---

## 8.5 Reusability

A single Business Question may be answered using multiple KPIs.

Likewise, a single KPI may contribute to multiple Business Questions.

Business information should be reused rather than duplicated.

---

## 8.6 Traceability

Every Business Question should be traceable.

The preferred information flow is:

Business Need

↓

Business Question

↓

Business Rule

↓

Business Calculation

↓

Business Indicator

↓

KPI

↓

Dashboard

↓

Business Decision

Every dashboard element should ultimately answer one or more Business Questions.

---

# 9. Future Evolution

The Business Question model has been intentionally designed to evolve together with the business.

Future Business Questions may include:

- Cost Optimization
- Inventory Efficiency
- Supplier Performance
- Demand Forecasting
- Production Capacity
- Artificial Intelligence Recommendations
- Predictive Operational Risks

New Business Questions should extend the existing model rather than replace current questions.

Business Questions should remain stable even when implementation evolves.

---

# 10. Lifecycle

Every Business Question follows one of the following lifecycle states.

---

## Approved

The Business Question has been validated by the business and is currently supported by the platform.

---

## Planned

The Business Question has been approved but its implementation has not yet started.

---

## Future Ready

The current architecture and business model already support the Business Question.

Its implementation has been intentionally postponed until there is a real business need.

---

## Deprecated

The Business Question is no longer relevant to the business.

Historical documentation is preserved for traceability.

Deprecated Business Questions are never deleted.

---

# 11. Final Statement

Business Questions define the purpose of the EPSM ecosystem.

They represent the information that the business needs in order to make better operational and managerial decisions.

Business Rules define how the business operates.

Business Calculations transform operational facts into measurable information.

KPIs summarize that information.

Dashboards present the KPIs.

Business Questions provide the reason why the entire analytical chain exists.

Every future module within the EPSM ecosystem should begin by identifying the Business Questions it intends to answer before introducing new KPIs, calculations or user interfaces.