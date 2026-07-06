# Business Calculation Engine

**Project:** EPSM Manager

**Version:** 1.0

**Status:** Draft

**Last Update:** 2026-07-05

---

# 1. Purpose

This document defines every business calculation performed by EPSM Manager.

Business calculations transform operational production data into reusable business information.

Business calculations never interact directly with the user interface.

Every KPI is generated from one or more business calculations.

---

# 2. Calculation Philosophy

Business calculations follow five principles.

1. Every calculation has a single responsibility.

2. Every calculation produces reusable outputs.

3. Calculations never depend on dashboard implementation.

4. Business rules are documented before implementation.

5. Calculations must be deterministic and reproducible.

---

# 3. Calculation Categories

## Production

Calculations related to production execution.

## Waste

Calculations related to dough utilization.

## Performance

Calculations related to operational comparisons.

## Trends

Historical calculations.

## Insights

Business intelligence calculations.

---

# PROD-001

## Name

Theoretical Production

## Purpose

Calculate the theoretical production for a product using business operational rules.

## Inputs

- Initial Dough Weight
- Product Target Weight

## Output

- Theoretical Units

## Used By

- Production Compliance

## Status

Approved

# PROD-002

## Name

Production Difference

## Purpose

Calculate the difference between theoretical production and actual production.

## Inputs

- Theoretical Units
- Produced Units

## Output

- Difference

## Used By

- Production Compliance

## Status

Approved

# PROD-003

## Name

Production Range

## Purpose

Determine the acceptable production interval.

## Inputs

- Theoretical Units
- Production Tolerance

## Outputs

- Minimum Units
- Maximum Units

## Used By

- Production Compliance

## Status

Pending Validation

# PROD-004

## Name

Production Status

## Purpose

Determine whether production falls inside the acceptable operational range.

## Inputs

- Produced Units
- Minimum Units
- Maximum Units

## Outputs

- Below Target
- Within Target
- Above Target

## Used By

- Production Compliance
- Operator Performance
- Recipe Performance
- Shift Performance

## Status

Approved

# WASTE-001

## Name

Effective Dough

## Purpose

Calculate the amount of dough effectively available after production.

## Inputs

- Initial Dough Weight
- Remaining Dough

## Output

- Effective Dough

## Used By

- Waste

## Status

Approved

# WASTE-002

## Name

Produced Weight

## Purpose

Calculate the total weight represented by every produced item.

## Inputs

- Product Weight
- Produced Units

## Output

- Produced Weight

## Used By

- Waste

## Status

Approved

# WASTE-003

## Name

Waste

## Purpose

Calculate dough losses after production.

## Inputs

- Effective Dough
- Produced Weight

## Output

- Waste (g)

## Used By

- Waste

## Status

Approved

# WASTE-004

## Name

Waste Percentage

## Purpose

Calculate waste relative to the initial dough weight.

## Inputs

- Waste
- Initial Dough Weight

## Output

- Waste %

## Used By

- Waste Percentage

## Status

Approved

# PERF-001

Operator Performance

# PERF-002

Recipe Performance

# PERF-003

Shift Performance

# TREND-001

Production Trend

# INSIGHT-001

## Name

Improvement Opportunity Score

## Purpose

Identify operational areas with the highest improvement potential.

## Inputs

Multiple production indicators.

## Outputs

Priority Level

## Used By

Improvement Opportunities

## Status

Planned

# Traceability

Business Question

↓

Business Rule

↓

Business Calculation

↓

KPI

↓

Dashboard

↓

Business Decision