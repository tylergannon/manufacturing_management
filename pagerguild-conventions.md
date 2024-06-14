# Database Schema Conventions

## 1. General Principles

- **Consistency**: Apply naming conventions consistently across the database schema.
- **Readability**: Names should be intuitive and descriptive, favoring clarity over brevity.
- **Singular vs. Plurality**: Favor singular names for tables and views.
- **Case Sensitivity**: Use snake_case for identifiers (tables, columns, functions, etc.) to avoid case sensitivity issues.
- **Abbreviations**: Avoid abbreviations unless they are well-known (e.g., `id` for identifier, `qty` for quantity).
- **Prefixes and Suffixes**: Use prefixes or suffixes where appropriate to convey the type or purpose of a table or column (e.g., `is_`, `has_` for booleans).

## 2. Naming Conventions

### Tables

- Use singular, descriptive names (e.g., `user`, `invoice_line`).
- For join tables, combine the names of
  the involved tables (e.g., `user_role` for a table joining `user` and `role`).

### Columns

- Column names should be descriptive and in snake_case (e.g., `first_name`, `email_address`).
- Primary keys should be named `id` or `<table_name>_id` for clarity.
- Foreign keys should reference the primary table and key (e.g., `user_id` in a table referencing the `user` table's `id`).
- Boolean columns should have prefix `is_` or `has_` to indicate state (e.g., `is_active`, `has_attachments`).
- Timestamp columns should include a suffix to indicate their nature (e.g., `created_at`, `updated_at`).

### Indexes

- Follow a naming convention that includes the table name, column(s) name(s), and the index type (e.g., `idx_<table_name>_<column_name>` for a simple B-tree index).
- For composite indexes, include the names of the key columns (e.g., `idx_user_role_user_id_role_id` for an index on `user_id` and `role_id` in the `user_role` table).

### Data Types

- **Integers**: Choose the appropriate size (`smallint`, `integer`, `bigint`) based on the expected range of values.
- **Decimals**: Use `numeric` with specified precision for fixed-point numbers where exactness is crucial (e.g., monetary values), and `real` or `double precision` for floating-point numbers where performance is more critical than precision.
- **Textual data**: Use `text` for strings without a fixed size, and `char(n)` or `varchar(n)` for strings with expected maximum lengths.
- **Booleans**: Use `boolean` for true/false values, preferring descriptive names and utilizing them to avoid nullable boolean columns.
- **Date and time**: Use `timestamp` with or without time zone depending on the application need (usually without time zone, storing UTC); use `date` where only a date is required.
- **Arrays & JSON**: Use array types or `json`/`jsonb` judiciously, where the use case specifically benefits from their versatility (e.g., storing dynamic attributes).

## 3. Constraints

- Name constraints explicitly to make error messages easier to understand.
- Use a standardized format that includes the table name, column name, and constraint type (e.g., `chk_user_age_positive` for a check constraint on the user's age to be positive, `fk_post_user_id` for a foreign key on `post.user_id`).

## 4. Views and Materialized Views

- Prefix view names with `v_` and materialized views with `mv_` to differentiate them from tables and to indicate their nature at a glance (e.g., `v_active_users`, `mv_monthly_sales`).

## 5. Functions and Stored Procedures

- Use descriptive verb phrases that clearly indicate the function's action (e.g., `calculate_order_total`, `get_active_users`).
- Include parameter types in the name only if necessary to distinguish overloaded functions.
