# Business Calculation Engine

Project: EPSM Ecosystem

Primary Product: EPSM Manager OPS

Organization: È Pronto Si Mangia

Version: 2.0

Status: Active

Last Updated: July 2026

---

# 1. Purpose

This document defines the Business Calculation Engine of the EPSM ecosystem.

Its purpose is to describe how operational production data is transformed into reusable business information.

Business calculations represent the bridge between operational events and business intelligence.

Every KPI, dashboard indicator and analytical report originates from one or more business calculations.

Business calculations are independent from user interfaces.

They may be reused by multiple modules across the EPSM ecosystem.

---

# 2. Business Calculation Philosophy

Every calculation follows a common set of principles.

---

## 2.1 Single Responsibility

Every calculation performs exactly one business calculation.

Complex business indicators should be composed from multiple simple calculations.

---

## 2.2 Reusability

Business calculations should be reusable.

The same calculation may support:

- Dashboards
- KPIs
- Reports
- Historical Analysis
- Future Modules

Calculations should never exist exclusively for one screen.

---

## 2.3 Business Independence

Calculations never depend on frontend implementation.

Dashboards consume calculations.

Calculations never consume dashboards.

---

## 2.4 Deterministic Behaviour

Every calculation must produce the same result when executed using the same operational data.

Business calculations should always be reproducible.

---

## 2.5 Historical Consistency

Historical operational data should never lose meaning.

Calculation methods may evolve.

Operational facts remain immutable.

Whenever required, historical calculations should remain reproducible.

---

# 3. Business Calculation Pipeline

Business information is generated through a structured calculation pipeline.

```text
Business Question

↓

Business Rule

↓

Operational Facts

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

Every business calculation exists to answer a real business question.

If a calculation does not generate business value, it should not exist.

---

# 4. Calculation Categories

Business calculations are organized into independent categories.

---

## Core Calculations

Fundamental calculations required by the production process.

Examples:

- Theoretical Production
- Production Difference
- Production Status

---

## Operational Calculations

Calculations describing production execution.

Examples:

- Effective Dough
- Produced Weight
- Waste
- Waste Percentage

---

## Performance Calculations

Calculations used to evaluate operational performance.

Examples:

- Operator Performance
- Recipe Performance
- Shift Performance

---

## Analytical Calculations

Calculations supporting historical analysis and business intelligence.

Examples:

- Production Trends
- Historical Comparisons
- Production Insights

---

## Future Calculations

Calculations reserved for future business capabilities.

Examples include:

- Predictive Production
- Artificial Intelligence
- Forecasting
- Optimization
# 5. Core Calculations

Core Calculations represent the fundamental business calculations of the production process.

These calculations transform operational production data into reusable business information.

Most operational KPIs depend directly or indirectly on these calculations.

---

# PROD-001 — Theoretical Production

## Purpose

Calculate the theoretical number of units that can be produced from the available dough according to business rules.

## Inputs

- Initial Dough Weight
- Product Target Weight

## Outputs

- Theoretical Units

## Dependencies

None.

## Used By

- Production Difference
- Production Status
- Operator Performance
- Dashboard KPIs

## Execution Frequency

Every Dough Batch.

## Historical Impact

None.

The calculation is deterministic.

## Reusable

Yes.

This calculation may be consumed by any current or future module.

## Status

Approved.

---

# PROD-002 — Production Difference

## Purpose

Calculate the numerical difference between theoretical production and actual production.

## Inputs

- Theoretical Units
- Produced Units

## Outputs

- Production Difference

## Dependencies

- PROD-001

## Used By

- Production Status
- Performance
- Historical Analysis

## Execution Frequency

Every Dough Batch.

## Historical Impact

None.

## Reusable

Yes.

## Status

Approved.

---

# PROD-003 — Production Range

## Purpose

Determine the acceptable operational interval according to business tolerance rules.

## Inputs

- Theoretical Units
- Production Tolerance

## Outputs

- Minimum Units
- Maximum Units

## Dependencies

- PROD-001

## Used By

- Production Status

## Execution Frequency

Every Dough Batch.

## Historical Impact

Business tolerance may evolve.

Historical calculations should remain reproducible.

## Reusable

Yes.

## Status

Pending Validation.

---

# PROD-004 — Production Status

## Purpose

Determine whether production falls below, inside or above the acceptable operational range.

## Inputs

- Produced Units
- Minimum Units
- Maximum Units

## Outputs

- Below Target
- Within Target
- Above Target

## Dependencies

- PROD-002
- PROD-003

## Used By

- Operator Performance
- Recipe Performance
- Shift Performance
- Dashboards
- KPIs

## Execution Frequency

Every Dough Batch.

## Historical Impact

None.

## Reusable

Yes.

## Status

Approved.

# 6. Operational Calculations

Operational Calculations describe how raw production data is transformed into measurable operational indicators.

These calculations evaluate dough utilization, production efficiency and resource consumption.

---

# WASTE-001 — Effective Dough

## Purpose

Calculate the amount of dough effectively available for production after removing the remaining dough.

## Inputs

- Initial Dough Weight
- Remaining Dough

## Outputs

- Effective Dough

## Dependencies

None.

## Used By

- Waste Calculation
- Dough Utilization
- KPI Dashboard

## Execution Frequency

Every Dough Batch.

## Historical Impact

None.

## Reusable

Yes.

## Status

Approved.

---

# WASTE-002 — Produced Weight

## Purpose

Calculate the total dough weight represented by all produced items.

## Inputs

- Product Weight
- Produced Units

## Outputs

- Produced Weight

## Dependencies

None.

## Used By

- Waste Calculation
- Dough Utilization
- Production Reports

## Execution Frequency

Every Dough Batch.

## Historical Impact

None.

## Reusable

Yes.

## Status

Approved.

---

# WASTE-003 — Waste

## Purpose

Calculate the amount of dough lost during production.

## Inputs

- Effective Dough
- Produced Weight

## Outputs

- Waste (g)

## Dependencies

- WASTE-001
- WASTE-002

## Used By

- Waste Percentage
- Waste Dashboard
- Production KPIs
- Historical Analysis

## Execution Frequency

Every Dough Batch.

## Historical Impact

None.

## Reusable

Yes.

## Status

Approved.

---

# WASTE-004 — Waste Percentage

## Purpose

Calculate waste as a percentage of the initial dough weight.

## Inputs

- Waste
- Initial Dough Weight

## Outputs

- Waste Percentage

## Dependencies

- WASTE-003

## Used By

- Executive Dashboard
- Historical Analysis
- Production Comparison
- KPI Dashboard

## Execution Frequency

Every Dough Batch.

## Historical Impact

None.

## Reusable

Yes.

## Status

Approved.

# 7. Performance Calculations

Performance Calculations evaluate operational efficiency using previously generated business calculations.

These calculations are intended to compare performance across different operational dimensions.

Performance calculations never consume raw operational data directly.

They consume validated business calculations.

---

# PERF-001 — Operator Performance

## Purpose

Evaluate the operational performance of each production operator.

## Inputs

- Production Status
- Production Difference
- Waste Percentage

## Outputs

- Operator Performance Score

## Dependencies

- PROD-004
- WASTE-004

## Used By

- Performance Dashboard
- Bonus Eligibility
- Historical Analysis

## Execution Frequency

Every Dough Batch.

## Historical Impact

Performance methodology may evolve.

Historical operational facts remain unchanged.

## Reusable

Yes.

## Status

Planned.

---

# PERF-002 — Recipe Performance

## Purpose

Evaluate how efficiently each recipe performs over time.

## Inputs

- Production Status
- Waste Percentage
- Historical Production

## Outputs

- Recipe Performance Score

## Dependencies

- PROD-004
- WASTE-004

## Used By

- Recipe Dashboard
- Historical Analysis
- Business Reporting

## Execution Frequency

Every Dough Batch.

## Historical Impact

Historical production remains unchanged.

Only evaluation methods may evolve.

## Reusable

Yes.

## Status

Planned.

---

# PERF-003 — Shift Performance

## Purpose

Compare production efficiency between operational shifts.

## Inputs

- Operator Performance
- Waste Percentage
- Production Status

## Outputs

- Shift Performance Score

## Dependencies

- PERF-001
- WASTE-004
- PROD-004

## Used By

- Executive Dashboard
- Historical Analysis

## Execution Frequency

Every Production Day.

## Historical Impact

None.

## Reusable

Yes.

## Status

Planned.

---

# 8. Analytical Calculations

Analytical Calculations transform historical operational information into business knowledge.

Unlike operational calculations, analytical calculations typically aggregate multiple production events.

---

# TREND-001 — Production Trend

## Purpose

Identify production evolution over time.

## Inputs

- Historical Production

## Outputs

- Production Trend

## Dependencies

- Historical Production Records

## Used By

- Executive Dashboard
- Historical Analysis

## Execution Frequency

On Demand.

## Historical Impact

None.

## Reusable

Yes.

## Status

Planned.

---

# TREND-002 — Waste Trend

## Purpose

Evaluate waste evolution across time.

## Inputs

- Historical Waste Percentage

## Outputs

- Waste Trend

## Dependencies

- WASTE-004

## Used By

- Executive Dashboard
- Historical Analysis

## Execution Frequency

On Demand.

## Historical Impact

None.

## Reusable

Yes.

## Status

Planned.

---

# TREND-003 — Performance Trend

## Purpose

Evaluate operational performance evolution.

## Inputs

- Historical Performance Scores

## Outputs

- Performance Trend

## Dependencies

- PERF-001
- PERF-002
- PERF-003

## Used By

- Executive Dashboard
- Historical Reports

## Execution Frequency

On Demand.

## Historical Impact

None.

## Reusable

Yes.

## Status

Planned.

---

# 9. Business Insight Calculations

Business Insight Calculations identify opportunities for operational improvement.

Unlike previous calculations, Insights are intended to support business decision making rather than operational reporting.

---

# INSIGHT-001 — Improvement Opportunity Score

## Purpose

Identify operational areas with the highest improvement potential.

## Inputs

- Production Indicators
- Performance Indicators
- Waste Indicators
- Historical Trends

## Outputs

- Improvement Priority

## Dependencies

- PERF-001
- PERF-002
- PERF-003
- TREND-001
- TREND-002
- TREND-003

## Used By

- Executive Dashboard
- Operational Intelligence
- Future AI Modules

## Execution Frequency

On Demand.

## Historical Impact

None.

## Reusable

Yes.

## Status

Planned.

# 10. Calculation Standards

Every Business Calculation implemented within the EPSM ecosystem should comply with the following standards.

---

## 10.1 Business Driven

Every calculation must answer a real business question.

Calculations should never exist solely because they are technically possible.

Business value always justifies implementation.

---

## 10.2 Reusable

Calculations should be reusable across multiple modules.

A calculation should never be designed exclusively for one dashboard or one report.

The same business calculation may support:

- Dashboards
- KPIs
- Reports
- Historical Analysis
- Artificial Intelligence
- Future Business Modules

---

## 10.3 Deterministic

Business calculations must always produce the same output when executed using the same operational data.

Random or non-repeatable calculations are not acceptable.

---

## 10.4 Traceable

Every calculation should be traceable back to its originating operational facts.

Business indicators should always be explainable.

Every KPI must be reproducible.

---

## 10.5 Composable

Complex business indicators should be built using existing calculations whenever possible.

Existing calculations should be reused instead of duplicated.

The preferred strategy is:

Operational Facts

↓

Core Calculation

↓

Operational Calculation

↓

Performance Calculation

↓

Business Insight

---

## 10.6 Independent

Business calculations should remain independent from:

- User Interface
- Dashboard Layout
- Frontend Framework
- Presentation Components

Calculations belong to the business layer.

Presentation belongs to the frontend.

---

# 11. Future Evolution

The Business Calculation Engine is intentionally designed to grow over time.

Future versions of EPSM may introduce additional calculation families, including:

- Cost Calculations
- Inventory Calculations
- Forecast Calculations
- Artificial Intelligence Scores
- Optimization Algorithms
- Predictive Business Models

Future calculations should follow the same standards defined in this document.

Existing calculations should evolve through extension rather than replacement.

---

# 12. Final Statement

The Business Calculation Engine represents the mathematical model of the EPSM ecosystem.

Operational events become business facts.

Business facts become calculations.

Calculations become indicators.

Indicators become KPIs.

KPIs become dashboards.

Dashboards support business decisions.

The objective of the Business Calculation Engine is not simply to perform calculations.

Its objective is to transform operational information into reliable business knowledge while preserving consistency, traceability and long-term maintainability.

Every future module within the EPSM ecosystem should consume this calculation engine instead of implementing independent business calculations.
