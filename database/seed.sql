-- ==========================================================
-- EPSM Manager
-- Seed Data
-- Version: 1.0.0
-- ==========================================================

BEGIN;

-- ==========================================================
-- SHIFTS
-- ==========================================================

INSERT INTO shifts (name)
VALUES
('Mañana'),
('Tarde'),
('Noche');

-- ==========================================================
-- RECIPES
-- ==========================================================

INSERT INTO recipes
(
    recipe_type,
    display_name,
    is_standard,
    default_flour_g,
    default_water_g,
    default_other_ingredients_g,
    default_total_weight_g
)
VALUES
(
    'STANDARD',
    'Masa Estándar',
    TRUE,
    12000,
    6500,
    500,
    19000
),
(
    'SPECIAL',
    'Masa Especial',
    FALSE,
    0,
    0,
    0,
    0
);

-- ==========================================================
-- SETTINGS
-- ==========================================================

INSERT INTO settings
(
    key,
    value,
    data_type,
    description
)
VALUES
(
    'monthly_goal',
    '120',
    'INTEGER',
    'Cantidad mínima de masas mensuales'
),
(
    'waste_percentage',
    '3',
    'DECIMAL',
    'Porcentaje máximo de merma permitido'
),
(
    'calculation_strategy',
    'BALANCE',
    'TEXT',
    'Motor de cálculo activo'
);

-- ==========================================================
-- USERS
-- ==========================================================

INSERT INTO users
(
    full_name,
    role
)
VALUES
(
    'EPSM Administrator',
    'ADMIN'
);

-- ==========================================================
-- OPERATORS
-- Catálogo oficial
-- ==========================================================

INSERT INTO operators
(
    full_name
)
VALUES
('Johan'),
('Genesis'),
('Karin'),
('Ana'),
('Nesly'),
('Polet');

-- ==========================================================
-- PRODUCTS
-- Catálogo oficial
-- ==========================================================

INSERT INTO products
(
    legacy_id,
    code,
    name,
    grammage_g
)
VALUES
(1,  'P001', 'XXL 60cm', 1200),
(2,  'P002', 'XL 50cm', 800),
(3,  'P003', 'FAMILIARES DELGADAS 38cm', 290),
(4,  'P004', 'MEDIANAS DELGADAS 33cm', 220),
(5,  'P005', 'FANTA FAMILIARES 38cm', 390),
(6,  'P006', 'FANTA MEDIANAS 25cm', 290),
(7,  'P007', 'HAPPYLAND FAMILIARES 38cm', 500),
(8,  'P008', 'BOLLOS 370 g', 370),
(9,  'P009', 'BOLLOS 290 g', 290),
(10, 'P010', 'BOLLOS 250 g', 250),
(11, 'P011', 'BOLLOS 230 g', 230),
(12, 'P012', 'BOLLOS 220 g', 220),
(13, 'P013', 'BOLLOS 180 g', 180),
(14, 'P014', 'BOLLOS 160 g', 160),
(15, 'P015', 'FAMILIARES GRUESAS 38cm', 360),
(16, 'P016', 'MEDIANAS GRUESAS 33cm', 290),
(17, 'P017', 'RECTANGULAR 20x30cm', 220),
(18, 'P018', 'RECTANGULAR G 20x35cm', 360),
(19, 'P019', 'RECTANGULAR D 25x35cm', 250),
(20, 'P020', 'INDIVIDUAL D18 HAPPY/FANTA', 150),
(21, 'P021', 'INDIVIDUAL 25cm', 150),
(22, 'P022', 'INDIVIDUAL 27cm HORNITO', 180),
(23, 'P023', 'PIZZETAS / FOCACCINE', 50),
(24, 'P024', 'MASA PALA RECT. 30x20cm', 250),
(25, 'P025', 'FAMILIAR CON BORDE', 400),
(26, 'P026', 'FOCACCIA REDONDA 30cm', 500),
(27, 'P027', 'FOCACCIA 60x40cm', 1200);

COMMIT;