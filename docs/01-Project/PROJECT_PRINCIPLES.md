# Project Principles

Project: EPSM Manager

Organization: È Pronto Si Mangia

Version: 2.0

Status: Approved

Last Updated: July 22, 2026

---

# 1. Purpose

This document defines the fundamental principles that govern every business, architectural and technical decision within the EPSM ecosystem.

These principles are considered permanent.

Technologies may evolve.

Architectures may improve.

Business requirements may change.

However, every future decision must remain aligned with these principles.

Violation of a Core Principle requires explicit architectural review.

---

# 2. Core Principles

The following principles define the identity of EPSM.

They have priority over implementation preferences, technology choices and development speed.

## 2.1 Business First

The software exists to support the business.

Technology adapts to business processes.

Business processes never adapt to software limitations.

Every feature must solve a real operational need.

---

## 2.2 Documentation First

Documentation is considered part of the product.

Every relevant architectural, business or technical decision must be documented before implementation.

If a decision is not documented, it does not officially exist.

A feature is not considered complete until its documentation reflects its implemented behaviour.

---

## 2.3 KISS (Keep It Simple)

Every solution should be as simple as possible while satisfying business requirements.

Complexity must only be introduced when it provides measurable business value.

Simple solutions are preferred over clever solutions.

---

## 2.4 Future Proof

Every module must evolve by extension rather than replacement.

Future requirements should be implemented without redesigning the existing architecture whenever reasonably possible.

Architectural decisions should remain valid for several years.

---

## 2.5 Quality over Speed

Long-term maintainability always has priority over short-term implementation speed.

Temporary shortcuts that compromise architecture, readability or historical integrity are discouraged.

# 3. Business Principles

The following principles define how EPSM represents and supports the operational reality of the business.

Every business feature must comply with these principles.

---

## 3.1 Digitalize Processes

The objective of EPSM is not to replace spreadsheets.

The objective is to digitalize the operational workflow.

Every implemented feature should reduce manual work, improve consistency and increase operational traceability.

Technology exists to simplify business operations, not to replicate existing manual processes.

---

## 3.2 Every Data Must Have Business Value

Every operational data collected by EPSM must answer one or more business questions.

Data should never be stored simply because it is available.

If a piece of information does not contribute to reporting, KPIs, traceability or future business analysis, it should not be collected.

Business value always justifies data collection.

---

## 3.3 Data Driven Decisions

Business decisions should be supported by reliable operational data.

Whenever possible, calculations should be generated automatically by the system.

Dashboards, KPIs and reports must answer real business questions.

If a feature does not improve decision making, its implementation should be questioned.

---

## 3.4 Traceability

Every relevant business event must be traceable.

The system should always allow understanding:

- what happened
- when it happened
- who participated
- what data was recorded
- who modified the information

Historical information should remain understandable even years after it was created.

---

## 3.5 Operator Experience

EPSM exists to support operators.

Operational workflows should be:

- fast
- intuitive
- consistent
- easy to learn

Manual typing should be minimized whenever possible.

The operator should focus on production rather than on interacting with the software.

---

## 3.6 Progressive Disclosure

Users should only see the information required for their current task.

Advanced options should appear only when necessary.

Simple workflows should remain simple.

Complexity should never be exposed unless it provides immediate value to the user.

# 4. Architecture Principles

The following principles define how EPSM is designed and implemented from a technical perspective.

Architectural decisions should maximize maintainability, scalability and long-term stability.

---

## 4.1 Database as Single Source of Truth

The database is the only authoritative source of operational information.

Business information must never exist exclusively in external tools such as spreadsheets.

Whenever possible, business calculations should originate from database data.

Every component of the platform must trust the database as the definitive source of information.

---

## 4.2 Database First

Business rules should be implemented as close to the database as reasonably possible.

The database is responsible for protecting data integrity, enforcing business rules and preserving historical consistency.

Application layers should consume business capabilities instead of reimplementing them.

---

## 4.3 Thin Frontend

The frontend is responsible for:

- user interaction
- data presentation
- workflow orchestration

The frontend should avoid implementing business rules whenever possible.

Business calculations belong to the backend.

---

## 4.4 Modular Architecture

Every feature belongs to a well-defined module.

Modules should evolve independently whenever possible.

Changes inside one module should minimize their impact on the rest of the system.

The architecture should promote low coupling and high cohesion.

---

## 4.5 Scalability

Every component should be designed considering future business growth.

New requirements should preferably extend existing capabilities instead of replacing them.

Growth should not require redesigning the architecture.

---

## 4.6 Configuration over Code

Business parameters should be configurable whenever possible.

Business rule changes should preferably require configuration changes rather than software development.

Operational flexibility is preferred over hardcoded behaviour.

---

## 4.7 Security by Design

Security is designed from the beginning.

It is never added as a final step.

Every externally accessible component should assume zero trust.

Business data should always be protected according to the principle of least privilege.

---

## 4.8 Readability First

Code is read significantly more often than it is written.

EPSM prioritizes readability, consistency and maintainability over minimizing the number of lines.

Clear code is preferred over compact code.

Every source file should be organized using consistent naming, modular structure and clearly identifiable sections.

# 5. Project Principles

The following principles define how EPSM is managed, maintained and evolved over time.

The objective is to preserve consistency, control technical debt and ensure sustainable long-term development.

---

## 5.1 Cost Zero First

Whenever technically possible, the platform should operate with zero recurring operational cost.

Free-tier services should be preferred during the early stages of the project.

Paid services should only be adopted when they provide measurable business value or become necessary to support growth.

---

## 5.2 Backlog First

No feature should be implemented without explicit approval.

Every new idea must first enter the project backlog.

Only approved backlog items may become development work.

This principle protects the project from uncontrolled scope growth.

---

## 5.3 Incremental Development

EPSM evolves through small, complete and testable iterations.

Each version should deliver one or more fully functional business capabilities.

Partial implementations should be avoided whenever possible.

A business capability is considered complete only when it is:

- implemented
- tested
- documented

---

## 5.4 Continuous Improvement

The platform is expected to evolve continuously.

Every improvement should preserve compatibility with existing operational data.

Existing architecture should be refined rather than replaced whenever possible.

---

## 5.5 Long-Term Thinking

Every architectural decision should remain valuable for several years.

Short-term optimizations should never compromise future maintainability.

The project should grow by extending existing foundations instead of replacing them.

---

## 5.6 Standardization

Consistency has priority over personal preference.

Source code, documentation, naming conventions and project organization should follow the established EPSM standards.

Every repository belonging to the EPSM ecosystem should provide a familiar development experience.

---

## 5.7 Documentation Maintenance

Project documentation must evolve together with the software.

Documentation should always describe the current implementation rather than historical states.

Historical evolution belongs to the project changelog.

Architectural documentation should remain synchronized with the implemented solution.

---

# 6. Final Statement

These principles define the identity of the EPSM ecosystem.

Technologies may evolve.

Programming languages may change.

Frameworks may be replaced.

Infrastructure may change.

Business requirements will continue to evolve.

However, these principles should remain stable and guide every future architectural, technical and business decision.

Every module of the EPSM ecosystem, present or future, should inherit these principles.

Maintaining consistency across projects is considered a strategic objective of the platform.