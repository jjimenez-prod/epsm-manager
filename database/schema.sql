-- ==========================================================
-- EPSM Manager
-- Database Schema
-- Version: 1.0.0
-- PostgreSQL / Supabase
-- ==========================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    full_name TEXT NOT NULL,

    role TEXT NOT NULL CHECK (role IN ('ADMIN','OPERATOR')),

    active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE operators (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    full_name TEXT NOT NULL,

    active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE shifts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name TEXT NOT NULL UNIQUE,

    active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE recipes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    recipe_type TEXT NOT NULL UNIQUE,

    display_name TEXT NOT NULL,

    is_standard BOOLEAN NOT NULL,

    default_flour_g INTEGER NOT NULL CHECK (default_flour_g >= 0),

    default_water_g INTEGER NOT NULL CHECK (default_water_g >= 0),

    default_other_ingredients_g INTEGER NOT NULL CHECK (default_other_ingredients_g >= 0),

    default_total_weight_g INTEGER NOT NULL CHECK (default_total_weight_g > 0),

    active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    code TEXT NOT NULL UNIQUE,

    name TEXT NOT NULL,

    grammage_g INTEGER NOT NULL CHECK (grammage_g > 0),

    active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    key TEXT NOT NULL UNIQUE,

    value TEXT NOT NULL,

    data_type TEXT NOT NULL,

    description TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE dough_batches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    production_date DATE NOT NULL,

    shift_id UUID NOT NULL REFERENCES shifts(id),

    recipe_id UUID NOT NULL REFERENCES recipes(id),

    initial_weight_g INTEGER NOT NULL CHECK (initial_weight_g > 0),

    leftover_added_g INTEGER NOT NULL DEFAULT 0 CHECK (leftover_added_g >= 0),

    total_weight_g INTEGER GENERATED ALWAYS AS (initial_weight_g + leftover_added_g) STORED,

    leftover_remaining_g INTEGER NOT NULL DEFAULT 0 CHECK (leftover_remaining_g >= 0),

    notes TEXT,

    status TEXT NOT NULL DEFAULT 'ACTIVE'
        CHECK (status IN ('ACTIVE','CANCELLED')),

    created_by UUID REFERENCES users(id),

    updated_by UUID REFERENCES users(id),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE dough_batch_operators (

    batch_id UUID NOT NULL REFERENCES dough_batches(id) ON DELETE CASCADE,

    operator_id UUID NOT NULL REFERENCES operators(id),

    PRIMARY KEY (batch_id, operator_id)

);
CREATE TABLE production_items (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    batch_id UUID NOT NULL REFERENCES dough_batches(id) ON DELETE CASCADE,

    product_id UUID NOT NULL REFERENCES products(id),

    quantity INTEGER NOT NULL CHECK (quantity > 0),

    notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()

);
CREATE TABLE audit_log (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    table_name TEXT NOT NULL,

    record_id UUID NOT NULL,

    modified_by UUID REFERENCES users(id),

    modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    reason TEXT,

    old_values JSONB,

    new_values JSONB

);
CREATE INDEX idx_batch_date
ON dough_batches(production_date);

CREATE INDEX idx_batch_shift
ON dough_batches(shift_id);

CREATE INDEX idx_production_batch
ON production_items(batch_id);

CREATE INDEX idx_operator_active
ON operators(active);

CREATE INDEX idx_product_active
ON products(active);