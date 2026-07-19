# Product Backlog

**Project:** EPSM Manager

**Current Stable Version:** v1.0.0

**Current Sprint:** v1.0.1

**Status:** Living Document

**Last Update:** 2026-07-09

---

# Vision

EPSM Manager is a lightweight Manufacturing Execution System (MES) specialized in pizza dough production.

The system registers **Production Events**, centralizes operational information and provides reliable data for operational analysis and future KPIs.

The project follows a KISS philosophy, prioritizing maintainability, scalability and a single source of truth.

---

# Current Sprint - v1.0.1

## Goal

Stabilize the first production release before adding new functional modules.

### Functional Improvements

- [x] Rename Happy/Fanta product.
- [x] Alphabetical product catalog.
- [x] Increase history from 10 to 20 records.
- [ ] Improve Products visualization in History.
- [ ] Review History UX.

### Database

- [x] Remove obsolete tables.
- [ ] Synchronize schema.sql.
- [x] Protect catalog tables using RLS.
- [ ] Review operational table permissions.

### Security

Status: In Progress

- [x] Enable RLS on catalog tables.
- [ ] Secure operational tables.
- [ ] Auth Ready architecture.

---

# Technical Backlog

Architecture improvements that do not directly affect end users.

---

## BT-001 - Production RPC

Priority: High

Replace direct CRUD operations with PostgreSQL RPC functions.

Current

Frontend

↓

Insert / Update / Delete

↓

Tables

Future

Frontend

↓

RPC

↓

Database

Functions

- save_production()
- update_production()

Benefits

- Smaller attack surface.
- Centralized business logic.
- Simpler RLS.
- Auth Ready.
- Easier maintenance.

Status

Pending

---

## BT-002 - Database Versioning

Priority: High

Introduce database migrations.

database/

    schema.sql

    migrations/

        001_initial.sql

        002_cleanup.sql

        003_rls.sql

        ...

Status

Pending

---

## BT-003 - Schema Synchronization

Priority: Medium

Keep schema.sql synchronized with the real database after every structural modification.

Status

In Progress

---

# v1.1.0 - Production Module Evolution

## Goal

Transform the application into a modular production system.

### Production Module

- Separate Form and History.
- Navigation between modules.
- Cleaner interface.
- Better UX.

### Production Model

Officially adopt the concept of

Production Event

instead of

Dough Batch

One event may contain multiple dough mixes.

Future-ready for production scaling.

---

# v1.2.0 - Analytics

## Dashboard

- Daily Production
- Shift Performance
- Product Distribution
- Dough Consumption
- Waste Indicators
- Production Trends

---

## KPIs

- Production Events
- Products Produced
- Dough Produced
- Flour Consumption
- Water Consumption
- Waste Percentage
- Operator Productivity

---

# v1.3.0 - Identity & Security

## Authentication

- User Login
- Session Management
- Password Recovery

---

## Roles

- Administrator
- Supervisor
- Operator

---

## Audit

- created_by
- updated_by
- Activity Log
- Change History
- Record Versioning

---

# v2.0

Future operational modules.

## Production

- Multi-site Production
- Production Planning

## Business

- Inventory
- Cost Analysis
- Purchasing

## Intelligence

- Forecasting
- AI Assisted Recommendations
- Operational Alerts

---

# Parking Lot

Ideas intentionally postponed.

- Dark Mode
- Excel Export
- PDF Reports
- Advanced Filters
- Dashboard Customization
- Mobile Version
- Push Notifications
- Multi-language

---

# Development Principles

The project follows the following principles:

- KISS First.
- One Source of Truth.
- Database First.
- Auth Ready.
- Event Driven Model.
- No duplicated business logic.
- Security by Default.
- Feature before Optimization.

---

# Backlog Rules

Items should only enter the backlog if they:

- Provide measurable business value.
- Improve maintainability.
- Support the long-term product vision.
- Respect the KISS philosophy.
- Are compatible with the current architecture.

Items are never implemented directly from the backlog.

Every item must first be prioritized and assigned to a sprint.