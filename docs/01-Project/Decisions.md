# Architectural Decision Records (ADR)

Project: EPSM Ecosystem

Primary Product: EPSM Manager OPS

Organization: È Pronto Si Mangia

Version: 2.0

Status: Active

Last Updated: July 2026

---

# 1. Purpose

This document records the significant architectural and strategic decisions made throughout the evolution of the EPSM ecosystem.

Its purpose is to preserve the reasoning behind architectural decisions so that future development can understand not only *what* was decided, but also *why* the decision was made.

Architecture evolves over time.

Business requirements evolve over time.

Technologies evolve over time.

The historical reasoning behind important decisions should never be lost.

---

# 2. ADR Philosophy

Each Architectural Decision Record (ADR) documents one important decision.

Every ADR should answer the following questions:

- What problem existed?
- Why was a decision required?
- Which solution was selected?
- Why was that solution preferred?
- What consequences does it have?
- Does it replace a previous decision?

An ADR documents architectural knowledge rather than implementation details.

---

# 3. ADR Lifecycle

Every ADR may have one of the following states:

- Draft
- Accepted
- Superseded
- Deprecated

Accepted ADRs remain valid until explicitly replaced.

Historical ADRs are never deleted.

If an architectural decision changes, a new ADR supersedes the previous one.

---

# 4. ADR Template

Every new Architectural Decision Record should follow the structure below.

---

## ADR-XXX — Decision Title

Status

Accepted

Decision Date

YYYY-MM-DD

Supersedes

None

Context

Describe the problem or business situation.

Decision

Describe the adopted solution.

Rationale

Explain why this solution was selected.

Consequences

Describe the expected architectural consequences.

Related Principles

Reference the corresponding principles when applicable.

Related Documents

Reference Architecture, Business Rules or other documentation when appropriate.

# 5. Platform Decisions

The following Architectural Decision Records define the technological foundation of the EPSM ecosystem.

These decisions establish the platform on which all future modules are built.

---

# ADR-001 — Cloud First

Status

Accepted

Decision Date

2026-07-02

Supersedes

None

## Context

The production system must be accessible from any location without depending on a specific computer or local network.

The platform should support remote access, centralized maintenance and future scalability.

## Decision

EPSM will adopt a Cloud First architecture.

Operational information will always be stored in cloud infrastructure.

## Rationale

Cloud infrastructure provides:

- Centralized access.
- Automatic availability.
- Simplified maintenance.
- Easier scalability.
- Lower operational overhead.

## Consequences

- No local installation required.
- Production data becomes immediately centralized.
- Future modules can share the same infrastructure.

Related Principles

- Business First
- Future Proof
- Cost Zero First

---

# ADR-002 — GitHub Pages as Frontend Hosting

Status

Accepted

Decision Date

2026-07-02

Supersedes

None

## Context

The project required a reliable static hosting platform with zero recurring operational cost.

## Decision

GitHub Pages will host the frontend applications of the EPSM ecosystem.

## Rationale

GitHub Pages provides:

- Zero operational cost.
- HTTPS by default.
- Native Git integration.
- Version-controlled deployments.
- High availability.

## Consequences

- Frontend applications remain static.
- Backend services are completely separated.
- Deployment is fully integrated with GitHub.

Related Principles

- Cost Zero First
- Modular Architecture

---

# ADR-003 — Supabase as Backend Platform

Status

Accepted

Decision Date

2026-07-02

Supersedes

None

## Context

The project required a managed PostgreSQL platform capable of providing authentication, APIs and business logic while remaining compatible with a zero-cost deployment strategy.

## Decision

Supabase becomes the backend platform for the EPSM ecosystem.

## Rationale

Supabase provides:

- PostgreSQL.
- Authentication.
- PostgreSQL RPC.
- REST API.
- Row Level Security.
- Managed infrastructure.
- Generous Free Tier.

## Consequences

- PostgreSQL becomes the operational database.
- Business capabilities are exposed through RPCs.
- Operational information is centralized.

Related Principles

- Database First
- Single Source of Truth
- Future Proof

---

# ADR-004 — Excel as Transitional Analytics Layer

Status

Accepted

Decision Date

2026-07-02

Supersedes

None

## Context

The business initially depended on Excel for reporting and operational analysis.

A gradual migration strategy was preferred over immediate replacement.

## Decision

Excel would temporarily remain the analytics platform while production management migrated to the web application.

## Rationale

This approach minimizes operational disruption while allowing gradual adoption of the new platform.

## Consequences

- Excel is no longer responsible for operational data entry.
- Excel becomes a temporary reporting consumer.
- Future analytical capabilities will progressively replace Excel.

Related Principles

- Business First
- Incremental Development
- Long-Term Thinking

---

# ADR-005 — Zero Operational Cost

Status

Accepted

Decision Date

2026-07-02

Supersedes

None

## Context

The project must remain economically sustainable during its early stages.

## Decision

Architectural decisions should preserve zero recurring operational cost whenever technically possible.

## Rationale

Reducing infrastructure costs lowers project risk and facilitates continuous development.

## Consequences

- Free-tier services are preferred.
- Paid services require explicit business justification.
- Infrastructure choices prioritize long-term sustainability.

Related Principles

- Cost Zero First

---

# ADR-006 — Documentation First

Status

Accepted

Decision Date

2026-07-02

Supersedes

None

## Context

Long-term maintainability requires preserving architectural and business knowledge.

## Decision

Important architectural and business decisions must be documented before implementation.

## Rationale

Documentation reduces knowledge loss, improves onboarding and supports long-term project evolution.

## Consequences

- Documentation becomes part of the product.
- Architectural knowledge remains preserved.
- Future modules inherit documented decisions.

Related Principles

- Documentation First
- Quality over Speed

# 6. Core Architecture Decisions

The following Architectural Decision Records define the fundamental architectural principles of the EPSM ecosystem.

These decisions establish how software is designed, how business logic is implemented and how future modules should evolve.

---

# ADR-007 — Business Before Technology

Status

Accepted

Decision Date

2026-07-02

Supersedes

None

## Context

Software exists to support business operations.

Technical limitations should never redefine business processes.

## Decision

Business requirements always take priority over technology choices.

Software implementation must adapt to the business rather than forcing the business to adapt to the software.

## Rationale

A business-oriented architecture remains valid even when technologies evolve.

This approach minimizes long-term technical debt and preserves operational consistency.

## Consequences

- Business Rules become technology independent.
- Architecture follows business capabilities.
- Future technologies can be adopted without redesigning the business model.

Related Principles

- Business First
- Future Proof

---

# ADR-008 — Single Source of Truth

Status

Accepted

Decision Date

2026-07-02

Supersedes

None

## Context

Duplicated business information creates inconsistencies and increases maintenance complexity.

## Decision

PostgreSQL becomes the only operational source of truth.

Every operational module consumes the same information.

## Rationale

Maintaining a single authoritative data source guarantees consistency and simplifies long-term evolution.

## Consequences

- Operational data exists only once.
- External tools consume data but never become authoritative.
- Historical integrity remains preserved.

Related Principles

- Database as Single Source of Truth
- Database First

---

# ADR-009 — Database First

Status

Accepted

Decision Date

2026-07-20

Supersedes

None

## Context

Business logic distributed across multiple frontend applications creates duplication, inconsistencies and maintenance difficulties.

## Decision

Business rules should be implemented as close as possible to PostgreSQL.

Frontend applications consume business capabilities rather than implementing business logic.

## Rationale

Centralizing business logic improves consistency, reduces duplication and allows multiple applications to share the same behaviour.

## Consequences

- PostgreSQL becomes the business engine.
- Business rules remain centralized.
- Future applications automatically inherit existing business capabilities.

Related Principles

- Database First
- Thin Frontend
- Single Source of Truth

---

# ADR-010 — Thin Frontend

Status

Accepted

Decision Date

2026-07-20

Supersedes

None

## Context

Frontend applications should remain simple, maintainable and independent from business implementation details.

## Decision

Frontend applications are responsible only for presentation, workflow orchestration and user interaction.

Business calculations remain outside the frontend whenever reasonably possible.

## Rationale

A lightweight frontend reduces maintenance complexity and allows multiple clients to reuse the same backend capabilities.

## Consequences

- Business logic is not duplicated.
- Frontend applications remain easier to maintain.
- Multiple interfaces can consume the same backend services.

Related Principles

- Thin Frontend
- Readability First
- Future Proof

---

# ADR-011 — Modular Architecture

Status

Accepted

Decision Date

2026-07-02

Supersedes

None

## Context

The business is expected to evolve through additional operational capabilities.

## Decision

The platform evolves by introducing independent modules rather than expanding a monolithic application.

Current and planned modules include:

- Operations
- Analytics
- Inventory
- Recipe Management
- Cost Analysis

## Rationale

Independent modules simplify maintenance, improve scalability and reduce coupling.

## Consequences

- Each module owns a well-defined responsibility.
- Modules evolve independently.
- New capabilities extend the ecosystem without redesigning existing modules.

Related Principles

- Modular Architecture
- Future Proof

---

# ADR-012 — Future Proof Architecture

Status

Accepted

Decision Date

2026-07-20

Supersedes

None

## Context

Business requirements will continue evolving over time.

Frequent architectural redesign introduces unnecessary risk.

## Decision

The architecture should evolve primarily through extension rather than replacement.

## Rationale

Stable foundations reduce maintenance costs and preserve long-term consistency.

## Consequences

- Existing modules remain stable.
- New requirements extend current capabilities.
- Architectural rewrites become exceptional events.

Related Principles

- Future Proof
- Long-Term Thinking

# 7. Business Model Decisions

The following Architectural Decision Records define how the production business is represented within the EPSM ecosystem.

These decisions establish the business language shared by every current and future module.

---

# ADR-013 — Dough Batch as Primary Business Entity

Status

Accepted

Decision Date

2026-07-02

Supersedes

None

## Context

Production is organized around dough preparation rather than around individual products.

A single dough preparation may generate multiple products.

## Decision

The Dough Batch becomes the primary business entity of the production process.

Every production record belongs to exactly one Dough Batch.

## Rationale

Modeling production around Dough Batches better represents the real operational workflow.

It also preserves complete production traceability.

## Consequences

- Production becomes batch-oriented.
- Products inherit the context of their originating Dough Batch.
- Historical reporting becomes significantly simpler.

Related Principles

- Business First
- Traceability

---

# ADR-014 — Operators Are Business Entities

Status

Accepted

Decision Date

2026-07-02

Supersedes

None

## Context

Operators participate in production but do not require individual system accounts.

Business traceability is independent from authentication.

## Decision

Operators remain business entities rather than application users.

Authentication exists for system access.

Operators exist for production traceability.

## Rationale

Separating business participants from authentication simplifies operations while preserving complete historical information.

## Consequences

- Production workflows remain simple.
- Operator history remains complete.
- Authentication strategy can evolve independently.

Related Principles

- Business First
- Operator Experience

---

# ADR-015 — Shared Production Session

Status

Accepted

Decision Date

2026-07-02

Supersedes

None

## Context

Production is performed collaboratively.

Multiple operators participate during the same production session.

## Decision

The production module uses a shared authenticated session.

Participating operators are recorded within each Dough Batch.

## Rationale

This approach minimizes operational complexity while preserving complete business traceability.

## Consequences

- Faster production registration.
- No individual operator login required.
- Complete operator history remains available.

Related Principles

- Operator Experience
- KISS

---

# ADR-016 — Business Facts vs Calculated Values

Status

Accepted

Decision Date

2026-07-20

Supersedes

None

## Context

Business calculations may evolve over time.

Operational facts should remain immutable.

## Decision

Only operational facts are permanently stored.

Business indicators are always calculated from recorded operational information.

## Examples

Stored

- Quantity
- Dough Weight
- Flour
- Water
- Remaining Dough

Calculated

- Expected Production
- Waste
- Performance
- Bonus Eligibility
- KPIs

## Rationale

Separating facts from calculations preserves historical consistency while allowing business formulas to evolve.

## Consequences

- Historical data remains stable.
- Business calculations become configurable.
- New KPIs can be introduced without modifying historical records.

Related Principles

- Every Data Must Have Business Value
- Database First

---

# ADR-017 — Production Snapshot

Status

Accepted

Decision Date

2026-07-20

Supersedes

None

## Context

Recipes and business parameters evolve over time.

Historical production must always remain reproducible.

## Decision

Every Dough Batch stores a Production Snapshot representing the operational context at the moment production was registered.

## Rationale

Historical reports should never depend on current recipe definitions.

Production history must always preserve the business reality that existed when production occurred.

## Consequences

- Historical information remains immutable.
- Recipe evolution does not alter historical records.
- Reports remain reproducible across time.

Related Principles

- Historical Integrity
- Future Proof

---

# ADR-018 — Recipe Versioning

Status

Accepted

Decision Date

2026-07-20

Supersedes

None

## Context

Recipes evolve as production techniques improve.

Historical production should not change when recipes are updated.

## Decision

Recipes become versioned business entities.

Production always references the version that was valid at the time of registration.

## Rationale

Recipe evolution should never compromise historical reporting or production traceability.

## Consequences

- Recipe history becomes fully traceable.
- Historical production remains reproducible.
- Future recipe improvements remain compatible with previous production records.

Related Principles

- Historical Integrity
- Future Proof

# 8. Repository Evolution Decisions

The following Architectural Decision Records capture decisions that define the long-term evolution of the EPSM ecosystem.

These decisions were introduced after the initial MVP and establish the direction for future development.

---

# ADR-019 — RPC as the Business Entry Point

Status

Accepted

Decision Date

2026-07-21

Supersedes

None

## Context

Direct database operations from the frontend duplicate business logic and make transactional consistency difficult to maintain.

## Decision

Every business operation that modifies operational data should be executed through PostgreSQL RPCs.

The frontend consumes business capabilities rather than individual database operations.

## Rationale

Centralizing business operations improves consistency, transactional integrity and maintainability.

## Consequences

- Business logic becomes reusable.
- Atomic transactions are guaranteed.
- Frontend complexity is reduced.

Related Principles

- Database First
- Thin Frontend
- Single Source of Truth

---

# ADR-020 — Documentation as Part of the Product

Status

Accepted

Decision Date

2026-07-21

Supersedes

ADR-006

## Context

As the project evolved, documentation became essential for maintaining architectural consistency.

## Decision

Project documentation is considered part of the software product.

A feature is not considered complete until its documentation reflects the implemented behaviour.

## Rationale

Documentation preserves architectural knowledge and simplifies future development.

## Consequences

- Documentation evolves together with the software.
- Architectural knowledge remains centralized.
- Future contributors understand the reasoning behind implementations.

Related Principles

- Documentation First
- Quality over Speed

---

# ADR-021 — Vertical Coding Standard

Status

Accepted

Decision Date

2026-07-21

Supersedes

None

## Context

As the codebase grew, compact source code became increasingly difficult to maintain and review.

## Decision

EPSM adopts a readability-oriented coding standard based on vertical formatting, explicit structure and clearly separated sections.

## Rationale

Readable code is easier to review, debug and maintain over the long term.

## Consequences

- Greater consistency across repositories.
- Faster code reviews.
- Improved maintainability.

Related Principles

- Readability First
- Standardization

---

# ADR-022 — Independent Repository Strategy

Status

Accepted

Decision Date

2026-07-22

Supersedes

None

## Context

Operational management and business analytics evolve at different speeds and have different deployment requirements.

## Decision

Each major module of the EPSM ecosystem is maintained in its own repository.

Examples include:

- EPSM Manager OPS
- EPSM Manager Analytics

## Rationale

Independent repositories reduce coupling, simplify deployments and allow each module to evolve independently.

## Consequences

- Independent release cycles.
- Independent GitHub Pages deployments.
- Lower deployment risk.
- Better long-term scalability.

Related Principles

- Modular Architecture
- Future Proof

---

# 9. ADR Summary

Current ADR Status

Accepted

22

Draft

0

Superseded

1

Deprecated

0

The ADR collection represents the historical evolution of the EPSM architecture.

Existing ADRs are never deleted.

Architectural evolution is documented by creating new ADRs that supersede previous decisions whenever necessary.

---

# 10. Final Statement

Architectural Decision Records preserve the engineering knowledge accumulated throughout the evolution of the EPSM ecosystem.

The objective of this document is not simply to record decisions.

Its purpose is to preserve the reasoning behind those decisions.

Future developers should be able to understand not only how the platform works, but also why it was designed this way.

Every significant architectural decision should become a new ADR.

The history of the architecture is considered part of the architecture itself.