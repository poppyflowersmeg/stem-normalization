# Project Instructions

## Local Database Access

psql is not installed locally. Always use `docker exec` to run SQL against the local Supabase database:

```bash
docker exec -i supabase_db_stem-normalization psql -U postgres -d postgres -c "SELECT ..."
```

To run a SQL file:
```bash
docker exec -i supabase_db_stem-normalization psql -U postgres -d postgres < path/to/file.sql
```
