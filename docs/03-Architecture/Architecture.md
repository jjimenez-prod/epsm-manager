# Architecture

**Project:** EPSM Manager

**Client:** È Pronto Si Mangia

**Version:** 1.0.3

**Status:** Approved

**Last Update:** 2026-07-14

---

# 1. Purpose

This document describes the software architecture of EPSM Manager.

The architecture has been designed to achieve the following objectives:

- Zero operational cost whenever technically possible.
- High scalability.
- Long-term maintainability.
- Cloud-first deployment.
- Secure by design.
- Modular evolution.
- Single Source of Truth.

---

# 2. Architectural Principles

The architecture follows these principles:

- Cloud Native
- Modular
- Data Driven
- API First
- Security by Design
- Zero Vendor Lock-in
- Progressive Evolution

---

# 3. High-Level Architecture

┌─────────────────────────────┐
│        Web Browser          │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│      GitHub Pages           │
│     Web Application         │
└──────────────┬──────────────┘
               │ HTTPS
               ▼
┌─────────────────────────────┐
│         Supabase            │
│                             │
│ Authentication              │
│ PostgreSQL Database         │
│ Row Level Security          │
│ Storage (Future)            │
└──────────────┬──────────────┘
               │
     ┌─────────┴─────────┐
     ▼                   ▼

Excel (Current)     Web Dashboard (Future)

---

# 4. Component Responsibilities

## GitHub Pages

Responsibilities:

- Host the web application.
- Deliver static assets.
- HTTPS termination.
- Global content delivery.

GitHub Pages does NOT store business data.

---

## Web Application

Responsibilities:

- User Interface.
- Form validation.
- Business workflow.
- User experience.
- Communication with Supabase.

The application must never contain business-critical data.

---

## Supabase

Supabase is the central platform.

Responsibilities:

- PostgreSQL Database.
- Authentication.
- Authorization.
- Data persistence.
- Audit information.
- API.

Supabase is the Single Source of Truth.

---

## Excel

Current role:

Business Intelligence.

Responsibilities:

- Dashboard.
- KPIs.
- Validation.
- Historical analysis.

Excel is NOT the source of operational data.

Its role is transitional.

---

## Future Dashboard

The future dashboard will replace Excel for operational analysis.

It will read directly from Supabase.

No duplicated logic should exist.

---

# 5. Data Flow

Production Operator

↓

Web Form

↓

Supabase

↓

Business Analysis

↓

Dashboard

Every business event must first be stored in Supabase before being consumed by any analytical tool.

---

# 6. Security Architecture

The architecture follows a Zero Trust model.

Every request must be authenticated.

Authorization is enforced by Supabase Row Level Security.

The frontend never contains privileged credentials.

---

# 7. Deployment Strategy

Development

↓

GitHub Repository

↓

GitHub Pages

↓

Production Deployment

Every deployment is version controlled.

No manual deployments are allowed.

---

# 8. Database Lifecycle

Starting with **EPSM Manager v1.0.3**, the project adopts a migration-based database lifecycle using the Supabase CLI.

This guarantees that every structural change to the database is:

- Version controlled
- Reproducible
- Auditable
- Traceable
- Reviewed before deployment

The database development workflow is:

```text
Git
        │
        ▼
supabase migration new
        │
        ▼
Implement SQL
        │
        ▼
supabase db push
        │
        ▼
Supabase Cloud
        │
        ▼
Validation
        │
        ▼
supabase db dump
        │
        ▼
database/schema.sql
```

## Source of Truth

The project distinguishes between two database artifacts.

### Database Schema Snapshot

```text
database/schema.sql
```

Represents the latest published database schema.

It is generated using:

```bash
supabase db dump --schema public -f database/schema.sql
```

It must never be edited manually.

---

### Database Migration History

```text
supabase/migrations/
```

Contains the complete history of every structural database change.

Each migration:

- represents a single functional responsibility;
- is immutable once applied;
- is version controlled through Git.

Migration filenames follow the convention:

```text
YYYYMMDDHHMMSS_descriptive_name.sql
```

Example:

```text
20260714185726_support_recipe_versioning.sql
```

---

## Architectural Rule

Every structural database change must follow this workflow:

1. Create a migration.
2. Implement the SQL.
3. Apply the migration using Supabase CLI.
4. Validate the result.
5. Update `database/schema.sql`.
6. Commit both the migration and the updated schema.

Direct modifications to the production schema without a corresponding migration are not allowed.

# 9. Future Evolution

The architecture has been designed to support future modules without redesigning the existing platform.

Possible future modules include:

- Inventory
- Recipes
- Bonus calculation
- Operator management
- Cost analysis
- Purchasing
- AI Assistant
- Notifications
- Mobile application

---

# 10. Design Decisions

The architecture intentionally separates:

Presentation

Business Data

Business Intelligence

This separation guarantees scalability and maintainability.

---

# 10. Architecture Goals

The EPSM Manager architecture has been designed to provide a robust, scalable and maintainable platform capable of evolving alongside the business without requiring architectural redesign.

The architecture must guarantee:

- Single Source of Truth for all operational data.
- Cloud-first architecture using managed services whenever possible.
- Secure by Design with least-privilege principles.
- Version-controlled infrastructure and database evolution.
- Modular components with clear separation of responsibilities.
- Long-term maintainability through standardized development workflows.
- Reproducible deployments across environments.
- Auditability of structural database changes.
- Business data integrity enforced at the database level whenever possible.
- High availability and low operational cost.
- Progressive evolution without breaking historical business data.
- Technology independence, avoiding unnecessary vendor lock-in.

---

## Success Criteria

The architecture is considered successful when:

- Every business event is stored only once.
- Every database change is traceable through version-controlled migrations.
- Every deployment is reproducible.
- Business rules remain consistent regardless of the client application.
- Historical information can never be lost due to future business changes.
- New modules can be incorporated without redesigning the existing architecture.
- The project remains maintainable as functionality and team size grow.y e

# 12. Current Status

## Current Implementation

### Platform

- ✅ GitHub Pages
- ✅ HTML / CSS / JavaScript
- ✅ Supabase
- ✅ PostgreSQL

### Architecture

- ✅ Cloud-First Architecture
- ✅ Single Source of Truth
- ✅ Modular Frontend Architecture
- ✅ Dynamic Card Pattern
- ✅ Version-Controlled Database Migrations
- ✅ Database Schema Snapshot Workflow

### Database

- ✅ Normalized Relational Model
- ✅ Production Snapshot Architecture
- ✅ Recipe Versioning Support
- ✅ CRUD Operations
- ✅ Audit Logging
- ✅ Referential Integrity
- ✅ Database Constraints (CHECK, FK, UNIQUE)
- ✅ Generated Columns

### Development Workflow

- ✅ Git Version Control
- ✅ Supabase CLI
- ✅ Docker Development Environment
- ✅ Database Migration Workflow
- ✅ Schema Synchronization (`database/schema.sql`)

### Business

- ✅ Production Registration
- ✅ Recipe Management
- ✅ Operator Management
- ✅ Shift Management
- ✅ Product Management
- ✅ Excel Integration

---

## Planned Implementation

### Security

- ⬜ User Authentication
- ⬜ Role-Based Access Control (RBAC)
- ⬜ Row Level Security (RLS) Policies

### Analytics

- ⬜ Native Web Dashboard
- ⬜ KPI Engine
- ⬜ Historical Reporting
- ⬜ Business Intelligence Module

### Business Modules

- ⬜ Inventory Management
- ⬜ Purchasing
- ⬜ Cost Analysis
- ⬜ Bonus Calculation

### Platform Evolution

- ⬜ File Storage
- ⬜ Notifications
- ⬜ Mobile Application
- ⬜ AI Assistant

