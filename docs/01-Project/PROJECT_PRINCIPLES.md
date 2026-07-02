# Project Principles

**Project:** EPSM Manager

**Client:** È Pronto Si Mangia

**Version:** 1.0

**Status:** Approved

**Last Update:** 2026-07-02

---

# 1. Purpose

This document defines the fundamental principles that govern every architectural, functional and technical decision within EPSM Manager.

These principles have priority over implementation preferences and should always be respected during the evolution of the platform.

---

# 2. Business First

The platform must represent the real business process.

Technology adapts to the business.

The business never adapts to the software.

---

# 3. KISS (Keep It Simple)

Every solution must be as simple as possible while fulfilling the business requirements.

Complexity should only be introduced when it provides measurable value.

---

# 4. Digitalize Processes

The objective is not to replace spreadsheets.

The objective is to digitalize the operational process.

Every feature must contribute to reducing manual work and increasing traceability.

---

# 5. Single Source of Truth

Supabase is the only authoritative source of operational data.

No business information should exist exclusively in Excel.

---

# 6. Documentation First

Every relevant architectural, business or technical decision must be documented before implementation.

If a decision is not documented, it does not officially exist.

---

# 7. Scalability

Every module must be designed considering future growth.

Future expansion should not require redesigning the database or rewriting existing modules.

---

# 8. Modular Architecture

Every feature should belong to a well-defined module.

Modules must evolve independently whenever possible.

---

# 9. Security by Design

Security is designed from the beginning.

It is never added as a final step.

Every component exposed to the Internet must assume zero trust.

---

# 10. Cost Zero First

The platform should operate with zero monthly operational cost whenever technically possible.

Paid services should only be introduced when justified by business growth.

---

# 11. Data Driven Decisions

Business decisions should always be supported by reliable operational data.

Whenever possible, calculations must be generated automatically.

---

# 12. Traceability

Every important business event must be traceable.

The system should always allow understanding:

- what happened
- when it happened
- who participated
- who modified the information

---

# 13. Operator Experience

The platform exists to help operators.

The workflow must be fast, intuitive and require minimal training.

Manual typing should be minimized.

---

# 14. Progressive Disclosure

Only the information required at each moment should be displayed.

Advanced fields must appear only when necessary.

---

# 15. Configuration over Code

Business parameters should be configurable whenever possible.

Business rule changes should not require software development.

---

# 16. Backlog Control

No feature will be implemented without explicit approval.

New ideas must first enter the backlog.

Only approved backlog items may become development work.

---

# 17. Future Independence

The platform should avoid unnecessary dependency on specific technologies.

Components should be replaceable with minimal impact.

---

# 18. Continuous Improvement

The project is expected to evolve continuously.

Every improvement should preserve compatibility with existing operational data.

---

# 19. Quality over Speed

A well-designed solution is preferred over a quick implementation.

Short-term shortcuts that compromise maintainability are discouraged.

---

# 20. Long-Term Thinking

Every design decision should remain valid for several years.

The platform should grow by extending existing foundations instead of replacing them.