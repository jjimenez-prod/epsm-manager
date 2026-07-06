# Traceability Matrix

**Project:** EPSM Manager

**Version:** 1.0

**Status:** Draft

**Last Update:** 2026-07-05

---

# 1. Purpose

This document establishes complete traceability across the EPSM Manager business model.

Every Business Question must be supported by Business Rules, Business Calculations and KPIs.

This matrix guarantees that every implemented feature provides measurable business value.

---

# 2. Traceability Matrix

| Business Question | Business Rules | Calculations | KPIs |
|-------------------|----------------|--------------|------|
| BQ-001 Production Overview | BR-001, BR-004 | PROD-001, PROD-002, PROD-003, PROD-004, WASTE-001, WASTE-002, WASTE-003, WASTE-004 | PROD-KPI-001, WASTE-KPI-001, WASTE-KPI-002 |
| BQ-002 Operator Performance | BR-003 | PERF-001 | PERF-KPI-001 |
| BQ-003 Recipe Performance | BR-002 | PERF-002 | PERF-KPI-002 |
| BQ-004 Shift Performance | BR-003 | PERF-003 | PERF-KPI-003 |
| BQ-005 Production Evolution | BR-001 | TREND-001 | TREND-KPI-001 |
| BQ-006 Improvement Opportunities | Multiple | INSIGHT-001 | INSIGHT-KPI-001 |
| BQ-007 Team Performance | BR-003 | TEAM-001 | TEAM-KPI-001 |

---

# 3. Validation Rules

Every Business Question must reference at least one KPI.

Every KPI must reference at least one Business Calculation.

Every Business Calculation must implement one or more Business Rules.

Business Rules originate from documented operational processes.

---

# 4. Design Principles

Traceability must always flow in one direction.

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

Implementation details must never break this relationship.