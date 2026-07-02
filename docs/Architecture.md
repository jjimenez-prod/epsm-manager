# Architecture

**Project:** EPSM Manager

**Client:** È Pronto Si Mangia

**Version:** 1.0

**Status:** Approved

**Last Update:** 2026-07-02

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

# 8. Future Evolution

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

# 9. Design Decisions

The architecture intentionally separates:

Presentation

Business Data

Business Intelligence

This separation guarantees scalability and maintainability.

---

# 10. Architecture Goals

The architecture must ensure:

- High availability.
- Low operational cost.
- Easy maintenance.
- Long-term scalability.
- Secure access.
- Reliable business data.
- Technology independence.

---

# 11. Current Status

Current implementation:

✅ GitHub Pages

✅ HTML/CSS/JavaScript

✅ Supabase

✅ PostgreSQL

✅ CRUD Operations

✅ Excel Integration

Future implementation:

⬜ Authentication

⬜ Role Management

⬜ Web Dashboard

⬜ Inventory

⬜ Reports

⬜ Business Intelligence

⬜ AI Support