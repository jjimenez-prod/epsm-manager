# Architecture

Project: EPSM Ecosystem

Primary Product: EPSM Manager OPS

Organization: È Pronto Si Mangia

Version: 2.0

Status: Approved

Last Updated: July 2026

---

# 1. Purpose

This document defines the software architecture of the EPSM ecosystem.

Its objective is to describe how the platform is structured, how its components interact and which architectural decisions guide its long-term evolution.

Rather than documenting implementation details, this document explains the architectural foundations that allow EPSM to remain scalable, maintainable and future-proof.

Business rules are documented separately.

Database implementation details are documented separately.

This document focuses exclusively on architecture.

---

# 2. Architectural Objectives

The architecture has been designed to achieve the following objectives:

- Business-first design.
- Long-term maintainability.
- Modular evolution.
- Future-proof architecture.
- Cloud-native deployment.
- High data integrity.
- Low operational cost.
- Version-controlled infrastructure.
- Readable and maintainable code.
- Clear separation of responsibilities.

Every architectural decision should contribute to one or more of these objectives.

---

# 3. High-Level Architecture

The EPSM ecosystem follows a layered architecture where each layer has a clearly defined responsibility.

```text
┌──────────────────────────────┐
│         Web Browser          │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│      GitHub Pages (OPS)      │
│ Static HTML / CSS / JS       │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│      Supabase JavaScript     │
│          Client SDK          │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│         Supabase API         │
│      Authentication          │
│      PostgreSQL RPC          │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│         PostgreSQL           │
│                              │
│ Tables                       │
│ Constraints                  │
│ Functions                    │
│ Views (Future)               │
│ Policies (Future)            │
└──────────────────────────────┘
```

Every business event flows through this architecture.

Operational data is always persisted before becoming available to analytical or reporting modules.

---

# 4. Architectural Philosophy

EPSM follows a Business-Driven Architecture.

The platform is intentionally designed around business capabilities rather than around technical components.

The architecture follows the principles defined in `PROJECT_PRINCIPLES.md`, particularly:

- Business First
- Documentation First
- Database First
- Thin Frontend
- Future Proof
- Single Source of Truth
- Readability First

Every new module introduced into the ecosystem should preserve these architectural foundations.
# 5. System Components

The EPSM ecosystem is composed of independent components, each with a clearly defined responsibility.

Every component performs a single role within the architecture.

Business capabilities emerge from the collaboration between components rather than from individual technologies.

---

## 5.1 Web Browser

Responsibilities:

- Execute the user interface.
- Render HTML, CSS and JavaScript.
- Capture user interactions.
- Display operational information.

The browser never stores business information permanently.

---

## 5.2 GitHub Pages

Responsibilities:

- Host the frontend application.
- Deliver static assets.
- Provide HTTPS access.
- Distribute application updates.

GitHub Pages never stores operational data.

It is responsible only for application delivery.

---

## 5.3 Frontend Application

The frontend represents the presentation layer of EPSM.

Responsibilities:

- Render the user interface.
- Guide the operational workflow.
- Perform basic client-side validation.
- Build requests.
- Display responses.
- Handle user interaction.

The frontend should remain intentionally lightweight.

Business calculations and business rules should not be implemented in the frontend whenever reasonably possible.

---

## 5.4 Supabase Platform

Supabase provides the backend infrastructure of the platform.

Responsibilities:

- Authentication.
- Authorization.
- PostgreSQL API.
- Database connectivity.
- Business RPC execution.
- Data persistence.

Supabase acts as the gateway between the frontend and PostgreSQL.

---

## 5.5 PostgreSQL Database

PostgreSQL is the core of the EPSM architecture.

Responsibilities:

- Persist operational information.
- Enforce data integrity.
- Execute business rules.
- Preserve historical consistency.
- Protect relational integrity.
- Execute business transactions.

The database is the Single Source of Truth.

Every operational event must be successfully stored before becoming available to any other module.

---

# 6. Architectural Layers

EPSM follows a layered architecture.

Each layer communicates only with its adjacent layer.

Business responsibilities remain clearly separated.

```text
Presentation Layer

↓

Workflow Layer

↓

Service Layer

↓

Supabase Client

↓

Business Layer (RPC)

↓

Persistence Layer (PostgreSQL)
```

---

## 6.1 Presentation Layer

Responsible for visual representation.

Examples:

- HTML
- CSS
- UI Components
- Tables
- Forms
- Dashboard Cards

This layer never contains business rules.

---

## 6.2 Workflow Layer

Responsible for user interaction.

Examples:

- Button events
- Form orchestration
- Navigation
- Screen state
- Loading indicators

This layer coordinates the application.

It does not calculate business results.

---

## 6.3 Service Layer

Responsible for communication with Supabase.

Responsibilities:

- Build requests.
- Execute queries.
- Execute RPCs.
- Handle responses.
- Handle communication errors.

This layer isolates the frontend from backend implementation details.

---

## 6.4 Business Layer

Implemented primarily through PostgreSQL RPCs.

Responsibilities:

- Business validations.
- Business calculations.
- Snapshot generation.
- Historical consistency.
- Transaction management.

Business rules belong here.

---

## 6.5 Persistence Layer

Implemented directly in PostgreSQL.

Responsibilities:

- Tables.
- Constraints.
- Foreign Keys.
- Generated Columns.
- Indexes.
- Historical records.

This layer guarantees data integrity regardless of which client accesses the system.
# 7. Data Flow

EPSM follows a unidirectional data flow.

Operational information always moves through the same sequence of architectural layers.

This guarantees consistency, traceability and predictable system behaviour.

Business information is never generated directly inside the user interface.

---

## 7.1 Operational Workflow

Every production event follows the workflow below.

```text
Operator

↓

Frontend Form

↓

Workflow Layer

↓

Service Layer

↓

Supabase Client

↓

PostgreSQL RPC

↓

Database Transaction

↓

Persistent Storage

↓

Response

↓

Frontend Update
```

Each layer performs a single responsibility before passing control to the next one.

---

## 7.2 Read Operations

Operational data follows the opposite direction.

```text
Database

↓

PostgreSQL

↓

RPC / Query

↓

Supabase Client

↓

Service Layer

↓

Workflow Layer

↓

Presentation Layer

↓

User
```

The frontend never accesses database tables directly for business logic.

Business information should preferably be exposed through dedicated business capabilities.

---

## 7.3 Analytics Workflow

Analytics consumes operational information without modifying it.

```text
OPS

↓

PostgreSQL

↓

Business Views (Future)

↓

Analytics RPC

↓

Dashboard

↓

Business Decisions
```

Analytics is intentionally designed as a read-only consumer of operational information.

No analytical component should modify production data.

---

# 8. Design Patterns

The architecture intentionally follows a set of recurring design patterns.

These patterns promote consistency across every module of the EPSM ecosystem.

---

## 8.1 Thin Frontend

The frontend is responsible only for:

- presentation
- navigation
- workflow orchestration
- user interaction

Business rules should remain outside the presentation layer.

---

## 8.2 Database First

Business rules should be implemented as close as possible to PostgreSQL.

Whenever possible:

- validations
- calculations
- transactions
- historical integrity

should be enforced by the database.

---

## 8.3 Single Source of Truth

Operational information exists only once.

Every component consumes the same information.

Duplicate business logic should never exist across multiple layers.

---

## 8.4 Modular Components

Every module should have a single responsibility.

Modules should evolve independently whenever reasonably possible.

Replacing one module should not require redesigning the rest of the platform.

---

## 8.5 Business Capabilities

The frontend should consume business capabilities instead of low-level database operations.

Examples include:

- Create Production Batch
- Update Production Batch
- Load Dashboard
- Retrieve Historical Production

This approach hides implementation details and promotes long-term maintainability.

---

## 8.6 Future Proof

The preferred strategy for evolution is extension rather than replacement.

New requirements should preferably introduce new capabilities instead of modifying existing ones.

Backward compatibility should be preserved whenever reasonably possible.

---

## 8.7 Documentation Driven Development

Architecture documentation evolves together with the software.

Every significant architectural decision should be reflected in the documentation before becoming part of the platform.

Documentation is considered part of the architecture itself.
# 9. Architectural Decisions

The following architectural decisions are considered fundamental to the EPSM ecosystem.

These decisions should only change when justified by a genuine business requirement and after an explicit architectural review.

---

## 9.1 Database as Single Source of Truth

Operational information exists only in PostgreSQL.

External tools may consume operational information but must never become independent sources of business data.

---

## 9.2 Business Logic Inside PostgreSQL

Business rules belong to the backend.

Whenever possible, validations, calculations and business transactions should be implemented through PostgreSQL RPCs.

This guarantees consistent behaviour regardless of the client application.

---

## 9.3 Thin Frontend

Frontend applications are responsible for:

- user interaction
- workflow orchestration
- presentation

Frontend applications should not implement business calculations.

---

## 9.4 Historical Integrity

Historical information must never lose its meaning.

Business evolution should preserve historical records rather than reinterpret them.

Snapshot strategies, immutable records and versioning exist to guarantee historical consistency.

---

## 9.5 Migration-Based Evolution

Database evolution is managed exclusively through version-controlled migrations.

Every structural database change must be:

- documented
- version controlled
- reproducible
- reviewable

Direct modifications to production databases are not allowed.

---

## 9.6 Backward Compatibility

Whenever reasonably possible, architectural evolution should preserve compatibility with existing modules.

New capabilities should extend existing contracts instead of replacing them.

---

# 10. Evolution Strategy

EPSM is designed as a continuously evolving platform.

Growth should occur by introducing new modules rather than redesigning existing ones.

The preferred evolution strategy is:

```text
Stable Foundation

↓

New Business Capability

↓

New Module

↓

Architecture Extension

↓

No Existing Module Rewrite
```

Examples of future evolution include:

- Analytics
- Inventory
- Purchasing
- Cost Analysis
- Multi-Location Support
- Artificial Intelligence
- Mobile Applications

Each new module should inherit the same architectural principles described in this document.

---

# 11. Architecture Success Criteria

The architecture is considered successful when:

- Every business event is stored exactly once.
- Every business rule is implemented consistently.
- Historical information remains trustworthy.
- New modules can be added without redesigning the platform.
- The frontend remains lightweight.
- The database preserves business integrity.
- Every deployment is reproducible.
- Every structural change is version controlled.
- Documentation remains synchronized with the implemented architecture.

Long-term maintainability is considered more important than short-term implementation speed.

---

# 12. Final Statement

The EPSM architecture is intentionally designed around business capabilities rather than technical components.

Technologies may evolve.

Programming languages may change.

Infrastructure may be replaced.

Business requirements will continue to grow.

However, the architectural principles defined in this document should remain stable.

Every future module developed within the EPSM ecosystem should extend these foundations rather than replace them.

The objective is not simply to build software.

The objective is to build a platform capable of evolving together with the business while preserving simplicity, consistency and long-term maintainability.