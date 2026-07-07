# Business Questions

**Project:** EPSM Manager

**Version:** 1.0

**Status:** Draft

**Last Update:** 2026-07-05

---

# 1. Purpose

This document defines the business questions that EPSM Manager must answer.

Business Questions represent the operational and managerial decisions that the platform is expected to support.

Every dashboard, KPI and business calculation must exist to answer at least one Business Question.

If a feature does not answer a real business question, it should not be implemented.

---

# 2. Business Question Philosophy

EPSM Manager follows five principles.

1. Business Questions represent real operational needs.

2. Every Business Question must support a business decision.

3. Questions should be answered automatically using operational data.

4. Questions must remain independent from software implementation.

5. Multiple KPIs may contribute to answering the same Business Question.

---

# BQ-001

## Name

Production Overview

## Business Question

How is production performing?

## Purpose

Provide management with a complete overview of production performance for a selected period.

## Typical Filters

- Today
- Yesterday
- This Week
- This Month
- Custom Period

## Typical KPIs

- Production Compliance
- Waste
- Waste Percentage
- Total Productions
- Production Trend

## Status

Approved

---

# BQ-002

## Name

Operator Performance

## Business Question

Which operators achieve the best production performance?

## Purpose

Identify operational excellence and training opportunities.

## Typical KPIs

- Operator Performance
- Production Compliance
- Average Waste
- Historical Trend

## Status

Approved

---

# BQ-003

## Name

Recipe Performance

## Business Question

Which recipes perform best?

## Purpose

Compare production efficiency across recipes.

## Typical KPIs

- Recipe Performance
- Average Waste
- Compliance Rate
- Historical Trend

## Status

Approved

---

# BQ-004

## Name

Shift Performance

## Business Question

Which production shifts perform best?

## Purpose

Compare operational performance across production shifts.

## Typical KPIs

- Shift Performance
- Compliance Rate
- Average Waste

## Status

Approved

---

# BQ-005

## Name

Production Evolution

## Business Question

How is production evolving over time?

## Purpose

Monitor long-term production behavior and identify positive or negative trends.

## Typical KPIs

- Production Trend
- Waste Trend
- Compliance Trend

## Status

Approved

---

# BQ-006

## Name

Improvement Opportunities

## Business Question

Which products represent the greatest opportunity for improvement?

## Purpose

Identify products, recipes or operational areas where improvement initiatives will generate the highest business impact.

## Typical Indicators

- High Waste
- High Variability
- Low Compliance
- Recurrent Operational Deviations

## Expected Outcome

Prioritized improvement opportunities.

## Status

Approved

---

# BQ-007

## Name

Team Performance

## Business Question

Which operator combinations achieve the best production performance?

## Purpose

Evaluate production teams composed of multiple operators working on the same dough batch.

## Notes

The current data model fully supports this analysis.

The feature is intentionally reserved for a future product version.

## Status

Future Ready

---

# 3. Traceability

Every Business Question should be traceable.

Business Question

↓

Business Rules

↓

Business Calculations

↓

KPIs

↓

Dashboard

↓

Business Decision

Business Questions should never depend on implementation details.

---

# 4. Design Principles

Business Questions should always:

- Represent a real business need.
- Support operational or managerial decisions.
- Be answered using automatically generated KPIs.
- Remain stable over time.

Business Questions should never:

- Exist without business value.
- Duplicate another Business Question.
- Depend on software implementation.
- Require manual calculations.

---

# 5. Lifecycle

Business Questions follow the lifecycle below.

## Approved

Business Question validated and accepted.

## Planned

Business Question approved but awaiting implementation.

## Future Ready

Supported by the current business model and architecture but intentionally hidden until required by the business.