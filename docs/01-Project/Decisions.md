# Architecture Decision Records (ADR)

**Project:** EPSM Manager

**Client:** È Pronto Si Mangia

**Version:** 1.0

**Status:** Approved

**Last Update:** 2026-07-02

---

# Purpose

This document records all significant architectural and strategic decisions made during the lifecycle of EPSM Manager.

Each decision explains:

- Context
- Decision
- Rationale
- Consequences

The objective is to preserve the reasoning behind the project architecture and avoid losing business knowledge over time.

---

# ADR-001 — Cloud First

## Status

Accepted

## Context

The system must be accessible from anywhere without depending on a local computer.

## Decision

EPSM Manager will be a cloud-first platform.

## Consequences

- No local installation required.
- Easier maintenance.
- Easier deployment.
- Better availability.

---

# ADR-002 — GitHub Pages as Frontend Hosting

## Status

Accepted

## Context

A zero-cost hosting platform was required.

## Decision

GitHub Pages will host the web application.

## Rationale

- Free.
- HTTPS included.
- Easy deployment.
- Version controlled.

## Consequences

The frontend must remain a static web application.

---

# ADR-003 — Supabase as Backend Platform

## Status

Accepted

## Context

A cloud database with authentication and API support was required.

## Decision

Supabase becomes the backend platform.

## Rationale

- PostgreSQL.
- Authentication included.
- REST API.
- Row Level Security.
- Free tier suitable for the project.

## Consequences

Supabase becomes the Single Source of Truth.

---

# ADR-004 — Excel as Transitional Analytics Layer

## Status

Accepted

## Context

The business currently depends on Excel formulas.

## Decision

Excel will initially remain as the analytics platform.

## Consequences

Excel is no longer responsible for data entry.

Its long-term role is temporary.

---

# ADR-005 — Dough Batch as Primary Business Entity

## Status

Accepted

## Context

Production revolves around dough preparation rather than individual products.

## Decision

The Dough Batch becomes the primary business entity.

## Consequences

Every production record belongs to one Dough Batch.

---

# ADR-006 — Business Before Technology

## Status

Accepted

## Context

Software should represent the business process.

## Decision

Business rules always take priority over implementation details.

---

# ADR-007 — Zero Operational Cost

## Status

Accepted

## Context

The project must remain financially sustainable.

## Decision

Every architectural decision should preserve zero monthly operational cost whenever technically possible.

---

# ADR-008 — Documentation First

## Status

Accepted

## Context

Long-term maintainability requires documented knowledge.

## Decision

Important business and architectural decisions must be documented before implementation.

---

# ADR-009 — Modular Architecture

## Status

Accepted

## Context

Future business growth is expected.

## Decision

The platform will evolve through independent modules.

Examples:

- Production
- Dashboard
- Inventory
- Recipes
- Reports

---

# ADR-010 — Single Source of Truth

## Status

Accepted

## Context

Business data should never be duplicated.

## Decision

Supabase is the only operational database.

Excel and future dashboards consume data but never become the source of truth.

---

# ADR-011 — Operators Are Business Entities

## Status

Accepted

## Context

Operators participate in production but do not require individual application accounts.

## Decision

Operators remain independent from authentication users.

Authentication exists for system access.

Operators exist for business traceability.

---

# ADR-012 — Shared Production Session

## Status

Accepted

## Context

Multiple operators collaborate during production.

## Decision

Production will use a shared technical account.

The production form records the operators participating in each Dough Batch.

## Consequences

Simpler workflow.

Business traceability remains preserved.

---

# ADR-013 — Progressive Replacement of Excel

## Status

Accepted

## Context

The long-term objective is a fully web-based platform.

## Decision

Excel will gradually be replaced by web dashboards.

No business logic should become permanently dependent on Excel.

---

# ADR-014 — Business Facts vs Calculated Values

## Status

Accepted

## Context

Historical calculations may change over time.

## Decision

Operational facts are stored.

Business indicators are calculated.

## Examples

Stored:

- Quantity
- Dough Weight
- Flour
- Water

Calculated:

- Waste
- Expected Production
- Performance
- Bonus

---

# ADR-015 — Future Ready

## Status

Accepted

## Context

Future modules are already expected.

## Decision

Current architecture must support future expansion without redesign.

Examples:

- Inventory
- AI
- Mobile
- Cost Analysis
- Notifications

---