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