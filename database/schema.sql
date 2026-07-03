-- ==========================================================
-- EPSM Manager
-- Database Schema
-- Version: 1.1.0
-- PostgreSQL / Supabase
-- ==========================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ==========================================================
-- OPERATORS
-- ==========================================================

CREATE TABLE operators (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    full_name TEXT NOT NULL UNIQUE,

    role TEXT NOT NULL
        CHECK (role IN ('ADMIN','OPERATOR')),

    active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()

);

-- ==========================================================
-- SHIFTS
-- ==========================================================

CREATE TABLE shifts (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name TEXT NOT NULL UNIQUE,

    active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()

);

-- ==========================================================
-- RECIPES
-- ==========================================================

CREATE TABLE recipes (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    recipe_type TEXT NOT NULL UNIQUE,

    display_name TEXT NOT NULL UNIQUE,

    is_standard BOOLEAN NOT NULL,

    default_flour_g INTEGER NOT NULL
        CHECK (default_flour_g >= 0),

    default_water_g INTEGER NOT NULL
        CHECK (default_water_g >= 0),

    default_other_ingredients_g INTEGER NOT NULL
        CHECK (default_other_ingredients_g >= 0),

    default_total_weight_g INTEGER NOT NULL
        CHECK (default_total_weight_g > 0),

    active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()

);

-- ==========================================================
-- PRODUCTS
-- ==========================================================

CREATE TABLE products (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    legacy_id INTEGER NOT NULL UNIQUE,

    code TEXT NOT NULL UNIQUE,

    name TEXT NOT NULL,

    grammage_g INTEGER NOT NULL
        CHECK (grammage_g > 0),

    active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()

);

-- ==========================================================
-- REFERENCE RANGES
-- ==========================================================

CREATE TABLE reference_ranges (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    grammage_g INTEGER NOT NULL UNIQUE
        CHECK (grammage_g > 0),

    min_units INTEGER NOT NULL
        CHECK (min_units >= 0),

    max_units INTEGER NOT NULL
        CHECK (max_units >= min_units)

);

-- ==========================================================
-- SETTINGS
-- ==========================================================

CREATE TABLE settings (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    category TEXT NOT NULL,

    key TEXT NOT NULL UNIQUE,

    value TEXT NOT NULL,

    data_type TEXT NOT NULL,

    description TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()

);
-- ==========================================================
-- DOUGH BATCHES
-- ==========================================================

CREATE TABLE dough_batches (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    production_date DATE NOT NULL,

    shift_id UUID NOT NULL
        REFERENCES shifts(id),

    recipe_id UUID NOT NULL
        REFERENCES recipes(id),

    initial_weight_g INTEGER NOT NULL
        CHECK (initial_weight_g > 0),

    leftover_added_g INTEGER NOT NULL DEFAULT 0
        CHECK (leftover_added_g >= 0),

    total_weight_g INTEGER
        GENERATED ALWAYS AS
        (initial_weight_g + leftover_added_g)
        STORED,

    leftover_remaining_g INTEGER NOT NULL DEFAULT 0
        CHECK (leftover_remaining_g >= 0),

    notes TEXT,

    status TEXT NOT NULL DEFAULT 'ACTIVE'
        CHECK (status IN ('ACTIVE','CANCELLED')),

    created_by UUID
        REFERENCES operators(id),

    updated_by UUID
        REFERENCES operators(id),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CHECK (leftover_remaining_g <= total_weight_g)

);

-- ==========================================================
-- DOUGH BATCH OPERATORS
-- ==========================================================

CREATE TABLE dough_batch_operators (

    batch_id UUID NOT NULL
        REFERENCES dough_batches(id)
        ON DELETE CASCADE,

    operator_id UUID NOT NULL
        REFERENCES operators(id),

    PRIMARY KEY (batch_id, operator_id)

);

-- ==========================================================
-- PRODUCTION ITEMS
-- ==========================================================

CREATE TABLE production_items (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    batch_id UUID NOT NULL
        REFERENCES dough_batches(id)
        ON DELETE CASCADE,

    product_id UUID NOT NULL
        REFERENCES products(id),

    quantity INTEGER NOT NULL
        CHECK (quantity > 0),

    notes TEXT,

    created_by UUID
        REFERENCES operators(id),

    updated_by UUID
        REFERENCES operators(id),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_batch_product
        UNIQUE(batch_id, product_id)

);

-- ==========================================================
-- AUDIT LOG
-- ==========================================================

CREATE TABLE audit_log (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    table_name TEXT NOT NULL,

    record_id UUID NOT NULL,

    action TEXT NOT NULL
        CHECK (action IN ('INSERT','UPDATE','CANCEL')),

    modified_by UUID
        REFERENCES operators(id),

    modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    reason TEXT,

    old_values JSONB,

    new_values JSONB

);
-- ==========================================================
-- INDEXES
-- ==========================================================

CREATE INDEX idx_batch_date
ON dough_batches(production_date);

CREATE INDEX idx_batch_shift
ON dough_batches(shift_id);

CREATE INDEX idx_batch_recipe
ON dough_batches(recipe_id);

CREATE INDEX idx_batch_created_at
ON dough_batches(created_at);

CREATE INDEX idx_batch_status
ON dough_batches(status);

CREATE INDEX idx_production_batch
ON production_items(batch_id);

CREATE INDEX idx_production_product
ON production_items(product_id);

CREATE INDEX idx_batch_operator
ON dough_batch_operators(operator_id);

CREATE INDEX idx_operator_active
ON operators(active);

CREATE INDEX idx_product_active
ON products(active);

CREATE INDEX idx_product_legacy
ON products(legacy_id);

CREATE INDEX idx_settings_category
ON settings(category);

CREATE INDEX idx_audit_record
ON audit_log(table_name, record_id);

CREATE INDEX idx_audit_date
ON audit_log(modified_at);

-- ==========================================================
-- FUTURE TABLES
-- ==========================================================
--
-- Reserved for future migrations:
--
-- inventory
-- production_targets
-- bonus_rules
-- attachments
-- dashboard_cache
--
-- Do not add tables below this line without
-- updating the architecture documentation.
-- ==========================================================