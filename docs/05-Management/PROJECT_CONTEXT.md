# EPSM Manager - EPIC 3 HANDOVER

Version: 1.0
Date: 2026-07-15

---

# 1. Project Overview

EPSM Manager is a production management system for a bakery.

Current technology stack:

- Supabase (PostgreSQL)
- HTML / CSS / Vanilla JavaScript
- Git
- Supabase Migrations
- Documentation-first approach

Project principles:

1. Business First
2. Historical Data Integrity
3. KISS
4. Future-Proof Architecture
5. Database as Single Source of Truth

Premature optimization must be avoided.

---

# 2. Current Epic

EPIC 3

Production Engine

Current Status:

IN DEVELOPMENT

---

# 3. Completed Work

The following milestones are completed:

- Functional Design
- Data Model
- Infrastructure
- Database Evolution

Implemented database improvements include:

- Recipe Versioning
- Production Snapshot strategy
- Generated Columns
- Historical KPIs support
- Migration-based schema evolution

---

# 4. Current Database Status

Current production tables:

- recipes
- products
- operators
- shifts
- dough_batches
- production_items
- batch_operators
- audit_log
- reference_ranges
- settings

The schema was synchronized using:

supabase db pull

The local schema.sql is considered the current source of truth.

---

# 5. Production Engine Status

Current RPC:

public.create_production_batch(payload jsonb)

Currently implemented:

✔ Read Payload

✔ Read Recipe

✔ Build Production Snapshot

Not implemented yet:

- Insert dough_batches
- Insert batch_operators
- Insert production_items

---

# 6. Approved Production Engine Algorithm

This workflow has been approved.

Do NOT redesign it unless there is a real business requirement.

Workflow:

Read Payload

↓

Validate Payload

↓

Read Recipe

↓

Build Production Snapshot

↓

Insert dough_batches

↓

Insert batch_operators

↓

Insert production_items

↓

Return batch_id

---

# 7. Approved RPC Payload

This payload is considered stable.

Future iterations must preserve backward compatibility.

{
    "production_date": "...",

    "shift_id": "...",

    "recipe": {

        "recipe_id": "...",

        "standard_dough_count": 2,

        "leftover_added_g": 500,

        "leftover_remaining_g": 100

    },

    "operators":[

        {

            "operator_id":"..."

        }

    ],

    "production_items":[

        {

            "product_id":"...",

            "quantity":120

        }

    ],

    "notes":"..."

}

---

# 8. Approved Business Decisions

## Recipe Versioning

Recipes are immutable.

Recipe updates create new versions.

Example:

STANDARD V1

↓

STANDARD V2

Historical productions always reference the version that was active at production time.

---

## Production Snapshot

Snapshots are stored ONLY for data that affects historical KPIs.

Snapshot includes:

- recipe_version
- recipe_display_name
- recipe_type
- flour_g
- water_g
- other_ingredients_g
- initial_weight_g
- product_grammage_g

Snapshot DOES NOT include:

- operator names
- shift names
- product names

Those values are obtained through joins.

---

## Products

Frontend sends only:

- product_id
- quantity

The RPC retrieves:

grammage_g

directly from the products table.

The database is the only source of truth.

---

## Operators

Current implementation:

batch_operators

(batch_id, operator_id)

Every operator currently receives equal production credit.

The architecture is intentionally prepared for future extensions:

- contribution_percent
- worked_minutes
- role

without breaking the RPC contract.

---

# 9. KPI Strategy

The entire data model was designed around future KPIs.

Primary KPI:

Theoretical Production

vs

Actual Production

The snapshot guarantees that KPIs remain historically accurate even if:

- recipes change
- product grammage changes
- business rules evolve

---

# 10. Architectural Principles

The following principles are considered frozen:

- KISS
- Business First
- Database as Single Source of Truth
- Thin Frontend
- Business Logic inside PostgreSQL RPCs
- Historical Integrity
- Future-Proof Design

---

# 11. Development Rules

Every migration must implement one complete business capability.

Avoid partial business implementations.

Example:

Production Engine v1

Includes:

- Dough Batch
- Operators
- Production Items

as a single business transaction.

---

# 12. Current Task

Implement Production Engine v1.

The RPC must:

- Read the approved payload
- Validate payload
- Read recipe
- Build Production Snapshot
- Insert dough_batches
- Insert batch_operators
- Insert production_items
- Return batch_id

Once completed:

Refactor the frontend.

Replace:

- insert()
- update()
- delete()

with a single:

supabase.rpc(
    'create_production_batch'
)

---

# 13. Documentation Strategy

Documentation is intentionally postponed until implementation is complete.

After Production Engine v1 is finished, update:

- Architecture.md
- DatabaseSchema.md
- APISpecification.md
- CurrentStatus.md
- Changelog.md
- Roadmap.md

---

# 14. Decisions That Must Not Be Revisited

The following architectural decisions are considered approved:

- Production Snapshot strategy
- Recipe Versioning
- RPC Payload Contract
- Business Logic inside PostgreSQL
- Database as Source of Truth
- Product Grammage retrieved by the RPC
- Future-proof Operators model

These decisions should only change if there is a genuine business requirement.

---

# 15. Next Development Step

Continue implementing Production Engine v1.

Do not redesign the architecture.

Focus only on implementation, testing, and frontend integration.