## Table `operators`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `full_name` | `text` |  Unique |
| `role` | `text` |  |
| `active` | `bool` |  |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |

## Table `shifts`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `name` | `text` |  Unique |
| `active` | `bool` |  |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |

## Table `recipes`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `recipe_type` | `text` |  |
| `display_name` | `text` |  Unique |
| `is_standard` | `bool` |  |
| `default_flour_g` | `int4` |  |
| `default_water_g` | `int4` |  |
| `default_other_ingredients_g` | `int4` |  |
| `default_total_weight_g` | `int4` |  |
| `active` | `bool` |  |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |
| `auto_calculate` | `bool` |  Nullable |
| `fixed_extra_weight_g` | `int4` |  Nullable |
| `default_initial_weight_g` | `int4` |  Nullable |
| `show_initial_weight` | `bool` |  Nullable |
| `version` | `int4` |  |

## Table `products`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `legacy_id` | `int4` |  Unique |
| `code` | `text` |  Unique |
| `name` | `text` |  |
| `grammage_g` | `int4` |  |
| `active` | `bool` |  |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |

## Table `settings`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `category` | `text` |  |
| `key` | `text` |  Unique |
| `value` | `text` |  |
| `data_type` | `text` |  |
| `description` | `text` |  Nullable |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |

## Table `dough_batches`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `production_date` | `date` |  |
| `shift_id` | `uuid` |  |
| `recipe_id` | `uuid` |  |
| `initial_weight_g` | `int4` |  |
| `leftover_added_g` | `int4` |  |
| `total_weight_g` | `int4` |  Nullable |
| `leftover_remaining_g` | `int4` |  |
| `notes` | `text` |  Nullable |
| `status` | `text` |  |
| `created_by` | `uuid` |  Nullable |
| `updated_by` | `uuid` |  Nullable |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |
| `other_ingredients_g` | `int4` |  |
| `flour_g` | `int4` |  |
| `water_g` | `int4` |  |
| `standard_dough_count` | `int4` |  |
| `recipe_version` | `int4` |  Nullable |
| `recipe_display_name` | `text` |  Nullable |
| `recipe_type` | `text` |  Nullable |

## Table `production_items`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `batch_id` | `uuid` |  |
| `product_id` | `uuid` |  |
| `quantity` | `int4` |  |
| `notes` | `text` |  Nullable |
| `created_by` | `uuid` |  Nullable |
| `updated_by` | `uuid` |  Nullable |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |
| `product_grammage_g` | `int4` |  |

## Table `audit_log`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `table_name` | `text` |  |
| `record_id` | `uuid` |  |
| `action` | `text` |  |
| `modified_by` | `uuid` |  Nullable |
| `modified_at` | `timestamptz` |  |
| `reason` | `text` |  Nullable |
| `old_values` | `jsonb` |  Nullable |
| `new_values` | `jsonb` |  Nullable |

## Table `reference_ranges`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `id` | `uuid` | Primary |
| `grammage_g` | `int4` |  Unique |
| `min_units` | `int4` |  |
| `max_units` | `int4` |  |

## Table `batch_operators`

### Columns

| Name | Type | Constraints |
|------|------|-------------|
| `batch_id` | `uuid` | Primary |
| `operator_id` | `uuid` | Primary |
| `created_at` | `timestamptz` |  |

