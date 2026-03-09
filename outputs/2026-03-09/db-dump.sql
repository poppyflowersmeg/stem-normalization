--
-- PostgreSQL database dump
--

\restrict cUm8O2QbyNDeMzVOWAaFHlpBQ2ATeOMFQzBiFwEWFkp0iNLonkOMheN0tvapB9T

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: _realtime; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA _realtime;


--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA auth;


--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA extensions;


--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql;


--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql_public;


--
-- Name: pg_net; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_net; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_net IS 'Async HTTP';


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgbouncer;


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA realtime;


--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- Name: supabase_functions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA supabase_functions;


--
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA supabase_migrations;


--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA vault;


--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


--
-- Name: action; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: -
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

    REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
    REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

    GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: -
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
begin
    raise debug 'PgBouncer auth request: %', p_usename;

    return query
    select 
        rolname::text, 
        case when rolvaliduntil < now() 
            then null 
            else rolpassword::text 
        end 
    from pg_authid 
    where rolname=$1 and rolcanlogin;
end;
$_$;


--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


--
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(v_common_prefix, v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


--
-- Name: http_request(); Type: FUNCTION; Schema: supabase_functions; Owner: -
--

CREATE FUNCTION supabase_functions.http_request() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'supabase_functions'
    AS $$
  DECLARE
    request_id bigint;
    payload jsonb;
    url text := TG_ARGV[0]::text;
    method text := TG_ARGV[1]::text;
    headers jsonb DEFAULT '{}'::jsonb;
    params jsonb DEFAULT '{}'::jsonb;
    timeout_ms integer DEFAULT 1000;
  BEGIN
    IF url IS NULL OR url = 'null' THEN
      RAISE EXCEPTION 'url argument is missing';
    END IF;

    IF method IS NULL OR method = 'null' THEN
      RAISE EXCEPTION 'method argument is missing';
    END IF;

    IF TG_ARGV[2] IS NULL OR TG_ARGV[2] = 'null' THEN
      headers = '{"Content-Type": "application/json"}'::jsonb;
    ELSE
      headers = TG_ARGV[2]::jsonb;
    END IF;

    IF TG_ARGV[3] IS NULL OR TG_ARGV[3] = 'null' THEN
      params = '{}'::jsonb;
    ELSE
      params = TG_ARGV[3]::jsonb;
    END IF;

    IF TG_ARGV[4] IS NULL OR TG_ARGV[4] = 'null' THEN
      timeout_ms = 1000;
    ELSE
      timeout_ms = TG_ARGV[4]::integer;
    END IF;

    CASE
      WHEN method = 'GET' THEN
        SELECT http_get INTO request_id FROM net.http_get(
          url,
          params,
          headers,
          timeout_ms
        );
      WHEN method = 'POST' THEN
        payload = jsonb_build_object(
          'old_record', OLD,
          'record', NEW,
          'type', TG_OP,
          'table', TG_TABLE_NAME,
          'schema', TG_TABLE_SCHEMA
        );

        SELECT http_post INTO request_id FROM net.http_post(
          url,
          payload,
          params,
          headers,
          timeout_ms
        );
      ELSE
        RAISE EXCEPTION 'method argument % is invalid', method;
    END CASE;

    INSERT INTO supabase_functions.hooks
      (hook_table_id, hook_name, request_id)
    VALUES
      (TG_RELID, TG_NAME, request_id);

    RETURN NEW;
  END
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: extensions; Type: TABLE; Schema: _realtime; Owner: -
--

CREATE TABLE _realtime.extensions (
    id uuid NOT NULL,
    type text,
    settings jsonb,
    tenant_external_id text,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: _realtime; Owner: -
--

CREATE TABLE _realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: tenants; Type: TABLE; Schema: _realtime; Owner: -
--

CREATE TABLE _realtime.tenants (
    id uuid NOT NULL,
    name text,
    external_id text,
    jwt_secret text,
    max_concurrent_users integer DEFAULT 200 NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    max_events_per_second integer DEFAULT 100 NOT NULL,
    postgres_cdc_default text DEFAULT 'postgres_cdc_rls'::text,
    max_bytes_per_second integer DEFAULT 100000 NOT NULL,
    max_channels_per_client integer DEFAULT 100 NOT NULL,
    max_joins_per_second integer DEFAULT 500 NOT NULL,
    suspend boolean DEFAULT false,
    jwt_jwks jsonb,
    notify_private_alpha boolean DEFAULT false,
    private_only boolean DEFAULT false NOT NULL,
    migrations_ran integer DEFAULT 0,
    broadcast_adapter character varying(255) DEFAULT 'gen_rpc'::character varying,
    max_presence_events_per_second integer DEFAULT 1000,
    max_payload_size_in_kb integer DEFAULT 3000,
    CONSTRAINT jwt_secret_or_jwt_jwks_required CHECK (((jwt_secret IS NOT NULL) OR (jwt_jwks IS NOT NULL)))
);


--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: -
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: -
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: color_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.color_categories (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    hex_code character varying(7),
    sort_order integer,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: color_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.color_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: color_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.color_categories_id_seq OWNED BY public.color_categories.id;


--
-- Name: lengths; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lengths (
    id integer NOT NULL,
    cm integer NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: lengths_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lengths_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lengths_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lengths_id_seq OWNED BY public.lengths.id;


--
-- Name: product_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_items (
    id integer NOT NULL,
    stem_id integer NOT NULL,
    vendor_id integer NOT NULL,
    stem_variety_id integer,
    stem_length_id integer,
    product_item_name character varying(255) NOT NULL,
    vendor_sku character varying(50),
    created_at timestamp with time zone DEFAULT now(),
    variety_color_category_id integer
);


--
-- Name: product_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_items_id_seq OWNED BY public.product_items.id;


--
-- Name: stem_lengths; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stem_lengths (
    id integer NOT NULL,
    stem_id integer NOT NULL,
    length_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: stem_lengths_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stem_lengths_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stem_lengths_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stem_lengths_id_seq OWNED BY public.stem_lengths.id;


--
-- Name: stem_varieties; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stem_varieties (
    id integer NOT NULL,
    stem_id integer NOT NULL,
    variety_id integer NOT NULL,
    legacy_stem_id integer,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: stem_varieties_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stem_varieties_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stem_varieties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stem_varieties_id_seq OWNED BY public.stem_varieties.id;


--
-- Name: stems; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stems (
    id integer NOT NULL,
    stem_category character varying(100) NOT NULL,
    stem_subcategory character varying(100),
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: stems_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stems_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stems_id_seq OWNED BY public.stems.id;


--
-- Name: varieties; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.varieties (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: varieties_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.varieties_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: varieties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.varieties_id_seq OWNED BY public.varieties.id;


--
-- Name: variety_color_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.variety_color_categories (
    id integer NOT NULL,
    variety_id integer NOT NULL,
    color_type character varying(20) NOT NULL,
    primary_color_category_id integer NOT NULL,
    secondary_color_category_id integer,
    bicolor_type character varying(30),
    secondary_color_searchable boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT check_bicolor_has_secondary CHECK (((((color_type)::text = 'single'::text) AND (secondary_color_category_id IS NULL) AND (bicolor_type IS NULL)) OR (((color_type)::text = 'bicolor'::text) AND (secondary_color_category_id IS NOT NULL) AND (bicolor_type IS NOT NULL)))),
    CONSTRAINT variety_color_categories_bicolor_type_check CHECK (((bicolor_type)::text = ANY ((ARRAY['variegated'::character varying, 'fade'::character varying, 'tipped'::character varying, 'striped'::character varying])::text[]))),
    CONSTRAINT variety_color_categories_color_type_check CHECK (((color_type)::text = ANY ((ARRAY['single'::character varying, 'bicolor'::character varying])::text[])))
);


--
-- Name: variety_color_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.variety_color_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: variety_color_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.variety_color_categories_id_seq OWNED BY public.variety_color_categories.id;


--
-- Name: vendor_locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vendor_locations (
    id integer NOT NULL,
    vendor_id integer NOT NULL,
    location_name character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: vendor_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vendor_locations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vendor_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vendor_locations_id_seq OWNED BY public.vendor_locations.id;


--
-- Name: vendors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vendors (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    vendor_type character varying(20) NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT vendors_vendor_type_check CHECK (((vendor_type)::text = ANY ((ARRAY['farm'::character varying, 'wholesaler'::character varying])::text[])))
);


--
-- Name: vendors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vendors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vendors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vendors_id_seq OWNED BY public.vendors.id;


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


--
-- Name: messages_2026_03_07; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_03_07 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages_2026_03_08; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_03_08 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages_2026_03_09; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_03_09 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages_2026_03_10; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_03_10 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages_2026_03_11; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2026_03_11 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: -
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: iceberg_namespaces; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.iceberg_namespaces (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_name text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    catalog_id uuid NOT NULL
);


--
-- Name: iceberg_tables; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.iceberg_tables (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    namespace_id uuid NOT NULL,
    bucket_name text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    location text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    remote_table_id text,
    shard_key text,
    shard_id text,
    catalog_id uuid NOT NULL
);


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: objects; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: hooks; Type: TABLE; Schema: supabase_functions; Owner: -
--

CREATE TABLE supabase_functions.hooks (
    id bigint NOT NULL,
    hook_table_id integer NOT NULL,
    hook_name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    request_id bigint
);


--
-- Name: TABLE hooks; Type: COMMENT; Schema: supabase_functions; Owner: -
--

COMMENT ON TABLE supabase_functions.hooks IS 'Supabase Functions Hooks: Audit trail for triggered hooks.';


--
-- Name: hooks_id_seq; Type: SEQUENCE; Schema: supabase_functions; Owner: -
--

CREATE SEQUENCE supabase_functions.hooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hooks_id_seq; Type: SEQUENCE OWNED BY; Schema: supabase_functions; Owner: -
--

ALTER SEQUENCE supabase_functions.hooks_id_seq OWNED BY supabase_functions.hooks.id;


--
-- Name: migrations; Type: TABLE; Schema: supabase_functions; Owner: -
--

CREATE TABLE supabase_functions.migrations (
    version text NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: supabase_migrations; Owner: -
--

CREATE TABLE supabase_migrations.schema_migrations (
    version text NOT NULL,
    statements text[],
    name text
);


--
-- Name: seed_files; Type: TABLE; Schema: supabase_migrations; Owner: -
--

CREATE TABLE supabase_migrations.seed_files (
    path text NOT NULL,
    hash text NOT NULL
);


--
-- Name: messages_2026_03_07; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_07 FOR VALUES FROM ('2026-03-07 00:00:00') TO ('2026-03-08 00:00:00');


--
-- Name: messages_2026_03_08; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_08 FOR VALUES FROM ('2026-03-08 00:00:00') TO ('2026-03-09 00:00:00');


--
-- Name: messages_2026_03_09; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_09 FOR VALUES FROM ('2026-03-09 00:00:00') TO ('2026-03-10 00:00:00');


--
-- Name: messages_2026_03_10; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_10 FOR VALUES FROM ('2026-03-10 00:00:00') TO ('2026-03-11 00:00:00');


--
-- Name: messages_2026_03_11; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_11 FOR VALUES FROM ('2026-03-11 00:00:00') TO ('2026-03-12 00:00:00');


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: color_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.color_categories ALTER COLUMN id SET DEFAULT nextval('public.color_categories_id_seq'::regclass);


--
-- Name: lengths id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lengths ALTER COLUMN id SET DEFAULT nextval('public.lengths_id_seq'::regclass);


--
-- Name: product_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_items ALTER COLUMN id SET DEFAULT nextval('public.product_items_id_seq'::regclass);


--
-- Name: stem_lengths id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stem_lengths ALTER COLUMN id SET DEFAULT nextval('public.stem_lengths_id_seq'::regclass);


--
-- Name: stem_varieties id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stem_varieties ALTER COLUMN id SET DEFAULT nextval('public.stem_varieties_id_seq'::regclass);


--
-- Name: stems id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stems ALTER COLUMN id SET DEFAULT nextval('public.stems_id_seq'::regclass);


--
-- Name: varieties id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.varieties ALTER COLUMN id SET DEFAULT nextval('public.varieties_id_seq'::regclass);


--
-- Name: variety_color_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.variety_color_categories ALTER COLUMN id SET DEFAULT nextval('public.variety_color_categories_id_seq'::regclass);


--
-- Name: vendor_locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_locations ALTER COLUMN id SET DEFAULT nextval('public.vendor_locations_id_seq'::regclass);


--
-- Name: vendors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendors ALTER COLUMN id SET DEFAULT nextval('public.vendors_id_seq'::regclass);


--
-- Name: hooks id; Type: DEFAULT; Schema: supabase_functions; Owner: -
--

ALTER TABLE ONLY supabase_functions.hooks ALTER COLUMN id SET DEFAULT nextval('supabase_functions.hooks_id_seq'::regclass);


--
-- Data for Name: extensions; Type: TABLE DATA; Schema: _realtime; Owner: -
--

COPY _realtime.extensions (id, type, settings, tenant_external_id, inserted_at, updated_at) FROM stdin;
a7809188-aa9b-4d4a-8500-c63ce99bc8b2	postgres_cdc_rls	{"region": "us-east-1", "db_host": "y4CDOs7U6Y2asrIXRvaiKgiULfukApVYyWHO58k6lIc=", "db_name": "sWBpZNdjggEPTQVlI52Zfw==", "db_port": "+enMDFi1J/3IrrquHHwUmA==", "db_user": "uxbEq/zz8DXVD53TOI1zmw==", "slot_name": "supabase_realtime_replication_slot", "db_password": "sWBpZNdjggEPTQVlI52Zfw==", "publication": "supabase_realtime", "ssl_enforced": false, "poll_interval_ms": 100, "poll_max_changes": 100, "poll_max_record_bytes": 1048576}	realtime-dev	2026-03-08 22:33:42	2026-03-08 22:33:42
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: _realtime; Owner: -
--

COPY _realtime.schema_migrations (version, inserted_at) FROM stdin;
20210706140551	2026-03-08 22:33:28
20220329161857	2026-03-08 22:33:28
20220410212326	2026-03-08 22:33:28
20220506102948	2026-03-08 22:33:28
20220527210857	2026-03-08 22:33:28
20220815211129	2026-03-08 22:33:28
20220815215024	2026-03-08 22:33:28
20220818141501	2026-03-08 22:33:28
20221018173709	2026-03-08 22:33:28
20221102172703	2026-03-08 22:33:28
20221223010058	2026-03-08 22:33:28
20230110180046	2026-03-08 22:33:28
20230810220907	2026-03-08 22:33:28
20230810220924	2026-03-08 22:33:28
20231024094642	2026-03-08 22:33:28
20240306114423	2026-03-08 22:33:28
20240418082835	2026-03-08 22:33:28
20240625211759	2026-03-08 22:33:28
20240704172020	2026-03-08 22:33:28
20240902173232	2026-03-08 22:33:28
20241106103258	2026-03-08 22:33:28
20250424203323	2026-03-08 22:33:28
20250613072131	2026-03-08 22:33:28
20250711044927	2026-03-08 22:33:28
20250811121559	2026-03-08 22:33:28
20250926223044	2026-03-08 22:33:28
20251204170944	2026-03-08 22:33:28
20251218000543	2026-03-08 22:33:28
\.


--
-- Data for Name: tenants; Type: TABLE DATA; Schema: _realtime; Owner: -
--

COPY _realtime.tenants (id, name, external_id, jwt_secret, max_concurrent_users, inserted_at, updated_at, max_events_per_second, postgres_cdc_default, max_bytes_per_second, max_channels_per_client, max_joins_per_second, suspend, jwt_jwks, notify_private_alpha, private_only, migrations_ran, broadcast_adapter, max_presence_events_per_second, max_payload_size_in_kb) FROM stdin;
cd81d810-cf04-4cb5-b881-1b2290c145d4	realtime-dev	realtime-dev	iNjicxc4+llvc9wovDvqymwfnj9teWMlyOIbJ8Fh6j2WNU8CIJ2ZgjR6MUIKqSmeDmvpsKLsZ9jgXJmQPpwL8w==	200	2026-03-08 22:33:42	2026-03-08 22:33:42	100	postgres_cdc_rls	100000	100	100	f	{"keys": [{"x": "M5Sjqn5zwC9Kl1zVfUUGvv9boQjCGd45G8sdopBExB4", "y": "P6IXMvA2WYXSHSOMTBH2jsw_9rrzGy89FjPf6oOsIxQ", "alg": "ES256", "crv": "P-256", "ext": true, "kid": "b81269f1-21d8-4f2e-b719-c2240a840d90", "kty": "EC", "use": "sig", "key_ops": ["verify"]}, {"k": "c3VwZXItc2VjcmV0LWp3dC10b2tlbi13aXRoLWF0LWxlYXN0LTMyLWNoYXJhY3RlcnMtbG9uZw", "kty": "oct"}]}	f	f	65	gen_rpc	1000	3000
\.


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
\.


--
-- Data for Name: color_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.color_categories (id, name, hex_code, sort_order, created_at) FROM stdin;
1	white	\N	1	2026-03-08 22:33:38.888532+00
2	cream	\N	2	2026-03-08 22:33:38.888532+00
3	tan	\N	3	2026-03-08 22:33:38.888532+00
4	light yellow	\N	4	2026-03-08 22:33:38.888532+00
5	yellow	\N	5	2026-03-08 22:33:38.888532+00
6	dark yellow	\N	6	2026-03-08 22:33:38.888532+00
7	peach	\N	7	2026-03-08 22:33:38.888532+00
8	blush	\N	8	2026-03-08 22:33:38.888532+00
9	light pink	\N	9	2026-03-08 22:33:38.888532+00
10	coral	\N	10	2026-03-08 22:33:38.888532+00
11	orange	\N	11	2026-03-08 22:33:38.888532+00
12	terracotta	\N	12	2026-03-08 22:33:38.888532+00
13	rust	\N	13	2026-03-08 22:33:38.888532+00
14	red	\N	14	2026-03-08 22:33:38.888532+00
15	pink	\N	15	2026-03-08 22:33:38.888532+00
16	hot pink	\N	16	2026-03-08 22:33:38.888532+00
17	mauve	\N	17	2026-03-08 22:33:38.888532+00
18	burgundy	\N	18	2026-03-08 22:33:38.888532+00
19	berry	\N	19	2026-03-08 22:33:38.888532+00
20	plum	\N	20	2026-03-08 22:33:38.888532+00
21	lavender	\N	21	2026-03-08 22:33:38.888532+00
22	purple	\N	22	2026-03-08 22:33:38.888532+00
23	eggplant	\N	23	2026-03-08 22:33:38.888532+00
24	sage	\N	24	2026-03-08 22:33:38.888532+00
25	dark green	\N	25	2026-03-08 22:33:38.888532+00
26	light blue	\N	26	2026-03-08 22:33:38.888532+00
27	blue	\N	27	2026-03-08 22:33:38.888532+00
28	gray	\N	28	2026-03-08 22:33:38.888532+00
29	dark brown	\N	29	2026-03-08 22:33:38.888532+00
30	lime green	\N	30	2026-03-08 22:33:38.888532+00
\.


--
-- Data for Name: lengths; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.lengths (id, cm, created_at) FROM stdin;
1	40	2026-03-08 22:33:38.888532+00
2	50	2026-03-08 22:33:38.888532+00
3	60	2026-03-08 22:33:38.888532+00
4	70	2026-03-08 22:33:38.888532+00
5	80	2026-03-08 22:33:38.888532+00
6	90	2026-03-08 22:33:38.888532+00
7	100	2026-03-08 22:33:38.888532+00
\.


--
-- Data for Name: product_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_items (id, stem_id, vendor_id, stem_variety_id, stem_length_id, product_item_name, vendor_sku, created_at, variety_color_category_id) FROM stdin;
1	1	2	1	\N	Red Delirium Rose	\N	2026-03-08 22:37:17.847215+00	1
2	1	2	2	\N	Red Freedom Rose	\N	2026-03-08 22:37:17.849793+00	2
3	1	2	3	\N	Red Hearts Rose	\N	2026-03-08 22:37:17.851542+00	3
4	4	2	4	\N	Red Mayra Red Rose	\N	2026-03-08 22:37:17.853822+00	4
5	1	2	5	\N	Red Mamma Mia Rose	\N	2026-03-08 22:37:17.856121+00	5
6	4	2	6	\N	Red Red Eye Rose	\N	2026-03-08 22:37:17.857261+00	6
7	1	2	7	\N	White Akito Rose	\N	2026-03-08 22:37:17.859519+00	7
8	1	2	8	\N	White Candlelight Rose	\N	2026-03-08 22:37:17.860084+00	8
9	1	2	9	\N	White Escimo Rose	\N	2026-03-08 22:37:17.861751+00	9
10	1	2	10	\N	White Mondial Rose	\N	2026-03-08 22:37:17.863287+00	10
11	1	2	11	\N	White Moonstone Rose	\N	2026-03-08 22:37:17.864253+00	11
12	1	2	12	\N	White Playa Blanca Rose	\N	2026-03-08 22:37:17.864819+00	12
13	4	2	13	\N	White Cotton X-Pression Rose	\N	2026-03-08 22:37:17.867109+00	13
14	4	2	14	\N	White Creamykiss Rose	\N	2026-03-08 22:37:17.869614+00	14
15	4	2	15	\N	White Mayra White Rose	\N	2026-03-08 22:37:17.871779+00	15
16	4	2	16	\N	White Starwalker Rose	\N	2026-03-08 22:37:17.873215+00	16
17	1	2	17	\N	White Sugar Doll Rose	\N	2026-03-08 22:37:17.873826+00	17
18	1	2	18	\N	White Tibet Rose	\N	2026-03-08 22:37:17.874426+00	18
19	1	2	19	\N	White Vendela Rose	\N	2026-03-08 22:37:17.875098+00	19
20	4	2	20	\N	White White O'Hara Rose	\N	2026-03-08 22:37:17.875671+00	20
21	1	2	21	\N	Bicolor White - Pink Paloma Rose	\N	2026-03-08 22:37:17.876397+00	21
22	1	2	22	\N	Bicolor White - Pink Magic Times Rose	\N	2026-03-08 22:37:17.87717+00	22
23	1	2	23	\N	Bicolor White - Hot Pink Sweetness Rose	\N	2026-03-08 22:37:17.877909+00	23
24	1	2	24	\N	Bicolor Pink - Hot Pink Lady Amira Rose	\N	2026-03-08 22:37:17.880683+00	24
25	1	2	25	\N	Medium Pink Sweet Unique Rose	\N	2026-03-08 22:37:17.88148+00	25
26	1	2	26	\N	Light Pink Christa Rose	\N	2026-03-08 22:37:17.882273+00	26
27	1	2	27	\N	Light Pink Flirty Rose	\N	2026-03-08 22:37:17.883007+00	27
28	1	2	28	\N	Light Pink Country Secret Rose	\N	2026-03-08 22:37:17.883746+00	28
29	1	2	29	\N	Light Pink Frutteto Rose	\N	2026-03-08 22:37:17.884463+00	29
30	1	2	30	\N	Light Pink Luciano Rose	\N	2026-03-08 22:37:17.885216+00	30
31	1	2	31	\N	Light Pink Pink Mondial Rose	\N	2026-03-08 22:37:17.886276+00	31
32	4	2	32	\N	Light Pink Pink O'Hara Rose	\N	2026-03-08 22:37:17.887447+00	32
33	4	2	33	\N	Light Pink Pink X-Pression Rose	\N	2026-03-08 22:37:17.888264+00	33
34	1	2	34	\N	Light Pink Sophie Rose	\N	2026-03-08 22:37:17.889051+00	34
35	1	2	35	\N	Light Pink Sweet Akito Rose	\N	2026-03-08 22:37:17.889881+00	35
36	4	2	36	\N	Pink Candy X-Pression Rose	\N	2026-03-08 22:37:17.890662+00	36
37	1	2	37	\N	Pink Marlysee Rose	\N	2026-03-08 22:37:17.891273+00	37
38	1	2	38	\N	Pink Novia Rose	\N	2026-03-08 22:37:17.891878+00	38
39	1	2	39	\N	Pink Romina Rose	\N	2026-03-08 22:37:17.892888+00	39
40	1	2	40	\N	Pink Saga Rose	\N	2026-03-08 22:37:17.893669+00	40
41	1	2	41	\N	Hot Pink Tina Rose	\N	2026-03-08 22:37:17.894458+00	41
42	1	2	42	\N	Hot Pink Full Monty Rose	\N	2026-03-08 22:37:17.895451+00	42
43	1	2	43	\N	Hot Pink Hot Princess Rose	\N	2026-03-08 22:37:17.89665+00	43
44	1	2	44	\N	Hot Pink Lola Rose	\N	2026-03-08 22:37:17.897482+00	44
45	4	2	45	\N	Hot Pink Mayra Bright Rose	\N	2026-03-08 22:37:17.898215+00	45
46	1	2	46	\N	Hot Pink Pink Floyd Rose	\N	2026-03-08 22:37:17.899071+00	46
47	1	2	47	\N	Hot Pink Pink Love Rose	\N	2026-03-08 22:37:17.899813+00	47
48	1	2	48	\N	Hot Pink Queen Berry Rose	\N	2026-03-08 22:37:17.900687+00	48
49	1	2	49	\N	Hot Pink V.I. Pink Rose	\N	2026-03-08 22:37:17.901387+00	49
50	1	2	50	\N	Orange High Orange Magic Rose	\N	2026-03-08 22:37:17.90209+00	50
51	1	2	51	\N	Orange Hilux Rose	\N	2026-03-08 22:37:17.90277+00	51
52	1	2	52	\N	Orange Lumia Rose	\N	2026-03-08 22:37:17.903511+00	52
53	1	2	53	\N	Orange Nina Rose	\N	2026-03-08 22:37:17.904429+00	53
54	1	2	54	\N	Orange Orange Crush Rose	\N	2026-03-08 22:37:17.905176+00	54
55	1	2	55	\N	Orange Free Spirit Rose	\N	2026-03-08 22:37:17.905956+00	55
56	4	2	56	\N	Orange Aquarelle Rose	\N	2026-03-08 22:37:17.906978+00	56
57	4	2	57	\N	Peach Carpe Diem Rose	\N	2026-03-08 22:37:17.907718+00	57
58	4	2	58	\N	Peach Country Louise Rose	\N	2026-03-08 22:37:17.908411+00	58
59	1	2	59	\N	Peach Kahala Rose	\N	2026-03-08 22:37:17.909112+00	59
60	1	2	60	\N	Peach Phoenix Rose	\N	2026-03-08 22:37:17.909871+00	60
61	4	2	61	\N	Peach Mayra Peach Rose	\N	2026-03-08 22:37:17.910591+00	61
62	4	2	62	\N	Peach Shine On Rose	\N	2026-03-08 22:37:17.911359+00	62
63	1	2	63	\N	Peach Shimmer Rose	\N	2026-03-08 22:37:17.912251+00	63
64	1	2	64	\N	Peach Tiffany Rose	\N	2026-03-08 22:37:17.91346+00	64
65	4	2	65	\N	Cream Country Candy Rose	\N	2026-03-08 22:37:17.91432+00	65
66	1	2	66	\N	Cream Creme De La Creme Rose	\N	2026-03-08 22:37:17.915018+00	66
67	1	2	67	\N	Cream Quicksand Rose	\N	2026-03-08 22:37:17.915706+00	67
68	1	2	68	\N	Cream Soul Rose	\N	2026-03-08 22:37:17.916353+00	68
69	1	2	69	\N	Yellow Brighton Rose	\N	2026-03-08 22:37:17.917161+00	69
70	1	2	70	\N	Yellow Giselle Rose	\N	2026-03-08 22:37:17.917911+00	70
71	1	2	71	\N	Yellow Goldfinch Rose	\N	2026-03-08 22:37:17.918623+00	71
72	1	2	72	\N	Yellow High & Yellow Magic Rose	\N	2026-03-08 22:37:17.919335+00	72
73	1	2	73	\N	Yellow High Exotic Rose	\N	2026-03-08 22:37:17.920239+00	73
74	1	2	74	\N	Yellow King'S Cross Rose	\N	2026-03-08 22:37:17.921183+00	74
75	1	2	75	\N	Yellow Momentum Rose	\N	2026-03-08 22:37:17.921985+00	75
76	1	2	76	\N	Yellow Stardust Rose	\N	2026-03-08 22:37:17.922751+00	76
77	1	2	77	\N	Yellow Summer Romance Rose	\N	2026-03-08 22:37:17.923626+00	77
78	1	2	78	\N	Yellow Super Sun Rose	\N	2026-03-08 22:37:17.924413+00	78
79	1	2	79	\N	Bicolor Yellow - Red High & Magic Rose	\N	2026-03-08 22:37:17.925145+00	79
80	1	2	80	\N	Bicolor Yellow - Red Hot Sauce Rose	\N	2026-03-08 22:37:17.925802+00	80
81	1	2	81	\N	Bicolor Yellow - Orange Silantoi Rose	\N	2026-03-08 22:37:17.926608+00	81
82	4	2	82	\N	Bicolor Yellow - Pink Light Spirit Rose	\N	2026-03-08 22:37:17.927466+00	82
83	1	2	83	\N	Lavender Blue Dream Rose	\N	2026-03-08 22:37:17.928162+00	83
84	1	2	84	\N	Lavender Cool Water Rose	\N	2026-03-08 22:37:17.929331+00	84
85	1	2	85	\N	Lavender Country Blues Rose	\N	2026-03-08 22:37:17.930273+00	85
86	1	2	86	\N	Lavender Deep Purple Rose	\N	2026-03-08 22:37:17.931086+00	86
87	1	2	87	\N	Lavender Moody Blues Rose	\N	2026-03-08 22:37:17.932001+00	87
88	1	2	88	\N	Lavender Ocean Song Rose	\N	2026-03-08 22:37:17.932732+00	88
89	1	2	89	\N	Lavender Queen'S Crown Rose	\N	2026-03-08 22:37:17.93346+00	89
90	1	2	90	\N	Lavender ** Peonikiss** Rose	\N	2026-03-08 22:37:17.934147+00	90
91	1	2	91	\N	Lavender Star Platinum Rose	\N	2026-03-08 22:37:17.934948+00	91
92	1	2	92	\N	Purple Ascot Rose	\N	2026-03-08 22:37:17.935493+00	92
93	1	2	93	\N	Brown Barista Rose	\N	2026-03-08 22:37:17.936046+00	93
94	94	2	94	\N	Tinted novelties	\N	2026-03-08 22:37:17.936539+00	\N
95	94	2	95	\N	Antique	\N	2026-03-08 22:37:17.937119+00	\N
96	94	2	96	\N	Solids	\N	2026-03-08 22:37:17.937776+00	\N
97	94	2	97	\N	Assorted	\N	2026-03-08 22:37:17.938319+00	\N
98	94	2	98	\N	Minicarnations	\N	2026-03-08 22:37:17.938827+00	\N
99	94	2	99	\N	Solids, Assorted & Novelties	\N	2026-03-08 22:37:17.939311+00	\N
100	94	2	100	\N	Florincas	\N	2026-03-08 22:37:17.940606+00	\N
101	94	2	101	\N	Solids & Assorted	\N	2026-03-08 22:37:17.941256+00	\N
102	94	2	102	\N	Gerberas & Gerrondos	\N	2026-03-08 22:37:17.941735+00	\N
103	94	2	103	\N	Solid colors	\N	2026-03-08 22:37:17.942214+00	\N
104	94	2	97	\N	Assorted	\N	2026-03-08 22:37:17.942612+00	\N
105	94	2	105	\N	Minicallas	\N	2026-03-08 22:37:17.943158+00	\N
106	94	2	97	\N	Assorted	\N	2026-03-08 22:37:17.943515+00	\N
107	94	2	107	\N	Solid	\N	2026-03-08 22:37:17.944042+00	\N
108	94	2	108	\N	Lilies	\N	2026-03-08 22:37:17.944626+00	\N
109	94	2	109	\N	Asiatic /LA Hybrids Lilies	\N	2026-03-08 22:37:17.945448+00	\N
110	94	2	110	\N	Oriental	\N	2026-03-08 22:37:17.9463+00	\N
111	94	2	111	\N	Rose Lily	\N	2026-03-08 22:37:17.947011+00	\N
112	94	2	112	\N	Novelty items Colombia	\N	2026-03-08 22:37:17.947571+00	\N
113	94	2	113	\N	Double Spray Stock	\N	2026-03-08 22:37:17.948126+00	\N
114	94	2	114	\N	Aster  (purple & white)	\N	2026-03-08 22:37:17.949147+00	94
115	94	2	115	\N	Aster  (Solidago Golden Glory)	\N	2026-03-08 22:37:17.949866+00	95
116	94	2	116	\N	Dianthus Green Ball	\N	2026-03-08 22:37:17.950588+00	96
117	94	2	117	\N	Dianthus (Amazon, Sweet Williams/Breanthus)	\N	2026-03-08 22:37:17.951163+00	\N
118	94	2	118	\N	Aster Matsumoto	\N	2026-03-08 22:37:17.951708+00	\N
119	94	2	119	\N	Greens (Ruscus, Coccolus, pithosporum)	\N	2026-03-08 22:37:17.952263+00	\N
120	94	2	120	\N	Greens Eucalypthus	\N	2026-03-08 22:37:17.952862+00	\N
121	94	2	121	\N	Hypericum	\N	2026-03-08 22:37:17.953371+00	\N
122	94	2	122	\N	X-lence Gyp	\N	2026-03-08 22:37:17.953865+00	\N
123	94	2	123	\N	Limonium Eversnow	\N	2026-03-08 22:37:17.954402+00	\N
124	94	2	124	\N	Ammimajus /queen anne's lace	\N	2026-03-08 22:37:17.954897+00	\N
125	94	2	125	\N	Sunflowers Pettite Vincent & Sunrich	\N	2026-03-08 22:37:17.955348+00	\N
126	94	2	126	\N	Eryngium Magical Blue	\N	2026-03-08 22:37:17.956034+00	97
127	94	2	127	\N	Veronicas	\N	2026-03-08 22:37:17.956619+00	\N
128	94	2	128	\N	Craspedia	\N	2026-03-08 22:37:17.957078+00	\N
129	94	2	129	\N	Craspedia tinted	\N	2026-03-08 22:37:17.957574+00	\N
130	94	2	130	\N	Spray Delphinium Blue	\N	2026-03-08 22:37:17.958313+00	98
131	94	2	131	\N	Matricaria	\N	2026-03-08 22:37:17.95918+00	\N
132	94	2	132	\N	Statice	\N	2026-03-08 22:37:17.960242+00	\N
133	94	2	133	\N	Lepidium Green Dragon	\N	2026-03-08 22:37:17.961102+00	99
134	94	2	134	\N	Snap Dragon	\N	2026-03-08 22:37:17.961843+00	\N
135	94	2	135	\N	Brassicas	\N	2026-03-08 22:37:17.962381+00	\N
136	94	2	136	\N	Crassulas	\N	2026-03-08 22:37:17.962977+00	\N
137	94	2	137	\N	Ranunculus	\N	2026-03-08 22:37:17.963359+00	\N
138	94	2	97	\N	Assorted	\N	2026-03-08 22:37:17.963661+00	\N
139	94	2	107	\N	Solid	\N	2026-03-08 22:37:17.964036+00	\N
140	94	2	140	\N	Spray Chrysanthemums	\N	2026-03-08 22:37:17.964999+00	\N
141	94	2	141	\N	CDN Assorted or Solids	\N	2026-03-08 22:37:17.965797+00	\N
142	94	2	142	\N	Tinted	\N	2026-03-08 22:37:17.966431+00	\N
143	94	2	143	\N	Disbuds	\N	2026-03-08 22:37:17.966902+00	\N
144	94	2	144	\N	Cremons	\N	2026-03-08 22:37:17.967422+00	\N
145	94	2	145	\N	Tinted Cremons	\N	2026-03-08 22:37:17.9679+00	\N
146	94	2	146	\N	Bombon	\N	2026-03-08 22:37:17.968709+00	\N
147	94	2	147	\N	Hydrangeas USA	\N	2026-03-08 22:37:17.969162+00	\N
148	94	2	148	\N	Mini Green	\N	2026-03-08 22:37:17.969682+00	100
149	94	2	149	\N	Dark Mini / Mini Mohito	\N	2026-03-08 22:37:17.970118+00	\N
150	94	2	150	\N	Classic White	\N	2026-03-08 22:37:17.970904+00	101
151	94	2	150	\N	Classic Blue	\N	2026-03-08 22:37:17.971482+00	102
152	94	2	95	\N	Antique	\N	2026-03-08 22:37:17.971777+00	\N
153	94	2	153	\N	Purple	\N	2026-03-08 22:37:17.97226+00	\N
154	94	2	154	\N	Big Petals	\N	2026-03-08 22:37:17.972663+00	\N
155	94	2	142	\N	Tinted	\N	2026-03-08 22:37:17.972894+00	\N
156	94	2	156	\N	Tinted Special	\N	2026-03-08 22:37:17.973279+00	\N
157	94	2	157	\N	Precios con fresh liner incluido / \nOpcion2: Papel & Waterbag - +0,05/tallo	\N	2026-03-08 22:37:17.97367+00	\N
158	158	1	158	\N	Acacia Knifeblade	G1203	2026-03-08 22:37:17.976095+00	\N
159	158	1	159	\N	Acacia Pearl	G2037	2026-03-08 22:37:17.976478+00	\N
160	158	1	\N	\N	Acacia Purple Fernleaf	G1365	2026-03-08 22:37:17.976672+00	\N
161	158	1	160	\N	Acacia Mimosa Ylw 150g It/Fr	38986	2026-03-08 22:37:17.977046+00	\N
162	158	1	161	\N	Acacia Mimosa Ylw 200g It/Fr	22009	2026-03-08 22:37:17.977407+00	\N
163	163	1	162	\N	Allium Prp Gladiator Dutch	26179	2026-03-08 22:37:17.978043+00	\N
164	164	1	\N	\N	Amaranthus - Hanging Bronze	\N	2026-03-08 22:37:17.978305+00	\N
165	164	1	\N	\N	Amaranthus - Hanging Coral	35473	2026-03-08 22:37:17.978485+00	\N
166	164	1	\N	\N	Amaranthus Bronze Mira	10491	2026-03-08 22:37:17.978711+00	\N
167	164	1	\N	\N	Amaranthus- Green Upright - Short	27757	2026-03-08 22:37:17.978875+00	\N
168	164	1	\N	\N	Amaranthus- Red Upright - Short	\N	2026-03-08 22:37:17.979036+00	\N
169	164	1	\N	\N	Amaranthus- Upright Hot Biscuits	12146	2026-03-08 22:37:17.979181+00	\N
170	164	1	\N	\N	Amaranthus- Upright Red Velvet	\N	2026-03-08 22:37:17.979371+00	\N
171	164	1	\N	\N	Amaranthus Hanging Green	25240	2026-03-08 22:37:17.979535+00	\N
172	164	1	\N	\N	Amaranthus Hanging Red	25229	2026-03-08 22:37:17.979774+00	\N
173	173	1	\N	\N	Anemone Levante 40cm - White	48347	2026-03-08 22:37:17.980269+00	\N
174	173	1	\N	\N	Anemone Mistral Blue	\N	2026-03-08 22:37:17.980426+00	\N
175	173	1	\N	\N	Anemone Mistral Blush	\N	2026-03-08 22:37:17.980629+00	\N
176	173	1	\N	\N	Anemone Mistral Burgundy	\N	2026-03-08 22:37:17.98088+00	\N
177	173	1	\N	\N	Anemone Red	47598	2026-03-08 22:37:17.981119+00	\N
178	173	1	\N	\N	Anemone Mistral Soft Purple	\N	2026-03-08 22:37:17.981381+00	\N
179	173	1	\N	\N	Anemone Mistral White	\N	2026-03-08 22:37:17.981545+00	\N
180	173	1	\N	\N	Anemone Tiger Blue	45244	2026-03-08 22:37:17.983054+00	\N
181	173	1	\N	\N	Anemone Purple Canada	45247	2026-03-08 22:37:17.983291+00	\N
182	182	1	\N	\N	Anthurium Coral - Sante MED	\N	2026-03-08 22:37:17.983588+00	\N
183	182	1	\N	\N	Anthurium Dark Red - Choco LG	\N	2026-03-08 22:37:17.984577+00	\N
184	182	1	\N	\N	Anthurium Green - Midori - MED	\N	2026-03-08 22:37:17.984769+00	\N
185	182	1	\N	\N	Anthurium White - Acropolis - LG	\N	2026-03-08 22:37:17.984901+00	\N
186	182	1	\N	\N	Anthurium White - Acropolis - MED	\N	2026-03-08 22:37:17.98509+00	\N
187	182	1	163	\N	Anthurium Assorted Medium 15pk	36213	2026-03-08 22:37:17.98551+00	\N
188	182	1	164	\N	Anthurium Blush Maui Bride 10p	10025	2026-03-08 22:37:17.986906+00	103
189	182	1	165	\N	Anthurium Orange Medium 10pk	17364	2026-03-08 22:37:17.987998+00	104
190	182	1	166	\N	Anthurium Purple Tulip Med 10p	31387	2026-03-08 22:37:17.989397+00	105
191	182	1	167	\N	Anthurium Red Dark Large 10pk	34254	2026-03-08 22:37:17.991436+00	106
192	182	1	168	\N	Anthurium Red Dark Medium 10pk	37926	2026-03-08 22:37:17.994101+00	107
193	182	1	169	\N	Anthurium Red Dark Small 15pk	30180	2026-03-08 22:37:17.99635+00	108
194	182	1	170	\N	Anthurium Red Large Haw. 10pk	46412	2026-03-08 22:37:17.9991+00	109
195	182	1	165	\N	Anthurium Red Medium 10pk	33255	2026-03-08 22:37:18.001548+00	110
196	182	1	172	\N	Anthurium Red Small 15pk	31455	2026-03-08 22:37:18.004358+00	111
197	182	1	165	\N	Anthurium White Large 10pk	10074	2026-03-08 22:37:18.007157+00	112
198	182	1	165	\N	Anthurium White Medium 10pk	10075	2026-03-08 22:37:18.007667+00	112
199	182	1	\N	\N	Anthurium Burgundy Medium	48218	2026-03-08 22:37:18.010169+00	\N
200	182	1	\N	\N	Anthurium Green Large	48313	2026-03-08 22:37:18.010476+00	\N
201	182	1	\N	\N	Anthurium Green Small	48312	2026-03-08 22:37:18.012298+00	\N
202	182	1	\N	\N	Anthurium Peach Medium	17367	2026-03-08 22:37:18.01265+00	\N
203	182	1	\N	\N	Anthurium White Small	34084	2026-03-08 22:37:18.012965+00	\N
204	204	1	\N	\N	Aster - Purple Monarch	\N	2026-03-08 22:37:18.014273+00	\N
205	204	1	\N	\N	Aster - White Chelsea	\N	2026-03-08 22:37:18.01448+00	\N
206	204	1	\N	\N	Aster Lavender -Isabella	\N	2026-03-08 22:37:18.014661+00	\N
207	204	1	175	\N	Aster Assorted Mardi Gras 10pk	31190	2026-03-08 22:37:18.017803+00	\N
208	204	1	176	\N	Aster Asst Carnival Duplo Cs8	29751	2026-03-08 22:37:18.018505+00	\N
209	204	1	177	\N	Aster Crm Estelle Solidago 5pk	58956	2026-03-08 22:37:18.020099+00	\N
210	204	1	178	\N	Aster Matsumoto Pink Hot 10st	29692	2026-03-08 22:37:18.022242+00	\N
211	204	1	179	\N	Aster Matsumoto Pink Light 10s	29693	2026-03-08 22:37:18.022665+00	\N
212	204	1	180	\N	Aster Matsumoto Red 10st	29698	2026-03-08 22:37:18.023051+00	\N
213	204	1	181	\N	Aster Matsumoto White 10st	29697	2026-03-08 22:37:18.025242+00	\N
214	204	1	\N	\N	Aster Purple	20530	2026-03-08 22:37:18.025475+00	\N
215	204	1	182	\N	Aster Purple Mardi Gras	26404	2026-03-08 22:37:18.026167+00	114
216	204	1	182	\N	Aster White Mardi Gras	26779	2026-03-08 22:37:18.027639+00	115
217	204	1	\N	\N	Aster White Sunspring	60579	2026-03-08 22:37:18.031052+00	\N
218	204	1	\N	\N	Aster Yellow Solidago	56855	2026-03-08 22:37:18.031614+00	\N
219	204	1	184	\N	Aster Yellow Solidago Mardi Gr	20591	2026-03-08 22:37:18.033612+00	116
220	204	1	185	\N	Aster Yellow Solidago Queen's	20551	2026-03-08 22:37:18.035299+00	117
221	221	1	\N	\N	Astrantia Burgundy	40048	2026-03-08 22:37:18.035637+00	\N
222	221	1	\N	\N	Astrantia Pink	12645	2026-03-08 22:37:18.035879+00	\N
223	221	1	\N	\N	Astrantia White	47656	2026-03-08 22:37:18.037437+00	\N
224	221	1	\N	\N	Astrantia Pink Dutch	12645	2026-03-08 22:37:18.037644+00	\N
225	225	1	\N	\N	Baby's Breath White - Xlence	60800	2026-03-08 22:37:18.038086+00	\N
226	225	1	186	\N	Gypsophila Cosmic	29327	2026-03-08 22:37:18.038727+00	\N
227	225	1	187	\N	Gypsophila Cosmic 10pk	46980	2026-03-08 22:37:18.040418+00	\N
228	225	1	188	\N	Gypsophila Excellence 6pk	29328	2026-03-08 22:37:18.04093+00	\N
229	225	1	189	\N	Gypsophila Excellence Pyg 6pk	29337	2026-03-08 22:37:18.043401+00	\N
230	225	1	190	\N	Gypsophila Grandtastic 6pk	17738	2026-03-08 22:37:18.04387+00	\N
231	225	1	191	\N	Gypsophila Wild Pearl 6pk	17691	2026-03-08 22:37:18.044255+00	\N
232	232	1	192	\N	Bells of Ireland 70-80cm	21484	2026-03-08 22:37:18.046114+00	\N
233	232	1	\N	\N	Bells of Ireland 90cm	32232	2026-03-08 22:37:18.046419+00	\N
234	234	1	\N	\N	Berry Black Navajo 40/60cm Chi	35588	2026-03-08 22:37:18.04705+00	\N
235	235	1	\N	\N	Berry Date Palm Green 5stm	28162	2026-03-08 22:37:18.047512+00	\N
236	236	1	193	\N	Berzelia Green 10st California	33149	2026-03-08 22:37:18.049702+00	118
237	236	1	194	\N	Berzelia Green Galpini Baubles	32902	2026-03-08 22:37:18.052283+00	119
238	236	1	195	\N	Berzelia Strawberry	35251	2026-03-08 22:37:18.052932+00	\N
239	239	1	196	\N	Bird of Paradise Super 20pk	34127	2026-03-08 22:37:18.055401+00	\N
240	240	1	197	\N	Bouquet Tropical Flat Orion 65	45493	2026-03-08 22:37:18.055994+00	\N
241	240	1	198	\N	Bouquet Tropical Round Snow 50	45495	2026-03-08 22:37:18.056845+00	\N
242	242	1	\N	\N	Branch Kiwi Vine	28262	2026-03-08 22:37:18.057743+00	\N
243	243	1	\N	\N	Branch Sumac	39503	2026-03-08 22:37:18.058202+00	\N
244	244	1	\N	\N	Butterfly Ranuculus pink - Hera	\N	2026-03-08 22:37:18.06022+00	\N
245	244	1	\N	\N	Butterfly Ranunculus - Eris	\N	2026-03-08 22:37:18.060656+00	\N
246	244	1	\N	\N	Butterfly Ranunculus - Magical Strawberry	\N	2026-03-08 22:37:18.060909+00	\N
247	244	1	\N	\N	Butterfly Ranunculus - Orange Minoan	\N	2026-03-08 22:37:18.061203+00	\N
248	244	1	\N	\N	Butterfly Ranunculus - Red Hades	\N	2026-03-08 22:37:18.063227+00	\N
249	244	1	\N	\N	Butterfly Ranunculus Blush - Ariande	\N	2026-03-08 22:37:18.063463+00	\N
250	244	1	\N	\N	Butterfly Ranunculus Pink - Lycia	\N	2026-03-08 22:37:18.063631+00	\N
251	244	1	\N	\N	Butterfly Ranunculus Purple - Magical Chocolate	\N	2026-03-08 22:37:18.063779+00	\N
252	244	1	\N	\N	Butterfly Ranunculus Salmon - Magical Salmon	\N	2026-03-08 22:37:18.063938+00	\N
253	244	1	\N	\N	Butterfly Ranunculus terra cotta- Musa	\N	2026-03-08 22:37:18.065161+00	\N
254	244	1	\N	\N	Butterfly Ranunculus White - Grace	\N	2026-03-08 22:37:18.065363+00	\N
255	244	1	\N	\N	Butterfly Ranunculus White - Magical Mascarpone	\N	2026-03-08 22:37:18.065588+00	\N
256	244	1	\N	\N	Butterfly Ranunculus Yellow - Helios	\N	2026-03-08 22:37:18.065786+00	\N
257	244	1	\N	\N	Butterfly Ranunculus Yellow - Phytalos	\N	2026-03-08 22:37:18.067722+00	\N
258	244	1	199	\N	Ranunculus Bfly Asst 10st 5pk	35433	2026-03-08 22:37:18.068229+00	\N
259	244	1	200	\N	Ranunculus Bfly Blush 10st Can	45250	2026-03-08 22:37:18.068826+00	\N
260	244	1	201	\N	Ranunculus Bfly Crm Graces 10s	45252	2026-03-08 22:37:18.071321+00	\N
261	244	1	202	\N	Ranunculus Bfly Org Minoan 10s	45251	2026-03-08 22:37:18.073461+00	\N
262	244	1	203	\N	Ranunculus Bfly Pk Melissa 10s	42828	2026-03-08 22:37:18.073988+00	\N
263	244	1	204	\N	Ranunculus Bfly Prp Thiva 10st	57278	2026-03-08 22:37:18.076224+00	\N
264	244	1	205	\N	Ranunculus Bfly Sal Eris 10st	42829	2026-03-08 22:37:18.076683+00	\N
265	244	1	206	\N	Ranunculus Bfly Vestalis 10st	69716	2026-03-08 22:37:18.077322+00	\N
266	266	1	\N	\N	Calendula Orange	28044	2026-03-08 22:37:18.077711+00	\N
267	266	1	\N	\N	Calendula Yellow	26688	2026-03-08 22:37:18.079213+00	\N
268	268	1	\N	\N	Calla Lily - Crystal Blush	\N	2026-03-08 22:37:18.079645+00	\N
269	268	1	\N	\N	Calla Lily - Mango	\N	2026-03-08 22:37:18.079924+00	\N
270	268	1	\N	\N	Mini Calla Lily - Burgundy	\N	2026-03-08 22:37:18.080122+00	\N
271	268	1	\N	\N	Mini Calla Lily - Cranberry	\N	2026-03-08 22:37:18.080276+00	\N
272	268	1	\N	\N	Mini Calla Lily - Pink	\N	2026-03-08 22:37:18.082161+00	\N
273	268	1	\N	\N	Mini Calla Lily - White	\N	2026-03-08 22:37:18.082352+00	\N
274	268	1	\N	\N	Mini Calla Lily Black/Purple - Dark Schwarzwalder	\N	2026-03-08 22:37:18.082542+00	\N
275	268	1	\N	\N	Mini Calla Lily Cherry	\N	2026-03-08 22:37:18.082726+00	\N
276	268	1	\N	\N	Mini Calla Lily Deep Purple	\N	2026-03-08 22:37:18.082915+00	\N
277	268	1	\N	\N	Mini Calla Lily Purple - La Paz	\N	2026-03-08 22:37:18.083358+00	\N
278	268	1	\N	\N	Mini Calla Lily Purple/white - Picasso	\N	2026-03-08 22:37:18.085344+00	\N
279	268	1	\N	\N	Mini Calla Lily Yellow	\N	2026-03-08 22:37:18.085546+00	\N
280	268	1	\N	\N	XL White Calla Lily - Super Open Cut	\N	2026-03-08 22:37:18.085748+00	\N
281	281	1	\N	\N	Calla Lily White Local	20598	2026-03-08 22:37:18.086093+00	\N
282	281	1	207	\N	Calla Lily Wht Magnum	33998	2026-03-08 22:37:18.08669+00	\N
283	281	1	208	\N	Calla Lily Wht Open 80/90 20pk	20656	2026-03-08 22:37:18.088342+00	\N
284	281	1	209	\N	Calla Lily Wht Open 90cm 25pk	17760	2026-03-08 22:37:18.088784+00	\N
285	281	1	210	\N	Calla Lily Wht Open Prem 80/90	20643	2026-03-08 22:37:18.091098+00	\N
286	286	1	211	\N	Calla Lily Mini Blk Odessa 50c	36586	2026-03-08 22:37:18.091639+00	\N
287	286	1	212	\N	Calla Lily Mini Burg Sumatra 5	38290	2026-03-08 22:37:18.092516+00	\N
288	286	1	\N	\N	Calla Lily Mini Pink Hot 50cm	38337	2026-03-08 22:37:18.093265+00	\N
289	286	1	213	\N	Calla Lily Mini Red Maj. 50/55	38092	2026-03-08 22:37:18.093806+00	120
290	286	1	\N	\N	Calla Lily Mini White 40cm	39874	2026-03-08 22:37:18.094052+00	\N
291	286	1	\N	\N	Calla Lily Mini White 50cm	39911	2026-03-08 22:37:18.094304+00	\N
292	286	1	214	\N	Calla Lily Mini Wht Iv Art 55+	28609	2026-03-08 22:37:18.094881+00	\N
293	293	1	\N	\N	Mini Calla Lily Purple 50cm	36584	2026-03-08 22:37:18.095211+00	\N
294	294	1	\N	\N	Campanula Dark Purple	\N	2026-03-08 22:37:18.095511+00	\N
295	294	1	\N	\N	Campanula Lilae	\N	2026-03-08 22:37:18.095727+00	\N
296	294	1	\N	\N	Campanula Pink	\N	2026-03-08 22:37:18.095983+00	\N
297	294	1	\N	\N	Campanula White	\N	2026-03-08 22:37:18.09619+00	\N
298	94	1	\N	\N	Carnation - Caramel	\N	2026-03-08 22:37:18.096504+00	\N
299	94	1	\N	\N	Carnation - Nobbio Burgundy	\N	2026-03-08 22:37:18.096718+00	\N
300	94	1	\N	\N	Carnation - Orange Flame	\N	2026-03-08 22:37:18.096904+00	\N
301	94	1	\N	\N	Carnation Beige - Lege Marrone	\N	2026-03-08 22:37:18.097145+00	\N
302	94	1	\N	\N	Carnation Blush - Mizuky	\N	2026-03-08 22:37:18.097373+00	\N
303	94	1	\N	\N	Carnation Blush- Hanoi	\N	2026-03-08 22:37:18.097565+00	\N
304	94	1	\N	\N	Carnation Burgundy - Caronte	\N	2026-03-08 22:37:18.097723+00	\N
305	94	1	\N	\N	Carnation Burgundy- Red Velvet	\N	2026-03-08 22:37:18.097855+00	\N
306	94	1	\N	\N	Carnation Hot Pink - Bizet	\N	2026-03-08 22:37:18.097983+00	\N
307	94	1	\N	\N	Carnation Orange - Megan	\N	2026-03-08 22:37:18.098117+00	\N
308	94	1	\N	\N	Carnation Peach - Brut	\N	2026-03-08 22:37:18.09824+00	\N
309	94	1	\N	\N	Carnation Peach/blush - Creta	\N	2026-03-08 22:37:18.098361+00	\N
310	94	1	\N	\N	Carnation Pink - Bubblicious	\N	2026-03-08 22:37:18.098484+00	\N
311	94	1	\N	\N	Carnation Pink- Babylon	\N	2026-03-08 22:37:18.098606+00	\N
312	94	1	\N	\N	Carnation Purple - Burgundy PIxel	\N	2026-03-08 22:37:18.098725+00	\N
313	94	1	\N	\N	Carnation White - Igloo	\N	2026-03-08 22:37:18.098971+00	\N
314	94	1	\N	\N	Carnation White - Polar Route	\N	2026-03-08 22:37:18.099141+00	\N
315	94	1	215	\N	Carn Moon Select Asst 80pk	60519	2026-03-08 22:37:18.099646+00	\N
316	94	1	216	\N	Carnation Antiqua	37119	2026-03-08 22:37:18.10021+00	\N
317	94	1	217	\N	Carnation Brt Rendez/Komachi	20732	2026-03-08 22:37:18.100686+00	\N
318	94	1	\N	\N	Carnation Burgundy	20771	2026-03-08 22:37:18.100904+00	\N
319	94	1	218	\N	Carnation Caramel	65781	2026-03-08 22:37:18.101278+00	\N
320	94	1	219	\N	Carnation Cover	68378	2026-03-08 22:37:18.101608+00	\N
321	94	1	\N	\N	Carnation Cream	20734	2026-03-08 22:37:18.101781+00	\N
322	94	1	220	\N	Carnation Creola	50616	2026-03-08 22:37:18.102093+00	\N
323	94	1	\N	\N	Carnation Green	37109	2026-03-08 22:37:18.102321+00	\N
324	94	1	221	\N	Carnation Lav Farida 75pk	62801	2026-03-08 22:37:18.102832+00	\N
325	94	1	\N	\N	Carnation Lavender	58013	2026-03-08 22:37:18.103044+00	\N
326	94	1	222	\N	Carnation Lege Sport 50pk	50878	2026-03-08 22:37:18.103382+00	\N
327	94	1	223	\N	Carnation Mariposa	54812	2026-03-08 22:37:18.10375+00	\N
328	94	1	224	\N	Carnation Nobbio Cherry 75pk	62797	2026-03-08 22:37:18.104122+00	\N
329	94	1	\N	\N	Carnation Orange	66053	2026-03-08 22:37:18.104294+00	\N
330	94	1	225	\N	Carnation Org Trueno 75pk	52192	2026-03-08 22:37:18.104836+00	\N
331	94	1	\N	\N	Carnation Peach	20748	2026-03-08 22:37:18.105066+00	\N
332	94	1	226	\N	Carnation Peach Lege Marrn 75p	65802	2026-03-08 22:37:18.105789+00	121
333	94	1	227	\N	Carnation Peach Lizi 50pk	50879	2026-03-08 22:37:18.10645+00	122
334	94	1	\N	\N	Carnation Pink	20751	2026-03-08 22:37:18.106658+00	\N
335	94	1	227	\N	Carnation Pink Doncel 50pk	50880	2026-03-08 22:37:18.106983+00	123
336	94	1	229	\N	Carnation Pink Doncel pk75	48606	2026-03-08 22:37:18.107628+00	124
337	94	1	\N	\N	Carnation Pink Lege	57635	2026-03-08 22:37:18.107827+00	\N
338	94	1	\N	\N	Carnation Pink-Hot	56042	2026-03-08 22:37:18.107954+00	\N
339	94	1	\N	\N	Carnation Purple	60522	2026-03-08 22:37:18.108085+00	\N
340	94	1	230	\N	Carnation Purple Golem 75pk	62061	2026-03-08 22:37:18.108539+00	125
341	94	1	\N	\N	Carnation Red	20757	2026-03-08 22:37:18.108792+00	\N
342	94	1	231	\N	Carnation Select Moon Aqua	20710	2026-03-08 22:37:18.10938+00	\N
343	94	1	232	\N	Carnation Select Moon Lite	20711	2026-03-08 22:37:18.109942+00	\N
344	94	1	233	\N	Carnation Select Moon Shade	20712	2026-03-08 22:37:18.110613+00	\N
345	94	1	234	\N	Carnation Select Moon Vista	20713	2026-03-08 22:37:18.111152+00	\N
346	94	1	235	\N	Carnation Spritz Sport	54837	2026-03-08 22:37:18.111669+00	\N
347	94	1	\N	\N	Carnation White	20763	2026-03-08 22:37:18.111881+00	\N
348	94	1	236	\N	Carnation White Fancy 175pk	28125	2026-03-08 22:37:18.112467+00	126
349	94	1	\N	\N	Carnation Yellow	68374	2026-03-08 22:37:18.112827+00	\N
350	350	1	\N	\N	Bronze/gold Football Mum	\N	2026-03-08 22:37:18.113436+00	\N
351	350	1	\N	\N	Chrysanthemum Disbud-Creme Brulee Yellow	\N	2026-03-08 22:37:18.11365+00	\N
352	350	1	\N	\N	Chrysanthemum Zembla White	74486	2026-03-08 22:37:18.113944+00	\N
353	350	1	\N	\N	Chrysanthemum-Rosetta Dark Bronze	\N	2026-03-08 22:37:18.114183+00	\N
354	350	1	\N	\N	Cushion Pompon Burgundy- Malbac	\N	2026-03-08 22:37:18.11437+00	\N
355	350	1	\N	\N	Mum Ball - Lavender Mochi	\N	2026-03-08 22:37:18.114554+00	\N
356	350	1	\N	\N	Mum Ball Bronze - Chivas Dark	\N	2026-03-08 22:37:18.114725+00	\N
357	350	1	\N	\N	Mum Ball Bronze - Mochi Bronze	50826	2026-03-08 22:37:18.11489+00	\N
358	350	1	\N	\N	Mum Ball Orange - Chivas	\N	2026-03-08 22:37:18.115102+00	\N
359	350	1	\N	\N	Mum Ball Purple - Lychee	\N	2026-03-08 22:37:18.115282+00	\N
360	350	1	\N	\N	Mum Ball Red - Testarossa	\N	2026-03-08 22:37:18.115451+00	\N
361	350	1	\N	\N	Mum Ball White - Evidence	\N	2026-03-08 22:37:18.11565+00	\N
362	350	1	\N	\N	Mum Ball Yellow - Totumo	\N	2026-03-08 22:37:18.115877+00	\N
363	350	1	\N	\N	Mum Ball- Paladov Sunny	\N	2026-03-08 22:37:18.116105+00	\N
364	350	1	\N	\N	Mum Disbud - White	\N	2026-03-08 22:37:18.116402+00	\N
365	350	1	\N	\N	Mum White - Vladimir	\N	2026-03-08 22:37:18.116634+00	\N
366	350	1	\N	\N	Romancero Salmon - Disbud Chrysanthemum	\N	2026-03-08 22:37:18.116867+00	\N
367	350	1	\N	\N	Super Mum Lavender - Single Lady Dark	\N	2026-03-08 22:37:18.117105+00	\N
368	350	1	\N	\N	Veronica-Salmon Mum	\N	2026-03-08 22:37:18.117345+00	\N
369	350	1	237	\N	Mum Dis Ball Pch Sorbet Berry	59322	2026-03-08 22:37:18.117995+00	\N
370	350	1	238	\N	Mum Dis Ball Pink Lorax 5stm	57124	2026-03-08 22:37:18.118519+00	\N
371	350	1	239	\N	Mum Dis Ball Prp Gustav, 5st	68170	2026-03-08 22:37:18.118906+00	\N
372	350	1	240	\N	Mum Dis Ball White Evidence	59327	2026-03-08 22:37:18.11931+00	\N
373	350	1	241	\N	Mum Dis Ball Wht Zonar 5st 4pk	50827	2026-03-08 22:37:18.11977+00	\N
374	350	1	242	\N	Mum Dis Ball Yellow Paladov	59146	2026-03-08 22:37:18.120277+00	\N
375	350	1	243	\N	Mum Disbud Assorted 9pk	21950	2026-03-08 22:37:18.121164+00	\N
376	350	1	244	\N	Mum Disbud Asst 4pk	61206	2026-03-08 22:37:18.121805+00	\N
377	350	1	245	\N	Mum Disbud BiClr Rasp Brulee E	18420	2026-03-08 22:37:18.12232+00	\N
378	350	1	246	\N	Mum Disbud Bronze Marrakesh 3p	18361	2026-03-08 22:37:18.122892+00	\N
379	350	1	247	\N	Mum Disbud Crm Caffe Latte ECU	59464	2026-03-08 22:37:18.123383+00	\N
380	350	1	248	\N	Mum Disbud Lavender Lotus	59336	2026-03-08 22:37:18.123872+00	\N
381	350	1	249	\N	Mum Disbud Peach Linette 4pk	59300	2026-03-08 22:37:18.12446+00	\N
382	350	1	250	\N	Mum Disbud Peach Linette ECU	59035	2026-03-08 22:37:18.124924+00	\N
383	350	1	251	\N	Mum Disbud Pink Honeymoon Ecu	49694	2026-03-08 22:37:18.125426+00	\N
384	350	1	252	\N	Mum Disbud Pink Petruska	54594	2026-03-08 22:37:18.125948+00	\N
385	350	1	253	\N	Mum Disbud Purple Andrea	57933	2026-03-08 22:37:18.126453+00	\N
386	350	1	254	\N	Mum Disbud Purple Bachata 4pk	51809	2026-03-08 22:37:18.126848+00	\N
387	350	1	255	\N	Mum Disbud Purple Tornado 4pk	18534	2026-03-08 22:37:18.127215+00	\N
388	350	1	256	\N	Mum Disbud Salm.Prdgy Coral	18572	2026-03-08 22:37:18.127546+00	\N
389	350	1	257	\N	Mum Disbud Salmon Pink ECU 3pk	50812	2026-03-08 22:37:18.127935+00	\N
390	350	1	258	\N	Mum Disbud Tinted Blue	18586	2026-03-08 22:37:18.128582+00	\N
391	350	1	259	\N	Mum Disbud White Arctic Qn 4pk	62839	2026-03-08 22:37:18.129414+00	\N
392	350	1	260	\N	Mum Disbud White Arctic Qn 9pk	54694	2026-03-08 22:37:18.130211+00	\N
393	350	1	261	\N	Mum Disbud White Arctic Queen	49581	2026-03-08 22:37:18.130913+00	\N
394	350	1	262	\N	Mum Disbud White Gagarin ECU	54873	2026-03-08 22:37:18.131438+00	\N
395	350	1	263	\N	Mum Disbud White Magnum	57127	2026-03-08 22:37:18.131957+00	\N
396	350	1	264	\N	Mum Disbud White Magnum 4pk	18525	2026-03-08 22:37:18.132459+00	\N
397	350	1	265	\N	Mum Disbud White Tatto 4pk	50842	2026-03-08 22:37:18.133073+00	\N
398	350	1	266	\N	Mum Disbud Yellow	51799	2026-03-08 22:37:18.133457+00	\N
399	350	1	267	\N	Mum Disbud Yellow Astroid	74478	2026-03-08 22:37:18.133846+00	\N
400	350	1	268	\N	Mum Disbud Yellow Astroid 4pk	62834	2026-03-08 22:37:18.13428+00	\N
401	350	1	269	\N	Mum Spider Green	46971	2026-03-08 22:37:18.134805+00	\N
402	350	1	270	\N	Mum Spider Green Dark	37301	2026-03-08 22:37:18.135359+00	\N
403	350	1	271	\N	Mum Spider Lav. Anas DVFl 4pk	50012	2026-03-08 22:37:18.135831+00	\N
404	350	1	272	\N	Mum Spider Lavender	22000	2026-03-08 22:37:18.136426+00	\N
405	350	1	273	\N	Mum Spider Pink	55393	2026-03-08 22:37:18.137156+00	\N
406	350	1	274	\N	Mum Spider Pink Anastasia	54595	2026-03-08 22:37:18.13753+00	\N
407	350	1	275	\N	Mum Spider Pink Hydra 5pk	58642	2026-03-08 22:37:18.1379+00	\N
408	350	1	276	\N	Mum Spider Purple 5pk	62888	2026-03-08 22:37:18.13841+00	\N
409	350	1	277	\N	Mum Spider White	37374	2026-03-08 22:37:18.139041+00	\N
410	350	1	278	\N	Mum Spider White Yazoo 12pk	67635	2026-03-08 22:37:18.139666+00	\N
411	350	1	279	\N	Mum Spider White Yazoo 9pk	21963	2026-03-08 22:37:18.140296+00	\N
412	350	1	280	\N	Mum Spider Yellow	21988	2026-03-08 22:37:18.140733+00	\N
413	350	1	281	\N	Mum Spider Yellow 4pk	46974	2026-03-08 22:37:18.141115+00	\N
414	350	1	282	\N	Mum Spider Yellow Anastasia	21943	2026-03-08 22:37:18.141499+00	\N
415	415	1	\N	\N	Mum Salmon Coral	18572	2026-03-08 22:37:18.141748+00	\N
416	416	1	283	\N	Clematis Amazing Kibo	57796	2026-03-08 22:37:18.142468+00	\N
417	416	1	\N	\N	Clematis Lavender	40302	2026-03-08 22:37:18.142713+00	\N
418	416	1	\N	\N	Clematis Pink Dark	57535	2026-03-08 22:37:18.142906+00	\N
419	416	1	284	\N	Clematis Pink Lt Kansas 10st	41322	2026-03-08 22:37:18.14354+00	127
420	416	1	\N	\N	Clematis Purple	57226	2026-03-08 22:37:18.143812+00	\N
421	421	1	\N	\N	Coontie Fern	G1246	2026-03-08 22:37:18.144058+00	\N
422	422	1	\N	\N	Cornflower Blue California	21505	2026-03-08 22:37:18.144349+00	\N
423	423	1	285	\N	Cosmos Chocolate Choco 10st	47816	2026-03-08 22:37:18.144994+00	\N
424	424	1	\N	\N	Craspedia Yellow	\N	2026-03-08 22:37:18.14543+00	\N
425	425	1	\N	\N	Cremon - Copper	\N	2026-03-08 22:37:18.145704+00	\N
426	425	1	\N	\N	Cremon Blush - Candyfloss	\N	2026-03-08 22:37:18.14598+00	\N
427	425	1	\N	\N	Cremon Bronze - Fuego	\N	2026-03-08 22:37:18.146214+00	\N
428	425	1	\N	\N	Cremon Lavender - Carina	\N	2026-03-08 22:37:18.146378+00	\N
429	425	1	\N	\N	Cremon Lavender - Petruska	\N	2026-03-08 22:37:18.146537+00	\N
430	425	1	\N	\N	Cremon Mum - Cream	\N	2026-03-08 22:37:18.146744+00	\N
431	425	1	\N	\N	Cremon Mum Purple - Densa	\N	2026-03-08 22:37:18.146905+00	\N
432	425	1	\N	\N	Cremon Mum White- Maisy	\N	2026-03-08 22:37:18.147057+00	\N
433	425	1	\N	\N	Cremon Peach - Linette	\N	2026-03-08 22:37:18.1472+00	\N
434	425	1	\N	\N	Cremon Red - Rosseta	\N	2026-03-08 22:37:18.147348+00	\N
435	425	1	\N	\N	Cremon Red - Tornado	\N	2026-03-08 22:37:18.147498+00	\N
436	425	1	\N	\N	Cremon Yellow -Zembla Sunny	\N	2026-03-08 22:37:18.147643+00	\N
437	425	1	\N	\N	Mum Salmon - Oefa	\N	2026-03-08 22:37:18.147793+00	\N
438	438	1	286	\N	Willow Curly Large	G1125	2026-03-08 22:37:18.148627+00	\N
439	438	1	287	\N	Willow Curly Medium	G1128	2026-03-08 22:37:18.149174+00	\N
440	440	1	288	\N	Cymbidium Asst 8/11 10pk	45384	2026-03-08 22:37:18.149836+00	\N
441	440	1	\N	\N	Cymbidium Brown 8/12	32537	2026-03-08 22:37:18.150087+00	\N
442	440	1	289	\N	Cymbidium Burgundy 8/11 Bloom	35979	2026-03-08 22:37:18.150745+00	128
443	440	1	290	\N	Cymbidium Green Brg Lip 8/11	46355	2026-03-08 22:37:18.151446+00	129
444	440	1	291	\N	Cymbidium Mini Burgundy	25939	2026-03-08 22:37:18.15196+00	\N
445	440	1	292	\N	Cymbidium Mini Grn RdLip 40cm+	31136	2026-03-08 22:37:18.152444+00	\N
446	440	1	293	\N	Cymbidium Mini Pink 40cm+	10098	2026-03-08 22:37:18.152941+00	\N
447	440	1	294	\N	Cymbidium Mini Yellow Red Lip	31269	2026-03-08 22:37:18.153475+00	\N
448	440	1	\N	\N	Cymbidium Orange 8/11	29599	2026-03-08 22:37:18.153768+00	\N
449	440	1	\N	\N	Cymbidium Pink-Dark 8/12+	46362	2026-03-08 22:37:18.153973+00	\N
450	440	1	290	\N	Cymbidium White Pink Lip 8/11	46359	2026-03-08 22:37:18.154472+00	130
451	440	1	296	\N	Cymbidium Ylw Red Lip 8/11	46363	2026-03-08 22:37:18.15514+00	\N
452	452	1	297	\N	Daffodil Ylw Carlton Dutch	22060	2026-03-08 22:37:18.155775+00	\N
453	452	1	298	\N	Daffodil Ylw Dutch Master Dut	22061	2026-03-08 22:37:18.15639+00	\N
454	452	1	299	\N	Daffodil Ylw Field Bunch	22059	2026-03-08 22:37:18.156799+00	\N
455	455	1	\N	\N	Dahlia Blush	\N	2026-03-08 22:37:18.157046+00	\N
456	455	1	\N	\N	Dahlia Burgundy	\N	2026-03-08 22:37:18.15727+00	\N
457	455	1	\N	\N	Dahlia Coral	\N	2026-03-08 22:37:18.157476+00	\N
458	455	1	\N	\N	Dahlia Orange	\N	2026-03-08 22:37:18.157685+00	\N
459	455	1	\N	\N	Dahlia Peach	\N	2026-03-08 22:37:18.157918+00	\N
460	455	1	300	\N	Dahlia White 5st Cali	20873	2026-03-08 22:37:18.158516+00	\N
461	461	1	301	\N	Dahlia Brg Naomi 5st Californi	32238	2026-03-08 22:37:18.159022+00	\N
462	461	1	302	\N	Dahlia Orange Maarn 5st Cali	20893	2026-03-08 22:37:18.159732+00	131
463	461	1	303	\N	Dahlia Purple Ivanetti 5st Cal	42180	2026-03-08 22:37:18.160489+00	132
464	461	1	304	\N	Dahlia Red Dark Cornel 5st	48882	2026-03-08 22:37:18.161081+00	133
465	465	1	\N	\N	Delphinium - Blue Planet Spray (dark)	\N	2026-03-08 22:37:18.161544+00	\N
466	465	1	\N	\N	Delphinium - Soft Purple (70cm)	\N	2026-03-08 22:37:18.161761+00	\N
467	465	1	\N	\N	Delphinium Blue - Sunshine	\N	2026-03-08 22:37:18.16196+00	\N
468	465	1	\N	\N	Delphinium Blush - Pink Planet	\N	2026-03-08 22:37:18.162185+00	\N
469	465	1	\N	\N	Delphinium Dark Blue - Belladonna	\N	2026-03-08 22:37:18.162385+00	\N
470	465	1	\N	\N	Delphinium Light Blue - Bella Donna	\N	2026-03-08 22:37:18.162538+00	\N
471	465	1	\N	\N	Delphinium White (White Center)	\N	2026-03-08 22:37:18.162676+00	\N
472	465	1	\N	\N	Delphinium- Belladonna White	\N	2026-03-08 22:37:18.16281+00	\N
473	473	1	305	\N	Delph Blue-Dk Sea Waltz 60/70	33114	2026-03-08 22:37:18.163287+00	\N
474	473	1	306	\N	Delph Blue-Dk Sea Waltz 70/90	35608	2026-03-08 22:37:18.16393+00	\N
475	473	1	307	\N	Delph Blue-Dk SeaWaltz 60cm 6p	39944	2026-03-08 22:37:18.164813+00	\N
476	473	1	308	\N	Delph Blue-Dk Waltz 55cm 6p	61232	2026-03-08 22:37:18.165465+00	\N
477	473	1	309	\N	Delph Blue-Lt Sky Waltz 60-70c	20951	2026-03-08 22:37:18.165947+00	\N
478	473	1	310	\N	Delph Blue-Lt Sky Waltz 60cm	33091	2026-03-08 22:37:18.166521+00	\N
479	473	1	311	\N	Delph Blue-Lt Sky Waltz 70/90c	34903	2026-03-08 22:37:18.167155+00	\N
480	473	1	312	\N	Delph Hyb Blue-Dk 70/80cm/10St	39119	2026-03-08 22:37:18.167613+00	\N
481	473	1	313	\N	Delph Hyb Blue-Dk Pacif60c/10s	38353	2026-03-08 22:37:18.168094+00	\N
482	473	1	314	\N	Delph Hyb Blue-Dk Pacif70c/10s	38354	2026-03-08 22:37:18.168591+00	\N
483	473	1	315	\N	Delph Hyb Blue-Dk Pacif80/90cm	38355	2026-03-08 22:37:18.169093+00	\N
484	473	1	316	\N	Delph Hyb Blue-Lt 80/90cm/10St	39133	2026-03-08 22:37:18.169923+00	\N
485	473	1	317	\N	Delph Hyb Blue-Lt Pacif 60c/10	38362	2026-03-08 22:37:18.170379+00	\N
486	473	1	318	\N	Delph Hyb Blue-Lt Pacif 70c/10	38363	2026-03-08 22:37:18.170743+00	\N
487	473	1	319	\N	Delph Hyb Blue-Lt Pacif 80c/10	38364	2026-03-08 22:37:18.171096+00	\N
488	473	1	320	\N	Delph Hyb Lav Pacif70c/10s	39075	2026-03-08 22:37:18.171528+00	\N
489	473	1	321	\N	Delph Hyb Lav Pacif80c/10s	39076	2026-03-08 22:37:18.171857+00	\N
490	473	1	322	\N	Delph Hyb Pink Pacif70c/10s	39079	2026-03-08 22:37:18.172188+00	\N
491	473	1	323	\N	Delph Hyb Pink Pacif80c/10s	39080	2026-03-08 22:37:18.172651+00	\N
492	473	1	324	\N	Delph Hyb Prpl BlkK Pacif70c/	39083	2026-03-08 22:37:18.172983+00	\N
493	473	1	325	\N	Delph Hyb White 80/90cm 10stm	38139	2026-03-08 22:37:18.173475+00	\N
494	473	1	326	\N	Delph Hyb White Pacif 60c/10s	38366	2026-03-08 22:37:18.173951+00	\N
495	473	1	327	\N	Delph Hyb White Pacif 70c/10st	38367	2026-03-08 22:37:18.174426+00	\N
496	473	1	328	\N	Delph Hyb White Pacif 80c/10st	38368	2026-03-08 22:37:18.174979+00	\N
497	473	1	329	\N	Delph Hyb Wht Full Moon 120cm	41454	2026-03-08 22:37:18.175475+00	\N
498	473	1	330	\N	Delph Hybrid Asst 60cm 6pk	34167	2026-03-08 22:37:18.175945+00	\N
499	473	1	331	\N	Delph Lavender Serene 70cm	20993	2026-03-08 22:37:18.176406+00	\N
500	473	1	332	\N	Delph White Andes Bella	33392	2026-03-08 22:37:18.176868+00	\N
501	473	1	333	\N	Delph White-Royal 60/70 Vflor	36374	2026-03-08 22:37:18.177317+00	\N
502	502	1	\N	\N	Dendrobium Orchid Blush - Erika	\N	2026-03-08 22:37:18.177648+00	\N
503	502	1	334	\N	Dendrobium Asst Mix Tray 5pk	10111	2026-03-08 22:37:18.178491+00	\N
504	502	1	335	\N	Dendrobium Asst Mx Bouquet 3st	10218	2026-03-08 22:37:18.179339+00	\N
505	502	1	336	\N	Dendrobium Blue Amy Super	10101	2026-03-08 22:37:18.180249+00	134
506	502	1	337	\N	Dendrobium Blue Vanda Stem	29083	2026-03-08 22:37:18.180864+00	135
507	502	1	338	\N	Dendrobium Green Jade SL/L	45898	2026-03-08 22:37:18.181742+00	136
508	502	1	339	\N	Dendrobium James Storei	10110	2026-03-08 22:37:18.182333+00	\N
509	502	1	340	\N	Dendrobium Lady Pink	46118	2026-03-08 22:37:18.182873+00	\N
510	502	1	341	\N	Dendrobium Lav/Wh Misteen long	45904	2026-03-08 22:37:18.183375+00	\N
511	502	1	342	\N	Dendrobium Mokara Calypso 5st	45988	2026-03-08 22:37:18.183875+00	\N
512	502	1	343	\N	Dendrobium Mokara Org 5st SL/L	45511	2026-03-08 22:37:18.184362+00	\N
513	502	1	344	\N	Dendrobium Mokara Pink Lt 5st	10116	2026-03-08 22:37:18.184832+00	\N
514	502	1	345	\N	Dendrobium Mokara Pur Nora 5st	40076	2026-03-08 22:37:18.185367+00	\N
515	502	1	346	\N	Dendrobium Mokara Ylw 5st SL/L	46268	2026-03-08 22:37:18.185731+00	\N
516	502	1	347	\N	Dendrobium Prp. Madame SL/L BO	45967	2026-03-08 22:37:18.18613+00	\N
517	502	1	\N	\N	Dendrobium Purple Super	10120	2026-03-08 22:37:18.186343+00	\N
518	502	1	348	\N	Dendrobium Var. BOM SL/L B	45966	2026-03-08 22:37:18.18669+00	\N
519	502	1	349	\N	Dendrobium Variegated Super	10124	2026-03-08 22:37:18.187141+00	\N
520	502	1	350	\N	Dendrobium White Big Med BO	10705	2026-03-08 22:37:18.187804+00	137
521	502	1	351	\N	Dendrobium White Big SL/L BO	45897	2026-03-08 22:37:18.188504+00	138
522	502	1	\N	\N	Dendrobium White Regular	10125	2026-03-08 22:37:18.18878+00	\N
523	502	1	\N	\N	Dendrobium White Super	10126	2026-03-08 22:37:18.188968+00	\N
524	502	1	\N	\N	Dendrobium Orchid Super	10126	2026-03-08 22:37:18.189165+00	\N
525	525	1	352	\N	Dianthus Green Trick 50-60cm	38789	2026-03-08 22:37:18.189847+00	139
526	525	1	353	\N	Dianthus Amazon Burgundy	38004	2026-03-08 22:37:18.190393+00	\N
527	525	1	354	\N	Dianthus Amazon Cherry	31690	2026-03-08 22:37:18.190955+00	\N
528	525	1	355	\N	Dianthus Amazon Coral	38002	2026-03-08 22:37:18.191436+00	\N
529	525	1	356	\N	Dianthus Amazon Pink-Lt	39843	2026-03-08 22:37:18.191948+00	\N
530	525	1	357	\N	Dianthus Amazon Purple	31947	2026-03-08 22:37:18.192435+00	\N
531	525	1	358	\N	Dianthus Amazon Var Pk/Wt	38003	2026-03-08 22:37:18.192954+00	\N
532	525	1	359	\N	Dianthus Amazon White	38127	2026-03-08 22:37:18.193436+00	\N
533	525	1	360	\N	Dianthus Ball Breanth Jolly 4p	18425	2026-03-08 22:37:18.193919+00	\N
534	525	1	361	\N	Dianthus Ball Breanth White 4p	18426	2026-03-08 22:37:18.19445+00	\N
535	525	1	362	\N	Dianthus Green Trick 4pk	38054	2026-03-08 22:37:18.195053+00	140
536	525	1	352	\N	Dianthus Green Trick 50-60cm	38789	2026-03-08 22:37:18.195454+00	139
537	537	1	\N	\N	Dried - Bunny Tail Brown (Natural)	\N	2026-03-08 22:37:18.195737+00	\N
538	538	1	\N	\N	Equisetum Rush	G1033	2026-03-08 22:37:18.195932+00	\N
539	539	1	\N	\N	Thistle Eryngium - Blue Ice	\N	2026-03-08 22:37:18.196132+00	\N
540	539	1	\N	\N	Thistle Eryngium - Blue Jackpot	\N	2026-03-08 22:37:18.196273+00	\N
541	539	1	\N	\N	Thistle Eryngium - Blue Lagoon	\N	2026-03-08 22:37:18.196408+00	\N
542	539	1	\N	\N	Thistle Eryngium - Green Lagoon	\N	2026-03-08 22:37:18.196674+00	\N
543	543	1	\N	\N	Eucalyptus - Baby Blue	G1036	2026-03-08 22:37:18.196865+00	\N
544	543	1	\N	\N	Eucalyptus - Cinerea	G1708	2026-03-08 22:37:18.197005+00	\N
545	543	1	\N	\N	Eucalyptus - Gunnii	G1045	2026-03-08 22:37:18.197198+00	\N
546	543	1	\N	\N	Eucalyptus - Parvifolia	\N	2026-03-08 22:37:18.197401+00	\N
547	543	1	\N	\N	Eucalyptus - Seeded	G1042	2026-03-08 22:37:18.197611+00	\N
548	543	1	\N	\N	Eucalyptus - Silver Dollar	G1048	2026-03-08 22:37:18.197823+00	\N
549	543	1	\N	\N	Eucalyptus - Willow	G1043	2026-03-08 22:37:18.19801+00	\N
550	543	1	\N	\N	Poliantemus (Silver Dollar)	\N	2026-03-08 22:37:18.198177+00	\N
551	543	1	364	\N	Eucalyptus Assorted 9pk	G1334	2026-03-08 22:37:18.198516+00	\N
552	543	1	365	\N	Eucalyptus Baby Blue 4pk	G1903	2026-03-08 22:37:18.198898+00	\N
553	543	1	366	\N	Eucalyptus Baby Blue 5pk	G1543	2026-03-08 22:37:18.199386+00	\N
554	543	1	367	\N	Eucalyptus Baby-Blue Bqt 7pk	G1703	2026-03-08 22:37:18.199844+00	\N
555	543	1	368	\N	Eucalyptus Feather Willow 5pk	G1548	2026-03-08 22:37:18.20034+00	\N
556	543	1	369	\N	Eucalyptus Gum Drop	G2212	2026-03-08 22:37:18.20079+00	\N
557	543	1	370	\N	Eucalyptus Gunnii 5pk	G1544	2026-03-08 22:37:18.201265+00	\N
558	543	1	371	\N	Eucalyptus Parvifolia Californ	G2127	2026-03-08 22:37:18.201714+00	\N
559	543	1	372	\N	Eucalyptus Seeded 5pk	G1358	2026-03-08 22:37:18.202316+00	\N
560	543	1	373	\N	Eucalyptus Seeded Naked	G1037	2026-03-08 22:37:18.202808+00	\N
561	543	1	374	\N	Eucalyptus Silver Dollar 10pk	G1376	2026-03-08 22:37:18.20335+00	\N
562	543	1	375	\N	Eucalyptus Silver Dollar 5pk	G1524	2026-03-08 22:37:18.203933+00	\N
563	543	1	376	\N	Eucalyptus Stuartiana Italian	G2217	2026-03-08 22:37:18.204461+00	\N
564	543	1	377	\N	Eucalyptus True Blue	G1049	2026-03-08 22:37:18.205005+00	\N
565	565	1	\N	\N	Euonymous Variegated	G1984	2026-03-08 22:37:18.205325+00	\N
566	566	1	378	\N	Carolina Sapphire	G1345	2026-03-08 22:37:18.205982+00	\N
567	566	1	379	\N	Cedar Port Orford Bunched	G1018	2026-03-08 22:37:18.206528+00	\N
568	566	1	\N	\N	Carolina Sapphire	\N	2026-03-08 22:37:18.206734+00	\N
569	566	1	\N	\N	Fraser Fir	\N	2026-03-08 22:37:18.206885+00	\N
570	566	1	\N	\N	Leyland Cypress	\N	2026-03-08 22:37:18.207041+00	\N
571	566	1	\N	\N	Pine Spruce Greenery	\N	2026-03-08 22:37:18.207268+00	\N
572	566	1	\N	\N	Port Oxford Cedar	\N	2026-03-08 22:37:18.20747+00	\N
573	566	1	\N	\N	Princess Pine	\N	2026-03-08 22:37:18.207689+00	\N
574	566	1	\N	\N	White Pine Tips	\N	2026-03-08 22:37:18.207874+00	\N
575	575	1	\N	\N	Foxglove Peach	50069	2026-03-08 22:37:18.208138+00	\N
576	576	1	\N	\N	Freesia Coral/orange- Tropical	\N	2026-03-08 22:37:18.208405+00	\N
577	576	1	\N	\N	Freesia Lavender	\N	2026-03-08 22:37:18.2086+00	\N
578	576	1	\N	\N	Freesia White Canada	31902	2026-03-08 22:37:18.208918+00	\N
579	576	1	\N	\N	Freesia Yellow Canada	31901	2026-03-08 22:37:18.209105+00	\N
580	576	1	380	\N	Freesia Lavender Dbl Canada	12904	2026-03-08 22:37:18.209655+00	142
581	576	1	\N	\N	Freesia Purple Canada	31904	2026-03-08 22:37:18.209883+00	\N
582	576	1	380	\N	Freesia White Dbl Canada	41105	2026-03-08 22:37:18.210234+00	143
583	576	1	380	\N	Freesia Yellow Dbl Canada	28443	2026-03-08 22:37:18.210676+00	144
584	584	1	383	\N	FR Tulip Pch Menton Dutch	27085	2026-03-08 22:37:18.211171+00	\N
585	584	1	384	\N	FR Tulip Wht Maureen Dutch	27083	2026-03-08 22:37:18.211667+00	\N
586	4	1	\N	\N	Pink Garden Rose - Candy X-pression	\N	2026-03-08 22:37:18.211916+00	\N
587	4	1	\N	\N	Rose - Antonia Gardens - Yellow	\N	2026-03-08 22:37:18.212132+00	\N
588	4	1	\N	\N	Rose - Mayra's Red	\N	2026-03-08 22:37:18.212395+00	\N
589	4	1	\N	\N	Rose - Mayra's White	\N	2026-03-08 22:37:18.212591+00	\N
590	4	1	\N	\N	Rose - Pink O'hare	\N	2026-03-08 22:37:18.212799+00	\N
591	4	1	\N	\N	Rose - Pink Xpression	\N	2026-03-08 22:37:18.213004+00	\N
592	4	1	\N	\N	Rose Bright Pink - Mayra's Queen	\N	2026-03-08 22:37:18.213195+00	\N
593	4	1	\N	\N	Rose Coral - Mayra's Peach	\N	2026-03-08 22:37:18.21335+00	\N
594	4	1	\N	\N	Rose White - Playa Blanca	\N	2026-03-08 22:37:18.213502+00	\N
595	4	1	\N	\N	Tip Top Garden Rose - Peach (60 cm)	\N	2026-03-08 22:37:18.213705+00	\N
596	4	1	385	\N	Garden Rose Gold Mustard x12	40952	2026-03-08 22:37:18.214208+00	145
597	4	1	386	\N	Garden Rose HPk Baronesse x12	37158	2026-03-08 22:37:18.214735+00	\N
598	4	1	387	\N	Garden Rose HPk Yves Piage x12	32385	2026-03-08 22:37:18.215207+00	\N
599	4	1	388	\N	Garden Rose Pch Juliet x12	47769	2026-03-08 22:37:18.215742+00	\N
600	4	1	389	\N	Garden Rose Pk Romantic An x12	37310	2026-03-08 22:37:18.216278+00	\N
601	4	1	390	\N	Garden Rose Wht Alabaster x12	37836	2026-03-08 22:37:18.216764+00	\N
602	4	1	391	\N	Garden Rose Wht Cloud x12	67266	2026-03-08 22:37:18.217248+00	\N
603	4	1	392	\N	Garden Rose Wht O'Hara cs50	40175	2026-03-08 22:37:18.217805+00	\N
604	4	1	393	\N	Garden Rose Wht Patience x12	39882	2026-03-08 22:37:18.218353+00	\N
605	4	1	394	\N	Garden Rose Wht Pr. Miyuki x12	37309	2026-03-08 22:37:18.218786+00	\N
606	4	1	395	\N	Garden Rose Wht Purity x12	40862	2026-03-08 22:37:18.219198+00	\N
607	607	1	396	\N	Garden Spray Wht Blanche 6st	42520	2026-03-08 22:37:18.220004+00	\N
608	607	1	397	\N	Garden SpRose Loli x6st	49964	2026-03-08 22:37:18.220718+00	\N
609	609	1	\N	\N	Gardenia Foliage	33448	2026-03-08 22:37:18.221251+00	\N
610	610	1	\N	\N	Gardenia White	10127	2026-03-08 22:37:18.221758+00	\N
611	611	1	398	\N	Gerbera Burgundy Amarone DC	27159	2026-03-08 22:37:18.222518+00	146
612	611	1	398	\N	Gerbera Burgundy Humberto DC	55410	2026-03-08 22:37:18.223011+00	146
613	611	1	400	\N	Gerbera Coral Treasure LC	63324	2026-03-08 22:37:18.223777+00	148
614	611	1	401	\N	Gerbera Crm/Pch Cartizze DC	17660	2026-03-08 22:37:18.224325+00	\N
615	611	1	402	\N	Gerbera Mini Burg Black Tie DC	58992	2026-03-08 22:37:18.224843+00	\N
616	611	1	403	\N	Gerbera Mini Coral Time Out LC	68791	2026-03-08 22:37:18.225339+00	\N
617	611	1	404	\N	Gerbera Mini Cream Milady LC	21468	2026-03-08 22:37:18.225805+00	\N
618	611	1	405	\N	Gerbera Mini Crm/Pch Pelican L	56096	2026-03-08 22:37:18.226276+00	\N
619	611	1	406	\N	Gerbera Mini Lav/Pnk Kimsey LC	28002	2026-03-08 22:37:18.226826+00	\N
620	611	1	407	\N	Gerbera Mini Orange DC	53302	2026-03-08 22:37:18.227338+00	\N
621	611	1	408	\N	Gerbera Mini Orange Jordy DC	49794	2026-03-08 22:37:18.227815+00	\N
622	611	1	409	\N	Gerbera Mini Orange LC	63314	2026-03-08 22:37:18.228476+00	\N
623	611	1	410	\N	Gerbera Mini Peach Cream Cafe	35842	2026-03-08 22:37:18.228946+00	\N
624	611	1	411	\N	Gerbera Mini Peach Larissa LC	55396	2026-03-08 22:37:18.229444+00	\N
625	611	1	412	\N	Gerbera Mini Peach Oreo DC	43353	2026-03-08 22:37:18.229962+00	\N
626	611	1	413	\N	Gerbera Mini Pink Light DC	63313	2026-03-08 22:37:18.230474+00	\N
627	611	1	414	\N	Gerbera Mini Pink Light LC	55705	2026-03-08 22:37:18.231439+00	\N
628	611	1	415	\N	Gerbera Mini Pink-Hot DC	68789	2026-03-08 22:37:18.232145+00	\N
629	611	1	416	\N	Gerbera Mini Pink-Hot LC	42544	2026-03-08 22:37:18.232596+00	\N
630	611	1	417	\N	Gerbera Mini Pk-Ht Wonderwal L	62863	2026-03-08 22:37:18.233023+00	\N
631	611	1	418	\N	Gerbera Mini Purple Dolce DC	25695	2026-03-08 22:37:18.23346+00	\N
632	611	1	419	\N	Gerbera Mini Red DC	43606	2026-03-08 22:37:18.233937+00	\N
633	611	1	420	\N	Gerbera Mini Red LC	43660	2026-03-08 22:37:18.234435+00	\N
634	611	1	421	\N	Gerbera Mini White DC	42161	2026-03-08 22:37:18.235032+00	\N
635	611	1	422	\N	Gerbera Mini White LC	37627	2026-03-08 22:37:18.23552+00	\N
636	611	1	423	\N	Gerbera Mini Yel/Org Franky LC	62900	2026-03-08 22:37:18.236072+00	\N
637	611	1	424	\N	Gerbera Mini Yellow DC	57576	2026-03-08 22:37:18.236748+00	\N
638	611	1	425	\N	Gerbera Mini Yellow LC	28051	2026-03-08 22:37:18.237377+00	\N
639	611	1	398	\N	Gerbera Orange Alex DC	32067	2026-03-08 22:37:18.237973+00	149
640	611	1	400	\N	Gerbera Orange Atlanta LC	57903	2026-03-08 22:37:18.238522+00	150
641	611	1	398	\N	Gerbera Orange Candella DC	34343	2026-03-08 22:37:18.238976+00	149
642	611	1	398	\N	Gerbera Orange Spotlight DC	55401	2026-03-08 22:37:18.23944+00	149
643	611	1	398	\N	Gerbera Peach Alma DC	52786	2026-03-08 22:37:18.240132+00	153
644	611	1	400	\N	Gerbera Peach Avignon LC	43342	2026-03-08 22:37:18.240767+00	154
645	611	1	432	\N	Gerbera Peach Bicolor Julia DC	34771	2026-03-08 22:37:18.241593+00	155
646	611	1	433	\N	Gerbera Peach Cream CafeDelM D	59919	2026-03-08 22:37:18.242396+00	156
647	611	1	434	\N	Gerbera Peach Cream Estate LC	59918	2026-03-08 22:37:18.243152+00	157
648	611	1	398	\N	Gerbera Peach Jetset DC	63303	2026-03-08 22:37:18.243662+00	153
649	611	1	400	\N	Gerbera Peach Pre-Extase LC	49749	2026-03-08 22:37:18.244147+00	154
650	611	1	\N	\N	Gerbera Pink-Hot DC	42615	2026-03-08 22:37:18.244433+00	\N
651	611	1	\N	\N	Gerbera Pink-Hot LC	47908	2026-03-08 22:37:18.244635+00	\N
652	611	1	\N	\N	Gerbera Pink-Hot/White Mandala	63301	2026-03-08 22:37:18.244826+00	\N
653	611	1	\N	\N	Gerbera Pink-Light DC	25789	2026-03-08 22:37:18.245035+00	\N
654	611	1	\N	\N	Gerbera Pink-Light LC	29886	2026-03-08 22:37:18.245228+00	\N
655	611	1	\N	\N	Gerbera Pink-Medium LC	35897	2026-03-08 22:37:18.245437+00	\N
656	611	1	\N	\N	Gerbera Red DC	43594	2026-03-08 22:37:18.24563+00	\N
657	611	1	\N	\N	Gerbera Red LC	29905	2026-03-08 22:37:18.245821+00	\N
658	611	1	437	\N	Gerbera Var Pk Hippie Chic DC	42613	2026-03-08 22:37:18.246312+00	\N
659	611	1	\N	\N	Gerbera White DC	34201	2026-03-08 22:37:18.246563+00	\N
660	611	1	\N	\N	Gerbera White LC	43607	2026-03-08 22:37:18.246761+00	\N
661	611	1	398	\N	Gerbera White/Pink Lisandra DC	42103	2026-03-08 22:37:18.24745+00	160
662	611	1	\N	\N	Gerbera Yellow DC	43639	2026-03-08 22:37:18.247793+00	\N
663	611	1	\N	\N	Gerbera Yellow LC	34200	2026-03-08 22:37:18.248037+00	\N
664	611	1	439	\N	Gerpom Cream Saturn	62903	2026-03-08 22:37:18.248412+00	\N
665	611	1	440	\N	Gerpom Pink Terra Cupid	53409	2026-03-08 22:37:18.249098+00	\N
666	611	1	441	\N	Gerpom Purple Chique	63308	2026-03-08 22:37:18.249645+00	\N
667	611	1	442	\N	Gerpom Red Floyd	53410	2026-03-08 22:37:18.250196+00	\N
668	611	1	443	\N	Gerpom White Terra Amando	53405	2026-03-08 22:37:18.250747+00	\N
669	611	1	444	\N	Gerpom Yellow Rhea	65029	2026-03-08 22:37:18.251252+00	\N
670	611	1	445	\N	Gerrondo Orange Fozzie	58896	2026-03-08 22:37:18.251758+00	\N
671	611	1	446	\N	Gerrondo Peach Beaker	22915	2026-03-08 22:37:18.252242+00	\N
672	611	1	447	\N	Gerrondo Pink-Hot Ravanel 10st	53604	2026-03-08 22:37:18.25267+00	\N
673	673	1	448	\N	Ginestra Pink 200g Italy	22079	2026-03-08 22:37:18.253253+00	\N
674	673	1	449	\N	Ginestra Red 200g Italy	22189	2026-03-08 22:37:18.253779+00	\N
675	673	1	450	\N	Ginestra White 10st Cali	25926	2026-03-08 22:37:18.254293+00	\N
676	673	1	451	\N	Ginestra White 200g Italy	22080	2026-03-08 22:37:18.254808+00	\N
677	677	1	452	\N	Ginger Pink Medium 10pk	10131	2026-03-08 22:37:18.255706+00	161
678	677	1	\N	\N	Ginger Pink Select	37954	2026-03-08 22:37:18.255965+00	\N
679	677	1	452	\N	Ginger Red Medium 10pk	33921	2026-03-08 22:37:18.256413+00	110
680	677	1	\N	\N	Ginger Red Select	37948	2026-03-08 22:37:18.256677+00	\N
681	677	1	\N	\N	Ginger White Medium	10731	2026-03-08 22:37:18.256868+00	\N
682	682	1	\N	\N	Gladiolus Orange California	32420	2026-03-08 22:37:18.257164+00	\N
683	682	1	\N	\N	Gladiolus Peach California	22681	2026-03-08 22:37:18.257358+00	\N
684	682	1	\N	\N	Gladiolus Red California	32424	2026-03-08 22:37:18.257539+00	\N
685	682	1	\N	\N	Gladiolus White California	32436	2026-03-08 22:37:18.257762+00	\N
686	682	1	\N	\N	Gladiolus Yellow California	32425	2026-03-08 22:37:18.257974+00	\N
687	687	1	454	\N	Gomphrenia White	36683	2026-03-08 22:37:18.258485+00	\N
688	688	1	455	\N	Agonis Foliage	G1612	2026-03-08 22:37:18.258947+00	\N
689	688	1	456	\N	Bay Laurel 10st California	G1770	2026-03-08 22:37:18.25934+00	\N
690	688	1	457	\N	Boxwood Africa Bunched	G1016	2026-03-08 22:37:18.259702+00	\N
691	688	1	458	\N	Boxwood American VBC	G1791	2026-03-08 22:37:18.260155+00	\N
692	688	1	459	\N	Artemisia Dusty Miller 60cm 4p	68448	2026-03-08 22:37:18.260647+00	\N
693	688	1	460	\N	Artemisia Dusty Miller 6pk Lg	31530	2026-03-08 22:37:18.261369+00	\N
694	688	1	461	\N	Artemisia Dusty Miller Lacey	26967	2026-03-08 22:37:18.262107+00	\N
695	688	1	462	\N	Artemisia Dusty Miller Lg Leaf	26814	2026-03-08 22:37:18.262623+00	\N
696	688	1	\N	\N	Leather Leaf	\N	2026-03-08 22:37:18.262853+00	\N
697	688	1	463	\N	Fatsia Japonica 10st (Aralia)	G1173	2026-03-08 22:37:18.263295+00	\N
698	688	1	464	\N	Fern Flat	G1052	2026-03-08 22:37:18.263927+00	\N
699	688	1	465	\N	Fern Holly	G1745	2026-03-08 22:37:18.264896+00	\N
700	688	1	466	\N	Fern Sea Star	G1552	2026-03-08 22:37:18.265589+00	\N
701	688	1	467	\N	Fern Umbrella	G1692	2026-03-08 22:37:18.266175+00	\N
702	688	1	468	\N	Foxtail Meyreii	G1058	2026-03-08 22:37:18.266733+00	\N
703	688	1	469	\N	Galax Leaves	G1059	2026-03-08 22:37:18.267232+00	\N
704	688	1	470	\N	Garland Plumosa 25ft	G1060	2026-03-08 22:37:18.267733+00	\N
705	688	1	471	\N	Geranium Scented Foliage	27820	2026-03-08 22:37:18.268195+00	\N
706	688	1	\N	\N	Explosion Grass	\N	2026-03-08 22:37:18.268437+00	\N
707	688	1	\N	\N	Sea Oat Grass	\N	2026-03-08 22:37:18.268636+00	\N
708	688	1	472	\N	Grass Lily (Monkey) Green	G1079	2026-03-08 22:37:18.269215+00	\N
709	688	1	473	\N	Grass Lily (Monkey) Variegated	G1081	2026-03-08 22:37:18.269849+00	\N
710	688	1	\N	\N	Pampas Tall Fresh	\N	2026-03-08 22:37:18.270179+00	\N
711	688	1	474	\N	Green Bouq Simply Spring 15pk	G1366	2026-03-08 22:37:18.270911+00	163
712	688	1	475	\N	Green Bouq Spring Mix 15pk	G1658	2026-03-08 22:37:18.271642+00	164
713	688	1	\N	\N	Acacia Foliage - Pearl Silver	\N	2026-03-08 22:37:18.2719+00	\N
714	688	1	476	\N	Grass Bear	G1015	2026-03-08 22:37:18.272404+00	\N
715	688	1	\N	\N	Bupleurum	\N	2026-03-08 22:37:18.272619+00	\N
716	688	1	\N	\N	Camellia	\N	2026-03-08 22:37:18.272766+00	\N
717	688	1	\N	\N	Dusty Miller - Large Leaf Silver	\N	2026-03-08 22:37:18.272893+00	\N
718	688	1	477	\N	Huckleberry	G1064	2026-03-08 22:37:18.273315+00	\N
719	688	1	478	\N	Ruscus Israel 50-60cm	G1107	2026-03-08 22:37:18.273813+00	\N
720	688	1	479	\N	Ruscus Italian Long	G1109	2026-03-08 22:37:18.274321+00	\N
721	688	1	\N	\N	Ivy	\N	2026-03-08 22:37:18.274589+00	\N
722	688	1	480	\N	Lepidium Green Dragon Californ	13036	2026-03-08 22:37:18.275052+00	\N
723	688	1	\N	\N	Lily Grass	\N	2026-03-08 22:37:18.275281+00	\N
724	688	1	\N	\N	Magnolia Tips	\N	2026-03-08 22:37:18.275598+00	\N
725	688	1	\N	\N	Mixed Evergreen Stems	\N	2026-03-08 22:37:18.275776+00	\N
726	688	1	\N	\N	Olive Greenery	\N	2026-03-08 22:37:18.275954+00	\N
727	688	1	\N	\N	Pennycress Greenery	\N	2026-03-08 22:37:18.27619+00	\N
728	688	1	481	\N	Pittosporum Nigra	G1090	2026-03-08 22:37:18.276649+00	\N
729	688	1	\N	\N	Pittosporum	\N	2026-03-08 22:37:18.276874+00	\N
730	688	1	482	\N	Salal	G1110	2026-03-08 22:37:18.277271+00	\N
731	688	1	\N	\N	Springeri	\N	2026-03-08 22:37:18.277472+00	\N
732	688	1	\N	\N	Table Smilax Vine	G2027	2026-03-08 22:37:18.277626+00	\N
733	688	1	483	\N	Herb Mint Green 5pk	29292	2026-03-08 22:37:18.278015+00	\N
734	688	1	484	\N	Herb Rosemary 5pk	31529	2026-03-08 22:37:18.278477+00	\N
735	688	1	485	\N	Honey Bracelet	G1242	2026-03-08 22:37:18.278944+00	\N
736	688	1	486	\N	Huckleberry 10pk	G1570	2026-03-08 22:37:18.279497+00	\N
737	688	1	487	\N	Huckleberry Red	G1136	2026-03-08 22:37:18.280042+00	\N
738	688	1	488	\N	Ivy Green	G1067	2026-03-08 22:37:18.280572+00	\N
739	688	1	489	\N	Ivy Variegated	G1070	2026-03-08 22:37:18.28108+00	\N
740	688	1	490	\N	Leatherleaf Fern AG/RWB 25pk	G2098	2026-03-08 22:37:18.281573+00	\N
741	688	1	491	\N	Leatherleaf Fern Large Gua 20p	G1714	2026-03-08 22:37:18.282165+00	\N
742	688	1	492	\N	Leatherleaf Fern Large Gua 35p	G2162	2026-03-08 22:37:18.282616+00	\N
743	688	1	493	\N	Leatherleaf Fern Sleeved 12pk	G2325	2026-03-08 22:37:18.283078+00	\N
744	688	1	494	\N	Leatherleaf Fern Sleeved 30pk	G1991	2026-03-08 22:37:18.283622+00	\N
745	688	1	495	\N	Leatherleaf Fern Sporeless 25p	G2044	2026-03-08 22:37:18.284126+00	\N
746	688	1	496	\N	Leatherleaf Fern Std FL 10pk	G1997	2026-03-08 22:37:18.284606+00	\N
747	688	1	497	\N	Leatherleaf Fern Std FL 30pk	G1006	2026-03-08 22:37:18.28508+00	\N
748	688	1	498	\N	Leatherleaf XL Royal FL Slv 35	G1924	2026-03-08 22:37:18.285555+00	\N
749	688	1	499	\N	Lepidium Green Dragon 6pk	58866	2026-03-08 22:37:18.286062+00	\N
750	688	1	500	\N	Ligustrum Green FL	G1806	2026-03-08 22:37:18.28666+00	\N
751	688	1	501	\N	Ligustrum Variegated FL	G1771	2026-03-08 22:37:18.287202+00	\N
752	688	1	502	\N	Ming Fern	G1076	2026-03-08 22:37:18.287669+00	\N
753	688	1	503	\N	Moss Sheet Fresh Local	G2342	2026-03-08 22:37:18.288204+00	\N
754	688	1	504	\N	Moss Sheet Fresh/Wet 8lb	G1811	2026-03-08 22:37:18.288733+00	\N
755	688	1	505	\N	Moss Spanish	G1785	2026-03-08 22:37:18.289235+00	\N
756	688	1	506	\N	Myrtle Large	G1082	2026-03-08 22:37:18.28993+00	\N
757	688	1	507	\N	Nandina	G1265	2026-03-08 22:37:18.290515+00	\N
758	688	1	508	\N	Pittosporum Green	G1094	2026-03-08 22:37:18.291031+00	\N
759	688	1	509	\N	Pittosporum Green 10pk	G1574	2026-03-08 22:37:18.291537+00	\N
760	688	1	510	\N	Pittosporum Variegated	G1098	2026-03-08 22:37:18.292121+00	\N
761	688	1	511	\N	Pittosporum Variegated 10pk	G1575	2026-03-08 22:37:18.292592+00	\N
762	688	1	\N	\N	Plumosus Grass	G1100	2026-03-08 22:37:18.292933+00	\N
763	688	1	512	\N	Plumosus Grass 10pk	G1103	2026-03-08 22:37:18.29347+00	165
764	688	1	513	\N	Podocarpus	G1322	2026-03-08 22:37:18.293965+00	\N
765	688	1	514	\N	Podocarpus Weeping	G2103	2026-03-08 22:37:18.294453+00	\N
766	688	1	515	\N	Rumex Unicorn 60cm+	12969	2026-03-08 22:37:18.294886+00	\N
767	688	1	516	\N	Ruscus Florida 20pk	G1106	2026-03-08 22:37:18.295398+00	\N
768	688	1	517	\N	Ruscus Italian Bleached 5st	G2273	2026-03-08 22:37:18.295922+00	\N
769	688	1	518	\N	Ruscus Italian Long 10pk	G1355	2026-03-08 22:37:18.296363+00	\N
770	688	1	519	\N	Ruscus Italian Long 15pk	G2314	2026-03-08 22:37:18.296819+00	\N
771	688	1	520	\N	Ruscus Italian Long 20pk	G2313	2026-03-08 22:37:18.297333+00	\N
772	688	1	521	\N	Ruscus Italian Tips Short	G1108	2026-03-08 22:37:18.297854+00	\N
773	688	1	522	\N	Salal 10pk	G1573	2026-03-08 22:37:18.298432+00	\N
774	688	1	523	\N	Salal Little John (Tips)	G1112	2026-03-08 22:37:18.299046+00	\N
775	688	1	524	\N	Salal Little John (Tips)15pk	G1630	2026-03-08 22:37:18.299657+00	\N
776	688	1	\N	\N	Cherry Laurel - Half Box	\N	2026-03-08 22:37:18.299934+00	\N
777	688	1	\N	\N	Elaeagnus Vine (full box)	\N	2026-03-08 22:37:18.300135+00	\N
778	688	1	\N	\N	Elaeagnus Vines (half Box)	\N	2026-03-08 22:37:18.300354+00	\N
779	688	1	\N	\N	Smilax Full Box	\N	2026-03-08 22:37:18.300617+00	\N
780	688	1	\N	\N	Smilax Half Box	\N	2026-03-08 22:37:18.300811+00	\N
781	688	1	\N	\N	Smilax Jumbo Box ( East Texas )	\N	2026-03-08 22:37:18.300998+00	\N
782	688	1	\N	\N	Water Oak - Full Box (East Texas Smilax)	\N	2026-03-08 22:37:18.301197+00	\N
783	688	1	\N	\N	Water Oak - Half Box (East Texas Smilax)	\N	2026-03-08 22:37:18.30142+00	\N
784	688	1	525	\N	Smilax Green 5 x 5ft Strings	G2027	2026-03-08 22:37:18.301891+00	\N
785	688	1	526	\N	Smilax Southern 13lbs Texas	G6654	2026-03-08 22:37:18.302379+00	\N
786	688	1	527	\N	Smilax Southern Alabama 30lbs	G1591	2026-03-08 22:37:18.302922+00	\N
787	688	1	528	\N	Sword Fern	G1119	2026-03-08 22:37:18.303324+00	\N
788	688	1	529	\N	Tree Fern Costa Rica 30pk	G1121	2026-03-08 22:37:18.303711+00	\N
789	688	1	530	\N	Tree Fern Florida	G1122	2026-03-08 22:37:18.304121+00	\N
790	688	1	531	\N	Tree Fern Florida 5pk	G1577	2026-03-08 22:37:18.304681+00	\N
791	791	1	532	\N	Grevillea Ivanhoe	G1682	2026-03-08 22:37:18.305396+00	\N
792	791	1	\N	\N	Grevillea Natural	G1606	2026-03-08 22:37:18.305638+00	\N
793	793	1	533	\N	Heather Pink / California	21059	2026-03-08 22:37:18.306326+00	166
794	794	1	534	\N	Heliconia Pinky Peach P&F	42395	2026-03-08 22:37:18.307207+00	167
795	795	1	\N	\N	Hellebore - Queen of the Night	\N	2026-03-08 22:37:18.30755+00	\N
796	796	1	535	\N	Helleborus Green 5-7st Calif	38826	2026-03-08 22:37:18.308363+00	168
797	796	1	535	\N	Helleborus Pink 5-7st Calif	18148	2026-03-08 22:37:18.308898+00	169
798	796	1	537	\N	Helleborus Pink Mammoth 5 stem	69034	2026-03-08 22:37:18.309554+00	170
799	796	1	535	\N	Helleborus Purple 5-7st Calif	17828	2026-03-08 22:37:18.310116+00	171
800	796	1	537	\N	Helleborus Red Mammoth 5 stem	69037	2026-03-08 22:37:18.310606+00	172
801	796	1	540	\N	Helleborus White Queen 10st	45449	2026-03-08 22:37:18.311339+00	173
802	796	1	541	\N	Helleborus Winterbells 5 stem	12638	2026-03-08 22:37:18.312019+00	\N
803	803	1	\N	\N	Lavender English	27972	2026-03-08 22:37:18.312332+00	\N
804	804	1	542	\N	Hyacinth White 5st Dutch	22084	2026-03-08 22:37:18.313404+00	174
805	804	1	542	\N	Hyacinth Pink 5st Dutch	22082	2026-03-08 22:37:18.313993+00	175
806	806	1	\N	\N	Hydrangea - Antique Green	\N	2026-03-08 22:37:18.314345+00	\N
807	806	1	\N	\N	Hydrangea - Antique Pink	\N	2026-03-08 22:37:18.314569+00	\N
808	806	1	\N	\N	Hydrangea - Antique Red	\N	2026-03-08 22:37:18.314928+00	\N
809	806	1	\N	\N	Hydrangea - Baby Green	\N	2026-03-08 22:37:18.315198+00	\N
810	806	1	\N	\N	Hydrangea - Lime Green	\N	2026-03-08 22:37:18.31541+00	\N
811	806	1	544	\N	Hydrangea Bl-Dk Shocking 30pk	43323	2026-03-08 22:37:18.315892+00	\N
812	806	1	\N	\N	Hydrangea Green - Esmeralda	\N	2026-03-08 22:37:18.31617+00	\N
813	806	1	545	\N	Hydrangea Blue Select 30pk	21825	2026-03-08 22:37:18.316777+00	176
814	806	1	\N	\N	Hydrangea Light/Medium Pink	\N	2026-03-08 22:37:18.317037+00	\N
815	806	1	\N	\N	Hydrangea White - Extra	\N	2026-03-08 22:37:18.317219+00	\N
816	806	1	546	\N	Hydrangea 12white/12blue 24pk	27220	2026-03-08 22:37:18.317617+00	\N
817	806	1	547	\N	Hydrangea 15White/15blue 30pk	43307	2026-03-08 22:37:18.318055+00	\N
818	806	1	548	\N	Hydrangea 5white/5blue 10pack	43478	2026-03-08 22:37:18.318645+00	\N
819	806	1	549	\N	Hydrangea 5wht/5blue DV 10pk	51291	2026-03-08 22:37:18.319147+00	\N
820	806	1	550	\N	Hydrangea 8wht/8blue/8grn 24pk	42063	2026-03-08 22:37:18.319687+00	\N
821	806	1	551	\N	Hydrangea Blue "Bogotana" 10pk	58305	2026-03-08 22:37:18.320758+00	177
822	806	1	552	\N	Hydrangea Blue Prem DVF 20pk	51266	2026-03-08 22:37:18.321633+00	178
823	806	1	553	\N	Hydrangea Blue Select 10pack	43477	2026-03-08 22:37:18.322307+00	179
824	806	1	554	\N	Hydrangea Blue Select 40pk	43374	2026-03-08 22:37:18.322992+00	180
825	806	1	555	\N	Hydrangea Blue Select DVF 10pk	51290	2026-03-08 22:37:18.32366+00	181
826	806	1	556	\N	Hydrangea Blue Super 20pk	42343	2026-03-08 22:37:18.324347+00	182
827	806	1	557	\N	Hydrangea Blueberry Select 30p	13043	2026-03-08 22:37:18.324999+00	183
828	806	1	558	\N	Hydrangea Green Antique Sel 30	35093	2026-03-08 22:37:18.325818+00	184
829	806	1	545	\N	Hydrangea Green Fancy 30pk	42059	2026-03-08 22:37:18.326326+00	185
830	806	1	554	\N	Hydrangea Green Mini 40pk	28306	2026-03-08 22:37:18.326693+00	186
831	806	1	552	\N	Hydrangea Green Mini DVF 20pk	51364	2026-03-08 22:37:18.327105+00	187
832	806	1	562	\N	Hydrangea Green Mini Mojito	48987	2026-03-08 22:37:18.327776+00	188
833	806	1	563	\N	Hydrangea Green Mojito Sel 10p	17375	2026-03-08 22:37:18.328516+00	189
834	806	1	564	\N	Hydrangea Green Mojito Sel 30p	43493	2026-03-08 22:37:18.329208+00	190
835	806	1	551	\N	Hydrangea Green Shamrock 10pk	17363	2026-03-08 22:37:18.329814+00	191
836	806	1	545	\N	Hydrangea Green Shamrock 30pk	53542	2026-03-08 22:37:18.33041+00	185
837	806	1	556	\N	Hydrangea Green-Dark Mini 20pk	12584	2026-03-08 22:37:18.331047+00	193
838	806	1	568	\N	Hydrangea Green-Dark Mini 50pk	42065	2026-03-08 22:37:18.331724+00	194
839	806	1	551	\N	Hydrangea Pink Crystal 10pk	13030	2026-03-08 22:37:18.332197+00	161
840	806	1	551	\N	Hydrangea Pink Magic 10pk	75214	2026-03-08 22:37:18.332731+00	161
841	806	1	571	\N	Hydrangea Purple Elite 25pk	43707	2026-03-08 22:37:18.343545+00	197
842	806	1	572	\N	Hydrangea Purple Premium 20p	42173	2026-03-08 22:37:18.344338+00	198
843	806	1	\N	\N	Hydrangea Purple-Dark Premium	34784	2026-03-08 22:37:18.344641+00	\N
844	806	1	573	\N	Hydrangea Tint Rouge Pink 15p	18119	2026-03-08 22:37:18.345281+00	\N
845	806	1	574	\N	Hydrangea Tinted Crm/Blsh 15pk	57346	2026-03-08 22:37:18.345724+00	\N
846	806	1	575	\N	Hydrangea Tinted Dusty Burg 15	17912	2026-03-08 22:37:18.3466+00	\N
847	806	1	576	\N	Hydrangea Tinted Lavender 15pk	75204	2026-03-08 22:37:18.347329+00	\N
848	806	1	577	\N	Hydrangea Tinted Mauve 15pk	75210	2026-03-08 22:37:18.347867+00	\N
849	806	1	578	\N	Hydrangea Tinted Peach 15pk	75211	2026-03-08 22:37:18.348354+00	\N
850	806	1	579	\N	Hydrangea Tinted Purple 15pk	75118	2026-03-08 22:37:18.348886+00	\N
851	806	1	580	\N	Hydrangea Wht Jumbo Loose	26961	2026-03-08 22:37:18.349408+00	\N
852	806	1	581	\N	Hydrangea Wht Prem DVF 20pk	51265	2026-03-08 22:37:18.349895+00	\N
853	806	1	582	\N	Hydrangea Wht Premium 25pk	21711	2026-03-08 22:37:18.350431+00	\N
854	806	1	583	\N	Hydrangea Wht Premium DVF 10pk	75115	2026-03-08 22:37:18.350956+00	\N
855	806	1	584	\N	Hydrangea Wht Select 24pk	27146	2026-03-08 22:37:18.351462+00	\N
856	806	1	585	\N	Hydrangea Wht Select 30pk	21830	2026-03-08 22:37:18.352046+00	\N
857	806	1	586	\N	Hydrangea Wht Select 40pk	49829	2026-03-08 22:37:18.352577+00	\N
858	806	1	587	\N	Hydrangea Wht Select DVF 10pk	51289	2026-03-08 22:37:18.353134+00	\N
859	806	1	588	\N	Hydrangea Wht Select S.A 10pk	43476	2026-03-08 22:37:18.353594+00	\N
860	806	1	589	\N	Hydrangea Wht Super 24pk	54035	2026-03-08 22:37:18.353983+00	\N
861	806	1	\N	\N	Hydrangea - Baby Green	28306	2026-03-08 22:37:18.354486+00	\N
862	806	1	\N	\N	Hydrangea Antique Green XL	33702	2026-03-08 22:37:18.354794+00	\N
863	806	1	590	\N	Hydrangea Bl-Dk Shocking 10pk	28584	2026-03-08 22:37:18.355325+00	\N
864	864	1	\N	\N	Hypericum Burgundy	\N	2026-03-08 22:37:18.355628+00	\N
865	864	1	\N	\N	Hypericum Cream	\N	2026-03-08 22:37:18.355835+00	\N
866	864	1	\N	\N	Hypericum Orange	\N	2026-03-08 22:37:18.356042+00	\N
867	864	1	\N	\N	Hypericum Peach	\N	2026-03-08 22:37:18.356246+00	\N
868	864	1	\N	\N	Hypericum Pink	\N	2026-03-08 22:37:18.356441+00	\N
869	864	1	\N	\N	Hypericum Red	\N	2026-03-08 22:37:18.356624+00	\N
870	864	1	\N	\N	Hypericum White	\N	2026-03-08 22:37:18.356874+00	\N
871	864	1	591	\N	Hypericum Burg Ilusion 50/60c	68371	2026-03-08 22:37:18.357427+00	\N
872	864	1	592	\N	Hypericum Green 70cm DVFlora	50502	2026-03-08 22:37:18.358107+00	199
873	864	1	593	\N	Hypericum Green Ilusion 50/60c	68368	2026-03-08 22:37:18.358837+00	200
874	864	1	594	\N	Hypericum Grn Jungle Roma 50/6	36487	2026-03-08 22:37:18.359373+00	\N
875	864	1	595	\N	Hypericum Grn Lucky Rom 50/60	32269	2026-03-08 22:37:18.359769+00	\N
876	864	1	596	\N	Hypericum Pch Mellow Rom 50/60	36435	2026-03-08 22:37:18.360151+00	\N
877	864	1	597	\N	Hypericum Pink Ilusion 50/60cm	25765	2026-03-08 22:37:18.360676+00	201
878	864	1	598	\N	Hypericum Pink Sweet Rom 50/60	12280	2026-03-08 22:37:18.36136+00	202
879	864	1	599	\N	Hypericum Pk Lt Lovely Rom 50/	17687	2026-03-08 22:37:18.36192+00	\N
880	864	1	592	\N	Hypericum Red 70cm DvFlora	50501	2026-03-08 22:37:18.362432+00	203
881	864	1	601	\N	Hypericum Red Dk 70cm DvFlora	50503	2026-03-08 22:37:18.363242+00	204
882	864	1	597	\N	Hypericum Red Ilusion 50/60cm	68361	2026-03-08 22:37:18.363881+00	205
883	864	1	603	\N	Hypericum Red True Rom 50/60cm	20397	2026-03-08 22:37:18.364676+00	206
884	864	1	598	\N	Hypericum White Cool Rom 50/60	36434	2026-03-08 22:37:18.365266+00	207
885	885	1	605	\N	Iris Blue-Dk Telstar Local	25313	2026-03-08 22:37:18.366049+00	208
886	885	1	606	\N	Iris Blue-Dk Telstar Mexico	35584	2026-03-08 22:37:18.366779+00	209
887	885	1	606	\N	Iris White Casablanca Mexico	35583	2026-03-08 22:37:18.367366+00	210
888	885	1	\N	\N	Iris White Local	33368	2026-03-08 22:37:18.367632+00	\N
889	885	1	\N	\N	Iris Yellow Carolina	37810	2026-03-08 22:37:18.367831+00	\N
890	890	1	608	\N	Ivy Bush Green	G1180	2026-03-08 22:37:18.368351+00	\N
891	891	1	609	\N	Kale Purple/Green 5st Peru	75084	2026-03-08 22:37:18.369051+00	211
892	892	1	610	\N	Larkspur Pink 80/90cm Ecuador	44028	2026-03-08 22:37:18.369755+00	212
893	892	1	611	\N	Larkspur Purple 80/90cm Ecuado	44027	2026-03-08 22:37:18.37044+00	213
894	892	1	610	\N	Larkspur White 80/90cm Ecuador	44026	2026-03-08 22:37:18.37115+00	214
895	892	1	\N	\N	Larkspur Lavender 60-70cm	28047	2026-03-08 22:37:18.371444+00	\N
896	892	1	610	\N	Larkspur Pink 60/70cm Ecuador	29725	2026-03-08 22:37:18.371907+00	212
897	892	1	614	\N	Larkspur Pink 80-90cm 6pk	21112	2026-03-08 22:37:18.372729+00	216
898	892	1	615	\N	Larkspur Pink-Dk 70-80cm CA	32224	2026-03-08 22:37:18.37333+00	217
899	892	1	616	\N	Larkspur Pink-Dk 80+cm XTR	21081	2026-03-08 22:37:18.373962+00	218
900	892	1	616	\N	Larkspur Pink-Lt 80+cm XTR	21084	2026-03-08 22:37:18.374421+00	218
901	892	1	618	\N	Larkspur Purple 60/70cm Ec	21113	2026-03-08 22:37:18.375085+00	220
902	892	1	615	\N	Larkspur Purple 70-80cm CA	32228	2026-03-08 22:37:18.375622+00	221
903	892	1	614	\N	Larkspur Purple 80-90cm 6pk	28449	2026-03-08 22:37:18.376167+00	222
904	892	1	611	\N	Larkspur White 60/70cm Ecuado	21114	2026-03-08 22:37:18.376685+00	223
905	892	1	615	\N	Larkspur White 70-80cm CA	32229	2026-03-08 22:37:18.377247+00	224
906	892	1	614	\N	Larkspur White 80-90cm 6pk	28450	2026-03-08 22:37:18.377758+00	225
907	907	1	\N	\N	Leptospermum Pink	25696	2026-03-08 22:37:18.378069+00	\N
908	907	1	\N	\N	Leptospermum Pink-Hot	26430	2026-03-08 22:37:18.378273+00	\N
909	907	1	\N	\N	Leptospermum White	25212	2026-03-08 22:37:18.378458+00	\N
910	910	1	624	\N	Leucadendron Gold Strike 10st	38045	2026-03-08 22:37:18.379096+00	226
911	910	1	625	\N	Leucadendron Safari Sunset	36101	2026-03-08 22:37:18.379573+00	\N
912	910	1	626	\N	Leucadendron Winter Sunshine	10602	2026-03-08 22:37:18.380042+00	\N
913	913	1	627	\N	Leucocoryne Lav Caravelle 10st	54469	2026-03-08 22:37:18.380613+00	\N
914	914	1	628	\N	Liatris Purple 70cm 6pk	52373	2026-03-08 22:37:18.381271+00	222
915	914	1	\N	\N	Liatris Purple 80 cm	21167	2026-03-08 22:37:18.381547+00	\N
916	914	1	\N	\N	Liatris Purple 90 cm	21169	2026-03-08 22:37:18.38181+00	\N
917	917	1	\N	\N	Lilac Lavender	\N	2026-03-08 22:37:18.382216+00	\N
918	918	1	629	\N	Lily Hyb Pk Binazco 2blm	67957	2026-03-08 22:37:18.382789+00	\N
919	918	1	630	\N	Lily Hyb Pk Brooks 3+	67965	2026-03-08 22:37:18.383292+00	\N
920	918	1	631	\N	Lily Hyb Pnk King Solomon 3+	50620	2026-03-08 22:37:18.383743+00	\N
921	918	1	632	\N	Lily Hyb Pnk Sorbonne 2/3 Cana	41485	2026-03-08 22:37:18.384253+00	\N
922	918	1	633	\N	Lily Hyb Pnk Sorbonne 2blm	57668	2026-03-08 22:37:18.384752+00	\N
923	918	1	634	\N	Lily Hyb Pnk Sorbonne 4/5 Cana	41486	2026-03-08 22:37:18.38527+00	\N
924	918	1	635	\N	Lily Hyb Pnk Table Dance 2/3 C	41487	2026-03-08 22:37:18.385772+00	\N
925	918	1	636	\N	Lily Hyb Pnk Table Dance 3+	53984	2026-03-08 22:37:18.386403+00	\N
926	918	1	637	\N	Lily Hyb Pnk Table Dance 3+ DV	26407	2026-03-08 22:37:18.387263+00	\N
927	918	1	638	\N	Lily Hyb Pnk Table Dance 4/5 C	41488	2026-03-08 22:37:18.387741+00	\N
928	918	1	639	\N	Lily Hyb Pnk Tarrango 2/3 Cana	41489	2026-03-08 22:37:18.388168+00	\N
929	918	1	640	\N	Lily Hyb Pnk Tarrango 2blm	26256	2026-03-08 22:37:18.38858+00	\N
930	918	1	641	\N	Lily Hyb Pnk Tarrango 3+	55824	2026-03-08 22:37:18.389023+00	\N
931	918	1	642	\N	Lily Hyb Pnk Tarrango 4/5 Cana	41490	2026-03-08 22:37:18.389555+00	\N
932	918	1	643	\N	Lily Hyb Wht Monteneu 3+	53994	2026-03-08 22:37:18.390042+00	\N
933	918	1	644	\N	Lily Hyb Wht Premium Blonde 3+	48793	2026-03-08 22:37:18.390623+00	\N
934	918	1	645	\N	Lily Hyb Wht Santander 3+	55445	2026-03-08 22:37:18.391282+00	\N
935	918	1	646	\N	Lily Hyb Wht Santander 4/5 Can	41480	2026-03-08 22:37:18.391837+00	\N
936	918	1	647	\N	Lily Hyb Wht Saronno 3+	54161	2026-03-08 22:37:18.392362+00	\N
937	918	1	648	\N	Lily Hyb Wht Saronno 4+ DVFlor	34102	2026-03-08 22:37:18.392869+00	\N
938	918	1	649	\N	Lily Hyb Wht Tisento 4+ DVFlor	57638	2026-03-08 22:37:18.393373+00	\N
939	918	1	650	\N	Lily Hyb Wht Zambesi 2/3 Canad	41483	2026-03-08 22:37:18.393849+00	\N
940	918	1	651	\N	Lily Hyb Wht Zambesi 2blm	57667	2026-03-08 22:37:18.394296+00	\N
941	918	1	652	\N	Lily Hyb Wht Zambesi 4/5 Canad	41484	2026-03-08 22:37:18.394765+00	\N
942	918	1	653	\N	Lily Hyb Yel Vigneron 2/3 Cana	41518	2026-03-08 22:37:18.395253+00	\N
943	918	1	654	\N	Lily Hyb Ylw Catina 3+	67912	2026-03-08 22:37:18.395719+00	\N
944	918	1	655	\N	Lily Hyb Ylw Manisa 3+ DVF	52706	2026-03-08 22:37:18.39621+00	\N
945	918	1	656	\N	Lily LA Orange Talisker NC	68068	2026-03-08 22:37:18.396688+00	\N
946	918	1	657	\N	Lily LA Org Eremo 3+	55782	2026-03-08 22:37:18.397168+00	\N
947	918	1	658	\N	Lily LA Org Honesty 3+	55781	2026-03-08 22:37:18.397635+00	\N
948	918	1	659	\N	Lily LA Org Sunderland 3+	22744	2026-03-08 22:37:18.398114+00	\N
949	918	1	660	\N	Lily LA Pch Menorca 3+	41072	2026-03-08 22:37:18.398613+00	\N
950	918	1	661	\N	Lily LA Pch Salmon Classic NC	53851	2026-03-08 22:37:18.399145+00	\N
951	918	1	662	\N	Lily LA Peach 3+ Canada	46426	2026-03-08 22:37:18.39961+00	\N
952	918	1	663	\N	Lily LA Pink 3+ Canada	41475	2026-03-08 22:37:18.400113+00	\N
953	918	1	664	\N	Lily LA Pink Albufeira 3+	54155	2026-03-08 22:37:18.400602+00	\N
954	918	1	665	\N	Lily LA Pink Bourbon Street 3+	57653	2026-03-08 22:37:18.401067+00	\N
955	918	1	666	\N	Lily LA Pink Brindisi 3+	40146	2026-03-08 22:37:18.401564+00	\N
956	918	1	667	\N	Lily LA Pink Brindisi NC	53853	2026-03-08 22:37:18.401957+00	\N
957	918	1	668	\N	Lily LA Pink Indian Summerset	57655	2026-03-08 22:37:18.402502+00	\N
958	918	1	669	\N	Lily LA Pink Yerseke 3+	49303	2026-03-08 22:37:18.403261+00	\N
959	918	1	670	\N	Lily LA Red Pokerface 3+	57105	2026-03-08 22:37:18.403798+00	\N
960	918	1	671	\N	Lily LA White 3+ Canada	41478	2026-03-08 22:37:18.404294+00	\N
961	918	1	672	\N	Lily LA White Perrano NC	20221	2026-03-08 22:37:18.404726+00	\N
962	918	1	673	\N	Lily LA Wht Bach 3+	33110	2026-03-08 22:37:18.405225+00	\N
963	918	1	674	\N	Lily LA Wht Charm 3+	68078	2026-03-08 22:37:18.40575+00	\N
964	918	1	675	\N	Lily LA Wht Courier 3+	57652	2026-03-08 22:37:18.406253+00	\N
965	918	1	676	\N	Lily LA Wht Litouwen 3+	68104	2026-03-08 22:37:18.406741+00	\N
966	918	1	677	\N	Lily LA Wht Parrano 3+	55789	2026-03-08 22:37:18.407207+00	\N
967	918	1	678	\N	Lily LA Wht Richmond 3+	54157	2026-03-08 22:37:18.407677+00	\N
968	918	1	679	\N	Lily LA Wht Sound 3+	57648	2026-03-08 22:37:18.408068+00	\N
969	918	1	680	\N	Lily LA Yellow Pavia NC	53848	2026-03-08 22:37:18.408481+00	\N
970	918	1	681	\N	Lily LA Ylw El Divo 3+	46698	2026-03-08 22:37:18.408863+00	\N
971	918	1	682	\N	Lily LA Ylw Pavia 3+	55852	2026-03-08 22:37:18.409272+00	\N
972	918	1	683	\N	Lily Org Brunello 3+	34528	2026-03-08 22:37:18.409678+00	\N
973	918	1	684	\N	Lily Org Tressor 3+	34935	2026-03-08 22:37:18.410164+00	\N
974	918	1	685	\N	Lily OT Conca D'Or 2blm	57672	2026-03-08 22:37:18.410618+00	\N
975	918	1	686	\N	Lily Rose Dbl Anoushka 2/3 Can	41503	2026-03-08 22:37:18.411104+00	\N
976	918	1	687	\N	Lily Rose Dbl Pnk Floretta 2/3	41497	2026-03-08 22:37:18.411597+00	\N
977	918	1	688	\N	Lily Rose Dbl Pnk Samantha 2/3	41499	2026-03-08 22:37:18.412125+00	\N
978	918	1	689	\N	Lily Rose Dbl Pnk Viola 2/3 Ca	41501	2026-03-08 22:37:18.41269+00	\N
979	918	1	690	\N	Lily Rose Dbl Pnk Viola 4/5 Ca	41502	2026-03-08 22:37:18.413418+00	\N
980	918	1	691	\N	Lily Rose Dbl Wht Aisha 2/3 Ca	41491	2026-03-08 22:37:18.413981+00	\N
981	918	1	692	\N	Lily Rose Dbl Wht Aisha 4/5 Ca	41492	2026-03-08 22:37:18.414479+00	\N
982	982	1	\N	\N	Asiatic Lily White -Richmond	\N	2026-03-08 22:37:18.414775+00	\N
983	982	1	\N	\N	Lily Orange - Amiga	\N	2026-03-08 22:37:18.41496+00	\N
984	984	1	\N	\N	Limonium White Misty	32957	2026-03-08 22:37:18.415219+00	\N
985	984	1	\N	\N	Limonium - Pina Colada	\N	2026-03-08 22:37:18.415403+00	\N
986	984	1	\N	\N	Limonium - White Sinesis	\N	2026-03-08 22:37:18.415643+00	\N
987	984	1	\N	\N	Limonium Lavender- Sky Light	\N	2026-03-08 22:37:18.415834+00	\N
988	984	1	\N	\N	Limonium Purple - Misty Blue	\N	2026-03-08 22:37:18.416013+00	\N
989	984	1	\N	\N	Limonium Purple- Shooting Star	\N	2026-03-08 22:37:18.416203+00	\N
990	984	1	\N	\N	Limonium- Silver Pink	\N	2026-03-08 22:37:18.416407+00	\N
991	984	1	\N	\N	Limonium Blue Maine	29411	2026-03-08 22:37:18.416658+00	\N
992	984	1	\N	\N	Limonium Blue Splendid	60802	2026-03-08 22:37:18.416851+00	\N
993	984	1	693	\N	Limonium Blue Splendid Cs5	26800	2026-03-08 22:37:18.417471+00	228
994	984	1	\N	\N	Limonium White Diamond	21179	2026-03-08 22:37:18.417723+00	\N
995	984	1	694	\N	Limonium White Misty 5pk	21181	2026-03-08 22:37:18.418303+00	229
996	984	1	\N	\N	Limonium Pink Sinensis	21178	2026-03-08 22:37:18.418553+00	\N
997	997	1	\N	\N	Lisianthus Blush	\N	2026-03-08 22:37:18.418819+00	\N
998	997	1	\N	\N	Lisianthus Brown - Rosanne	\N	2026-03-08 22:37:18.419007+00	\N
999	997	1	\N	\N	Lisianthus Brown - Wondrous	\N	2026-03-08 22:37:18.419189+00	\N
1000	997	1	\N	\N	Lisianthus Cream	\N	2026-03-08 22:37:18.419365+00	\N
1001	997	1	695	\N	Lisianthus Prp Rosaflora 75cm	42193	2026-03-08 22:37:18.41989+00	\N
1002	997	1	696	\N	Lisianthus Green Rosaflora 75c	21226	2026-03-08 22:37:18.420511+00	230
1003	997	1	\N	\N	Lisianthus Hot Pink	\N	2026-03-08 22:37:18.420767+00	\N
1004	997	1	\N	\N	Lisianthus Lavender	\N	2026-03-08 22:37:18.420946+00	\N
1005	997	1	697	\N	Lisianthus Apricot Rosaflor 75	53413	2026-03-08 22:37:18.421389+00	\N
1006	997	1	\N	\N	Lisianthus Pink RosaFlora 75cm	43330	2026-03-08 22:37:18.421618+00	\N
1007	997	1	696	\N	Lisianthus White RosaFlora 75c	21323	2026-03-08 22:37:18.422116+00	231
1008	997	1	\N	\N	Lisianthus Champagne 80cm	42368	2026-03-08 22:37:18.422437+00	\N
1009	997	1	699	\N	Lisianthus Magenta Rosaflor	42466	2026-03-08 22:37:18.422949+00	\N
1010	997	1	700	\N	Lisianthus Pink Canada 50/60cm	26755	2026-03-08 22:37:18.423581+00	201
1011	997	1	\N	\N	Lisianthus Pink Light 80cm	21272	2026-03-08 22:37:18.423833+00	\N
1012	997	1	701	\N	Lisianthus Pk Lt RosaFlora 75c	17328	2026-03-08 22:37:18.424263+00	\N
1013	997	1	702	\N	Lisianthus Pk Var Rosaflora 75	26751	2026-03-08 22:37:18.424641+00	\N
1014	997	1	703	\N	Lisianthus Prp Var Rosaflora 7	21312	2026-03-08 22:37:18.425014+00	\N
1015	997	1	704	\N	Lisianthus Purple Canada 50/60	44892	2026-03-08 22:37:18.425759+00	233
1016	997	1	\N	\N	Lisianthus White 80cm	21316	2026-03-08 22:37:18.426008+00	\N
1017	1017	1	\N	\N	Marigold Orange	\N	2026-03-08 22:37:18.426288+00	\N
1018	1018	1	\N	\N	Mini Carnation - Clavel Vinium	\N	2026-03-08 22:37:18.426565+00	\N
1019	1018	1	\N	\N	Mini Carnation - Moorea	\N	2026-03-08 22:37:18.426752+00	\N
1020	1018	1	\N	\N	Mini Carnation Burgundy - Chateau	\N	2026-03-08 22:37:18.426971+00	\N
1021	1018	1	\N	\N	Mini Carnation Canela	\N	2026-03-08 22:37:18.427208+00	\N
1022	1018	1	\N	\N	Mini Carnation Peach	\N	2026-03-08 22:37:18.427408+00	\N
1023	1018	1	\N	\N	Mini Carnation Pink Roxanne	\N	2026-03-08 22:37:18.427594+00	\N
1024	1018	1	\N	\N	Mini Carnation Red - Scarlette	\N	2026-03-08 22:37:18.428115+00	\N
1025	1018	1	\N	\N	Mini Carnation Red- Aragon	\N	2026-03-08 22:37:18.428529+00	\N
1026	1018	1	\N	\N	Mini Carnation White - Selene	\N	2026-03-08 22:37:18.42921+00	\N
1027	1018	1	\N	\N	Mini Carnation White Ibis	\N	2026-03-08 22:37:18.429529+00	\N
1028	1018	1	\N	\N	Mini Carnation Yellow- Alessia	\N	2026-03-08 22:37:18.429785+00	\N
1029	1018	1	\N	\N	Mini Carnation Burgundy	\N	2026-03-08 22:37:18.430036+00	\N
1030	1018	1	\N	\N	Mini Carnation Cream	\N	2026-03-08 22:37:18.43027+00	\N
1031	1018	1	\N	\N	Mini Carnation Hot Pink	\N	2026-03-08 22:37:18.430533+00	\N
1032	1018	1	\N	\N	Mini Carnation Pink	\N	2026-03-08 22:37:18.430799+00	\N
1033	1018	1	\N	\N	Mini Carnation Red	\N	2026-03-08 22:37:18.431086+00	\N
1034	1018	1	\N	\N	Mini Carnation White	\N	2026-03-08 22:37:18.43131+00	\N
1035	1018	1	\N	\N	Mini Carnation White	\N	2026-03-08 22:37:18.431556+00	\N
1036	1018	1	\N	\N	Mini Carnation Yellow	\N	2026-03-08 22:37:18.431797+00	\N
1037	1037	1	\N	\N	Nigella Light Blue	27649	2026-03-08 22:37:18.432269+00	\N
1038	1037	1	\N	\N	Nigella Light Pink	\N	2026-03-08 22:37:18.432539+00	\N
1039	1037	1	\N	\N	Nigella White	\N	2026-03-08 22:37:18.433009+00	\N
1040	1037	1	705	\N	Nigella Blue 10stem Japan	49731	2026-03-08 22:37:18.433852+00	234
1041	1037	1	\N	\N	Nigella Blue Japan	49731	2026-03-08 22:37:18.434168+00	\N
1042	1037	1	\N	\N	Nigella Pods Black	29505	2026-03-08 22:37:18.434349+00	\N
1043	1043	1	\N	\N	Oncidium Golden Shower	46554	2026-03-08 22:37:18.434632+00	\N
1044	1044	1	\N	\N	Cymbidium Orchid - Madelon Red	\N	2026-03-08 22:37:18.434901+00	\N
1045	1044	1	\N	\N	Dendrobium Orchid White	\N	2026-03-08 22:37:18.435067+00	\N
1046	1044	1	\N	\N	Mokara Orchid - Light Pink	\N	2026-03-08 22:37:18.435194+00	\N
1047	1044	1	\N	\N	Phalaenopsis Orchid Spray White 6-9 Blooms	\N	2026-03-08 22:37:18.435325+00	\N
1048	1048	1	\N	\N	Oregonia	G1310	2026-03-08 22:37:18.435509+00	\N
1049	1049	1	\N	\N	Oriental Lily Pink - Star Gazer	\N	2026-03-08 22:37:18.435747+00	\N
1050	1049	1	\N	\N	Oriental Lily White	\N	2026-03-08 22:37:18.435909+00	\N
1051	1049	1	\N	\N	Oriental Lily White- Sambuca	\N	2026-03-08 22:37:18.436066+00	\N
1052	1052	1	706	\N	Emerald Medium Guatemala	G2091	2026-03-08 22:37:18.43644+00	\N
1053	1052	1	707	\N	Emerald Premium Guatemala	G1645	2026-03-08 22:37:18.436808+00	\N
1054	1052	1	708	\N	Emerald Premium Guatemala 15pk	G2092	2026-03-08 22:37:18.437529+00	\N
1055	1052	1	709	\N	Emerald Premium Narrow	G2100	2026-03-08 22:37:18.438189+00	\N
1056	1052	1	710	\N	Emerald Tepe	G1031	2026-03-08 22:37:18.438719+00	\N
1057	1052	1	711	\N	Palm Phoenix Roebelini 20st	G1369	2026-03-08 22:37:18.439298+00	\N
1058	1058	1	\N	\N	Dried Pampas Grass Short	\N	2026-03-08 22:37:18.439608+00	\N
1059	1058	1	\N	\N	Dried Pampas Grass Tall	\N	2026-03-08 22:37:18.43981+00	\N
1060	1060	1	\N	\N	Peony - Coral Charm	\N	2026-03-08 22:37:18.4401+00	\N
1061	1060	1	\N	\N	Peony Blush	\N	2026-03-08 22:37:18.440295+00	\N
1062	1060	1	\N	\N	Peony Burgundy	\N	2026-03-08 22:37:18.440491+00	\N
1063	1060	1	\N	\N	Peony Hot Pink	\N	2026-03-08 22:37:18.440676+00	\N
1064	1060	1	\N	\N	Peony Hot Pink - Alexander Flemming	\N	2026-03-08 22:37:18.440874+00	\N
1065	1060	1	\N	\N	Peony Pink/Blush - Sarah Bernhardt	\N	2026-03-08 22:37:18.441104+00	\N
1066	1060	1	\N	\N	Peony White	\N	2026-03-08 22:37:18.44128+00	\N
1067	1060	1	712	\N	Peony Blush Gardenia 5st	12668	2026-03-08 22:37:18.441881+00	235
1068	1060	1	712	\N	Peony Coral Charm 5st	12653	2026-03-08 22:37:18.442463+00	236
1069	1060	1	714	\N	Peony Pink Lt Angel Cheeks 5st	10697	2026-03-08 22:37:18.443237+00	237
1070	1060	1	715	\N	Peony Pink Sara B 5st	33768	2026-03-08 22:37:18.443938+00	238
1071	1060	1	715	\N	Peony Pink Sara B 5st	42841	2026-03-08 22:37:18.444442+00	238
1072	1060	1	717	\N	Peony Pink Sarah Bern 5st 20pk	32002	2026-03-08 22:37:18.445193+00	240
1073	1060	1	718	\N	Peony Red Henry Bockstoce 5st	12192	2026-03-08 22:37:18.445951+00	241
1074	1060	1	719	\N	Peony White Bridal Shower 5st	17836	2026-03-08 22:37:18.446665+00	242
1075	1060	1	720	\N	Peony White Claude Tain 5st	12096	2026-03-08 22:37:18.447405+00	243
1076	1076	1	721	\N	Pepperberry Upright Brazilian	28062	2026-03-08 22:37:18.448243+00	\N
1077	1076	1	722	\N	Pepperberry Hanging Green	21549	2026-03-08 22:37:18.44887+00	\N
1078	1078	1	723	\N	Phal Spray Prp Buffalo 9+bl	75123	2026-03-08 22:37:18.44949+00	\N
1079	1078	1	724	\N	Phal Spray White Kobe 7+bl	10810	2026-03-08 22:37:18.44998+00	\N
1080	1078	1	725	\N	Phal Spray White Kobe 9+bl	10791	2026-03-08 22:37:18.450476+00	\N
1081	1081	1	\N	\N	Phlox White Dutch	22127	2026-03-08 22:37:18.450759+00	\N
1082	1082	1	726	\N	Pincushion Asst Seasonal 20pk	39826	2026-03-08 22:37:18.451162+00	\N
1083	1082	1	727	\N	Pincushion Org 20pk	29174	2026-03-08 22:37:18.451567+00	\N
1084	1082	1	728	\N	Pincushion Org CA 20pk	36639	2026-03-08 22:37:18.451982+00	\N
1085	1082	1	729	\N	Pincushion Org Soleil 50pk	42664	2026-03-08 22:37:18.452512+00	\N
1086	1082	1	730	\N	Pincushion Red Tango 20pk	30034	2026-03-08 22:37:18.453071+00	\N
1087	1082	1	731	\N	Pincushion Yel Blush Firefly20	10379	2026-03-08 22:37:18.453569+00	\N
1088	1082	1	732	\N	Pincushion Yel Mooonlight 50pk	38271	2026-03-08 22:37:18.454049+00	\N
1089	1089	1	\N	\N	Mini Pine Cones	\N	2026-03-08 22:37:18.454353+00	\N
1090	1089	1	\N	\N	Pinecone Pick	\N	2026-03-08 22:37:18.454635+00	\N
1091	1091	1	\N	\N	Micro Pompons Bronze - Oro	\N	2026-03-08 22:37:18.454892+00	\N
1092	1091	1	733	\N	Pom Pon Candy Crush Mint 6pk	52137	2026-03-08 22:37:18.455319+00	\N
1093	1091	1	734	\N	Pom Pon White Candy Crush 6pk	52183	2026-03-08 22:37:18.45579+00	\N
1094	1091	1	\N	\N	Micro Pompons White - Katy	\N	2026-03-08 22:37:18.456007+00	\N
1095	1091	1	\N	\N	Micro Pompons Yellow - Candy Crush	\N	2026-03-08 22:37:18.456196+00	\N
1096	1091	1	\N	\N	Pompon Cushion - Copper	\N	2026-03-08 22:37:18.456378+00	\N
1097	1091	1	\N	\N	Pompon Cushion - Creme Brulee	\N	2026-03-08 22:37:18.456554+00	\N
1098	1091	1	\N	\N	Pompon Cushion Dark Bronze - Tusca	\N	2026-03-08 22:37:18.456726+00	\N
1099	1091	1	\N	\N	Pompon Cushion Lavender- Roselle	\N	2026-03-08 22:37:18.456915+00	\N
1100	1091	1	\N	\N	Pompon Cushion Red - Chianti	\N	2026-03-08 22:37:18.457097+00	\N
1101	1091	1	\N	\N	Pompon Cushion Red - Testarossa	\N	2026-03-08 22:37:18.457279+00	\N
1102	1091	1	\N	\N	Pompon Daisy Light Bronze - Ribbon	\N	2026-03-08 22:37:18.457457+00	\N
1103	1091	1	\N	\N	Pompon Daisy White - Atlantis	\N	2026-03-08 22:37:18.457624+00	\N
1104	1091	1	735	\N	Pom Pon Yellow Zippo 6pk	54836	2026-03-08 22:37:18.457981+00	\N
1105	1091	1	\N	\N	Pompon Light Bronze - Solar Eclipse	\N	2026-03-08 22:37:18.458205+00	\N
1106	1091	1	\N	\N	Pompon Novelty Bronze - Lexy	\N	2026-03-08 22:37:18.458396+00	\N
1107	1091	1	\N	\N	Pompon Novelty White - Mont Blanc	\N	2026-03-08 22:37:18.458577+00	\N
1108	1091	1	736	\N	Pom Pon Blue Ocean Coral	59170	2026-03-08 22:37:18.458984+00	\N
1109	1091	1	737	\N	Pom Pon Blue Ocean Jade	59171	2026-03-08 22:37:18.45945+00	\N
1110	1091	1	738	\N	Pom Pon Blue Ocean Prp Sapphir	59172	2026-03-08 22:37:18.459914+00	\N
1111	1091	1	739	\N	Pom Pon Blue Ocean Sapphire	59173	2026-03-08 22:37:18.460379+00	\N
1112	1091	1	740	\N	Pom Pon Burg Cush Malbec 5pk	18526	2026-03-08 22:37:18.460837+00	\N
1113	1091	1	741	\N	Pom Pon Cream Cush Crm Brul 6p	54879	2026-03-08 22:37:18.461436+00	\N
1114	1091	1	742	\N	Pom Pon Cush Yel Champagne 6pk	52149	2026-03-08 22:37:18.461956+00	\N
1115	1091	1	743	\N	Pom Pon Green Athos 5pk	18535	2026-03-08 22:37:18.462451+00	\N
1116	1091	1	744	\N	Pom Pon Green Bombellini 5pk	54732	2026-03-08 22:37:18.462971+00	\N
1117	1091	1	745	\N	Pom Pon Green Button	23159	2026-03-08 22:37:18.463372+00	\N
1118	1091	1	746	\N	Pom Pon Green Button Country	37806	2026-03-08 22:37:18.463836+00	\N
1119	1091	1	747	\N	Pom Pon Green Button Ctry 12pk	42354	2026-03-08 22:37:18.464388+00	\N
1120	1091	1	748	\N	Pom Pon Green Whatsapp 6pk	62812	2026-03-08 22:37:18.464841+00	\N
1121	1091	1	749	\N	Pom Pon Green Zembla 6pk	62820	2026-03-08 22:37:18.465337+00	\N
1122	1091	1	750	\N	Pom Pon Grn Butt Country 5pk	18536	2026-03-08 22:37:18.465824+00	\N
1123	1091	1	751	\N	Pom Pon Grn Butt Whats App 5pk	67139	2026-03-08 22:37:18.466386+00	\N
1124	1091	1	752	\N	Pom Pon Lav Melrose 6pk	52164	2026-03-08 22:37:18.46685+00	\N
1125	1091	1	753	\N	Pom Pon Lav Prada Sweet 6pk	62821	2026-03-08 22:37:18.467336+00	\N
1126	1091	1	754	\N	Pom Pon Lav Veronica 6pk	52158	2026-03-08 22:37:18.467816+00	\N
1127	1091	1	755	\N	Pom Pon Lav. Button	23254	2026-03-08 22:37:18.468264+00	\N
1128	1091	1	756	\N	Pom Pon Lav. Button 5pk	18527	2026-03-08 22:37:18.468714+00	\N
1129	1091	1	757	\N	Pom Pon Lav. Cushion	23178	2026-03-08 22:37:18.469233+00	\N
1130	1091	1	758	\N	Pom Pon Lav. Cushion 5pk	67138	2026-03-08 22:37:18.469694+00	\N
1131	1091	1	759	\N	Pom Pon Lav. Daisy 5pk	50756	2026-03-08 22:37:18.470158+00	\N
1132	1091	1	760	\N	Pom Pon Lavender Daisy	23229	2026-03-08 22:37:18.470683+00	\N
1133	1091	1	761	\N	Pom Pon Lavender Mystery 6pk	62824	2026-03-08 22:37:18.471194+00	\N
1134	1091	1	762	\N	Pom Pon Nov Green Alemani 5pk	54799	2026-03-08 22:37:18.471691+00	\N
1135	1091	1	763	\N	Pom Pon Novelty Asst 12pk	67619	2026-03-08 22:37:18.472215+00	\N
1136	1091	1	764	\N	Pom Pon Novelty Pink Amaze 5pk	52115	2026-03-08 22:37:18.472646+00	\N
1137	1091	1	765	\N	Pom Pon Novelty Ying Yang	60961	2026-03-08 22:37:18.473085+00	\N
1138	1091	1	766	\N	Pom Pon Novelty Ying Yang 5pk	18528	2026-03-08 22:37:18.473476+00	\N
1139	1091	1	767	\N	Pom Pon Peach Cushion 5pk	58668	2026-03-08 22:37:18.473875+00	\N
1140	1091	1	768	\N	Pom Pon Peach Cushion 6pk	54700	2026-03-08 22:37:18.47438+00	\N
1141	1091	1	769	\N	Pom Pon Peach Daisy 5pk	58667	2026-03-08 22:37:18.47493+00	\N
1142	1091	1	770	\N	Pom Pon Pink Cushion	53679	2026-03-08 22:37:18.475423+00	\N
1143	1091	1	771	\N	Pom Pon Pink Daisy 14pk	54748	2026-03-08 22:37:18.475932+00	\N
1144	1091	1	772	\N	Pom Pon Pink Daisy Alma	50958	2026-03-08 22:37:18.476467+00	\N
1145	1091	1	773	\N	Pom Pon Pink Daisy Aquarel 6pk	52189	2026-03-08 22:37:18.477045+00	\N
1146	1091	1	774	\N	Pom Pon Pink Daisy Atlantis	52098	2026-03-08 22:37:18.477653+00	\N
1147	1091	1	775	\N	Pom Pon Pink Delirock 6pk	62809	2026-03-08 22:37:18.478543+00	\N
1148	1091	1	776	\N	Pom Pon Purple Button	54753	2026-03-08 22:37:18.47934+00	\N
1149	1091	1	777	\N	Pom Pon Purple Cushion	42351	2026-03-08 22:37:18.479982+00	\N
1150	1091	1	778	\N	Pom Pon Purple Cushion 12pk	54685	2026-03-08 22:37:18.480596+00	\N
1151	1091	1	779	\N	Pom Pon Purple Cushion 5pk	60929	2026-03-08 22:37:18.481101+00	\N
1152	1091	1	780	\N	Pom Pon Purple Daisy 5pk	21569	2026-03-08 22:37:18.481659+00	\N
1153	1091	1	781	\N	Pom Pon Purple Delirock 6pk	52094	2026-03-08 22:37:18.482151+00	\N
1154	1091	1	782	\N	Pom Pon Purple Uvita 6pk	52186	2026-03-08 22:37:18.48261+00	\N
1155	1091	1	783	\N	Pom Pon Red Button	62046	2026-03-08 22:37:18.483126+00	\N
1156	1091	1	784	\N	Pom Pon Red Daisy Bramis 5pk	62983	2026-03-08 22:37:18.48377+00	\N
1157	1091	1	785	\N	Pom Pon Salmon Cushion 5pk	59106	2026-03-08 22:37:18.484283+00	\N
1158	1091	1	786	\N	Pom Pon White Button	23182	2026-03-08 22:37:18.484774+00	\N
1159	1091	1	787	\N	Pom Pon White Button 5pk	23131	2026-03-08 22:37:18.485261+00	\N
1160	1091	1	734	\N	Pom Pon White Candy Crush 6pk	52183	2026-03-08 22:37:18.485617+00	\N
1161	1091	1	789	\N	Pom Pon White Cush Maisy	23296	2026-03-08 22:37:18.486156+00	\N
1162	1091	1	790	\N	Pom Pon White Cush Maisy 5pk	60655	2026-03-08 22:37:18.486846+00	\N
1163	1091	1	791	\N	Pom Pon White Cush Maisy 8pk	18429	2026-03-08 22:37:18.487453+00	\N
1164	1091	1	792	\N	Pom Pon White Daisy Alma	23200	2026-03-08 22:37:18.487973+00	\N
1165	1091	1	793	\N	Pom Pon White Daisy Alma 6pk	62814	2026-03-08 22:37:18.488489+00	\N
1166	1091	1	794	\N	Pom Pon White Daisy Coconut 6p	54818	2026-03-08 22:37:18.488991+00	\N
1167	1091	1	795	\N	Pom Pon White Daisy Meraki 6p	50947	2026-03-08 22:37:18.489504+00	\N
1168	1091	1	796	\N	Pom Pon White Daisy Reagan 15p	23347	2026-03-08 22:37:18.490072+00	\N
1169	1091	1	797	\N	Pom Pon White Eagle 6pk	52156	2026-03-08 22:37:18.490522+00	\N
1170	1091	1	798	\N	Pom Pon White Micro Whynot 6pk	52162	2026-03-08 22:37:18.490917+00	\N
1171	1091	1	799	\N	Pom Pon White Top Dollar 6pk	52166	2026-03-08 22:37:18.491458+00	\N
1172	1091	1	800	\N	Pom Pon Wht/Grn Zem/Maisy Lime	62035	2026-03-08 22:37:18.491971+00	\N
1173	1091	1	801	\N	Pom Pon Yel. Viking Sundi 5pk	23204	2026-03-08 22:37:18.492507+00	\N
1174	1091	1	802	\N	Pom Pon Yel. Viking Vybowl 5pk	18538	2026-03-08 22:37:18.493006+00	\N
1175	1091	1	803	\N	Pom Pon Yellow Button	23187	2026-03-08 22:37:18.493565+00	\N
1176	1091	1	804	\N	Pom Pon Ylw Daisy Ylwstone 5pk	18540	2026-03-08 22:37:18.494036+00	\N
1177	1091	1	805	\N	Pom Pon Ylw Paintball Sunny 6p	62826	2026-03-08 22:37:18.494428+00	\N
1178	1178	1	\N	\N	Poppy Mixed Colors	\N	2026-03-08 22:37:18.494664+00	\N
1179	1179	1	\N	\N	King Protea Pink	\N	2026-03-08 22:37:18.494869+00	\N
1180	1179	1	\N	\N	Leucadendron Red - Safari Sunset	\N	2026-03-08 22:37:18.495018+00	\N
1181	1179	1	\N	\N	Protea Pink Ice	10184	2026-03-08 22:37:18.495219+00	\N
1182	1179	1	806	\N	Protea Assorted Pink 15pk	38104	2026-03-08 22:37:18.495618+00	\N
1183	1179	1	\N	\N	Protea Pink Mink	10188	2026-03-08 22:37:18.495841+00	\N
1184	1179	1	807	\N	Protea Queen Pink Empress	27588	2026-03-08 22:37:18.496293+00	\N
1185	1179	1	\N	\N	Protea Red Mink	10189	2026-03-08 22:37:18.496518+00	\N
1186	1179	1	\N	\N	Protea White Night	27483	2026-03-08 22:37:18.496705+00	\N
1187	1187	1	808	\N	Pussy Willow 20in 10st	18110	2026-03-08 22:37:18.497364+00	\N
1188	1187	1	809	\N	Pussy Willow 24in 10st	12939	2026-03-08 22:37:18.497892+00	\N
1189	1187	1	810	\N	Pussy Willow 3-4ft 10-12st	68801	2026-03-08 22:37:18.498552+00	\N
1190	1187	1	811	\N	Pussy Willow 30in 10st	51777	2026-03-08 22:37:18.499133+00	\N
1191	1187	1	812	\N	Pussy Willow 4-5ft 10stem	53218	2026-03-08 22:37:18.499688+00	\N
1192	1192	1	813	\N	Laceflower Green Mist	21063	2026-03-08 22:37:18.500265+00	\N
1193	1192	1	814	\N	Laceflower Chocolate CA	25213	2026-03-08 22:37:18.50075+00	\N
1194	1192	1	815	\N	Laceflower White Queen Anne's	27796	2026-03-08 22:37:18.501256+00	\N
1195	1192	1	816	\N	Laceflower White Orlaya	35661	2026-03-08 22:37:18.501721+00	\N
1196	1196	1	817	\N	Quince Apricot Dbl 3-4ft 6st	13021	2026-03-08 22:37:18.502268+00	\N
1197	1196	1	818	\N	Quince Pink 6ft, 6stems	42288	2026-03-08 22:37:18.502805+00	244
1198	1196	1	819	\N	Quince Pink/White 3-4ft 5stem	57150	2026-03-08 22:37:18.503764+00	245
1199	1196	1	820	\N	Quince White 6ft, 6 stems	42310	2026-03-08 22:37:18.504456+00	246
1200	1200	1	\N	\N	Ranunculus - Cloni Success Nebbia	\N	2026-03-08 22:37:18.504793+00	\N
1201	1200	1	\N	\N	Ranunculus Peach	48222	2026-03-08 22:37:18.504983+00	\N
1202	1200	1	\N	\N	Ranunculus Red RP	35571	2026-03-08 22:37:18.505175+00	\N
1203	1203	1	\N	\N	Rice Flower Pink 50cm/60cm	37397	2026-03-08 22:37:18.505429+00	\N
1204	1203	1	\N	\N	Rice Flower White 50cm/60cm	40510	2026-03-08 22:37:18.505612+00	\N
1205	1203	1	821	\N	Rice Flower White Vic. 40/50cm	28596	2026-03-08 22:37:18.506217+00	247
1206	1	1	\N	\N	Barista Rose	\N	2026-03-08 22:37:18.506498+00	\N
1207	1	1	\N	\N	Rose - Coral Reef	\N	2026-03-08 22:37:18.506685+00	\N
1208	1	1	\N	\N	Rose - Mondial	\N	2026-03-08 22:37:18.506891+00	\N
1209	1	1	\N	\N	Rose - Orange Crush	\N	2026-03-08 22:37:18.507083+00	\N
1210	1	1	\N	\N	Rose - Pink Floyd	\N	2026-03-08 22:37:18.507283+00	\N
1211	1	1	\N	\N	Rose - Pink Mondial	\N	2026-03-08 22:37:18.507474+00	\N
1212	1	1	\N	\N	Rose Beige - Quicksand	\N	2026-03-08 22:37:18.507662+00	\N
1213	1	1	\N	\N	Rose Beige - Sahara	\N	2026-03-08 22:37:18.507835+00	\N
1214	1	1	\N	\N	Rose Blush - Poma Rosa	\N	2026-03-08 22:37:18.508064+00	\N
1215	1	1	\N	\N	Rose Blush - Rhoslyn	\N	2026-03-08 22:37:18.508271+00	\N
1216	1	1	\N	\N	Rose Burgundy - Heart	\N	2026-03-08 22:37:18.508464+00	\N
1217	1	1	\N	\N	Rose Champagne/peach - Shimmer	\N	2026-03-08 22:37:18.508618+00	\N
1218	1	1	\N	\N	Rose Cream - Candlelight	\N	2026-03-08 22:37:18.508768+00	\N
1219	1	1	\N	\N	Rose Cream - Vendela	\N	2026-03-08 22:37:18.508909+00	\N
1220	1	1	\N	\N	Rose Cream/Blush - Suspiro	\N	2026-03-08 22:37:18.509057+00	\N
1221	1	1	\N	\N	Rose Cream/natural - Pompeii	\N	2026-03-08 22:37:18.509207+00	\N
1222	1	1	\N	\N	Rose Crimson - Razzmatazz	\N	2026-03-08 22:37:18.509405+00	\N
1223	1	1	\N	\N	Rose Hot Pink - Breezer	\N	2026-03-08 22:37:18.509547+00	\N
1224	1	1	\N	\N	Rose Hot Pink - Full Monty	\N	2026-03-08 22:37:18.509692+00	\N
1225	1	1	\N	\N	Rose Lavender - Andrea	\N	2026-03-08 22:37:18.509835+00	\N
1226	1	1	\N	\N	Rose Lavender - Ocean Song	\N	2026-03-08 22:37:18.509978+00	\N
1227	1	1	\N	\N	Rose Mustard - Symbol	\N	2026-03-08 22:37:18.510191+00	\N
1228	1	1	\N	\N	Rose Orange - Free Spirit 40cm	\N	2026-03-08 22:37:18.510394+00	\N
1229	1	1	\N	\N	Rose Peach - Kahala	\N	2026-03-08 22:37:18.510582+00	\N
1230	1	1	\N	\N	Rose Peach - Phoenix	\N	2026-03-08 22:37:18.510786+00	\N
1231	1	1	\N	\N	Rose Red - Freedom	\N	2026-03-08 22:37:18.510972+00	\N
1232	1	1	\N	\N	Rose Toffee	\N	2026-03-08 22:37:18.511164+00	\N
1233	1	1	\N	\N	Rose White - Tibet	\N	2026-03-08 22:37:18.511346+00	\N
1234	1	1	\N	\N	Rose White - Yuraq	\N	2026-03-08 22:37:18.511508+00	\N
1235	1	1	\N	\N	Rose Wine - Merlot	\N	2026-03-08 22:37:18.511738+00	\N
1236	1	1	\N	\N	Rose Yellow - Catalina	\N	2026-03-08 22:37:18.511946+00	\N
1237	1	1	\N	\N	Rose Yellow/Orange - Shine On	\N	2026-03-08 22:37:18.512195+00	\N
1238	1	1	822	\N	Rose Brw Matilda 50cm	46841	2026-03-08 22:37:18.512661+00	\N
1239	1	1	823	\N	Rose Brw Moab 60cm	54821	2026-03-08 22:37:18.513148+00	\N
1240	1	1	824	\N	Rose Brw Toffee 50cm	57020	2026-03-08 22:37:18.513673+00	\N
1241	1	1	825	\N	Rose Crm Expression 60cm	68667	2026-03-08 22:37:18.514151+00	\N
1242	1	1	826	\N	Rose Crm Quicksand 40cm	29594	2026-03-08 22:37:18.5149+00	\N
1243	1	1	826	\N	Rose Crm Quicksand 50cm	28180	2026-03-08 22:37:18.515294+00	\N
1244	1	1	828	\N	Rose Crm Quicksand 50cm Cs50	30694	2026-03-08 22:37:18.515855+00	\N
1245	1	1	826	\N	Rose Crm Quicksand 60cm	30357	2026-03-08 22:37:18.516236+00	\N
1246	1	1	830	\N	Rose Crm Soul 50cm	56996	2026-03-08 22:37:18.516712+00	\N
1247	1	1	831	\N	Rose Dyed Blue 60cm	40002	2026-03-08 22:37:18.517229+00	\N
1248	1	1	832	\N	Rose Dyed Rainbow 60cm	29518	2026-03-08 22:37:18.517663+00	\N
1249	1	1	833	\N	Rose Gr Green Tea 50cm	23858	2026-03-08 22:37:18.51817+00	\N
1250	1	1	834	\N	Rose Gr Lemonade 40cm	68712	2026-03-08 22:37:18.518654+00	\N
1251	1	1	834	\N	Rose Gr Lemonade 50cm	51791	2026-03-08 22:37:18.519022+00	\N
1252	1	1	834	\N	Rose Gr Lemonade 60cm	51792	2026-03-08 22:37:18.51942+00	\N
1253	1	1	837	\N	Rose Gr Wasabi 40cm	40741	2026-03-08 22:37:18.519935+00	\N
1254	1	1	838	\N	Rose HPk Cherry-O 50cm	60925	2026-03-08 22:37:18.520343+00	\N
1255	1	1	838	\N	Rose HPk Cherry-O 60cm	33523	2026-03-08 22:37:18.520716+00	\N
1256	1	1	840	\N	Rose Hpk Country Blues 40cm	24543	2026-03-08 22:37:18.521104+00	\N
1257	1	1	840	\N	Rose HPk Country Blues 50cm	30710	2026-03-08 22:37:18.521373+00	\N
1258	1	1	842	\N	Rose HPk Dark Expression 60cm	24879	2026-03-08 22:37:18.521854+00	\N
1259	1	1	843	\N	Rose HPk Full Monty 50cm	30623	2026-03-08 22:37:18.522654+00	\N
1260	1	1	843	\N	Rose HPk Full Monty 60cm	30622	2026-03-08 22:37:18.522996+00	\N
1261	1	1	845	\N	Rose HPk Hot Spot 60cm	52496	2026-03-08 22:37:18.523505+00	\N
1262	1	1	846	\N	Rose HPk Lola 50cm	40367	2026-03-08 22:37:18.524007+00	\N
1263	1	1	847	\N	Rose HPk Pk Floyd 50cm	47089	2026-03-08 22:37:18.524497+00	\N
1264	1	1	847	\N	Rose HPk Pk Floyd 60cm	47090	2026-03-08 22:37:18.524821+00	\N
1265	1	1	849	\N	Rose HPk Pk Floyd 60cm Cs50	52925	2026-03-08 22:37:18.525372+00	\N
1266	1	1	850	\N	Rose HPk Tina 50cm	69401	2026-03-08 22:37:18.525854+00	\N
1267	1	1	851	\N	Rose HPk Tina 50cm DVF	68892	2026-03-08 22:37:18.526337+00	\N
1268	1	1	850	\N	Rose HPk Tina 60cm	68891	2026-03-08 22:37:18.52668+00	\N
1269	1	1	853	\N	Rose HPk Tina 60cm cs50	42737	2026-03-08 22:37:18.527197+00	\N
1270	1	1	854	\N	Rose HPk Tina 60cm DVF	68893	2026-03-08 22:37:18.527646+00	\N
1271	1	1	855	\N	Rose HPk Topaz 50cm	30381	2026-03-08 22:37:18.528198+00	\N
1272	1	1	855	\N	Rose HPk Topaz 60cm	30718	2026-03-08 22:37:18.528537+00	\N
1273	1	1	857	\N	Rose Lav Amnesia 50cm	48118	2026-03-08 22:37:18.529091+00	\N
1274	1	1	858	\N	Rose Lav Andrea 50cm	45758	2026-03-08 22:37:18.529589+00	\N
1275	1	1	859	\N	Rose Lav Ascot 40cm	62219	2026-03-08 22:37:18.530415+00	\N
1276	1	1	860	\N	Rose Lav Blue Dream 50cm	52246	2026-03-08 22:37:18.530997+00	\N
1277	1	1	861	\N	Rose Lav Blueberry 50cm	47099	2026-03-08 22:37:18.531546+00	\N
1278	1	1	862	\N	Rose Lav Cool Down 50cm	68685	2026-03-08 22:37:18.532032+00	\N
1279	1	1	863	\N	Rose Lav Cool Water 50cm	30732	2026-03-08 22:37:18.532565+00	\N
1280	1	1	864	\N	Rose Lav Cool Water 50cm Cs50	51034	2026-03-08 22:37:18.533074+00	\N
1281	1	1	863	\N	Rose Lav Cool Water 60cm	30839	2026-03-08 22:37:18.533312+00	\N
1282	1	1	866	\N	Rose Lav Cool Water 60cm Cs50	51178	2026-03-08 22:37:18.53374+00	\N
1283	1	1	867	\N	Rose Lav Deep Ppl 50cm	30947	2026-03-08 22:37:18.534087+00	\N
1284	1	1	868	\N	Rose Lav Deep Ppl 50cm Cs50	45785	2026-03-08 22:37:18.534572+00	\N
1285	1	1	868	\N	Rose Lav Deep Ppl 50cm cs50	45786	2026-03-08 22:37:18.534939+00	\N
1286	1	1	867	\N	Rose Lav Deep Ppl 60cm	61086	2026-03-08 22:37:18.535313+00	\N
1287	1	1	871	\N	Rose Lav Deep Ppl 60cm Cs50	52840	2026-03-08 22:37:18.535932+00	\N
1288	1	1	872	\N	Rose Lav Govinda 60cm	30356	2026-03-08 22:37:18.536905+00	\N
1289	1	1	873	\N	Rose Lav Grey Knights 60cm	53462	2026-03-08 22:37:18.537495+00	\N
1290	1	1	874	\N	Rose Lav Menta 50cm	40679	2026-03-08 22:37:18.538023+00	\N
1291	1	1	875	\N	Rose Lav Moody Blues 50cm	24358	2026-03-08 22:37:18.538502+00	\N
1292	1	1	875	\N	Rose Lav Moody Blues 60cm	47103	2026-03-08 22:37:18.538854+00	\N
1293	1	1	877	\N	Rose Lav Ocean Song 50cm	30720	2026-03-08 22:37:18.539367+00	\N
1294	1	1	878	\N	Rose Lav Ocean Song 50cm Cs50	52842	2026-03-08 22:37:18.53987+00	\N
1295	1	1	877	\N	Rose Lav Ocean Song 60cm	30735	2026-03-08 22:37:18.540209+00	\N
1296	1	1	880	\N	Rose Org Bohemian 50cm	30363	2026-03-08 22:37:18.540679+00	\N
1297	1	1	881	\N	Rose Org Crush 40cm	62127	2026-03-08 22:37:18.541115+00	\N
1298	1	1	881	\N	Rose Org Crush 50cm	52030	2026-03-08 22:37:18.541383+00	\N
1299	1	1	883	\N	Rose Org Crush 50cm Cs50	43875	2026-03-08 22:37:18.541776+00	\N
1300	1	1	881	\N	Rose Org Crush 60cm	52031	2026-03-08 22:37:18.542055+00	\N
1301	1	1	885	\N	Rose Org Free Spirit 40cm	26131	2026-03-08 22:37:18.542659+00	\N
1302	1	1	886	\N	Rose Org Free Spirit 40cm Cs50	49842	2026-03-08 22:37:18.543141+00	\N
1303	1	1	885	\N	Rose Org Free Spirit 50cm	24348	2026-03-08 22:37:18.543491+00	\N
1304	1	1	888	\N	Rose Org Free Spirit 50cm Cs50	52871	2026-03-08 22:37:18.544014+00	\N
1305	1	1	885	\N	Rose Org Free Spirit 60cm	30985	2026-03-08 22:37:18.54434+00	\N
1306	1	1	890	\N	Rose Org Joy 60cm	69277	2026-03-08 22:37:18.544831+00	\N
1307	1	1	891	\N	Rose Org Nina 50cm	47112	2026-03-08 22:37:18.545333+00	\N
1308	1	1	892	\N	Rose Pch Coral Reef 50cm	53452	2026-03-08 22:37:18.545818+00	\N
1309	1	1	893	\N	Rose Pch Country Home 50cm	57618	2026-03-08 22:37:18.546311+00	\N
1310	1	1	894	\N	Rose Pch Felicity 50cm	52418	2026-03-08 22:37:18.546764+00	\N
1311	1	1	894	\N	Rose Pch Felicity 60cm	52419	2026-03-08 22:37:18.547036+00	\N
1312	1	1	896	\N	Rose Pch Honeyglow 60cm	48942	2026-03-08 22:37:18.547402+00	\N
1313	1	1	897	\N	Rose Pch Phoenix 50cm	29959	2026-03-08 22:37:18.547844+00	\N
1314	1	1	897	\N	Rose Pch Phoenix 60cm	53759	2026-03-08 22:37:18.548161+00	\N
1315	1	1	899	\N	Rose Pch Phoenix 70-80cm	26371	2026-03-08 22:37:18.548707+00	\N
1316	1	1	900	\N	Rose Pch Shimmer 50cm	53473	2026-03-08 22:37:18.549125+00	\N
1317	1	1	901	\N	Rose Pch Shimmer 50cm Cs50	66879	2026-03-08 22:37:18.54951+00	\N
1318	1	1	900	\N	Rose Pch Shimmer 60cm	53474	2026-03-08 22:37:18.549804+00	\N
1319	1	1	903	\N	Rose Pch Shimmer 60cm Cs50	67366	2026-03-08 22:37:18.550213+00	\N
1320	1	1	904	\N	Rose Pch Tiffany 50cm	62022	2026-03-08 22:37:18.550677+00	\N
1321	1	1	904	\N	Rose Pch Tiffany 50cm	62118	2026-03-08 22:37:18.551056+00	\N
1322	1	1	904	\N	Rose Pch Tiffany 60cm	48932	2026-03-08 22:37:18.551364+00	\N
1323	1	1	907	\N	Rose Pk Asst 40cm cs125	69151	2026-03-08 22:37:18.551832+00	\N
1324	1	1	908	\N	Rose Pk Christa 50cm	55317	2026-03-08 22:37:18.552291+00	\N
1325	1	1	909	\N	Rose Pk Expression 40cm	52585	2026-03-08 22:37:18.552734+00	\N
1326	1	1	909	\N	Rose Pk Expression 50cm	52586	2026-03-08 22:37:18.553039+00	\N
1327	1	1	909	\N	Rose Pk Expression 60cm	52587	2026-03-08 22:37:18.553358+00	\N
1328	1	1	912	\N	Rose Pk Faith 50cm	30409	2026-03-08 22:37:18.553899+00	\N
1329	1	1	913	\N	Rose Pk Flirty 60cm	56895	2026-03-08 22:37:18.554333+00	\N
1330	1	1	914	\N	Rose Pk Garden Spirit 50cm	52022	2026-03-08 22:37:18.55468+00	\N
1331	1	1	915	\N	Rose Pk Geraldine 50cm	28789	2026-03-08 22:37:18.555044+00	\N
1332	1	1	915	\N	Rose Pk Geraldine 60cm	28771	2026-03-08 22:37:18.555267+00	\N
1333	1	1	915	\N	Rose Pk Geraldine 60cm	30640	2026-03-08 22:37:18.555528+00	\N
1334	1	1	918	\N	Rose Pk Hermosa 50cm	46897	2026-03-08 22:37:18.555878+00	\N
1335	1	1	918	\N	Rose Pk Hermosa 60cm	46898	2026-03-08 22:37:18.556158+00	\N
1336	1	1	920	\N	Rose Pk Hermosa 60cm Cs50	24053	2026-03-08 22:37:18.556607+00	\N
1337	1	1	921	\N	Rose Pk Miss Piggy 50cm	52321	2026-03-08 22:37:18.557122+00	\N
1338	1	1	922	\N	Rose Pk Mondial 40cm	43893	2026-03-08 22:37:18.557617+00	\N
1339	1	1	922	\N	Rose Pk Mondial 50cm	53738	2026-03-08 22:37:18.557953+00	\N
1340	1	1	922	\N	Rose Pk Mondial 60cm	53739	2026-03-08 22:37:18.558302+00	\N
1341	1	1	925	\N	Rose Pk Mondial 60cm x50	57049	2026-03-08 22:37:18.558798+00	\N
1342	1	1	926	\N	Rose Pk Mondial 70/80cm	53740	2026-03-08 22:37:18.559274+00	\N
1343	1	1	927	\N	Rose Pk Mother of Prl 50cm	54033	2026-03-08 22:37:18.559768+00	\N
1344	1	1	927	\N	Rose Pk Mother of Prl 60cm	54034	2026-03-08 22:37:18.56011+00	\N
1345	1	1	929	\N	Rose Pk Nena 50cm	46895	2026-03-08 22:37:18.560577+00	\N
1346	1	1	929	\N	Rose Pk Nena 60cm	46896	2026-03-08 22:37:18.560898+00	\N
1347	1	1	931	\N	Rose Pk Nuage 60cm	69025	2026-03-08 22:37:18.561346+00	\N
1348	1	1	932	\N	Rose Pk Opala 50cm	40736	2026-03-08 22:37:18.561809+00	\N
1349	1	1	933	\N	Rose Pk Pnky Promise 60cm DVF	68896	2026-03-08 22:37:18.562263+00	\N
1350	1	1	934	\N	Rose Pk Shy 50cm cs50	25900	2026-03-08 22:37:18.562729+00	\N
1351	1	1	935	\N	Rose Pk Shy 60cm	45780	2026-03-08 22:37:18.563217+00	\N
1352	1	1	936	\N	Rose Pk Swt Eskimo 50cm	53753	2026-03-08 22:37:18.564066+00	\N
1353	1	1	937	\N	Rose Pk Swt Eskimo 50cm cs100	57052	2026-03-08 22:37:18.564709+00	\N
1354	1	1	936	\N	Rose Pk Swt Eskimo 60cm	53754	2026-03-08 22:37:18.565154+00	\N
1355	1	1	939	\N	Rose Pk Swt Unique 50cm	30519	2026-03-08 22:37:18.565659+00	\N
1356	1	1	940	\N	Rose Pk Swt Unique 50cm cs50	24505	2026-03-08 22:37:18.566158+00	\N
1357	1	1	939	\N	Rose Pk Swt Unique 60cm	30520	2026-03-08 22:37:18.566499+00	\N
1358	1	1	942	\N	Rose Rd Bl Baccara 40cm	24105	2026-03-08 22:37:18.566955+00	\N
1359	1	1	942	\N	Rose Rd Bl Baccara 50cm	46800	2026-03-08 22:37:18.567292+00	\N
1360	1	1	942	\N	Rose Rd Bl Baccara 60cm	30829	2026-03-08 22:37:18.567596+00	\N
1361	1	1	945	\N	Rose Rd Black Pearl 60cm	65691	2026-03-08 22:37:18.568064+00	\N
1362	1	1	946	\N	Rose Rd Explorer 40cm	40362	2026-03-08 22:37:18.568479+00	\N
1363	1	1	946	\N	Rose Rd Explorer 50cm	46798	2026-03-08 22:37:18.568767+00	\N
1364	1	1	946	\N	Rose Rd Explorer 60cm	46799	2026-03-08 22:37:18.569056+00	\N
1365	1	1	949	\N	Rose Rd Explorer 70/80cm	49517	2026-03-08 22:37:18.569498+00	\N
1366	1	1	950	\N	Rose Rd Freedom 40cm	28863	2026-03-08 22:37:18.56991+00	\N
1367	1	1	950	\N	Rose Rd Freedom 50cm	28616	2026-03-08 22:37:18.570244+00	\N
1368	1	1	950	\N	Rose Rd Freedom 50cm	28517	2026-03-08 22:37:18.57056+00	\N
1369	1	1	950	\N	Rose Rd Freedom 50cm	29098	2026-03-08 22:37:18.570887+00	\N
1370	1	1	954	\N	Rose Rd Freedom 50cm cs100	49909	2026-03-08 22:37:18.571357+00	\N
1371	1	1	955	\N	Rose Rd Freedom 50cm Cs125	26220	2026-03-08 22:37:18.571838+00	\N
1372	1	1	955	\N	Rose Rd Freedom 50cm Cs125	32196	2026-03-08 22:37:18.57219+00	\N
1373	1	1	950	\N	Rose Rd Freedom 60cm	28617	2026-03-08 22:37:18.572497+00	\N
1374	1	1	950	\N	Rose Rd Freedom 60cm	37620	2026-03-08 22:37:18.572938+00	\N
1375	1	1	950	\N	Rose Rd Freedom 60cm	31523	2026-03-08 22:37:18.573273+00	\N
1376	1	1	960	\N	Rose Rd Freedom 60cm Cs100	26187	2026-03-08 22:37:18.573753+00	\N
1377	1	1	960	\N	Rose Rd Freedom 60cm cs100	49911	2026-03-08 22:37:18.574104+00	\N
1378	1	1	960	\N	Rose Rd Freedom 60cm Cs100	29868	2026-03-08 22:37:18.574476+00	\N
1379	1	1	963	\N	Rose Rd Freedom 70-80cm	28859	2026-03-08 22:37:18.575006+00	\N
1380	1	1	963	\N	Rose Rd Freedom 70-80cm	33649	2026-03-08 22:37:18.575327+00	\N
1381	1	1	965	\N	Rose Rd Freedom 70/80cm Cs100	37621	2026-03-08 22:37:18.575856+00	\N
1382	1	1	966	\N	Rose Rd Freedom 70cm Cs100	24342	2026-03-08 22:37:18.576922+00	\N
1383	1	1	967	\N	Rose Rd Hearts 40cm	55328	2026-03-08 22:37:18.57755+00	\N
1384	1	1	967	\N	Rose Rd Hearts 50cm	65350	2026-03-08 22:37:18.577979+00	\N
1385	1	1	967	\N	Rose Rd Hearts 60cm	49086	2026-03-08 22:37:18.578416+00	\N
1386	1	1	970	\N	Rose Rd Mama Mia 40cm cs125	47149	2026-03-08 22:37:18.579074+00	\N
1387	1	1	971	\N	Rose Rd Mama Mia 50cm	68820	2026-03-08 22:37:18.579707+00	\N
1388	1	1	971	\N	Rose Rd Mama Mia 60cm	68821	2026-03-08 22:37:18.580076+00	\N
1389	1	1	973	\N	Rose Sal Amsterdam 50cm	47798	2026-03-08 22:37:18.580581+00	\N
1390	1	1	974	\N	Rose Sal Dragonfly 60cm	69114	2026-03-08 22:37:18.581227+00	\N
1391	1	1	975	\N	Rose Var 3D 50cm	47154	2026-03-08 22:37:18.581953+00	\N
1392	1	1	976	\N	Rose Var Barista 40cm	27054	2026-03-08 22:37:18.582701+00	\N
1393	1	1	976	\N	Rose Var Barista 50cm	33583	2026-03-08 22:37:18.58313+00	\N
1394	1	1	978	\N	Rose Var Bluez 60cm	49903	2026-03-08 22:37:18.583691+00	\N
1395	1	1	979	\N	Rose Var Cherry Brandy 50cm	30399	2026-03-08 22:37:18.584301+00	\N
1396	1	1	980	\N	Rose Var High & Magic 50cm	30386	2026-03-08 22:37:18.584837+00	\N
1397	1	1	980	\N	Rose Var High & Magic 60cm	39786	2026-03-08 22:37:18.585178+00	\N
1398	1	1	982	\N	Rose Var Kahala 50cm	67448	2026-03-08 22:37:18.585728+00	\N
1399	1	1	983	\N	Rose Wht Aspen 50cm	30664	2026-03-08 22:37:18.586379+00	\N
1400	1	1	984	\N	Rose Wht Asst 40cm cs125	26399	2026-03-08 22:37:18.586967+00	\N
1401	1	1	985	\N	Rose Wht Coldplay 60cm 12st	68889	2026-03-08 22:37:18.587485+00	\N
1402	1	1	986	\N	Rose Wht Cotton Expr 50cm	68680	2026-03-08 22:37:18.588053+00	\N
1403	1	1	986	\N	Rose Wht Cotton Expr 60cm	68681	2026-03-08 22:37:18.588375+00	\N
1404	1	1	988	\N	Rose Wht Eskimo 40cm Cs125	23951	2026-03-08 22:37:18.588934+00	\N
1405	1	1	989	\N	Rose Wht Eskimo 50cm	30801	2026-03-08 22:37:18.589507+00	\N
1406	1	1	989	\N	Rose Wht Eskimo 50cm	30236	2026-03-08 22:37:18.589806+00	\N
1407	1	1	991	\N	Rose Wht Eskimo 50cm cs100	53809	2026-03-08 22:37:18.591053+00	\N
1408	1	1	992	\N	Rose Wht Eskimo 50cm Cs50	52821	2026-03-08 22:37:18.591713+00	\N
1409	1	1	989	\N	Rose Wht Eskimo 60cm	30751	2026-03-08 22:37:18.592353+00	\N
1410	1	1	994	\N	Rose Wht Mondial 40cm	48649	2026-03-08 22:37:18.592902+00	\N
1411	1	1	994	\N	Rose Wht Mondial 50cm	20246	2026-03-08 22:37:18.593242+00	\N
1412	1	1	996	\N	Rose Wht Mondial 50cm Cs50	51314	2026-03-08 22:37:18.593793+00	\N
1413	1	1	994	\N	Rose Wht Mondial 60cm	20247	2026-03-08 22:37:18.594185+00	\N
1414	1	1	998	\N	Rose Wht Mondial 60cm Cs50	27250	2026-03-08 22:37:18.595073+00	\N
1415	1	1	999	\N	Rose Wht Mondial 60cm DVF	51232	2026-03-08 22:37:18.595811+00	\N
1416	1	1	1000	\N	Rose Wht Moonstone 60cm	40733	2026-03-08 22:37:18.596812+00	\N
1417	1	1	1001	\N	Rose Wht Playa Blnca 50c Cs100	57044	2026-03-08 22:37:18.598547+00	\N
1418	1	1	1002	\N	Rose Wht Playa Blnca 50cm	67352	2026-03-08 22:37:18.599365+00	\N
1419	1	1	1003	\N	Rose Wht Playa Blnca 60c Cs100	53704	2026-03-08 22:37:18.599903+00	\N
1420	1	1	1002	\N	Rose Wht Playa Blnca 60cm	67353	2026-03-08 22:37:18.600335+00	\N
1421	1	1	1005	\N	Rose Wht Playa Blnca 70/80cm	67354	2026-03-08 22:37:18.600877+00	\N
1422	1	1	1006	\N	Rose Wht Polo 50cm	24609	2026-03-08 22:37:18.601472+00	\N
1423	1	1	1006	\N	Rose Wht Polo 60cm	30532	2026-03-08 22:37:18.601826+00	\N
1424	1	1	1008	\N	Rose Wht Tibet 40cm	23835	2026-03-08 22:37:18.602402+00	\N
1425	1	1	1008	\N	Rose Wht Tibet 50cm	23881	2026-03-08 22:37:18.602696+00	\N
1426	1	1	1010	\N	Rose Wht Tibet 50cm Cs50	24612	2026-03-08 22:37:18.603184+00	\N
1427	1	1	1008	\N	Rose Wht Tibet 60cm	39798	2026-03-08 22:37:18.603547+00	\N
1428	1	1	1012	\N	Rose Wht Vendela 40cm	24061	2026-03-08 22:37:18.604136+00	\N
1429	1	1	1012	\N	Rose Wht Vendela 50cm	30769	2026-03-08 22:37:18.604522+00	\N
1430	1	1	1014	\N	Rose Wht Vendela 50cm Cs50	51066	2026-03-08 22:37:18.605038+00	\N
1431	1	1	1014	\N	Rose Wht Vendela 50cm Cs50	24647	2026-03-08 22:37:18.60539+00	\N
1432	1	1	1012	\N	Rose Wht Vendela 60cm	30841	2026-03-08 22:37:18.605853+00	\N
1433	1	1	1017	\N	Rose Wht Vendela 60cm Cs50	51047	2026-03-08 22:37:18.606421+00	\N
1434	1	1	1018	\N	Rose Yel Bikini 50cm	46922	2026-03-08 22:37:18.607017+00	\N
1435	1	1	1018	\N	Rose Yel Bikini 60cm	46923	2026-03-08 22:37:18.607335+00	\N
1436	1	1	1020	\N	Rose Yel Brighton 50cm	48892	2026-03-08 22:37:18.607919+00	\N
1437	1	1	1020	\N	Rose Yel Brighton 60cm	48893	2026-03-08 22:37:18.608232+00	\N
1438	1	1	1022	\N	Rose Yel Bumblebee 50cm	52545	2026-03-08 22:37:18.608641+00	\N
1439	1	1	1022	\N	Rose Yel Bumblebee 60cm	52396	2026-03-08 22:37:18.608889+00	\N
1440	1	1	1024	\N	Rose Yel Butterscotch 50cm	65687	2026-03-08 22:37:18.609486+00	\N
1441	1	1	1025	\N	Rose Yel Cancun 50cm	68774	2026-03-08 22:37:18.610001+00	\N
1442	1	1	1026	\N	Rose Yel Cancun 50cm cs50	20288	2026-03-08 22:37:18.610545+00	\N
1443	1	1	1025	\N	Rose Yel Cancun 60cm	26707	2026-03-08 22:37:18.611034+00	\N
1444	1	1	1028	\N	Rose Yel Gelosia 40cm Cs50	28793	2026-03-08 22:37:18.611761+00	\N
1445	1	1	1029	\N	Rose Yel Gelosia 50cm Cs50	51164	2026-03-08 22:37:18.612396+00	\N
1446	1	1	1030	\N	Rose Yel High & Exot 50cm	46869	2026-03-08 22:37:18.613043+00	\N
1447	1	1	1030	\N	Rose Yel High & Exot 50cm	54391	2026-03-08 22:37:18.613567+00	\N
1448	1	1	1030	\N	Rose Yel High & Exot 60cm	46870	2026-03-08 22:37:18.613972+00	\N
1449	1	1	1033	\N	Rose Yel Momentum 50cm	63370	2026-03-08 22:37:18.614758+00	\N
1450	1	1	1033	\N	Rose Yel Momentum 60cm	47260	2026-03-08 22:37:18.615191+00	\N
1451	1	1	1035	\N	Rose Yel Stardust 60cm	46851	2026-03-08 22:37:18.61573+00	\N
1452	1	1	1036	\N	Rose Yel Summer Rom. 50cm	56951	2026-03-08 22:37:18.616216+00	\N
1453	1	1	1037	\N	Rose Yel Turtle 50cm	46848	2026-03-08 22:37:18.616818+00	\N
1454	1454	1	1038	\N	Rose Petals Wht	53249	2026-03-08 22:37:18.617393+00	\N
1455	1455	1	\N	\N	Saxicola Pink	21560	2026-03-08 22:37:18.617631+00	\N
1456	1456	1	\N	\N	Scabiosa Lavender- Caucasian	\N	2026-03-08 22:37:18.617828+00	\N
1457	1456	1	\N	\N	Scabiosa Pink - Focal Scoop Bon Bon Vanilla	\N	2026-03-08 22:37:18.617969+00	\N
1458	1456	1	\N	\N	Scabiosa White - Focal Scoop	\N	2026-03-08 22:37:18.618131+00	\N
1459	1456	1	\N	\N	Scabiosa White- Caucasian	\N	2026-03-08 22:37:18.618745+00	\N
1460	1456	1	1039	\N	Scabiosa Pink Candy Scoop	43040	2026-03-08 22:37:18.619403+00	248
1461	1456	1	1039	\N	Scabiosa White Milky Scoop	42693	2026-03-08 22:37:18.620191+00	249
1462	1462	1	1041	\N	Pods Scabiosa Stellata 10st	29506	2026-03-08 22:37:18.620794+00	\N
1463	1463	1	\N	\N	Snapdragon Pink-Hot California	23678	2026-03-08 22:37:18.621077+00	\N
1464	1463	1	\N	\N	Snapdragon Orange	\N	2026-03-08 22:37:18.623106+00	\N
1465	1463	1	\N	\N	Snapdragon Pink California	23681	2026-03-08 22:37:18.623301+00	\N
1466	1463	1	\N	\N	Snapdragon White California	23684	2026-03-08 22:37:18.623465+00	\N
1467	1463	1	\N	\N	Snapdragon Burgundy California	23677	2026-03-08 22:37:18.623614+00	\N
1468	1463	1	\N	\N	Snapdragon Lavender California	23679	2026-03-08 22:37:18.623749+00	\N
1469	1463	1	1042	\N	Snapdragon Pink Tall Canada	23669	2026-03-08 22:37:18.6243+00	250
1470	1463	1	\N	\N	Snapdragon Pink-Hot Tall	23665	2026-03-08 22:37:18.624655+00	\N
1471	1463	1	\N	\N	Snapdragon Purple Medium	25831	2026-03-08 22:37:18.624837+00	\N
1472	1463	1	\N	\N	Snapdragon Red Flame	25807	2026-03-08 22:37:18.62502+00	\N
1473	1463	1	1042	\N	Snapdragon White Tall Canada	23673	2026-03-08 22:37:18.625371+00	143
1474	1463	1	1044	\N	Snapdragon Yellow 6pk Mexico	39094	2026-03-08 22:37:18.62595+00	252
1475	1463	1	\N	\N	Snapdragon Yellow California	23685	2026-03-08 22:37:18.62624+00	\N
1476	1463	1	\N	\N	Snapdragon Yellow S.A.	28707	2026-03-08 22:37:18.626406+00	\N
1477	1463	1	1042	\N	Snapdragon Yellow Tall Canada	23674	2026-03-08 22:37:18.626734+00	144
1478	1478	1	1046	\N	Snowberry White 60/70cm Chile	38121	2026-03-08 22:37:18.627374+00	254
1479	1478	1	\N	\N	Snowberry Pink/Wht Picotee	47327	2026-03-08 22:37:18.627624+00	\N
1480	1480	1	\N	\N	Solidago Yellow	\N	2026-03-08 22:37:18.627865+00	\N
1481	1481	1	\N	\N	Solomio White - Ard	\N	2026-03-08 22:37:18.628118+00	\N
1482	1481	1	\N	\N	Solomio White - Snow Tessino	\N	2026-03-08 22:37:18.628337+00	\N
1483	1483	1	1047	\N	Ranunculus Berry Capp XXL 5st	27775	2026-03-08 22:37:18.628996+00	\N
1484	1483	1	\N	\N	Ranunculus - Cloni Success Lady Pink	\N	2026-03-08 22:37:18.629214+00	\N
1485	1483	1	\N	\N	Ranunculus Blush - Cloni Success Hanoi	\N	2026-03-08 22:37:18.629434+00	\N
1486	1483	1	1048	\N	Ranunculus Asst XXL 5st 5pk	17900	2026-03-08 22:37:18.629919+00	\N
1487	1483	1	1049	\N	Ranunculus Chocolate XL 10st	17887	2026-03-08 22:37:18.630514+00	\N
1488	1483	1	1050	\N	Ranunculus Chocolate XXL 5st	17886	2026-03-08 22:37:18.631083+00	\N
1489	1483	1	1051	\N	Ranunculus Coral Desert XL 10s	69713	2026-03-08 22:37:18.631563+00	\N
1490	1483	1	1052	\N	Ranunculus Coral Fragolino XXL	42785	2026-03-08 22:37:18.632048+00	\N
1491	1483	1	1053	\N	Ranunculus Pch Grand Pastel XX	17866	2026-03-08 22:37:18.632585+00	\N
1492	1483	1	1054	\N	Ranunculus Pink Blush Clooney	42771	2026-03-08 22:37:18.633039+00	\N
1493	1483	1	1055	\N	Ranunculus Pink Blush XL 10st	41190	2026-03-08 22:37:18.633497+00	\N
1494	1483	1	1056	\N	Ranunculus Pink Blush XXL 5st	17840	2026-03-08 22:37:18.634024+00	\N
1495	1483	1	1057	\N	Ranunculus Pink Dark Clooney I	45447	2026-03-08 22:37:18.634502+00	\N
1496	1483	1	1058	\N	Ranunculus Pink Hot XL 10st	41192	2026-03-08 22:37:18.634879+00	\N
1497	1483	1	1059	\N	Ranunculus Pink Hot XXL 5st Ca	17865	2026-03-08 22:37:18.635256+00	\N
1498	1483	1	1060	\N	Ranunculus Pink Lady XXL 5st	17904	2026-03-08 22:37:18.63567+00	\N
1499	1483	1	1061	\N	Ranunculus Pink Lt Confetto XX	69722	2026-03-08 22:37:18.636339+00	\N
1500	1483	1	1062	\N	Ranunculus Pink Lt XXL 5st	17896	2026-03-08 22:37:18.637129+00	\N
1501	1483	1	1063	\N	Ranunculus Pink Romance XXL 5s	69711	2026-03-08 22:37:18.637779+00	\N
1502	1483	1	1064	\N	Ranunculus Pink Ruffle XL 10st	69714	2026-03-08 22:37:18.63825+00	\N
1503	1483	1	1065	\N	Ranunculus Pink Ruffle XXL 5st	49382	2026-03-08 22:37:18.638768+00	\N
1504	1483	1	1066	\N	Ranunculus Plum XL 10st	41191	2026-03-08 22:37:18.63922+00	\N
1505	1483	1	1067	\N	Ranunculus Plum XXL 5st	17883	2026-03-08 22:37:18.639696+00	\N
1506	1483	1	1068	\N	Ranunculus Princess Peach XXL	17884	2026-03-08 22:37:18.640267+00	\N
1507	1483	1	1069	\N	Ranunculus Red XL 10st	41196	2026-03-08 22:37:18.640805+00	\N
1508	1483	1	1070	\N	Ranunculus Red XXL 5st	45242	2026-03-08 22:37:18.64134+00	\N
1509	1483	1	1071	\N	Ranunculus Striato Pastel XXL	69718	2026-03-08 22:37:18.641897+00	\N
1510	1483	1	1072	\N	Ranunculus White Clooney Italy	45400	2026-03-08 22:37:18.642418+00	\N
1511	1483	1	1073	\N	Ranunculus White XL 10st	41193	2026-03-08 22:37:18.642811+00	\N
1512	1483	1	1074	\N	Ranunculus White XXL 5st	17841	2026-03-08 22:37:18.643254+00	\N
1513	1483	1	1075	\N	Ranunculus Yellow Romance XXL	69710	2026-03-08 22:37:18.643665+00	\N
1514	1483	1	1076	\N	Ranunculus Yellow XXL 5st	17898	2026-03-08 22:37:18.644066+00	\N
1515	1515	1	1077	\N	Spirea White Kodemari 80-110cm	49674	2026-03-08 22:37:18.645158+00	255
1516	1515	1	1078	\N	Spirea White Thunbergii 10stem	53070	2026-03-08 22:37:18.645942+00	256
1517	1517	1	\N	\N	Be Amazing - Spray Rose	\N	2026-03-08 22:37:18.646362+00	\N
1518	1517	1	\N	\N	Be Gentle Spray Rose - Blush	\N	2026-03-08 22:37:18.646566+00	\N
1519	1517	1	\N	\N	Be Kind - White Spray Rose	\N	2026-03-08 22:37:18.646782+00	\N
1520	1517	1	\N	\N	Be True Cream/blush - Spray Rose	\N	2026-03-08 22:37:18.646932+00	\N
1521	1517	1	\N	\N	Big Dipper Spray Rose - Blush	\N	2026-03-08 22:37:18.647081+00	\N
1522	1517	1	\N	\N	Spray Rose - Blush - Creta	\N	2026-03-08 22:37:18.64722+00	\N
1523	1517	1	\N	\N	Spray Rose - Candy Blush	\N	2026-03-08 22:37:18.647356+00	\N
1524	1517	1	\N	\N	Spray Rose - Lesbos	\N	2026-03-08 22:37:18.647489+00	\N
1525	1517	1	\N	\N	Spray Rose - Sahara Sensation	\N	2026-03-08 22:37:18.647625+00	\N
1526	1517	1	1079	\N	SpRose Wht Majolica 40/50cm	23598	2026-03-08 22:37:18.64796+00	\N
1527	1517	1	\N	\N	Spray Rose Blush - Be Nice	\N	2026-03-08 22:37:18.648149+00	\N
1528	1517	1	\N	\N	Spray Rose Hot Pink - Fire Up	\N	2026-03-08 22:37:18.648315+00	\N
1529	1517	1	\N	\N	Spray Rose Lavender - Little Silver	\N	2026-03-08 22:37:18.648498+00	\N
1530	1517	1	\N	\N	Spray Rose Orange-Saona	\N	2026-03-08 22:37:18.648719+00	\N
1531	1517	1	1080	\N	SpRose Pch Bali 40/50cm	64149	2026-03-08 22:37:18.649331+00	\N
1532	1517	1	1081	\N	SpRose Pch Apricot Bril Stars	64136	2026-03-08 22:37:18.649925+00	\N
1533	1517	1	\N	\N	Spray Rose Pink - Boomerang	\N	2026-03-08 22:37:18.650208+00	\N
1534	1517	1	\N	\N	Spray Rose Pink - Elva	\N	2026-03-08 22:37:18.650408+00	\N
1535	1517	1	1082	\N	SpRose Rd/Brg Rubicon 40/50cm	30038	2026-03-08 22:37:18.650915+00	\N
1536	1517	1	\N	\N	Spray Rose Red - Scarlette Mimi	\N	2026-03-08 22:37:18.651162+00	\N
1537	1517	1	1083	\N	SpRose Wht Floreana 40/50cm	64129	2026-03-08 22:37:18.65155+00	\N
1538	1517	1	1084	\N	SpRose Wht Snowflake 40/50cm	30211	2026-03-08 22:37:18.651983+00	\N
1539	1517	1	\N	\N	Spray Rose White- Shining Star	\N	2026-03-08 22:37:18.652207+00	\N
1540	1517	1	1085	\N	SpRose Asst 40cm Cs12	29014	2026-03-08 22:37:18.652616+00	\N
1541	1517	1	1086	\N	SpRose Asst 40cm DVF Cs12	61006	2026-03-08 22:37:18.653082+00	\N
1542	1517	1	1087	\N	SpRose Asst 50cm Cs10	23516	2026-03-08 22:37:18.65377+00	\N
1543	1517	1	1088	\N	SpRose Crm Gard Cluster 5st	69708	2026-03-08 22:37:18.654247+00	\N
1544	1517	1	1089	\N	SpRose Crm New Moon 60cm	58806	2026-03-08 22:37:18.654805+00	\N
1545	1517	1	1090	\N	SpRose Htpk Bril Star 50cm	56806	2026-03-08 22:37:18.655194+00	\N
1546	1517	1	1091	\N	SpRose HtPk Gem Star 40/50cm	49958	2026-03-08 22:37:18.657182+00	\N
1547	1517	1	1092	\N	SpRose Htpk L Lydia 40/50cm	23521	2026-03-08 22:37:18.657557+00	\N
1548	1517	1	1093	\N	SpRose Htpk Majolica 40/50cm	30960	2026-03-08 22:37:18.658038+00	\N
1549	1517	1	1093	\N	SpRose Htpk Majolica 40/50cm	53015	2026-03-08 22:37:18.658348+00	\N
1550	1517	1	1095	\N	SpRose Lav Bl Moon 40/50cm	28592	2026-03-08 22:37:18.658835+00	\N
1551	1517	1	1096	\N	SpRose Lav Portrait 40/50cm	68638	2026-03-08 22:37:18.65925+00	\N
1552	1517	1	1097	\N	SpRose Lav Silv Mik 40/50cm	64145	2026-03-08 22:37:18.659655+00	\N
1553	1517	1	1098	\N	SpRose Org Babe 40/50cm	31029	2026-03-08 22:37:18.660008+00	\N
1554	1517	1	1099	\N	SpRose Org Royal Flash 40/50cm	57543	2026-03-08 22:37:18.660438+00	\N
1555	1517	1	1100	\N	SpRose Org Sensation 40/50cm	52566	2026-03-08 22:37:18.660861+00	\N
1556	1517	1	1101	\N	SpRose Pch Aureus 40/50cm	67023	2026-03-08 22:37:18.661405+00	\N
1557	1517	1	1102	\N	SpRose Pch Baby Rosev 40/50cm	64126	2026-03-08 22:37:18.661908+00	\N
1558	1517	1	1103	\N	SpRose Pch Capricorn 40/50cm	68637	2026-03-08 22:37:18.662514+00	\N
1559	1517	1	1104	\N	SpRose Pch Ilse 40/50cm	23555	2026-03-08 22:37:18.663349+00	\N
1560	1517	1	1105	\N	SpRose Pch LtPk Bril Star 50cm	34539	2026-03-08 22:37:18.663818+00	\N
1561	1517	1	1106	\N	SpRose Pk Cozumel 40/50cm 5st	69754	2026-03-08 22:37:18.664266+00	\N
1562	1517	1	1107	\N	SpRose Pk Elba 40/50cm	64127	2026-03-08 22:37:18.664745+00	\N
1563	1517	1	1108	\N	SpRose Pk Majolica 40/50cm	23582	2026-03-08 22:37:18.665247+00	\N
1564	1517	1	1109	\N	SpRose Pk Majolica 50cm cs6	49136	2026-03-08 22:37:18.665726+00	\N
1565	1517	1	1110	\N	SpRose Pk Phuket 40cm	64122	2026-03-08 22:37:18.666252+00	\N
1566	1517	1	1111	\N	SpRose Pk Star Blush 40/50cm	27668	2026-03-08 22:37:18.666792+00	\N
1567	1517	1	1112	\N	SpRose Rd Mikado 40/50cm	23589	2026-03-08 22:37:18.667182+00	\N
1568	1517	1	1113	\N	Sprose Sal Be Joyful 50-70cm	63089	2026-03-08 22:37:18.667581+00	\N
1569	1517	1	1114	\N	SpRose Wht Jeanine 40/50cm	49027	2026-03-08 22:37:18.66794+00	\N
1570	1517	1	1115	\N	SpRose Wht Majo 50cm Cs5	23551	2026-03-08 22:37:18.668325+00	\N
1571	1517	1	1116	\N	SpRose Wht Snoflk 50cm cs6	62021	2026-03-08 22:37:18.668709+00	\N
1572	1517	1	1117	\N	SpRose Wht Swt Dreams 40/50cm	52270	2026-03-08 22:37:18.669149+00	\N
1573	1517	1	1118	\N	SpRose Yel Babe 40/50cm	30254	2026-03-08 22:37:18.669632+00	\N
1574	1517	1	1119	\N	SpRose Yel Bora Bora 40/50cm	56866	2026-03-08 22:37:18.670094+00	\N
1575	1517	1	1120	\N	SpRose Yel Bril Star 40/50cm	25800	2026-03-08 22:37:18.670714+00	\N
1576	1517	1	1121	\N	SpRose Yel Bril Star Lemon 50c	20502	2026-03-08 22:37:18.672232+00	\N
1577	1517	1	1122	\N	SpRose Yel Fibo Gioconda 50cm	52440	2026-03-08 22:37:18.672635+00	\N
1578	1517	1	1123	\N	SpRose Yel Somerset 40/50cm	64128	2026-03-08 22:37:18.673091+00	\N
1579	1579	1	\N	\N	Springeri	G1117	2026-03-08 22:37:18.673355+00	\N
1580	1580	1	\N	\N	Ranunculus - Ciocolato Elegance	\N	2026-03-08 22:37:18.673626+00	\N
1581	1580	1	\N	\N	Ranunculus - Coral Elegance	\N	2026-03-08 22:37:18.673761+00	\N
1582	1580	1	\N	\N	Ranunculus - Cream Elegance	\N	2026-03-08 22:37:18.673979+00	\N
1583	1580	1	\N	\N	Ranunculus - Hot Pink Elegance	\N	2026-03-08 22:37:18.674177+00	\N
1584	1580	1	\N	\N	Ranunculus - Light Pink Elegance	\N	2026-03-08 22:37:18.674999+00	\N
1585	1580	1	\N	\N	Ranunculus - Orange Elegance	\N	2026-03-08 22:37:18.675324+00	\N
1586	1580	1	\N	\N	Ranunculus - Peach Elegance	\N	2026-03-08 22:37:18.675494+00	\N
1587	1580	1	\N	\N	Ranunculus - Pink Elegance	\N	2026-03-08 22:37:18.67568+00	\N
1588	1580	1	\N	\N	Ranunculus - Purple Elegance	\N	2026-03-08 22:37:18.675883+00	\N
1589	1580	1	\N	\N	Ranunculus - Red Elegance	\N	2026-03-08 22:37:18.676137+00	\N
1590	1580	1	\N	\N	Ranunculus - White Elegance	\N	2026-03-08 22:37:18.676364+00	\N
1591	1580	1	\N	\N	Ranunculus - Yellow Elegance	\N	2026-03-08 22:37:18.676545+00	\N
1592	1580	1	\N	\N	Ranunculus Orange - Pon Pon Garfield	\N	2026-03-08 22:37:18.676781+00	\N
1593	1580	1	\N	\N	Ranunculus Peach- Pastello	\N	2026-03-08 22:37:18.677014+00	\N
1594	1594	1	\N	\N	Statice Sinzil Lilae - Lavender	\N	2026-03-08 22:37:18.678359+00	\N
1595	1594	1	\N	\N	Statice Sinzil Peach	\N	2026-03-08 22:37:18.678544+00	\N
1596	1594	1	\N	\N	Statice Sinzil Pink	\N	2026-03-08 22:37:18.678763+00	\N
1597	1594	1	1124	\N	Statice Apricot Tissue Culture	18279	2026-03-08 22:37:18.679608+00	\N
1598	1594	1	1125	\N	Statice Blush Tissue CA	17732	2026-03-08 22:37:18.681061+00	257
1599	1594	1	1126	\N	Statice Purple Queens 5pk	60595	2026-03-08 22:37:18.683122+00	258
1600	1594	1	1127	\N	Statice Purple Tissue Queens	24996	2026-03-08 22:37:18.684146+00	259
1601	1594	1	1128	\N	Statice White Tissue Culture	25043	2026-03-08 22:37:18.685093+00	260
1602	1602	1	\N	\N	Stock Pink Appleblossom	25128	2026-03-08 22:37:18.685608+00	\N
1603	1602	1	1129	\N	Stock Brg Ruby Red S.A.	23705	2026-03-08 22:37:18.686595+00	\N
1604	1602	1	\N	\N	Stock Cream S.A.	27979	2026-03-08 22:37:18.687333+00	\N
1605	1602	1	\N	\N	Stock Purple-Dk S.A.	38603	2026-03-08 22:37:18.687914+00	\N
1606	1602	1	\N	\N	Stock Pink-Dark S.A.	25093	2026-03-08 22:37:18.688274+00	\N
1607	1602	1	\N	\N	Stock Lavender S.A.	28309	2026-03-08 22:37:18.688681+00	\N
1608	1602	1	\N	\N	Stock Pink-Light S.A.	75097	2026-03-08 22:37:18.689493+00	\N
1609	1602	1	\N	\N	Stock Peach S.A.	27978	2026-03-08 22:37:18.689894+00	\N
1610	1602	1	\N	\N	Stock White S.A.	26642	2026-03-08 22:37:18.690239+00	\N
1611	1602	1	1130	\N	Stock Asst 4pk Wt/Lav S.A.	40487	2026-03-08 22:37:18.691005+00	\N
1612	1602	1	1131	\N	Stock Brg Ruby Red 4pk S.A.	75101	2026-03-08 22:37:18.691717+00	\N
1613	1602	1	1132	\N	Stock Cream 4pk S.A.	75100	2026-03-08 22:37:18.693323+00	261
1614	1602	1	\N	\N	Stock Lavender	25064	2026-03-08 22:37:18.693714+00	\N
1615	1602	1	1133	\N	Stock Lavender S.A. 4Pk	40485	2026-03-08 22:37:18.694586+00	262
1616	1602	1	1134	\N	Stock Lavender-Dk Blue Mid	25738	2026-03-08 22:37:18.695426+00	263
1617	1602	1	1135	\N	Stock Magenta Fuchsia	25063	2026-03-08 22:37:18.69605+00	\N
1618	1602	1	1136	\N	Stock Magenta Fuchsia S.A.	23700	2026-03-08 22:37:18.697092+00	\N
1619	1602	1	1137	\N	Stock Magenta Fuschia 4pk S.A.	75099	2026-03-08 22:37:18.697978+00	\N
1620	1602	1	1138	\N	Stock Mauve Antique 4Pk S.A.	40504	2026-03-08 22:37:18.698855+00	264
1621	1602	1	1132	\N	Stock Mauve Antique S.A.	39709	2026-03-08 22:37:18.699611+00	265
1622	1602	1	\N	\N	Stock Peach	26154	2026-03-08 22:37:18.699988+00	\N
1623	1602	1	1132	\N	Stock Peach 4pk S.A.	75098	2026-03-08 22:37:18.700607+00	266
1624	1602	1	\N	\N	Stock Pink-Dark	40531	2026-03-08 22:37:18.700986+00	\N
1625	1602	1	\N	\N	Stock Pink-Dk Pacific	25125	2026-03-08 22:37:18.701369+00	\N
1626	1602	1	1133	\N	Stock Pink-Dk S.A. 4pk	25083	2026-03-08 22:37:18.702105+00	267
1627	1602	1	1132	\N	Stock Pink-Light 4pk S.A.	17365	2026-03-08 22:37:18.702828+00	268
1628	1602	1	1133	\N	Stock Pink-Lt Applebl 4pk	27977	2026-03-08 22:37:18.703536+00	267
1629	1602	1	\N	\N	Stock Pink-Lt Sweetheart	75125	2026-03-08 22:37:18.704372+00	\N
1630	1602	1	1144	\N	Stock Pink/White Antique 4pk B	25065	2026-03-08 22:37:18.705534+00	270
1631	1602	1	1132	\N	Stock Purple 4pk S.A.	40341	2026-03-08 22:37:18.706267+00	271
1632	1602	1	\N	\N	Stock Purple S.A.	28308	2026-03-08 22:37:18.706584+00	\N
1633	1602	1	\N	\N	Stock Purple Velvet	25141	2026-03-08 22:37:18.706858+00	\N
1634	1602	1	1133	\N	Stock Purple-Dk S.A. 4pk	17366	2026-03-08 22:37:18.707615+00	272
1635	1602	1	\N	\N	Stock White	25068	2026-03-08 22:37:18.708045+00	\N
1636	1602	1	1132	\N	Stock White 4pk S.A.	40340	2026-03-08 22:37:18.708689+00	273
1637	1602	1	1148	\N	Stock White Spray 5st 5pk	45094	2026-03-08 22:37:18.709653+00	274
1638	1602	1	1149	\N	Stock White Supreme 10pk	36714	2026-03-08 22:37:18.710378+00	112
1639	1639	1	1150	\N	Strawflower Assorted 10pk	21565	2026-03-08 22:37:18.71127+00	\N
1640	1639	1	\N	\N	Strawflower White 10st	22364	2026-03-08 22:37:18.711595+00	\N
1641	1641	1	\N	\N	Spray Sunflowers	\N	2026-03-08 22:37:18.712743+00	\N
1642	1641	1	\N	\N	Sunflower - Helios	\N	2026-03-08 22:37:18.71351+00	\N
1643	1641	1	1151	\N	Sunflower Ylw Vincent Sel 5st	38277	2026-03-08 22:37:18.71467+00	\N
1644	1641	1	1152	\N	Sunflower Vincent Lg 5st 5pk	40484	2026-03-08 22:37:18.715504+00	\N
1645	1641	1	1153	\N	Sunflower Ylw DC FNY Vin Choic	31862	2026-03-08 22:37:18.716231+00	\N
1646	1641	1	1154	\N	Sunflower Ylw DC SEL Vin Choic	31868	2026-03-08 22:37:18.717111+00	\N
1647	1641	1	1155	\N	Sunflower Ylw DC XTR Vin Choic	31865	2026-03-08 22:37:18.717836+00	\N
1648	1641	1	1156	\N	Sunflower Ylw LC FCY Vin Fresh	31863	2026-03-08 22:37:18.718484+00	\N
1649	1641	1	1157	\N	Sunflower Ylw LC SEL Vin Fresh	31869	2026-03-08 22:37:18.719239+00	\N
1650	1641	1	1158	\N	Sunflower Ylw LC XTR Vin Fresh	31866	2026-03-08 22:37:18.720064+00	\N
1651	1641	1	1159	\N	Sunflower Ylw Mini DC 10st	21784	2026-03-08 22:37:18.720768+00	\N
1652	1641	1	1160	\N	Sunflower Ylw Sunbright 5st	32865	2026-03-08 22:37:18.721644+00	\N
1653	1641	1	1161	\N	Sunflower Ylw Vin 5st 12pk Mex	36598	2026-03-08 22:37:18.722432+00	\N
1654	1641	1	1162	\N	Sunflower Ylw Vin Mini 10s 6pk	40486	2026-03-08 22:37:18.723145+00	\N
1655	1641	1	1163	\N	Sunflower Ylw Vin Petite 10st	27533	2026-03-08 22:37:18.72387+00	\N
1656	1641	1	1164	\N	Sunflower Ylw Vin Sel 5st 4pk	32876	2026-03-08 22:37:18.724478+00	\N
1657	1641	1	1165	\N	Sunflower Ylw Vincent 5st 6pk	40483	2026-03-08 22:37:18.725099+00	\N
1658	1641	1	1166	\N	Sunflower Ylw Vincent 8pk DVF	52076	2026-03-08 22:37:18.725838+00	\N
1659	1659	1	\N	\N	Sweet Pea Blush	\N	2026-03-08 22:37:18.72624+00	\N
1660	1659	1	\N	\N	Sweet Pea Cream 25stem	17382	2026-03-08 22:37:18.726507+00	\N
1661	1659	1	1167	\N	Sweet Pea Dk Pink Happy 50stem	18052	2026-03-08 22:37:18.727093+00	\N
1662	1659	1	\N	\N	Sweet Pea Hot Pink	\N	2026-03-08 22:37:18.727397+00	\N
1663	1659	1	\N	\N	Sweet Pea Lavender 25stem	17384	2026-03-08 22:37:18.72767+00	\N
1664	1659	1	\N	\N	Sweet Pea White 25stem	41330	2026-03-08 22:37:18.727918+00	\N
1665	1659	1	1168	\N	Sweet Pea Lavender Japan 50st	18057	2026-03-08 22:37:18.728713+00	276
1666	1659	1	1169	\N	Sweet Pea Light Pink 25stem	17381	2026-03-08 22:37:18.729546+00	277
1667	1659	1	\N	\N	Sweet Pea Peach 50st	43514	2026-03-08 22:37:18.729873+00	\N
1668	1659	1	1169	\N	Sweet Pea Peach Megumi 25stem	18189	2026-03-08 22:37:18.730461+00	278
1669	1659	1	1171	\N	Sweet Pea Pink-Hot Salmon 25st	17396	2026-03-08 22:37:18.731284+00	279
1670	1659	1	\N	\N	Sweet Pea Pink-Light 50st	17521	2026-03-08 22:37:18.731711+00	\N
1671	1659	1	\N	\N	Sweet Pea Purple 50st	51384	2026-03-08 22:37:18.732071+00	\N
1672	1659	1	1168	\N	Sweet Pea Red Scarlet 50st	18088	2026-03-08 22:37:18.732798+00	280
1673	1659	1	1173	\N	Sweet Pea Violet 25stem	18104	2026-03-08 22:37:18.733473+00	\N
1674	1659	1	\N	\N	Sweet Pea White 50stem	58887	2026-03-08 22:37:18.733745+00	\N
1675	1675	1	1174	\N	Sweetheart Rose Rd Sacha	31150	2026-03-08 22:37:18.734528+00	\N
1676	1676	1	1175	\N	Thistle Blue Bell 60cm 6pk	46099	2026-03-08 22:37:18.735794+00	281
1677	1676	1	1176	\N	Thistle Blue Dynamite 5st 80cm	45860	2026-03-08 22:37:18.736625+00	282
1678	1676	1	1177	\N	Thistle Blue Lagoon 50/60cm	17276	2026-03-08 22:37:18.737469+00	283
1679	1676	1	1178	\N	Thistle Green Sirius Questar	12558	2026-03-08 22:37:18.738481+00	284
1680	1680	1	\N	\N	Limonium - Cinnamon Tinted	\N	2026-03-08 22:37:18.738946+00	\N
1681	1681	1	\N	\N	Trachelium - Corine Light Blue	\N	2026-03-08 22:37:18.739333+00	\N
1682	1682	1	1179	\N	Trachelium Blue-Dark	25568	2026-03-08 22:37:18.740093+00	\N
1683	1682	1	1180	\N	Trachelium Green Jade	41464	2026-03-08 22:37:18.740892+00	\N
1684	1682	1	1181	\N	Trachelium White	25570	2026-03-08 22:37:18.741713+00	\N
1685	1685	1	1182	\N	Aspidistra 10pk	G1388	2026-03-08 22:37:18.742525+00	\N
1686	1685	1	1183	\N	Aspidistra Variegated	G1224	2026-03-08 22:37:18.74326+00	\N
1687	1685	1	1184	\N	Aspidistra XL	G1759	2026-03-08 22:37:18.743974+00	\N
1688	1685	1	1185	\N	Leaf Calathea White Star	10679	2026-03-08 22:37:18.744636+00	\N
1689	1685	1	1186	\N	Leaf Calathea Zebrina	34021	2026-03-08 22:37:18.745359+00	\N
1690	1685	1	1187	\N	Leaf Ginger Variegated 10st	32467	2026-03-08 22:37:18.746018+00	\N
1691	1685	1	1188	\N	Leaf Monstera Jumbo/XL	37339	2026-03-08 22:37:18.746664+00	\N
1692	1685	1	1189	\N	Leaf Monstera Large	10167	2026-03-08 22:37:18.747295+00	\N
1693	1685	1	1190	\N	Leaf Monstera Medium	10168	2026-03-08 22:37:18.747863+00	\N
1694	1685	1	1191	\N	Leaf Monstera Mini	31205	2026-03-08 22:37:18.748425+00	\N
1695	1685	1	1192	\N	Leaf Monstera Small	10169	2026-03-08 22:37:18.748989+00	\N
1696	1685	1	1193	\N	Leaf Ti Green	10171	2026-03-08 22:37:18.749585+00	\N
1697	1685	1	1194	\N	Leaf Ti Red	10172	2026-03-08 22:37:18.750218+00	\N
1698	1685	1	1195	\N	Aspidistra	G1001	2026-03-08 22:37:18.750771+00	\N
1699	1685	1	\N	\N	Bird Of Paradise	\N	2026-03-08 22:37:18.751037+00	\N
1700	1685	1	\N	\N	Palm - Robelina	\N	2026-03-08 22:37:18.75124+00	\N
1701	1685	1	\N	\N	Palm - Sago Large	\N	2026-03-08 22:37:18.751485+00	\N
1702	1702	1	\N	\N	Double Tulip Yellow	\N	2026-03-08 22:37:18.751806+00	\N
1703	1702	1	\N	\N	Purple Double Tulip	\N	2026-03-08 22:37:18.752041+00	\N
1704	1702	1	\N	\N	Tulip - Double Cream	\N	2026-03-08 22:37:18.752243+00	\N
1705	1702	1	\N	\N	Tulip - Double Double Price Lavender	\N	2026-03-08 22:37:18.752526+00	\N
1706	1702	1	\N	\N	Tulip - Double Price Light Pink	\N	2026-03-08 22:37:18.75276+00	\N
1707	1702	1	\N	\N	Tulip Red VA	38978	2026-03-08 22:37:18.753037+00	\N
1708	1702	1	\N	\N	Tulip Black - Ronaldo	\N	2026-03-08 22:37:18.753997+00	\N
1709	1702	1	\N	\N	Tulip Double Python	\N	2026-03-08 22:37:18.754303+00	\N
1710	1702	1	\N	\N	Tulip Orange - Princess Double	\N	2026-03-08 22:37:18.754549+00	\N
1711	1702	1	\N	\N	Tulip Orange Parrot	\N	2026-03-08 22:37:18.754773+00	\N
1712	1702	1	\N	\N	Tulip Purple - Queen Of The Night	\N	2026-03-08 22:37:18.755138+00	\N
1713	1702	1	\N	\N	Tulip White	\N	2026-03-08 22:37:18.755377+00	\N
1714	1702	1	\N	\N	Tulip Black Jack	49483	2026-03-08 22:37:18.755623+00	\N
1715	1702	1	\N	\N	Tulip Purple VA	38977	2026-03-08 22:37:18.755879+00	\N
1716	1702	1	1196	\N	Tulip Asst 15pk VA	38560	2026-03-08 22:37:18.756654+00	\N
1717	1702	1	1197	\N	Tulip Lav Candy Prince Dutch	45811	2026-03-08 22:37:18.75756+00	\N
1718	1702	1	\N	\N	Tulip Orange VA	38975	2026-03-08 22:37:18.757828+00	\N
1719	1702	1	\N	\N	Tulip Pink Dutch	25181	2026-03-08 22:37:18.758043+00	\N
1720	1702	1	1198	\N	Tulip Pink Ht Dutch	54077	2026-03-08 22:37:18.758599+00	175
1721	1702	1	\N	\N	Tulip Pink VA	35180	2026-03-08 22:37:18.758931+00	\N
1722	1702	1	1199	\N	Tulip Pnk Lt First Class Dutch	33171	2026-03-08 22:37:18.759494+00	\N
1723	1702	1	1200	\N	Tulip Prp Prince Dutch	25162	2026-03-08 22:37:18.760073+00	\N
1724	1702	1	\N	\N	Tulip White VA	38979	2026-03-08 22:37:18.760362+00	\N
1725	1702	1	\N	\N	Tulip Yellow VA	38980	2026-03-08 22:37:18.760571+00	\N
1726	1726	1	\N	\N	Tweedia Blue Japan	42302	2026-03-08 22:37:18.760877+00	\N
1727	1726	1	1201	\N	Tweedia White Dutch 10stem	75206	2026-03-08 22:37:18.761462+00	256
1728	1726	1	\N	\N	Tweedia White Japan	42301	2026-03-08 22:37:18.7618+00	\N
1729	1726	1	\N	\N	Tweedia White S.A.	17588	2026-03-08 22:37:18.762137+00	\N
1730	1730	1	\N	\N	Veronica Spray White	\N	2026-03-08 22:37:18.762717+00	\N
1731	1730	1	1202	\N	Veronica California	\N	2026-03-08 22:37:18.763423+00	\N
1732	1730	1	\N	\N	Veronica Blue Dutch	22157	2026-03-08 22:37:18.763732+00	\N
1733	1730	1	\N	\N	Veronica White Dutch	22159	2026-03-08 22:37:18.763992+00	\N
1734	1734	1	\N	\N	Wax Flower - Lavender	\N	2026-03-08 22:37:18.764411+00	\N
1735	1734	1	\N	\N	Wax Flower Light Pink	\N	2026-03-08 22:37:18.76461+00	\N
1736	1734	1	\N	\N	Wax Flower Orange	\N	2026-03-08 22:37:18.764843+00	\N
1737	1734	1	\N	\N	Wax Flower Pink	\N	2026-03-08 22:37:18.765091+00	\N
1738	1734	1	\N	\N	Wax Flower Purple	\N	2026-03-08 22:37:18.765294+00	\N
1739	1734	1	\N	\N	Wax Flower White	\N	2026-03-08 22:37:18.765541+00	\N
1740	1740	1	\N	\N	Waxflower Pink CA	33023	2026-03-08 22:37:18.765855+00	\N
1741	1740	1	1203	\N	Waxflower Pink Dancing Queen	27736	2026-03-08 22:37:18.76668+00	287
1742	1740	1	1204	\N	Waxflower Pink Hyb CA	26102	2026-03-08 22:37:18.767317+00	217
1743	1740	1	1205	\N	Waxflower Pink Lady Stephanie	21604	2026-03-08 22:37:18.768151+00	289
1744	1740	1	\N	\N	Waxflower Pink Lollypop	29113	2026-03-08 22:37:18.768454+00	\N
1745	1740	1	\N	\N	Waxflower Purple CA	33025	2026-03-08 22:37:18.768683+00	\N
1746	1740	1	1206	\N	Waxflower Purple Select Peru	32374	2026-03-08 22:37:18.769233+00	211
1747	1740	1	1207	\N	Waxflower Wh Hyb/Blush Maya	39927	2026-03-08 22:37:18.769853+00	\N
1748	1740	1	1208	\N	Waxflower White 50-55cm 14st	33908	2026-03-08 22:37:18.770796+00	291
1749	1740	1	1204	\N	Waxflower White Hyb CA	27329	2026-03-08 22:37:18.771379+00	224
1750	1750	1	1210	\N	Yarrow Asst Roots Peru 6pk	31478	2026-03-08 22:37:18.772179+00	\N
1751	1750	1	1211	\N	Yarrow Cottage Salmon	29486	2026-03-08 22:37:18.77275+00	\N
1752	1750	1	1212	\N	Yarrow Orange Peru 10st	32267	2026-03-08 22:37:18.77344+00	293
1753	1750	1	\N	\N	Yarrow White Peru	35575	2026-03-08 22:37:18.773786+00	\N
1754	1750	1	\N	\N	Yarrow Yellow Peru	31479	2026-03-08 22:37:18.774056+00	\N
1755	204	4	1213	\N	ASTER WHITE	\N	2026-03-08 22:37:18.77486+00	294
1756	688	4	1214	\N	LEUCADEDRON RED	\N	2026-03-08 22:37:18.775723+00	295
1757	525	4	1215	\N	GREEN WICKY	\N	2026-03-08 22:37:18.77655+00	296
1758	1758	4	1216	\N	FIORINO IRIS	\N	2026-03-08 22:37:18.777256+00	\N
1759	1759	4	1217	\N	LILLIPUT FOREVER	\N	2026-03-08 22:37:18.777943+00	\N
1760	1759	4	1218	\N	LILLIPUT MAGIC FROST	\N	2026-03-08 22:37:18.778516+00	\N
1761	1759	4	1219	\N	LILLIPUT NAUGE	\N	2026-03-08 22:37:18.779106+00	\N
1762	1480	4	1220	\N	GOLDEN SOLIDAGO	\N	2026-03-08 22:37:18.779884+00	297
1763	1480	4	1221	\N	SOLIDAGO YELLOW	\N	2026-03-08 22:37:18.780794+00	298
1764	1481	4	1222	\N	SOLOMIO ARD	\N	2026-03-08 22:37:18.781474+00	\N
1765	1481	4	1223	\N	SOLOMIO BERNI	\N	2026-03-08 22:37:18.782058+00	\N
1766	1481	4	1224	\N	SOLOMIO CAS	\N	2026-03-08 22:37:18.782593+00	\N
1767	1481	4	1225	\N	SOLOMIO EDO	\N	2026-03-08 22:37:18.783197+00	\N
1768	1481	4	1226	\N	SOLOMIO IMRE	\N	2026-03-08 22:37:18.783746+00	\N
1769	1481	4	1227	\N	SOLOMIO SEM	\N	2026-03-08 22:37:18.784282+00	\N
1770	1481	4	1228	\N	SOLOMIO STAR SNOW TESSINO	\N	2026-03-08 22:37:18.784873+00	\N
1771	94	4	1229	\N	CLAVEL HANOI	\N	2026-03-08 22:37:18.78553+00	\N
1772	537	4	1230	\N	BUNNY TAIL BROWN	\N	2026-03-08 22:37:18.786338+00	299
1773	543	4	1231	\N	BABY BLUE EUCALIPTO	\N	2026-03-08 22:37:18.787178+00	300
1774	543	4	1232	\N	CINEREA EUCALIPTO	\N	2026-03-08 22:37:18.787821+00	\N
1775	543	4	1233	\N	PARVULA GUM EUCALIPTO	\N	2026-03-08 22:37:18.788426+00	\N
1776	543	4	1234	\N	POLYANTEMUS EUCALIPTO	\N	2026-03-08 22:37:18.789007+00	\N
1777	688	4	1235	\N	COCULUS GREEN	\N	2026-03-08 22:37:18.78981+00	301
1778	688	4	1236	\N	HEBES	\N	2026-03-08 22:37:18.790468+00	\N
1779	688	4	1237	\N	LEATHER LEAF	\N	2026-03-08 22:37:18.790981+00	\N
1780	688	4	1238	\N	PHOTINIA	\N	2026-03-08 22:37:18.791575+00	\N
1781	688	4	1239	\N	RUSCUS GREEN	\N	2026-03-08 22:37:18.792355+00	302
1782	1463	4	1240	\N	PK SNAPDRAGON RED	\N	2026-03-08 22:37:18.793177+00	303
1783	688	4	1241	\N	FIELD PENNYCRESS	\N	2026-03-08 22:37:18.793878+00	\N
1784	1037	4	1242	\N	NIGELLA ALL WHITE	\N	2026-03-08 22:37:18.794639+00	304
1785	688	4	1243	\N	MOLUCELLA	\N	2026-03-08 22:37:18.795232+00	\N
1786	688	4	1244	\N	RUMEX UNICORN	\N	2026-03-08 22:37:18.795781+00	\N
1787	864	4	1245	\N	HYPERICUM BURGUNDY	\N	2026-03-08 22:37:18.796606+00	305
1788	864	4	1246	\N	HYPERICUM WHITE	\N	2026-03-08 22:37:18.79753+00	306
1789	1789	4	1247	\N	LEPIDIUM WHITE	\N	2026-03-08 22:37:18.798431+00	307
1790	1789	4	1248	\N	PK LEPIDIUM GREEN	\N	2026-03-08 22:37:18.799236+00	308
1791	984	4	1249	\N	LIMONIUM CUMULO WHITE	\N	2026-03-08 22:37:18.800168+00	309
1792	984	4	1250	\N	LIMONIUM PIÑA COLADA	\N	2026-03-08 22:37:18.800894+00	\N
1793	984	4	1251	\N	LIMONIUM PINK POKERS	\N	2026-03-08 22:37:18.801714+00	310
1794	984	4	1252	\N	LIMONIUM SHOOTING STAR	\N	2026-03-08 22:37:18.802351+00	\N
1795	984	4	1253	\N	LIMONIUM SILVER PINK	\N	2026-03-08 22:37:18.803194+00	311
1796	1463	4	1254	\N	PK SNAPDRAGON MAGENTA	\N	2026-03-08 22:37:18.803811+00	\N
1797	1463	4	1255	\N	PK SNAPDRAGON ORANGE	\N	2026-03-08 22:37:18.804565+00	312
1798	1463	4	1256	\N	PK SNAPDRAGON WHITE	\N	2026-03-08 22:37:18.805401+00	313
1799	1463	4	1257	\N	SNAPDRAGON PINK	\N	2026-03-08 22:37:18.806234+00	314
1800	1463	4	1258	\N	SNAPDRAGON PURPLE	\N	2026-03-08 22:37:18.806955+00	315
1801	1463	4	1259	\N	SNAPDRAGON YELLOW	\N	2026-03-08 22:37:18.807913+00	316
1802	1594	4	1260	\N	STATICE PEACH	\N	2026-03-08 22:37:18.808724+00	317
1803	1594	4	1261	\N	STATICE SINZII CORAL	\N	2026-03-08 22:37:18.80952+00	318
1804	1594	4	1262	\N	STATICE SINZII LILAE	\N	2026-03-08 22:37:18.810143+00	\N
1805	1594	4	1263	\N	STATICE SINZII SILVER	\N	2026-03-08 22:37:18.810659+00	\N
1806	1594	4	1264	\N	STATICE SINZIL DEEP PURPLE	\N	2026-03-08 22:37:18.811489+00	319
1807	1602	4	1265	\N	STOCK CREAM	\N	2026-03-08 22:37:18.812353+00	320
1808	1602	4	1266	\N	STOCK HOT PINK	\N	2026-03-08 22:37:18.813364+00	321
1809	1602	4	1267	\N	STOCK LAVANDER	\N	2026-03-08 22:37:18.813969+00	\N
1810	1602	4	1268	\N	STOCK PEACH	\N	2026-03-08 22:37:18.814853+00	322
1811	1602	4	1269	\N	STOCK PURPLE	\N	2026-03-08 22:37:18.815635+00	323
1812	1602	4	1270	\N	STOCK WHITE	\N	2026-03-08 22:37:18.816434+00	324
1813	1602	4	1271	\N	STOCK YELLOW	\N	2026-03-08 22:37:18.817245+00	325
1814	1641	4	1272	\N	SPRAY SUNFLOWER	\N	2026-03-08 22:37:18.817909+00	\N
1815	1641	4	1273	\N	SUNFLOWER YELLOW	\N	2026-03-08 22:37:18.818646+00	326
1816	424	4	1274	\N	CRASPEDIA JUMBO	\N	2026-03-08 22:37:18.819399+00	\N
1817	892	4	1275	\N	LARKSPUR PINK	\N	2026-03-08 22:37:18.820467+00	327
1818	892	4	1276	\N	LARKSPUR PURPLE	\N	2026-03-08 22:37:18.821463+00	328
1819	892	4	1277	\N	LARKSPUR WHITE	\N	2026-03-08 22:37:18.82227+00	329
1820	1730	4	1278	\N	S VERONICA PURPLE	\N	2026-03-08 22:37:18.823092+00	330
1821	1730	4	1279	\N	S VERONICA WHITE	\N	2026-03-08 22:37:18.823889+00	331
1822	221	4	1280	\N	Y ASTRANTIA BURGUNDY	\N	2026-03-08 22:37:18.824698+00	332
1823	221	4	1281	\N	Y ASTRANTIA LIGHT PINK	\N	2026-03-08 22:37:18.82547+00	333
1824	221	4	1282	\N	Y ASTRANTIA PINK	\N	2026-03-08 22:37:18.826283+00	334
1825	221	4	1283	\N	Y ASTRANTIA WHITE	\N	2026-03-08 22:37:18.827137+00	335
1826	465	4	1284	\N	BLUE SPRAY DELPHINIUM	\N	2026-03-08 22:37:18.827765+00	\N
1827	465	4	1285	\N	DELPHINIUM BLACK NIGHT	\N	2026-03-08 22:37:18.828382+00	\N
1828	465	4	1286	\N	DELPHINIUM LIGHT BLUE	\N	2026-03-08 22:37:18.82909+00	336
1829	465	4	1287	\N	DELPHINIUM SEA WALTZ	\N	2026-03-08 22:37:18.829728+00	\N
1830	465	4	1288	\N	DELPHINIUM SKY WALTZ	\N	2026-03-08 22:37:18.830331+00	\N
1831	465	4	1289	\N	DELPHINIUM SOFT PURPLE	\N	2026-03-08 22:37:18.831119+00	337
1832	465	4	1290	\N	DELPHINIUM TRICK GRAPE	\N	2026-03-08 22:37:18.831903+00	\N
1833	465	4	1291	\N	DELPHINIUM TRICK LIGHT YELLOW	\N	2026-03-08 22:37:18.832771+00	338
1834	465	4	1292	\N	DELPHINIUM WHITE	\N	2026-03-08 22:37:18.833602+00	339
1835	465	4	1293	\N	DELPHINIUM WHITE & BLACK CENTER	\N	2026-03-08 22:37:18.834203+00	\N
1836	465	4	1294	\N	SPRAY DELPHINIUM BLUSH	\N	2026-03-08 22:37:18.834874+00	340
1837	465	4	1295	\N	SPRAY DELPHINIUM SUNSHINE BLUE	\N	2026-03-08 22:37:18.835634+00	341
1838	465	4	1296	\N	Y DELPHINIUM WHITE & BLACK	\N	2026-03-08 22:37:18.836296+00	\N
1839	1839	4	1297	\N	DUBIUM WHITE	\N	2026-03-08 22:37:18.837352+00	342
1840	350	4	1298	\N	CRISANTEMO LINETTE	\N	2026-03-08 22:37:18.837972+00	\N
1841	350	4	1299	\N	CRISANTEMO MARRAKESH	\N	2026-03-08 22:37:18.838532+00	\N
1842	350	4	1300	\N	CRISANTEMO ROSSETA	\N	2026-03-08 22:37:18.839187+00	\N
1843	350	4	1301	\N	CRISANTEMO WHITE	\N	2026-03-08 22:37:18.840407+00	343
1844	225	4	1302	\N	GYPSOPHILA	\N	2026-03-08 22:37:18.840915+00	\N
1845	465	4	1303	\N	DELPHINIUM LAVANDER	\N	2026-03-08 22:37:18.842126+00	\N
1846	537	4	1304	\N	DRIED PAMPAS	\N	2026-03-08 22:37:18.842695+00	\N
1847	576	4	1305	\N	FREESIA LAVENDER	\N	2026-03-08 22:37:18.843473+00	344
1848	576	4	1306	\N	FREESIA TROPICAL	\N	2026-03-08 22:37:18.84414+00	\N
1849	576	4	1307	\N	FREESIA WHITE	\N	2026-03-08 22:37:18.844923+00	345
1850	576	4	1308	\N	FREESIA YELLOW	\N	2026-03-08 22:37:18.845799+00	346
1851	1017	4	1309	\N	MARIGOLD ORANGE	\N	2026-03-08 22:37:18.846529+00	347
1852	1178	4	1310	\N	FLOWERING POPPY MIX	\N	2026-03-08 22:37:18.847204+00	\N
1853	1178	4	1311	\N	FLOWERING POPPY PEACH	\N	2026-03-08 22:37:18.848033+00	348
1854	1	4	1312	\N	TEDDYS	\N	2026-03-08 22:37:18.848638+00	\N
1855	1517	4	1313	\N	APRICOT SPRAY ROSE	\N	2026-03-08 22:37:18.849195+00	\N
1856	1517	4	1314	\N	BALI SPRAY ROSE	\N	2026-03-08 22:37:18.849728+00	\N
1857	1517	4	1315	\N	BE AMAZING SPRAY ROSE	\N	2026-03-08 22:37:18.850341+00	\N
1858	1517	4	1316	\N	BE GENTLE SPRAY ROSE	\N	2026-03-08 22:37:18.850835+00	\N
1859	1517	4	1317	\N	BE LOVING SPRAY ROSE	\N	2026-03-08 22:37:18.85137+00	\N
1860	1517	4	1318	\N	BE NICE SPRAY ROSE	\N	2026-03-08 22:37:18.852015+00	\N
1861	1517	4	1319	\N	BE TRUE SPRAY ROSE	\N	2026-03-08 22:37:18.852584+00	\N
1862	1517	4	1320	\N	BIG DIPPER SPRAY ROSE	\N	2026-03-08 22:37:18.853183+00	\N
1863	1517	4	1321	\N	CANDY SPRAY ROSE	\N	2026-03-08 22:37:18.853771+00	\N
1864	1517	4	1322	\N	CRETA SPRAY ROSE	\N	2026-03-08 22:37:18.854398+00	\N
1865	1517	4	1323	\N	ELVA SPRAY ROSE	\N	2026-03-08 22:37:18.855499+00	\N
1866	1517	4	1324	\N	FIRE UP SPRAY ROSE	\N	2026-03-08 22:37:18.856003+00	\N
1867	1517	4	1325	\N	FLOREANA SPRAY ROSE	\N	2026-03-08 22:37:18.857281+00	\N
1868	1517	4	1326	\N	LESBOS SPRAY ROSE	\N	2026-03-08 22:37:18.85777+00	\N
1869	1517	4	1327	\N	MAJOLICA SPRAY ROSE WHITE	\N	2026-03-08 22:37:18.858427+00	349
1870	1517	4	1328	\N	SAONA SPRAY ROSE	\N	2026-03-08 22:37:18.860247+00	\N
1871	1517	4	1329	\N	SHINNING STAR SPRAY ROSE	\N	2026-03-08 22:37:18.860733+00	\N
1872	1456	4	1330	\N	CAUCASIAN ESCABIOSA DEEP BLUE	\N	2026-03-08 22:37:18.861381+00	350
1873	1456	4	1331	\N	CAUCASIAN ESCABIOSA WHITE	\N	2026-03-08 22:37:18.862062+00	351
1874	1456	4	1332	\N	FOCAL SCOOP BANANA	\N	2026-03-08 22:37:18.862568+00	\N
1875	1456	4	1333	\N	FOCAL SCOOP BLACKBERRY	\N	2026-03-08 22:37:18.863051+00	\N
1876	1456	4	1334	\N	FOCAL SCOOP CRANBERRY	\N	2026-03-08 22:37:18.863644+00	\N
1877	1456	4	1335	\N	FOCAL SCOOP LAVANDER	\N	2026-03-08 22:37:18.864167+00	\N
1878	1456	4	1336	\N	FOCAL SCOOP MARASCHINO	\N	2026-03-08 22:37:18.86465+00	\N
1879	1456	4	1337	\N	FOCAL SCOOP RED APPLE	\N	2026-03-08 22:37:18.865363+00	352
1880	1456	4	1338	\N	FOCAL SCOOP STELLATA	\N	2026-03-08 22:37:18.865921+00	\N
1881	1456	4	1339	\N	FOCAL SCOOP TEABERRY	\N	2026-03-08 22:37:18.86641+00	\N
1882	1456	4	1340	\N	FOCAL SCOOP UBE	\N	2026-03-08 22:37:18.866878+00	\N
1883	1456	4	1341	\N	HOOP SCOOP STRAWBERRY	\N	2026-03-08 22:37:18.867314+00	\N
1884	1456	4	1342	\N	RASBERRY RIPPLE SCOOP	\N	2026-03-08 22:37:18.867758+00	\N
1885	1456	4	1343	\N	SCOOP BON BON VANILLA	\N	2026-03-08 22:37:18.868218+00	\N
1886	1517	4	1344	\N	SNOWFLAKE SPRAY ROSE WHITE	\N	2026-03-08 22:37:18.868888+00	353
1887	1659	4	1345	\N	SWEET PEA BLUSH	\N	2026-03-08 22:37:18.869537+00	354
1888	1659	4	1346	\N	SWEET PEA LAVENDER	\N	2026-03-08 22:37:18.870085+00	355
1889	1659	4	1347	\N	SWEET PEA WHITE	\N	2026-03-08 22:37:18.870593+00	356
1890	294	4	1348	\N	CAMPANULA PURPLE	\N	2026-03-08 22:37:18.871192+00	357
1891	294	4	1349	\N	CAMPANULA WHITE	\N	2026-03-08 22:37:18.872175+00	358
1892	1892	4	1350	\N	CAMPANULA PINK	\N	2026-03-08 22:37:18.87307+00	359
1893	1893	4	1351	\N	DIDISCUS WHITE	\N	2026-03-08 22:37:18.873851+00	360
1894	1	4	1352	\N	FATIMA GARDEN	\N	2026-03-08 22:37:18.874476+00	\N
1895	1	4	1353	\N	ALY	\N	2026-03-08 22:37:18.875009+00	\N
1896	1	4	1354	\N	ANDREA	\N	2026-03-08 22:37:18.875664+00	\N
1897	1	4	1355	\N	ART DECO	\N	2026-03-08 22:37:18.876196+00	\N
1898	1	4	93	\N	BARISTA	\N	2026-03-08 22:37:18.876498+00	\N
1899	1	4	1357	\N	BIT MORE	\N	2026-03-08 22:37:18.87707+00	\N
1900	1	4	1358	\N	BLIZZARD	\N	2026-03-08 22:37:18.87767+00	\N
1901	1	4	1359	\N	BLUE BERRY	\N	2026-03-08 22:37:18.878623+00	361
1902	1	4	1360	\N	BROMO	\N	2026-03-08 22:37:18.879685+00	\N
1903	1	4	8	\N	CANDLELIGHT	\N	2026-03-08 22:37:18.880071+00	\N
1904	1	4	1362	\N	EXPLORER	\N	2026-03-08 22:37:18.880578+00	\N
1905	1	4	1363	\N	FAIR LADY	\N	2026-03-08 22:37:18.881209+00	\N
1906	1	4	55	\N	FREE SPIRIT	\N	2026-03-08 22:37:18.881677+00	\N
1907	1	4	2	\N	FREEDOM	\N	2026-03-08 22:37:18.882118+00	\N
1908	1	4	1366	\N	GOVINDA	\N	2026-03-08 22:37:18.882729+00	\N
1909	1	4	3	\N	HEARTS	\N	2026-03-08 22:37:18.883122+00	\N
1910	1	4	1368	\N	HOT SPOT	\N	2026-03-08 22:37:18.883637+00	\N
1911	1	4	1369	\N	IDILIA	\N	2026-03-08 22:37:18.884202+00	\N
1912	1	4	1370	\N	JALAH	\N	2026-03-08 22:37:18.884758+00	\N
1913	1	4	59	\N	KAHALA	\N	2026-03-08 22:37:18.885117+00	\N
1914	1	4	1372	\N	MERLOT	\N	2026-03-08 22:37:18.88562+00	\N
1915	1	4	10	\N	MONDIAL	\N	2026-03-08 22:37:18.885909+00	\N
1916	1	4	1374	\N	NENA	\N	2026-03-08 22:37:18.886427+00	\N
1917	1	4	53	\N	NINA	\N	2026-03-08 22:37:18.887004+00	\N
1918	1	4	88	\N	OCEAN SONG	\N	2026-03-08 22:37:18.887411+00	\N
1919	1	4	54	\N	ORANGE CRUSH	\N	2026-03-08 22:37:18.887916+00	54
1920	1	4	60	\N	PHOENIX	\N	2026-03-08 22:37:18.888375+00	\N
1921	1	4	46	\N	PINK FLOYD	\N	2026-03-08 22:37:18.888944+00	363
1922	1	4	31	\N	PINK MONDIAL	\N	2026-03-08 22:37:18.889521+00	364
1923	1	4	1381	\N	PINK PORCELAIN	\N	2026-03-08 22:37:18.890174+00	365
1924	1	4	1382	\N	POMA ROSA	\N	2026-03-08 22:37:18.890635+00	\N
1925	1	4	1383	\N	POMPEI	\N	2026-03-08 22:37:18.891+00	\N
1926	1	4	67	\N	QUICKSAND	\N	2026-03-08 22:37:18.891242+00	\N
1927	1	4	1385	\N	RAZZMATAZZ	\N	2026-03-08 22:37:18.891574+00	\N
1928	1	4	1386	\N	RHOSLYN	\N	2026-03-08 22:37:18.891909+00	\N
1929	1	4	1387	\N	ROYAL EXPLORER	\N	2026-03-08 22:37:18.892299+00	\N
1930	1	4	1388	\N	SAHARA	\N	2026-03-08 22:37:18.892752+00	\N
1931	1	4	63	\N	SHIMMER	\N	2026-03-08 22:37:18.893115+00	\N
1932	1	4	1390	\N	SHINE ON	\N	2026-03-08 22:37:18.893604+00	\N
1933	1	4	1391	\N	SHOCKING BLUE	\N	2026-03-08 22:37:18.894306+00	366
1934	1	4	1392	\N	SOUTH PARK	\N	2026-03-08 22:37:18.894912+00	\N
1935	1	4	1393	\N	SPRIT	\N	2026-03-08 22:37:18.895562+00	\N
1936	1	4	1394	\N	SUSPIRO	\N	2026-03-08 22:37:18.896176+00	\N
1937	1	4	1395	\N	SYMBOL	\N	2026-03-08 22:37:18.896754+00	\N
1938	1	4	1396	\N	TIARA	\N	2026-03-08 22:37:18.897333+00	\N
1939	1	4	18	\N	TIBET	\N	2026-03-08 22:37:18.897741+00	\N
1940	1	4	1398	\N	TIE DYE	\N	2026-03-08 22:37:18.898516+00	\N
1941	1	4	1399	\N	TINTED MON	\N	2026-03-08 22:37:18.899179+00	\N
1942	1	4	1400	\N	TIP TOP	\N	2026-03-08 22:37:18.899705+00	\N
1943	1	4	1401	\N	TYCOON	\N	2026-03-08 22:37:18.900304+00	\N
1944	1	4	19	\N	VENDELA	\N	2026-03-08 22:37:18.90072+00	\N
1945	1	4	1403	\N	YOGA	\N	2026-03-08 22:37:18.901237+00	\N
1946	1	4	1404	\N	YURAQ	\N	2026-03-08 22:37:18.901805+00	\N
1947	1726	4	1405	\N	TWEEDIA SKY BLUE	\N	2026-03-08 22:37:18.90252+00	367
1948	1726	4	1406	\N	TWEEDIA WHITE	\N	2026-03-08 22:37:18.903311+00	368
1949	173	4	1407	\N	ANEMONE LEVANTE BLUE	\N	2026-03-08 22:37:18.904063+00	369
1950	465	4	1408	\N	DELPHINIUM BLUE BIRD	\N	2026-03-08 22:37:18.904761+00	370
1951	173	4	1409	\N	ANEMONE MISTRAL BLUE	\N	2026-03-08 22:37:18.905555+00	371
1952	173	4	1410	\N	ANEMONE MISTRAL SOFT PURPLE	\N	2026-03-08 22:37:18.906297+00	372
1953	1200	4	1411	\N	AMANDINE PICOTTE	\N	2026-03-08 22:37:18.906866+00	\N
1954	1200	4	1412	\N	ELEGANCE BURGUNDY	\N	2026-03-08 22:37:18.90763+00	373
1955	1200	4	1413	\N	ELEGANCE CIOCOLATO	\N	2026-03-08 22:37:18.908197+00	\N
1956	1200	4	1414	\N	ELEGANCE VIOLET	\N	2026-03-08 22:37:18.908673+00	\N
1957	1957	4	1415	\N	LIMONIUM PAINTED GOLD	\N	2026-03-08 22:37:18.909499+00	374
1958	1957	4	1416	\N	LIMONIUM TINTED CINNAMON BROWN	\N	2026-03-08 22:37:18.910299+00	375
1959	164	4	1417	\N	AMARANTHUS CORAL FOURTAIN	\N	2026-03-08 22:37:18.910961+00	376
1960	164	4	1418	\N	AMARANTHUS GREEN TAILS	\N	2026-03-08 22:37:18.911511+00	377
1961	164	4	1419	\N	AMARANTHUS HOT BISCUITS	\N	2026-03-08 22:37:18.911891+00	\N
1962	164	4	1420	\N	AMARANTHUS PONYTAILS RED	\N	2026-03-08 22:37:18.912643+00	378
1963	164	4	1421	\N	AMARANTHUS VELVET CURTAINS	\N	2026-03-08 22:37:18.913229+00	\N
1964	1964	4	1422	\N	ANEMONE MISTRAL WHITE	\N	2026-03-08 22:37:18.914008+00	379
1965	1965	4	1423	\N	GYPSOPHILA ORANGE	\N	2026-03-08 22:37:18.914733+00	380
1966	1965	4	1424	\N	GYPSOPHILA RASPBERRY TINTED	\N	2026-03-08 22:37:18.91531+00	\N
1967	1965	4	1425	\N	GYPSOPHILA TERRACOTA XCLENCE	\N	2026-03-08 22:37:18.91594+00	\N
1968	1965	4	1426	\N	GYPSOPHILA TINTED CAFE AULAIT	\N	2026-03-08 22:37:18.916592+00	\N
1969	1200	4	1427	\N	PON PON DRAGONFRUIT	\N	2026-03-08 22:37:18.917319+00	\N
1970	1200	4	1428	\N	PON PON IGLOO	\N	2026-03-08 22:37:18.917914+00	\N
1971	1200	4	1429	\N	PON PON LUNA	\N	2026-03-08 22:37:18.918481+00	\N
1972	1200	4	1430	\N	PON PON MALVA	\N	2026-03-08 22:37:18.919011+00	\N
1973	1200	4	1431	\N	PON PON MERLINO	\N	2026-03-08 22:37:18.919601+00	\N
1974	1	4	1432	\N	MAYRA'S PEACH	\N	2026-03-08 22:37:18.920302+00	381
1975	1	4	1433	\N	RED MONSTER	\N	2026-03-08 22:37:18.921052+00	382
1976	1	4	1434	\N	SCARLATA	\N	2026-03-08 22:37:18.921637+00	\N
1977	1	4	1435	\N	SUNDAY MORNING	\N	2026-03-08 22:37:18.922179+00	\N
1978	4	4	1436	\N	ANTONIA GARDENS	\N	2026-03-08 22:37:18.922731+00	\N
1979	4	4	1437	\N	AURORA GARDEN	\N	2026-03-08 22:37:18.923412+00	\N
1980	4	4	1438	\N	BRUJAS	\N	2026-03-08 22:37:18.924188+00	\N
1981	4	4	1439	\N	CANDY EXPRESSION	\N	2026-03-08 22:37:18.924865+00	\N
1982	4	4	1440	\N	DRAGON FLY	\N	2026-03-08 22:37:18.925432+00	\N
1983	4	4	1441	\N	GARDEN SPIRIT	\N	2026-03-08 22:37:18.925936+00	\N
1984	4	4	1442	\N	HOT PINK MAYRA	\N	2026-03-08 22:37:18.926476+00	383
1985	4	4	1443	\N	OHARA	\N	2026-03-08 22:37:18.92689+00	\N
1986	4	4	1444	\N	PINK EXPRESSION	\N	2026-03-08 22:37:18.927634+00	384
1987	4	4	1445	\N	PLAYA BLANCA	\N	2026-03-08 22:37:18.928254+00	\N
1988	4	4	1446	\N	QUEEN MAYRA	\N	2026-03-08 22:37:18.928955+00	\N
1989	4	4	1447	\N	RED MAYRA	\N	2026-03-08 22:37:18.929802+00	385
1990	4	4	1448	\N	SIENTE	\N	2026-03-08 22:37:18.930476+00	\N
1991	4	4	1449	\N	WHITE MAYRA	\N	2026-03-08 22:37:18.931222+00	386
1992	244	4	1450	\N	MARIPOSA MAGICAL STRAWBERRY	\N	2026-03-08 22:37:18.93187+00	\N
1993	244	4	1451	\N	MARIPOSA MAGICAL YELLOW	\N	2026-03-08 22:37:18.93263+00	387
1994	244	4	1452	\N	BUTTERFLY ERIS CL	\N	2026-03-08 22:37:18.933227+00	\N
1995	244	4	1453	\N	BUTTERFLY GRACE W	\N	2026-03-08 22:37:18.933765+00	\N
1996	244	4	1454	\N	BUTTERFLY HADES R	\N	2026-03-08 22:37:18.934241+00	\N
1997	244	4	1455	\N	BUTTERFLY HELIOS - LY	\N	2026-03-08 22:37:18.934803+00	\N
1998	244	4	1456	\N	BUTTERFLY HERA P	\N	2026-03-08 22:37:18.93538+00	\N
1999	244	4	1457	\N	BUTTERFLY LYCIA LV	\N	2026-03-08 22:37:18.935933+00	\N
2000	244	4	1458	\N	BUTTERFLY MINOAN O	\N	2026-03-08 22:37:18.936592+00	\N
2001	244	4	1459	\N	BUTTERFLY MUSA CL	\N	2026-03-08 22:37:18.937208+00	\N
2002	244	4	1460	\N	BUTTERFLY PHYTALOS Y	\N	2026-03-08 22:37:18.937785+00	\N
2003	244	4	1461	\N	MARIPOSA MAGICAL CARAMEL	\N	2026-03-08 22:37:18.938331+00	\N
2004	244	4	1462	\N	MARIPOSA MAGICAL CHOCOLATE	\N	2026-03-08 22:37:18.938922+00	\N
2005	244	4	1463	\N	MARIPOSA MAGICAL CINNAMON	\N	2026-03-08 22:37:18.93946+00	\N
2006	244	4	1464	\N	MARIPOSA MAGICAL RASPBERRY	\N	2026-03-08 22:37:18.940018+00	\N
2007	244	4	1465	\N	NATURA MODERNA DOLCE	\N	2026-03-08 22:37:18.940497+00	\N
2008	244	4	1466	\N	NATURA MODERNA MIELLE	\N	2026-03-08 22:37:18.940847+00	\N
2009	1200	4	1467	\N	SUCCESS WHITE	\N	2026-03-08 22:37:18.941329+00	388
2010	2010	4	1468	\N	BUTTERFLY ARIADNE LP	\N	2026-03-08 22:37:18.941785+00	\N
2011	2010	4	1469	\N	MARIPOSA MAGICAL MASCARPONE	\N	2026-03-08 22:37:18.942251+00	\N
2012	2012	4	1470	\N	SUCCESS CLONI FAVOLA	\N	2026-03-08 22:37:18.942874+00	\N
2013	2012	4	1471	\N	SUCCESS CLONI LADY PINK	\N	2026-03-08 22:37:18.943565+00	389
2014	2012	4	1472	\N	SUCCESS CLONI NEBBIA	\N	2026-03-08 22:37:18.94423+00	\N
2015	2012	4	1473	\N	SUCCESS HANOI	\N	2026-03-08 22:37:18.944853+00	\N
2016	2016	4	1474	\N	SMILAX GARLAND	\N	2026-03-08 22:37:18.945464+00	\N
2017	164	3	1475	\N	AMARANTHUS HANGING GREEN 60CM. 5ST. QB/EB	\N	2026-03-08 22:37:18.946167+00	390
2018	164	3	1475	\N	AMARANTHUS HANGING RED 60CM. 5ST. QB/EB	\N	2026-03-08 22:37:18.946767+00	391
2019	182	3	1477	\N	ANTHURIUM ACROPOLIS WHITE LARGE 50CM. 1ST. QB/EBC	\N	2026-03-08 22:37:18.947528+00	392
2020	182	3	1477	\N	ANTHURIUM ACROPOLIS WHITE MEDIUM 50CM. 1ST. QB/EBC	\N	2026-03-08 22:37:18.948071+00	392
2021	182	3	1477	\N	ANTHURIUM ACROPOLIS WHITE XL 50CM. 1ST. QB/EBC	\N	2026-03-08 22:37:18.948633+00	392
2022	182	3	1477	\N	ANTHURIUM ACROPOLIS WHITE XXL 50CM. 1ST. QB/EBC	\N	2026-03-08 22:37:18.94912+00	392
2023	182	3	1481	\N	ANTHURIUM CHEERS PINK MEDIUM 50CM. 1ST. QB/EBC	\N	2026-03-08 22:37:18.949812+00	396
2024	182	3	1482	\N	ANTHURIUM CHOCO BROWN LARGE 50CM. 1ST. QB/EBC	\N	2026-03-08 22:37:18.950621+00	397
2025	182	3	1482	\N	ANTHURIUM CHOCO BROWN MEDIUM 50CM. 1ST. QB/EBC	\N	2026-03-08 22:37:18.95124+00	397
2026	182	3	1484	\N	ANTHURIUM HOT PINK LARGE 50CM. 1ST. QB/EBC	\N	2026-03-08 22:37:18.951917+00	383
2027	182	3	1485	\N	ANTHURIUM PISTACHE GREEN LARGE 50CM. 1ST. QB/EBC	\N	2026-03-08 22:37:18.952694+00	400
2028	182	3	1485	\N	ANTHURIUM PISTACHE GREEN XL 50CM. 1ST. QB/EBC	\N	2026-03-08 22:37:18.953403+00	400
2029	182	3	1487	\N	ANTHURIUM ROSA PINK XL 50CM. 1ST. QB/EBC	\N	2026-03-08 22:37:18.95406+00	402
2030	182	3	1487	\N	ANTHURIUM ROSA PINK XXL 50CM. 1ST. QB/EBC	\N	2026-03-08 22:37:18.954583+00	402
2031	182	3	1489	\N	ANTHURIUM SANTE PINK MEDIUM 50CM. 1ST. QB/EBC	\N	2026-03-08 22:37:18.955292+00	404
2032	182	3	1490	\N	ANTHURIUM TROPICAL RED MEDIUM 50CM. 1ST. QB/EBC	\N	2026-03-08 22:37:18.956073+00	405
2033	2033	3	1491	\N	ASPIDISTRA LEAF 50CM. 10ST.	\N	2026-03-08 22:37:18.95671+00	\N
2034	2034	3	1492	\N	PALM CAT MEDIUM 65CM. 10ST. HB/QB/EBC	\N	2026-03-08 22:37:18.957291+00	\N
2035	2034	3	1493	\N	PALM CAT SMALL 50CM. 10ST.	\N	2026-03-08 22:37:18.957824+00	\N
2036	2034	3	1493	\N	PALM CAT SMALL 50CM. 10ST. HB/QB/EB	\N	2026-03-08 22:37:18.958119+00	\N
2037	2037	3	1495	\N	CORDELYNE LEAF FUCSIA 50CM. 10ST. HB/QB/EB (NC)	\N	2026-03-08 22:37:18.958875+00	\N
2038	2038	3	1496	\N	MONSTERA GREEN LARGE 90CM. 5ST. HB/QB (NC)	\N	2026-03-08 22:37:18.959542+00	\N
2039	2038	3	1497	\N	MONSTERA GREEN MEDIUM 70CM.	\N	2026-03-08 22:37:18.960134+00	\N
2040	2038	3	1498	\N	MONSTERA GREEN PETITE 30CM.	\N	2026-03-08 22:37:18.960686+00	\N
2041	2038	3	1499	\N	MONSTERA GREEN SMALL 50CM. 5ST. HB/QB/EB (NC)	\N	2026-03-08 22:37:18.961241+00	\N
2042	2042	3	1500	\N	DAVALIA 60CM. 10ST. HB/QB/EBC (SC)	\N	2026-03-08 22:37:18.961915+00	\N
2043	2043	3	1501	\N	MASAJEANA VARIEGATED 60CM. 10ST. HB/QB/EB (NC)	\N	2026-03-08 22:37:18.962553+00	\N
2044	677	3	1502	\N	GINGER RED MEDIUM 13CM. 75CM. 5ST. HB/QB/EBC	\N	2026-03-08 22:37:18.963309+00	\N
2045	2045	3	1503	\N	FOLIATE 50CM. 5ST. HB/QB/EB (SC)	\N	2026-03-08 22:37:18.964112+00	\N
2046	2045	3	1504	\N	HELECHO MACHO 50CM. 10ST. HB/QB/EBC (SC)	\N	2026-03-08 22:37:18.964771+00	\N
2047	794	3	1505	\N	HEL. OPAL RED 70CM. 5ST. HB/QB/EB	\N	2026-03-08 22:37:18.965665+00	406
2048	2048	3	1506	\N	MUSA LEAF LARGE 90CM. 5ST. HB/QB (NC)	\N	2026-03-08 22:37:18.966343+00	\N
2049	2049	3	1507	\N	PALM RAPHIS 50CM. 5ST. HB/QB/EB (SC)	\N	2026-03-08 22:37:18.966987+00	\N
2050	2050	3	1508	\N	PHI. XANADU 40CM.10ST. HB/QB/EB/GB-M (NC)	\N	2026-03-08 22:37:18.967607+00	\N
2051	2050	3	1509	\N	PHI. XANTAL 60CM. 10ST. HB/QB/EB (NC)	\N	2026-03-08 22:37:18.968206+00	\N
2052	2052	3	1510	\N	PODOCARPUS FRESH 50CM. 5ST. HB/QB/EBC (SC)	\N	2026-03-08 22:37:18.968793+00	\N
2053	2053	3	1511	\N	SCHEFFLERA TIP GREEN 45CM. 5ST. HB/QB (NC)	\N	2026-03-08 22:37:18.969695+00	407
2054	677	3	1512	\N	Ginger Nicole Pink	\N	2026-03-08 22:37:18.970656+00	408
2055	677	3	1513	\N	Ginger Plus Red	\N	2026-03-08 22:37:18.971442+00	409
2056	677	3	1514	\N	Torch Ginger Red	\N	2026-03-08 22:37:18.972181+00	410
2057	677	3	1515	\N	Torch Ginger Pink	\N	2026-03-08 22:37:18.97289+00	411
2058	677	3	1516	\N	Ginger Red Large	\N	2026-03-08 22:37:18.973443+00	\N
2059	677	3	1517	\N	Ginger Red Medium	\N	2026-03-08 22:37:18.973808+00	\N
2060	677	3	1518	\N	Ginger Red Small	\N	2026-03-08 22:37:18.974159+00	\N
2061	677	3	1519	\N	Ginger Red Petite	\N	2026-03-08 22:37:18.974496+00	\N
2062	677	3	1520	\N	Ginger Pink Large	\N	2026-03-08 22:37:18.974934+00	\N
2063	677	3	1521	\N	Ginger Pink Medium	\N	2026-03-08 22:37:18.975538+00	\N
2064	677	3	1522	\N	Ginger White Large	\N	2026-03-08 22:37:18.97607+00	\N
2065	677	3	1523	\N	Ginger White Medium	\N	2026-03-08 22:37:18.976605+00	\N
2066	677	3	1524	\N	Ginger White Small	\N	2026-03-08 22:37:18.977127+00	\N
2067	677	3	1525	\N	Ginger White Petite with leaves	\N	2026-03-08 22:37:18.977698+00	\N
2068	2068	3	1526	\N	Shampoo Ginger Yellow	\N	2026-03-08 22:37:18.978595+00	412
2069	2068	3	1527	\N	Shampoo Ginger Red	\N	2026-03-08 22:37:18.979658+00	413
2070	2068	3	1528	\N	Shampoo Ginger Peach	\N	2026-03-08 22:37:18.980646+00	414
2071	2068	3	1529	\N	Shampoo Ginger Pink	\N	2026-03-08 22:37:18.981361+00	415
2072	2068	3	1530	\N	Shampoo Ginger Green	\N	2026-03-08 22:37:18.982089+00	416
2073	2068	3	1531	\N	Shampoo Ginger Brown	\N	2026-03-08 22:37:18.982812+00	417
2074	2068	3	1532	\N	Shampoo Ginger XL Bicolor	\N	2026-03-08 22:37:18.983367+00	\N
2075	2068	3	1533	\N	Shampoo Ginger XL Yellow	\N	2026-03-08 22:37:18.984088+00	418
2076	2068	3	1534	\N	Shampoo Ginger XL Red	\N	2026-03-08 22:37:18.984776+00	419
2077	2068	3	1535	\N	Shampoo Ginger XL Peach	\N	2026-03-08 22:37:18.985471+00	420
2078	2068	3	1536	\N	Shampoo Ginger XL Brown	\N	2026-03-08 22:37:18.98622+00	421
2079	2068	3	1537	\N	Shampoo Ginger White	\N	2026-03-08 22:37:18.987351+00	422
2080	794	3	1538	\N	Hel. Prince of Darkness Large	\N	2026-03-08 22:37:18.988075+00	\N
2081	794	3	1539	\N	Hel. Caribaea Red Large	\N	2026-03-08 22:37:18.988818+00	423
2082	794	3	1540	\N	Hel. Terracota XL	\N	2026-03-08 22:37:18.989436+00	\N
2083	794	3	1541	\N	Hel. Terracota Large	\N	2026-03-08 22:37:18.990044+00	\N
2084	794	3	1542	\N	Hel. Rauliana Large XL	\N	2026-03-08 22:37:18.990537+00	\N
2085	794	3	1543	\N	Hel. Rauliana Large	\N	2026-03-08 22:37:18.990904+00	\N
2086	794	3	1544	\N	Hel. Iris red Xlarge	\N	2026-03-08 22:37:18.991429+00	424
2087	794	3	1545	\N	Hel. Iris red - big blooms 5-6 bracteas	\N	2026-03-08 22:37:18.991816+00	\N
2088	794	3	1546	\N	Hel. Iris red Large	\N	2026-03-08 22:37:18.992497+00	425
2089	794	3	1547	\N	Hel. Iris red Medium	\N	2026-03-08 22:37:18.993397+00	426
2090	794	3	1548	\N	Hel. Wagneriana Yellow XL	\N	2026-03-08 22:37:18.994233+00	427
2091	794	3	1549	\N	Hel. Wagneriana Yellow Large	\N	2026-03-08 22:37:18.995035+00	428
2092	794	3	1550	\N	Hel. Wagneriana Yellow Medium	\N	2026-03-08 22:37:18.995843+00	429
2093	794	3	1551	\N	Hel. Flamingo XL	\N	2026-03-08 22:37:18.996551+00	\N
2094	794	3	1552	\N	Hel. Flamingo Large	\N	2026-03-08 22:37:18.997217+00	\N
2095	794	3	1553	\N	Hel. Flamingo Medium	\N	2026-03-08 22:37:18.997909+00	\N
2096	794	3	1554	\N	Hel. Wagneriana Red XL	\N	2026-03-08 22:37:18.99883+00	430
2097	794	3	1555	\N	Hel. Wagneriana Red Large	\N	2026-03-08 22:37:18.999796+00	431
2098	794	3	1556	\N	Hel. Wagneriana Red Medium	\N	2026-03-08 22:37:19.00072+00	432
2099	794	3	1557	\N	Hel. Nativa XL	\N	2026-03-08 22:37:19.001393+00	\N
2100	794	3	1558	\N	Hel. Nativa Large	\N	2026-03-08 22:37:19.002013+00	\N
2101	794	3	1559	\N	Hel. Nativa Medium	\N	2026-03-08 22:37:19.002628+00	\N
2102	794	3	1560	\N	Hel. Sunshine Large	\N	2026-03-08 22:37:19.003251+00	\N
2103	794	3	1561	\N	Hel. Sunshine Medium	\N	2026-03-08 22:37:19.004054+00	\N
2104	794	3	1562	\N	Hel. Peach Pink Large	\N	2026-03-08 22:37:19.004836+00	433
2105	794	3	1563	\N	Hel. Peach Pink Medium	\N	2026-03-08 22:37:19.005784+00	434
2106	794	3	1564	\N	Hel. Bihai Yellow Large	\N	2026-03-08 22:37:19.006784+00	435
2107	794	3	1565	\N	Hel. Bihai Yellow Medium	\N	2026-03-08 22:37:19.007704+00	436
2108	794	3	1566	\N	Hel. Escarlata Large	\N	2026-03-08 22:37:19.008339+00	\N
2109	794	3	1567	\N	Hel. Escarlata Medium	\N	2026-03-08 22:37:19.008952+00	\N
2110	794	3	1568	\N	Hel. Esmeralda Large	\N	2026-03-08 22:37:19.009539+00	\N
2111	794	3	1569	\N	Hel. Esmeralda Medium	\N	2026-03-08 22:37:19.010126+00	\N
2112	2112	3	1570	\N	Hel. She Kong XL	\N	2026-03-08 22:37:19.010839+00	\N
2113	2112	3	1571	\N	Hel. She Kong Large	\N	2026-03-08 22:37:19.011625+00	\N
2114	2112	3	1572	\N	Hel. Bloody Mary Large	\N	2026-03-08 22:37:19.012462+00	\N
2115	2112	3	1573	\N	Hel. Sexy Scarlet Large	\N	2026-03-08 22:37:19.013153+00	\N
2116	2112	3	1574	\N	Hel. Sexy Scarlet Blue Large	\N	2026-03-08 22:37:19.013675+00	437
2117	2112	3	1575	\N	Hel. Sexy Orange Large	\N	2026-03-08 22:37:19.014297+00	438
2118	2112	3	1576	\N	Hel. Rostrata Xlarge	\N	2026-03-08 22:37:19.014686+00	\N
2119	2112	3	1577	\N	Hel. Rostrata Large	\N	2026-03-08 22:37:19.015037+00	\N
2120	2112	3	1578	\N	Hel. Rostrata Medium	\N	2026-03-08 22:37:19.015632+00	\N
2121	2112	3	1579	\N	Hel. Rostrata Small	\N	2026-03-08 22:37:19.016219+00	\N
2122	2122	3	1580	\N	Bird of Paradise	\N	2026-03-08 22:37:19.016911+00	\N
2123	2122	3	1581	\N	Strilitzia White	\N	2026-03-08 22:37:19.017718+00	439
2124	2124	3	1582	\N	Hel. Golden Fire Opal	\N	2026-03-08 22:37:19.018451+00	\N
2125	2124	3	1583	\N	Hel. Golden Opal Red	\N	2026-03-08 22:37:19.019285+00	440
2126	2124	3	1584	\N	Hel. Golden Orange	\N	2026-03-08 22:37:19.020287+00	441
2127	2124	3	1585	\N	Hel. Sassy with or without leaves	\N	2026-03-08 22:37:19.021041+00	\N
2128	2124	3	1586	\N	Hel. Golden Opal	\N	2026-03-08 22:37:19.02181+00	\N
2129	2124	3	1587	\N	Hel. Latispatha	\N	2026-03-08 22:37:19.022456+00	\N
2130	2130	3	1588	\N	Musa Royal	\N	2026-03-08 22:37:19.023159+00	\N
2131	2130	3	1589	\N	Musa Reina	\N	2026-03-08 22:37:19.023793+00	\N
2132	2130	3	1590	\N	Musa Mouve	\N	2026-03-08 22:37:19.024438+00	\N
2133	2130	3	1591	\N	Musa Linda	\N	2026-03-08 22:37:19.025047+00	\N
2134	2130	3	1592	\N	Musa Orange	\N	2026-03-08 22:37:19.025648+00	\N
2135	2130	3	1593	\N	Musa Pacari	\N	2026-03-08 22:37:19.0263+00	\N
2136	2130	3	1594	\N	Musa White	\N	2026-03-08 22:37:19.026868+00	\N
2137	2130	3	1595	\N	Musa without antena	\N	2026-03-08 22:37:19.027632+00	\N
2138	2130	3	1596	\N	Musa Coccinea	\N	2026-03-08 22:37:19.02843+00	\N
2139	2130	3	1597	\N	Gran Musa Green XXL	\N	2026-03-08 22:37:19.02937+00	442
2140	2130	3	1598	\N	Gran Musa Green XL	\N	2026-03-08 22:37:19.030243+00	443
2141	2130	3	1599	\N	Gran Musa Green Large	\N	2026-03-08 22:37:19.031046+00	444
2142	2130	3	1600	\N	Baby Banana Green Large	\N	2026-03-08 22:37:19.031955+00	445
2143	2130	3	1601	\N	Baby Banana Green Medium	\N	2026-03-08 22:37:19.032698+00	446
2144	2130	3	1602	\N	Baby Banana Green Small	\N	2026-03-08 22:37:19.033613+00	447
2145	2130	3	1603	\N	Baby Banana Red Large	\N	2026-03-08 22:37:19.034433+00	448
2146	2130	3	1604	\N	Banana Prayer hand Large	\N	2026-03-08 22:37:19.035148+00	\N
2147	2130	3	1605	\N	Banana Prayer hand Medium	\N	2026-03-08 22:37:19.035744+00	\N
2148	2148	3	1606	\N	Black Tulip	\N	2026-03-08 22:37:19.03645+00	\N
2149	2148	3	1607	\N	Eucalyptus fresh doll cluster	\N	2026-03-08 22:37:19.037143+00	\N
2150	2148	3	1608	\N	Eucalyptus fresh doll stem	\N	2026-03-08 22:37:19.037911+00	\N
2151	2148	3	1609	\N	Eucalyptus fresh pot cluster	\N	2026-03-08 22:37:19.038488+00	\N
2152	2148	3	1610	\N	Eucalyptus fresh pot stem	\N	2026-03-08 22:37:19.038874+00	\N
2153	2148	3	1611	\N	Eucalyptus fresh doll cluster Red	\N	2026-03-08 22:37:19.039349+00	449
2154	2148	3	1612	\N	Eucalyptus fresh pot cluster Red	\N	2026-03-08 22:37:19.039843+00	450
2155	2148	3	1613	\N	Banana Fingers black	\N	2026-03-08 22:37:19.040328+00	\N
2156	2148	3	1614	\N	Banana Fingers green	\N	2026-03-08 22:37:19.041117+00	451
2157	2148	3	1615	\N	Banana Fingers green pick	\N	2026-03-08 22:37:19.041903+00	452
2158	2148	3	1616	\N	Night Torch	\N	2026-03-08 22:37:19.042502+00	\N
2159	2148	3	1617	\N	Cacao pods decorative	\N	2026-03-08 22:37:19.04313+00	\N
2160	2148	3	1618	\N	Black Kiss	\N	2026-03-08 22:37:19.04366+00	\N
2161	2148	3	1619	\N	Costus Barbatus	\N	2026-03-08 22:37:19.044205+00	\N
2162	2148	3	1620	\N	French Kiss	\N	2026-03-08 22:37:19.044703+00	\N
2163	2148	3	1621	\N	Anana Torch	\N	2026-03-08 22:37:19.045121+00	\N
2164	2148	3	1622	\N	Anana Lucidus	\N	2026-03-08 22:37:19.045725+00	\N
2165	2148	3	1623	\N	Anana Lucidus with Leaves	\N	2026-03-08 22:37:19.046346+00	\N
2166	2148	3	1624	\N	Calathea Yellow	\N	2026-03-08 22:37:19.047213+00	453
2167	2148	3	1625	\N	Calathea Brown with leaves	\N	2026-03-08 22:37:19.047889+00	\N
2168	2148	3	1626	\N	Calathea green ice	\N	2026-03-08 22:37:19.048825+00	454
2169	2148	3	1627	\N	Caryota Fresh L	\N	2026-03-08 22:37:19.049505+00	\N
2170	2148	3	1628	\N	Caryota Fresh M	\N	2026-03-08 22:37:19.050074+00	\N
2171	2148	3	1629	\N	Caryota Fresh S	\N	2026-03-08 22:37:19.050681+00	\N
2172	2148	3	1630	\N	Giant Green Large (not USA)	\N	2026-03-08 22:37:19.051272+00	\N
2173	2148	3	1631	\N	Giant Green Medium (not USA)	\N	2026-03-08 22:37:19.051701+00	\N
2174	2148	3	1632	\N	Asclepia 5 to 7 balls	\N	2026-03-08 22:37:19.052167+00	\N
2175	2148	3	1633	\N	Asclepia 3 to 5 balls	\N	2026-03-08 22:37:19.052813+00	\N
2176	2148	3	1634	\N	Asclepia 1 to 2 balls	\N	2026-03-08 22:37:19.053431+00	\N
2177	2148	3	1635	\N	Chili Fat Green Stem	\N	2026-03-08 22:37:19.054256+00	455
2178	2148	3	1636	\N	Hibiscus Sabdariffa	\N	2026-03-08 22:37:19.054894+00	\N
2179	2148	3	1637	\N	Kangaroo Paw	\N	2026-03-08 22:37:19.055534+00	\N
2180	2180	3	1638	\N	Anthurium Red XLarge	\N	2026-03-08 22:37:19.056316+00	456
2181	2181	3	1639	\N	Anthurium Red Large	\N	2026-03-08 22:37:19.057034+00	457
2182	2182	3	1640	\N	Anthurium Red Medium	\N	2026-03-08 22:37:19.057926+00	458
2183	2180	3	1641	\N	Anthurium Hot Pink XLarge	\N	2026-03-08 22:37:19.058751+00	459
2184	2181	3	1642	\N	Anthurium Hot Pink Large	\N	2026-03-08 22:37:19.059556+00	460
2185	2182	3	1643	\N	Anthurium Hot Pink Medium	\N	2026-03-08 22:37:19.060355+00	461
2186	2180	3	1644	\N	Anthurium Rosa/ Santé/ Cheers/Senator XLarge	\N	2026-03-08 22:37:19.060827+00	\N
2187	2181	3	1645	\N	Anthurium Rosa/ Santé/ Cheers/Senator Large	\N	2026-03-08 22:37:19.061348+00	\N
2188	2182	3	1646	\N	Anthurium Rosa/ Santé/ Cheers/Senator Medium	\N	2026-03-08 22:37:19.061919+00	\N
2189	2180	3	1647	\N	Anthurium Casino/Choco/Calisto/Orange XLarge	\N	2026-03-08 22:37:19.062474+00	\N
2190	2181	3	1648	\N	Anthurium Casino/Choco/Calisto/Orange Large	\N	2026-03-08 22:37:19.06304+00	\N
2191	2182	3	1649	\N	Anthurium Casino/Choco/Calisto/Orange Medium	\N	2026-03-08 22:37:19.063603+00	\N
2192	2180	3	1650	\N	Anthurium White XLarge	\N	2026-03-08 22:37:19.064358+00	462
2193	2181	3	1651	\N	Anthurium White Large	\N	2026-03-08 22:37:19.065169+00	463
2194	2182	3	1652	\N	Anthurium White Medium	\N	2026-03-08 22:37:19.065688+00	464
2195	2180	3	1653	\N	Anthurium Green XLarge	\N	2026-03-08 22:37:19.066295+00	465
2196	2181	3	1654	\N	Anthurium Green Large	\N	2026-03-08 22:37:19.067156+00	466
2197	2182	3	1655	\N	Anthurium Green Medium	\N	2026-03-08 22:37:19.067983+00	467
2198	2180	3	1656	\N	Anthurium Assorted XLarge	\N	2026-03-08 22:37:19.06864+00	\N
2199	2181	3	1657	\N	Anthurium Assorted Large	\N	2026-03-08 22:37:19.069199+00	\N
2200	2182	3	1658	\N	Anthurium Assorted Medium	\N	2026-03-08 22:37:19.069761+00	\N
2201	164	3	1659	\N	Amaranthus Hanging Red	\N	2026-03-08 22:37:19.070674+00	468
2202	164	3	1660	\N	Amaranthus Hanging Green	\N	2026-03-08 22:37:19.071229+00	469
2203	164	3	1661	\N	Amaranthus Hanging Mira Bicolor	\N	2026-03-08 22:37:19.071611+00	\N
2204	164	3	1662	\N	Amaranthus Hanging Bronze	\N	2026-03-08 22:37:19.072108+00	470
2205	164	3	1663	\N	Amaranthus Upright Red	\N	2026-03-08 22:37:19.072892+00	471
2206	164	3	1664	\N	Amaranthus Upright Green	\N	2026-03-08 22:37:19.073722+00	472
2207	164	3	1665	\N	Amaranthus Upright Bronze	\N	2026-03-08 22:37:19.074553+00	473
2208	164	3	1666	\N	Amaranthus Upright Orange	\N	2026-03-08 22:37:19.075327+00	474
2209	164	3	1667	\N	Amaranthus Cascada Red	\N	2026-03-08 22:37:19.076069+00	475
2210	1789	3	1668	\N	Lepidium	\N	2026-03-08 22:37:19.076651+00	\N
2211	2148	3	1669	\N	Celosia Cristata Spray Hot Pink	\N	2026-03-08 22:37:19.077157+00	476
2212	2148	3	1670	\N	Celosia Cristata Hot Pink	\N	2026-03-08 22:37:19.077786+00	477
2213	2148	3	1671	\N	Celosia Cristata Gold	\N	2026-03-08 22:37:19.078625+00	478
2214	2148	3	1672	\N	Celosia Cristata Scarlet	\N	2026-03-08 22:37:19.079274+00	\N
2215	2148	3	1673	\N	Celosia Cresta Red	\N	2026-03-08 22:37:19.080068+00	479
2216	2148	3	1674	\N	Celosia Cresta Red XL	\N	2026-03-08 22:37:19.080877+00	480
2217	2148	3	1675	\N	Red Sun flower	\N	2026-03-08 22:37:19.081597+00	\N
2218	2218	3	1676	\N	Safari Sunset	\N	2026-03-08 22:37:19.08218+00	\N
2219	2219	3	1677	\N	Curcuma Elata	\N	2026-03-08 22:37:19.082852+00	\N
2220	864	3	1678	\N	Hypericum Mix	\N	2026-03-08 22:37:19.083417+00	\N
2221	864	3	1679	\N	Hypericum Red	\N	2026-03-08 22:37:19.083958+00	\N
2222	864	3	1680	\N	Hypericum Peach	\N	2026-03-08 22:37:19.084489+00	\N
2223	2223	3	1681	\N	Areca Palm XL	\N	2026-03-08 22:37:19.085099+00	\N
2224	1052	3	1682	\N	Areca Palm M	\N	2026-03-08 22:37:19.085533+00	\N
2225	1052	3	1683	\N	Areca Palm S	\N	2026-03-08 22:37:19.085947+00	\N
2226	1052	3	1684	\N	Arrow Palm	\N	2026-03-08 22:37:19.086401+00	\N
2227	1052	3	1685	\N	Fish Tail	\N	2026-03-08 22:37:19.086799+00	\N
2228	2228	3	1686	\N	Accordeon Palm XL	\N	2026-03-08 22:37:19.087427+00	\N
2229	1052	3	1687	\N	Accordeon Palm L	\N	2026-03-08 22:37:19.088083+00	\N
2230	1052	3	1688	\N	Accordeon Palm M	\N	2026-03-08 22:37:19.08864+00	\N
2231	1052	3	1689	\N	Licuala Palm	\N	2026-03-08 22:37:19.089224+00	\N
2232	1052	3	1690	\N	Raphis Palm	\N	2026-03-08 22:37:19.089807+00	\N
2233	2233	3	1691	\N	Deer Face	\N	2026-03-08 22:37:19.090475+00	\N
2234	2233	3	1692	\N	Alocasia Esmeralda Large	\N	2026-03-08 22:37:19.091059+00	\N
2235	2233	3	1693	\N	Alocasia Esmeralda Medium	\N	2026-03-08 22:37:19.091652+00	\N
2236	2233	3	1694	\N	Alocasia Esmeralda Small	\N	2026-03-08 22:37:19.092371+00	\N
2237	2237	3	1695	\N	Alocasia Green XL	\N	2026-03-08 22:37:19.093272+00	\N
2238	2237	3	1696	\N	Alocasia Green Large	\N	2026-03-08 22:37:19.093869+00	\N
2239	2233	3	1697	\N	Alocasia Green Medium	\N	2026-03-08 22:37:19.094563+00	\N
2240	2233	3	1698	\N	Alocasia Green Small	\N	2026-03-08 22:37:19.095226+00	\N
2241	2237	3	1699	\N	Alocasia Xlarge Bicolor	\N	2026-03-08 22:37:19.095914+00	\N
2242	2237	3	1700	\N	Alocasia Large Bicolor	\N	2026-03-08 22:37:19.09674+00	\N
2243	2233	3	1701	\N	Alocasia Medium Bicolor	\N	2026-03-08 22:37:19.09744+00	\N
2244	2233	3	1702	\N	Alocasia Small Bicolor	\N	2026-03-08 22:37:19.098092+00	\N
2245	2245	3	1703	\N	Monstera XLarge Green	\N	2026-03-08 22:37:19.099181+00	481
2246	2245	3	1704	\N	Monstera Large Green	\N	2026-03-08 22:37:19.099842+00	\N
2247	2038	3	1705	\N	Monstera Medium Green	\N	2026-03-08 22:37:19.100469+00	\N
2248	2038	3	1706	\N	Monstera Small Green	\N	2026-03-08 22:37:19.100996+00	\N
2249	2038	3	1707	\N	Monstera Petite Green	\N	2026-03-08 22:37:19.101586+00	\N
2250	2245	3	1708	\N	Monstera XLarge Bicolor	\N	2026-03-08 22:37:19.10217+00	\N
2251	2245	3	1709	\N	Monstera Large Bicolor	\N	2026-03-08 22:37:19.102756+00	\N
2252	2038	3	1710	\N	Monstera Medium Bicolor	\N	2026-03-08 22:37:19.10355+00	\N
2253	2245	3	1711	\N	Alocasia and Monstera Bicolor Mix Sizes	\N	2026-03-08 22:37:19.104175+00	\N
2254	2254	3	1712	\N	Musa Leaf XL	\N	2026-03-08 22:37:19.104829+00	\N
2255	2048	3	1713	\N	Musa Leaf Large	\N	2026-03-08 22:37:19.105324+00	\N
2256	2048	3	1714	\N	Musa Leaf Small	\N	2026-03-08 22:37:19.105712+00	\N
2257	2257	3	1715	\N	Phi Pinnatifidum	\N	2026-03-08 22:37:19.106211+00	\N
2258	2257	3	1716	\N	Phi Seloum	\N	2026-03-08 22:37:19.10683+00	\N
2259	2228	3	1717	\N	Trina Palm Round	\N	2026-03-08 22:37:19.107409+00	\N
2260	2228	3	1718	\N	Umbrella Palm	\N	2026-03-08 22:37:19.108011+00	\N
2261	2228	3	1719	\N	Toquilla Palm	\N	2026-03-08 22:37:19.108563+00	\N
2262	2228	3	1720	\N	Agave Penco XL	\N	2026-03-08 22:37:19.108948+00	\N
2263	1052	3	1721	\N	Agave Penco	\N	2026-03-08 22:37:19.109324+00	\N
2264	2264	3	1722	\N	Willow thick	\N	2026-03-08 22:37:19.10977+00	\N
2265	2264	3	1723	\N	Willow	\N	2026-03-08 22:37:19.110234+00	\N
2266	2266	3	1724	\N	Cocculos leaf	\N	2026-03-08 22:37:19.110815+00	\N
2267	2267	3	1725	\N	Sansevieria Golden	\N	2026-03-08 22:37:19.111421+00	482
2268	2267	3	1726	\N	Sansevieria Silver	\N	2026-03-08 22:37:19.111823+00	\N
2269	2269	3	1727	\N	Cocoplum	\N	2026-03-08 22:37:19.112473+00	\N
2270	2270	3	1728	\N	Masajeana Variegated	\N	2026-03-08 22:37:19.113139+00	\N
2271	2271	3	1729	\N	Dieffenbachia lemon	\N	2026-03-08 22:37:19.113878+00	\N
2272	2271	3	1730	\N	Dieffenbachia white	\N	2026-03-08 22:37:19.114543+00	\N
2273	2273	3	1731	\N	Alpinia Leave Variegated	\N	2026-03-08 22:37:19.115245+00	\N
2274	543	3	1732	\N	Eucalyptus Long	\N	2026-03-08 22:37:19.115859+00	\N
2275	543	3	1733	\N	Eucalyptus Silver Dollar	\N	2026-03-08 22:37:19.116442+00	\N
2276	2276	3	1734	\N	Calathea round leaf	\N	2026-03-08 22:37:19.117127+00	\N
2277	2276	3	1735	\N	Calathea Zebrina Leaf CE	\N	2026-03-08 22:37:19.117678+00	\N
2278	2276	3	1736	\N	Calathea Zebrina leaf LM	\N	2026-03-08 22:37:19.118326+00	\N
2279	2279	3	1737	\N	Cordyline leaf dark green pink edge	\N	2026-03-08 22:37:19.118891+00	483
2280	2279	3	1738	\N	Cordyline leaf Fucsia	\N	2026-03-08 22:37:19.11957+00	\N
2281	2279	3	1739	\N	Cordyline leaf mix	\N	2026-03-08 22:37:19.120243+00	\N
2282	2282	3	1740	\N	Cordyline leaf XL full green	\N	2026-03-08 22:37:19.120954+00	484
2283	2282	3	1741	\N	Cordyline leaf XL Pink edge	\N	2026-03-08 22:37:19.121786+00	485
2284	2282	3	1742	\N	Cordyline leaf XL black	\N	2026-03-08 22:37:19.122396+00	\N
2285	688	3	1743	\N	Cordyline tip fucsia (not USA)	\N	2026-03-08 22:37:19.123021+00	\N
2286	688	3	1744	\N	Cordyline tip full green (not USA)	\N	2026-03-08 22:37:19.123596+00	\N
2287	688	3	1745	\N	Cordyline tip dark green pink edge (not USA)	\N	2026-03-08 22:37:19.124078+00	\N
2288	2050	3	1746	\N	Phi Congo Red	\N	2026-03-08 22:37:19.124678+00	486
2289	2050	3	1747	\N	Phi Congo Green	\N	2026-03-08 22:37:19.125438+00	487
2290	2050	3	1748	\N	Phi Xantal	\N	2026-03-08 22:37:19.126214+00	\N
2291	2050	3	1749	\N	Phi Lemon	\N	2026-03-08 22:37:19.126903+00	\N
2292	2050	3	1750	\N	Phi Esmeralda	\N	2026-03-08 22:37:19.127532+00	\N
2293	2050	3	1751	\N	Phi Xanadu	\N	2026-03-08 22:37:19.128133+00	\N
2294	2050	3	1752	\N	Phi Hope	\N	2026-03-08 22:37:19.128763+00	\N
2295	2295	3	1753	\N	Davalia	\N	2026-03-08 22:37:19.129364+00	\N
2296	2295	3	1754	\N	Felicium Fern (not USA)	\N	2026-03-08 22:37:19.129974+00	\N
2297	2295	3	1755	\N	Esparrago plumosa	\N	2026-03-08 22:37:19.130632+00	488
2298	2295	3	1756	\N	Helecho Macho	\N	2026-03-08 22:37:19.131045+00	\N
2299	2295	3	1757	\N	Lettuce Fern	\N	2026-03-08 22:37:19.131488+00	\N
2300	2295	3	1758	\N	Foliate	\N	2026-03-08 22:37:19.131874+00	\N
2301	2295	3	1759	\N	Twisted fern	\N	2026-03-08 22:37:19.132441+00	\N
2302	2302	3	1760	\N	Pandanus Green	\N	2026-03-08 22:37:19.133023+00	\N
2303	2302	3	1761	\N	Pandanus Variegated	\N	2026-03-08 22:37:19.133631+00	\N
2304	2302	3	1762	\N	Pandanus Curly variegated	\N	2026-03-08 22:37:19.134204+00	\N
2305	2305	3	1763	\N	Monedita	\N	2026-03-08 22:37:19.134891+00	\N
2306	688	3	1764	\N	Croton tip lemon dop	\N	2026-03-08 22:37:19.135491+00	\N
2307	2307	3	1765	\N	Croton tip lemon dop	\N	2026-03-08 22:37:19.136132+00	\N
2308	688	3	1766	\N	Croton tip baby doll	\N	2026-03-08 22:37:19.136825+00	\N
2309	688	3	1767	\N	Croton tip thin	\N	2026-03-08 22:37:19.137487+00	\N
2310	688	3	1768	\N	Schefflera tip Green	\N	2026-03-08 22:37:19.138316+00	489
2311	688	3	1769	\N	Schefflera tip Bicolor	\N	2026-03-08 22:37:19.139035+00	\N
2312	688	3	1770	\N	Anglonema tip Green	\N	2026-03-08 22:37:19.139824+00	490
2313	688	3	1771	\N	Anglonema tip Snow White	\N	2026-03-08 22:37:19.140645+00	491
2314	688	3	1772	\N	Anglonema tip Pink and Green CE	\N	2026-03-08 22:37:19.141454+00	492
2315	688	3	1773	\N	Anglonema tip Pink and Green LM	\N	2026-03-08 22:37:19.14227+00	493
2316	688	3	513	\N	Podocarpus	\N	2026-03-08 22:37:19.142614+00	\N
2317	2317	3	1775	\N	Coffee leaf	\N	2026-03-08 22:37:19.1431+00	\N
2318	2318	3	1776	\N	Aralia Leaves	\N	2026-03-08 22:37:19.143745+00	\N
2319	2033	3	1777	\N	Aspidistra leaves	\N	2026-03-08 22:37:19.144336+00	\N
2320	2320	3	1778	\N	Schefflera leaves	\N	2026-03-08 22:37:19.144995+00	\N
2321	2050	3	1779	\N	Aralia Japonica	\N	2026-03-08 22:37:19.145882+00	\N
2322	537	3	1780	\N	Dried Monochromatic Box Green	\N	2026-03-08 22:37:19.146691+00	494
2323	537	3	1781	\N	Dried Monochromatic Box Xmass	\N	2026-03-08 22:37:19.14747+00	\N
2324	537	3	1782	\N	Dried Monochromatic Box Red	\N	2026-03-08 22:37:19.14827+00	495
2325	537	3	1783	\N	Dried Monochromatic Box Metallic	\N	2026-03-08 22:37:19.148746+00	\N
2326	537	3	1784	\N	Dried Monochromatic Box Eart	\N	2026-03-08 22:37:19.149181+00	\N
2327	537	3	1785	\N	Dried Monochromatic Box Fall	\N	2026-03-08 22:37:19.149688+00	\N
2328	537	3	1786	\N	Dried Monochromatic Box Pink/Red	\N	2026-03-08 22:37:19.15045+00	496
2329	537	3	1787	\N	Dried Monochromatic Box Bleached	\N	2026-03-08 22:37:19.15107+00	\N
2330	537	3	1788	\N	Dried Monochromatic Box Pink	\N	2026-03-08 22:37:19.151879+00	497
2331	537	3	1789	\N	Dried Monochromatic Box Fucsia	\N	2026-03-08 22:37:19.152536+00	\N
2332	537	3	1790	\N	Dried Monochromatic Box Lavender	\N	2026-03-08 22:37:19.153292+00	498
2333	537	3	1791	\N	Dried Monochromatic Box Light Pink	\N	2026-03-08 22:37:19.154675+00	499
2334	537	3	1792	\N	Dried Monochromatic Box Pastel	\N	2026-03-08 22:37:19.155442+00	\N
2335	537	3	1793	\N	Wow Dried Box	\N	2026-03-08 22:37:19.155874+00	\N
2336	537	3	1794	\N	Deco Dry Xmass	\N	2026-03-08 22:37:19.156277+00	\N
2337	537	3	1795	\N	Jingle Preserved Box	\N	2026-03-08 22:37:19.156673+00	\N
2338	537	3	1796	\N	Dried Deco Pink Box	\N	2026-03-08 22:37:19.157298+00	500
2339	537	3	1797	\N	Dried Enchanted Pink Box	\N	2026-03-08 22:37:19.158099+00	501
2340	537	3	1798	\N	Dried Pampas Slim summer mix	\N	2026-03-08 22:37:19.158772+00	\N
2341	537	3	1799	\N	Dried Pampas Slim fall mix	\N	2026-03-08 22:37:19.159396+00	\N
2342	537	3	1800	\N	Dried Summer Box	\N	2026-03-08 22:37:19.159792+00	\N
2343	537	3	1801	\N	Dried Eternal Box	\N	2026-03-08 22:37:19.160171+00	\N
2344	537	3	1802	\N	Dried Eternal Rose Box	\N	2026-03-08 22:37:19.16057+00	\N
2345	537	3	1803	\N	Dried BQT Eternal Large Xmass Mix	\N	2026-03-08 22:37:19.160911+00	\N
2346	537	3	1804	\N	Dried BQT Eternal Large Fall Mix	\N	2026-03-08 22:37:19.161552+00	\N
2347	537	3	1805	\N	Dried BQT Eternal Large Vday Mix	\N	2026-03-08 22:37:19.162287+00	\N
2348	537	3	1806	\N	Dried BQT Eternal Regular Mix	\N	2026-03-08 22:37:19.163845+00	\N
2349	537	3	1807	\N	Dried BQT Lush Botanicals Mix	\N	2026-03-08 22:37:19.164466+00	\N
2350	537	3	1808	\N	SemiFresh Willow Wreath Noel	\N	2026-03-08 22:37:19.165165+00	\N
2351	537	3	1809	\N	SemiFresh Willow Wreath Shine	\N	2026-03-08 22:37:19.165773+00	\N
2352	537	3	1810	\N	SemiFresh Willow Wreath Twinkle	\N	2026-03-08 22:37:19.166428+00	\N
2353	537	3	1811	\N	Lunaria (any colour)	\N	2026-03-08 22:37:19.167011+00	\N
2354	537	3	1812	\N	Orchad (any colour)	\N	2026-03-08 22:37:19.167642+00	\N
2355	537	3	1813	\N	Oats (any colour)	\N	2026-03-08 22:37:19.168228+00	\N
2356	537	3	1814	\N	Thypa (any colour)	\N	2026-03-08 22:37:19.168827+00	\N
2357	537	3	1815	\N	Eucalyptus preserved natural	\N	2026-03-08 22:37:19.16965+00	502
2358	537	3	1816	\N	Eucalyptus preserved burgundy	\N	2026-03-08 22:37:19.170659+00	503
2359	537	3	1817	\N	Bunny Tail (any colour)	\N	2026-03-08 22:37:19.171237+00	\N
2360	537	3	1818	\N	Gypsophila (any colour)	\N	2026-03-08 22:37:19.171688+00	\N
2361	537	3	1819	\N	Spikes (any colour)	\N	2026-03-08 22:37:19.172169+00	\N
2362	537	3	1820	\N	Linum (any colour)	\N	2026-03-08 22:37:19.172791+00	\N
2363	537	3	1821	\N	Craspedia (any colour)	\N	2026-03-08 22:37:19.173324+00	\N
2364	537	3	1822	\N	Dried Washingtonia round palm	\N	2026-03-08 22:37:19.173921+00	\N
2365	537	3	1823	\N	Dried Washingtonia heart palm	\N	2026-03-08 22:37:19.174505+00	\N
2366	537	3	1824	\N	Spear Palm Fall	\N	2026-03-08 22:37:19.175113+00	\N
2367	537	3	1825	\N	Dried Sago palm bleached	\N	2026-03-08 22:37:19.175685+00	\N
2368	537	3	1826	\N	Dried Pampas Fat Natural	\N	2026-03-08 22:37:19.176443+00	504
2369	537	3	1827	\N	Dried Pennisetum bleached	\N	2026-03-08 22:37:19.176988+00	\N
2370	537	3	1828	\N	Dried Pennisetum Xmass	\N	2026-03-08 22:37:19.177578+00	\N
2371	537	3	1829	\N	Gorso Xmass	\N	2026-03-08 22:37:19.178151+00	\N
2372	537	3	1830	\N	Dried Banana Leaf upright red	\N	2026-03-08 22:37:19.178726+00	505
2373	537	3	1831	\N	Dried Ginger pink	\N	2026-03-08 22:37:19.179528+00	506
2374	537	3	1832	\N	Jungle Apple L	\N	2026-03-08 22:37:19.180123+00	\N
2375	537	3	1833	\N	caryota dry bleached L	\N	2026-03-08 22:37:19.181176+00	\N
2376	537	3	1834	\N	caryota dry bleached M	\N	2026-03-08 22:37:19.181906+00	\N
2377	537	3	1835	\N	caryota dry red S	\N	2026-03-08 22:37:19.182817+00	507
2378	537	3	1836	\N	chili fat pick*1 (any colour)	\N	2026-03-08 22:37:19.183408+00	\N
2379	537	3	1837	\N	Loafa Sponge pick*1 (any colour)	\N	2026-03-08 22:37:19.183881+00	\N
2380	537	3	1838	\N	Loafa Pick*1 Orange Halloween	\N	2026-03-08 22:37:19.184525+00	508
2381	537	3	1839	\N	Pennycress bleach	\N	2026-03-08 22:37:19.185001+00	\N
2382	537	3	1840	\N	Andean Aster (any colour)	\N	2026-03-08 22:37:19.185572+00	\N
2383	537	3	1841	\N	Limonium bunch*10 (any colour)	\N	2026-03-08 22:37:19.186181+00	\N
2384	537	3	1842	\N	Redwood Grace Wreath	\N	2026-03-08 22:37:19.186776+00	\N
2385	537	3	1843	\N	Earthbound Elegance Wreath	\N	2026-03-08 22:37:19.187482+00	\N
2386	537	3	1844	\N	Rudolf Golden Fresh Wreath	\N	2026-03-08 22:37:19.188201+00	\N
2387	537	3	1845	\N	Comet Golden Fresh Wreath	\N	2026-03-08 22:37:19.188842+00	\N
2388	537	3	1846	\N	Dasher Golden Fresh Wreath	\N	2026-03-08 22:37:19.189463+00	\N
2389	537	3	1847	\N	Cielo Golden Dried Wreath	\N	2026-03-08 22:37:19.190035+00	\N
2390	537	3	1848	\N	Eclipse Golden Dried Wreath	\N	2026-03-08 22:37:19.190617+00	\N
2391	537	3	1849	\N	Bleached Golden Dried Wreath	\N	2026-03-08 22:37:19.191184+00	\N
2392	537	3	1850	\N	Snow Golden Dried Wreath	\N	2026-03-08 22:37:19.191741+00	\N
2393	537	3	1851	\N	Snow Gold Wood Box	\N	2026-03-08 22:37:19.192355+00	\N
2394	537	3	1852	\N	Noel Wood Box	\N	2026-03-08 22:37:19.192896+00	\N
2395	537	3	1853	\N	Green Moss Wood Box	\N	2026-03-08 22:37:19.193393+00	\N
2396	537	3	1854	\N	Rose Red Wood Box	\N	2026-03-08 22:37:19.193839+00	\N
2397	537	3	1855	\N	bismark palm round shape, natural/tinted	\N	2026-03-08 22:37:19.194847+00	509
2398	537	3	1856	\N	ginger dry gold	\N	2026-03-08 22:37:19.195711+00	510
2399	537	3	1857	\N	Podocarpus bleached or Green	\N	2026-03-08 22:37:19.196527+00	511
2400	537	3	1858	\N	jungle apple gold L	\N	2026-03-08 22:37:19.197308+00	512
2401	537	3	1859	\N	jungle apple gold M	\N	2026-03-08 22:37:19.198137+00	513
2402	537	3	1860	\N	jungle apple gold S	\N	2026-03-08 22:37:19.198918+00	514
2403	164	5	1660	\N	Amaranthus Hanging Green	\N	2026-03-08 22:37:19.199401+00	469
2404	225	5	1862	\N	Gypsophila Million Star White	\N	2026-03-08 22:37:19.199971+00	516
2405	268	5	1863	\N	Calla Lily Mini White	\N	2026-03-08 22:37:19.20062+00	517
2406	2406	5	1864	\N	Calla Lily Mini Purple	\N	2026-03-08 22:37:19.201409+00	518
2407	465	5	1865	\N	Delphinium Belladonna White	\N	2026-03-08 22:37:19.202199+00	519
2408	465	5	1866	\N	Delphinium Sky Waltz Light Blue 70cm	\N	2026-03-08 22:37:19.203147+00	520
2409	525	5	1867	\N	Dianthus Solomio White	\N	2026-03-08 22:37:19.203985+00	521
2410	688	5	1868	\N	Eucalyptus Parvifolia Green	\N	2026-03-08 22:37:19.204873+00	522
2411	688	5	1869	\N	Eucalyptus Silver Dollar Green	\N	2026-03-08 22:37:19.20571+00	523
2412	688	5	1870	\N	Leather Green	\N	2026-03-08 22:37:19.206556+00	524
2413	688	5	1871	\N	Ruscus Israeli Green	\N	2026-03-08 22:37:19.207325+00	525
2414	688	5	1872	\N	Ruscus Italian Green 100 cm	\N	2026-03-08 22:37:19.207975+00	\N
2415	806	5	1873	\N	Hydrangea Dark Blue Medium	\N	2026-03-08 22:37:19.208729+00	526
2416	892	5	1277	\N	Larkspur White	\N	2026-03-08 22:37:19.209247+00	\N
2417	918	5	1875	\N	Lily Oriental Stargazer Pink/White	\N	2026-03-08 22:37:19.2101+00	527
2418	1200	5	1876	\N	Ranunculus Cream	\N	2026-03-08 22:37:19.210695+00	\N
2419	244	5	1877	\N	Ranunculus Spray Butterfly Eris Salmon	\N	2026-03-08 22:37:19.211421+00	528
2420	1	5	1878	\N	Rose Mondial Cream	\N	2026-03-08 22:37:19.212054+00	529
2421	1	5	1879	\N	Rose Peach	\N	2026-03-08 22:37:19.212526+00	\N
2422	1	5	1880	\N	Rose Playa Blanca White	\N	2026-03-08 22:37:19.213064+00	530
2423	1	5	1881	\N	Rose Tibet White	\N	2026-03-08 22:37:19.2141+00	531
2424	4	5	1882	\N	Rose Garden Keira Blush	\N	2026-03-08 22:37:19.214986+00	532
2425	1517	5	1883	\N	Spray Rose Floreana White	\N	2026-03-08 22:37:19.215876+00	533
2426	1517	5	1884	\N	Spray Rose Sahara Sensation Peach	\N	2026-03-08 22:37:19.216688+00	534
2427	1456	5	1885	\N	Scabiosa French Vanilla Scoop Blush	\N	2026-03-08 22:37:19.217469+00	535
2428	1456	5	1886	\N	Scabiosa White	\N	2026-03-08 22:37:19.218075+00	\N
2429	1594	5	1887	\N	Statice Tissue Culture Peach	\N	2026-03-08 22:37:19.218819+00	536
2430	1602	5	1888	\N	Stock Yellow Select	\N	2026-03-08 22:37:19.219532+00	\N
2431	1702	5	1889	\N	Tulip Light Pink	\N	2026-03-08 22:37:19.220457+00	537
2432	1702	5	1890	\N	Tulip White	\N	2026-03-08 22:37:19.221093+00	\N
2433	158	5	1891	\N	Acacia Foliage Pearl Silver	\N	2026-03-08 22:37:19.221713+00	\N
2434	2406	5	1892	\N	Calla Lily Mini White	\N	2026-03-08 22:37:19.222351+00	517
2435	2435	5	1893	\N	Chamomile Daisy White	\N	2026-03-08 22:37:19.223217+00	539
2436	543	5	1894	\N	Eucalyptus Gunnii Green	\N	2026-03-08 22:37:19.22393+00	540
2437	806	5	1895	\N	Hydrangea Mojito Green Medium	\N	2026-03-08 22:37:19.224548+00	541
2438	2438	5	1896	\N	Calla Lily Super White 80cm	\N	2026-03-08 22:37:19.22527+00	542
2439	2439	5	1897	\N	Orlaya White	\N	2026-03-08 22:37:19.225969+00	\N
2440	1517	5	1898	\N	Spray Rose Snowflake White	\N	2026-03-08 22:37:19.226732+00	543
2441	1676	5	1899	\N	Eryngium Magical Blue Lagoon Blue	\N	2026-03-08 22:37:19.227571+00	544
2442	543	5	1900	\N	Eucalyptus Silver Dollar Green	\N	2026-03-08 22:37:19.22815+00	523
2443	2443	5	1901	\N	Gypsophila Xlence White	\N	2026-03-08 22:37:19.228976+00	546
2444	1200	5	1902	\N	Ranunculus Clooney Pink	\N	2026-03-08 22:37:19.229805+00	547
2445	1200	5	1903	\N	Ranunculus White	\N	2026-03-08 22:37:19.230433+00	\N
2446	1602	5	1904	\N	Stock White Select	\N	2026-03-08 22:37:19.230985+00	\N
2447	688	5	1905	\N	Cypress Carolina Sapphire Green	\N	2026-03-08 22:37:19.231857+00	548
2448	688	5	1906	\N	Douglas Fir Boughs Green	\N	2026-03-08 22:37:19.232617+00	549
2449	688	5	1907	\N	Leyland Cypress Variegated	\N	2026-03-08 22:37:19.23305+00	\N
2450	688	5	1908	\N	Ruscus Italian Green	\N	2026-03-08 22:37:19.233529+00	550
2451	806	5	1909	\N	Hydrangea White Medium	\N	2026-03-08 22:37:19.233903+00	\N
2452	158	5	1910	\N	Acacia Blooming Yellow	\N	2026-03-08 22:37:19.23467+00	551
2453	163	5	1911	\N	Allium Japan Snake Ball Green	\N	2026-03-08 22:37:19.235484+00	552
2454	164	5	1659	\N	Amaranthus Hanging Red	\N	2026-03-08 22:37:19.236016+00	468
2455	173	5	1913	\N	Anemone Mistral Blush	\N	2026-03-08 22:37:19.236853+00	554
2456	182	5	1914	\N	Anthurium Burgundy Medium	\N	2026-03-08 22:37:19.237767+00	\N
2457	2033	5	1915	\N	Aspidistra Green	\N	2026-03-08 22:37:19.238572+00	\N
2458	204	5	1916	\N	Aster Montecasino White	\N	2026-03-08 22:37:19.239349+00	555
2459	2459	5	1917	\N	Astilbe Burgundy	\N	2026-03-08 22:37:19.239973+00	\N
2460	221	5	1280	\N	Astrantia Burgundy	\N	2026-03-08 22:37:19.240395+00	\N
2461	221	5	1283	\N	Astrantia White	\N	2026-03-08 22:37:19.240769+00	\N
2462	225	5	1920	\N	Garland Gypsophila Xlence White 5'	\N	2026-03-08 22:37:19.241399+00	556
2463	225	5	1921	\N	Gypsophila Xlence White	\N	2026-03-08 22:37:19.241944+00	546
2464	2464	5	1922	\N	Ligustrum Berry Black	\N	2026-03-08 22:37:19.242703+00	558
2465	2464	5	1923	\N	Pepperberry Hanging Pink	\N	2026-03-08 22:37:19.243346+00	559
2466	2466	5	1924	\N	Fruiting Branches Blueberries Green	\N	2026-03-08 22:37:19.243934+00	560
2467	268	5	1925	\N	Calla Lily Aethiopica White	\N	2026-03-08 22:37:19.244777+00	561
2468	268	5	1926	\N	Calla Lily Mini Cranberry Burgundy 40cm	\N	2026-03-08 22:37:19.245567+00	562
2469	268	5	1927	\N	Calla Lily Mini Cranberry Burgundy 50cm	\N	2026-03-08 22:37:19.246368+00	563
2470	268	5	1928	\N	Calla Lily Mini Crystal Blush White	\N	2026-03-08 22:37:19.247124+00	564
2471	268	5	1929	\N	Calla Lily Mini Naomi Purple	\N	2026-03-08 22:37:19.247957+00	565
2472	268	5	1930	\N	Calla Lily Mini Schwarzwalder Black	\N	2026-03-08 22:37:19.248603+00	\N
2473	268	5	1931	\N	Calla Lily Mini White 50cm	\N	2026-03-08 22:37:19.249328+00	566
2474	268	5	1932	\N	Calla Lily Super White 80cm	\N	2026-03-08 22:37:19.249929+00	542
2475	2406	5	1933	\N	Calla Lily Mini Burgundy	\N	2026-03-08 22:37:19.250694+00	568
2476	2406	5	1934	\N	Calla Lily Mini Cranberry Burgundy	\N	2026-03-08 22:37:19.251443+00	569
2477	2406	5	1935	\N	Calla Lily Mini Light Pink	\N	2026-03-08 22:37:19.252161+00	570
2478	2406	5	1936	\N	Calla Lily Mini Nightcap	\N	2026-03-08 22:37:19.252679+00	\N
2479	2406	5	1937	\N	Calla Lily Mini Nightcap Purple	\N	2026-03-08 22:37:19.253383+00	571
2480	94	5	1938	\N	Carnation Brut Blush Fancy	\N	2026-03-08 22:37:19.254637+00	572
2481	94	5	1939	\N	Carnation Burgundy	\N	2026-03-08 22:37:19.255257+00	\N
2482	94	5	1940	\N	Carnation Hanoi Blush	\N	2026-03-08 22:37:19.255884+00	573
2483	94	5	1941	\N	Carnation Lege Marrone Beige	\N	2026-03-08 22:37:19.256784+00	574
2484	94	5	1942	\N	Carnation Lizzy Peach Fancy	\N	2026-03-08 22:37:19.257578+00	575
2485	94	5	1943	\N	Carnation Minerva Purple/White Fancy	\N	2026-03-08 22:37:19.258265+00	576
2486	94	5	1944	\N	Carnation White	\N	2026-03-08 22:37:19.258812+00	\N
2487	1018	5	1945	\N	Mini Carnation White	\N	2026-03-08 22:37:19.259351+00	\N
2488	350	5	1946	\N	China Mum Bronze	\N	2026-03-08 22:37:19.260063+00	577
2489	350	5	1947	\N	China Mum White Select	\N	2026-03-08 22:37:19.260791+00	578
2490	350	5	1948	\N	Chrysanthemum Disbud Andrea Purple	\N	2026-03-08 22:37:19.261508+00	579
2491	350	5	1949	\N	Chrysanthemum Disbud Ball Red	\N	2026-03-08 22:37:19.262217+00	580
2492	350	5	1950	\N	Chrysanthemum Disbud Cooper	\N	2026-03-08 22:37:19.262757+00	\N
2493	350	5	1951	\N	Chrysanthemum Disbud Cooper Bronze	\N	2026-03-08 22:37:19.263445+00	581
2494	350	5	1952	\N	Chrysanthemum Disbud Linette	\N	2026-03-08 22:37:19.263998+00	\N
2495	350	5	1953	\N	Chrysanthemum Disbud Linette Peach	\N	2026-03-08 22:37:19.264655+00	582
2496	350	5	1954	\N	Chrysanthemum Disbud White	\N	2026-03-08 22:37:19.265614+00	583
2497	416	5	1955	\N	Pod Clematis White	\N	2026-03-08 22:37:19.266361+00	584
2498	465	5	1956	\N	Delphinium Belladonna Dark Blue	\N	2026-03-08 22:37:19.266983+00	585
2499	465	5	1957	\N	Delphinium Belladonna Light Blue	\N	2026-03-08 22:37:19.267577+00	586
2500	465	5	1958	\N	Delphinium Sea Waltz Dark Blue 70cm	\N	2026-03-08 22:37:19.268194+00	587
2501	465	5	1959	\N	Delphinium Sea Waltz White	\N	2026-03-08 22:37:19.268873+00	588
2502	537	5	1960	\N	Preserved Bleached Fern White	\N	2026-03-08 22:37:19.26961+00	589
2503	539	5	1961	\N	Eryngium Magical Blue Lagoon Blue	\N	2026-03-08 22:37:19.270341+00	544
2504	543	5	1962	\N	Eucalyptus Baby Blue Blue	\N	2026-03-08 22:37:19.271024+00	591
2505	543	5	1963	\N	Eucalyptus Parvifolia Green	\N	2026-03-08 22:37:19.271674+00	522
2506	2016	5	1964	\N	Garland Gypsophila Xlence Natural White	\N	2026-03-08 22:37:19.272364+00	593
2507	2016	5	1965	\N	Garland Gypsophila Xlence White	\N	2026-03-08 22:37:19.273065+00	594
2508	2508	5	1966	\N	Lily Grass Green	\N	2026-03-08 22:37:19.273942+00	595
2509	688	5	1967	\N	Agonis Brown	\N	2026-03-08 22:37:19.274726+00	596
2510	688	5	1968	\N	Bear Grass Standard Green	\N	2026-03-08 22:37:19.275423+00	597
2511	688	5	1969	\N	Cedar Port Orford Green	\N	2026-03-08 22:37:19.276081+00	598
2512	688	5	1970	\N	Dusty Miller Silver	\N	2026-03-08 22:37:19.276612+00	\N
2513	688	5	1971	\N	Eucalyptus Seeded Green	\N	2026-03-08 22:37:19.277269+00	599
2514	688	5	1972	\N	Eucalyptus Silver Dollar	\N	2026-03-08 22:37:19.277743+00	\N
2515	688	5	1973	\N	Eucalyptus Willow Green	\N	2026-03-08 22:37:19.278693+00	600
2516	688	5	1974	\N	Fruiting Branches Olive Green	\N	2026-03-08 22:37:19.279608+00	601
2517	688	5	1975	\N	Huckleberry Green	\N	2026-03-08 22:37:19.280433+00	602
2518	688	5	1976	\N	Lemon/Salal Tips Green	\N	2026-03-08 22:37:19.2812+00	603
2519	688	5	1977	\N	Leyland Cypress Green	\N	2026-03-08 22:37:19.281947+00	604
2520	688	5	1978	\N	Mixed Xmas Greens Evergreen	\N	2026-03-08 22:37:19.282658+00	605
2521	688	5	1979	\N	Nagi Foliage Green	\N	2026-03-08 22:37:19.283349+00	606
2522	688	5	1980	\N	Pittosporum Pitto Nigra Variegated	\N	2026-03-08 22:37:19.283886+00	\N
2523	688	5	1981	\N	Preserved Italian Ruscus Bleached White	\N	2026-03-08 22:37:19.28457+00	607
2524	688	5	1982	\N	Princess Pine Green	\N	2026-03-08 22:37:19.285246+00	608
2525	688	5	1983	\N	Spruce Baby Tree Green	\N	2026-03-08 22:37:19.285962+00	609
2526	688	5	1984	\N	Sword Fern Green	\N	2026-03-08 22:37:19.286617+00	610
2527	2527	5	1985	\N	Fritillaria Meleagris Variegated Purple	\N	2026-03-08 22:37:19.28732+00	611
2528	796	5	1986	\N	Helleborus Queens Red	\N	2026-03-08 22:37:19.2879+00	612
2529	796	5	1987	\N	Helleborus Winterbells Green/White	\N	2026-03-08 22:37:19.288476+00	613
2530	806	5	1988	\N	Hydrangea Antique Green	\N	2026-03-08 22:37:19.28907+00	614
2531	806	5	1989	\N	Hydrangea Light Blue Medium	\N	2026-03-08 22:37:19.289751+00	615
2532	806	5	1990	\N	Hydrangea Mojito Green	\N	2026-03-08 22:37:19.290675+00	616
2533	864	5	1245	\N	Hypericum Burgundy	\N	2026-03-08 22:37:19.29115+00	\N
2534	864	5	1992	\N	Hypericum Ivory	\N	2026-03-08 22:37:19.291662+00	\N
2535	864	5	1993	\N	Hypericum Rocky Romance	\N	2026-03-08 22:37:19.292145+00	\N
2536	918	5	1994	\N	Lily Asiatic Orange	\N	2026-03-08 22:37:19.292811+00	617
2537	918	5	1995	\N	Lily Oriental Light Pink	\N	2026-03-08 22:37:19.293548+00	618
2538	918	5	1996	\N	Lily Oriental White	\N	2026-03-08 22:37:19.294297+00	619
2539	984	5	1997	\N	Limonium Misty White	\N	2026-03-08 22:37:19.294899+00	620
2540	984	5	1998	\N	Limonium Misty White White	\N	2026-03-08 22:37:19.295892+00	621
2541	984	5	1999	\N	Limonium White	\N	2026-03-08 22:37:19.296489+00	\N
2542	997	5	2000	\N	Lisianthus Brown	\N	2026-03-08 22:37:19.297097+00	\N
2543	997	5	2001	\N	Lisianthus Purple	\N	2026-03-08 22:37:19.297668+00	\N
2544	997	5	2002	\N	Lisianthus White	\N	2026-03-08 22:37:19.298207+00	\N
2545	2545	5	2003	\N	Moss Sheet Green	\N	2026-03-08 22:37:19.2988+00	622
2546	2438	5	2004	\N	Calla Lily Super White	\N	2026-03-08 22:37:19.299485+00	623
2547	1044	5	2005	\N	Cymbidium Mini Red	\N	2026-03-08 22:37:19.300231+00	624
2548	2548	5	2006	\N	Plumosa Green	\N	2026-03-08 22:37:19.300816+00	\N
2549	1091	5	2007	\N	Pompon Button Green	\N	2026-03-08 22:37:19.301464+00	625
2550	1091	5	2008	\N	Pompon Button Lexy Bronze	\N	2026-03-08 22:37:19.302181+00	626
2551	1091	5	2009	\N	Pompon Cushion Burgundy	\N	2026-03-08 22:37:19.30266+00	627
2552	1091	5	2010	\N	Pompon Cushion Red	\N	2026-03-08 22:37:19.303381+00	628
2553	1091	5	2011	\N	Pompon Cushion Veronica Salmon	\N	2026-03-08 22:37:19.304221+00	629
2554	1179	5	2012	\N	Protea King Pink	\N	2026-03-08 22:37:19.304932+00	630
2555	2555	5	2013	\N	Queen Annes Lace White	\N	2026-03-08 22:37:19.305687+00	631
2556	1192	5	2014	\N	Queen Annes Lace Chocolate Brown	\N	2026-03-08 22:37:19.306384+00	632
2557	1200	5	2015	\N	Ranunculus Blush	\N	2026-03-08 22:37:19.306908+00	\N
2558	244	5	2016	\N	Ranunculus Spray Butterfly Ariadne Blush	\N	2026-03-08 22:37:19.307594+00	633
2559	1	5	2017	\N	Rose Amnesia Antique Lavender	\N	2026-03-08 22:37:19.308311+00	634
2560	1	5	2018	\N	Rose Black Baccara Dark Red	\N	2026-03-08 22:37:19.308983+00	635
2561	1	5	2019	\N	Rose Cappuccino Beige	\N	2026-03-08 22:37:19.309653+00	636
2562	1	5	2020	\N	Rose Cream/Blush	\N	2026-03-08 22:37:19.31016+00	\N
2563	1	5	2021	\N	Rose Escimo White	\N	2026-03-08 22:37:19.310797+00	637
2564	1	5	2022	\N	Rose Faith Mauve	\N	2026-03-08 22:37:19.311493+00	638
2565	1	5	2023	\N	Rose Playa Blanca White 50cm	\N	2026-03-08 22:37:19.312186+00	639
2566	1	5	2024	\N	Rose Quicksand Beige	\N	2026-03-08 22:37:19.31287+00	640
2567	1	5	2025	\N	Rose Tibet White 50cm	\N	2026-03-08 22:37:19.31355+00	641
2568	4	5	2026	\N	Rose Garden Wedding Spirit Blush 50cm	\N	2026-03-08 22:37:19.314147+00	642
2569	4	5	2027	\N	Rose Garden White O'hara Blush	\N	2026-03-08 22:37:19.314709+00	643
2570	1517	5	2028	\N	Spray Rose Hanoi Majolica Blush Pink	\N	2026-03-08 22:37:19.31535+00	644
2571	1517	5	2029	\N	Spray Rose Rubicon Dark Red	\N	2026-03-08 22:37:19.316002+00	645
2572	1517	5	2030	\N	Spray Rose White Majolika Cream	\N	2026-03-08 22:37:19.316718+00	646
2573	2573	5	2031	\N	Sanguisorba Burgundy	\N	2026-03-08 22:37:19.317301+00	\N
2574	1456	5	2032	\N	Scabiosa Blackberry Scoop Burgundy	\N	2026-03-08 22:37:19.317905+00	647
2575	1463	5	2033	\N	Snapdragon Burgundy	\N	2026-03-08 22:37:19.318506+00	\N
2576	1463	5	2034	\N	Snapdragon Orange Select	\N	2026-03-08 22:37:19.319004+00	\N
2577	1463	5	2035	\N	Snapdragon Pink Select	\N	2026-03-08 22:37:19.319529+00	\N
2578	1463	5	2036	\N	Snapdragon White Select	\N	2026-03-08 22:37:19.320067+00	\N
2579	1517	5	2037	\N	Spray Rose Peach Jewel Pink/Peach	\N	2026-03-08 22:37:19.320752+00	648
2580	1517	5	2038	\N	Spray Rose Snowflake	\N	2026-03-08 22:37:19.321344+00	\N
2581	1517	5	2039	\N	Spray Rose White Majolika	\N	2026-03-08 22:37:19.321834+00	\N
2582	1602	5	2040	\N	Stock Burgundy Select	\N	2026-03-08 22:37:19.322318+00	\N
2583	1602	5	2041	\N	Stock Mauve Select	\N	2026-03-08 22:37:19.322802+00	\N
2584	1602	5	2042	\N	Stock Peach Select	\N	2026-03-08 22:37:19.323316+00	\N
2585	1676	5	2043	\N	Eryngium Blue	\N	2026-03-08 22:37:19.323838+00	649
2586	1702	5	2044	\N	Tulip Double Light Pink	\N	2026-03-08 22:37:19.324744+00	650
2587	1702	5	2045	\N	Tulip Double Northcap White	\N	2026-03-08 22:37:19.32553+00	651
2588	1702	5	2046	\N	Tulip Dyed Brown	\N	2026-03-08 22:37:19.326244+00	652
2589	1702	5	2047	\N	Tulip Parrot Super Parrot Green/White	\N	2026-03-08 22:37:19.326938+00	653
2590	1702	5	2048	\N	Tulip Red	\N	2026-03-08 22:37:19.327364+00	\N
2591	1702	5	2049	\N	Tulip Royal Virgin	\N	2026-03-08 22:37:19.327757+00	\N
2592	1730	5	1279	\N	Veronica White	\N	2026-03-08 22:37:19.328048+00	\N
2593	1734	5	2051	\N	Wax Flower Purple	\N	2026-03-08 22:37:19.328608+00	\N
2594	1734	5	2052	\N	Wax Flower White	\N	2026-03-08 22:37:19.329057+00	\N
2595	94	5	2053	\N	Carnation Lege Marrone Beige Fancy	\N	2026-03-08 22:37:19.329673+00	654
2596	1	5	2054	\N	Rose Black Magic Dark Red	\N	2026-03-08 22:37:19.330411+00	655
2597	2597	5	2055	\N	Brunia Silver	\N	2026-03-08 22:37:19.331015+00	\N
2598	2598	5	2056	\N	Ruscus Italian Green 100 cm	\N	2026-03-08 22:37:19.331519+00	\N
2599	350	5	2057	\N	Chrysanthemum Disbud Ball White	\N	2026-03-08 22:37:19.332262+00	656
2600	350	5	2058	\N	Chrysanthemum Disbud Maisy White	\N	2026-03-08 22:37:19.332946+00	657
2601	864	5	1246	\N	Hypericum White	\N	2026-03-08 22:37:19.333237+00	\N
2602	1091	5	2060	\N	Pompon Button White	\N	2026-03-08 22:37:19.333737+00	658
2603	2603	5	2061	\N	Preserved Hanging Amaranthus White	\N	2026-03-08 22:37:19.334471+00	659
2604	268	5	2062	\N	Calla Lily Mini Pink	\N	2026-03-08 22:37:19.335163+00	660
2605	2603	5	2063	\N	Astilbe White	\N	2026-03-08 22:37:19.335883+00	661
2606	2603	5	2064	\N	Bear Grass Standard Green	\N	2026-03-08 22:37:19.336482+00	597
2607	2603	5	2065	\N	Amaranthus Hanging Green	\N	2026-03-08 22:37:19.337059+00	469
2608	2603	5	2066	\N	Gomphrena Assorted	\N	2026-03-08 22:37:19.337659+00	\N
2609	2603	5	2067	\N	Phlox Assorted	\N	2026-03-08 22:37:19.338233+00	\N
2610	2603	5	2068	\N	Limonium Misty White White	\N	2026-03-08 22:37:19.338638+00	621
2611	1463	5	2069	\N	Snapdragon Burgundy Select	\N	2026-03-08 22:37:19.339063+00	\N
2612	2603	5	2070	\N	Eryngium Magical Blue	\N	2026-03-08 22:37:19.339592+00	665
2613	2603	5	2071	\N	Waxflower White	\N	2026-03-08 22:37:19.340274+00	666
2614	2603	5	2072	\N	Lemon/Salal Green	\N	2026-03-08 22:37:19.341106+00	667
2615	2603	5	2073	\N	Garland Gypsophila Xlence Natural White 10'	\N	2026-03-08 22:37:19.341909+00	668
2616	94	5	2074	\N	Carnation Assorted	\N	2026-03-08 22:37:19.342461+00	\N
2617	2603	5	2075	\N	Aster Montecasino White	\N	2026-03-08 22:37:19.342975+00	555
2618	2603	5	2076	\N	Smilax Green	\N	2026-03-08 22:37:19.343633+00	670
2619	688	5	510	\N	Pittosporum Variegated	\N	2026-03-08 22:37:19.343997+00	\N
2620	2603	5	2078	\N	Gerbera Mini White	\N	2026-03-08 22:37:19.344722+00	671
2621	2603	5	2079	\N	Waxflower Pink	\N	2026-03-08 22:37:19.34571+00	672
2622	2603	5	2080	\N	Dendrobium Singapore Mokara Red	\N	2026-03-08 22:37:19.346594+00	673
2623	94	5	2081	\N	Carnation Nobbio Burgundy Fancy	\N	2026-03-08 22:37:19.347428+00	674
2624	2603	5	2082	\N	Palm Leaf Areca Green	\N	2026-03-08 22:37:19.348182+00	675
2625	806	5	2083	\N	Hydrangea Light Blue	\N	2026-03-08 22:37:19.348732+00	676
2626	997	5	2084	\N	Lisianthus Cream	\N	2026-03-08 22:37:19.349141+00	\N
2627	1200	5	2085	\N	Ranunculus Spray Butterfly Pink	\N	2026-03-08 22:37:19.349694+00	677
2628	1200	5	2086	\N	Ranunculus Light Pink	\N	2026-03-08 22:37:19.35033+00	678
2629	2603	5	2087	\N	Tweedia White	\N	2026-03-08 22:37:19.350909+00	368
2630	1517	5	2088	\N	Spray Rose Garden Be Loving Blush Pink	\N	2026-03-08 22:37:19.351691+00	680
2631	2603	5	2089	\N	Scabiosa Blush	\N	2026-03-08 22:37:19.352419+00	681
2632	1517	5	2090	\N	Spray Rose White	\N	2026-03-08 22:37:19.353032+00	\N
2633	1	5	2091	\N	Rose Barista Mauve	\N	2026-03-08 22:37:19.354143+00	682
2634	688	5	2092	\N	Pittosporum Silver Queen Variegated	\N	2026-03-08 22:37:19.35471+00	\N
2635	543	5	2093	\N	Eucalyptus Assorted	\N	2026-03-08 22:37:19.355251+00	\N
2636	225	5	2094	\N	Gypsophila Overtime White	\N	2026-03-08 22:37:19.355928+00	683
\.


--
-- Data for Name: stem_lengths; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.stem_lengths (id, stem_id, length_id, created_at) FROM stdin;
\.


--
-- Data for Name: stem_varieties; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.stem_varieties (id, stem_id, variety_id, legacy_stem_id, created_at) FROM stdin;
1	1	1	\N	2026-03-08 22:37:17.843524+00
2	1	2	\N	2026-03-08 22:37:17.849356+00
3	1	3	\N	2026-03-08 22:37:17.851264+00
4	4	4	\N	2026-03-08 22:37:17.853337+00
5	1	5	\N	2026-03-08 22:37:17.855379+00
6	4	6	\N	2026-03-08 22:37:17.856763+00
7	1	7	\N	2026-03-08 22:37:17.859239+00
8	1	8	\N	2026-03-08 22:37:17.859834+00
9	1	9	\N	2026-03-08 22:37:17.861351+00
10	1	10	\N	2026-03-08 22:37:17.862246+00
11	1	11	\N	2026-03-08 22:37:17.863636+00
12	1	12	\N	2026-03-08 22:37:17.864564+00
13	4	13	\N	2026-03-08 22:37:17.865289+00
14	4	14	\N	2026-03-08 22:37:17.869199+00
15	4	15	\N	2026-03-08 22:37:17.870042+00
16	4	16	\N	2026-03-08 22:37:17.872236+00
17	1	17	\N	2026-03-08 22:37:17.87355+00
18	1	18	\N	2026-03-08 22:37:17.874165+00
19	1	19	\N	2026-03-08 22:37:17.874784+00
20	4	20	\N	2026-03-08 22:37:17.875417+00
21	1	21	\N	2026-03-08 22:37:17.876059+00
22	1	22	\N	2026-03-08 22:37:17.876705+00
23	1	23	\N	2026-03-08 22:37:17.877476+00
24	1	24	\N	2026-03-08 22:37:17.88016+00
25	1	25	\N	2026-03-08 22:37:17.881078+00
26	1	26	\N	2026-03-08 22:37:17.881936+00
27	1	27	\N	2026-03-08 22:37:17.88267+00
28	1	28	\N	2026-03-08 22:37:17.883437+00
29	1	29	\N	2026-03-08 22:37:17.884149+00
30	1	30	\N	2026-03-08 22:37:17.884859+00
31	1	31	\N	2026-03-08 22:37:17.885706+00
32	4	32	\N	2026-03-08 22:37:17.887084+00
33	4	33	\N	2026-03-08 22:37:17.887854+00
34	1	34	\N	2026-03-08 22:37:17.888721+00
35	1	35	\N	2026-03-08 22:37:17.889494+00
36	4	36	\N	2026-03-08 22:37:17.890329+00
37	1	37	\N	2026-03-08 22:37:17.890987+00
38	1	38	\N	2026-03-08 22:37:17.891605+00
39	1	39	\N	2026-03-08 22:37:17.892376+00
40	1	40	\N	2026-03-08 22:37:17.893346+00
41	1	41	\N	2026-03-08 22:37:17.894075+00
42	1	42	\N	2026-03-08 22:37:17.894927+00
43	1	43	\N	2026-03-08 22:37:17.896112+00
44	1	44	\N	2026-03-08 22:37:17.89713+00
45	4	45	\N	2026-03-08 22:37:17.897875+00
46	1	46	\N	2026-03-08 22:37:17.898627+00
47	1	47	\N	2026-03-08 22:37:17.899488+00
48	1	48	\N	2026-03-08 22:37:17.900374+00
49	1	49	\N	2026-03-08 22:37:17.90108+00
50	1	50	\N	2026-03-08 22:37:17.901772+00
51	1	51	\N	2026-03-08 22:37:17.902464+00
52	1	52	\N	2026-03-08 22:37:17.903166+00
53	1	53	\N	2026-03-08 22:37:17.904091+00
54	1	54	\N	2026-03-08 22:37:17.904834+00
55	1	55	\N	2026-03-08 22:37:17.905589+00
56	4	56	\N	2026-03-08 22:37:17.906499+00
57	4	57	\N	2026-03-08 22:37:17.907419+00
58	4	58	\N	2026-03-08 22:37:17.908121+00
59	1	59	\N	2026-03-08 22:37:17.908807+00
60	1	60	\N	2026-03-08 22:37:17.909557+00
61	4	61	\N	2026-03-08 22:37:17.910314+00
62	4	62	\N	2026-03-08 22:37:17.911008+00
63	1	63	\N	2026-03-08 22:37:17.91185+00
64	1	64	\N	2026-03-08 22:37:17.912985+00
65	4	65	\N	2026-03-08 22:37:17.913872+00
66	1	66	\N	2026-03-08 22:37:17.914687+00
67	1	67	\N	2026-03-08 22:37:17.915433+00
68	1	68	\N	2026-03-08 22:37:17.916045+00
69	1	69	\N	2026-03-08 22:37:17.916823+00
70	1	70	\N	2026-03-08 22:37:17.9176+00
71	1	71	\N	2026-03-08 22:37:17.918306+00
72	1	72	\N	2026-03-08 22:37:17.919014+00
73	1	73	\N	2026-03-08 22:37:17.919765+00
74	1	74	\N	2026-03-08 22:37:17.920834+00
75	1	75	\N	2026-03-08 22:37:17.921652+00
76	1	76	\N	2026-03-08 22:37:17.922391+00
77	1	77	\N	2026-03-08 22:37:17.923284+00
78	1	78	\N	2026-03-08 22:37:17.924083+00
79	1	79	\N	2026-03-08 22:37:17.924824+00
80	1	80	\N	2026-03-08 22:37:17.925507+00
81	1	81	\N	2026-03-08 22:37:17.926253+00
82	4	82	\N	2026-03-08 22:37:17.927143+00
83	1	83	\N	2026-03-08 22:37:17.927855+00
84	1	84	\N	2026-03-08 22:37:17.928733+00
85	1	85	\N	2026-03-08 22:37:17.929921+00
86	1	86	\N	2026-03-08 22:37:17.930699+00
87	1	87	\N	2026-03-08 22:37:17.931678+00
88	1	88	\N	2026-03-08 22:37:17.932405+00
89	1	89	\N	2026-03-08 22:37:17.933161+00
90	1	90	\N	2026-03-08 22:37:17.933843+00
91	1	91	\N	2026-03-08 22:37:17.934674+00
92	1	92	\N	2026-03-08 22:37:17.935267+00
93	1	93	\N	2026-03-08 22:37:17.935798+00
94	94	94	\N	2026-03-08 22:37:17.936398+00
95	94	95	\N	2026-03-08 22:37:17.936933+00
96	94	96	\N	2026-03-08 22:37:17.937615+00
97	94	97	\N	2026-03-08 22:37:17.938157+00
98	94	98	\N	2026-03-08 22:37:17.93869+00
99	94	99	\N	2026-03-08 22:37:17.939183+00
100	94	100	\N	2026-03-08 22:37:17.940433+00
101	94	101	\N	2026-03-08 22:37:17.941118+00
102	94	102	\N	2026-03-08 22:37:17.941589+00
103	94	103	\N	2026-03-08 22:37:17.94208+00
105	94	105	\N	2026-03-08 22:37:17.942997+00
107	94	107	\N	2026-03-08 22:37:17.943885+00
108	94	108	\N	2026-03-08 22:37:17.944477+00
109	94	109	\N	2026-03-08 22:37:17.945176+00
110	94	110	\N	2026-03-08 22:37:17.946061+00
111	94	111	\N	2026-03-08 22:37:17.94684+00
112	94	112	\N	2026-03-08 22:37:17.94743+00
113	94	113	\N	2026-03-08 22:37:17.947963+00
114	94	114	\N	2026-03-08 22:37:17.948491+00
115	94	115	\N	2026-03-08 22:37:17.949548+00
116	94	116	\N	2026-03-08 22:37:17.950252+00
117	94	117	\N	2026-03-08 22:37:17.950996+00
118	94	118	\N	2026-03-08 22:37:17.95155+00
119	94	119	\N	2026-03-08 22:37:17.952115+00
120	94	120	\N	2026-03-08 22:37:17.952714+00
121	94	121	\N	2026-03-08 22:37:17.953227+00
122	94	122	\N	2026-03-08 22:37:17.953729+00
123	94	123	\N	2026-03-08 22:37:17.954251+00
124	94	124	\N	2026-03-08 22:37:17.954771+00
125	94	125	\N	2026-03-08 22:37:17.955236+00
126	94	126	\N	2026-03-08 22:37:17.95577+00
127	94	127	\N	2026-03-08 22:37:17.956434+00
128	94	128	\N	2026-03-08 22:37:17.956939+00
129	94	129	\N	2026-03-08 22:37:17.957422+00
130	94	130	\N	2026-03-08 22:37:17.957965+00
131	94	131	\N	2026-03-08 22:37:17.958825+00
132	94	132	\N	2026-03-08 22:37:17.960075+00
133	94	133	\N	2026-03-08 22:37:17.960645+00
134	94	134	\N	2026-03-08 22:37:17.96163+00
135	94	135	\N	2026-03-08 22:37:17.962221+00
136	94	136	\N	2026-03-08 22:37:17.962722+00
137	94	137	\N	2026-03-08 22:37:17.963234+00
140	94	140	\N	2026-03-08 22:37:17.96473+00
141	94	141	\N	2026-03-08 22:37:17.965548+00
142	94	142	\N	2026-03-08 22:37:17.966284+00
143	94	143	\N	2026-03-08 22:37:17.966782+00
144	94	144	\N	2026-03-08 22:37:17.967264+00
145	94	145	\N	2026-03-08 22:37:17.967786+00
146	94	146	\N	2026-03-08 22:37:17.968366+00
147	94	147	\N	2026-03-08 22:37:17.969015+00
148	94	148	\N	2026-03-08 22:37:17.96944+00
149	94	149	\N	2026-03-08 22:37:17.96998+00
150	94	150	\N	2026-03-08 22:37:17.970519+00
153	94	153	\N	2026-03-08 22:37:17.972138+00
154	94	154	\N	2026-03-08 22:37:17.972546+00
156	94	156	\N	2026-03-08 22:37:17.973169+00
157	94	157	\N	2026-03-08 22:37:17.973546+00
158	158	158	\N	2026-03-08 22:37:17.974083+00
159	158	159	\N	2026-03-08 22:37:17.976365+00
160	158	160	\N	2026-03-08 22:37:17.976936+00
161	158	161	\N	2026-03-08 22:37:17.97729+00
162	163	162	\N	2026-03-08 22:37:17.977876+00
163	182	163	\N	2026-03-08 22:37:17.985364+00
164	182	164	\N	2026-03-08 22:37:17.985824+00
165	182	165	\N	2026-03-08 22:37:17.987568+00
166	182	166	\N	2026-03-08 22:37:17.988734+00
167	182	167	\N	2026-03-08 22:37:17.991099+00
168	182	168	\N	2026-03-08 22:37:17.991873+00
169	182	169	\N	2026-03-08 22:37:17.994555+00
170	182	170	\N	2026-03-08 22:37:17.9969+00
172	182	172	\N	2026-03-08 22:37:18.002035+00
175	204	175	\N	2026-03-08 22:37:18.017024+00
176	204	176	\N	2026-03-08 22:37:18.018269+00
177	204	177	\N	2026-03-08 22:37:18.019428+00
178	204	178	\N	2026-03-08 22:37:18.022058+00
179	204	179	\N	2026-03-08 22:37:18.022547+00
180	204	180	\N	2026-03-08 22:37:18.022931+00
181	204	181	\N	2026-03-08 22:37:18.025051+00
182	204	182	\N	2026-03-08 22:37:18.025839+00
184	204	184	\N	2026-03-08 22:37:18.033295+00
185	204	185	\N	2026-03-08 22:37:18.033991+00
186	225	186	\N	2026-03-08 22:37:18.03854+00
187	225	187	\N	2026-03-08 22:37:18.040287+00
188	225	188	\N	2026-03-08 22:37:18.040778+00
189	225	189	\N	2026-03-08 22:37:18.043268+00
190	225	190	\N	2026-03-08 22:37:18.043738+00
191	225	191	\N	2026-03-08 22:37:18.044131+00
192	232	192	\N	2026-03-08 22:37:18.044931+00
193	236	193	\N	2026-03-08 22:37:18.049357+00
194	236	194	\N	2026-03-08 22:37:18.050078+00
195	236	195	\N	2026-03-08 22:37:18.052752+00
196	239	196	\N	2026-03-08 22:37:18.055208+00
197	240	197	\N	2026-03-08 22:37:18.055859+00
198	240	198	\N	2026-03-08 22:37:18.056558+00
199	244	199	\N	2026-03-08 22:37:18.068075+00
200	244	200	\N	2026-03-08 22:37:18.06867+00
201	244	201	\N	2026-03-08 22:37:18.071107+00
202	244	202	\N	2026-03-08 22:37:18.073305+00
203	244	203	\N	2026-03-08 22:37:18.07384+00
204	244	204	\N	2026-03-08 22:37:18.076087+00
205	244	205	\N	2026-03-08 22:37:18.076555+00
206	244	206	\N	2026-03-08 22:37:18.077182+00
207	281	207	\N	2026-03-08 22:37:18.086474+00
208	281	208	\N	2026-03-08 22:37:18.088187+00
209	281	209	\N	2026-03-08 22:37:18.08863+00
210	281	210	\N	2026-03-08 22:37:18.089495+00
211	286	211	\N	2026-03-08 22:37:18.091501+00
212	286	212	\N	2026-03-08 22:37:18.092256+00
213	286	213	\N	2026-03-08 22:37:18.093532+00
214	286	214	\N	2026-03-08 22:37:18.094652+00
215	94	215	\N	2026-03-08 22:37:18.099434+00
216	94	216	\N	2026-03-08 22:37:18.100066+00
217	94	217	\N	2026-03-08 22:37:18.10055+00
218	94	218	\N	2026-03-08 22:37:18.101169+00
219	94	219	\N	2026-03-08 22:37:18.10151+00
220	94	220	\N	2026-03-08 22:37:18.101979+00
221	94	221	\N	2026-03-08 22:37:18.102678+00
222	94	222	\N	2026-03-08 22:37:18.103269+00
223	94	223	\N	2026-03-08 22:37:18.103647+00
224	94	224	\N	2026-03-08 22:37:18.104007+00
225	94	225	\N	2026-03-08 22:37:18.104728+00
226	94	226	\N	2026-03-08 22:37:18.105449+00
227	94	227	\N	2026-03-08 22:37:18.106203+00
229	94	229	\N	2026-03-08 22:37:18.107364+00
230	94	230	\N	2026-03-08 22:37:18.108298+00
231	94	231	\N	2026-03-08 22:37:18.1092+00
232	94	232	\N	2026-03-08 22:37:18.109779+00
233	94	233	\N	2026-03-08 22:37:18.110432+00
234	94	234	\N	2026-03-08 22:37:18.110985+00
235	94	235	\N	2026-03-08 22:37:18.111518+00
236	94	236	\N	2026-03-08 22:37:18.112115+00
237	350	237	\N	2026-03-08 22:37:18.117823+00
238	350	238	\N	2026-03-08 22:37:18.118404+00
239	350	239	\N	2026-03-08 22:37:18.118798+00
240	350	240	\N	2026-03-08 22:37:18.119168+00
241	350	241	\N	2026-03-08 22:37:18.119632+00
242	350	242	\N	2026-03-08 22:37:18.120054+00
243	350	243	\N	2026-03-08 22:37:18.120903+00
244	350	244	\N	2026-03-08 22:37:18.121628+00
245	350	245	\N	2026-03-08 22:37:18.12217+00
246	350	246	\N	2026-03-08 22:37:18.122729+00
247	350	247	\N	2026-03-08 22:37:18.123245+00
248	350	248	\N	2026-03-08 22:37:18.123739+00
249	350	249	\N	2026-03-08 22:37:18.124325+00
250	350	250	\N	2026-03-08 22:37:18.12479+00
251	350	251	\N	2026-03-08 22:37:18.125262+00
252	350	252	\N	2026-03-08 22:37:18.125788+00
253	350	253	\N	2026-03-08 22:37:18.126314+00
254	350	254	\N	2026-03-08 22:37:18.126745+00
255	350	255	\N	2026-03-08 22:37:18.127116+00
256	350	256	\N	2026-03-08 22:37:18.127445+00
257	350	257	\N	2026-03-08 22:37:18.127817+00
258	350	258	\N	2026-03-08 22:37:18.128368+00
259	350	259	\N	2026-03-08 22:37:18.129158+00
260	350	260	\N	2026-03-08 22:37:18.130019+00
261	350	261	\N	2026-03-08 22:37:18.130759+00
262	350	262	\N	2026-03-08 22:37:18.131294+00
263	350	263	\N	2026-03-08 22:37:18.131799+00
264	350	264	\N	2026-03-08 22:37:18.132322+00
265	350	265	\N	2026-03-08 22:37:18.132897+00
266	350	266	\N	2026-03-08 22:37:18.133343+00
267	350	267	\N	2026-03-08 22:37:18.133735+00
268	350	268	\N	2026-03-08 22:37:18.134138+00
269	350	269	\N	2026-03-08 22:37:18.134644+00
270	350	270	\N	2026-03-08 22:37:18.135207+00
271	350	271	\N	2026-03-08 22:37:18.135684+00
272	350	272	\N	2026-03-08 22:37:18.136234+00
273	350	273	\N	2026-03-08 22:37:18.13701+00
274	350	274	\N	2026-03-08 22:37:18.137415+00
275	350	275	\N	2026-03-08 22:37:18.137792+00
276	350	276	\N	2026-03-08 22:37:18.138268+00
277	350	277	\N	2026-03-08 22:37:18.138854+00
278	350	278	\N	2026-03-08 22:37:18.139416+00
279	350	279	\N	2026-03-08 22:37:18.140119+00
280	350	280	\N	2026-03-08 22:37:18.140614+00
281	350	281	\N	2026-03-08 22:37:18.140999+00
282	350	282	\N	2026-03-08 22:37:18.141377+00
283	416	283	\N	2026-03-08 22:37:18.142299+00
284	416	284	\N	2026-03-08 22:37:18.143216+00
285	423	285	\N	2026-03-08 22:37:18.144783+00
286	438	286	\N	2026-03-08 22:37:18.148116+00
287	438	287	\N	2026-03-08 22:37:18.149004+00
288	440	288	\N	2026-03-08 22:37:18.149663+00
289	440	289	\N	2026-03-08 22:37:18.150413+00
290	440	290	\N	2026-03-08 22:37:18.151139+00
291	440	291	\N	2026-03-08 22:37:18.151827+00
292	440	292	\N	2026-03-08 22:37:18.152317+00
293	440	293	\N	2026-03-08 22:37:18.152795+00
294	440	294	\N	2026-03-08 22:37:18.153335+00
296	440	296	\N	2026-03-08 22:37:18.154871+00
297	452	297	\N	2026-03-08 22:37:18.155579+00
298	452	298	\N	2026-03-08 22:37:18.156206+00
299	452	299	\N	2026-03-08 22:37:18.156683+00
300	455	300	\N	2026-03-08 22:37:18.158314+00
301	461	301	\N	2026-03-08 22:37:18.158895+00
302	461	302	\N	2026-03-08 22:37:18.159398+00
303	461	303	\N	2026-03-08 22:37:18.16022+00
304	461	304	\N	2026-03-08 22:37:18.1608+00
305	473	305	\N	2026-03-08 22:37:18.1631+00
306	473	306	\N	2026-03-08 22:37:18.163744+00
307	473	307	\N	2026-03-08 22:37:18.164599+00
308	473	308	\N	2026-03-08 22:37:18.165289+00
309	473	309	\N	2026-03-08 22:37:18.165812+00
310	473	310	\N	2026-03-08 22:37:18.16637+00
311	473	311	\N	2026-03-08 22:37:18.167005+00
312	473	312	\N	2026-03-08 22:37:18.167484+00
313	473	313	\N	2026-03-08 22:37:18.167956+00
314	473	314	\N	2026-03-08 22:37:18.168419+00
315	473	315	\N	2026-03-08 22:37:18.168944+00
316	473	316	\N	2026-03-08 22:37:18.169581+00
317	473	317	\N	2026-03-08 22:37:18.170258+00
318	473	318	\N	2026-03-08 22:37:18.170632+00
319	473	319	\N	2026-03-08 22:37:18.170976+00
320	473	320	\N	2026-03-08 22:37:18.171411+00
321	473	321	\N	2026-03-08 22:37:18.171758+00
322	473	322	\N	2026-03-08 22:37:18.17209+00
323	473	323	\N	2026-03-08 22:37:18.172549+00
324	473	324	\N	2026-03-08 22:37:18.172883+00
325	473	325	\N	2026-03-08 22:37:18.173345+00
326	473	326	\N	2026-03-08 22:37:18.17381+00
327	473	327	\N	2026-03-08 22:37:18.174286+00
328	473	328	\N	2026-03-08 22:37:18.174804+00
329	473	329	\N	2026-03-08 22:37:18.17534+00
330	473	330	\N	2026-03-08 22:37:18.175806+00
331	473	331	\N	2026-03-08 22:37:18.176276+00
332	473	332	\N	2026-03-08 22:37:18.176749+00
333	473	333	\N	2026-03-08 22:37:18.177158+00
334	502	334	\N	2026-03-08 22:37:18.178181+00
335	502	335	\N	2026-03-08 22:37:18.179069+00
336	502	336	\N	2026-03-08 22:37:18.179886+00
337	502	337	\N	2026-03-08 22:37:18.180608+00
338	502	338	\N	2026-03-08 22:37:18.181294+00
339	502	339	\N	2026-03-08 22:37:18.182198+00
340	502	340	\N	2026-03-08 22:37:18.182701+00
341	502	341	\N	2026-03-08 22:37:18.183239+00
342	502	342	\N	2026-03-08 22:37:18.183735+00
343	502	343	\N	2026-03-08 22:37:18.184223+00
344	502	344	\N	2026-03-08 22:37:18.184698+00
345	502	345	\N	2026-03-08 22:37:18.185255+00
346	502	346	\N	2026-03-08 22:37:18.185625+00
347	502	347	\N	2026-03-08 22:37:18.185992+00
348	502	348	\N	2026-03-08 22:37:18.186571+00
349	502	349	\N	2026-03-08 22:37:18.186982+00
350	502	350	\N	2026-03-08 22:37:18.187467+00
351	502	351	\N	2026-03-08 22:37:18.188208+00
352	525	352	\N	2026-03-08 22:37:18.189558+00
353	525	353	\N	2026-03-08 22:37:18.190241+00
354	525	354	\N	2026-03-08 22:37:18.190823+00
355	525	355	\N	2026-03-08 22:37:18.191299+00
356	525	356	\N	2026-03-08 22:37:18.191817+00
357	525	357	\N	2026-03-08 22:37:18.1923+00
358	525	358	\N	2026-03-08 22:37:18.192799+00
359	525	359	\N	2026-03-08 22:37:18.193304+00
360	525	360	\N	2026-03-08 22:37:18.19378+00
361	525	361	\N	2026-03-08 22:37:18.19431+00
362	525	362	\N	2026-03-08 22:37:18.194772+00
364	543	364	\N	2026-03-08 22:37:18.198406+00
365	543	365	\N	2026-03-08 22:37:18.198786+00
366	543	366	\N	2026-03-08 22:37:18.199245+00
367	543	367	\N	2026-03-08 22:37:18.199707+00
368	543	368	\N	2026-03-08 22:37:18.200211+00
369	543	369	\N	2026-03-08 22:37:18.200664+00
370	543	370	\N	2026-03-08 22:37:18.201139+00
371	543	371	\N	2026-03-08 22:37:18.201585+00
372	543	372	\N	2026-03-08 22:37:18.202064+00
373	543	373	\N	2026-03-08 22:37:18.202649+00
374	543	374	\N	2026-03-08 22:37:18.203185+00
375	543	375	\N	2026-03-08 22:37:18.203777+00
376	543	376	\N	2026-03-08 22:37:18.204322+00
377	543	377	\N	2026-03-08 22:37:18.204838+00
378	566	378	\N	2026-03-08 22:37:18.205811+00
379	566	379	\N	2026-03-08 22:37:18.206396+00
380	576	380	\N	2026-03-08 22:37:18.209383+00
383	584	383	\N	2026-03-08 22:37:18.211041+00
384	584	384	\N	2026-03-08 22:37:18.211515+00
385	4	385	\N	2026-03-08 22:37:18.213953+00
386	4	386	\N	2026-03-08 22:37:18.214511+00
387	4	387	\N	2026-03-08 22:37:18.215037+00
388	4	388	\N	2026-03-08 22:37:18.215578+00
389	4	389	\N	2026-03-08 22:37:18.216118+00
390	4	390	\N	2026-03-08 22:37:18.216618+00
391	4	391	\N	2026-03-08 22:37:18.217115+00
392	4	392	\N	2026-03-08 22:37:18.217642+00
393	4	393	\N	2026-03-08 22:37:18.218216+00
394	4	394	\N	2026-03-08 22:37:18.218668+00
395	4	395	\N	2026-03-08 22:37:18.219064+00
396	607	396	\N	2026-03-08 22:37:18.219827+00
397	607	397	\N	2026-03-08 22:37:18.220478+00
398	611	398	\N	2026-03-08 22:37:18.222196+00
400	611	400	\N	2026-03-08 22:37:18.22344+00
401	611	401	\N	2026-03-08 22:37:18.224193+00
402	611	402	\N	2026-03-08 22:37:18.224686+00
403	611	403	\N	2026-03-08 22:37:18.225207+00
404	611	404	\N	2026-03-08 22:37:18.225676+00
405	611	405	\N	2026-03-08 22:37:18.226145+00
406	611	406	\N	2026-03-08 22:37:18.226677+00
407	611	407	\N	2026-03-08 22:37:18.227207+00
408	611	408	\N	2026-03-08 22:37:18.227685+00
409	611	409	\N	2026-03-08 22:37:18.228347+00
410	611	410	\N	2026-03-08 22:37:18.228795+00
411	611	411	\N	2026-03-08 22:37:18.229313+00
412	611	412	\N	2026-03-08 22:37:18.229794+00
413	611	413	\N	2026-03-08 22:37:18.230345+00
414	611	414	\N	2026-03-08 22:37:18.230979+00
415	611	415	\N	2026-03-08 22:37:18.231998+00
416	611	416	\N	2026-03-08 22:37:18.232479+00
417	611	417	\N	2026-03-08 22:37:18.232886+00
418	611	418	\N	2026-03-08 22:37:18.233333+00
419	611	419	\N	2026-03-08 22:37:18.233804+00
420	611	420	\N	2026-03-08 22:37:18.234291+00
421	611	421	\N	2026-03-08 22:37:18.234889+00
422	611	422	\N	2026-03-08 22:37:18.235372+00
423	611	423	\N	2026-03-08 22:37:18.235901+00
424	611	424	\N	2026-03-08 22:37:18.236579+00
425	611	425	\N	2026-03-08 22:37:18.237167+00
432	611	432	\N	2026-03-08 22:37:18.241187+00
433	611	433	\N	2026-03-08 22:37:18.241981+00
434	611	434	\N	2026-03-08 22:37:18.242829+00
437	611	437	\N	2026-03-08 22:37:18.246136+00
439	611	439	\N	2026-03-08 22:37:18.248289+00
440	611	440	\N	2026-03-08 22:37:18.248812+00
441	611	441	\N	2026-03-08 22:37:18.249446+00
442	611	442	\N	2026-03-08 22:37:18.250043+00
443	611	443	\N	2026-03-08 22:37:18.25056+00
444	611	444	\N	2026-03-08 22:37:18.251121+00
445	611	445	\N	2026-03-08 22:37:18.251612+00
446	611	446	\N	2026-03-08 22:37:18.25208+00
447	611	447	\N	2026-03-08 22:37:18.252526+00
448	673	448	\N	2026-03-08 22:37:18.253118+00
449	673	449	\N	2026-03-08 22:37:18.253601+00
450	673	450	\N	2026-03-08 22:37:18.254145+00
451	673	451	\N	2026-03-08 22:37:18.254654+00
452	677	165	\N	2026-03-08 22:37:18.255189+00
454	687	454	\N	2026-03-08 22:37:18.258363+00
455	688	455	\N	2026-03-08 22:37:18.258833+00
456	688	456	\N	2026-03-08 22:37:18.259232+00
457	688	457	\N	2026-03-08 22:37:18.259598+00
458	688	458	\N	2026-03-08 22:37:18.259977+00
459	688	459	\N	2026-03-08 22:37:18.26051+00
460	688	460	\N	2026-03-08 22:37:18.261122+00
461	688	461	\N	2026-03-08 22:37:18.261943+00
462	688	462	\N	2026-03-08 22:37:18.262477+00
463	688	463	\N	2026-03-08 22:37:18.26316+00
464	688	464	\N	2026-03-08 22:37:18.263761+00
465	688	465	\N	2026-03-08 22:37:18.264642+00
466	688	466	\N	2026-03-08 22:37:18.265389+00
467	688	467	\N	2026-03-08 22:37:18.265997+00
468	688	468	\N	2026-03-08 22:37:18.26658+00
469	688	469	\N	2026-03-08 22:37:18.267093+00
470	688	470	\N	2026-03-08 22:37:18.267587+00
471	688	471	\N	2026-03-08 22:37:18.268067+00
472	688	472	\N	2026-03-08 22:37:18.269086+00
473	688	473	\N	2026-03-08 22:37:18.269566+00
474	688	474	\N	2026-03-08 22:37:18.270545+00
475	688	475	\N	2026-03-08 22:37:18.271326+00
476	688	476	\N	2026-03-08 22:37:18.272234+00
477	688	477	\N	2026-03-08 22:37:18.273165+00
478	688	478	\N	2026-03-08 22:37:18.273675+00
479	688	479	\N	2026-03-08 22:37:18.274149+00
480	688	480	\N	2026-03-08 22:37:18.274911+00
481	688	481	\N	2026-03-08 22:37:18.276514+00
482	688	482	\N	2026-03-08 22:37:18.277149+00
483	688	483	\N	2026-03-08 22:37:18.277869+00
484	688	484	\N	2026-03-08 22:37:18.278323+00
485	688	485	\N	2026-03-08 22:37:18.278779+00
486	688	486	\N	2026-03-08 22:37:18.279342+00
487	688	487	\N	2026-03-08 22:37:18.27985+00
488	688	488	\N	2026-03-08 22:37:18.280424+00
489	688	489	\N	2026-03-08 22:37:18.280919+00
490	688	490	\N	2026-03-08 22:37:18.28144+00
491	688	491	\N	2026-03-08 22:37:18.282023+00
492	688	492	\N	2026-03-08 22:37:18.282489+00
493	688	493	\N	2026-03-08 22:37:18.282946+00
494	688	494	\N	2026-03-08 22:37:18.283484+00
495	688	495	\N	2026-03-08 22:37:18.283987+00
496	688	496	\N	2026-03-08 22:37:18.284466+00
497	688	497	\N	2026-03-08 22:37:18.284929+00
498	688	498	\N	2026-03-08 22:37:18.285405+00
499	688	499	\N	2026-03-08 22:37:18.285901+00
500	688	500	\N	2026-03-08 22:37:18.286508+00
501	688	501	\N	2026-03-08 22:37:18.287054+00
502	688	502	\N	2026-03-08 22:37:18.287537+00
503	688	503	\N	2026-03-08 22:37:18.288031+00
504	688	504	\N	2026-03-08 22:37:18.288582+00
505	688	505	\N	2026-03-08 22:37:18.289095+00
506	688	506	\N	2026-03-08 22:37:18.28976+00
507	688	507	\N	2026-03-08 22:37:18.290334+00
508	688	508	\N	2026-03-08 22:37:18.290866+00
509	688	509	\N	2026-03-08 22:37:18.291375+00
510	688	510	\N	2026-03-08 22:37:18.291978+00
511	688	511	\N	2026-03-08 22:37:18.292458+00
512	688	165	\N	2026-03-08 22:37:18.293171+00
513	688	513	\N	2026-03-08 22:37:18.293841+00
514	688	514	\N	2026-03-08 22:37:18.294329+00
515	688	515	\N	2026-03-08 22:37:18.294739+00
516	688	516	\N	2026-03-08 22:37:18.295256+00
517	688	517	\N	2026-03-08 22:37:18.295774+00
518	688	518	\N	2026-03-08 22:37:18.296244+00
519	688	519	\N	2026-03-08 22:37:18.296658+00
520	688	520	\N	2026-03-08 22:37:18.297162+00
521	688	521	\N	2026-03-08 22:37:18.297692+00
522	688	522	\N	2026-03-08 22:37:18.298262+00
523	688	523	\N	2026-03-08 22:37:18.298773+00
524	688	524	\N	2026-03-08 22:37:18.299496+00
525	688	525	\N	2026-03-08 22:37:18.301752+00
526	688	526	\N	2026-03-08 22:37:18.302244+00
527	688	527	\N	2026-03-08 22:37:18.302749+00
528	688	528	\N	2026-03-08 22:37:18.303214+00
529	688	529	\N	2026-03-08 22:37:18.3036+00
530	688	530	\N	2026-03-08 22:37:18.303981+00
531	688	531	\N	2026-03-08 22:37:18.304506+00
532	791	532	\N	2026-03-08 22:37:18.305257+00
533	793	193	\N	2026-03-08 22:37:18.305956+00
534	794	534	\N	2026-03-08 22:37:18.306844+00
535	796	535	\N	2026-03-08 22:37:18.308032+00
537	796	537	\N	2026-03-08 22:37:18.30929+00
540	796	540	\N	2026-03-08 22:37:18.310981+00
541	796	541	\N	2026-03-08 22:37:18.311876+00
542	804	542	\N	2026-03-08 22:37:18.312944+00
544	806	544	\N	2026-03-08 22:37:18.31576+00
545	806	545	\N	2026-03-08 22:37:18.316495+00
546	806	546	\N	2026-03-08 22:37:18.317478+00
547	806	547	\N	2026-03-08 22:37:18.317914+00
548	806	548	\N	2026-03-08 22:37:18.318395+00
549	806	549	\N	2026-03-08 22:37:18.318986+00
550	806	550	\N	2026-03-08 22:37:18.319527+00
551	806	165	\N	2026-03-08 22:37:18.320255+00
552	806	552	\N	2026-03-08 22:37:18.321287+00
553	806	553	\N	2026-03-08 22:37:18.322014+00
554	806	554	\N	2026-03-08 22:37:18.322715+00
555	806	555	\N	2026-03-08 22:37:18.323363+00
556	806	556	\N	2026-03-08 22:37:18.324083+00
557	806	557	\N	2026-03-08 22:37:18.324725+00
558	806	558	\N	2026-03-08 22:37:18.325476+00
562	806	562	\N	2026-03-08 22:37:18.327454+00
563	806	563	\N	2026-03-08 22:37:18.328179+00
564	806	564	\N	2026-03-08 22:37:18.328908+00
568	806	227	\N	2026-03-08 22:37:18.331382+00
571	806	571	\N	2026-03-08 22:37:18.343166+00
572	806	572	\N	2026-03-08 22:37:18.343939+00
573	806	573	\N	2026-03-08 22:37:18.345041+00
574	806	574	\N	2026-03-08 22:37:18.345597+00
575	806	575	\N	2026-03-08 22:37:18.346083+00
576	806	576	\N	2026-03-08 22:37:18.347152+00
577	806	577	\N	2026-03-08 22:37:18.347709+00
578	806	578	\N	2026-03-08 22:37:18.348221+00
579	806	579	\N	2026-03-08 22:37:18.348718+00
580	806	580	\N	2026-03-08 22:37:18.34927+00
581	806	581	\N	2026-03-08 22:37:18.349752+00
582	806	582	\N	2026-03-08 22:37:18.350275+00
583	806	583	\N	2026-03-08 22:37:18.350795+00
584	806	584	\N	2026-03-08 22:37:18.35132+00
585	806	585	\N	2026-03-08 22:37:18.351896+00
586	806	586	\N	2026-03-08 22:37:18.35242+00
587	806	587	\N	2026-03-08 22:37:18.352973+00
588	806	588	\N	2026-03-08 22:37:18.353482+00
589	806	589	\N	2026-03-08 22:37:18.353864+00
590	806	590	\N	2026-03-08 22:37:18.355155+00
591	864	591	\N	2026-03-08 22:37:18.357251+00
592	864	592	\N	2026-03-08 22:37:18.35778+00
593	864	593	\N	2026-03-08 22:37:18.358529+00
594	864	594	\N	2026-03-08 22:37:18.359235+00
595	864	595	\N	2026-03-08 22:37:18.359651+00
596	864	596	\N	2026-03-08 22:37:18.360043+00
597	864	597	\N	2026-03-08 22:37:18.360423+00
598	864	598	\N	2026-03-08 22:37:18.360991+00
599	864	599	\N	2026-03-08 22:37:18.36174+00
601	864	601	\N	2026-03-08 22:37:18.362848+00
603	864	603	\N	2026-03-08 22:37:18.36434+00
605	885	605	\N	2026-03-08 22:37:18.365734+00
606	885	606	\N	2026-03-08 22:37:18.366458+00
608	890	608	\N	2026-03-08 22:37:18.368209+00
609	891	609	\N	2026-03-08 22:37:18.368747+00
610	892	610	\N	2026-03-08 22:37:18.369481+00
611	892	611	\N	2026-03-08 22:37:18.370128+00
614	892	614	\N	2026-03-08 22:37:18.3724+00
615	892	615	\N	2026-03-08 22:37:18.373064+00
616	892	616	\N	2026-03-08 22:37:18.373683+00
618	892	618	\N	2026-03-08 22:37:18.37477+00
624	910	540	\N	2026-03-08 22:37:18.378754+00
625	910	625	\N	2026-03-08 22:37:18.379445+00
626	910	626	\N	2026-03-08 22:37:18.379892+00
627	913	627	\N	2026-03-08 22:37:18.380436+00
628	914	614	\N	2026-03-08 22:37:18.38103+00
629	918	629	\N	2026-03-08 22:37:18.382647+00
630	918	630	\N	2026-03-08 22:37:18.383169+00
631	918	631	\N	2026-03-08 22:37:18.383617+00
632	918	632	\N	2026-03-08 22:37:18.384094+00
633	918	633	\N	2026-03-08 22:37:18.384604+00
634	918	634	\N	2026-03-08 22:37:18.385116+00
635	918	635	\N	2026-03-08 22:37:18.38562+00
636	918	636	\N	2026-03-08 22:37:18.386242+00
637	918	637	\N	2026-03-08 22:37:18.387057+00
638	918	638	\N	2026-03-08 22:37:18.387612+00
639	918	639	\N	2026-03-08 22:37:18.388045+00
640	918	640	\N	2026-03-08 22:37:18.388437+00
641	918	641	\N	2026-03-08 22:37:18.388905+00
642	918	642	\N	2026-03-08 22:37:18.389416+00
643	918	643	\N	2026-03-08 22:37:18.389899+00
644	918	644	\N	2026-03-08 22:37:18.390402+00
645	918	645	\N	2026-03-08 22:37:18.3911+00
646	918	646	\N	2026-03-08 22:37:18.391699+00
647	918	647	\N	2026-03-08 22:37:18.392204+00
648	918	648	\N	2026-03-08 22:37:18.392704+00
649	918	649	\N	2026-03-08 22:37:18.393231+00
650	918	650	\N	2026-03-08 22:37:18.393704+00
651	918	651	\N	2026-03-08 22:37:18.394169+00
652	918	652	\N	2026-03-08 22:37:18.394623+00
653	918	653	\N	2026-03-08 22:37:18.395119+00
654	918	654	\N	2026-03-08 22:37:18.395583+00
655	918	655	\N	2026-03-08 22:37:18.396058+00
656	918	656	\N	2026-03-08 22:37:18.396554+00
657	918	657	\N	2026-03-08 22:37:18.397037+00
658	918	658	\N	2026-03-08 22:37:18.397499+00
659	918	659	\N	2026-03-08 22:37:18.397974+00
660	918	660	\N	2026-03-08 22:37:18.398456+00
661	918	661	\N	2026-03-08 22:37:18.398986+00
662	918	662	\N	2026-03-08 22:37:18.399468+00
663	918	663	\N	2026-03-08 22:37:18.399964+00
664	918	664	\N	2026-03-08 22:37:18.400467+00
665	918	665	\N	2026-03-08 22:37:18.400923+00
666	918	666	\N	2026-03-08 22:37:18.401432+00
667	918	667	\N	2026-03-08 22:37:18.401854+00
668	918	668	\N	2026-03-08 22:37:18.402336+00
669	918	669	\N	2026-03-08 22:37:18.402966+00
670	918	670	\N	2026-03-08 22:37:18.403657+00
671	918	671	\N	2026-03-08 22:37:18.404158+00
672	918	672	\N	2026-03-08 22:37:18.404607+00
673	918	673	\N	2026-03-08 22:37:18.405079+00
674	918	674	\N	2026-03-08 22:37:18.405593+00
675	918	675	\N	2026-03-08 22:37:18.406119+00
676	918	676	\N	2026-03-08 22:37:18.406593+00
677	918	677	\N	2026-03-08 22:37:18.407071+00
678	918	678	\N	2026-03-08 22:37:18.407548+00
679	918	679	\N	2026-03-08 22:37:18.407957+00
680	918	680	\N	2026-03-08 22:37:18.408348+00
681	918	681	\N	2026-03-08 22:37:18.408749+00
682	918	682	\N	2026-03-08 22:37:18.409154+00
683	918	683	\N	2026-03-08 22:37:18.409564+00
684	918	684	\N	2026-03-08 22:37:18.410022+00
685	918	685	\N	2026-03-08 22:37:18.410479+00
686	918	686	\N	2026-03-08 22:37:18.410949+00
687	918	687	\N	2026-03-08 22:37:18.411462+00
688	918	688	\N	2026-03-08 22:37:18.411974+00
689	918	689	\N	2026-03-08 22:37:18.412528+00
690	918	690	\N	2026-03-08 22:37:18.413248+00
691	918	691	\N	2026-03-08 22:37:18.413833+00
692	918	692	\N	2026-03-08 22:37:18.41433+00
693	984	693	\N	2026-03-08 22:37:18.417158+00
694	984	694	\N	2026-03-08 22:37:18.418+00
695	997	695	\N	2026-03-08 22:37:18.41974+00
696	997	696	\N	2026-03-08 22:37:18.420228+00
697	997	697	\N	2026-03-08 22:37:18.421226+00
699	997	699	\N	2026-03-08 22:37:18.422816+00
700	997	597	\N	2026-03-08 22:37:18.423256+00
701	997	701	\N	2026-03-08 22:37:18.424141+00
702	997	702	\N	2026-03-08 22:37:18.424532+00
703	997	703	\N	2026-03-08 22:37:18.424912+00
704	997	704	\N	2026-03-08 22:37:18.42541+00
705	1037	705	\N	2026-03-08 22:37:18.433459+00
706	1052	706	\N	2026-03-08 22:37:18.436329+00
707	1052	707	\N	2026-03-08 22:37:18.436698+00
708	1052	708	\N	2026-03-08 22:37:18.437357+00
709	1052	709	\N	2026-03-08 22:37:18.437979+00
710	1052	710	\N	2026-03-08 22:37:18.438575+00
711	1052	711	\N	2026-03-08 22:37:18.439163+00
712	1060	712	\N	2026-03-08 22:37:18.441588+00
714	1060	714	\N	2026-03-08 22:37:18.442943+00
715	1060	715	\N	2026-03-08 22:37:18.443619+00
717	1060	717	\N	2026-03-08 22:37:18.444844+00
718	1060	718	\N	2026-03-08 22:37:18.445604+00
719	1060	719	\N	2026-03-08 22:37:18.446363+00
720	1060	720	\N	2026-03-08 22:37:18.447062+00
721	1076	721	\N	2026-03-08 22:37:18.448051+00
722	1076	722	\N	2026-03-08 22:37:18.44871+00
723	1078	723	\N	2026-03-08 22:37:18.449334+00
724	1078	724	\N	2026-03-08 22:37:18.449839+00
725	1078	725	\N	2026-03-08 22:37:18.450336+00
726	1082	726	\N	2026-03-08 22:37:18.451046+00
727	1082	727	\N	2026-03-08 22:37:18.451437+00
728	1082	728	\N	2026-03-08 22:37:18.451869+00
729	1082	729	\N	2026-03-08 22:37:18.452358+00
730	1082	730	\N	2026-03-08 22:37:18.452934+00
731	1082	731	\N	2026-03-08 22:37:18.453433+00
732	1082	732	\N	2026-03-08 22:37:18.45391+00
733	1091	733	\N	2026-03-08 22:37:18.455189+00
734	1091	734	\N	2026-03-08 22:37:18.45566+00
735	1091	735	\N	2026-03-08 22:37:18.457856+00
736	1091	736	\N	2026-03-08 22:37:18.458854+00
737	1091	737	\N	2026-03-08 22:37:18.459306+00
738	1091	738	\N	2026-03-08 22:37:18.459782+00
739	1091	739	\N	2026-03-08 22:37:18.460238+00
740	1091	740	\N	2026-03-08 22:37:18.460713+00
741	1091	741	\N	2026-03-08 22:37:18.46127+00
742	1091	742	\N	2026-03-08 22:37:18.461815+00
743	1091	743	\N	2026-03-08 22:37:18.462318+00
744	1091	744	\N	2026-03-08 22:37:18.462795+00
745	1091	745	\N	2026-03-08 22:37:18.463243+00
746	1091	746	\N	2026-03-08 22:37:18.463691+00
747	1091	747	\N	2026-03-08 22:37:18.464236+00
748	1091	748	\N	2026-03-08 22:37:18.464713+00
749	1091	749	\N	2026-03-08 22:37:18.46519+00
750	1091	750	\N	2026-03-08 22:37:18.465669+00
751	1091	751	\N	2026-03-08 22:37:18.466239+00
752	1091	752	\N	2026-03-08 22:37:18.466723+00
753	1091	753	\N	2026-03-08 22:37:18.467192+00
754	1091	754	\N	2026-03-08 22:37:18.467685+00
755	1091	755	\N	2026-03-08 22:37:18.468137+00
756	1091	756	\N	2026-03-08 22:37:18.468579+00
757	1091	757	\N	2026-03-08 22:37:18.46908+00
758	1091	758	\N	2026-03-08 22:37:18.469566+00
759	1091	759	\N	2026-03-08 22:37:18.469996+00
760	1091	760	\N	2026-03-08 22:37:18.470541+00
761	1091	761	\N	2026-03-08 22:37:18.471046+00
762	1091	762	\N	2026-03-08 22:37:18.471552+00
763	1091	763	\N	2026-03-08 22:37:18.472043+00
764	1091	764	\N	2026-03-08 22:37:18.472532+00
765	1091	765	\N	2026-03-08 22:37:18.472947+00
766	1091	766	\N	2026-03-08 22:37:18.473361+00
767	1091	767	\N	2026-03-08 22:37:18.473755+00
768	1091	768	\N	2026-03-08 22:37:18.474238+00
769	1091	769	\N	2026-03-08 22:37:18.47479+00
770	1091	770	\N	2026-03-08 22:37:18.47529+00
771	1091	771	\N	2026-03-08 22:37:18.475801+00
772	1091	772	\N	2026-03-08 22:37:18.476288+00
773	1091	773	\N	2026-03-08 22:37:18.476873+00
774	1091	774	\N	2026-03-08 22:37:18.477461+00
775	1091	775	\N	2026-03-08 22:37:18.478208+00
776	1091	776	\N	2026-03-08 22:37:18.479041+00
777	1091	777	\N	2026-03-08 22:37:18.479768+00
778	1091	778	\N	2026-03-08 22:37:18.480424+00
779	1091	779	\N	2026-03-08 22:37:18.480932+00
780	1091	780	\N	2026-03-08 22:37:18.481505+00
781	1091	781	\N	2026-03-08 22:37:18.482001+00
782	1091	782	\N	2026-03-08 22:37:18.482485+00
783	1091	783	\N	2026-03-08 22:37:18.482941+00
784	1091	784	\N	2026-03-08 22:37:18.483609+00
785	1091	785	\N	2026-03-08 22:37:18.484127+00
786	1091	786	\N	2026-03-08 22:37:18.484631+00
787	1091	787	\N	2026-03-08 22:37:18.485116+00
789	1091	789	\N	2026-03-08 22:37:18.48598+00
790	1091	790	\N	2026-03-08 22:37:18.48655+00
791	1091	791	\N	2026-03-08 22:37:18.487262+00
792	1091	792	\N	2026-03-08 22:37:18.487838+00
793	1091	793	\N	2026-03-08 22:37:18.488337+00
794	1091	794	\N	2026-03-08 22:37:18.488856+00
795	1091	795	\N	2026-03-08 22:37:18.48935+00
796	1091	796	\N	2026-03-08 22:37:18.489922+00
797	1091	797	\N	2026-03-08 22:37:18.4904+00
798	1091	798	\N	2026-03-08 22:37:18.490794+00
799	1091	799	\N	2026-03-08 22:37:18.491258+00
800	1091	800	\N	2026-03-08 22:37:18.49181+00
801	1091	801	\N	2026-03-08 22:37:18.492346+00
802	1091	802	\N	2026-03-08 22:37:18.492853+00
803	1091	803	\N	2026-03-08 22:37:18.493421+00
804	1091	804	\N	2026-03-08 22:37:18.493895+00
805	1091	805	\N	2026-03-08 22:37:18.494309+00
806	1179	806	\N	2026-03-08 22:37:18.495488+00
807	1179	807	\N	2026-03-08 22:37:18.496156+00
808	1187	808	\N	2026-03-08 22:37:18.497219+00
809	1187	809	\N	2026-03-08 22:37:18.497734+00
810	1187	810	\N	2026-03-08 22:37:18.498354+00
811	1187	811	\N	2026-03-08 22:37:18.498954+00
812	1187	812	\N	2026-03-08 22:37:18.499532+00
813	1192	813	\N	2026-03-08 22:37:18.500124+00
814	1192	814	\N	2026-03-08 22:37:18.500619+00
815	1192	815	\N	2026-03-08 22:37:18.501112+00
816	1192	816	\N	2026-03-08 22:37:18.501589+00
817	1196	817	\N	2026-03-08 22:37:18.502136+00
818	1196	818	\N	2026-03-08 22:37:18.502543+00
819	1196	819	\N	2026-03-08 22:37:18.503316+00
820	1196	820	\N	2026-03-08 22:37:18.504145+00
821	1203	821	\N	2026-03-08 22:37:18.505909+00
822	1	822	\N	2026-03-08 22:37:18.512513+00
823	1	823	\N	2026-03-08 22:37:18.512982+00
824	1	824	\N	2026-03-08 22:37:18.513539+00
825	1	825	\N	2026-03-08 22:37:18.514011+00
826	1	826	\N	2026-03-08 22:37:18.514681+00
828	1	828	\N	2026-03-08 22:37:18.515699+00
830	1	830	\N	2026-03-08 22:37:18.516578+00
831	1	831	\N	2026-03-08 22:37:18.517041+00
832	1	832	\N	2026-03-08 22:37:18.51753+00
833	1	833	\N	2026-03-08 22:37:18.518039+00
834	1	834	\N	2026-03-08 22:37:18.518495+00
837	1	837	\N	2026-03-08 22:37:18.519794+00
838	1	838	\N	2026-03-08 22:37:18.520228+00
840	1	840	\N	2026-03-08 22:37:18.520986+00
842	1	842	\N	2026-03-08 22:37:18.521713+00
843	1	843	\N	2026-03-08 22:37:18.522499+00
845	1	845	\N	2026-03-08 22:37:18.523328+00
846	1	846	\N	2026-03-08 22:37:18.523857+00
847	1	847	\N	2026-03-08 22:37:18.524364+00
849	1	849	\N	2026-03-08 22:37:18.525171+00
850	1	850	\N	2026-03-08 22:37:18.525705+00
851	1	851	\N	2026-03-08 22:37:18.526202+00
853	1	853	\N	2026-03-08 22:37:18.527041+00
854	1	854	\N	2026-03-08 22:37:18.527512+00
855	1	855	\N	2026-03-08 22:37:18.528042+00
857	1	857	\N	2026-03-08 22:37:18.528907+00
858	1	858	\N	2026-03-08 22:37:18.529449+00
859	1	859	\N	2026-03-08 22:37:18.530073+00
860	1	860	\N	2026-03-08 22:37:18.530841+00
861	1	861	\N	2026-03-08 22:37:18.531374+00
862	1	862	\N	2026-03-08 22:37:18.53189+00
863	1	863	\N	2026-03-08 22:37:18.532412+00
864	1	864	\N	2026-03-08 22:37:18.532926+00
866	1	866	\N	2026-03-08 22:37:18.533623+00
867	1	867	\N	2026-03-08 22:37:18.533974+00
868	1	868	\N	2026-03-08 22:37:18.534423+00
871	1	871	\N	2026-03-08 22:37:18.53578+00
872	1	872	\N	2026-03-08 22:37:18.536736+00
873	1	873	\N	2026-03-08 22:37:18.537324+00
874	1	874	\N	2026-03-08 22:37:18.537883+00
875	1	875	\N	2026-03-08 22:37:18.538357+00
877	1	877	\N	2026-03-08 22:37:18.539202+00
878	1	878	\N	2026-03-08 22:37:18.539707+00
880	1	880	\N	2026-03-08 22:37:18.540537+00
881	1	881	\N	2026-03-08 22:37:18.54098+00
883	1	883	\N	2026-03-08 22:37:18.541646+00
885	1	885	\N	2026-03-08 22:37:18.542432+00
886	1	886	\N	2026-03-08 22:37:18.542981+00
888	1	888	\N	2026-03-08 22:37:18.543856+00
890	1	890	\N	2026-03-08 22:37:18.544684+00
891	1	891	\N	2026-03-08 22:37:18.545197+00
892	1	892	\N	2026-03-08 22:37:18.545679+00
893	1	893	\N	2026-03-08 22:37:18.546162+00
894	1	894	\N	2026-03-08 22:37:18.546637+00
896	1	896	\N	2026-03-08 22:37:18.547294+00
897	1	897	\N	2026-03-08 22:37:18.547723+00
899	1	899	\N	2026-03-08 22:37:18.548555+00
900	1	900	\N	2026-03-08 22:37:18.549004+00
901	1	901	\N	2026-03-08 22:37:18.549395+00
903	1	903	\N	2026-03-08 22:37:18.550061+00
904	1	904	\N	2026-03-08 22:37:18.55055+00
907	1	907	\N	2026-03-08 22:37:18.551695+00
908	1	908	\N	2026-03-08 22:37:18.55216+00
909	1	909	\N	2026-03-08 22:37:18.552585+00
912	1	912	\N	2026-03-08 22:37:18.55372+00
913	1	913	\N	2026-03-08 22:37:18.554226+00
914	1	914	\N	2026-03-08 22:37:18.554581+00
915	1	915	\N	2026-03-08 22:37:18.554945+00
918	1	918	\N	2026-03-08 22:37:18.555775+00
920	1	920	\N	2026-03-08 22:37:18.556475+00
921	1	921	\N	2026-03-08 22:37:18.556961+00
922	1	922	\N	2026-03-08 22:37:18.557482+00
925	1	925	\N	2026-03-08 22:37:18.558638+00
926	1	926	\N	2026-03-08 22:37:18.55914+00
927	1	927	\N	2026-03-08 22:37:18.559627+00
929	1	929	\N	2026-03-08 22:37:18.560446+00
931	1	931	\N	2026-03-08 22:37:18.561219+00
932	1	932	\N	2026-03-08 22:37:18.561665+00
933	1	933	\N	2026-03-08 22:37:18.562129+00
934	1	934	\N	2026-03-08 22:37:18.56259+00
935	1	935	\N	2026-03-08 22:37:18.563072+00
936	1	936	\N	2026-03-08 22:37:18.56383+00
937	1	937	\N	2026-03-08 22:37:18.56455+00
939	1	939	\N	2026-03-08 22:37:18.56551+00
940	1	940	\N	2026-03-08 22:37:18.566018+00
942	1	942	\N	2026-03-08 22:37:18.566824+00
945	1	945	\N	2026-03-08 22:37:18.567917+00
946	1	946	\N	2026-03-08 22:37:18.568358+00
949	1	949	\N	2026-03-08 22:37:18.569366+00
950	1	950	\N	2026-03-08 22:37:18.569775+00
954	1	954	\N	2026-03-08 22:37:18.571221+00
955	1	955	\N	2026-03-08 22:37:18.571705+00
960	1	960	\N	2026-03-08 22:37:18.573601+00
963	1	963	\N	2026-03-08 22:37:18.574859+00
965	1	965	\N	2026-03-08 22:37:18.575706+00
966	1	966	\N	2026-03-08 22:37:18.576724+00
967	1	967	\N	2026-03-08 22:37:18.57738+00
970	1	970	\N	2026-03-08 22:37:18.578864+00
971	1	971	\N	2026-03-08 22:37:18.579545+00
973	1	973	\N	2026-03-08 22:37:18.580446+00
974	1	974	\N	2026-03-08 22:37:18.580967+00
975	1	975	\N	2026-03-08 22:37:18.581768+00
976	1	976	\N	2026-03-08 22:37:18.58248+00
978	1	978	\N	2026-03-08 22:37:18.583497+00
979	1	979	\N	2026-03-08 22:37:18.584112+00
980	1	980	\N	2026-03-08 22:37:18.58471+00
982	1	982	\N	2026-03-08 22:37:18.585566+00
983	1	983	\N	2026-03-08 22:37:18.586157+00
984	1	984	\N	2026-03-08 22:37:18.586782+00
985	1	985	\N	2026-03-08 22:37:18.58732+00
986	1	986	\N	2026-03-08 22:37:18.587867+00
988	1	988	\N	2026-03-08 22:37:18.588769+00
989	1	989	\N	2026-03-08 22:37:18.589359+00
991	1	991	\N	2026-03-08 22:37:18.590754+00
992	1	992	\N	2026-03-08 22:37:18.591506+00
994	1	994	\N	2026-03-08 22:37:18.592741+00
996	1	996	\N	2026-03-08 22:37:18.593627+00
998	1	998	\N	2026-03-08 22:37:18.594739+00
999	1	999	\N	2026-03-08 22:37:18.595558+00
1000	1	1000	\N	2026-03-08 22:37:18.596465+00
1001	1	1001	\N	2026-03-08 22:37:18.5975+00
1002	1	1002	\N	2026-03-08 22:37:18.599167+00
1003	1	1003	\N	2026-03-08 22:37:18.599743+00
1005	1	1005	\N	2026-03-08 22:37:18.60072+00
1006	1	1006	\N	2026-03-08 22:37:18.601301+00
1008	1	1008	\N	2026-03-08 22:37:18.602271+00
1010	1	1010	\N	2026-03-08 22:37:18.603022+00
1012	1	1012	\N	2026-03-08 22:37:18.603972+00
1014	1	1014	\N	2026-03-08 22:37:18.604877+00
1017	1	1017	\N	2026-03-08 22:37:18.606261+00
1018	1	1018	\N	2026-03-08 22:37:18.60684+00
1020	1	1020	\N	2026-03-08 22:37:18.607735+00
1022	1	1022	\N	2026-03-08 22:37:18.608532+00
1024	1	1024	\N	2026-03-08 22:37:18.609301+00
1025	1	1025	\N	2026-03-08 22:37:18.609848+00
1026	1	1026	\N	2026-03-08 22:37:18.610344+00
1028	1	1028	\N	2026-03-08 22:37:18.611526+00
1029	1	1029	\N	2026-03-08 22:37:18.612226+00
1030	1	1030	\N	2026-03-08 22:37:18.612881+00
1033	1	1033	\N	2026-03-08 22:37:18.614537+00
1035	1	1035	\N	2026-03-08 22:37:18.615517+00
1036	1	1036	\N	2026-03-08 22:37:18.616057+00
1037	1	1037	\N	2026-03-08 22:37:18.616668+00
1038	1454	1038	\N	2026-03-08 22:37:18.617225+00
1039	1456	1039	\N	2026-03-08 22:37:18.619045+00
1041	1462	1041	\N	2026-03-08 22:37:18.620651+00
1042	1463	380	\N	2026-03-08 22:37:18.623919+00
1044	1463	606	\N	2026-03-08 22:37:18.625628+00
1046	1478	1046	\N	2026-03-08 22:37:18.627129+00
1047	1483	1047	\N	2026-03-08 22:37:18.628827+00
1048	1483	1048	\N	2026-03-08 22:37:18.629765+00
1049	1483	1049	\N	2026-03-08 22:37:18.630309+00
1050	1483	1050	\N	2026-03-08 22:37:18.630947+00
1051	1483	1051	\N	2026-03-08 22:37:18.631441+00
1052	1483	1052	\N	2026-03-08 22:37:18.631879+00
1053	1483	1053	\N	2026-03-08 22:37:18.632421+00
1054	1483	1054	\N	2026-03-08 22:37:18.632882+00
1055	1483	1055	\N	2026-03-08 22:37:18.633351+00
1056	1483	1056	\N	2026-03-08 22:37:18.633904+00
1057	1483	1057	\N	2026-03-08 22:37:18.634334+00
1058	1483	1058	\N	2026-03-08 22:37:18.634775+00
1059	1483	1059	\N	2026-03-08 22:37:18.63514+00
1060	1483	1060	\N	2026-03-08 22:37:18.635528+00
1061	1483	1061	\N	2026-03-08 22:37:18.636143+00
1062	1483	1062	\N	2026-03-08 22:37:18.636751+00
1063	1483	1063	\N	2026-03-08 22:37:18.637627+00
1064	1483	1064	\N	2026-03-08 22:37:18.638106+00
1065	1483	1065	\N	2026-03-08 22:37:18.638627+00
1066	1483	1066	\N	2026-03-08 22:37:18.63907+00
1067	1483	1067	\N	2026-03-08 22:37:18.639571+00
1068	1483	1068	\N	2026-03-08 22:37:18.640087+00
1069	1483	1069	\N	2026-03-08 22:37:18.640677+00
1070	1483	1070	\N	2026-03-08 22:37:18.641175+00
1071	1483	1071	\N	2026-03-08 22:37:18.641696+00
1072	1483	1072	\N	2026-03-08 22:37:18.64229+00
1073	1483	1073	\N	2026-03-08 22:37:18.642697+00
1074	1483	1074	\N	2026-03-08 22:37:18.643101+00
1075	1483	1075	\N	2026-03-08 22:37:18.643531+00
1076	1483	1076	\N	2026-03-08 22:37:18.643937+00
1077	1515	1077	\N	2026-03-08 22:37:18.644741+00
1078	1515	1078	\N	2026-03-08 22:37:18.645585+00
1079	1517	1079	\N	2026-03-08 22:37:18.647841+00
1080	1517	1080	\N	2026-03-08 22:37:18.649129+00
1081	1517	1081	\N	2026-03-08 22:37:18.64972+00
1082	1517	1082	\N	2026-03-08 22:37:18.650763+00
1083	1517	1083	\N	2026-03-08 22:37:18.651418+00
1084	1517	1084	\N	2026-03-08 22:37:18.651854+00
1085	1517	1085	\N	2026-03-08 22:37:18.652465+00
1086	1517	1086	\N	2026-03-08 22:37:18.652932+00
1087	1517	1087	\N	2026-03-08 22:37:18.653581+00
1088	1517	1088	\N	2026-03-08 22:37:18.654086+00
1089	1517	1089	\N	2026-03-08 22:37:18.654552+00
1090	1517	1090	\N	2026-03-08 22:37:18.655074+00
1091	1517	1091	\N	2026-03-08 22:37:18.655549+00
1092	1517	1092	\N	2026-03-08 22:37:18.657444+00
1093	1517	1093	\N	2026-03-08 22:37:18.657899+00
1095	1517	1095	\N	2026-03-08 22:37:18.658681+00
1096	1517	1096	\N	2026-03-08 22:37:18.659129+00
1097	1517	1097	\N	2026-03-08 22:37:18.659548+00
1098	1517	1098	\N	2026-03-08 22:37:18.659905+00
1099	1517	1099	\N	2026-03-08 22:37:18.660301+00
1100	1517	1100	\N	2026-03-08 22:37:18.660733+00
1101	1517	1101	\N	2026-03-08 22:37:18.661229+00
1102	1517	1102	\N	2026-03-08 22:37:18.661775+00
1103	1517	1103	\N	2026-03-08 22:37:18.662271+00
1104	1517	1104	\N	2026-03-08 22:37:18.663141+00
1105	1517	1105	\N	2026-03-08 22:37:18.663696+00
1106	1517	1106	\N	2026-03-08 22:37:18.664139+00
1107	1517	1107	\N	2026-03-08 22:37:18.664604+00
1108	1517	1108	\N	2026-03-08 22:37:18.665117+00
1109	1517	1109	\N	2026-03-08 22:37:18.665553+00
1110	1517	1110	\N	2026-03-08 22:37:18.66606+00
1111	1517	1111	\N	2026-03-08 22:37:18.666664+00
1112	1517	1112	\N	2026-03-08 22:37:18.667061+00
1113	1517	1113	\N	2026-03-08 22:37:18.66747+00
1114	1517	1114	\N	2026-03-08 22:37:18.667826+00
1115	1517	1115	\N	2026-03-08 22:37:18.668209+00
1116	1517	1116	\N	2026-03-08 22:37:18.668602+00
1117	1517	1117	\N	2026-03-08 22:37:18.669017+00
1118	1517	1118	\N	2026-03-08 22:37:18.669505+00
1119	1517	1119	\N	2026-03-08 22:37:18.669929+00
1120	1517	1120	\N	2026-03-08 22:37:18.670605+00
1121	1517	1121	\N	2026-03-08 22:37:18.672093+00
1122	1517	1122	\N	2026-03-08 22:37:18.672531+00
1123	1517	1123	\N	2026-03-08 22:37:18.672926+00
1124	1594	1124	\N	2026-03-08 22:37:18.679328+00
1125	1594	615	\N	2026-03-08 22:37:18.680543+00
1126	1594	694	\N	2026-03-08 22:37:18.682503+00
1127	1594	1127	\N	2026-03-08 22:37:18.683678+00
1128	1594	1128	\N	2026-03-08 22:37:18.684643+00
1129	1602	1129	\N	2026-03-08 22:37:18.686131+00
1130	1602	1130	\N	2026-03-08 22:37:18.690774+00
1131	1602	1131	\N	2026-03-08 22:37:18.691491+00
1132	1602	1132	\N	2026-03-08 22:37:18.692181+00
1133	1602	362	\N	2026-03-08 22:37:18.694015+00
1134	1602	1134	\N	2026-03-08 22:37:18.695077+00
1135	1602	1135	\N	2026-03-08 22:37:18.695861+00
1136	1602	1136	\N	2026-03-08 22:37:18.696751+00
1137	1602	1137	\N	2026-03-08 22:37:18.697718+00
1138	1602	1138	\N	2026-03-08 22:37:18.698446+00
1144	1602	1144	\N	2026-03-08 22:37:18.705047+00
1148	1602	1148	\N	2026-03-08 22:37:18.709249+00
1149	1602	165	\N	2026-03-08 22:37:18.710055+00
1150	1639	1150	\N	2026-03-08 22:37:18.71102+00
1151	1641	1151	\N	2026-03-08 22:37:18.714404+00
1152	1641	1152	\N	2026-03-08 22:37:18.715274+00
1153	1641	1153	\N	2026-03-08 22:37:18.716021+00
1154	1641	1154	\N	2026-03-08 22:37:18.716921+00
1155	1641	1155	\N	2026-03-08 22:37:18.717607+00
1156	1641	1156	\N	2026-03-08 22:37:18.718237+00
1157	1641	1157	\N	2026-03-08 22:37:18.718996+00
1158	1641	1158	\N	2026-03-08 22:37:18.719834+00
1159	1641	1159	\N	2026-03-08 22:37:18.720578+00
1160	1641	1160	\N	2026-03-08 22:37:18.721251+00
1161	1641	1161	\N	2026-03-08 22:37:18.722175+00
1162	1641	1162	\N	2026-03-08 22:37:18.722948+00
1163	1641	1163	\N	2026-03-08 22:37:18.723656+00
1164	1641	1164	\N	2026-03-08 22:37:18.724295+00
1165	1641	1165	\N	2026-03-08 22:37:18.724904+00
1166	1641	1166	\N	2026-03-08 22:37:18.725628+00
1167	1659	1167	\N	2026-03-08 22:37:18.726904+00
1168	1659	1168	\N	2026-03-08 22:37:18.728308+00
1169	1659	1169	\N	2026-03-08 22:37:18.729175+00
1171	1659	1171	\N	2026-03-08 22:37:18.730878+00
1173	1659	1173	\N	2026-03-08 22:37:18.733294+00
1174	1675	1174	\N	2026-03-08 22:37:18.734328+00
1175	1676	1175	\N	2026-03-08 22:37:18.735276+00
1176	1676	712	\N	2026-03-08 22:37:18.736195+00
1177	1676	597	\N	2026-03-08 22:37:18.736961+00
1178	1676	1178	\N	2026-03-08 22:37:18.737975+00
1179	1682	1179	\N	2026-03-08 22:37:18.739879+00
1180	1682	1180	\N	2026-03-08 22:37:18.740553+00
1181	1682	1181	\N	2026-03-08 22:37:18.741477+00
1182	1685	1182	\N	2026-03-08 22:37:18.742289+00
1183	1685	1183	\N	2026-03-08 22:37:18.742913+00
1184	1685	1184	\N	2026-03-08 22:37:18.743691+00
1185	1685	1185	\N	2026-03-08 22:37:18.744468+00
1186	1685	1186	\N	2026-03-08 22:37:18.74506+00
1187	1685	1187	\N	2026-03-08 22:37:18.745787+00
1188	1685	1188	\N	2026-03-08 22:37:18.746431+00
1189	1685	1189	\N	2026-03-08 22:37:18.747098+00
1190	1685	1190	\N	2026-03-08 22:37:18.747696+00
1191	1685	1191	\N	2026-03-08 22:37:18.748237+00
1192	1685	1192	\N	2026-03-08 22:37:18.748829+00
1193	1685	1193	\N	2026-03-08 22:37:18.749416+00
1194	1685	1194	\N	2026-03-08 22:37:18.749995+00
1195	1685	1195	\N	2026-03-08 22:37:18.750611+00
1196	1702	1196	\N	2026-03-08 22:37:18.756428+00
1197	1702	1197	\N	2026-03-08 22:37:18.757337+00
1198	1702	542	\N	2026-03-08 22:37:18.758309+00
1199	1702	1199	\N	2026-03-08 22:37:18.759294+00
1200	1702	1200	\N	2026-03-08 22:37:18.759905+00
1201	1726	1078	\N	2026-03-08 22:37:18.761148+00
1202	1730	193	\N	2026-03-08 22:37:18.763118+00
1203	1740	1203	\N	2026-03-08 22:37:18.766274+00
1204	1740	615	\N	2026-03-08 22:37:18.767009+00
1205	1740	1205	\N	2026-03-08 22:37:18.76776+00
1206	1740	609	\N	2026-03-08 22:37:18.768963+00
1207	1740	1207	\N	2026-03-08 22:37:18.769686+00
1208	1740	1208	\N	2026-03-08 22:37:18.770273+00
1210	1750	1210	\N	2026-03-08 22:37:18.771911+00
1211	1750	1211	\N	2026-03-08 22:37:18.772567+00
1212	1750	540	\N	2026-03-08 22:37:18.773088+00
1213	204	1213	\N	2026-03-08 22:37:18.774491+00
1214	688	1214	\N	2026-03-08 22:37:18.775296+00
1215	525	1215	\N	2026-03-08 22:37:18.776158+00
1216	1758	1216	\N	2026-03-08 22:37:18.777057+00
1217	1759	1217	\N	2026-03-08 22:37:18.777766+00
1218	1759	1218	\N	2026-03-08 22:37:18.778352+00
1219	1759	1219	\N	2026-03-08 22:37:18.778915+00
1220	1480	1220	\N	2026-03-08 22:37:18.779516+00
1221	1480	1221	\N	2026-03-08 22:37:18.780321+00
1222	1481	1222	\N	2026-03-08 22:37:18.781297+00
1223	1481	1223	\N	2026-03-08 22:37:18.781873+00
1224	1481	1224	\N	2026-03-08 22:37:18.782436+00
1225	1481	1225	\N	2026-03-08 22:37:18.783037+00
1226	1481	1226	\N	2026-03-08 22:37:18.78359+00
1227	1481	1227	\N	2026-03-08 22:37:18.784113+00
1228	1481	1228	\N	2026-03-08 22:37:18.784669+00
1229	94	1229	\N	2026-03-08 22:37:18.785332+00
1230	537	1230	\N	2026-03-08 22:37:18.78592+00
1231	543	1231	\N	2026-03-08 22:37:18.786819+00
1232	543	1232	\N	2026-03-08 22:37:18.787624+00
1233	543	1233	\N	2026-03-08 22:37:18.788208+00
1234	543	1234	\N	2026-03-08 22:37:18.788829+00
1235	688	1235	\N	2026-03-08 22:37:18.789425+00
1236	688	1236	\N	2026-03-08 22:37:18.790284+00
1237	688	1237	\N	2026-03-08 22:37:18.790809+00
1238	688	1238	\N	2026-03-08 22:37:18.791387+00
1239	688	1239	\N	2026-03-08 22:37:18.791966+00
1240	1463	1240	\N	2026-03-08 22:37:18.792796+00
1241	688	1241	\N	2026-03-08 22:37:18.793677+00
1242	1037	1242	\N	2026-03-08 22:37:18.794275+00
1243	688	1243	\N	2026-03-08 22:37:18.795038+00
1244	688	1244	\N	2026-03-08 22:37:18.795605+00
1245	864	1245	\N	2026-03-08 22:37:18.79622+00
1246	864	1246	\N	2026-03-08 22:37:18.797108+00
1247	1789	1247	\N	2026-03-08 22:37:18.798069+00
1248	1789	1248	\N	2026-03-08 22:37:18.798848+00
1249	984	1249	\N	2026-03-08 22:37:18.799624+00
1250	984	1250	\N	2026-03-08 22:37:18.800685+00
1251	984	1251	\N	2026-03-08 22:37:18.801303+00
1252	984	1252	\N	2026-03-08 22:37:18.80217+00
1253	984	1253	\N	2026-03-08 22:37:18.8028+00
1254	1463	1254	\N	2026-03-08 22:37:18.803597+00
1255	1463	1255	\N	2026-03-08 22:37:18.804209+00
1256	1463	1256	\N	2026-03-08 22:37:18.804987+00
1257	1463	1257	\N	2026-03-08 22:37:18.805851+00
1258	1463	1258	\N	2026-03-08 22:37:18.806602+00
1259	1463	1259	\N	2026-03-08 22:37:18.807546+00
1260	1594	1260	\N	2026-03-08 22:37:18.808389+00
1261	1594	1261	\N	2026-03-08 22:37:18.809136+00
1262	1594	1262	\N	2026-03-08 22:37:18.809948+00
1263	1594	1263	\N	2026-03-08 22:37:18.81048+00
1264	1594	1264	\N	2026-03-08 22:37:18.811065+00
1265	1602	1265	\N	2026-03-08 22:37:18.811958+00
1266	1602	1266	\N	2026-03-08 22:37:18.812842+00
1267	1602	1267	\N	2026-03-08 22:37:18.813788+00
1268	1602	1268	\N	2026-03-08 22:37:18.814438+00
1269	1602	1269	\N	2026-03-08 22:37:18.8153+00
1270	1602	1270	\N	2026-03-08 22:37:18.816065+00
1271	1602	1271	\N	2026-03-08 22:37:18.816838+00
1272	1641	1272	\N	2026-03-08 22:37:18.817721+00
1273	1641	1273	\N	2026-03-08 22:37:18.818286+00
1274	424	1274	\N	2026-03-08 22:37:18.819185+00
1275	892	1275	\N	2026-03-08 22:37:18.819821+00
1276	892	1276	\N	2026-03-08 22:37:18.821046+00
1277	892	1277	\N	2026-03-08 22:37:18.821923+00
1278	1730	1278	\N	2026-03-08 22:37:18.822711+00
1279	1730	1279	\N	2026-03-08 22:37:18.823517+00
1280	221	1280	\N	2026-03-08 22:37:18.824335+00
1281	221	1281	\N	2026-03-08 22:37:18.825123+00
1282	221	1282	\N	2026-03-08 22:37:18.825901+00
1283	221	1283	\N	2026-03-08 22:37:18.826693+00
1284	465	1284	\N	2026-03-08 22:37:18.827582+00
1285	465	1285	\N	2026-03-08 22:37:18.828208+00
1286	465	1286	\N	2026-03-08 22:37:18.828736+00
1287	465	1287	\N	2026-03-08 22:37:18.829538+00
1288	465	1288	\N	2026-03-08 22:37:18.830145+00
1289	465	1289	\N	2026-03-08 22:37:18.830736+00
1290	465	1290	\N	2026-03-08 22:37:18.831613+00
1291	465	1291	\N	2026-03-08 22:37:18.832395+00
1292	465	1292	\N	2026-03-08 22:37:18.833209+00
1293	465	1293	\N	2026-03-08 22:37:18.834014+00
1294	465	130	\N	2026-03-08 22:37:18.834525+00
1295	465	1295	\N	2026-03-08 22:37:18.835294+00
1296	465	1296	\N	2026-03-08 22:37:18.836102+00
1297	1839	1297	\N	2026-03-08 22:37:18.836924+00
1298	350	1298	\N	2026-03-08 22:37:18.837804+00
1299	350	1299	\N	2026-03-08 22:37:18.838391+00
1300	350	1300	\N	2026-03-08 22:37:18.838971+00
1301	350	1301	\N	2026-03-08 22:37:18.840101+00
1302	225	1302	\N	2026-03-08 22:37:18.840777+00
1303	465	1303	\N	2026-03-08 22:37:18.84125+00
1304	537	1304	\N	2026-03-08 22:37:18.842545+00
1305	576	1305	\N	2026-03-08 22:37:18.843066+00
1306	576	1306	\N	2026-03-08 22:37:18.843992+00
1307	576	1307	\N	2026-03-08 22:37:18.844575+00
1308	576	1308	\N	2026-03-08 22:37:18.845423+00
1309	1017	1309	\N	2026-03-08 22:37:18.846222+00
1310	1178	1310	\N	2026-03-08 22:37:18.846992+00
1311	1178	1311	\N	2026-03-08 22:37:18.847657+00
1312	1	1312	\N	2026-03-08 22:37:18.848439+00
1313	1517	1313	\N	2026-03-08 22:37:18.849054+00
1314	1517	1314	\N	2026-03-08 22:37:18.849571+00
1315	1517	1315	\N	2026-03-08 22:37:18.850136+00
1316	1517	1316	\N	2026-03-08 22:37:18.850696+00
1317	1517	1317	\N	2026-03-08 22:37:18.851212+00
1318	1517	1318	\N	2026-03-08 22:37:18.851831+00
1319	1517	1319	\N	2026-03-08 22:37:18.852388+00
1320	1517	1320	\N	2026-03-08 22:37:18.853024+00
1321	1517	1321	\N	2026-03-08 22:37:18.853625+00
1322	1517	1322	\N	2026-03-08 22:37:18.854261+00
1323	1517	1323	\N	2026-03-08 22:37:18.855359+00
1324	1517	1324	\N	2026-03-08 22:37:18.855836+00
1325	1517	1325	\N	2026-03-08 22:37:18.857141+00
1326	1517	1326	\N	2026-03-08 22:37:18.857633+00
1327	1517	1327	\N	2026-03-08 22:37:18.858109+00
1328	1517	1328	\N	2026-03-08 22:37:18.860106+00
1329	1517	1329	\N	2026-03-08 22:37:18.860594+00
1330	1456	1330	\N	2026-03-08 22:37:18.861082+00
1331	1456	1331	\N	2026-03-08 22:37:18.861778+00
1332	1456	1332	\N	2026-03-08 22:37:18.86242+00
1333	1456	1333	\N	2026-03-08 22:37:18.862897+00
1334	1456	1334	\N	2026-03-08 22:37:18.86347+00
1335	1456	1335	\N	2026-03-08 22:37:18.864015+00
1336	1456	1336	\N	2026-03-08 22:37:18.8645+00
1337	1456	1337	\N	2026-03-08 22:37:18.864996+00
1338	1456	1338	\N	2026-03-08 22:37:18.865754+00
1339	1456	1339	\N	2026-03-08 22:37:18.866271+00
1340	1456	1340	\N	2026-03-08 22:37:18.866742+00
1341	1456	1341	\N	2026-03-08 22:37:18.867189+00
1342	1456	1342	\N	2026-03-08 22:37:18.867629+00
1343	1456	1343	\N	2026-03-08 22:37:18.868064+00
1344	1517	1344	\N	2026-03-08 22:37:18.8686+00
1345	1659	1345	\N	2026-03-08 22:37:18.869254+00
1346	1659	1346	\N	2026-03-08 22:37:18.86985+00
1347	1659	1347	\N	2026-03-08 22:37:18.870364+00
1348	294	1348	\N	2026-03-08 22:37:18.870894+00
1349	294	1349	\N	2026-03-08 22:37:18.871642+00
1350	1892	1350	\N	2026-03-08 22:37:18.872744+00
1351	1893	1351	\N	2026-03-08 22:37:18.873476+00
1352	1	1352	\N	2026-03-08 22:37:18.874316+00
1353	1	1353	\N	2026-03-08 22:37:18.874853+00
1354	1	1354	\N	2026-03-08 22:37:18.875506+00
1355	1	1355	\N	2026-03-08 22:37:18.876063+00
1357	1	1357	\N	2026-03-08 22:37:18.8769+00
1358	1	1358	\N	2026-03-08 22:37:18.87747+00
1359	1	1359	\N	2026-03-08 22:37:18.878118+00
1360	1	1360	\N	2026-03-08 22:37:18.879434+00
1362	1	1362	\N	2026-03-08 22:37:18.880438+00
1363	1	1363	\N	2026-03-08 22:37:18.881052+00
1366	1	1366	\N	2026-03-08 22:37:18.882537+00
1368	1	1368	\N	2026-03-08 22:37:18.883473+00
1369	1	1369	\N	2026-03-08 22:37:18.88402+00
1370	1	1370	\N	2026-03-08 22:37:18.884587+00
1372	1	1372	\N	2026-03-08 22:37:18.885476+00
1374	1	1374	\N	2026-03-08 22:37:18.886215+00
1381	1	1381	\N	2026-03-08 22:37:18.889883+00
1382	1	1382	\N	2026-03-08 22:37:18.890531+00
1383	1	1383	\N	2026-03-08 22:37:18.890895+00
1385	1	1385	\N	2026-03-08 22:37:18.891474+00
1386	1	1386	\N	2026-03-08 22:37:18.891801+00
1387	1	1387	\N	2026-03-08 22:37:18.892182+00
1388	1	1388	\N	2026-03-08 22:37:18.892599+00
1390	1	62	\N	2026-03-08 22:37:18.89343+00
1391	1	1391	\N	2026-03-08 22:37:18.893958+00
1392	1	1392	\N	2026-03-08 22:37:18.894763+00
1393	1	1393	\N	2026-03-08 22:37:18.895376+00
1394	1	1394	\N	2026-03-08 22:37:18.896008+00
1395	1	1395	\N	2026-03-08 22:37:18.896617+00
1396	1	1396	\N	2026-03-08 22:37:18.897142+00
1398	1	1398	\N	2026-03-08 22:37:18.898224+00
1399	1	1399	\N	2026-03-08 22:37:18.899007+00
1400	1	1400	\N	2026-03-08 22:37:18.899571+00
1401	1	1401	\N	2026-03-08 22:37:18.900147+00
1403	1	1403	\N	2026-03-08 22:37:18.901095+00
1404	1	1404	\N	2026-03-08 22:37:18.901657+00
1405	1726	1405	\N	2026-03-08 22:37:18.902215+00
1406	1726	1406	\N	2026-03-08 22:37:18.902936+00
1407	173	1407	\N	2026-03-08 22:37:18.903734+00
1408	465	1408	\N	2026-03-08 22:37:18.904403+00
1409	173	1409	\N	2026-03-08 22:37:18.905216+00
1410	173	1410	\N	2026-03-08 22:37:18.905964+00
1411	1200	1411	\N	2026-03-08 22:37:18.906697+00
1412	1200	1412	\N	2026-03-08 22:37:18.907272+00
1413	1200	1413	\N	2026-03-08 22:37:18.908049+00
1414	1200	1414	\N	2026-03-08 22:37:18.908527+00
1415	1957	1415	\N	2026-03-08 22:37:18.909152+00
1416	1957	1416	\N	2026-03-08 22:37:18.90995+00
1417	164	1417	\N	2026-03-08 22:37:18.910708+00
1418	164	1418	\N	2026-03-08 22:37:18.911268+00
1419	164	1419	\N	2026-03-08 22:37:18.911787+00
1420	164	1420	\N	2026-03-08 22:37:18.912302+00
1421	164	1421	\N	2026-03-08 22:37:18.913081+00
1422	1964	1409	\N	2026-03-08 22:37:18.913609+00
1423	1965	1302	\N	2026-03-08 22:37:18.914392+00
1424	1965	1424	\N	2026-03-08 22:37:18.915142+00
1425	1965	1425	\N	2026-03-08 22:37:18.915744+00
1426	1965	1426	\N	2026-03-08 22:37:18.916397+00
1427	1200	1427	\N	2026-03-08 22:37:18.91714+00
1428	1200	1428	\N	2026-03-08 22:37:18.917732+00
1429	1200	1429	\N	2026-03-08 22:37:18.918328+00
1430	1200	1430	\N	2026-03-08 22:37:18.918844+00
1431	1200	1431	\N	2026-03-08 22:37:18.919452+00
1432	1	1432	\N	2026-03-08 22:37:18.919972+00
1433	1	1433	\N	2026-03-08 22:37:18.920706+00
1434	1	1434	\N	2026-03-08 22:37:18.921465+00
1435	1	1435	\N	2026-03-08 22:37:18.921995+00
1436	4	1436	\N	2026-03-08 22:37:18.922552+00
1437	4	1437	\N	2026-03-08 22:37:18.923226+00
1438	4	1438	\N	2026-03-08 22:37:18.924008+00
1439	4	1439	\N	2026-03-08 22:37:18.924683+00
1440	4	1440	\N	2026-03-08 22:37:18.925257+00
1441	4	1441	\N	2026-03-08 22:37:18.925805+00
1442	4	1442	\N	2026-03-08 22:37:18.926212+00
1443	4	1443	\N	2026-03-08 22:37:18.926771+00
1444	4	1444	\N	2026-03-08 22:37:18.927308+00
1445	4	12	\N	2026-03-08 22:37:18.928012+00
1446	4	1446	\N	2026-03-08 22:37:18.928722+00
1447	4	1447	\N	2026-03-08 22:37:18.929359+00
1448	4	1448	\N	2026-03-08 22:37:18.930305+00
1449	4	1449	\N	2026-03-08 22:37:18.930869+00
1450	244	1450	\N	2026-03-08 22:37:18.931678+00
1451	244	1451	\N	2026-03-08 22:37:18.932269+00
1452	244	1452	\N	2026-03-08 22:37:18.933038+00
1453	244	1453	\N	2026-03-08 22:37:18.933596+00
1454	244	1454	\N	2026-03-08 22:37:18.934083+00
1455	244	1455	\N	2026-03-08 22:37:18.934646+00
1456	244	1456	\N	2026-03-08 22:37:18.93521+00
1457	244	1457	\N	2026-03-08 22:37:18.935795+00
1458	244	1458	\N	2026-03-08 22:37:18.936312+00
1459	244	1459	\N	2026-03-08 22:37:18.937048+00
1460	244	1460	\N	2026-03-08 22:37:18.937638+00
1461	244	1461	\N	2026-03-08 22:37:18.938178+00
1462	244	1462	\N	2026-03-08 22:37:18.938738+00
1463	244	1463	\N	2026-03-08 22:37:18.939307+00
1464	244	1464	\N	2026-03-08 22:37:18.93985+00
1465	244	1465	\N	2026-03-08 22:37:18.940379+00
1466	244	1466	\N	2026-03-08 22:37:18.940743+00
1467	1200	1467	\N	2026-03-08 22:37:18.941102+00
1468	2010	1468	\N	2026-03-08 22:37:18.94168+00
1469	2010	1469	\N	2026-03-08 22:37:18.942087+00
1470	2012	1470	\N	2026-03-08 22:37:18.942716+00
1471	2012	1471	\N	2026-03-08 22:37:18.94323+00
1472	2012	1472	\N	2026-03-08 22:37:18.944053+00
1473	2012	1473	\N	2026-03-08 22:37:18.944653+00
1474	2016	1474	\N	2026-03-08 22:37:18.945304+00
1475	164	1475	\N	2026-03-08 22:37:18.945791+00
1477	182	1477	\N	2026-03-08 22:37:18.947199+00
1481	182	1481	\N	2026-03-08 22:37:18.949461+00
1482	182	1482	\N	2026-03-08 22:37:18.950227+00
1484	182	1442	\N	2026-03-08 22:37:18.951592+00
1485	182	1485	\N	2026-03-08 22:37:18.952346+00
1487	182	1487	\N	2026-03-08 22:37:18.953772+00
1489	182	1489	\N	2026-03-08 22:37:18.954925+00
1490	182	1490	\N	2026-03-08 22:37:18.955688+00
1491	2033	1491	\N	2026-03-08 22:37:18.956559+00
1492	2034	1492	\N	2026-03-08 22:37:18.957161+00
1493	2034	1493	\N	2026-03-08 22:37:18.957685+00
1495	2037	1495	\N	2026-03-08 22:37:18.958742+00
1496	2038	1496	\N	2026-03-08 22:37:18.959375+00
1497	2038	1497	\N	2026-03-08 22:37:18.959947+00
1498	2038	1498	\N	2026-03-08 22:37:18.960496+00
1499	2038	1499	\N	2026-03-08 22:37:18.961069+00
1500	2042	1500	\N	2026-03-08 22:37:18.961742+00
1501	2043	1501	\N	2026-03-08 22:37:18.962365+00
1502	677	1502	\N	2026-03-08 22:37:18.962982+00
1503	2045	1503	\N	2026-03-08 22:37:18.963909+00
1504	2045	1504	\N	2026-03-08 22:37:18.96458+00
1505	794	1505	\N	2026-03-08 22:37:18.96528+00
1506	2048	1506	\N	2026-03-08 22:37:18.966202+00
1507	2049	1507	\N	2026-03-08 22:37:18.966804+00
1508	2050	1508	\N	2026-03-08 22:37:18.967447+00
1509	2050	1509	\N	2026-03-08 22:37:18.968041+00
1510	2052	1510	\N	2026-03-08 22:37:18.96866+00
1511	2053	1511	\N	2026-03-08 22:37:18.969228+00
1512	677	1512	\N	2026-03-08 22:37:18.970231+00
1513	677	1513	\N	2026-03-08 22:37:18.971103+00
1514	677	1514	\N	2026-03-08 22:37:18.97185+00
1515	677	1515	\N	2026-03-08 22:37:18.972582+00
1516	677	1516	\N	2026-03-08 22:37:18.973297+00
1517	677	1517	\N	2026-03-08 22:37:18.973701+00
1518	677	1518	\N	2026-03-08 22:37:18.97405+00
1519	677	1519	\N	2026-03-08 22:37:18.97439+00
1520	677	1520	\N	2026-03-08 22:37:18.974806+00
1521	677	1521	\N	2026-03-08 22:37:18.975314+00
1522	677	1522	\N	2026-03-08 22:37:18.975936+00
1523	677	1523	\N	2026-03-08 22:37:18.97644+00
1524	677	1524	\N	2026-03-08 22:37:18.976959+00
1525	677	1525	\N	2026-03-08 22:37:18.977521+00
1526	2068	1526	\N	2026-03-08 22:37:18.97814+00
1527	2068	1527	\N	2026-03-08 22:37:18.979189+00
1528	2068	1528	\N	2026-03-08 22:37:18.980282+00
1529	2068	1529	\N	2026-03-08 22:37:18.981021+00
1530	2068	1530	\N	2026-03-08 22:37:18.981751+00
1531	2068	1531	\N	2026-03-08 22:37:18.982476+00
1532	2068	1532	\N	2026-03-08 22:37:18.983216+00
1533	2068	1533	\N	2026-03-08 22:37:18.983775+00
1534	2068	1534	\N	2026-03-08 22:37:18.984442+00
1535	2068	1535	\N	2026-03-08 22:37:18.985153+00
1536	2068	1536	\N	2026-03-08 22:37:18.985894+00
1537	2068	1537	\N	2026-03-08 22:37:18.986689+00
1538	794	1538	\N	2026-03-08 22:37:18.987902+00
1539	794	1539	\N	2026-03-08 22:37:18.988462+00
1540	794	1540	\N	2026-03-08 22:37:18.989219+00
1541	794	1541	\N	2026-03-08 22:37:18.98984+00
1542	794	1542	\N	2026-03-08 22:37:18.990403+00
1543	794	1543	\N	2026-03-08 22:37:18.990797+00
1544	794	1544	\N	2026-03-08 22:37:18.991201+00
1545	794	1545	\N	2026-03-08 22:37:18.991711+00
1546	794	1546	\N	2026-03-08 22:37:18.992086+00
1547	794	1547	\N	2026-03-08 22:37:18.993001+00
1548	794	1548	\N	2026-03-08 22:37:18.993816+00
1549	794	1549	\N	2026-03-08 22:37:18.994644+00
1550	794	1550	\N	2026-03-08 22:37:18.995445+00
1551	794	1551	\N	2026-03-08 22:37:18.996328+00
1552	794	1552	\N	2026-03-08 22:37:18.997057+00
1553	794	1553	\N	2026-03-08 22:37:18.997708+00
1554	794	1554	\N	2026-03-08 22:37:18.998401+00
1555	794	1555	\N	2026-03-08 22:37:18.999367+00
1556	794	1556	\N	2026-03-08 22:37:19.000288+00
1557	794	1557	\N	2026-03-08 22:37:19.001199+00
1558	794	1558	\N	2026-03-08 22:37:19.001822+00
1559	794	1559	\N	2026-03-08 22:37:19.002439+00
1560	794	1560	\N	2026-03-08 22:37:19.003043+00
1561	794	1561	\N	2026-03-08 22:37:19.003854+00
1562	794	1562	\N	2026-03-08 22:37:19.004457+00
1563	794	1563	\N	2026-03-08 22:37:19.005348+00
1564	794	1564	\N	2026-03-08 22:37:19.006329+00
1565	794	1565	\N	2026-03-08 22:37:19.007287+00
1566	794	1566	\N	2026-03-08 22:37:19.008152+00
1567	794	1567	\N	2026-03-08 22:37:19.008781+00
1568	794	1568	\N	2026-03-08 22:37:19.00937+00
1569	794	1569	\N	2026-03-08 22:37:19.009931+00
1570	2112	1570	\N	2026-03-08 22:37:19.010628+00
1571	2112	1571	\N	2026-03-08 22:37:19.011361+00
1572	2112	1572	\N	2026-03-08 22:37:19.012269+00
1573	2112	1573	\N	2026-03-08 22:37:19.012951+00
1574	2112	1574	\N	2026-03-08 22:37:19.013432+00
1575	2112	1575	\N	2026-03-08 22:37:19.013991+00
1576	2112	1576	\N	2026-03-08 22:37:19.014581+00
1577	2112	1577	\N	2026-03-08 22:37:19.014928+00
1578	2112	1578	\N	2026-03-08 22:37:19.015465+00
1579	2112	1579	\N	2026-03-08 22:37:19.016047+00
1580	2122	1580	\N	2026-03-08 22:37:19.016719+00
1581	2122	1581	\N	2026-03-08 22:37:19.017345+00
1582	2124	1582	\N	2026-03-08 22:37:19.018249+00
1583	2124	1583	\N	2026-03-08 22:37:19.018864+00
1584	2124	1584	\N	2026-03-08 22:37:19.019846+00
1585	2124	1585	\N	2026-03-08 22:37:19.020794+00
1586	2124	1586	\N	2026-03-08 22:37:19.021587+00
1587	2124	1587	\N	2026-03-08 22:37:19.022282+00
1588	2130	1588	\N	2026-03-08 22:37:19.022962+00
1589	2130	1589	\N	2026-03-08 22:37:19.023615+00
1590	2130	1590	\N	2026-03-08 22:37:19.024235+00
1591	2130	1591	\N	2026-03-08 22:37:19.024871+00
1592	2130	1592	\N	2026-03-08 22:37:19.025465+00
1593	2130	1593	\N	2026-03-08 22:37:19.026083+00
1594	2130	1594	\N	2026-03-08 22:37:19.026679+00
1595	2130	1595	\N	2026-03-08 22:37:19.02741+00
1596	2130	1596	\N	2026-03-08 22:37:19.028215+00
1597	2130	1597	\N	2026-03-08 22:37:19.02893+00
1598	2130	1598	\N	2026-03-08 22:37:19.029851+00
1599	2130	1599	\N	2026-03-08 22:37:19.030643+00
1600	2130	1600	\N	2026-03-08 22:37:19.031529+00
1601	2130	1601	\N	2026-03-08 22:37:19.032337+00
1602	2130	1602	\N	2026-03-08 22:37:19.033197+00
1603	2130	1603	\N	2026-03-08 22:37:19.034044+00
1604	2130	1604	\N	2026-03-08 22:37:19.034967+00
1605	2130	1605	\N	2026-03-08 22:37:19.035574+00
1606	2148	1606	\N	2026-03-08 22:37:19.036258+00
1607	2148	1607	\N	2026-03-08 22:37:19.036924+00
1608	2148	1608	\N	2026-03-08 22:37:19.037696+00
1609	2148	1609	\N	2026-03-08 22:37:19.038321+00
1610	2148	1610	\N	2026-03-08 22:37:19.038764+00
1611	2148	1611	\N	2026-03-08 22:37:19.039129+00
1612	2148	1612	\N	2026-03-08 22:37:19.039616+00
1613	2148	1613	\N	2026-03-08 22:37:19.040165+00
1614	2148	1614	\N	2026-03-08 22:37:19.040727+00
1615	2148	1615	\N	2026-03-08 22:37:19.041563+00
1616	2148	1616	\N	2026-03-08 22:37:19.042343+00
1617	2148	1617	\N	2026-03-08 22:37:19.042927+00
1618	2148	1618	\N	2026-03-08 22:37:19.043501+00
1619	2148	1619	\N	2026-03-08 22:37:19.044079+00
1620	2148	1620	\N	2026-03-08 22:37:19.044584+00
1621	2148	1621	\N	2026-03-08 22:37:19.044967+00
1622	2148	1622	\N	2026-03-08 22:37:19.045549+00
1623	2148	1623	\N	2026-03-08 22:37:19.046136+00
1624	2148	1624	\N	2026-03-08 22:37:19.04673+00
1625	2148	1625	\N	2026-03-08 22:37:19.047688+00
1626	2148	1626	\N	2026-03-08 22:37:19.048361+00
1627	2148	1627	\N	2026-03-08 22:37:19.04933+00
1628	2148	1628	\N	2026-03-08 22:37:19.049909+00
1629	2148	1629	\N	2026-03-08 22:37:19.050488+00
1630	2148	1630	\N	2026-03-08 22:37:19.051052+00
1631	2148	1631	\N	2026-03-08 22:37:19.051581+00
1632	2148	1632	\N	2026-03-08 22:37:19.052004+00
1633	2148	1633	\N	2026-03-08 22:37:19.052606+00
1634	2148	1634	\N	2026-03-08 22:37:19.053231+00
1635	2148	1635	\N	2026-03-08 22:37:19.053864+00
1636	2148	1636	\N	2026-03-08 22:37:19.054695+00
1637	2148	1637	\N	2026-03-08 22:37:19.05534+00
1638	2180	1638	\N	2026-03-08 22:37:19.055945+00
1639	2181	1639	\N	2026-03-08 22:37:19.056748+00
1640	2182	1640	\N	2026-03-08 22:37:19.057554+00
1641	2180	1641	\N	2026-03-08 22:37:19.058386+00
1642	2181	1642	\N	2026-03-08 22:37:19.059188+00
1643	2182	1643	\N	2026-03-08 22:37:19.059965+00
1644	2180	1644	\N	2026-03-08 22:37:19.060682+00
1645	2181	1645	\N	2026-03-08 22:37:19.061156+00
1646	2182	1646	\N	2026-03-08 22:37:19.061734+00
1647	2180	1647	\N	2026-03-08 22:37:19.062319+00
1648	2181	1648	\N	2026-03-08 22:37:19.062869+00
1649	2182	1649	\N	2026-03-08 22:37:19.063449+00
1650	2180	1650	\N	2026-03-08 22:37:19.064009+00
1651	2181	1651	\N	2026-03-08 22:37:19.064795+00
1652	2182	1652	\N	2026-03-08 22:37:19.065463+00
1653	2180	1653	\N	2026-03-08 22:37:19.06597+00
1654	2181	1654	\N	2026-03-08 22:37:19.066732+00
1655	2182	1655	\N	2026-03-08 22:37:19.067605+00
1656	2180	1656	\N	2026-03-08 22:37:19.068449+00
1657	2181	1657	\N	2026-03-08 22:37:19.069021+00
1658	2182	1658	\N	2026-03-08 22:37:19.069606+00
1659	164	1659	\N	2026-03-08 22:37:19.070154+00
1660	164	1660	\N	2026-03-08 22:37:19.070991+00
1661	164	1661	\N	2026-03-08 22:37:19.071508+00
1662	164	1662	\N	2026-03-08 22:37:19.071849+00
1663	164	1663	\N	2026-03-08 22:37:19.072543+00
1664	164	1664	\N	2026-03-08 22:37:19.073343+00
1665	164	1665	\N	2026-03-08 22:37:19.074193+00
1666	164	1666	\N	2026-03-08 22:37:19.074934+00
1667	164	1667	\N	2026-03-08 22:37:19.075716+00
1668	1789	133	\N	2026-03-08 22:37:19.076463+00
1669	2148	1669	\N	2026-03-08 22:37:19.076926+00
1670	2148	1670	\N	2026-03-08 22:37:19.077497+00
1671	2148	1671	\N	2026-03-08 22:37:19.07824+00
1672	2148	1672	\N	2026-03-08 22:37:19.079064+00
1673	2148	1673	\N	2026-03-08 22:37:19.079685+00
1674	2148	1674	\N	2026-03-08 22:37:19.080491+00
1675	2148	1675	\N	2026-03-08 22:37:19.081398+00
1676	2218	625	\N	2026-03-08 22:37:19.081985+00
1677	2219	1677	\N	2026-03-08 22:37:19.082674+00
1678	864	1678	\N	2026-03-08 22:37:19.08324+00
1679	864	1679	\N	2026-03-08 22:37:19.08382+00
1680	864	1680	\N	2026-03-08 22:37:19.08435+00
1681	2223	1681	\N	2026-03-08 22:37:19.084954+00
1682	1052	1682	\N	2026-03-08 22:37:19.085396+00
1683	1052	1683	\N	2026-03-08 22:37:19.085821+00
1684	1052	1684	\N	2026-03-08 22:37:19.086243+00
1685	1052	1685	\N	2026-03-08 22:37:19.086682+00
1686	2228	1686	\N	2026-03-08 22:37:19.087232+00
1687	1052	1687	\N	2026-03-08 22:37:19.087878+00
1688	1052	1688	\N	2026-03-08 22:37:19.088449+00
1689	1052	1689	\N	2026-03-08 22:37:19.089017+00
1690	1052	1690	\N	2026-03-08 22:37:19.089609+00
1691	2233	1691	\N	2026-03-08 22:37:19.090299+00
1692	2233	1692	\N	2026-03-08 22:37:19.090839+00
1693	2233	1693	\N	2026-03-08 22:37:19.091488+00
1694	2233	1694	\N	2026-03-08 22:37:19.092144+00
1695	2237	1695	\N	2026-03-08 22:37:19.093071+00
1696	2237	1696	\N	2026-03-08 22:37:19.09368+00
1697	2233	1697	\N	2026-03-08 22:37:19.094353+00
1698	2233	1698	\N	2026-03-08 22:37:19.09502+00
1699	2237	1699	\N	2026-03-08 22:37:19.095692+00
1700	2237	1700	\N	2026-03-08 22:37:19.096436+00
1701	2233	1701	\N	2026-03-08 22:37:19.097218+00
1702	2233	1702	\N	2026-03-08 22:37:19.097906+00
1703	2245	1703	\N	2026-03-08 22:37:19.098718+00
1704	2245	1704	\N	2026-03-08 22:37:19.099691+00
1705	2038	1705	\N	2026-03-08 22:37:19.100272+00
1706	2038	1706	\N	2026-03-08 22:37:19.100831+00
1707	2038	1707	\N	2026-03-08 22:37:19.101417+00
1708	2245	1708	\N	2026-03-08 22:37:19.101991+00
1709	2245	1709	\N	2026-03-08 22:37:19.102565+00
1710	2038	1710	\N	2026-03-08 22:37:19.103362+00
1711	2245	1711	\N	2026-03-08 22:37:19.103966+00
1712	2254	1712	\N	2026-03-08 22:37:19.104669+00
1713	2048	1713	\N	2026-03-08 22:37:19.105209+00
1714	2048	1714	\N	2026-03-08 22:37:19.105596+00
1715	2257	1715	\N	2026-03-08 22:37:19.106034+00
1716	2257	1716	\N	2026-03-08 22:37:19.106641+00
1717	2228	1717	\N	2026-03-08 22:37:19.107239+00
1718	2228	1718	\N	2026-03-08 22:37:19.107846+00
1719	2228	1719	\N	2026-03-08 22:37:19.108413+00
1720	2228	1720	\N	2026-03-08 22:37:19.108824+00
1721	1052	1721	\N	2026-03-08 22:37:19.109208+00
1722	2264	1722	\N	2026-03-08 22:37:19.109637+00
1723	2264	1723	\N	2026-03-08 22:37:19.110083+00
1724	2266	1724	\N	2026-03-08 22:37:19.11069+00
1725	2267	1725	\N	2026-03-08 22:37:19.111151+00
1726	2267	1726	\N	2026-03-08 22:37:19.111715+00
1727	2269	1727	\N	2026-03-08 22:37:19.112254+00
1728	2270	1501	\N	2026-03-08 22:37:19.112898+00
1729	2271	1729	\N	2026-03-08 22:37:19.113683+00
1730	2271	1730	\N	2026-03-08 22:37:19.114328+00
1731	2273	1731	\N	2026-03-08 22:37:19.115078+00
1732	543	1732	\N	2026-03-08 22:37:19.11566+00
1733	543	1733	\N	2026-03-08 22:37:19.11625+00
1734	2276	1734	\N	2026-03-08 22:37:19.116919+00
1735	2276	1735	\N	2026-03-08 22:37:19.117497+00
1736	2276	1736	\N	2026-03-08 22:37:19.118149+00
1737	2279	1737	\N	2026-03-08 22:37:19.118648+00
1738	2279	1738	\N	2026-03-08 22:37:19.119381+00
1739	2279	1739	\N	2026-03-08 22:37:19.11999+00
1740	2282	1740	\N	2026-03-08 22:37:19.120705+00
1741	2282	1741	\N	2026-03-08 22:37:19.121389+00
1742	2282	1742	\N	2026-03-08 22:37:19.122219+00
1743	688	1743	\N	2026-03-08 22:37:19.122824+00
1744	688	1744	\N	2026-03-08 22:37:19.123417+00
1745	688	1745	\N	2026-03-08 22:37:19.123938+00
1746	2050	1746	\N	2026-03-08 22:37:19.124376+00
1747	2050	1747	\N	2026-03-08 22:37:19.125112+00
1748	2050	1748	\N	2026-03-08 22:37:19.125951+00
1749	2050	1749	\N	2026-03-08 22:37:19.126666+00
1750	2050	1750	\N	2026-03-08 22:37:19.12733+00
1751	2050	1751	\N	2026-03-08 22:37:19.127949+00
1752	2050	1752	\N	2026-03-08 22:37:19.128566+00
1753	2295	1500	\N	2026-03-08 22:37:19.129183+00
1754	2295	1754	\N	2026-03-08 22:37:19.129776+00
1755	2295	1755	\N	2026-03-08 22:37:19.13036+00
1756	2295	1504	\N	2026-03-08 22:37:19.130916+00
1757	2295	1757	\N	2026-03-08 22:37:19.131342+00
1758	2295	1503	\N	2026-03-08 22:37:19.131742+00
1759	2295	1759	\N	2026-03-08 22:37:19.132258+00
1760	2302	1760	\N	2026-03-08 22:37:19.132861+00
1761	2302	1761	\N	2026-03-08 22:37:19.13344+00
1762	2302	1762	\N	2026-03-08 22:37:19.134017+00
1763	2305	1763	\N	2026-03-08 22:37:19.134694+00
1764	688	1764	\N	2026-03-08 22:37:19.135293+00
1765	2307	1764	\N	2026-03-08 22:37:19.135919+00
1766	688	1766	\N	2026-03-08 22:37:19.136644+00
1767	688	1767	\N	2026-03-08 22:37:19.137317+00
1768	688	1768	\N	2026-03-08 22:37:19.137908+00
1769	688	1769	\N	2026-03-08 22:37:19.138848+00
1770	688	1770	\N	2026-03-08 22:37:19.139412+00
1771	688	1771	\N	2026-03-08 22:37:19.140233+00
1772	688	1772	\N	2026-03-08 22:37:19.14108+00
1773	688	1773	\N	2026-03-08 22:37:19.141885+00
1775	2317	1775	\N	2026-03-08 22:37:19.142937+00
1776	2318	1776	\N	2026-03-08 22:37:19.143577+00
1777	2033	1777	\N	2026-03-08 22:37:19.144166+00
1778	2320	1778	\N	2026-03-08 22:37:19.144818+00
1779	2050	1779	\N	2026-03-08 22:37:19.145591+00
1780	537	1780	\N	2026-03-08 22:37:19.146315+00
1781	537	1781	\N	2026-03-08 22:37:19.147268+00
1782	537	1782	\N	2026-03-08 22:37:19.147926+00
1783	537	1783	\N	2026-03-08 22:37:19.148606+00
1784	537	1784	\N	2026-03-08 22:37:19.149063+00
1785	537	1785	\N	2026-03-08 22:37:19.149496+00
1786	537	1786	\N	2026-03-08 22:37:19.150087+00
1787	537	1787	\N	2026-03-08 22:37:19.150888+00
1788	537	1788	\N	2026-03-08 22:37:19.151511+00
1789	537	1789	\N	2026-03-08 22:37:19.152338+00
1790	537	1790	\N	2026-03-08 22:37:19.152894+00
1791	537	1791	\N	2026-03-08 22:37:19.153672+00
1792	537	1792	\N	2026-03-08 22:37:19.155241+00
1793	537	1793	\N	2026-03-08 22:37:19.155743+00
1794	537	1794	\N	2026-03-08 22:37:19.156157+00
1795	537	1795	\N	2026-03-08 22:37:19.156548+00
1796	537	1796	\N	2026-03-08 22:37:19.156951+00
1797	537	1797	\N	2026-03-08 22:37:19.157724+00
1798	537	1798	\N	2026-03-08 22:37:19.158582+00
1799	537	1799	\N	2026-03-08 22:37:19.15919+00
1800	537	1800	\N	2026-03-08 22:37:19.159675+00
1801	537	1801	\N	2026-03-08 22:37:19.16005+00
1802	537	1802	\N	2026-03-08 22:37:19.160467+00
1803	537	1803	\N	2026-03-08 22:37:19.160805+00
1804	537	1804	\N	2026-03-08 22:37:19.161356+00
1805	537	1805	\N	2026-03-08 22:37:19.161982+00
1806	537	1806	\N	2026-03-08 22:37:19.16361+00
1807	537	1807	\N	2026-03-08 22:37:19.16425+00
1808	537	1808	\N	2026-03-08 22:37:19.164933+00
1809	537	1809	\N	2026-03-08 22:37:19.16556+00
1810	537	1810	\N	2026-03-08 22:37:19.166232+00
1811	537	1811	\N	2026-03-08 22:37:19.16681+00
1812	537	1812	\N	2026-03-08 22:37:19.167411+00
1813	537	1813	\N	2026-03-08 22:37:19.168058+00
1814	537	1814	\N	2026-03-08 22:37:19.168637+00
1815	537	1815	\N	2026-03-08 22:37:19.169241+00
1816	537	1816	\N	2026-03-08 22:37:19.170266+00
1817	537	1817	\N	2026-03-08 22:37:19.171098+00
1818	537	1818	\N	2026-03-08 22:37:19.171568+00
1819	537	1819	\N	2026-03-08 22:37:19.171979+00
1820	537	1820	\N	2026-03-08 22:37:19.172564+00
1821	537	1821	\N	2026-03-08 22:37:19.173165+00
1822	537	1822	\N	2026-03-08 22:37:19.173732+00
1823	537	1823	\N	2026-03-08 22:37:19.174316+00
1824	537	1824	\N	2026-03-08 22:37:19.174945+00
1825	537	1825	\N	2026-03-08 22:37:19.175515+00
1826	537	1826	\N	2026-03-08 22:37:19.176076+00
1827	537	1827	\N	2026-03-08 22:37:19.176854+00
1828	537	1828	\N	2026-03-08 22:37:19.177408+00
1829	537	1829	\N	2026-03-08 22:37:19.17798+00
1830	537	1830	\N	2026-03-08 22:37:19.178441+00
1831	537	1831	\N	2026-03-08 22:37:19.179102+00
1832	537	1832	\N	2026-03-08 22:37:19.179948+00
1833	537	1833	\N	2026-03-08 22:37:19.180878+00
1834	537	1834	\N	2026-03-08 22:37:19.181697+00
1835	537	1835	\N	2026-03-08 22:37:19.182436+00
1836	537	1836	\N	2026-03-08 22:37:19.183227+00
1837	537	1837	\N	2026-03-08 22:37:19.183755+00
1838	537	1838	\N	2026-03-08 22:37:19.184227+00
1839	537	1839	\N	2026-03-08 22:37:19.184866+00
1840	537	1840	\N	2026-03-08 22:37:19.185398+00
1841	537	1841	\N	2026-03-08 22:37:19.185982+00
1842	537	1842	\N	2026-03-08 22:37:19.186564+00
1843	537	1843	\N	2026-03-08 22:37:19.187296+00
1844	537	1844	\N	2026-03-08 22:37:19.188038+00
1845	537	1845	\N	2026-03-08 22:37:19.188691+00
1846	537	1846	\N	2026-03-08 22:37:19.189274+00
1847	537	1847	\N	2026-03-08 22:37:19.189851+00
1848	537	1848	\N	2026-03-08 22:37:19.19043+00
1849	537	1849	\N	2026-03-08 22:37:19.191011+00
1850	537	1850	\N	2026-03-08 22:37:19.191602+00
1851	537	1851	\N	2026-03-08 22:37:19.192179+00
1852	537	1852	\N	2026-03-08 22:37:19.192732+00
1853	537	1853	\N	2026-03-08 22:37:19.193263+00
1854	537	1854	\N	2026-03-08 22:37:19.193707+00
1855	537	1855	\N	2026-03-08 22:37:19.194164+00
1856	537	1856	\N	2026-03-08 22:37:19.195309+00
1857	537	1857	\N	2026-03-08 22:37:19.196172+00
1858	537	1858	\N	2026-03-08 22:37:19.196968+00
1859	537	1859	\N	2026-03-08 22:37:19.19776+00
1860	537	1860	\N	2026-03-08 22:37:19.198545+00
1862	225	1862	\N	2026-03-08 22:37:19.199725+00
1863	268	1863	\N	2026-03-08 22:37:19.200299+00
1864	2406	1864	\N	2026-03-08 22:37:19.201014+00
1865	465	1865	\N	2026-03-08 22:37:19.201795+00
1866	465	1866	\N	2026-03-08 22:37:19.202652+00
1867	525	1867	\N	2026-03-08 22:37:19.203623+00
1868	688	1868	\N	2026-03-08 22:37:19.20452+00
1869	688	1869	\N	2026-03-08 22:37:19.205327+00
1870	688	1870	\N	2026-03-08 22:37:19.206156+00
1871	688	1871	\N	2026-03-08 22:37:19.206961+00
1872	688	1872	\N	2026-03-08 22:37:19.207762+00
1873	806	1873	\N	2026-03-08 22:37:19.208368+00
1875	918	1875	\N	2026-03-08 22:37:19.209697+00
1876	1200	1876	\N	2026-03-08 22:37:19.210542+00
1877	244	1877	\N	2026-03-08 22:37:19.211139+00
1878	1	1878	\N	2026-03-08 22:37:19.211763+00
1879	1	1879	\N	2026-03-08 22:37:19.212392+00
1880	1	1880	\N	2026-03-08 22:37:19.212813+00
1881	1	1881	\N	2026-03-08 22:37:19.213562+00
1882	4	1882	\N	2026-03-08 22:37:19.214644+00
1883	1517	1883	\N	2026-03-08 22:37:19.21546+00
1884	1517	1884	\N	2026-03-08 22:37:19.216309+00
1885	1456	1885	\N	2026-03-08 22:37:19.217099+00
1886	1456	1886	\N	2026-03-08 22:37:19.217916+00
1887	1594	1887	\N	2026-03-08 22:37:19.218468+00
1888	1602	1888	\N	2026-03-08 22:37:19.219258+00
1889	1702	1889	\N	2026-03-08 22:37:19.220084+00
1890	1702	1890	\N	2026-03-08 22:37:19.220923+00
1891	158	1891	\N	2026-03-08 22:37:19.221518+00
1892	2406	1863	\N	2026-03-08 22:37:19.222073+00
1893	2435	1893	\N	2026-03-08 22:37:19.222844+00
1894	543	1894	\N	2026-03-08 22:37:19.223678+00
1895	806	1895	\N	2026-03-08 22:37:19.224248+00
1896	2438	1896	\N	2026-03-08 22:37:19.224926+00
1897	2439	1897	\N	2026-03-08 22:37:19.225776+00
1898	1517	1898	\N	2026-03-08 22:37:19.226345+00
1899	1676	1899	\N	2026-03-08 22:37:19.227159+00
1900	543	1869	\N	2026-03-08 22:37:19.227908+00
1901	2443	1901	\N	2026-03-08 22:37:19.228632+00
1902	1200	1902	\N	2026-03-08 22:37:19.229411+00
1903	1200	1903	\N	2026-03-08 22:37:19.230241+00
1904	1602	1904	\N	2026-03-08 22:37:19.230822+00
1905	688	1905	\N	2026-03-08 22:37:19.231448+00
1906	688	1906	\N	2026-03-08 22:37:19.232269+00
1907	688	1907	\N	2026-03-08 22:37:19.232926+00
1908	688	1908	\N	2026-03-08 22:37:19.233301+00
1909	806	1909	\N	2026-03-08 22:37:19.233799+00
1910	158	1910	\N	2026-03-08 22:37:19.234259+00
1911	163	1911	\N	2026-03-08 22:37:19.23509+00
1913	173	1913	\N	2026-03-08 22:37:19.2365+00
1914	182	1914	\N	2026-03-08 22:37:19.237529+00
1915	2033	1915	\N	2026-03-08 22:37:19.238413+00
1916	204	1916	\N	2026-03-08 22:37:19.238932+00
1917	2459	1917	\N	2026-03-08 22:37:19.239831+00
1920	225	1920	\N	2026-03-08 22:37:19.241072+00
1921	225	1901	\N	2026-03-08 22:37:19.241692+00
1922	2464	1922	\N	2026-03-08 22:37:19.242407+00
1923	2464	1923	\N	2026-03-08 22:37:19.243074+00
1924	2466	1924	\N	2026-03-08 22:37:19.24371+00
1925	268	1925	\N	2026-03-08 22:37:19.244299+00
1926	268	1926	\N	2026-03-08 22:37:19.245204+00
1927	268	1927	\N	2026-03-08 22:37:19.245998+00
1928	268	1928	\N	2026-03-08 22:37:19.246792+00
1929	268	1929	\N	2026-03-08 22:37:19.247541+00
1930	268	1930	\N	2026-03-08 22:37:19.248448+00
1931	268	1931	\N	2026-03-08 22:37:19.248975+00
1932	268	1896	\N	2026-03-08 22:37:19.249667+00
1933	2406	1933	\N	2026-03-08 22:37:19.250366+00
1934	2406	1934	\N	2026-03-08 22:37:19.251156+00
1935	2406	1935	\N	2026-03-08 22:37:19.251851+00
1936	2406	1936	\N	2026-03-08 22:37:19.252538+00
1937	2406	1937	\N	2026-03-08 22:37:19.253067+00
1938	94	1938	\N	2026-03-08 22:37:19.253937+00
1939	94	1939	\N	2026-03-08 22:37:19.255095+00
1940	94	1940	\N	2026-03-08 22:37:19.255606+00
1941	94	1941	\N	2026-03-08 22:37:19.256358+00
1942	94	1942	\N	2026-03-08 22:37:19.25722+00
1943	94	1943	\N	2026-03-08 22:37:19.257981+00
1944	94	1944	\N	2026-03-08 22:37:19.258671+00
1945	1018	1945	\N	2026-03-08 22:37:19.259179+00
1946	350	1946	\N	2026-03-08 22:37:19.259733+00
1947	350	1947	\N	2026-03-08 22:37:19.260432+00
1948	350	1948	\N	2026-03-08 22:37:19.261201+00
1949	350	1949	\N	2026-03-08 22:37:19.261894+00
1950	350	1950	\N	2026-03-08 22:37:19.262609+00
1951	350	1951	\N	2026-03-08 22:37:19.263139+00
1952	350	1952	\N	2026-03-08 22:37:19.263851+00
1953	350	1953	\N	2026-03-08 22:37:19.264322+00
1954	350	1954	\N	2026-03-08 22:37:19.265246+00
1955	416	1955	\N	2026-03-08 22:37:19.265985+00
1956	465	1956	\N	2026-03-08 22:37:19.266725+00
1957	465	1957	\N	2026-03-08 22:37:19.267311+00
1958	465	1958	\N	2026-03-08 22:37:19.26789+00
1959	465	1959	\N	2026-03-08 22:37:19.268582+00
1960	537	1960	\N	2026-03-08 22:37:19.269246+00
1961	539	1899	\N	2026-03-08 22:37:19.270069+00
1962	543	1962	\N	2026-03-08 22:37:19.270725+00
1963	543	1868	\N	2026-03-08 22:37:19.271382+00
1964	2016	1964	\N	2026-03-08 22:37:19.272069+00
1965	2016	1965	\N	2026-03-08 22:37:19.272759+00
1966	2508	1966	\N	2026-03-08 22:37:19.273612+00
1967	688	1967	\N	2026-03-08 22:37:19.27442+00
1968	688	1968	\N	2026-03-08 22:37:19.275124+00
1969	688	1969	\N	2026-03-08 22:37:19.27579+00
1970	688	1970	\N	2026-03-08 22:37:19.27646+00
1971	688	1971	\N	2026-03-08 22:37:19.276961+00
1972	688	1733	\N	2026-03-08 22:37:19.277569+00
1973	688	1973	\N	2026-03-08 22:37:19.27815+00
1974	688	1974	\N	2026-03-08 22:37:19.27923+00
1975	688	1975	\N	2026-03-08 22:37:19.280076+00
1976	688	1976	\N	2026-03-08 22:37:19.280857+00
1977	688	1977	\N	2026-03-08 22:37:19.281624+00
1978	688	1978	\N	2026-03-08 22:37:19.282365+00
1979	688	1979	\N	2026-03-08 22:37:19.283036+00
1980	688	1980	\N	2026-03-08 22:37:19.283748+00
1981	688	1981	\N	2026-03-08 22:37:19.284236+00
1982	688	1982	\N	2026-03-08 22:37:19.284943+00
1983	688	1983	\N	2026-03-08 22:37:19.28565+00
1984	688	1984	\N	2026-03-08 22:37:19.286324+00
1985	2527	1985	\N	2026-03-08 22:37:19.287075+00
1986	796	1986	\N	2026-03-08 22:37:19.287636+00
1987	796	1987	\N	2026-03-08 22:37:19.288225+00
1988	806	1988	\N	2026-03-08 22:37:19.288775+00
1989	806	1989	\N	2026-03-08 22:37:19.289401+00
1990	806	1990	\N	2026-03-08 22:37:19.290288+00
1992	864	1992	\N	2026-03-08 22:37:19.291524+00
1993	864	1993	\N	2026-03-08 22:37:19.292013+00
1994	918	1994	\N	2026-03-08 22:37:19.292488+00
1995	918	1995	\N	2026-03-08 22:37:19.293213+00
1996	918	1996	\N	2026-03-08 22:37:19.293921+00
1997	984	1997	\N	2026-03-08 22:37:19.294653+00
1998	984	1998	\N	2026-03-08 22:37:19.295479+00
1999	984	1999	\N	2026-03-08 22:37:19.296339+00
2000	997	2000	\N	2026-03-08 22:37:19.29693+00
2001	997	2001	\N	2026-03-08 22:37:19.297494+00
2002	997	2002	\N	2026-03-08 22:37:19.298065+00
2003	2545	2003	\N	2026-03-08 22:37:19.298553+00
2004	2438	2004	\N	2026-03-08 22:37:19.299188+00
2005	1044	2005	\N	2026-03-08 22:37:19.299876+00
2006	2548	2006	\N	2026-03-08 22:37:19.300677+00
2007	1091	2007	\N	2026-03-08 22:37:19.301162+00
2008	1091	2008	\N	2026-03-08 22:37:19.301882+00
2009	1091	2009	\N	2026-03-08 22:37:19.302449+00
2010	1091	2010	\N	2026-03-08 22:37:19.302944+00
2011	1091	2011	\N	2026-03-08 22:37:19.30388+00
2012	1179	2012	\N	2026-03-08 22:37:19.304609+00
2013	2555	2013	\N	2026-03-08 22:37:19.305408+00
2014	1192	2014	\N	2026-03-08 22:37:19.306074+00
2015	1200	2015	\N	2026-03-08 22:37:19.306771+00
2016	244	2016	\N	2026-03-08 22:37:19.307273+00
2017	1	2017	\N	2026-03-08 22:37:19.307977+00
2018	1	2018	\N	2026-03-08 22:37:19.308705+00
2019	1	2019	\N	2026-03-08 22:37:19.309338+00
2020	1	2020	\N	2026-03-08 22:37:19.310022+00
2021	1	2021	\N	2026-03-08 22:37:19.310513+00
2022	1	2022	\N	2026-03-08 22:37:19.311202+00
2023	1	2023	\N	2026-03-08 22:37:19.311883+00
2024	1	2024	\N	2026-03-08 22:37:19.312568+00
2025	1	2025	\N	2026-03-08 22:37:19.313258+00
2026	4	2026	\N	2026-03-08 22:37:19.31389+00
2027	4	2027	\N	2026-03-08 22:37:19.314461+00
2028	1517	2028	\N	2026-03-08 22:37:19.315024+00
2029	1517	2029	\N	2026-03-08 22:37:19.315735+00
2030	1517	2030	\N	2026-03-08 22:37:19.316382+00
2031	2573	2031	\N	2026-03-08 22:37:19.317163+00
2032	1456	2032	\N	2026-03-08 22:37:19.317648+00
2033	1463	2033	\N	2026-03-08 22:37:19.318357+00
2034	1463	2034	\N	2026-03-08 22:37:19.318871+00
2035	1463	2035	\N	2026-03-08 22:37:19.319365+00
2036	1463	2036	\N	2026-03-08 22:37:19.319898+00
2037	1517	2037	\N	2026-03-08 22:37:19.320454+00
2038	1517	2038	\N	2026-03-08 22:37:19.321189+00
2039	1517	2039	\N	2026-03-08 22:37:19.321703+00
2040	1602	2040	\N	2026-03-08 22:37:19.32218+00
2041	1602	2041	\N	2026-03-08 22:37:19.32267+00
2042	1602	2042	\N	2026-03-08 22:37:19.323171+00
2043	1676	2043	\N	2026-03-08 22:37:19.323603+00
2044	1702	2044	\N	2026-03-08 22:37:19.324326+00
2045	1702	2045	\N	2026-03-08 22:37:19.325189+00
2046	1702	2046	\N	2026-03-08 22:37:19.325918+00
2047	1702	2047	\N	2026-03-08 22:37:19.326588+00
2048	1702	2048	\N	2026-03-08 22:37:19.327263+00
2049	1702	2049	\N	2026-03-08 22:37:19.327629+00
2051	1734	2051	\N	2026-03-08 22:37:19.328415+00
2052	1734	2052	\N	2026-03-08 22:37:19.328932+00
2053	94	2053	\N	2026-03-08 22:37:19.329325+00
2054	1	2054	\N	2026-03-08 22:37:19.330001+00
2055	2597	2055	\N	2026-03-08 22:37:19.330868+00
2056	2598	1872	\N	2026-03-08 22:37:19.331357+00
2057	350	2057	\N	2026-03-08 22:37:19.331929+00
2058	350	2058	\N	2026-03-08 22:37:19.3327+00
2060	1091	2060	\N	2026-03-08 22:37:19.333492+00
2061	2603	2061	\N	2026-03-08 22:37:19.334154+00
2062	268	2062	\N	2026-03-08 22:37:19.334862+00
2063	2603	2063	\N	2026-03-08 22:37:19.335592+00
2064	2603	1968	\N	2026-03-08 22:37:19.336189+00
2065	2603	1660	\N	2026-03-08 22:37:19.336812+00
2066	2603	2066	\N	2026-03-08 22:37:19.337522+00
2067	2603	2067	\N	2026-03-08 22:37:19.338061+00
2068	2603	1998	\N	2026-03-08 22:37:19.33846+00
2069	1463	2069	\N	2026-03-08 22:37:19.33895+00
2070	2603	2070	\N	2026-03-08 22:37:19.339329+00
2071	2603	2071	\N	2026-03-08 22:37:19.339954+00
2072	2603	2072	\N	2026-03-08 22:37:19.340679+00
2073	2603	2073	\N	2026-03-08 22:37:19.341542+00
2074	94	2074	\N	2026-03-08 22:37:19.342323+00
2075	2603	1916	\N	2026-03-08 22:37:19.34274+00
2076	2603	2076	\N	2026-03-08 22:37:19.343344+00
2078	2603	2078	\N	2026-03-08 22:37:19.344376+00
2079	2603	2079	\N	2026-03-08 22:37:19.345272+00
2080	2603	2080	\N	2026-03-08 22:37:19.346136+00
2081	94	2081	\N	2026-03-08 22:37:19.347058+00
2082	2603	2082	\N	2026-03-08 22:37:19.347861+00
2083	806	2083	\N	2026-03-08 22:37:19.348496+00
2084	997	2084	\N	2026-03-08 22:37:19.349035+00
2085	1200	2085	\N	2026-03-08 22:37:19.349401+00
2086	1200	2086	\N	2026-03-08 22:37:19.350011+00
2087	2603	1406	\N	2026-03-08 22:37:19.350663+00
2088	1517	2088	\N	2026-03-08 22:37:19.351345+00
2089	2603	2089	\N	2026-03-08 22:37:19.352098+00
2090	1517	2090	\N	2026-03-08 22:37:19.352838+00
2091	1	2091	\N	2026-03-08 22:37:19.353679+00
2092	688	2092	\N	2026-03-08 22:37:19.354555+00
2093	543	2093	\N	2026-03-08 22:37:19.355114+00
2094	225	2094	\N	2026-03-08 22:37:19.355614+00
\.


--
-- Data for Name: stems; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.stems (id, stem_category, stem_subcategory, created_at) FROM stdin;
1	rose	\N	2026-03-08 22:37:17.840989+00
4	rose	garden	2026-03-08 22:37:17.853068+00
94	carnation	\N	2026-03-08 22:37:17.936219+00
158	acacia	\N	2026-03-08 22:37:17.973905+00
163	allium	\N	2026-03-08 22:37:17.977546+00
164	amaranthus	\N	2026-03-08 22:37:17.978202+00
173	anemone	\N	2026-03-08 22:37:17.980155+00
182	anthurium	\N	2026-03-08 22:37:17.983471+00
204	aster	\N	2026-03-08 22:37:18.014146+00
221	astrantia	\N	2026-03-08 22:37:18.035494+00
225	baby's breath	\N	2026-03-08 22:37:18.037883+00
232	bells of ireland	\N	2026-03-08 22:37:18.04455+00
234	berry black navajo 40/60cm chi	\N	2026-03-08 22:37:18.046627+00
235	berry date palm green 5stm	\N	2026-03-08 22:37:18.047213+00
236	berzelia	\N	2026-03-08 22:37:18.049137+00
239	bird of paradise	\N	2026-03-08 22:37:18.053171+00
240	bouquet tropical	\N	2026-03-08 22:37:18.055602+00
242	branch kiwi vine	\N	2026-03-08 22:37:18.0576+00
243	branch sumac	\N	2026-03-08 22:37:18.05808+00
244	ranunculus	butterfly	2026-03-08 22:37:18.060088+00
266	calendula	\N	2026-03-08 22:37:18.077484+00
268	calla	\N	2026-03-08 22:37:18.079422+00
281	calla lily	\N	2026-03-08 22:37:18.085891+00
286	calla lily mini	\N	2026-03-08 22:37:18.091297+00
293	calla mini	\N	2026-03-08 22:37:18.095062+00
294	campanula	\N	2026-03-08 22:37:18.09537+00
350	chrysanthemum	\N	2026-03-08 22:37:18.113159+00
415	chysanth	\N	2026-03-08 22:37:18.141653+00
416	clematis	\N	2026-03-08 22:37:18.142035+00
421	coontie fern	\N	2026-03-08 22:37:18.143946+00
422	cornflower	\N	2026-03-08 22:37:18.144192+00
423	cosmos	\N	2026-03-08 22:37:18.144533+00
424	craspedia	\N	2026-03-08 22:37:18.145266+00
425	cremon	\N	2026-03-08 22:37:18.145587+00
438	curly willow	\N	2026-03-08 22:37:18.147906+00
440	cymbidium	\N	2026-03-08 22:37:18.149373+00
452	daffodil	\N	2026-03-08 22:37:18.155326+00
455	dahila	\N	2026-03-08 22:37:18.156943+00
461	dahlia	\N	2026-03-08 22:37:18.158694+00
465	delphinium	\N	2026-03-08 22:37:18.161427+00
473	delphinum	\N	2026-03-08 22:37:18.16292+00
502	dendrobium	\N	2026-03-08 22:37:18.177501+00
525	dianthus	\N	2026-03-08 22:37:18.18932+00
537	dried	\N	2026-03-08 22:37:18.195652+00
538	equisetum rush	\N	2026-03-08 22:37:18.19585+00
539	eryngium	\N	2026-03-08 22:37:18.196048+00
543	eucalyptus	\N	2026-03-08 22:37:18.196785+00
565	euonymous variegated	\N	2026-03-08 22:37:18.205201+00
566	evergreen	\N	2026-03-08 22:37:18.205501+00
575	foxglove	\N	2026-03-08 22:37:18.208008+00
576	freesia	\N	2026-03-08 22:37:18.208298+00
584	french tulip	\N	2026-03-08 22:37:18.21086+00
607	garden spray rose	\N	2026-03-08 22:37:18.21945+00
609	gardenia foliage	\N	2026-03-08 22:37:18.22093+00
610	gardenia white	\N	2026-03-08 22:37:18.221571+00
611	gerbera	\N	2026-03-08 22:37:18.221937+00
673	ginesta	\N	2026-03-08 22:37:18.252869+00
677	ginger	\N	2026-03-08 22:37:18.255002+00
682	gladiolus	\N	2026-03-08 22:37:18.257035+00
687	gomphrena	\N	2026-03-08 22:37:18.25813+00
688	greenery	\N	2026-03-08 22:37:18.258642+00
791	grevillea	\N	2026-03-08 22:37:18.304846+00
793	heather	\N	2026-03-08 22:37:18.305772+00
794	heliconia	\N	2026-03-08 22:37:18.306544+00
795	hellebores	\N	2026-03-08 22:37:18.30742+00
796	helleborus	\N	2026-03-08 22:37:18.307717+00
803	herb lavendder	\N	2026-03-08 22:37:18.312192+00
804	hyacinth	\N	2026-03-08 22:37:18.312551+00
806	hydrangea	\N	2026-03-08 22:37:18.314207+00
864	hypericum	\N	2026-03-08 22:37:18.355498+00
885	iris	\N	2026-03-08 22:37:18.365466+00
890	ivy	\N	2026-03-08 22:37:18.367976+00
891	kale	\N	2026-03-08 22:37:18.368524+00
892	larkspur	\N	2026-03-08 22:37:18.369242+00
907	leptospermum	\N	2026-03-08 22:37:18.377949+00
910	leucadendron	\N	2026-03-08 22:37:18.378605+00
913	leucocoryne	\N	2026-03-08 22:37:18.38022+00
914	liatris	\N	2026-03-08 22:37:18.380803+00
917	lilac	\N	2026-03-08 22:37:18.382066+00
918	lily	\N	2026-03-08 22:37:18.382377+00
982	lily hybrid	\N	2026-03-08 22:37:18.414647+00
984	limonium	\N	2026-03-08 22:37:18.415109+00
997	lisianthus	\N	2026-03-08 22:37:18.418699+00
1017	marigold	\N	2026-03-08 22:37:18.426153+00
1018	carnation	mini	2026-03-08 22:37:18.42645+00
1037	nigella	\N	2026-03-08 22:37:18.432062+00
1043	oncidium	\N	2026-03-08 22:37:18.434508+00
1044	orchid	\N	2026-03-08 22:37:18.434764+00
1048	oregonia	\N	2026-03-08 22:37:18.435426+00
1049	oriental lily	\N	2026-03-08 22:37:18.435636+00
1052	palm	\N	2026-03-08 22:37:18.436176+00
1058	pampas	\N	2026-03-08 22:37:18.439468+00
1060	peony	\N	2026-03-08 22:37:18.439987+00
1076	pepperberry	\N	2026-03-08 22:37:18.44761+00
1078	phal	\N	2026-03-08 22:37:18.449054+00
1081	phlox	\N	2026-03-08 22:37:18.45065+00
1082	pincushion protea	\N	2026-03-08 22:37:18.450876+00
1089	pine cones	\N	2026-03-08 22:37:18.454236+00
1091	pompon	\N	2026-03-08 22:37:18.454773+00
1178	poppy	\N	2026-03-08 22:37:18.494573+00
1179	protea	\N	2026-03-08 22:37:18.494778+00
1187	pussy willow	\N	2026-03-08 22:37:18.49685+00
1192	queen anne's lace	\N	2026-03-08 22:37:18.499875+00
1196	quince	\N	2026-03-08 22:37:18.501888+00
1200	ranunculus	\N	2026-03-08 22:37:18.504671+00
1203	rice flower	\N	2026-03-08 22:37:18.505306+00
1454	rose petals	\N	2026-03-08 22:37:18.616978+00
1455	saxicola pink	\N	2026-03-08 22:37:18.617553+00
1456	scabiosa	\N	2026-03-08 22:37:18.617751+00
1462	scabiosa pod	\N	2026-03-08 22:37:18.620408+00
1463	snapdragon	\N	2026-03-08 22:37:18.620956+00
1478	snowberry	\N	2026-03-08 22:37:18.626949+00
1480	solidago	\N	2026-03-08 22:37:18.627768+00
1481	solomio	\N	2026-03-08 22:37:18.628019+00
1483	specialty ranunculus	\N	2026-03-08 22:37:18.62855+00
1515	spirea	\N	2026-03-08 22:37:18.644393+00
1517	rose	spray	2026-03-08 22:37:18.646261+00
1579	springeri	\N	2026-03-08 22:37:18.673252+00
1580	ranunculus	standard	2026-03-08 22:37:18.673478+00
1594	statice	\N	2026-03-08 22:37:18.678154+00
1602	stock	\N	2026-03-08 22:37:18.685388+00
1639	strawflower	\N	2026-03-08 22:37:18.710643+00
1641	sunflower	\N	2026-03-08 22:37:18.71227+00
1659	sweet pea	\N	2026-03-08 22:37:18.726069+00
1675	sweetheart rose	\N	2026-03-08 22:37:18.733942+00
1676	thistle	\N	2026-03-08 22:37:18.734832+00
1680	tinted limonium	\N	2026-03-08 22:37:18.738783+00
1681	trachelium	\N	2026-03-08 22:37:18.739189+00
1682	trachellium	\N	2026-03-08 22:37:18.739581+00
1685	tropicals	\N	2026-03-08 22:37:18.741958+00
1702	tulip	\N	2026-03-08 22:37:18.751682+00
1726	tweedia	\N	2026-03-08 22:37:18.760757+00
1730	veronica	\N	2026-03-08 22:37:18.762513+00
1734	wax flower	\N	2026-03-08 22:37:18.764263+00
1740	waxflower	\N	2026-03-08 22:37:18.765722+00
1750	yarrow	\N	2026-03-08 22:37:18.771649+00
1758	fiorino	\N	2026-03-08 22:37:18.776789+00
1759	lilliput	\N	2026-03-08 22:37:18.777488+00
1789	lepidium	\N	2026-03-08 22:37:18.79779+00
1839	dubium	\N	2026-03-08 22:37:18.836632+00
1892	capanula	\N	2026-03-08 22:37:18.872415+00
1893	didiscus	\N	2026-03-08 22:37:18.873283+00
1957	limonium	tinted	2026-03-08 22:37:18.908885+00
1964	anemone	premium	2026-03-08 22:37:18.913427+00
1965	baby's breath	tinted	2026-03-08 22:37:18.914224+00
2010	ranunculus	butterfly premium	2026-03-08 22:37:18.941523+00
2012	ranunculus	premium	2026-03-08 22:37:18.942463+00
2016	garland	\N	2026-03-08 22:37:18.945047+00
2033	aspidistra	\N	2026-03-08 22:37:18.956311+00
2034	chamaedorea	\N	2026-03-08 22:37:18.956904+00
2037	cordyline	\N	2026-03-08 22:37:18.958465+00
2038	monstera	\N	2026-03-08 22:37:18.959062+00
2042	davalia	\N	2026-03-08 22:37:18.961459+00
2043	dracaenas	\N	2026-03-08 22:37:18.962115+00
2045	leather leaf	\N	2026-03-08 22:37:18.963513+00
2048	musa leaf	\N	2026-03-08 22:37:18.965894+00
2049	raphis palm	\N	2026-03-08 22:37:18.966522+00
2050	philodendron	\N	2026-03-08 22:37:18.967191+00
2052	podocarpus	\N	2026-03-08 22:37:18.968409+00
2053	scheflera	\N	2026-03-08 22:37:18.968974+00
2068	ginger	seasonal	2026-03-08 22:37:18.977871+00
2112	heliconia hanging	\N	2026-03-08 22:37:19.010382+00
2122	heliconia novelty	\N	2026-03-08 22:37:19.016447+00
2124	heliconia parakeet	\N	2026-03-08 22:37:19.017982+00
2130	musa	\N	2026-03-08 22:37:19.022673+00
2148	novelty	\N	2026-03-08 22:37:19.035994+00
2180	anthuriums 12	14cm head	2026-03-08 22:37:19.055711+00
2181	anthuriums 10	12cm head	2026-03-08 22:37:19.056541+00
2182	anthuriums 8	10cm head	2026-03-08 22:37:19.057293+00
2218	safari sunset	\N	2026-03-08 22:37:19.081793+00
2219	curcuma	\N	2026-03-08 22:37:19.082416+00
2223	greenery	oversize	2026-03-08 22:37:19.084714+00
2228	palm	oversize	2026-03-08 22:37:19.086971+00
2233	alocasia	\N	2026-03-08 22:37:19.090032+00
2237	alocasia	oversize	2026-03-08 22:37:19.09265+00
2245	monstera	oversize	2026-03-08 22:37:19.098329+00
2254	musa oversize	\N	2026-03-08 22:37:19.10439+00
2257	philodendron	oversize	2026-03-08 22:37:19.105866+00
2264	willow	\N	2026-03-08 22:37:19.109466+00
2266	cocculos	\N	2026-03-08 22:37:19.110449+00
2267	sanseveria	\N	2026-03-08 22:37:19.110971+00
2269	cocoplum	\N	2026-03-08 22:37:19.11197+00
2270	dracaena	\N	2026-03-08 22:37:19.11271+00
2271	dieffenbachia	\N	2026-03-08 22:37:19.11336+00
2273	greens	\N	2026-03-08 22:37:19.114759+00
2276	calathea	\N	2026-03-08 22:37:19.116647+00
2279	cordelyn	\N	2026-03-08 22:37:19.118485+00
2282	cordelyn oversize	\N	2026-03-08 22:37:19.120425+00
2295	fern	\N	2026-03-08 22:37:19.128978+00
2302	pandanus	\N	2026-03-08 22:37:19.13261+00
2305	monedita	\N	2026-03-08 22:37:19.134437+00
2307	empac	\N	2026-03-08 22:37:19.135723+00
2317	coffee leaves	\N	2026-03-08 22:37:19.142773+00
2318	aralia	\N	2026-03-08 22:37:19.143298+00
2320	schefflera leaves	\N	2026-03-08 22:37:19.144548+00
2406	calla	mini	2026-03-08 22:37:19.200829+00
2435	chamomile	\N	2026-03-08 22:37:19.22257+00
2438	open cut calla lily	\N	2026-03-08 22:37:19.22475+00
2439	orlaya	\N	2026-03-08 22:37:19.225526+00
2443	gypsophila	\N	2026-03-08 22:37:19.228366+00
2459	astilbe	\N	2026-03-08 22:37:19.239588+00
2464	berries	\N	2026-03-08 22:37:19.242162+00
2466	branches	\N	2026-03-08 22:37:19.243537+00
2508	gass	\N	2026-03-08 22:37:19.273342+00
2527	greenry	\N	2026-03-08 22:37:19.286809+00
2545	moss	\N	2026-03-08 22:37:19.298381+00
2548	plumosa	\N	2026-03-08 22:37:19.300444+00
2555	qal	\N	2026-03-08 22:37:19.30516+00
2573	sanguisorba	\N	2026-03-08 22:37:19.316938+00
2597	brunia	\N	2026-03-08 22:37:19.330631+00
2598	ruscus	\N	2026-03-08 22:37:19.3312+00
2603	unknown	\N	2026-03-08 22:37:19.33393+00
\.


--
-- Data for Name: varieties; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.varieties (id, name, created_at) FROM stdin;
1	delirium	2026-03-08 22:37:17.843192+00
2	freedom	2026-03-08 22:37:17.849204+00
3	hearts	2026-03-08 22:37:17.851172+00
4	mayra red	2026-03-08 22:37:17.853203+00
5	mamma mia	2026-03-08 22:37:17.855204+00
6	red eye	2026-03-08 22:37:17.856664+00
7	akito	2026-03-08 22:37:17.859143+00
8	candlelight	2026-03-08 22:37:17.859746+00
9	escimo	2026-03-08 22:37:17.861234+00
10	mondial	2026-03-08 22:37:17.86206+00
11	moonstone	2026-03-08 22:37:17.863544+00
12	playa blanca	2026-03-08 22:37:17.864473+00
13	cotton x-pression	2026-03-08 22:37:17.8652+00
14	creamykiss	2026-03-08 22:37:17.869098+00
15	mayra white	2026-03-08 22:37:17.8699+00
16	starwalker	2026-03-08 22:37:17.872123+00
17	sugar doll	2026-03-08 22:37:17.87346+00
18	tibet	2026-03-08 22:37:17.874062+00
19	vendela	2026-03-08 22:37:17.874652+00
20	white o'hara	2026-03-08 22:37:17.875328+00
21	paloma	2026-03-08 22:37:17.875965+00
22	magic times	2026-03-08 22:37:17.876617+00
23	sweetness	2026-03-08 22:37:17.877391+00
24	lady amira	2026-03-08 22:37:17.879427+00
25	sweet unique	2026-03-08 22:37:17.880966+00
26	christa	2026-03-08 22:37:17.881808+00
27	flirty	2026-03-08 22:37:17.882547+00
28	country secret	2026-03-08 22:37:17.883299+00
29	frutteto	2026-03-08 22:37:17.884022+00
30	luciano	2026-03-08 22:37:17.884731+00
31	pink mondial	2026-03-08 22:37:17.88559+00
32	pink o'hara	2026-03-08 22:37:17.886847+00
33	pink x-pression	2026-03-08 22:37:17.887741+00
34	sophie	2026-03-08 22:37:17.888605+00
35	sweet akito	2026-03-08 22:37:17.889329+00
36	candy x-pression	2026-03-08 22:37:17.890159+00
37	marlysee	2026-03-08 22:37:17.890897+00
38	novia	2026-03-08 22:37:17.891504+00
39	romina	2026-03-08 22:37:17.892121+00
40	saga	2026-03-08 22:37:17.893212+00
41	tina	2026-03-08 22:37:17.89396+00
42	full monty	2026-03-08 22:37:17.894744+00
43	hot princess	2026-03-08 22:37:17.895913+00
44	lola	2026-03-08 22:37:17.896973+00
45	mayra bright	2026-03-08 22:37:17.897742+00
46	pink floyd	2026-03-08 22:37:17.898495+00
47	pink love	2026-03-08 22:37:17.899354+00
48	queen berry	2026-03-08 22:37:17.900213+00
49	v.i. pink	2026-03-08 22:37:17.90094+00
50	high orange magic	2026-03-08 22:37:17.901635+00
51	hilux	2026-03-08 22:37:17.902337+00
52	lumia	2026-03-08 22:37:17.903024+00
53	nina	2026-03-08 22:37:17.903915+00
54	orange crush	2026-03-08 22:37:17.904704+00
55	free spirit	2026-03-08 22:37:17.905429+00
56	aquarelle	2026-03-08 22:37:17.906331+00
57	carpe diem	2026-03-08 22:37:17.907281+00
58	country louise	2026-03-08 22:37:17.907997+00
59	kahala	2026-03-08 22:37:17.908693+00
60	phoenix	2026-03-08 22:37:17.909384+00
61	mayra peach	2026-03-08 22:37:17.910149+00
62	shine on	2026-03-08 22:37:17.910837+00
63	shimmer	2026-03-08 22:37:17.911658+00
64	tiffany	2026-03-08 22:37:17.912705+00
65	country candy	2026-03-08 22:37:17.913744+00
66	creme de la creme	2026-03-08 22:37:17.914571+00
67	quicksand	2026-03-08 22:37:17.91534+00
68	soul	2026-03-08 22:37:17.915936+00
69	brighton	2026-03-08 22:37:17.91662+00
70	giselle	2026-03-08 22:37:17.917463+00
71	goldfinch	2026-03-08 22:37:17.918183+00
72	high & yellow magic	2026-03-08 22:37:17.918893+00
73	high exotic	2026-03-08 22:37:17.919603+00
74	king's cross	2026-03-08 22:37:17.920692+00
75	momentum	2026-03-08 22:37:17.921527+00
76	stardust	2026-03-08 22:37:17.922256+00
77	summer romance	2026-03-08 22:37:17.923035+00
78	super sun	2026-03-08 22:37:17.923933+00
79	high & magic	2026-03-08 22:37:17.9247+00
80	hot sauce	2026-03-08 22:37:17.925396+00
81	silantoi	2026-03-08 22:37:17.92608+00
82	light spirit	2026-03-08 22:37:17.926894+00
83	blue dream	2026-03-08 22:37:17.927721+00
84	cool water	2026-03-08 22:37:17.928501+00
85	country blues	2026-03-08 22:37:17.929651+00
86	deep purple	2026-03-08 22:37:17.930542+00
87	moody blues	2026-03-08 22:37:17.931531+00
88	ocean song	2026-03-08 22:37:17.932277+00
89	queen's crown	2026-03-08 22:37:17.933032+00
90	** peonikiss**	2026-03-08 22:37:17.933721+00
91	star platinum	2026-03-08 22:37:17.934558+00
92	ascot	2026-03-08 22:37:17.935182+00
93	barista	2026-03-08 22:37:17.935711+00
94	tinted novelties	2026-03-08 22:37:17.936302+00
95	antique	2026-03-08 22:37:17.936783+00
96	solids	2026-03-08 22:37:17.937469+00
97	assorted	2026-03-08 22:37:17.938035+00
98	minicarnations	2026-03-08 22:37:17.93857+00
99	solids, assorted & novelties	2026-03-08 22:37:17.939073+00
100	florincas	2026-03-08 22:37:17.940264+00
101	solids & assorted	2026-03-08 22:37:17.940856+00
102	gerberas & gerrondos	2026-03-08 22:37:17.941481+00
103	solid colors	2026-03-08 22:37:17.941962+00
105	minicallas	2026-03-08 22:37:17.942873+00
107	solid	2026-03-08 22:37:17.943735+00
108	lilies	2026-03-08 22:37:17.944286+00
109	asiatic /la hybrids lilies	2026-03-08 22:37:17.944918+00
110	oriental	2026-03-08 22:37:17.94582+00
111	rose lily	2026-03-08 22:37:17.946659+00
112	novelty items colombia	2026-03-08 22:37:17.94729+00
113	double spray stock	2026-03-08 22:37:17.947834+00
114	aster (purple &	2026-03-08 22:37:17.948359+00
115	aster (solidago	2026-03-08 22:37:17.949425+00
116	dianthus	2026-03-08 22:37:17.950122+00
117	dianthus (amazon, sweet williams/breanthus)	2026-03-08 22:37:17.950863+00
118	aster matsumoto	2026-03-08 22:37:17.951405+00
119	greens (ruscus, coccolus, pithosporum)	2026-03-08 22:37:17.951941+00
120	greens eucalypthus	2026-03-08 22:37:17.952481+00
121	hypericum	2026-03-08 22:37:17.953107+00
122	x-lence gyp	2026-03-08 22:37:17.95361+00
123	limonium eversnow	2026-03-08 22:37:17.9541+00
124	ammimajus /queen anne's lace	2026-03-08 22:37:17.95464+00
125	sunflowers pettite vincent & sunrich	2026-03-08 22:37:17.955141+00
126	eryngium magical	2026-03-08 22:37:17.955681+00
127	veronicas	2026-03-08 22:37:17.956308+00
128	craspedia	2026-03-08 22:37:17.956841+00
129	craspedia tinted	2026-03-08 22:37:17.957296+00
130	spray delphinium	2026-03-08 22:37:17.957811+00
131	matricaria	2026-03-08 22:37:17.958569+00
132	statice	2026-03-08 22:37:17.959715+00
133	lepidium	2026-03-08 22:37:17.960552+00
134	snap dragon	2026-03-08 22:37:17.96152+00
135	brassicas	2026-03-08 22:37:17.962124+00
136	crassulas	2026-03-08 22:37:17.962636+00
137	ranunculus	2026-03-08 22:37:17.963156+00
140	spray chrysanthemums	2026-03-08 22:37:17.964513+00
141	cdn assorted or solids	2026-03-08 22:37:17.965365+00
142	tinted	2026-03-08 22:37:17.966096+00
143	disbuds	2026-03-08 22:37:17.966699+00
144	cremons	2026-03-08 22:37:17.967155+00
145	tinted cremons	2026-03-08 22:37:17.967623+00
146	bombon	2026-03-08 22:37:17.968105+00
147	hydrangeas usa	2026-03-08 22:37:17.968918+00
148	mini	2026-03-08 22:37:17.969353+00
149	dark mini / mini mohito	2026-03-08 22:37:17.969896+00
150	classic	2026-03-08 22:37:17.970435+00
153	purple	2026-03-08 22:37:17.97195+00
154	big petals	2026-03-08 22:37:17.972452+00
156	tinted special	2026-03-08 22:37:17.973085+00
157	precios con fresh liner incluido / \nopcion2: papel & waterbag - +0,05/tallo	2026-03-08 22:37:17.973442+00
158	knifeblade	2026-03-08 22:37:17.973994+00
159	pearl	2026-03-08 22:37:17.97629+00
160	mimosa ylw 150g it/fr	2026-03-08 22:37:17.97686+00
161	mimosa ylw 200g it/fr	2026-03-08 22:37:17.977211+00
162	prp gladiator dutch	2026-03-08 22:37:17.977642+00
163	assorted medium 15pk	2026-03-08 22:37:17.985257+00
164	bride 10p	2026-03-08 22:37:17.985717+00
165	10pk	2026-03-08 22:37:17.987311+00
166	med 10p	2026-03-08 22:37:17.988611+00
167	large 10pk	2026-03-08 22:37:17.990062+00
168	medium 10pk	2026-03-08 22:37:17.991749+00
169	small 15pk	2026-03-08 22:37:17.99438+00
170	haw. 10pk	2026-03-08 22:37:17.996726+00
172	15pk	2026-03-08 22:37:18.001843+00
175	assorted mardi gras 10pk	2026-03-08 22:37:18.014963+00
176	asst carnival duplo cs8	2026-03-08 22:37:18.018116+00
177	crm estelle solidago 5pk	2026-03-08 22:37:18.019273+00
178	matsumoto pink hot 10st	2026-03-08 22:37:18.020402+00
179	matsumoto pink light 10s	2026-03-08 22:37:18.022448+00
180	matsumoto red 10st	2026-03-08 22:37:18.022856+00
181	matsumoto white 10st	2026-03-08 22:37:18.023366+00
182	gras	2026-03-08 22:37:18.02569+00
184	mardi gr	2026-03-08 22:37:18.033141+00
185	queen's	2026-03-08 22:37:18.033865+00
186	gypsophila cosmic	2026-03-08 22:37:18.038351+00
187	gypsophila cosmic 10pk	2026-03-08 22:37:18.040135+00
188	gypsophila excellence 6pk	2026-03-08 22:37:18.040633+00
189	gypsophila excellence pyg 6pk	2026-03-08 22:37:18.043172+00
190	gypsophila grandtastic 6pk	2026-03-08 22:37:18.043607+00
191	gypsophila wild pearl 6pk	2026-03-08 22:37:18.044058+00
192	70-	2026-03-08 22:37:18.044653+00
193	california	2026-03-08 22:37:18.049236+00
194	baubles	2026-03-08 22:37:18.049974+00
195	strawberry	2026-03-08 22:37:18.052582+00
196	super 20pk	2026-03-08 22:37:18.053304+00
197	flat orion 65	2026-03-08 22:37:18.055728+00
198	round snow 50	2026-03-08 22:37:18.056312+00
199	bfly asst 10st 5pk	2026-03-08 22:37:18.067934+00
200	bfly blush 10st can	2026-03-08 22:37:18.068501+00
201	bfly crm graces 10s	2026-03-08 22:37:18.07041+00
202	bfly org minoan 10s	2026-03-08 22:37:18.073142+00
203	bfly pk melissa 10s	2026-03-08 22:37:18.073675+00
204	bfly prp thiva 10st	2026-03-08 22:37:18.074207+00
205	bfly sal eris 10st	2026-03-08 22:37:18.076428+00
206	bfly vestalis 10st	2026-03-08 22:37:18.076954+00
207	wht magnum	2026-03-08 22:37:18.086327+00
208	wht open 80/90 20pk	2026-03-08 22:37:18.088041+00
209	wht open 90cm 25pk	2026-03-08 22:37:18.088542+00
210	wht open prem 80/90	2026-03-08 22:37:18.089326+00
211	blk odessa 50c	2026-03-08 22:37:18.091407+00
212	burg sumatra 5	2026-03-08 22:37:18.092113+00
213	50/55	2026-03-08 22:37:18.093438+00
214	wht iv art 55+	2026-03-08 22:37:18.094528+00
215	carn moon select asst 80pk	2026-03-08 22:37:18.099313+00
216	antiqua	2026-03-08 22:37:18.099908+00
217	brt rendez/komachi	2026-03-08 22:37:18.100442+00
218	caramel	2026-03-08 22:37:18.101078+00
219	cover	2026-03-08 22:37:18.101439+00
220	creola	2026-03-08 22:37:18.10191+00
221	lav farida 75pk	2026-03-08 22:37:18.102526+00
222	lege sport 50pk	2026-03-08 22:37:18.103179+00
223	mariposa	2026-03-08 22:37:18.103563+00
224	nobbio cherry 75pk	2026-03-08 22:37:18.103928+00
225	org trueno 75pk	2026-03-08 22:37:18.104643+00
226	marrn 75p	2026-03-08 22:37:18.105276+00
227	50pk	2026-03-08 22:37:18.106053+00
229	pk75	2026-03-08 22:37:18.107263+00
230	75pk	2026-03-08 22:37:18.108219+00
231	select moon aqua	2026-03-08 22:37:18.108968+00
232	select moon lite	2026-03-08 22:37:18.109614+00
233	select moon shade	2026-03-08 22:37:18.110306+00
234	select moon vista	2026-03-08 22:37:18.110838+00
235	spritz sport	2026-03-08 22:37:18.111383+00
236	175pk	2026-03-08 22:37:18.112037+00
237	mum dis ball pch sorbet berry	2026-03-08 22:37:18.117596+00
238	mum dis ball pink lorax 5stm	2026-03-08 22:37:18.118278+00
239	mum dis ball prp gustav, 5st	2026-03-08 22:37:18.118712+00
240	mum dis ball white evidence	2026-03-08 22:37:18.119093+00
241	mum dis ball wht zonar 5st 4pk	2026-03-08 22:37:18.11955+00
242	mum dis ball yellow paladov	2026-03-08 22:37:18.11996+00
243	mum disbud assorted 9pk	2026-03-08 22:37:18.120565+00
244	mum disbud asst 4pk	2026-03-08 22:37:18.121496+00
245	mum disbud biclr rasp brulee e	2026-03-08 22:37:18.122052+00
246	mum disbud bronze marrakesh 3p	2026-03-08 22:37:18.122586+00
247	mum disbud crm caffe latte ecu	2026-03-08 22:37:18.123131+00
248	mum disbud lavender lotus	2026-03-08 22:37:18.123621+00
249	mum disbud peach linette 4pk	2026-03-08 22:37:18.1241+00
250	mum disbud peach linette ecu	2026-03-08 22:37:18.124684+00
251	mum disbud pink honeymoon ecu	2026-03-08 22:37:18.125151+00
252	mum disbud pink petruska	2026-03-08 22:37:18.125675+00
253	mum disbud purple andrea	2026-03-08 22:37:18.126196+00
254	mum disbud purple bachata 4pk	2026-03-08 22:37:18.126665+00
255	mum disbud purple tornado 4pk	2026-03-08 22:37:18.127012+00
256	mum disbud salm.prdgy coral	2026-03-08 22:37:18.127374+00
257	mum disbud salmon pink ecu 3pk	2026-03-08 22:37:18.127728+00
258	mum disbud tinted blue	2026-03-08 22:37:18.128171+00
259	mum disbud white arctic qn 4pk	2026-03-08 22:37:18.128906+00
260	mum disbud white arctic qn 9pk	2026-03-08 22:37:18.129806+00
261	mum disbud white arctic queen	2026-03-08 22:37:18.130587+00
262	mum disbud white gagarin ecu	2026-03-08 22:37:18.131153+00
263	mum disbud white magnum	2026-03-08 22:37:18.131679+00
264	mum disbud white magnum 4pk	2026-03-08 22:37:18.132192+00
265	mum disbud white tatto 4pk	2026-03-08 22:37:18.132779+00
266	mum disbud yellow	2026-03-08 22:37:18.133263+00
267	mum disbud yellow astroid	2026-03-08 22:37:18.133655+00
268	mum disbud yellow astroid 4pk	2026-03-08 22:37:18.134024+00
269	mum spider green	2026-03-08 22:37:18.134512+00
270	mum spider green dark	2026-03-08 22:37:18.135065+00
271	mum spider lav. anas dvfl 4pk	2026-03-08 22:37:18.135576+00
272	mum spider lavender	2026-03-08 22:37:18.136057+00
273	mum spider pink	2026-03-08 22:37:18.136889+00
274	mum spider pink anastasia	2026-03-08 22:37:18.137338+00
275	mum spider pink hydra 5pk	2026-03-08 22:37:18.137702+00
276	mum spider purple 5pk	2026-03-08 22:37:18.138112+00
277	mum spider white	2026-03-08 22:37:18.13871+00
278	mum spider white yazoo 12pk	2026-03-08 22:37:18.139267+00
279	mum spider white yazoo 9pk	2026-03-08 22:37:18.139965+00
280	mum spider yellow	2026-03-08 22:37:18.140531+00
281	mum spider yellow 4pk	2026-03-08 22:37:18.140915+00
282	mum spider yellow anastasia	2026-03-08 22:37:18.141294+00
283	amazing kibo	2026-03-08 22:37:18.142149+00
284	kansas 10st	2026-03-08 22:37:18.143087+00
285	chocolate choco 10st	2026-03-08 22:37:18.144669+00
286	willow curly large	2026-03-08 22:37:18.147993+00
287	willow curly medium	2026-03-08 22:37:18.148878+00
288	asst 8/11 10pk	2026-03-08 22:37:18.149486+00
289	bloom	2026-03-08 22:37:18.150282+00
290	lip 8/11	2026-03-08 22:37:18.151018+00
291	mini burgundy	2026-03-08 22:37:18.151718+00
292	mini grn rdlip 40cm+	2026-03-08 22:37:18.152198+00
293	mini pink 40cm+	2026-03-08 22:37:18.152676+00
294	mini yellow red lip	2026-03-08 22:37:18.153184+00
296	ylw red lip 8/11	2026-03-08 22:37:18.154736+00
297	ylw carlton dutch	2026-03-08 22:37:18.155438+00
298	ylw dutch master dut	2026-03-08 22:37:18.156046+00
299	ylw field bunch	2026-03-08 22:37:18.156603+00
300	dahlia white 5st cali	2026-03-08 22:37:18.158132+00
301	brg naomi 5st californi	2026-03-08 22:37:18.158809+00
302	5st cali	2026-03-08 22:37:18.159268+00
303	5st cal	2026-03-08 22:37:18.160141+00
304	cornel 5st	2026-03-08 22:37:18.160716+00
305	delph blue-dk sea waltz 60/70	2026-03-08 22:37:18.163001+00
306	delph blue-dk sea waltz 70/90	2026-03-08 22:37:18.163583+00
307	delph blue-dk seawaltz 60cm 6p	2026-03-08 22:37:18.164182+00
308	delph blue-dk waltz 55cm 6p	2026-03-08 22:37:18.165086+00
309	delph blue-lt sky waltz 60-70c	2026-03-08 22:37:18.165713+00
310	delph blue-lt sky waltz	2026-03-08 22:37:18.166193+00
311	delph blue-lt sky waltz 70/90c	2026-03-08 22:37:18.166888+00
312	delph hyb blue-dk 70/80cm/10st	2026-03-08 22:37:18.167378+00
313	delph hyb blue-dk pacif60c/10s	2026-03-08 22:37:18.167844+00
314	delph hyb blue-dk pacif70c/10s	2026-03-08 22:37:18.168307+00
315	delph hyb blue-dk pacif80/	2026-03-08 22:37:18.168813+00
316	delph hyb blue-lt 80/90cm/10st	2026-03-08 22:37:18.169317+00
317	delph hyb blue-lt pacif 60c/10	2026-03-08 22:37:18.170141+00
318	delph hyb blue-lt pacif 70c/10	2026-03-08 22:37:18.170556+00
319	delph hyb blue-lt pacif 80c/10	2026-03-08 22:37:18.170903+00
320	delph hyb lav pacif70c/10s	2026-03-08 22:37:18.171311+00
321	delph hyb lav pacif80c/10s	2026-03-08 22:37:18.171683+00
322	delph hyb pink pacif70c/10s	2026-03-08 22:37:18.172009+00
323	delph hyb pink pacif80c/10s	2026-03-08 22:37:18.172478+00
324	delph hyb prpl blkk pacif70c/	2026-03-08 22:37:18.172808+00
325	delph hyb white 80/90cm 10stm	2026-03-08 22:37:18.173217+00
326	delph hyb white pacif 60c/10s	2026-03-08 22:37:18.173711+00
327	delph hyb white pacif 70c/10st	2026-03-08 22:37:18.17418+00
328	delph hyb white pacif 80c/10st	2026-03-08 22:37:18.174712+00
329	delph hyb wht full moon	2026-03-08 22:37:18.175195+00
330	delph hybrid asst 60cm 6pk	2026-03-08 22:37:18.175693+00
331	delph lavender serene	2026-03-08 22:37:18.176166+00
332	delph white andes bella	2026-03-08 22:37:18.176647+00
333	delph white-royal 60/70 vflor	2026-03-08 22:37:18.177021+00
334	asst mix tray 5pk	2026-03-08 22:37:18.177992+00
335	asst mx bouquet 3st	2026-03-08 22:37:18.178839+00
336	super	2026-03-08 22:37:18.179651+00
337	stem	2026-03-08 22:37:18.180518+00
338	sl/l	2026-03-08 22:37:18.181165+00
339	james storei	2026-03-08 22:37:18.182075+00
340	lady pink	2026-03-08 22:37:18.182571+00
341	lav/wh misteen long	2026-03-08 22:37:18.183111+00
342	mokara calypso 5st	2026-03-08 22:37:18.183612+00
343	mokara org 5st sl/l	2026-03-08 22:37:18.1841+00
344	mokara pink lt 5st	2026-03-08 22:37:18.184577+00
345	mokara pur nora 5st	2026-03-08 22:37:18.185173+00
346	mokara ylw 5st sl/l	2026-03-08 22:37:18.185544+00
347	prp. madame sl/l bo	2026-03-08 22:37:18.185904+00
348	var. bom sl/l b	2026-03-08 22:37:18.186488+00
349	variegated super	2026-03-08 22:37:18.186884+00
350	med bo	2026-03-08 22:37:18.18736+00
351	sl/l bo	2026-03-08 22:37:18.188081+00
352	50-	2026-03-08 22:37:18.189428+00
353	amazon burgundy	2026-03-08 22:37:18.190119+00
354	amazon cherry	2026-03-08 22:37:18.190608+00
355	amazon coral	2026-03-08 22:37:18.191195+00
356	amazon pink-lt	2026-03-08 22:37:18.191708+00
357	amazon purple	2026-03-08 22:37:18.192185+00
358	amazon var pk/wt	2026-03-08 22:37:18.192663+00
359	amazon white	2026-03-08 22:37:18.193192+00
360	ball breanth jolly 4p	2026-03-08 22:37:18.193649+00
361	ball breanth white 4p	2026-03-08 22:37:18.194169+00
362	4pk	2026-03-08 22:37:18.194657+00
364	assorted 9pk	2026-03-08 22:37:18.198322+00
365	baby blue 4pk	2026-03-08 22:37:18.198706+00
366	baby blue 5pk	2026-03-08 22:37:18.199116+00
367	baby-blue bqt 7pk	2026-03-08 22:37:18.19961+00
368	feather willow 5pk	2026-03-08 22:37:18.200068+00
369	gum drop	2026-03-08 22:37:18.200567+00
370	gunnii 5pk	2026-03-08 22:37:18.201006+00
371	parvifolia californ	2026-03-08 22:37:18.201487+00
372	seeded 5pk	2026-03-08 22:37:18.201931+00
373	seeded naked	2026-03-08 22:37:18.202545+00
374	silver dollar 10pk	2026-03-08 22:37:18.203047+00
375	silver dollar 5pk	2026-03-08 22:37:18.203654+00
376	stuartiana italian	2026-03-08 22:37:18.204188+00
377	true blue	2026-03-08 22:37:18.204691+00
378	carolina sapphire	2026-03-08 22:37:18.205655+00
379	cedar port orford bunched	2026-03-08 22:37:18.206219+00
380	canada	2026-03-08 22:37:18.209301+00
383	fr tulip pch menton dutch	2026-03-08 22:37:18.210948+00
384	fr tulip wht maureen dutch	2026-03-08 22:37:18.211405+00
385	x12	2026-03-08 22:37:18.213863+00
386	hpk baronesse x12	2026-03-08 22:37:18.21443+00
387	hpk yves piage x12	2026-03-08 22:37:18.21495+00
388	pch juliet x12	2026-03-08 22:37:18.215442+00
389	pk romantic an x12	2026-03-08 22:37:18.215966+00
390	wht alabaster x12	2026-03-08 22:37:18.216502+00
391	wht cloud x12	2026-03-08 22:37:18.216992+00
392	wht o'hara cs50	2026-03-08 22:37:18.217511+00
393	wht patience x12	2026-03-08 22:37:18.218084+00
394	wht pr. miyuki x12	2026-03-08 22:37:18.218587+00
395	wht purity x12	2026-03-08 22:37:18.218971+00
396	garden spray wht blanche 6st	2026-03-08 22:37:18.219654+00
397	garden sprose loli x6st	2026-03-08 22:37:18.220251+00
398	dc	2026-03-08 22:37:18.222066+00
400	lc	2026-03-08 22:37:18.2233+00
401	crm/pch cartizze dc	2026-03-08 22:37:18.224068+00
402	mini burg black tie dc	2026-03-08 22:37:18.224554+00
403	mini coral time out lc	2026-03-08 22:37:18.225092+00
404	mini cream milady lc	2026-03-08 22:37:18.225572+00
405	mini crm/pch pelican l	2026-03-08 22:37:18.226032+00
406	mini lav/pnk kimsey lc	2026-03-08 22:37:18.226547+00
407	mini orange dc	2026-03-08 22:37:18.227086+00
408	mini orange jordy dc	2026-03-08 22:37:18.227562+00
409	mini orange lc	2026-03-08 22:37:18.228228+00
410	mini peach cream cafe	2026-03-08 22:37:18.228693+00
411	mini peach larissa lc	2026-03-08 22:37:18.2292+00
412	mini peach oreo dc	2026-03-08 22:37:18.229678+00
413	mini pink light dc	2026-03-08 22:37:18.230221+00
414	mini pink light lc	2026-03-08 22:37:18.23078+00
415	mini pink-hot dc	2026-03-08 22:37:18.231819+00
416	mini pink-hot lc	2026-03-08 22:37:18.232377+00
417	mini pk-ht wonderwal l	2026-03-08 22:37:18.232797+00
418	mini purple dolce dc	2026-03-08 22:37:18.233247+00
419	mini red dc	2026-03-08 22:37:18.233673+00
420	mini red lc	2026-03-08 22:37:18.234161+00
421	mini white dc	2026-03-08 22:37:18.234768+00
422	mini white lc	2026-03-08 22:37:18.235252+00
423	mini yel/org franky lc	2026-03-08 22:37:18.235771+00
424	mini yellow dc	2026-03-08 22:37:18.236392+00
425	mini yellow lc	2026-03-08 22:37:18.237007+00
432	julia dc	2026-03-08 22:37:18.241068+00
433	cafedelm d	2026-03-08 22:37:18.241867+00
434	estate lc	2026-03-08 22:37:18.242678+00
437	var pk hippie chic dc	2026-03-08 22:37:18.246007+00
439	gerpom cream saturn	2026-03-08 22:37:18.248197+00
440	gerpom pink terra cupid	2026-03-08 22:37:18.24866+00
441	gerpom purple chique	2026-03-08 22:37:18.249337+00
442	gerpom red floyd	2026-03-08 22:37:18.249921+00
443	gerpom white terra amando	2026-03-08 22:37:18.250431+00
444	gerpom yellow rhea	2026-03-08 22:37:18.251002+00
445	gerrondo orange fozzie	2026-03-08 22:37:18.251481+00
446	gerrondo peach beaker	2026-03-08 22:37:18.251981+00
447	gerrondo pink-hot ravanel 10st	2026-03-08 22:37:18.252445+00
448	ginestra pink 200g italy	2026-03-08 22:37:18.252989+00
449	ginestra red 200g italy	2026-03-08 22:37:18.253486+00
450	ginestra white 10st cali	2026-03-08 22:37:18.254013+00
451	ginestra white 200g italy	2026-03-08 22:37:18.254524+00
454	gomphrenia white	2026-03-08 22:37:18.258244+00
455	agonis foliage	2026-03-08 22:37:18.258733+00
456	bay laurel 10st california	2026-03-08 22:37:18.259146+00
457	boxwood africa bunched	2026-03-08 22:37:18.259519+00
458	boxwood american vbc	2026-03-08 22:37:18.259884+00
459	artemisia dusty miller 60cm 4p	2026-03-08 22:37:18.260399+00
460	artemisia dusty miller 6pk lg	2026-03-08 22:37:18.260889+00
461	artemisia dusty miller lacey	2026-03-08 22:37:18.261817+00
462	artemisia dusty miller lg leaf	2026-03-08 22:37:18.262359+00
463	fatsia japonica 10st (aralia)	2026-03-08 22:37:18.263048+00
464	fern flat	2026-03-08 22:37:18.263601+00
465	fern holly	2026-03-08 22:37:18.26445+00
466	fern sea star	2026-03-08 22:37:18.265231+00
467	fern umbrella	2026-03-08 22:37:18.26583+00
468	foxtail meyreii	2026-03-08 22:37:18.266412+00
469	galax leaves	2026-03-08 22:37:18.266974+00
470	garland plumosa 25ft	2026-03-08 22:37:18.267472+00
471	geranium scented foliage	2026-03-08 22:37:18.267935+00
472	grass lily (monkey) green	2026-03-08 22:37:18.268963+00
473	grass lily (monkey) variegated	2026-03-08 22:37:18.269426+00
474	simply spring 15pk	2026-03-08 22:37:18.270417+00
475	spring mix 15pk	2026-03-08 22:37:18.271213+00
476	grass bear	2026-03-08 22:37:18.272113+00
477	huckleberry	2026-03-08 22:37:18.27305+00
478	ruscus israel 50-	2026-03-08 22:37:18.273548+00
479	ruscus italian long	2026-03-08 22:37:18.274039+00
480	lepidium green dragon californ	2026-03-08 22:37:18.274795+00
481	pittosporum nigra	2026-03-08 22:37:18.276397+00
482	salal	2026-03-08 22:37:18.277056+00
483	herb mint green 5pk	2026-03-08 22:37:18.277763+00
484	herb rosemary 5pk	2026-03-08 22:37:18.278228+00
485	honey bracelet	2026-03-08 22:37:18.278684+00
486	huckleberry 10pk	2026-03-08 22:37:18.279213+00
487	huckleberry red	2026-03-08 22:37:18.279718+00
488	ivy green	2026-03-08 22:37:18.280282+00
489	ivy variegated	2026-03-08 22:37:18.280791+00
490	leatherleaf fern ag/rwb 25pk	2026-03-08 22:37:18.281326+00
491	leatherleaf fern large gua 20p	2026-03-08 22:37:18.281908+00
492	leatherleaf fern large gua 35p	2026-03-08 22:37:18.282384+00
493	leatherleaf fern sleeved 12pk	2026-03-08 22:37:18.282831+00
494	leatherleaf fern sleeved 30pk	2026-03-08 22:37:18.283323+00
495	leatherleaf fern sporeless 25p	2026-03-08 22:37:18.283857+00
496	leatherleaf fern std fl 10pk	2026-03-08 22:37:18.284344+00
497	leatherleaf fern std fl 30pk	2026-03-08 22:37:18.284831+00
498	leatherleaf xl royal fl slv 35	2026-03-08 22:37:18.285286+00
499	lepidium green dragon 6pk	2026-03-08 22:37:18.285781+00
500	ligustrum green fl	2026-03-08 22:37:18.286396+00
501	ligustrum variegated fl	2026-03-08 22:37:18.28691+00
502	ming fern	2026-03-08 22:37:18.287428+00
503	moss sheet fresh local	2026-03-08 22:37:18.287894+00
504	moss sheet fresh/wet 8lb	2026-03-08 22:37:18.288438+00
505	moss spanish	2026-03-08 22:37:18.288967+00
506	myrtle large	2026-03-08 22:37:18.289491+00
507	nandina	2026-03-08 22:37:18.290176+00
508	pittosporum green	2026-03-08 22:37:18.290741+00
509	pittosporum green 10pk	2026-03-08 22:37:18.29126+00
510	pittosporum variegated	2026-03-08 22:37:18.291858+00
511	pittosporum variegated 10pk	2026-03-08 22:37:18.292353+00
513	podocarpus	2026-03-08 22:37:18.293726+00
514	podocarpus weeping	2026-03-08 22:37:18.29423+00
515	rumex unicorn 60cm+	2026-03-08 22:37:18.294643+00
516	ruscus florida 20pk	2026-03-08 22:37:18.295092+00
517	ruscus italian bleached 5st	2026-03-08 22:37:18.29561+00
518	ruscus italian long 10pk	2026-03-08 22:37:18.296144+00
519	ruscus italian long 15pk	2026-03-08 22:37:18.296565+00
520	ruscus italian long 20pk	2026-03-08 22:37:18.297007+00
521	ruscus italian tips short	2026-03-08 22:37:18.297567+00
522	salal 10pk	2026-03-08 22:37:18.298128+00
523	salal little john (tips)	2026-03-08 22:37:18.298655+00
524	salal little john (tips)15pk	2026-03-08 22:37:18.299377+00
525	smilax green 5 x 5ft strings	2026-03-08 22:37:18.301624+00
526	smilax southern 13lbs texas	2026-03-08 22:37:18.30212+00
527	smilax southern alabama 30lbs	2026-03-08 22:37:18.302608+00
528	sword fern	2026-03-08 22:37:18.30313+00
529	tree fern costa rica 30pk	2026-03-08 22:37:18.303504+00
530	tree fern florida	2026-03-08 22:37:18.303898+00
531	tree fern florida 5pk	2026-03-08 22:37:18.304378+00
532	ivanhoe	2026-03-08 22:37:18.305136+00
534	p&f	2026-03-08 22:37:18.306685+00
535	calif	2026-03-08 22:37:18.30786+00
537	5 stem	2026-03-08 22:37:18.309172+00
540	10st	2026-03-08 22:37:18.310842+00
541	winterbells 5 stem	2026-03-08 22:37:18.31173+00
542	dutch	2026-03-08 22:37:18.312746+00
544	bl-dk shocking 30pk	2026-03-08 22:37:18.315629+00
545	30pk	2026-03-08 22:37:18.316369+00
546	12white/12blue 24pk	2026-03-08 22:37:18.317384+00
547	15white/15blue 30pk	2026-03-08 22:37:18.317825+00
548	5white/5blue 10pack	2026-03-08 22:37:18.318293+00
549	5wht/5blue dv 10pk	2026-03-08 22:37:18.318872+00
550	8wht/8blue/8grn 24pk	2026-03-08 22:37:18.319374+00
552	dvf 20pk	2026-03-08 22:37:18.321119+00
553	10pack	2026-03-08 22:37:18.321886+00
554	40pk	2026-03-08 22:37:18.322597+00
555	dvf 10pk	2026-03-08 22:37:18.323252+00
556	20pk	2026-03-08 22:37:18.323963+00
557	30p	2026-03-08 22:37:18.324598+00
558	sel 30	2026-03-08 22:37:18.325376+00
562	mojito	2026-03-08 22:37:18.327345+00
563	sel 10p	2026-03-08 22:37:18.328021+00
564	sel 30p	2026-03-08 22:37:18.328768+00
571	25pk	2026-03-08 22:37:18.343008+00
572	20p	2026-03-08 22:37:18.343827+00
573	tint rouge pink 15p	2026-03-08 22:37:18.344872+00
574	tinted crm/blsh 15pk	2026-03-08 22:37:18.345503+00
575	tinted dusty burg 15	2026-03-08 22:37:18.345949+00
576	tinted lavender 15pk	2026-03-08 22:37:18.346965+00
577	tinted mauve 15pk	2026-03-08 22:37:18.347586+00
578	tinted peach 15pk	2026-03-08 22:37:18.348106+00
579	tinted purple 15pk	2026-03-08 22:37:18.348604+00
580	wht jumbo loose	2026-03-08 22:37:18.349127+00
581	wht prem dvf 20pk	2026-03-08 22:37:18.349634+00
582	wht premium 25pk	2026-03-08 22:37:18.350138+00
583	wht premium dvf 10pk	2026-03-08 22:37:18.35065+00
584	wht select 24pk	2026-03-08 22:37:18.351203+00
585	wht select 30pk	2026-03-08 22:37:18.351753+00
586	wht select 40pk	2026-03-08 22:37:18.352306+00
587	wht select dvf 10pk	2026-03-08 22:37:18.352832+00
588	wht select s.a 10pk	2026-03-08 22:37:18.3534+00
589	wht super 24pk	2026-03-08 22:37:18.353775+00
590	bl-dk shocking 10pk	2026-03-08 22:37:18.355042+00
591	burg ilusion 50/60c	2026-03-08 22:37:18.357116+00
592	dvflora	2026-03-08 22:37:18.357668+00
593	50/60c	2026-03-08 22:37:18.358408+00
594	grn jungle roma 50/6	2026-03-08 22:37:18.359105+00
595	grn lucky rom 50/60	2026-03-08 22:37:18.359566+00
596	pch mellow rom 50/60	2026-03-08 22:37:18.359952+00
597	50/	2026-03-08 22:37:18.360332+00
598	rom 50/60	2026-03-08 22:37:18.360897+00
599	pk lt lovely rom 50/	2026-03-08 22:37:18.361619+00
601	70cm dvflora	2026-03-08 22:37:18.362726+00
603	rom 50/	2026-03-08 22:37:18.364191+00
605	local	2026-03-08 22:37:18.365597+00
606	mexico	2026-03-08 22:37:18.366317+00
608	bush green	2026-03-08 22:37:18.368103+00
609	peru	2026-03-08 22:37:18.368628+00
610	ecuador	2026-03-08 22:37:18.369372+00
611	ecuado	2026-03-08 22:37:18.370005+00
614	6pk	2026-03-08 22:37:18.372239+00
615	ca	2026-03-08 22:37:18.372972+00
616	xtr	2026-03-08 22:37:18.37358+00
618	ec	2026-03-08 22:37:18.374656+00
625	safari sunset	2026-03-08 22:37:18.379347+00
626	winter sunshine	2026-03-08 22:37:18.379789+00
627	lav caravelle 10st	2026-03-08 22:37:18.380325+00
629	hyb pk binazco 2blm	2026-03-08 22:37:18.382499+00
630	hyb pk brooks 3+	2026-03-08 22:37:18.383051+00
631	hyb pnk king solomon 3+	2026-03-08 22:37:18.383504+00
632	hyb pnk sorbonne 2/3 cana	2026-03-08 22:37:18.383952+00
633	hyb pnk sorbonne 2blm	2026-03-08 22:37:18.384473+00
634	hyb pnk sorbonne 4/5 cana	2026-03-08 22:37:18.384987+00
635	hyb pnk table dance 2/3 c	2026-03-08 22:37:18.38551+00
636	hyb pnk table dance 3+	2026-03-08 22:37:18.386068+00
637	hyb pnk table dance 3+ dv	2026-03-08 22:37:18.386707+00
638	hyb pnk table dance 4/5 c	2026-03-08 22:37:18.387514+00
639	hyb pnk tarrango 2/3 cana	2026-03-08 22:37:18.387949+00
640	hyb pnk tarrango 2blm	2026-03-08 22:37:18.388357+00
641	hyb pnk tarrango 3+	2026-03-08 22:37:18.388811+00
642	hyb pnk tarrango 4/5 cana	2026-03-08 22:37:18.389276+00
643	hyb wht monteneu 3+	2026-03-08 22:37:18.389783+00
644	hyb wht premium blonde 3+	2026-03-08 22:37:18.390277+00
645	hyb wht santander 3+	2026-03-08 22:37:18.39092+00
646	hyb wht santander 4/5 can	2026-03-08 22:37:18.39152+00
647	hyb wht saronno 3+	2026-03-08 22:37:18.392088+00
648	hyb wht saronno 4+ dvflor	2026-03-08 22:37:18.392572+00
649	hyb wht tisento 4+ dvflor	2026-03-08 22:37:18.393115+00
650	hyb wht zambesi 2/3 canad	2026-03-08 22:37:18.393591+00
651	hyb wht zambesi 2blm	2026-03-08 22:37:18.394063+00
652	hyb wht zambesi 4/5 canad	2026-03-08 22:37:18.394511+00
653	hyb yel vigneron 2/3 cana	2026-03-08 22:37:18.394995+00
654	hyb ylw catina 3+	2026-03-08 22:37:18.395477+00
655	hyb ylw manisa 3+ dvf	2026-03-08 22:37:18.39593+00
656	la orange talisker nc	2026-03-08 22:37:18.396445+00
657	la org eremo 3+	2026-03-08 22:37:18.396916+00
658	la org honesty 3+	2026-03-08 22:37:18.397385+00
659	la org sunderland 3+	2026-03-08 22:37:18.397853+00
660	la pch menorca 3+	2026-03-08 22:37:18.398334+00
661	la pch salmon classic nc	2026-03-08 22:37:18.398863+00
662	la peach 3+ canada	2026-03-08 22:37:18.399364+00
663	la pink 3+ canada	2026-03-08 22:37:18.399842+00
664	la pink albufeira 3+	2026-03-08 22:37:18.400337+00
665	la pink bourbon street 3+	2026-03-08 22:37:18.40082+00
666	la pink brindisi 3+	2026-03-08 22:37:18.401307+00
667	la pink brindisi nc	2026-03-08 22:37:18.401772+00
668	la pink indian summerset	2026-03-08 22:37:18.402229+00
669	la pink yerseke 3+	2026-03-08 22:37:18.402845+00
670	la red pokerface 3+	2026-03-08 22:37:18.403529+00
671	la white 3+ canada	2026-03-08 22:37:18.404037+00
672	la white perrano nc	2026-03-08 22:37:18.404514+00
673	la wht bach 3+	2026-03-08 22:37:18.40494+00
674	la wht charm 3+	2026-03-08 22:37:18.405448+00
675	la wht courier 3+	2026-03-08 22:37:18.406003+00
676	la wht litouwen 3+	2026-03-08 22:37:18.406462+00
677	la wht parrano 3+	2026-03-08 22:37:18.406957+00
678	la wht richmond 3+	2026-03-08 22:37:18.40744+00
679	la wht sound 3+	2026-03-08 22:37:18.407873+00
680	la yellow pavia nc	2026-03-08 22:37:18.408262+00
681	la ylw el divo 3+	2026-03-08 22:37:18.408667+00
682	la ylw pavia 3+	2026-03-08 22:37:18.409062+00
683	org brunello 3+	2026-03-08 22:37:18.409464+00
684	org tressor 3+	2026-03-08 22:37:18.409916+00
685	ot conca d'or 2blm	2026-03-08 22:37:18.410378+00
686	rose dbl anoushka 2/3 can	2026-03-08 22:37:18.410838+00
687	rose dbl pnk floretta 2/3	2026-03-08 22:37:18.411309+00
688	rose dbl pnk samantha 2/3	2026-03-08 22:37:18.411839+00
689	rose dbl pnk viola 2/3 ca	2026-03-08 22:37:18.412353+00
690	rose dbl pnk viola 4/5 ca	2026-03-08 22:37:18.412976+00
691	rose dbl wht aisha 2/3 ca	2026-03-08 22:37:18.413669+00
692	rose dbl wht aisha 4/5 ca	2026-03-08 22:37:18.414196+00
693	cs5	2026-03-08 22:37:18.417038+00
694	5pk	2026-03-08 22:37:18.417903+00
695	prp rosaflora	2026-03-08 22:37:18.419562+00
696	75c	2026-03-08 22:37:18.420112+00
697	apricot rosaflor 75	2026-03-08 22:37:18.421119+00
699	magenta rosaflor	2026-03-08 22:37:18.422696+00
701	pk lt rosaflora 75c	2026-03-08 22:37:18.424045+00
702	pk var rosaflora 75	2026-03-08 22:37:18.424452+00
703	prp var rosaflora 7	2026-03-08 22:37:18.424828+00
704	50/60	2026-03-08 22:37:18.425267+00
705	japan	2026-03-08 22:37:18.433275+00
706	emerald medium guatemala	2026-03-08 22:37:18.436253+00
707	emerald premium guatemala	2026-03-08 22:37:18.43661+00
708	emerald premium guatemala 15pk	2026-03-08 22:37:18.437066+00
709	emerald premium narrow	2026-03-08 22:37:18.437858+00
710	emerald tepe	2026-03-08 22:37:18.438443+00
711	phoenix roebelini 20st	2026-03-08 22:37:18.439053+00
712	5st	2026-03-08 22:37:18.441479+00
714	angel cheeks 5st	2026-03-08 22:37:18.442814+00
715	b 5st	2026-03-08 22:37:18.443504+00
717	bern 5st 20pk	2026-03-08 22:37:18.444679+00
718	bockstoce 5st	2026-03-08 22:37:18.445491+00
719	shower 5st	2026-03-08 22:37:18.446244+00
720	tain 5st	2026-03-08 22:37:18.446953+00
721	upright brazilian	2026-03-08 22:37:18.447849+00
722	hanging green	2026-03-08 22:37:18.44853+00
723	spray prp buffalo 9+bl	2026-03-08 22:37:18.449182+00
724	spray white kobe 7+bl	2026-03-08 22:37:18.449726+00
725	spray white kobe 9+bl	2026-03-08 22:37:18.450215+00
726	pincushion asst seasonal 20pk	2026-03-08 22:37:18.450964+00
727	pincushion org 20pk	2026-03-08 22:37:18.451349+00
728	pincushion org ca 20pk	2026-03-08 22:37:18.451781+00
729	pincushion org soleil 50pk	2026-03-08 22:37:18.452247+00
730	pincushion red tango 20pk	2026-03-08 22:37:18.452798+00
731	pincushion yel blush firefly20	2026-03-08 22:37:18.453294+00
732	pincushion yel mooonlight 50pk	2026-03-08 22:37:18.453793+00
733	pom pon candy crush mint 6pk	2026-03-08 22:37:18.455072+00
734	pom pon white candy crush 6pk	2026-03-08 22:37:18.455546+00
735	pom pon yellow zippo 6pk	2026-03-08 22:37:18.457767+00
736	pom pon blue ocean coral	2026-03-08 22:37:18.458752+00
737	pom pon blue ocean jade	2026-03-08 22:37:18.459192+00
738	pom pon blue ocean prp sapphir	2026-03-08 22:37:18.459674+00
739	pom pon blue ocean sapphire	2026-03-08 22:37:18.460131+00
740	pom pon burg cush malbec 5pk	2026-03-08 22:37:18.460576+00
741	pom pon cream cush crm brul 6p	2026-03-08 22:37:18.4611+00
742	pom pon cush yel champagne 6pk	2026-03-08 22:37:18.461679+00
743	pom pon green athos 5pk	2026-03-08 22:37:18.462198+00
744	pom pon green bombellini 5pk	2026-03-08 22:37:18.462671+00
745	pom pon green button	2026-03-08 22:37:18.463158+00
746	pom pon green button country	2026-03-08 22:37:18.463593+00
747	pom pon green button ctry 12pk	2026-03-08 22:37:18.464064+00
748	pom pon green whatsapp 6pk	2026-03-08 22:37:18.464609+00
749	pom pon green zembla 6pk	2026-03-08 22:37:18.465061+00
750	pom pon grn butt country 5pk	2026-03-08 22:37:18.465542+00
751	pom pon grn butt whats app 5pk	2026-03-08 22:37:18.466117+00
752	pom pon lav melrose 6pk	2026-03-08 22:37:18.466611+00
753	pom pon lav prada sweet 6pk	2026-03-08 22:37:18.467077+00
754	pom pon lav veronica 6pk	2026-03-08 22:37:18.467559+00
755	pom pon lav. button	2026-03-08 22:37:18.468033+00
756	pom pon lav. button 5pk	2026-03-08 22:37:18.468473+00
757	pom pon lav. cushion	2026-03-08 22:37:18.468922+00
758	pom pon lav. cushion 5pk	2026-03-08 22:37:18.469459+00
759	pom pon lav. daisy 5pk	2026-03-08 22:37:18.46989+00
760	pom pon lavender daisy	2026-03-08 22:37:18.470408+00
761	pom pon lavender mystery 6pk	2026-03-08 22:37:18.470917+00
762	pom pon nov green alemani 5pk	2026-03-08 22:37:18.471427+00
763	pom pon novelty asst 12pk	2026-03-08 22:37:18.47192+00
764	pom pon novelty pink amaze 5pk	2026-03-08 22:37:18.47244+00
765	pom pon novelty ying yang	2026-03-08 22:37:18.472838+00
766	pom pon novelty ying yang 5pk	2026-03-08 22:37:18.473279+00
767	pom pon peach cushion 5pk	2026-03-08 22:37:18.473659+00
768	pom pon peach cushion 6pk	2026-03-08 22:37:18.474109+00
769	pom pon peach daisy 5pk	2026-03-08 22:37:18.47468+00
770	pom pon pink cushion	2026-03-08 22:37:18.475174+00
771	pom pon pink daisy 14pk	2026-03-08 22:37:18.475677+00
772	pom pon pink daisy alma	2026-03-08 22:37:18.476164+00
773	pom pon pink daisy aquarel 6pk	2026-03-08 22:37:18.476704+00
774	pom pon pink daisy atlantis	2026-03-08 22:37:18.477312+00
775	pom pon pink delirock 6pk	2026-03-08 22:37:18.477961+00
776	pom pon purple button	2026-03-08 22:37:18.47883+00
777	pom pon purple cushion	2026-03-08 22:37:18.479615+00
778	pom pon purple cushion 12pk	2026-03-08 22:37:18.480259+00
779	pom pon purple cushion 5pk	2026-03-08 22:37:18.480818+00
780	pom pon purple daisy 5pk	2026-03-08 22:37:18.481354+00
781	pom pon purple delirock 6pk	2026-03-08 22:37:18.481878+00
782	pom pon purple uvita 6pk	2026-03-08 22:37:18.482374+00
783	pom pon red button	2026-03-08 22:37:18.482825+00
784	pom pon red daisy bramis 5pk	2026-03-08 22:37:18.483491+00
785	pom pon salmon cushion 5pk	2026-03-08 22:37:18.483999+00
786	pom pon white button	2026-03-08 22:37:18.484508+00
787	pom pon white button 5pk	2026-03-08 22:37:18.485003+00
789	pom pon white cush maisy	2026-03-08 22:37:18.485842+00
790	pom pon white cush maisy 5pk	2026-03-08 22:37:18.486404+00
791	pom pon white cush maisy 8pk	2026-03-08 22:37:18.487105+00
792	pom pon white daisy alma	2026-03-08 22:37:18.487707+00
793	pom pon white daisy alma 6pk	2026-03-08 22:37:18.488218+00
794	pom pon white daisy coconut 6p	2026-03-08 22:37:18.488729+00
795	pom pon white daisy meraki 6p	2026-03-08 22:37:18.489221+00
796	pom pon white daisy reagan 15p	2026-03-08 22:37:18.489757+00
797	pom pon white eagle 6pk	2026-03-08 22:37:18.490297+00
798	pom pon white micro whynot 6pk	2026-03-08 22:37:18.490703+00
799	pom pon white top dollar 6pk	2026-03-08 22:37:18.491137+00
800	pom pon wht/grn zem/maisy lime	2026-03-08 22:37:18.491703+00
801	pom pon yel. viking sundi 5pk	2026-03-08 22:37:18.492199+00
802	pom pon yel. viking vybowl 5pk	2026-03-08 22:37:18.492725+00
803	pom pon yellow button	2026-03-08 22:37:18.493305+00
804	pom pon ylw daisy ylwstone 5pk	2026-03-08 22:37:18.493789+00
805	pom pon ylw paintball sunny 6p	2026-03-08 22:37:18.494227+00
806	assorted pink 15pk	2026-03-08 22:37:18.495395+00
807	queen pink empress	2026-03-08 22:37:18.496024+00
808	20in 10st	2026-03-08 22:37:18.497075+00
809	24in 10st	2026-03-08 22:37:18.497598+00
810	3-4ft 10-12st	2026-03-08 22:37:18.498179+00
811	30in 10st	2026-03-08 22:37:18.4988+00
812	4-5ft 10stem	2026-03-08 22:37:18.499392+00
813	laceflower green mist	2026-03-08 22:37:18.499996+00
814	laceflower chocolate ca	2026-03-08 22:37:18.500508+00
815	laceflower white queen anne's	2026-03-08 22:37:18.500991+00
816	laceflower white orlaya	2026-03-08 22:37:18.501495+00
817	apricot dbl 3-4ft 6st	2026-03-08 22:37:18.502018+00
818	6stems	2026-03-08 22:37:18.502461+00
819	5stem	2026-03-08 22:37:18.503058+00
820	6 stems	2026-03-08 22:37:18.504033+00
821	40/	2026-03-08 22:37:18.505785+00
822	brw matilda	2026-03-08 22:37:18.512404+00
823	brw moab	2026-03-08 22:37:18.512874+00
824	brw toffee	2026-03-08 22:37:18.513419+00
825	crm expression	2026-03-08 22:37:18.513899+00
826	crm quicksand	2026-03-08 22:37:18.514449+00
828	crm quicksand 50cm cs50	2026-03-08 22:37:18.515553+00
830	crm soul	2026-03-08 22:37:18.51646+00
831	dyed blue	2026-03-08 22:37:18.516927+00
832	dyed rainbow	2026-03-08 22:37:18.517434+00
833	gr green tea	2026-03-08 22:37:18.517904+00
834	gr lemonade	2026-03-08 22:37:18.518377+00
837	gr wasabi	2026-03-08 22:37:18.519678+00
838	hpk cherry-o	2026-03-08 22:37:18.520144+00
840	hpk country blues	2026-03-08 22:37:18.520901+00
842	hpk dark expression	2026-03-08 22:37:18.521589+00
843	hpk full monty	2026-03-08 22:37:18.522119+00
845	hpk hot spot	2026-03-08 22:37:18.523222+00
846	hpk lola	2026-03-08 22:37:18.523752+00
847	hpk pk floyd	2026-03-08 22:37:18.524246+00
849	hpk pk floyd 60cm cs50	2026-03-08 22:37:18.525051+00
850	hpk tina	2026-03-08 22:37:18.525575+00
851	hpk tina 50cm dvf	2026-03-08 22:37:18.526084+00
853	hpk tina 60cm cs50	2026-03-08 22:37:18.526898+00
854	hpk tina 60cm dvf	2026-03-08 22:37:18.527383+00
855	hpk topaz	2026-03-08 22:37:18.527897+00
857	lav amnesia	2026-03-08 22:37:18.528768+00
858	lav andrea	2026-03-08 22:37:18.529323+00
859	lav ascot	2026-03-08 22:37:18.529834+00
860	lav blue dream	2026-03-08 22:37:18.530688+00
861	lav blueberry	2026-03-08 22:37:18.531247+00
862	lav cool down	2026-03-08 22:37:18.531773+00
863	lav cool water	2026-03-08 22:37:18.532272+00
864	lav cool water 50cm cs50	2026-03-08 22:37:18.532785+00
866	lav cool water 60cm cs50	2026-03-08 22:37:18.533473+00
867	lav deep ppl	2026-03-08 22:37:18.533902+00
868	lav deep ppl 50cm cs50	2026-03-08 22:37:18.53429+00
871	lav deep ppl 60cm cs50	2026-03-08 22:37:18.535593+00
872	lav govinda	2026-03-08 22:37:18.536605+00
873	lav grey knights	2026-03-08 22:37:18.537154+00
874	lav menta	2026-03-08 22:37:18.537763+00
875	lav moody blues	2026-03-08 22:37:18.538242+00
877	lav ocean song	2026-03-08 22:37:18.539086+00
878	lav ocean song 50cm cs50	2026-03-08 22:37:18.53959+00
880	org bohemian	2026-03-08 22:37:18.540429+00
881	org crush	2026-03-08 22:37:18.540901+00
883	org crush 50cm cs50	2026-03-08 22:37:18.541562+00
885	org free spirit	2026-03-08 22:37:18.542277+00
886	org free spirit 40cm cs50	2026-03-08 22:37:18.542872+00
888	org free spirit 50cm cs50	2026-03-08 22:37:18.543742+00
890	org joy	2026-03-08 22:37:18.544553+00
891	org nina	2026-03-08 22:37:18.545066+00
892	pch coral reef	2026-03-08 22:37:18.545563+00
893	pch country home	2026-03-08 22:37:18.546049+00
894	pch felicity	2026-03-08 22:37:18.546524+00
896	pch honeyglow	2026-03-08 22:37:18.547211+00
897	pch phoenix	2026-03-08 22:37:18.547634+00
899	pch phoenix 70-	2026-03-08 22:37:18.548426+00
900	pch shimmer	2026-03-08 22:37:18.548919+00
901	pch shimmer 50cm cs50	2026-03-08 22:37:18.549313+00
903	pch shimmer 60cm cs50	2026-03-08 22:37:18.54998+00
904	pch tiffany	2026-03-08 22:37:18.550442+00
907	pk asst 40cm cs125	2026-03-08 22:37:18.551572+00
908	pk christa	2026-03-08 22:37:18.552046+00
909	pk expression	2026-03-08 22:37:18.552486+00
912	pk faith	2026-03-08 22:37:18.553564+00
913	pk flirty	2026-03-08 22:37:18.554114+00
914	pk garden spirit	2026-03-08 22:37:18.55451+00
915	pk geraldine	2026-03-08 22:37:18.554868+00
918	pk hermosa	2026-03-08 22:37:18.555701+00
920	pk hermosa 60cm cs50	2026-03-08 22:37:18.556376+00
921	pk miss piggy	2026-03-08 22:37:18.55683+00
922	pk mondial	2026-03-08 22:37:18.557369+00
925	pk mondial 60cm x50	2026-03-08 22:37:18.558505+00
926	pk mondial 70/	2026-03-08 22:37:18.559017+00
927	pk mother of prl	2026-03-08 22:37:18.559505+00
929	pk nena	2026-03-08 22:37:18.560329+00
931	pk nuage	2026-03-08 22:37:18.56111+00
932	pk opala	2026-03-08 22:37:18.561556+00
933	pk pnky promise 60cm dvf	2026-03-08 22:37:18.56202+00
934	pk shy 50cm cs50	2026-03-08 22:37:18.562473+00
935	pk shy	2026-03-08 22:37:18.562952+00
936	pk swt eskimo	2026-03-08 22:37:18.563458+00
937	pk swt eskimo 50cm cs100	2026-03-08 22:37:18.564361+00
939	pk swt unique	2026-03-08 22:37:18.565398+00
940	pk swt unique 50cm cs50	2026-03-08 22:37:18.5659+00
942	rd bl baccara	2026-03-08 22:37:18.566706+00
945	rd black pearl	2026-03-08 22:37:18.567807+00
946	rd explorer	2026-03-08 22:37:18.568265+00
949	rd explorer 70/	2026-03-08 22:37:18.56925+00
950	rd freedom	2026-03-08 22:37:18.569684+00
954	rd freedom 50cm cs100	2026-03-08 22:37:18.571104+00
955	rd freedom 50cm cs125	2026-03-08 22:37:18.571557+00
960	rd freedom 60cm cs100	2026-03-08 22:37:18.573481+00
963	rd freedom 70-	2026-03-08 22:37:18.574692+00
965	rd freedom 70/80cm cs100	2026-03-08 22:37:18.575539+00
966	rd freedom 70cm cs100	2026-03-08 22:37:18.576509+00
967	rd hearts	2026-03-08 22:37:18.577187+00
970	rd mama mia 40cm cs125	2026-03-08 22:37:18.578698+00
971	rd mama mia	2026-03-08 22:37:18.579392+00
973	sal amsterdam	2026-03-08 22:37:18.580306+00
974	sal dragonfly	2026-03-08 22:37:18.580822+00
975	var 3d	2026-03-08 22:37:18.581533+00
976	var barista	2026-03-08 22:37:18.582242+00
978	var bluez	2026-03-08 22:37:18.583363+00
979	var cherry brandy	2026-03-08 22:37:18.583998+00
980	var high & magic	2026-03-08 22:37:18.584547+00
982	var kahala	2026-03-08 22:37:18.585403+00
983	wht aspen	2026-03-08 22:37:18.585957+00
984	wht asst 40cm cs125	2026-03-08 22:37:18.586633+00
985	wht coldplay 60cm 12st	2026-03-08 22:37:18.587205+00
986	wht cotton expr	2026-03-08 22:37:18.587703+00
988	wht eskimo 40cm cs125	2026-03-08 22:37:18.588593+00
989	wht eskimo	2026-03-08 22:37:18.589195+00
991	wht eskimo 50cm cs100	2026-03-08 22:37:18.590446+00
992	wht eskimo 50cm cs50	2026-03-08 22:37:18.591331+00
994	wht mondial	2026-03-08 22:37:18.592568+00
996	wht mondial 50cm cs50	2026-03-08 22:37:18.593479+00
998	wht mondial 60cm cs50	2026-03-08 22:37:18.594499+00
999	wht mondial 60cm dvf	2026-03-08 22:37:18.595384+00
1000	wht moonstone	2026-03-08 22:37:18.596194+00
1001	wht playa blnca 50c cs100	2026-03-08 22:37:18.597124+00
1002	wht playa blnca	2026-03-08 22:37:18.599009+00
1003	wht playa blnca 60c cs100	2026-03-08 22:37:18.59961+00
1005	wht playa blnca 70/	2026-03-08 22:37:18.60057+00
1006	wht polo	2026-03-08 22:37:18.601125+00
1008	wht tibet	2026-03-08 22:37:18.602092+00
1010	wht tibet 50cm cs50	2026-03-08 22:37:18.602897+00
1012	wht vendela	2026-03-08 22:37:18.603815+00
1014	wht vendela 50cm cs50	2026-03-08 22:37:18.604722+00
1017	wht vendela 60cm cs50	2026-03-08 22:37:18.606105+00
1018	yel bikini	2026-03-08 22:37:18.606657+00
1020	yel brighton	2026-03-08 22:37:18.607563+00
1022	yel bumblebee	2026-03-08 22:37:18.608439+00
1024	yel butterscotch	2026-03-08 22:37:18.609082+00
1025	yel cancun	2026-03-08 22:37:18.609694+00
1026	yel cancun 50cm cs50	2026-03-08 22:37:18.610213+00
1028	yel gelosia 40cm cs50	2026-03-08 22:37:18.611304+00
1029	yel gelosia 50cm cs50	2026-03-08 22:37:18.612108+00
1030	yel high & exot	2026-03-08 22:37:18.612745+00
1033	yel momentum	2026-03-08 22:37:18.614311+00
1035	yel stardust	2026-03-08 22:37:18.615411+00
1036	yel summer rom.	2026-03-08 22:37:18.615964+00
1037	yel turtle	2026-03-08 22:37:18.616554+00
1038	wht	2026-03-08 22:37:18.617115+00
1039	scoop	2026-03-08 22:37:18.618914+00
1041	pods scabiosa stellata 10st	2026-03-08 22:37:18.62051+00
1046	chile	2026-03-08 22:37:18.627043+00
1047	ranunculus berry capp xxl 5st	2026-03-08 22:37:18.628669+00
1048	ranunculus asst xxl 5st 5pk	2026-03-08 22:37:18.62968+00
1049	ranunculus chocolate xl 10st	2026-03-08 22:37:18.630167+00
1050	ranunculus chocolate xxl 5st	2026-03-08 22:37:18.630802+00
1051	ranunculus coral desert xl 10s	2026-03-08 22:37:18.631317+00
1052	ranunculus coral fragolino xxl	2026-03-08 22:37:18.631779+00
1053	ranunculus pch grand pastel xx	2026-03-08 22:37:18.632321+00
1054	ranunculus pink blush clooney	2026-03-08 22:37:18.632778+00
1055	ranunculus pink blush xl 10st	2026-03-08 22:37:18.633261+00
1056	ranunculus pink blush xxl 5st	2026-03-08 22:37:18.633707+00
1057	ranunculus pink dark clooney i	2026-03-08 22:37:18.634239+00
1058	ranunculus pink hot xl 10st	2026-03-08 22:37:18.634693+00
1059	ranunculus pink hot xxl 5st ca	2026-03-08 22:37:18.635061+00
1060	ranunculus pink lady xxl 5st	2026-03-08 22:37:18.635424+00
1061	ranunculus pink lt confetto xx	2026-03-08 22:37:18.635992+00
1062	ranunculus pink lt xxl 5st	2026-03-08 22:37:18.636613+00
1063	ranunculus pink romance xxl 5s	2026-03-08 22:37:18.637482+00
1064	ranunculus pink ruffle xl 10st	2026-03-08 22:37:18.638008+00
1065	ranunculus pink ruffle xxl 5st	2026-03-08 22:37:18.638505+00
1066	ranunculus plum xl 10st	2026-03-08 22:37:18.63897+00
1067	ranunculus plum xxl 5st	2026-03-08 22:37:18.639458+00
1068	ranunculus princess peach xxl	2026-03-08 22:37:18.639981+00
1069	ranunculus red xl 10st	2026-03-08 22:37:18.640587+00
1070	ranunculus red xxl 5st	2026-03-08 22:37:18.641083+00
1071	ranunculus striato pastel xxl	2026-03-08 22:37:18.641583+00
1072	ranunculus white clooney italy	2026-03-08 22:37:18.642152+00
1073	ranunculus white xl 10st	2026-03-08 22:37:18.642619+00
1074	ranunculus white xxl 5st	2026-03-08 22:37:18.643009+00
1075	ranunculus yellow romance xxl	2026-03-08 22:37:18.64345+00
1076	ranunculus yellow xxl 5st	2026-03-08 22:37:18.64384+00
1077	80-	2026-03-08 22:37:18.64452+00
1078	10stem	2026-03-08 22:37:18.645489+00
1079	sprose wht majolica 40/	2026-03-08 22:37:18.647758+00
1080	sprose pch bali 40/	2026-03-08 22:37:18.648972+00
1081	sprose pch apricot bril stars	2026-03-08 22:37:18.649627+00
1082	sprose rd/brg rubicon 40/	2026-03-08 22:37:18.650608+00
1083	sprose wht floreana 40/	2026-03-08 22:37:18.651331+00
1084	sprose wht snowflake 40/	2026-03-08 22:37:18.651765+00
1085	sprose asst 40cm cs12	2026-03-08 22:37:18.652381+00
1086	sprose asst 40cm dvf cs12	2026-03-08 22:37:18.652837+00
1087	sprose asst 50cm cs10	2026-03-08 22:37:18.653466+00
1088	sprose crm gard cluster 5st	2026-03-08 22:37:18.653973+00
1089	sprose crm new moon	2026-03-08 22:37:18.654473+00
1090	sprose htpk bril star	2026-03-08 22:37:18.654982+00
1091	sprose htpk gem star 40/	2026-03-08 22:37:18.655435+00
1092	sprose htpk l lydia 40/	2026-03-08 22:37:18.657371+00
1093	sprose htpk majolica 40/	2026-03-08 22:37:18.657767+00
1095	sprose lav bl moon 40/	2026-03-08 22:37:18.65854+00
1096	sprose lav portrait 40/	2026-03-08 22:37:18.659046+00
1097	sprose lav silv mik 40/	2026-03-08 22:37:18.659472+00
1098	sprose org babe 40/	2026-03-08 22:37:18.659832+00
1099	sprose org royal flash 40/	2026-03-08 22:37:18.660207+00
1100	sprose org sensation 40/	2026-03-08 22:37:18.660647+00
1101	sprose pch aureus 40/	2026-03-08 22:37:18.661133+00
1102	sprose pch baby rosev 40/	2026-03-08 22:37:18.661648+00
1103	sprose pch capricorn 40/	2026-03-08 22:37:18.662167+00
1104	sprose pch ilse 40/	2026-03-08 22:37:18.662864+00
1105	sprose pch ltpk bril star	2026-03-08 22:37:18.663601+00
1106	sprose pk cozumel 40/50cm 5st	2026-03-08 22:37:18.664047+00
1107	sprose pk elba 40/	2026-03-08 22:37:18.664491+00
1108	sprose pk majolica 40/	2026-03-08 22:37:18.665015+00
1109	sprose pk majolica 50cm cs6	2026-03-08 22:37:18.665458+00
1110	sprose pk phuket	2026-03-08 22:37:18.665951+00
1111	sprose pk star blush 40/	2026-03-08 22:37:18.666527+00
1112	sprose rd mikado 40/	2026-03-08 22:37:18.666974+00
1113	sprose sal be joyful 50-	2026-03-08 22:37:18.667391+00
1114	sprose wht jeanine 40/	2026-03-08 22:37:18.667751+00
1115	sprose wht majo 50cm cs5	2026-03-08 22:37:18.668115+00
1116	sprose wht snoflk 50cm cs6	2026-03-08 22:37:18.668525+00
1117	sprose wht swt dreams 40/	2026-03-08 22:37:18.66893+00
1118	sprose yel babe 40/	2026-03-08 22:37:18.669394+00
1119	sprose yel bora bora 40/	2026-03-08 22:37:18.669842+00
1120	sprose yel bril star 40/	2026-03-08 22:37:18.670512+00
1121	sprose yel bril star lemon 50c	2026-03-08 22:37:18.671042+00
1122	sprose yel fibo gioconda	2026-03-08 22:37:18.672454+00
1123	sprose yel somerset 40/	2026-03-08 22:37:18.672803+00
1124	apricot tissue culture	2026-03-08 22:37:18.679153+00
1127	queens	2026-03-08 22:37:18.683496+00
1128	culture	2026-03-08 22:37:18.684476+00
1129	brg ruby red s.a.	2026-03-08 22:37:18.685875+00
1130	asst 4pk wt/lav s.a.	2026-03-08 22:37:18.690563+00
1131	brg ruby red 4pk s.a.	2026-03-08 22:37:18.69129+00
1132	s.a.	2026-03-08 22:37:18.692041+00
1134	mid	2026-03-08 22:37:18.694939+00
1135	magenta fuchsia	2026-03-08 22:37:18.695717+00
1136	magenta fuchsia s.a.	2026-03-08 22:37:18.696474+00
1137	magenta fuschia 4pk s.a.	2026-03-08 22:37:18.697507+00
1138	4pk s.a.	2026-03-08 22:37:18.698276+00
1144	4pk b	2026-03-08 22:37:18.704783+00
1148	5st 5pk	2026-03-08 22:37:18.709068+00
1150	assorted 10pk	2026-03-08 22:37:18.710772+00
1151	ylw vincent sel 5st	2026-03-08 22:37:18.713952+00
1152	vincent lg 5st 5pk	2026-03-08 22:37:18.715048+00
1153	ylw dc fny vin choic	2026-03-08 22:37:18.715839+00
1154	ylw dc sel vin choic	2026-03-08 22:37:18.716792+00
1155	ylw dc xtr vin choic	2026-03-08 22:37:18.717449+00
1156	ylw lc fcy vin fresh	2026-03-08 22:37:18.718112+00
1157	ylw lc sel vin fresh	2026-03-08 22:37:18.718783+00
1158	ylw lc xtr vin fresh	2026-03-08 22:37:18.719648+00
1159	ylw mini dc 10st	2026-03-08 22:37:18.720422+00
1160	ylw sunbright 5st	2026-03-08 22:37:18.721089+00
1161	ylw vin 5st 12pk mex	2026-03-08 22:37:18.721984+00
1162	ylw vin mini 10s 6pk	2026-03-08 22:37:18.72277+00
1163	ylw vin petite 10st	2026-03-08 22:37:18.723464+00
1164	ylw vin sel 5st 4pk	2026-03-08 22:37:18.724135+00
1165	ylw vincent 5st 6pk	2026-03-08 22:37:18.724761+00
1166	ylw vincent 8pk dvf	2026-03-08 22:37:18.725468+00
1167	dk pink happy 50stem	2026-03-08 22:37:18.726753+00
1168	50st	2026-03-08 22:37:18.728143+00
1169	25stem	2026-03-08 22:37:18.729022+00
1171	25st	2026-03-08 22:37:18.730756+00
1173	violet 25stem	2026-03-08 22:37:18.733161+00
1174	rd sacha	2026-03-08 22:37:18.734105+00
1175	60cm 6pk	2026-03-08 22:37:18.735059+00
1178	questar	2026-03-08 22:37:18.737799+00
1179	trachelium blue-dark	2026-03-08 22:37:18.73974+00
1180	trachelium green jade	2026-03-08 22:37:18.740403+00
1181	trachelium white	2026-03-08 22:37:18.741305+00
1182	aspidistra 10pk	2026-03-08 22:37:18.74213+00
1183	aspidistra variegated	2026-03-08 22:37:18.742804+00
1184	aspidistra xl	2026-03-08 22:37:18.743579+00
1185	leaf calathea white star	2026-03-08 22:37:18.744369+00
1186	leaf calathea zebrina	2026-03-08 22:37:18.744972+00
1187	leaf ginger variegated 10st	2026-03-08 22:37:18.745669+00
1188	leaf monstera jumbo/xl	2026-03-08 22:37:18.746321+00
1189	leaf monstera large	2026-03-08 22:37:18.746982+00
1190	leaf monstera medium	2026-03-08 22:37:18.747567+00
1191	leaf monstera mini	2026-03-08 22:37:18.748123+00
1192	leaf monstera small	2026-03-08 22:37:18.748698+00
1193	leaf ti green	2026-03-08 22:37:18.749286+00
1194	leaf ti red	2026-03-08 22:37:18.749871+00
1195	aspidistra	2026-03-08 22:37:18.750476+00
1196	asst 15pk va	2026-03-08 22:37:18.756175+00
1197	lav candy prince dutch	2026-03-08 22:37:18.757188+00
1199	pnk lt first class dutch	2026-03-08 22:37:18.759153+00
1200	prp prince dutch	2026-03-08 22:37:18.759768+00
1203	queen	2026-03-08 22:37:18.766092+00
1205	stephanie	2026-03-08 22:37:18.767652+00
1207	wh hyb/blush maya	2026-03-08 22:37:18.769553+00
1208	14st	2026-03-08 22:37:18.770125+00
1210	asst roots peru 6pk	2026-03-08 22:37:18.771771+00
1211	cottage salmon	2026-03-08 22:37:18.772427+00
1213	aster white	2026-03-08 22:37:18.774344+00
1214	leucadedron	2026-03-08 22:37:18.775162+00
1215	green wicky	2026-03-08 22:37:18.776035+00
1216	fiorino iris	2026-03-08 22:37:18.776914+00
1217	lilliput forever	2026-03-08 22:37:18.777608+00
1218	lilliput magic frost	2026-03-08 22:37:18.778233+00
1219	lilliput nauge	2026-03-08 22:37:18.778796+00
1220	golden solidago	2026-03-08 22:37:18.779374+00
1221	solidago yellow	2026-03-08 22:37:18.78017+00
1222	solomio ard	2026-03-08 22:37:18.781151+00
1223	solomio berni	2026-03-08 22:37:18.781743+00
1224	solomio cas	2026-03-08 22:37:18.782319+00
1225	solomio edo	2026-03-08 22:37:18.782907+00
1226	solomio imre	2026-03-08 22:37:18.783466+00
1227	solomio sem	2026-03-08 22:37:18.783992+00
1228	solomio star snow tessino	2026-03-08 22:37:18.784534+00
1229	clavel hanoi	2026-03-08 22:37:18.785172+00
1230	bunny tail	2026-03-08 22:37:18.785792+00
1231	baby	2026-03-08 22:37:18.786676+00
1232	cinerea eucalipto	2026-03-08 22:37:18.78749+00
1233	parvula gum eucalipto	2026-03-08 22:37:18.788079+00
1234	polyantemus eucalipto	2026-03-08 22:37:18.78871+00
1235	coculus	2026-03-08 22:37:18.789307+00
1236	hebes	2026-03-08 22:37:18.790111+00
1237	leather leaf	2026-03-08 22:37:18.790694+00
1238	photinia	2026-03-08 22:37:18.791263+00
1239	ruscus	2026-03-08 22:37:18.791829+00
1240	snapdragon red	2026-03-08 22:37:18.792666+00
1241	field pennycress	2026-03-08 22:37:18.793552+00
1242	all	2026-03-08 22:37:18.794136+00
1243	molucella	2026-03-08 22:37:18.794904+00
1244	rumex unicorn	2026-03-08 22:37:18.795462+00
1245	hypericum burgundy	2026-03-08 22:37:18.796067+00
1246	hypericum white	2026-03-08 22:37:18.796956+00
1247	lepidium white	2026-03-08 22:37:18.797941+00
1248	lepidium green	2026-03-08 22:37:18.79872+00
1249	cumulo	2026-03-08 22:37:18.799507+00
1250	limonium piña colada	2026-03-08 22:37:18.800514+00
1251	limonium pink pokers	2026-03-08 22:37:18.801155+00
1252	limonium shooting star	2026-03-08 22:37:18.802033+00
1253	silver	2026-03-08 22:37:18.802633+00
1254	snapdragon magenta	2026-03-08 22:37:18.803456+00
1255	snapdragon orange	2026-03-08 22:37:18.804074+00
1256	snapdragon white	2026-03-08 22:37:18.804867+00
1257	snapdragon pink	2026-03-08 22:37:18.805731+00
1258	snapdragon purple	2026-03-08 22:37:18.806497+00
1259	snapdragon yellow	2026-03-08 22:37:18.807417+00
1260	statice peach	2026-03-08 22:37:18.808272+00
1261	sinzii	2026-03-08 22:37:18.809003+00
1262	statice sinzii lilae	2026-03-08 22:37:18.809794+00
1263	statice sinzii silver	2026-03-08 22:37:18.810368+00
1264	sinzil deep	2026-03-08 22:37:18.810932+00
1265	stock cream	2026-03-08 22:37:18.811826+00
1266	stock hot pink	2026-03-08 22:37:18.812659+00
1267	stock lavander	2026-03-08 22:37:18.81366+00
1268	stock peach	2026-03-08 22:37:18.814284+00
1269	stock purple	2026-03-08 22:37:18.815118+00
1270	stock white	2026-03-08 22:37:18.815907+00
1271	stock yellow	2026-03-08 22:37:18.816713+00
1272	spray sunflower	2026-03-08 22:37:18.817517+00
1273	sunflower yellow	2026-03-08 22:37:18.818161+00
1274	craspedia jumbo	2026-03-08 22:37:18.819051+00
1275	larkspur pink	2026-03-08 22:37:18.819677+00
1276	larkspur purple	2026-03-08 22:37:18.820897+00
1277	larkspur white	2026-03-08 22:37:18.821772+00
1278	veronica purple	2026-03-08 22:37:18.822599+00
1279	veronica white	2026-03-08 22:37:18.823392+00
1280	astrantia burgundy	2026-03-08 22:37:18.824206+00
1281	astrantia light pink	2026-03-08 22:37:18.82499+00
1282	astrantia pink	2026-03-08 22:37:18.825755+00
1283	astrantia white	2026-03-08 22:37:18.826537+00
1284	blue spray delphinium	2026-03-08 22:37:18.82745+00
1285	delphinium black night	2026-03-08 22:37:18.828041+00
1286	delphinium light blue	2026-03-08 22:37:18.82861+00
1287	delphinium sea waltz	2026-03-08 22:37:18.829421+00
1288	delphinium sky waltz	2026-03-08 22:37:18.830012+00
1289	soft	2026-03-08 22:37:18.830599+00
1290	delphinium trick grape	2026-03-08 22:37:18.831419+00
1291	trick	2026-03-08 22:37:18.83225+00
1292	delphinium white	2026-03-08 22:37:18.833085+00
1293	delphinium white & black center	2026-03-08 22:37:18.833884+00
1295	spray delphinium sunshine	2026-03-08 22:37:18.835189+00
1296	delphinium white & black	2026-03-08 22:37:18.835953+00
1297	dubium white	2026-03-08 22:37:18.836787+00
1298	crisantemo linette	2026-03-08 22:37:18.837628+00
1299	crisantemo marrakesh	2026-03-08 22:37:18.838238+00
1300	crisantemo rosseta	2026-03-08 22:37:18.838878+00
1301	crisantemo	2026-03-08 22:37:18.839502+00
1302	gypsophila	2026-03-08 22:37:18.840656+00
1303	delphinium lavander	2026-03-08 22:37:18.841146+00
1304	dried pampas	2026-03-08 22:37:18.842391+00
1305	freesia lavender	2026-03-08 22:37:18.842921+00
1306	freesia tropical	2026-03-08 22:37:18.843812+00
1307	freesia white	2026-03-08 22:37:18.844452+00
1308	freesia yellow	2026-03-08 22:37:18.845276+00
1309	marigold orange	2026-03-08 22:37:18.846092+00
1310	flowering poppy mix	2026-03-08 22:37:18.846835+00
1311	flowering poppy	2026-03-08 22:37:18.847514+00
1312	teddys	2026-03-08 22:37:18.848323+00
1313	apricot spray rose	2026-03-08 22:37:18.848934+00
1314	bali spray rose	2026-03-08 22:37:18.849455+00
1315	be amazing spray rose	2026-03-08 22:37:18.850032+00
1316	be gentle spray rose	2026-03-08 22:37:18.850585+00
1317	be loving spray rose	2026-03-08 22:37:18.851105+00
1318	be nice spray rose	2026-03-08 22:37:18.851668+00
1319	be true spray rose	2026-03-08 22:37:18.852259+00
1320	big dipper spray rose	2026-03-08 22:37:18.852859+00
1321	candy spray rose	2026-03-08 22:37:18.853517+00
1322	creta spray rose	2026-03-08 22:37:18.854051+00
1323	elva spray rose	2026-03-08 22:37:18.855219+00
1324	fire up spray rose	2026-03-08 22:37:18.855728+00
1325	floreana spray rose	2026-03-08 22:37:18.857031+00
1326	lesbos spray rose	2026-03-08 22:37:18.857523+00
1327	majolica spray rose	2026-03-08 22:37:18.857994+00
1328	saona spray rose	2026-03-08 22:37:18.858699+00
1329	shinning star spray rose	2026-03-08 22:37:18.860477+00
1330	caucasian escabiosa deep	2026-03-08 22:37:18.860946+00
1331	caucasian escabiosa	2026-03-08 22:37:18.861666+00
1332	focal scoop banana	2026-03-08 22:37:18.862302+00
1333	focal scoop blackberry	2026-03-08 22:37:18.86279+00
1334	focal scoop cranberry	2026-03-08 22:37:18.863306+00
1335	focal scoop lavander	2026-03-08 22:37:18.863865+00
1336	focal scoop maraschino	2026-03-08 22:37:18.864363+00
1337	focal scoop	2026-03-08 22:37:18.864846+00
1338	focal scoop stellata	2026-03-08 22:37:18.86562+00
1339	focal scoop teaberry	2026-03-08 22:37:18.866145+00
1340	focal scoop ube	2026-03-08 22:37:18.866662+00
1341	hoop scoop strawberry	2026-03-08 22:37:18.867064+00
1342	rasberry ripple scoop	2026-03-08 22:37:18.867525+00
1343	scoop bon bon vanilla	2026-03-08 22:37:18.86795+00
1344	snowflake spray rose	2026-03-08 22:37:18.868487+00
1345	sweet pea blush	2026-03-08 22:37:18.869155+00
1346	sweet pea lavender	2026-03-08 22:37:18.869772+00
1347	sweet pea white	2026-03-08 22:37:18.870288+00
1348	campanula purple	2026-03-08 22:37:18.870813+00
1349	campanula white	2026-03-08 22:37:18.871492+00
1350	campanula	2026-03-08 22:37:18.872586+00
1351	didiscus white	2026-03-08 22:37:18.873369+00
1352	fatima garden	2026-03-08 22:37:18.874154+00
1353	aly	2026-03-08 22:37:18.874722+00
1354	andrea	2026-03-08 22:37:18.875303+00
1355	art deco	2026-03-08 22:37:18.875926+00
1357	bit more	2026-03-08 22:37:18.876763+00
1358	blizzard	2026-03-08 22:37:18.877324+00
1359	blue berry	2026-03-08 22:37:18.877948+00
1360	bromo	2026-03-08 22:37:18.879157+00
1362	explorer	2026-03-08 22:37:18.88031+00
1363	fair lady	2026-03-08 22:37:18.880855+00
1366	govinda	2026-03-08 22:37:18.882354+00
1368	hot spot	2026-03-08 22:37:18.883367+00
1369	idilia	2026-03-08 22:37:18.883896+00
1370	jalah	2026-03-08 22:37:18.884435+00
1372	merlot	2026-03-08 22:37:18.885379+00
1374	nena	2026-03-08 22:37:18.886102+00
1381	pink porcelain	2026-03-08 22:37:18.889773+00
1382	poma rosa	2026-03-08 22:37:18.890451+00
1383	pompei	2026-03-08 22:37:18.890821+00
1385	razzmatazz	2026-03-08 22:37:18.891401+00
1386	rhoslyn	2026-03-08 22:37:18.891731+00
1387	royal explorer	2026-03-08 22:37:18.892098+00
1388	sahara	2026-03-08 22:37:18.892488+00
1391	shocking	2026-03-08 22:37:18.893856+00
1392	south park	2026-03-08 22:37:18.894591+00
1393	sprit	2026-03-08 22:37:18.895205+00
1394	suspiro	2026-03-08 22:37:18.895805+00
1395	symbol	2026-03-08 22:37:18.896441+00
1396	tiara	2026-03-08 22:37:18.897003+00
1398	tie dye	2026-03-08 22:37:18.898019+00
1399	tinted mon	2026-03-08 22:37:18.898831+00
1400	tip top	2026-03-08 22:37:18.899449+00
1401	tycoon	2026-03-08 22:37:18.900036+00
1403	yoga	2026-03-08 22:37:18.900975+00
1404	yuraq	2026-03-08 22:37:18.901499+00
1405	sky	2026-03-08 22:37:18.902057+00
1406	tweedia white	2026-03-08 22:37:18.902848+00
1407	levante	2026-03-08 22:37:18.9036+00
1408	delphinium blue bird	2026-03-08 22:37:18.904319+00
1409	mistral	2026-03-08 22:37:18.90508+00
1410	mistral soft	2026-03-08 22:37:18.905828+00
1411	amandine picotte	2026-03-08 22:37:18.90655+00
1412	elegance	2026-03-08 22:37:18.907144+00
1413	elegance ciocolato	2026-03-08 22:37:18.90793+00
1414	elegance violet	2026-03-08 22:37:18.90843+00
1415	painted	2026-03-08 22:37:18.90901+00
1416	cinnamon	2026-03-08 22:37:18.909791+00
1417	amaranthus coral fourtain	2026-03-08 22:37:18.910605+00
1418	amaranthus green tails	2026-03-08 22:37:18.911186+00
1419	amaranthus hot biscuits	2026-03-08 22:37:18.911707+00
1420	ponytails	2026-03-08 22:37:18.912138+00
1421	amaranthus velvet curtains	2026-03-08 22:37:18.9129+00
1424	gypsophila raspberry tinted	2026-03-08 22:37:18.915017+00
1425	gypsophila terracota xclence	2026-03-08 22:37:18.915586+00
1426	gypsophila tinted cafe aulait	2026-03-08 22:37:18.916198+00
1427	pon pon dragonfruit	2026-03-08 22:37:18.916957+00
1428	pon pon igloo	2026-03-08 22:37:18.917579+00
1429	pon pon luna	2026-03-08 22:37:18.918187+00
1430	pon pon malva	2026-03-08 22:37:18.91873+00
1431	pon pon merlino	2026-03-08 22:37:18.919302+00
1432	mayra's	2026-03-08 22:37:18.919852+00
1433	red monster	2026-03-08 22:37:18.920559+00
1434	scarlata	2026-03-08 22:37:18.921315+00
1435	sunday morning	2026-03-08 22:37:18.921859+00
1436	antonia gardens	2026-03-08 22:37:18.922415+00
1437	aurora garden	2026-03-08 22:37:18.923069+00
1438	brujas	2026-03-08 22:37:18.923791+00
1439	candy expression	2026-03-08 22:37:18.924544+00
1440	dragon fly	2026-03-08 22:37:18.925117+00
1441	garden spirit	2026-03-08 22:37:18.92571+00
1442	hot	2026-03-08 22:37:18.926132+00
1443	ohara	2026-03-08 22:37:18.926687+00
1444	pink expression	2026-03-08 22:37:18.927203+00
1446	queen mayra	2026-03-08 22:37:18.928517+00
1447	red mayra	2026-03-08 22:37:18.929188+00
1448	siente	2026-03-08 22:37:18.930143+00
1449	white mayra	2026-03-08 22:37:18.930708+00
1450	mariposa magical strawberry	2026-03-08 22:37:18.931522+00
1451	mariposa magical	2026-03-08 22:37:18.932109+00
1452	butterfly eris cl	2026-03-08 22:37:18.932923+00
1453	butterfly grace w	2026-03-08 22:37:18.93346+00
1454	butterfly hades r	2026-03-08 22:37:18.933972+00
1455	butterfly helios - ly	2026-03-08 22:37:18.934502+00
1456	butterfly hera p	2026-03-08 22:37:18.935099+00
1457	butterfly lycia lv	2026-03-08 22:37:18.935618+00
1458	butterfly minoan o	2026-03-08 22:37:18.936145+00
1459	butterfly musa cl	2026-03-08 22:37:18.936905+00
1460	butterfly phytalos y	2026-03-08 22:37:18.937485+00
1461	mariposa magical caramel	2026-03-08 22:37:18.938049+00
1462	mariposa magical chocolate	2026-03-08 22:37:18.938583+00
1463	mariposa magical cinnamon	2026-03-08 22:37:18.939192+00
1464	mariposa magical raspberry	2026-03-08 22:37:18.939749+00
1465	natura moderna dolce	2026-03-08 22:37:18.940262+00
1466	natura moderna mielle	2026-03-08 22:37:18.940666+00
1467	success	2026-03-08 22:37:18.941015+00
1468	butterfly ariadne lp	2026-03-08 22:37:18.941603+00
1469	mariposa magical mascarpone	2026-03-08 22:37:18.941964+00
1470	success cloni favola	2026-03-08 22:37:18.942587+00
1471	success cloni lady	2026-03-08 22:37:18.943133+00
1472	success cloni nebbia	2026-03-08 22:37:18.943921+00
1473	success hanoi	2026-03-08 22:37:18.944497+00
1474	smilax garland	2026-03-08 22:37:18.945176+00
1475	hanging	2026-03-08 22:37:18.945679+00
1477	acropolis	2026-03-08 22:37:18.947067+00
1481	cheers	2026-03-08 22:37:18.949351+00
1482	choco	2026-03-08 22:37:18.950106+00
1485	pistache	2026-03-08 22:37:18.952218+00
1487	rosa	2026-03-08 22:37:18.953665+00
1489	sante	2026-03-08 22:37:18.95482+00
1490	tropical	2026-03-08 22:37:18.955584+00
1491	leaf	2026-03-08 22:37:18.956451+00
1492	palm cat medium	2026-03-08 22:37:18.957046+00
1493	palm cat small	2026-03-08 22:37:18.957591+00
1495	cordelyne leaf fucsia	2026-03-08 22:37:18.958655+00
1496	green large	2026-03-08 22:37:18.959238+00
1497	green medium	2026-03-08 22:37:18.959801+00
1498	green petite	2026-03-08 22:37:18.960369+00
1499	green small	2026-03-08 22:37:18.960908+00
1500	davalia	2026-03-08 22:37:18.961589+00
1501	masajeana variegated	2026-03-08 22:37:18.962228+00
1502	red medium	2026-03-08 22:37:18.962817+00
1503	foliate	2026-03-08 22:37:18.963642+00
1504	helecho macho	2026-03-08 22:37:18.964414+00
1505	hel. opal	2026-03-08 22:37:18.965102+00
1506	large	2026-03-08 22:37:18.96608+00
1507	palm raphis	2026-03-08 22:37:18.966653+00
1508	phi. xanadu	2026-03-08 22:37:18.967324+00
1509	phi. xantal	2026-03-08 22:37:18.967855+00
1510	fresh	2026-03-08 22:37:18.968531+00
1511	schefflera tip	2026-03-08 22:37:18.969111+00
1512	ginger nicole pink	2026-03-08 22:37:18.970089+00
1513	ginger plus red	2026-03-08 22:37:18.970969+00
1514	torch ginger red	2026-03-08 22:37:18.971713+00
1515	torch ginger pink	2026-03-08 22:37:18.972479+00
1516	ginger red large	2026-03-08 22:37:18.973151+00
1517	ginger red medium	2026-03-08 22:37:18.973626+00
1518	ginger red small	2026-03-08 22:37:18.973971+00
1519	ginger red petite	2026-03-08 22:37:18.974318+00
1520	ginger pink large	2026-03-08 22:37:18.974679+00
1521	ginger pink medium	2026-03-08 22:37:18.975195+00
1522	ginger white large	2026-03-08 22:37:18.975821+00
1523	ginger white medium	2026-03-08 22:37:18.976324+00
1524	ginger white small	2026-03-08 22:37:18.976835+00
1525	ginger white petite with leaves	2026-03-08 22:37:18.977407+00
1526	shampoo ginger yellow	2026-03-08 22:37:18.978018+00
1527	shampoo ginger red	2026-03-08 22:37:18.978921+00
1528	shampoo ginger peach	2026-03-08 22:37:18.980067+00
1529	shampoo ginger pink	2026-03-08 22:37:18.980927+00
1530	shampoo ginger green	2026-03-08 22:37:18.981637+00
1531	shampoo ginger brown	2026-03-08 22:37:18.982366+00
1532	shampoo ginger xl bicolor	2026-03-08 22:37:18.983095+00
1533	shampoo ginger xl yellow	2026-03-08 22:37:18.983622+00
1534	shampoo ginger xl red	2026-03-08 22:37:18.984359+00
1535	shampoo ginger xl peach	2026-03-08 22:37:18.985048+00
1536	shampoo ginger xl brown	2026-03-08 22:37:18.985759+00
1537	shampoo ginger white	2026-03-08 22:37:18.986526+00
1538	hel. prince of darkness large	2026-03-08 22:37:18.987771+00
1539	hel. caribaea red large	2026-03-08 22:37:18.988327+00
1540	hel. terracota xl	2026-03-08 22:37:18.989112+00
1541	hel. terracota large	2026-03-08 22:37:18.989717+00
1542	hel. rauliana large xl	2026-03-08 22:37:18.99028+00
1543	hel. rauliana large	2026-03-08 22:37:18.99072+00
1544	hel. iris red xlarge	2026-03-08 22:37:18.991123+00
1545	hel. iris red - big blooms 5-6 bracteas	2026-03-08 22:37:18.991633+00
1546	hel. iris red large	2026-03-08 22:37:18.991993+00
1547	hel. iris red medium	2026-03-08 22:37:18.992857+00
1548	hel. wagneriana yellow xl	2026-03-08 22:37:18.993711+00
1549	hel. wagneriana yellow large	2026-03-08 22:37:18.994509+00
1550	hel. wagneriana yellow medium	2026-03-08 22:37:18.995317+00
1551	hel. flamingo xl	2026-03-08 22:37:18.996216+00
1552	hel. flamingo large	2026-03-08 22:37:18.996876+00
1553	hel. flamingo medium	2026-03-08 22:37:18.997535+00
1554	hel. wagneriana red xl	2026-03-08 22:37:18.998206+00
1555	hel. wagneriana red large	2026-03-08 22:37:18.999211+00
1556	hel. wagneriana red medium	2026-03-08 22:37:19.000133+00
1557	hel. nativa xl	2026-03-08 22:37:19.001075+00
1558	hel. nativa large	2026-03-08 22:37:19.001667+00
1559	hel. nativa medium	2026-03-08 22:37:19.00229+00
1560	hel. sunshine large	2026-03-08 22:37:19.002906+00
1561	hel. sunshine medium	2026-03-08 22:37:19.003643+00
1562	hel. peach pink large	2026-03-08 22:37:19.004336+00
1563	hel. peach pink medium	2026-03-08 22:37:19.00518+00
1564	hel. bihai yellow large	2026-03-08 22:37:19.006077+00
1565	hel. bihai yellow medium	2026-03-08 22:37:19.007155+00
1566	hel. escarlata large	2026-03-08 22:37:19.008016+00
1567	hel. escarlata medium	2026-03-08 22:37:19.008634+00
1568	hel. esmeralda large	2026-03-08 22:37:19.009231+00
1569	hel. esmeralda medium	2026-03-08 22:37:19.009825+00
1570	hel. she kong xl	2026-03-08 22:37:19.010516+00
1571	hel. she kong large	2026-03-08 22:37:19.011223+00
1572	hel. bloody mary large	2026-03-08 22:37:19.012006+00
1573	hel. sexy scarlet large	2026-03-08 22:37:19.012797+00
1574	hel. sexy scarlet blue large	2026-03-08 22:37:19.01335+00
1575	hel. sexy orange large	2026-03-08 22:37:19.013883+00
1576	hel. rostrata xlarge	2026-03-08 22:37:19.014505+00
1577	hel. rostrata large	2026-03-08 22:37:19.014848+00
1578	hel. rostrata medium	2026-03-08 22:37:19.015342+00
1579	hel. rostrata small	2026-03-08 22:37:19.015902+00
1580	bird of paradise	2026-03-08 22:37:19.016572+00
1581	strilitzia white	2026-03-08 22:37:19.017229+00
1582	hel. golden fire opal	2026-03-08 22:37:19.018112+00
1583	hel. golden opal red	2026-03-08 22:37:19.018731+00
1584	hel. golden orange	2026-03-08 22:37:19.019633+00
1585	hel. sassy with or without leaves	2026-03-08 22:37:19.020649+00
1586	hel. golden opal	2026-03-08 22:37:19.021385+00
1587	hel. latispatha	2026-03-08 22:37:19.02216+00
1588	musa royal	2026-03-08 22:37:19.022829+00
1589	musa reina	2026-03-08 22:37:19.023463+00
1590	musa mouve	2026-03-08 22:37:19.024096+00
1591	musa linda	2026-03-08 22:37:19.024755+00
1592	musa orange	2026-03-08 22:37:19.025313+00
1593	musa pacari	2026-03-08 22:37:19.025945+00
1594	musa white	2026-03-08 22:37:19.026539+00
1595	musa without antena	2026-03-08 22:37:19.027181+00
1596	musa coccinea	2026-03-08 22:37:19.027896+00
1597	gran musa green xxl	2026-03-08 22:37:19.028787+00
1598	gran musa green xl	2026-03-08 22:37:19.029742+00
1599	gran musa green large	2026-03-08 22:37:19.030507+00
1600	baby banana green large	2026-03-08 22:37:19.031397+00
1601	baby banana green medium	2026-03-08 22:37:19.03222+00
1602	baby banana green small	2026-03-08 22:37:19.033047+00
1603	baby banana red large	2026-03-08 22:37:19.033916+00
1604	banana prayer hand large	2026-03-08 22:37:19.034836+00
1605	banana prayer hand medium	2026-03-08 22:37:19.035445+00
1606	black tulip	2026-03-08 22:37:19.036119+00
1607	eucalyptus fresh doll cluster	2026-03-08 22:37:19.036745+00
1608	eucalyptus fresh doll stem	2026-03-08 22:37:19.037551+00
1609	eucalyptus fresh pot cluster	2026-03-08 22:37:19.038186+00
1610	eucalyptus fresh pot stem	2026-03-08 22:37:19.038686+00
1611	eucalyptus fresh doll cluster red	2026-03-08 22:37:19.039049+00
1612	eucalyptus fresh pot cluster red	2026-03-08 22:37:19.039545+00
1613	banana fingers black	2026-03-08 22:37:19.040048+00
1614	banana fingers green	2026-03-08 22:37:19.040584+00
1615	banana fingers green pick	2026-03-08 22:37:19.04141+00
1616	night torch	2026-03-08 22:37:19.042217+00
1617	cacao pods decorative	2026-03-08 22:37:19.042787+00
1618	black kiss	2026-03-08 22:37:19.043379+00
1619	costus barbatus	2026-03-08 22:37:19.043947+00
1620	french kiss	2026-03-08 22:37:19.04449+00
1621	anana torch	2026-03-08 22:37:19.044886+00
1622	anana lucidus	2026-03-08 22:37:19.045426+00
1623	anana lucidus with leaves	2026-03-08 22:37:19.046006+00
1624	calathea yellow	2026-03-08 22:37:19.046596+00
1625	calathea brown with leaves	2026-03-08 22:37:19.047517+00
1626	calathea green ice	2026-03-08 22:37:19.04816+00
1627	caryota fresh l	2026-03-08 22:37:19.049164+00
1628	caryota fresh m	2026-03-08 22:37:19.049778+00
1629	caryota fresh s	2026-03-08 22:37:19.050362+00
1630	giant green large (not usa)	2026-03-08 22:37:19.050934+00
1631	giant green medium (not usa)	2026-03-08 22:37:19.051497+00
1632	asclepia 5 to 7 balls	2026-03-08 22:37:19.051925+00
1633	asclepia 3 to 5 balls	2026-03-08 22:37:19.052464+00
1634	asclepia 1 to 2 balls	2026-03-08 22:37:19.053103+00
1635	chili fat green stem	2026-03-08 22:37:19.053717+00
1636	hibiscus sabdariffa	2026-03-08 22:37:19.054573+00
1637	kangaroo paw	2026-03-08 22:37:19.05521+00
1638	anthurium red xlarge	2026-03-08 22:37:19.055839+00
1639	anthurium red large	2026-03-08 22:37:19.056652+00
1640	anthurium red medium	2026-03-08 22:37:19.057428+00
1641	anthurium hot pink xlarge	2026-03-08 22:37:19.058244+00
1642	anthurium hot pink large	2026-03-08 22:37:19.059083+00
1643	anthurium hot pink medium	2026-03-08 22:37:19.059838+00
1644	anthurium rosa/ santé/ cheers/senator xlarge	2026-03-08 22:37:19.060589+00
1645	anthurium rosa/ santé/ cheers/senator large	2026-03-08 22:37:19.061031+00
1646	anthurium rosa/ santé/ cheers/senator medium	2026-03-08 22:37:19.06161+00
1647	anthurium casino/choco/calisto/orange xlarge	2026-03-08 22:37:19.062189+00
1648	anthurium casino/choco/calisto/orange large	2026-03-08 22:37:19.062754+00
1649	anthurium casino/choco/calisto/orange medium	2026-03-08 22:37:19.063333+00
1650	anthurium white xlarge	2026-03-08 22:37:19.063878+00
1651	anthurium white large	2026-03-08 22:37:19.064642+00
1652	anthurium white medium	2026-03-08 22:37:19.065386+00
1653	anthurium green xlarge	2026-03-08 22:37:19.065889+00
1654	anthurium green large	2026-03-08 22:37:19.066612+00
1655	anthurium green medium	2026-03-08 22:37:19.067474+00
1656	anthurium assorted xlarge	2026-03-08 22:37:19.068319+00
1657	anthurium assorted large	2026-03-08 22:37:19.068894+00
1658	anthurium assorted medium	2026-03-08 22:37:19.069475+00
1659	amaranthus hanging red	2026-03-08 22:37:19.069998+00
1660	amaranthus hanging green	2026-03-08 22:37:19.070914+00
1661	amaranthus hanging mira bicolor	2026-03-08 22:37:19.071435+00
1662	amaranthus hanging bronze	2026-03-08 22:37:19.071775+00
1663	amaranthus upright red	2026-03-08 22:37:19.072438+00
1664	amaranthus upright green	2026-03-08 22:37:19.073216+00
1665	amaranthus upright bronze	2026-03-08 22:37:19.074073+00
1666	amaranthus upright orange	2026-03-08 22:37:19.074816+00
1667	amaranthus cascada red	2026-03-08 22:37:19.075585+00
1669	celosia cristata spray hot pink	2026-03-08 22:37:19.07685+00
1670	celosia cristata hot pink	2026-03-08 22:37:19.077401+00
1671	celosia cristata gold	2026-03-08 22:37:19.078094+00
1672	celosia cristata scarlet	2026-03-08 22:37:19.078944+00
1673	celosia cresta red	2026-03-08 22:37:19.079544+00
1674	celosia cresta red xl	2026-03-08 22:37:19.080347+00
1675	red sun flower	2026-03-08 22:37:19.081231+00
1677	curcuma elata	2026-03-08 22:37:19.082551+00
1678	hypericum mix	2026-03-08 22:37:19.083098+00
1679	hypericum red	2026-03-08 22:37:19.083701+00
1680	hypericum peach	2026-03-08 22:37:19.084234+00
1681	areca palm xl	2026-03-08 22:37:19.084848+00
1682	areca palm m	2026-03-08 22:37:19.085304+00
1683	areca palm s	2026-03-08 22:37:19.085729+00
1684	arrow palm	2026-03-08 22:37:19.086157+00
1685	fish tail	2026-03-08 22:37:19.086592+00
1686	accordeon palm xl	2026-03-08 22:37:19.0871+00
1687	accordeon palm l	2026-03-08 22:37:19.087741+00
1688	accordeon palm m	2026-03-08 22:37:19.088305+00
1689	licuala palm	2026-03-08 22:37:19.088901+00
1690	raphis palm	2026-03-08 22:37:19.089486+00
1691	deer face	2026-03-08 22:37:19.090182+00
1692	alocasia esmeralda large	2026-03-08 22:37:19.090744+00
1693	alocasia esmeralda medium	2026-03-08 22:37:19.091389+00
1694	alocasia esmeralda small	2026-03-08 22:37:19.09193+00
1695	alocasia green xl	2026-03-08 22:37:19.09291+00
1696	alocasia green large	2026-03-08 22:37:19.093581+00
1697	alocasia green medium	2026-03-08 22:37:19.094212+00
1698	alocasia green small	2026-03-08 22:37:19.09487+00
1699	alocasia xlarge bicolor	2026-03-08 22:37:19.095519+00
1700	alocasia large bicolor	2026-03-08 22:37:19.096241+00
1701	alocasia medium bicolor	2026-03-08 22:37:19.097077+00
1702	alocasia small bicolor	2026-03-08 22:37:19.09774+00
1703	monstera xlarge green	2026-03-08 22:37:19.098502+00
1704	monstera large green	2026-03-08 22:37:19.099476+00
1705	monstera medium green	2026-03-08 22:37:19.100148+00
1706	monstera small green	2026-03-08 22:37:19.100703+00
1707	monstera petite green	2026-03-08 22:37:19.101278+00
1708	monstera xlarge bicolor	2026-03-08 22:37:19.101851+00
1709	monstera large bicolor	2026-03-08 22:37:19.102466+00
1710	monstera medium bicolor	2026-03-08 22:37:19.103166+00
1711	alocasia and monstera bicolor mix sizes	2026-03-08 22:37:19.103833+00
1712	musa leaf xl	2026-03-08 22:37:19.10449+00
1713	musa leaf large	2026-03-08 22:37:19.105119+00
1714	musa leaf small	2026-03-08 22:37:19.105516+00
1715	phi pinnatifidum	2026-03-08 22:37:19.10595+00
1716	phi seloum	2026-03-08 22:37:19.106514+00
1717	trina palm round	2026-03-08 22:37:19.107087+00
1718	umbrella palm	2026-03-08 22:37:19.107694+00
1719	toquilla palm	2026-03-08 22:37:19.108298+00
1720	agave penco xl	2026-03-08 22:37:19.108747+00
1721	agave penco	2026-03-08 22:37:19.10913+00
1722	willow thick	2026-03-08 22:37:19.109547+00
1723	willow	2026-03-08 22:37:19.109968+00
1724	cocculos leaf	2026-03-08 22:37:19.110568+00
1725	sansevieria golden	2026-03-08 22:37:19.111062+00
1726	sansevieria silver	2026-03-08 22:37:19.111636+00
1727	cocoplum	2026-03-08 22:37:19.112105+00
1729	dieffenbachia lemon	2026-03-08 22:37:19.113506+00
1730	dieffenbachia white	2026-03-08 22:37:19.114174+00
1731	alpinia leave variegated	2026-03-08 22:37:19.114922+00
1732	eucalyptus long	2026-03-08 22:37:19.115542+00
1733	eucalyptus silver dollar	2026-03-08 22:37:19.116136+00
1734	calathea round leaf	2026-03-08 22:37:19.116777+00
1735	calathea zebrina leaf ce	2026-03-08 22:37:19.117379+00
1736	calathea zebrina leaf lm	2026-03-08 22:37:19.118045+00
1737	cordyline leaf dark green pink edge	2026-03-08 22:37:19.118571+00
1738	cordyline leaf fucsia	2026-03-08 22:37:19.119179+00
1739	cordyline leaf mix	2026-03-08 22:37:19.119859+00
1740	cordyline leaf xl full green	2026-03-08 22:37:19.120586+00
1741	cordyline leaf xl pink edge	2026-03-08 22:37:19.12126+00
1742	cordyline leaf xl black	2026-03-08 22:37:19.12208+00
1743	cordyline tip fucsia (not usa)	2026-03-08 22:37:19.122721+00
1744	cordyline tip full green (not usa)	2026-03-08 22:37:19.123315+00
1745	cordyline tip dark green pink edge (not usa)	2026-03-08 22:37:19.123849+00
1746	phi congo red	2026-03-08 22:37:19.124291+00
1747	phi congo green	2026-03-08 22:37:19.124995+00
1748	phi xantal	2026-03-08 22:37:19.125795+00
1749	phi lemon	2026-03-08 22:37:19.126497+00
1750	phi esmeralda	2026-03-08 22:37:19.127208+00
1751	phi xanadu	2026-03-08 22:37:19.127807+00
1752	phi hope	2026-03-08 22:37:19.128429+00
1754	felicium fern (not usa)	2026-03-08 22:37:19.129668+00
1755	esparrago plumosa	2026-03-08 22:37:19.130239+00
1757	lettuce fern	2026-03-08 22:37:19.131243+00
1759	twisted fern	2026-03-08 22:37:19.132122+00
1760	pandanus green	2026-03-08 22:37:19.132723+00
1761	pandanus variegated	2026-03-08 22:37:19.133328+00
1762	pandanus curly variegated	2026-03-08 22:37:19.13391+00
1763	monedita	2026-03-08 22:37:19.134559+00
1764	croton tip lemon dop	2026-03-08 22:37:19.135123+00
1766	croton tip baby doll	2026-03-08 22:37:19.136437+00
1767	croton tip thin	2026-03-08 22:37:19.137136+00
1768	schefflera tip green	2026-03-08 22:37:19.137806+00
1769	schefflera tip bicolor	2026-03-08 22:37:19.138728+00
1770	anglonema tip green	2026-03-08 22:37:19.139316+00
1771	anglonema tip snow white	2026-03-08 22:37:19.140104+00
1772	anglonema tip pink and green ce	2026-03-08 22:37:19.140942+00
1773	anglonema tip pink and green lm	2026-03-08 22:37:19.141739+00
1775	coffee leaf	2026-03-08 22:37:19.142853+00
1776	aralia leaves	2026-03-08 22:37:19.143432+00
1777	aspidistra leaves	2026-03-08 22:37:19.144035+00
1778	schefflera leaves	2026-03-08 22:37:19.144684+00
1779	aralia japonica	2026-03-08 22:37:19.145304+00
1780	dried monochromatic box green	2026-03-08 22:37:19.146145+00
1781	dried monochromatic box xmass	2026-03-08 22:37:19.146991+00
1782	dried monochromatic box red	2026-03-08 22:37:19.147755+00
1783	dried monochromatic box metallic	2026-03-08 22:37:19.148519+00
1784	dried monochromatic box eart	2026-03-08 22:37:19.148964+00
1785	dried monochromatic box fall	2026-03-08 22:37:19.14939+00
1786	dried monochromatic box pink/red	2026-03-08 22:37:19.149932+00
1787	dried monochromatic box bleached	2026-03-08 22:37:19.15075+00
1788	dried monochromatic box pink	2026-03-08 22:37:19.151385+00
1789	dried monochromatic box fucsia	2026-03-08 22:37:19.152197+00
1790	dried monochromatic box lavender	2026-03-08 22:37:19.152774+00
1791	dried monochromatic box light pink	2026-03-08 22:37:19.15353+00
1792	dried monochromatic box pastel	2026-03-08 22:37:19.155002+00
1793	wow dried box	2026-03-08 22:37:19.155662+00
1794	deco dry xmass	2026-03-08 22:37:19.156067+00
1795	jingle preserved box	2026-03-08 22:37:19.156465+00
1796	dried deco pink box	2026-03-08 22:37:19.156865+00
1797	dried enchanted pink box	2026-03-08 22:37:19.157593+00
1798	dried pampas slim summer mix	2026-03-08 22:37:19.158449+00
1799	dried pampas slim fall mix	2026-03-08 22:37:19.159051+00
1800	dried summer box	2026-03-08 22:37:19.159599+00
1801	dried eternal box	2026-03-08 22:37:19.159962+00
1802	dried eternal rose box	2026-03-08 22:37:19.160393+00
1803	dried bqt eternal large xmass mix	2026-03-08 22:37:19.160733+00
1804	dried bqt eternal large fall mix	2026-03-08 22:37:19.161146+00
1805	dried bqt eternal large vday mix	2026-03-08 22:37:19.161811+00
1806	dried bqt eternal regular mix	2026-03-08 22:37:19.163342+00
1807	dried bqt lush botanicals mix	2026-03-08 22:37:19.164137+00
1808	semifresh willow wreath noel	2026-03-08 22:37:19.16474+00
1809	semifresh willow wreath shine	2026-03-08 22:37:19.165405+00
1810	semifresh willow wreath twinkle	2026-03-08 22:37:19.166079+00
1811	lunaria (any colour)	2026-03-08 22:37:19.166682+00
1812	orchad (any colour)	2026-03-08 22:37:19.167293+00
1813	oats (any colour)	2026-03-08 22:37:19.16793+00
1814	thypa (any colour)	2026-03-08 22:37:19.168531+00
1815	eucalyptus preserved natural	2026-03-08 22:37:19.169086+00
1816	eucalyptus preserved burgundy	2026-03-08 22:37:19.170158+00
1817	bunny tail (any colour)	2026-03-08 22:37:19.170977+00
1818	gypsophila (any colour)	2026-03-08 22:37:19.171462+00
1819	spikes (any colour)	2026-03-08 22:37:19.171895+00
1820	linum (any colour)	2026-03-08 22:37:19.17244+00
1821	craspedia (any colour)	2026-03-08 22:37:19.173058+00
1822	dried washingtonia round palm	2026-03-08 22:37:19.173593+00
1823	dried washingtonia heart palm	2026-03-08 22:37:19.174197+00
1824	spear palm fall	2026-03-08 22:37:19.174818+00
1825	dried sago palm bleached	2026-03-08 22:37:19.175416+00
1826	dried pampas fat natural	2026-03-08 22:37:19.175959+00
1827	dried pennisetum bleached	2026-03-08 22:37:19.176761+00
1828	dried pennisetum xmass	2026-03-08 22:37:19.177268+00
1829	gorso xmass	2026-03-08 22:37:19.177864+00
1830	dried banana leaf upright red	2026-03-08 22:37:19.178355+00
1831	dried ginger pink	2026-03-08 22:37:19.17898+00
1832	jungle apple l	2026-03-08 22:37:19.179834+00
1833	caryota dry bleached l	2026-03-08 22:37:19.180604+00
1834	caryota dry bleached m	2026-03-08 22:37:19.18152+00
1835	caryota dry red s	2026-03-08 22:37:19.182272+00
1836	chili fat pick*1 (any colour)	2026-03-08 22:37:19.183093+00
1837	loafa sponge pick*1 (any colour)	2026-03-08 22:37:19.183666+00
1838	loafa pick*1 orange halloween	2026-03-08 22:37:19.184117+00
1839	pennycress bleach	2026-03-08 22:37:19.184785+00
1840	andean aster (any colour)	2026-03-08 22:37:19.185252+00
1841	limonium bunch*10 (any colour)	2026-03-08 22:37:19.185852+00
1842	redwood grace wreath	2026-03-08 22:37:19.186434+00
1843	earthbound elegance wreath	2026-03-08 22:37:19.187108+00
1844	rudolf golden fresh wreath	2026-03-08 22:37:19.187773+00
1845	comet golden fresh wreath	2026-03-08 22:37:19.188518+00
1846	dasher golden fresh wreath	2026-03-08 22:37:19.189138+00
1847	cielo golden dried wreath	2026-03-08 22:37:19.189735+00
1848	eclipse golden dried wreath	2026-03-08 22:37:19.190293+00
1849	bleached golden dried wreath	2026-03-08 22:37:19.190869+00
1850	snow golden dried wreath	2026-03-08 22:37:19.191462+00
1851	snow gold wood box	2026-03-08 22:37:19.192017+00
1852	noel wood box	2026-03-08 22:37:19.192622+00
1853	green moss wood box	2026-03-08 22:37:19.19315+00
1854	rose red wood box	2026-03-08 22:37:19.193603+00
1855	bismark palm round shape, natural/tinted	2026-03-08 22:37:19.194032+00
1856	ginger dry gold	2026-03-08 22:37:19.195191+00
1857	podocarpus bleached or green	2026-03-08 22:37:19.196061+00
1858	jungle apple gold l	2026-03-08 22:37:19.196863+00
1859	jungle apple gold m	2026-03-08 22:37:19.197644+00
1860	jungle apple gold s	2026-03-08 22:37:19.198397+00
1862	gypsophila million star white	2026-03-08 22:37:19.199634+00
1863	calla lily mini white	2026-03-08 22:37:19.200199+00
1864	calla lily mini purple	2026-03-08 22:37:19.20092+00
1865	delphinium belladonna white	2026-03-08 22:37:19.201688+00
1866	delphinium sky waltz light blue 70cm	2026-03-08 22:37:19.20251+00
1867	dianthus solomio white	2026-03-08 22:37:19.203485+00
1868	eucalyptus parvifolia green	2026-03-08 22:37:19.204378+00
1869	eucalyptus silver dollar green	2026-03-08 22:37:19.205199+00
1870	leather green	2026-03-08 22:37:19.206016+00
1871	ruscus israeli green	2026-03-08 22:37:19.20683+00
1872	ruscus italian green 100 cm	2026-03-08 22:37:19.207619+00
1873	hydrangea dark blue medium	2026-03-08 22:37:19.208253+00
1875	lily oriental stargazer pink/white	2026-03-08 22:37:19.209555+00
1876	ranunculus cream	2026-03-08 22:37:19.210371+00
1877	ranunculus spray butterfly eris salmon	2026-03-08 22:37:19.210972+00
1878	rose mondial cream	2026-03-08 22:37:19.211674+00
1879	rose peach	2026-03-08 22:37:19.212297+00
1880	rose playa blanca white	2026-03-08 22:37:19.212724+00
1881	rose tibet white	2026-03-08 22:37:19.213426+00
1882	rose garden keira blush	2026-03-08 22:37:19.214459+00
1883	spray rose floreana white	2026-03-08 22:37:19.215334+00
1884	spray rose sahara sensation peach	2026-03-08 22:37:19.216185+00
1885	scabiosa french vanilla scoop blush	2026-03-08 22:37:19.216998+00
1886	scabiosa white	2026-03-08 22:37:19.217812+00
1887	statice tissue culture peach	2026-03-08 22:37:19.218341+00
1888	stock yellow select	2026-03-08 22:37:19.219116+00
1889	tulip light pink	2026-03-08 22:37:19.219914+00
1890	tulip white	2026-03-08 22:37:19.220813+00
1891	acacia foliage pearl silver	2026-03-08 22:37:19.221388+00
1893	chamomile daisy white	2026-03-08 22:37:19.222715+00
1894	eucalyptus gunnii green	2026-03-08 22:37:19.223576+00
1895	hydrangea mojito green medium	2026-03-08 22:37:19.224158+00
1896	calla lily super white 80cm	2026-03-08 22:37:19.224838+00
1897	orlaya white	2026-03-08 22:37:19.225671+00
1898	spray rose snowflake white	2026-03-08 22:37:19.226241+00
1899	eryngium magical blue lagoon blue	2026-03-08 22:37:19.227005+00
1901	gypsophila xlence white	2026-03-08 22:37:19.228499+00
1902	ranunculus clooney pink	2026-03-08 22:37:19.22928+00
1903	ranunculus white	2026-03-08 22:37:19.230102+00
1904	stock white select	2026-03-08 22:37:19.230676+00
1905	cypress carolina sapphire green	2026-03-08 22:37:19.231312+00
1906	douglas fir boughs green	2026-03-08 22:37:19.232124+00
1907	leyland cypress variegated	2026-03-08 22:37:19.232846+00
1908	ruscus italian green	2026-03-08 22:37:19.233224+00
1909	hydrangea white medium	2026-03-08 22:37:19.233725+00
1910	acacia blooming yellow	2026-03-08 22:37:19.234126+00
1911	allium japan snake ball green	2026-03-08 22:37:19.234943+00
1913	anemone mistral blush	2026-03-08 22:37:19.23639+00
1914	anthurium burgundy medium	2026-03-08 22:37:19.237273+00
1915	aspidistra green	2026-03-08 22:37:19.238255+00
1916	aster montecasino white	2026-03-08 22:37:19.238803+00
1917	astilbe burgundy	2026-03-08 22:37:19.239722+00
1920	garland gypsophila xlence white 5'	2026-03-08 22:37:19.240969+00
1922	ligustrum berry black	2026-03-08 22:37:19.242278+00
1923	pepperberry hanging pink	2026-03-08 22:37:19.242954+00
1924	fruiting branches blueberries green	2026-03-08 22:37:19.243622+00
1925	calla lily aethiopica white	2026-03-08 22:37:19.244193+00
1926	calla lily mini cranberry burgundy 40cm	2026-03-08 22:37:19.245035+00
1927	calla lily mini cranberry burgundy 50cm	2026-03-08 22:37:19.245858+00
1928	calla lily mini crystal blush white	2026-03-08 22:37:19.246653+00
1929	calla lily mini naomi purple	2026-03-08 22:37:19.247383+00
1930	calla lily mini schwarzwalder black	2026-03-08 22:37:19.248284+00
1931	calla lily mini white 50cm	2026-03-08 22:37:19.248857+00
1933	calla lily mini burgundy	2026-03-08 22:37:19.250247+00
1934	calla lily mini cranberry burgundy	2026-03-08 22:37:19.251044+00
1935	calla lily mini light pink	2026-03-08 22:37:19.251723+00
1936	calla lily mini nightcap	2026-03-08 22:37:19.252428+00
1937	calla lily mini nightcap purple	2026-03-08 22:37:19.252905+00
1938	carnation brut blush fancy	2026-03-08 22:37:19.253718+00
1939	carnation burgundy	2026-03-08 22:37:19.254949+00
1940	carnation hanoi blush	2026-03-08 22:37:19.255496+00
1941	carnation lege marrone beige	2026-03-08 22:37:19.256152+00
1942	carnation lizzy peach fancy	2026-03-08 22:37:19.257063+00
1943	carnation minerva purple/white fancy	2026-03-08 22:37:19.257857+00
1944	carnation white	2026-03-08 22:37:19.258562+00
1945	mini carnation white	2026-03-08 22:37:19.259048+00
1946	china mum bronze	2026-03-08 22:37:19.259599+00
1947	china mum white select	2026-03-08 22:37:19.26031+00
1948	chrysanthemum disbud andrea purple	2026-03-08 22:37:19.261081+00
1949	chrysanthemum disbud ball red	2026-03-08 22:37:19.261784+00
1950	chrysanthemum disbud cooper	2026-03-08 22:37:19.262483+00
1951	chrysanthemum disbud cooper bronze	2026-03-08 22:37:19.263019+00
1952	chrysanthemum disbud linette	2026-03-08 22:37:19.263735+00
1953	chrysanthemum disbud linette peach	2026-03-08 22:37:19.264204+00
1954	chrysanthemum disbud white	2026-03-08 22:37:19.265063+00
1955	pod clematis white	2026-03-08 22:37:19.26588+00
1956	delphinium belladonna dark blue	2026-03-08 22:37:19.266614+00
1957	delphinium belladonna light blue	2026-03-08 22:37:19.267229+00
1958	delphinium sea waltz dark blue 70cm	2026-03-08 22:37:19.26781+00
1959	delphinium sea waltz white	2026-03-08 22:37:19.268478+00
1960	preserved bleached fern white	2026-03-08 22:37:19.269137+00
1962	eucalyptus baby blue blue	2026-03-08 22:37:19.270606+00
1964	garland gypsophila xlence natural white	2026-03-08 22:37:19.271958+00
1965	garland gypsophila xlence white	2026-03-08 22:37:19.272652+00
1966	lily grass green	2026-03-08 22:37:19.273491+00
1967	agonis brown	2026-03-08 22:37:19.274292+00
1968	bear grass standard green	2026-03-08 22:37:19.275007+00
1969	cedar port orford green	2026-03-08 22:37:19.27568+00
1970	dusty miller silver	2026-03-08 22:37:19.276336+00
1971	eucalyptus seeded green	2026-03-08 22:37:19.276846+00
1973	eucalyptus willow green	2026-03-08 22:37:19.27799+00
1974	fruiting branches olive green	2026-03-08 22:37:19.279055+00
1975	huckleberry green	2026-03-08 22:37:19.279882+00
1976	lemon/salal tips green	2026-03-08 22:37:19.280754+00
1977	leyland cypress green	2026-03-08 22:37:19.281506+00
1978	mixed xmas greens evergreen	2026-03-08 22:37:19.282245+00
1979	nagi foliage green	2026-03-08 22:37:19.282913+00
1980	pittosporum pitto nigra variegated	2026-03-08 22:37:19.283612+00
1981	preserved italian ruscus bleached white	2026-03-08 22:37:19.28413+00
1982	princess pine green	2026-03-08 22:37:19.28484+00
1983	spruce baby tree green	2026-03-08 22:37:19.285522+00
1984	sword fern green	2026-03-08 22:37:19.286219+00
1985	fritillaria meleagris variegated purple	2026-03-08 22:37:19.286943+00
1986	helleborus queens red	2026-03-08 22:37:19.287554+00
1987	helleborus winterbells green/white	2026-03-08 22:37:19.288128+00
1988	hydrangea antique green	2026-03-08 22:37:19.288689+00
1989	hydrangea light blue medium	2026-03-08 22:37:19.289315+00
1990	hydrangea mojito green	2026-03-08 22:37:19.290063+00
1992	hypericum ivory	2026-03-08 22:37:19.29139+00
1993	hypericum rocky romance	2026-03-08 22:37:19.291894+00
1994	lily asiatic orange	2026-03-08 22:37:19.292373+00
1995	lily oriental light pink	2026-03-08 22:37:19.293088+00
1996	lily oriental white	2026-03-08 22:37:19.293813+00
1997	limonium misty white	2026-03-08 22:37:19.294572+00
1998	limonium misty white white	2026-03-08 22:37:19.295293+00
1999	limonium white	2026-03-08 22:37:19.29619+00
2000	lisianthus brown	2026-03-08 22:37:19.296792+00
2001	lisianthus purple	2026-03-08 22:37:19.297357+00
2002	lisianthus white	2026-03-08 22:37:19.297919+00
2003	moss sheet green	2026-03-08 22:37:19.298468+00
2004	calla lily super white	2026-03-08 22:37:19.299043+00
2005	cymbidium mini red	2026-03-08 22:37:19.299766+00
2006	plumosa green	2026-03-08 22:37:19.300566+00
2007	pompon button green	2026-03-08 22:37:19.301049+00
2008	pompon button lexy bronze	2026-03-08 22:37:19.30175+00
2009	pompon cushion burgundy	2026-03-08 22:37:19.302375+00
2010	pompon cushion red	2026-03-08 22:37:19.302867+00
2011	pompon cushion veronica salmon	2026-03-08 22:37:19.303733+00
2012	protea king pink	2026-03-08 22:37:19.304488+00
2013	queen annes lace white	2026-03-08 22:37:19.305278+00
2014	queen annes lace chocolate brown	2026-03-08 22:37:19.305951+00
2015	ranunculus blush	2026-03-08 22:37:19.306644+00
2016	ranunculus spray butterfly ariadne blush	2026-03-08 22:37:19.307145+00
2017	rose amnesia antique lavender	2026-03-08 22:37:19.307855+00
2018	rose black baccara dark red	2026-03-08 22:37:19.308589+00
2019	rose cappuccino beige	2026-03-08 22:37:19.309234+00
2020	rose cream/blush	2026-03-08 22:37:19.309933+00
2021	rose escimo white	2026-03-08 22:37:19.310406+00
2022	rose faith mauve	2026-03-08 22:37:19.311076+00
2023	rose playa blanca white 50cm	2026-03-08 22:37:19.311758+00
2024	rose quicksand beige	2026-03-08 22:37:19.312443+00
2025	rose tibet white 50cm	2026-03-08 22:37:19.31313+00
2026	rose garden wedding spirit blush 50cm	2026-03-08 22:37:19.313791+00
2027	rose garden white o'hara blush	2026-03-08 22:37:19.314373+00
2028	spray rose hanoi majolica blush pink	2026-03-08 22:37:19.314928+00
2029	spray rose rubicon dark red	2026-03-08 22:37:19.315615+00
2030	spray rose white majolika cream	2026-03-08 22:37:19.316263+00
2031	sanguisorba burgundy	2026-03-08 22:37:19.317054+00
2032	scabiosa blackberry scoop burgundy	2026-03-08 22:37:19.317515+00
2033	snapdragon burgundy	2026-03-08 22:37:19.318246+00
2034	snapdragon orange select	2026-03-08 22:37:19.318752+00
2035	snapdragon pink select	2026-03-08 22:37:19.319234+00
2036	snapdragon white select	2026-03-08 22:37:19.319751+00
2037	spray rose peach jewel pink/peach	2026-03-08 22:37:19.32031+00
2038	spray rose snowflake	2026-03-08 22:37:19.321062+00
2039	spray rose white majolika	2026-03-08 22:37:19.321572+00
2040	stock burgundy select	2026-03-08 22:37:19.322065+00
2041	stock mauve select	2026-03-08 22:37:19.322547+00
2042	stock peach select	2026-03-08 22:37:19.323038+00
2043	eryngium blue	2026-03-08 22:37:19.32352+00
2044	tulip double light pink	2026-03-08 22:37:19.324118+00
2045	tulip double northcap white	2026-03-08 22:37:19.32504+00
2046	tulip dyed brown	2026-03-08 22:37:19.325789+00
2047	tulip parrot super parrot green/white	2026-03-08 22:37:19.326477+00
2048	tulip red	2026-03-08 22:37:19.327182+00
2049	tulip royal virgin	2026-03-08 22:37:19.327537+00
2051	wax flower purple	2026-03-08 22:37:19.328276+00
2052	wax flower white	2026-03-08 22:37:19.328828+00
2053	carnation lege marrone beige fancy	2026-03-08 22:37:19.329235+00
2054	rose black magic dark red	2026-03-08 22:37:19.329918+00
2055	brunia silver	2026-03-08 22:37:19.330752+00
2057	chrysanthemum disbud ball white	2026-03-08 22:37:19.331765+00
2058	chrysanthemum disbud maisy white	2026-03-08 22:37:19.332543+00
2060	pompon button white	2026-03-08 22:37:19.333409+00
2061	preserved hanging amaranthus white	2026-03-08 22:37:19.334021+00
2062	calla lily mini pink	2026-03-08 22:37:19.334733+00
2063	astilbe white	2026-03-08 22:37:19.33548+00
2066	gomphrena assorted	2026-03-08 22:37:19.337402+00
2067	phlox assorted	2026-03-08 22:37:19.337897+00
2069	snapdragon burgundy select	2026-03-08 22:37:19.338862+00
2070	eryngium magical blue	2026-03-08 22:37:19.339247+00
2071	waxflower white	2026-03-08 22:37:19.339849+00
2072	lemon/salal green	2026-03-08 22:37:19.340549+00
2073	garland gypsophila xlence natural white 10'	2026-03-08 22:37:19.341394+00
2074	carnation assorted	2026-03-08 22:37:19.342185+00
2076	smilax green	2026-03-08 22:37:19.343227+00
2078	gerbera mini white	2026-03-08 22:37:19.34423+00
2079	waxflower pink	2026-03-08 22:37:19.344966+00
2080	dendrobium singapore mokara red	2026-03-08 22:37:19.345999+00
2081	carnation nobbio burgundy fancy	2026-03-08 22:37:19.346893+00
2082	palm leaf areca green	2026-03-08 22:37:19.347707+00
2083	hydrangea light blue	2026-03-08 22:37:19.34841+00
2084	lisianthus cream	2026-03-08 22:37:19.348946+00
2085	ranunculus spray butterfly pink	2026-03-08 22:37:19.349319+00
2086	ranunculus light pink	2026-03-08 22:37:19.349909+00
2088	spray rose garden be loving blush pink	2026-03-08 22:37:19.351206+00
2089	scabiosa blush	2026-03-08 22:37:19.351965+00
2090	spray rose white	2026-03-08 22:37:19.352669+00
2091	rose barista mauve	2026-03-08 22:37:19.353452+00
2092	pittosporum silver queen variegated	2026-03-08 22:37:19.354435+00
2093	eucalyptus assorted	2026-03-08 22:37:19.354982+00
2094	gypsophila overtime white	2026-03-08 22:37:19.355491+00
\.


--
-- Data for Name: variety_color_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.variety_color_categories (id, variety_id, color_type, primary_color_category_id, secondary_color_category_id, bicolor_type, secondary_color_searchable, created_at) FROM stdin;
1	1	single	14	\N	\N	f	2026-03-08 22:37:17.845476+00
2	2	single	14	\N	\N	f	2026-03-08 22:37:17.84958+00
3	3	single	14	\N	\N	f	2026-03-08 22:37:17.851394+00
4	4	single	14	\N	\N	f	2026-03-08 22:37:17.853534+00
5	5	single	14	\N	\N	f	2026-03-08 22:37:17.855634+00
6	6	single	14	\N	\N	f	2026-03-08 22:37:17.857095+00
7	7	single	1	\N	\N	f	2026-03-08 22:37:17.859393+00
8	8	single	1	\N	\N	f	2026-03-08 22:37:17.859946+00
9	9	single	1	\N	\N	f	2026-03-08 22:37:17.861549+00
10	10	single	1	\N	\N	f	2026-03-08 22:37:17.863058+00
11	11	single	1	\N	\N	f	2026-03-08 22:37:17.8641+00
12	12	single	1	\N	\N	f	2026-03-08 22:37:17.864678+00
13	13	single	1	\N	\N	f	2026-03-08 22:37:17.865469+00
14	14	single	1	\N	\N	f	2026-03-08 22:37:17.869427+00
15	15	single	1	\N	\N	f	2026-03-08 22:37:17.871434+00
16	16	single	1	\N	\N	f	2026-03-08 22:37:17.87305+00
17	17	single	1	\N	\N	f	2026-03-08 22:37:17.873676+00
18	18	single	1	\N	\N	f	2026-03-08 22:37:17.874285+00
19	19	single	1	\N	\N	f	2026-03-08 22:37:17.874963+00
20	20	single	1	\N	\N	f	2026-03-08 22:37:17.875532+00
21	21	bicolor	1	15	variegated	f	2026-03-08 22:37:17.876174+00
22	22	bicolor	1	15	variegated	f	2026-03-08 22:37:17.876999+00
23	23	bicolor	1	16	variegated	f	2026-03-08 22:37:17.877631+00
24	24	bicolor	15	16	variegated	f	2026-03-08 22:37:17.880441+00
25	25	single	15	\N	\N	f	2026-03-08 22:37:17.881246+00
26	26	single	9	\N	\N	f	2026-03-08 22:37:17.882079+00
27	27	single	9	\N	\N	f	2026-03-08 22:37:17.882821+00
28	28	single	9	\N	\N	f	2026-03-08 22:37:17.883583+00
29	29	single	9	\N	\N	f	2026-03-08 22:37:17.884298+00
30	30	single	9	\N	\N	f	2026-03-08 22:37:17.884997+00
31	31	single	9	\N	\N	f	2026-03-08 22:37:17.886041+00
32	32	single	9	\N	\N	f	2026-03-08 22:37:17.887278+00
33	33	single	9	\N	\N	f	2026-03-08 22:37:17.888093+00
34	34	single	9	\N	\N	f	2026-03-08 22:37:17.888891+00
35	35	single	9	\N	\N	f	2026-03-08 22:37:17.889703+00
36	36	single	15	\N	\N	f	2026-03-08 22:37:17.890492+00
37	37	single	15	\N	\N	f	2026-03-08 22:37:17.891125+00
38	38	single	15	\N	\N	f	2026-03-08 22:37:17.891743+00
39	39	single	15	\N	\N	f	2026-03-08 22:37:17.892685+00
40	40	single	15	\N	\N	f	2026-03-08 22:37:17.893514+00
41	41	single	16	\N	\N	f	2026-03-08 22:37:17.894244+00
42	42	single	16	\N	\N	f	2026-03-08 22:37:17.895194+00
43	43	single	16	\N	\N	f	2026-03-08 22:37:17.89637+00
44	44	single	16	\N	\N	f	2026-03-08 22:37:17.897315+00
45	45	single	16	\N	\N	f	2026-03-08 22:37:17.898039+00
46	46	single	16	\N	\N	f	2026-03-08 22:37:17.898879+00
47	47	single	16	\N	\N	f	2026-03-08 22:37:17.899641+00
48	48	single	16	\N	\N	f	2026-03-08 22:37:17.900522+00
49	49	single	16	\N	\N	f	2026-03-08 22:37:17.901223+00
50	50	single	11	\N	\N	f	2026-03-08 22:37:17.901921+00
51	51	single	11	\N	\N	f	2026-03-08 22:37:17.90261+00
52	52	single	11	\N	\N	f	2026-03-08 22:37:17.90334+00
53	53	single	11	\N	\N	f	2026-03-08 22:37:17.904263+00
54	54	single	11	\N	\N	f	2026-03-08 22:37:17.90501+00
55	55	single	11	\N	\N	f	2026-03-08 22:37:17.905781+00
56	56	single	11	\N	\N	f	2026-03-08 22:37:17.906664+00
57	57	single	7	\N	\N	f	2026-03-08 22:37:17.907557+00
58	58	single	7	\N	\N	f	2026-03-08 22:37:17.90826+00
59	59	single	7	\N	\N	f	2026-03-08 22:37:17.908946+00
60	60	single	7	\N	\N	f	2026-03-08 22:37:17.909719+00
61	61	single	7	\N	\N	f	2026-03-08 22:37:17.910442+00
62	62	single	7	\N	\N	f	2026-03-08 22:37:17.911185+00
63	63	single	7	\N	\N	f	2026-03-08 22:37:17.91204+00
64	64	single	7	\N	\N	f	2026-03-08 22:37:17.913243+00
65	65	single	2	\N	\N	f	2026-03-08 22:37:17.914151+00
66	66	single	2	\N	\N	f	2026-03-08 22:37:17.914853+00
67	67	single	2	\N	\N	f	2026-03-08 22:37:17.915558+00
68	68	single	2	\N	\N	f	2026-03-08 22:37:17.916184+00
69	69	single	5	\N	\N	f	2026-03-08 22:37:17.916956+00
70	70	single	5	\N	\N	f	2026-03-08 22:37:17.917741+00
71	71	single	5	\N	\N	f	2026-03-08 22:37:17.918438+00
72	72	single	5	\N	\N	f	2026-03-08 22:37:17.919174+00
73	73	single	5	\N	\N	f	2026-03-08 22:37:17.919942+00
74	74	single	5	\N	\N	f	2026-03-08 22:37:17.920991+00
75	75	single	5	\N	\N	f	2026-03-08 22:37:17.921807+00
76	76	single	5	\N	\N	f	2026-03-08 22:37:17.92257+00
77	77	single	5	\N	\N	f	2026-03-08 22:37:17.923447+00
78	78	single	5	\N	\N	f	2026-03-08 22:37:17.924239+00
79	79	bicolor	5	14	variegated	f	2026-03-08 22:37:17.924957+00
80	80	bicolor	5	14	variegated	f	2026-03-08 22:37:17.925632+00
81	81	bicolor	5	11	variegated	f	2026-03-08 22:37:17.926428+00
82	82	bicolor	5	15	variegated	f	2026-03-08 22:37:17.927288+00
83	83	single	21	\N	\N	f	2026-03-08 22:37:17.927974+00
84	84	single	21	\N	\N	f	2026-03-08 22:37:17.929088+00
85	85	single	21	\N	\N	f	2026-03-08 22:37:17.930105+00
86	86	single	21	\N	\N	f	2026-03-08 22:37:17.930875+00
87	87	single	21	\N	\N	f	2026-03-08 22:37:17.931826+00
88	88	single	21	\N	\N	f	2026-03-08 22:37:17.932555+00
89	89	single	21	\N	\N	f	2026-03-08 22:37:17.9333+00
90	90	single	21	\N	\N	f	2026-03-08 22:37:17.933988+00
91	91	single	21	\N	\N	f	2026-03-08 22:37:17.934807+00
92	92	single	22	\N	\N	f	2026-03-08 22:37:17.935367+00
93	93	single	29	\N	\N	f	2026-03-08 22:37:17.935914+00
94	114	single	1	\N	\N	f	2026-03-08 22:37:17.948673+00
95	115	single	6	\N	\N	f	2026-03-08 22:37:17.949694+00
96	116	single	25	\N	\N	f	2026-03-08 22:37:17.950413+00
97	126	single	27	\N	\N	f	2026-03-08 22:37:17.955886+00
98	130	single	27	\N	\N	f	2026-03-08 22:37:17.958148+00
99	133	single	25	\N	\N	f	2026-03-08 22:37:17.960824+00
100	148	single	25	\N	\N	f	2026-03-08 22:37:17.969546+00
101	150	single	1	\N	\N	f	2026-03-08 22:37:17.970711+00
102	150	single	27	\N	\N	f	2026-03-08 22:37:17.971307+00
103	164	single	8	\N	\N	f	2026-03-08 22:37:17.986049+00
104	165	single	11	\N	\N	f	2026-03-08 22:37:17.987793+00
105	166	single	22	\N	\N	f	2026-03-08 22:37:17.988943+00
106	167	single	14	\N	\N	f	2026-03-08 22:37:17.991257+00
107	168	single	14	\N	\N	f	2026-03-08 22:37:17.992093+00
108	169	single	14	\N	\N	f	2026-03-08 22:37:17.996116+00
109	170	single	14	\N	\N	f	2026-03-08 22:37:17.997141+00
110	165	single	14	\N	\N	f	2026-03-08 22:37:18.001346+00
111	172	single	14	\N	\N	f	2026-03-08 22:37:18.004139+00
112	165	single	1	\N	\N	f	2026-03-08 22:37:18.00549+00
114	182	single	22	\N	\N	f	2026-03-08 22:37:18.025979+00
115	182	single	1	\N	\N	f	2026-03-08 22:37:18.027301+00
116	184	single	5	\N	\N	f	2026-03-08 22:37:18.033449+00
117	185	single	5	\N	\N	f	2026-03-08 22:37:18.035126+00
118	193	single	25	\N	\N	f	2026-03-08 22:37:18.049517+00
119	194	single	25	\N	\N	f	2026-03-08 22:37:18.0521+00
120	213	single	14	\N	\N	f	2026-03-08 22:37:18.093653+00
121	226	single	7	\N	\N	f	2026-03-08 22:37:18.105614+00
122	227	single	7	\N	\N	f	2026-03-08 22:37:18.10632+00
123	227	single	15	\N	\N	f	2026-03-08 22:37:18.106859+00
124	229	single	15	\N	\N	f	2026-03-08 22:37:18.107506+00
125	230	single	22	\N	\N	f	2026-03-08 22:37:18.108395+00
126	236	single	1	\N	\N	f	2026-03-08 22:37:18.112238+00
127	284	single	15	\N	\N	f	2026-03-08 22:37:18.143352+00
128	289	single	18	\N	\N	f	2026-03-08 22:37:18.150551+00
129	290	single	25	\N	\N	f	2026-03-08 22:37:18.151273+00
130	290	single	1	\N	\N	f	2026-03-08 22:37:18.154304+00
131	302	single	11	\N	\N	f	2026-03-08 22:37:18.15953+00
132	303	single	22	\N	\N	f	2026-03-08 22:37:18.160352+00
133	304	single	14	\N	\N	f	2026-03-08 22:37:18.16092+00
134	336	single	27	\N	\N	f	2026-03-08 22:37:18.180039+00
135	337	single	27	\N	\N	f	2026-03-08 22:37:18.180728+00
136	338	single	25	\N	\N	f	2026-03-08 22:37:18.181463+00
137	350	single	1	\N	\N	f	2026-03-08 22:37:18.187641+00
138	351	single	1	\N	\N	f	2026-03-08 22:37:18.188347+00
139	352	single	25	\N	\N	f	2026-03-08 22:37:18.189686+00
140	362	single	25	\N	\N	f	2026-03-08 22:37:18.194894+00
142	380	single	21	\N	\N	f	2026-03-08 22:37:18.209507+00
143	380	single	1	\N	\N	f	2026-03-08 22:37:18.210094+00
144	380	single	5	\N	\N	f	2026-03-08 22:37:18.21054+00
145	385	single	6	\N	\N	f	2026-03-08 22:37:18.214074+00
146	398	single	18	\N	\N	f	2026-03-08 22:37:18.222355+00
148	400	single	10	\N	\N	f	2026-03-08 22:37:18.223606+00
149	398	single	11	\N	\N	f	2026-03-08 22:37:18.237785+00
150	400	single	11	\N	\N	f	2026-03-08 22:37:18.238376+00
153	398	single	7	\N	\N	f	2026-03-08 22:37:18.239979+00
154	400	single	7	\N	\N	f	2026-03-08 22:37:18.240576+00
155	432	single	7	\N	\N	f	2026-03-08 22:37:18.241322+00
156	433	single	7	\N	\N	f	2026-03-08 22:37:18.242122+00
157	434	single	7	\N	\N	f	2026-03-08 22:37:18.242971+00
160	398	single	1	\N	\N	f	2026-03-08 22:37:18.247232+00
161	165	single	15	\N	\N	f	2026-03-08 22:37:18.255535+00
163	474	single	25	\N	\N	f	2026-03-08 22:37:18.270686+00
164	475	single	25	\N	\N	f	2026-03-08 22:37:18.271464+00
165	165	single	20	\N	\N	f	2026-03-08 22:37:18.293308+00
166	193	single	15	\N	\N	f	2026-03-08 22:37:18.306165+00
167	534	single	15	\N	\N	f	2026-03-08 22:37:18.307037+00
168	535	single	25	\N	\N	f	2026-03-08 22:37:18.308188+00
169	535	single	15	\N	\N	f	2026-03-08 22:37:18.308744+00
170	537	single	15	\N	\N	f	2026-03-08 22:37:18.309415+00
171	535	single	22	\N	\N	f	2026-03-08 22:37:18.309937+00
172	537	single	14	\N	\N	f	2026-03-08 22:37:18.310454+00
173	540	single	1	\N	\N	f	2026-03-08 22:37:18.311161+00
174	542	single	1	\N	\N	f	2026-03-08 22:37:18.313181+00
175	542	single	15	\N	\N	f	2026-03-08 22:37:18.313832+00
176	545	single	27	\N	\N	f	2026-03-08 22:37:18.316624+00
177	165	single	27	\N	\N	f	2026-03-08 22:37:18.320526+00
178	552	single	27	\N	\N	f	2026-03-08 22:37:18.321435+00
179	553	single	27	\N	\N	f	2026-03-08 22:37:18.322157+00
180	554	single	27	\N	\N	f	2026-03-08 22:37:18.322844+00
181	555	single	27	\N	\N	f	2026-03-08 22:37:18.323503+00
182	556	single	27	\N	\N	f	2026-03-08 22:37:18.324206+00
183	557	single	27	\N	\N	f	2026-03-08 22:37:18.324855+00
184	558	single	25	\N	\N	f	2026-03-08 22:37:18.325633+00
185	545	single	25	\N	\N	f	2026-03-08 22:37:18.326196+00
186	554	single	25	\N	\N	f	2026-03-08 22:37:18.326579+00
187	552	single	25	\N	\N	f	2026-03-08 22:37:18.326964+00
188	562	single	25	\N	\N	f	2026-03-08 22:37:18.327593+00
189	563	single	25	\N	\N	f	2026-03-08 22:37:18.328346+00
190	564	single	25	\N	\N	f	2026-03-08 22:37:18.329059+00
191	165	single	25	\N	\N	f	2026-03-08 22:37:18.32955+00
193	556	single	25	\N	\N	f	2026-03-08 22:37:18.330842+00
194	227	single	25	\N	\N	f	2026-03-08 22:37:18.331541+00
197	571	single	22	\N	\N	f	2026-03-08 22:37:18.343373+00
198	572	single	22	\N	\N	f	2026-03-08 22:37:18.344142+00
199	592	single	25	\N	\N	f	2026-03-08 22:37:18.357925+00
200	593	single	25	\N	\N	f	2026-03-08 22:37:18.358664+00
201	597	single	15	\N	\N	f	2026-03-08 22:37:18.360549+00
202	598	single	15	\N	\N	f	2026-03-08 22:37:18.361172+00
203	592	single	14	\N	\N	f	2026-03-08 22:37:18.362282+00
204	601	single	14	\N	\N	f	2026-03-08 22:37:18.362994+00
205	597	single	14	\N	\N	f	2026-03-08 22:37:18.363605+00
206	603	single	14	\N	\N	f	2026-03-08 22:37:18.364506+00
207	598	single	1	\N	\N	f	2026-03-08 22:37:18.365083+00
208	605	single	27	\N	\N	f	2026-03-08 22:37:18.36587+00
209	606	single	27	\N	\N	f	2026-03-08 22:37:18.36661+00
210	606	single	1	\N	\N	f	2026-03-08 22:37:18.367201+00
211	609	single	22	\N	\N	f	2026-03-08 22:37:18.368892+00
212	610	single	15	\N	\N	f	2026-03-08 22:37:18.369613+00
213	611	single	22	\N	\N	f	2026-03-08 22:37:18.370265+00
214	610	single	1	\N	\N	f	2026-03-08 22:37:18.370969+00
216	614	single	15	\N	\N	f	2026-03-08 22:37:18.372559+00
217	615	single	15	\N	\N	f	2026-03-08 22:37:18.373186+00
218	616	single	15	\N	\N	f	2026-03-08 22:37:18.37381+00
220	618	single	22	\N	\N	f	2026-03-08 22:37:18.374922+00
221	615	single	22	\N	\N	f	2026-03-08 22:37:18.375456+00
222	614	single	22	\N	\N	f	2026-03-08 22:37:18.376012+00
223	611	single	1	\N	\N	f	2026-03-08 22:37:18.376528+00
224	615	single	1	\N	\N	f	2026-03-08 22:37:18.37709+00
225	614	single	1	\N	\N	f	2026-03-08 22:37:18.377615+00
226	540	single	6	\N	\N	f	2026-03-08 22:37:18.378947+00
228	693	single	27	\N	\N	f	2026-03-08 22:37:18.417289+00
229	694	single	1	\N	\N	f	2026-03-08 22:37:18.418143+00
230	696	single	25	\N	\N	f	2026-03-08 22:37:18.420361+00
231	696	single	1	\N	\N	f	2026-03-08 22:37:18.421942+00
233	704	single	22	\N	\N	f	2026-03-08 22:37:18.425577+00
234	705	single	27	\N	\N	f	2026-03-08 22:37:18.433652+00
235	712	single	8	\N	\N	f	2026-03-08 22:37:18.441723+00
236	712	single	10	\N	\N	f	2026-03-08 22:37:18.44231+00
237	714	single	15	\N	\N	f	2026-03-08 22:37:18.443087+00
238	715	single	15	\N	\N	f	2026-03-08 22:37:18.443759+00
240	717	single	15	\N	\N	f	2026-03-08 22:37:18.445009+00
241	718	single	14	\N	\N	f	2026-03-08 22:37:18.445754+00
242	719	single	1	\N	\N	f	2026-03-08 22:37:18.446498+00
243	720	single	1	\N	\N	f	2026-03-08 22:37:18.447199+00
244	818	single	15	\N	\N	f	2026-03-08 22:37:18.502659+00
245	819	single	15	\N	\N	f	2026-03-08 22:37:18.503582+00
246	820	single	1	\N	\N	f	2026-03-08 22:37:18.504282+00
247	821	single	1	\N	\N	f	2026-03-08 22:37:18.506041+00
248	1039	single	15	\N	\N	f	2026-03-08 22:37:18.619231+00
249	1039	single	1	\N	\N	f	2026-03-08 22:37:18.62004+00
250	380	single	15	\N	\N	f	2026-03-08 22:37:18.624086+00
252	606	single	5	\N	\N	f	2026-03-08 22:37:18.625764+00
254	1046	single	1	\N	\N	f	2026-03-08 22:37:18.627242+00
255	1077	single	1	\N	\N	f	2026-03-08 22:37:18.64495+00
256	1078	single	1	\N	\N	f	2026-03-08 22:37:18.645741+00
257	615	single	8	\N	\N	f	2026-03-08 22:37:18.680787+00
258	694	single	22	\N	\N	f	2026-03-08 22:37:18.682853+00
259	1127	single	22	\N	\N	f	2026-03-08 22:37:18.683899+00
260	1128	single	1	\N	\N	f	2026-03-08 22:37:18.684852+00
261	1132	single	2	\N	\N	f	2026-03-08 22:37:18.693004+00
262	362	single	21	\N	\N	f	2026-03-08 22:37:18.694359+00
263	1134	single	21	\N	\N	f	2026-03-08 22:37:18.695252+00
264	1138	single	17	\N	\N	f	2026-03-08 22:37:18.698662+00
265	1132	single	17	\N	\N	f	2026-03-08 22:37:18.699353+00
266	1132	single	7	\N	\N	f	2026-03-08 22:37:18.700386+00
267	362	single	15	\N	\N	f	2026-03-08 22:37:18.701798+00
268	1132	single	15	\N	\N	f	2026-03-08 22:37:18.702613+00
270	1144	single	15	\N	\N	f	2026-03-08 22:37:18.705286+00
271	1132	single	22	\N	\N	f	2026-03-08 22:37:18.706023+00
272	362	single	22	\N	\N	f	2026-03-08 22:37:18.707346+00
273	1132	single	1	\N	\N	f	2026-03-08 22:37:18.708491+00
274	1148	single	1	\N	\N	f	2026-03-08 22:37:18.70946+00
276	1168	single	21	\N	\N	f	2026-03-08 22:37:18.728491+00
277	1169	single	9	\N	\N	f	2026-03-08 22:37:18.729359+00
278	1169	single	7	\N	\N	f	2026-03-08 22:37:18.73025+00
279	1171	single	15	\N	\N	f	2026-03-08 22:37:18.731046+00
280	1168	single	14	\N	\N	f	2026-03-08 22:37:18.732515+00
281	1175	single	27	\N	\N	f	2026-03-08 22:37:18.735534+00
282	712	single	27	\N	\N	f	2026-03-08 22:37:18.736398+00
283	597	single	27	\N	\N	f	2026-03-08 22:37:18.737231+00
284	1178	single	25	\N	\N	f	2026-03-08 22:37:18.738184+00
287	1203	single	15	\N	\N	f	2026-03-08 22:37:18.766464+00
289	1205	single	15	\N	\N	f	2026-03-08 22:37:18.767926+00
291	1208	single	1	\N	\N	f	2026-03-08 22:37:18.770471+00
293	540	single	11	\N	\N	f	2026-03-08 22:37:18.773237+00
294	1213	single	1	\N	\N	f	2026-03-08 22:37:18.774667+00
295	1214	single	14	\N	\N	f	2026-03-08 22:37:18.775491+00
296	1215	single	25	\N	\N	f	2026-03-08 22:37:18.776338+00
297	1220	single	6	\N	\N	f	2026-03-08 22:37:18.7797+00
298	1221	single	5	\N	\N	f	2026-03-08 22:37:18.780593+00
299	1230	single	29	\N	\N	f	2026-03-08 22:37:18.786123+00
300	1231	single	27	\N	\N	f	2026-03-08 22:37:18.787007+00
301	1235	single	25	\N	\N	f	2026-03-08 22:37:18.789601+00
302	1239	single	25	\N	\N	f	2026-03-08 22:37:18.792156+00
303	1240	single	14	\N	\N	f	2026-03-08 22:37:18.792972+00
304	1242	single	1	\N	\N	f	2026-03-08 22:37:18.794458+00
305	1245	single	18	\N	\N	f	2026-03-08 22:37:18.796399+00
306	1246	single	1	\N	\N	f	2026-03-08 22:37:18.797323+00
307	1247	single	1	\N	\N	f	2026-03-08 22:37:18.798247+00
308	1248	single	25	\N	\N	f	2026-03-08 22:37:18.799043+00
309	1249	single	1	\N	\N	f	2026-03-08 22:37:18.799868+00
310	1251	single	15	\N	\N	f	2026-03-08 22:37:18.801485+00
311	1253	single	15	\N	\N	f	2026-03-08 22:37:18.802989+00
312	1255	single	11	\N	\N	f	2026-03-08 22:37:18.804407+00
313	1256	single	1	\N	\N	f	2026-03-08 22:37:18.805209+00
314	1257	single	15	\N	\N	f	2026-03-08 22:37:18.806048+00
315	1258	single	22	\N	\N	f	2026-03-08 22:37:18.806764+00
316	1259	single	5	\N	\N	f	2026-03-08 22:37:18.80773+00
317	1260	single	7	\N	\N	f	2026-03-08 22:37:18.808555+00
318	1261	single	10	\N	\N	f	2026-03-08 22:37:18.809313+00
319	1264	single	22	\N	\N	f	2026-03-08 22:37:18.811273+00
320	1265	single	2	\N	\N	f	2026-03-08 22:37:18.812152+00
321	1266	single	16	\N	\N	f	2026-03-08 22:37:18.813145+00
322	1268	single	7	\N	\N	f	2026-03-08 22:37:18.814655+00
323	1269	single	22	\N	\N	f	2026-03-08 22:37:18.815476+00
324	1270	single	1	\N	\N	f	2026-03-08 22:37:18.816238+00
325	1271	single	5	\N	\N	f	2026-03-08 22:37:18.817035+00
326	1273	single	5	\N	\N	f	2026-03-08 22:37:18.818462+00
327	1275	single	15	\N	\N	f	2026-03-08 22:37:18.820106+00
328	1276	single	22	\N	\N	f	2026-03-08 22:37:18.821233+00
329	1277	single	1	\N	\N	f	2026-03-08 22:37:18.822109+00
330	1278	single	22	\N	\N	f	2026-03-08 22:37:18.8229+00
331	1279	single	1	\N	\N	f	2026-03-08 22:37:18.823712+00
332	1280	single	18	\N	\N	f	2026-03-08 22:37:18.824505+00
333	1281	single	9	\N	\N	f	2026-03-08 22:37:18.825293+00
334	1282	single	15	\N	\N	f	2026-03-08 22:37:18.826081+00
335	1283	single	1	\N	\N	f	2026-03-08 22:37:18.826944+00
336	1286	single	26	\N	\N	f	2026-03-08 22:37:18.828912+00
337	1289	single	22	\N	\N	f	2026-03-08 22:37:18.830924+00
338	1291	single	4	\N	\N	f	2026-03-08 22:37:18.832596+00
339	1292	single	1	\N	\N	f	2026-03-08 22:37:18.833407+00
340	130	single	8	\N	\N	f	2026-03-08 22:37:18.83468+00
341	1295	single	27	\N	\N	f	2026-03-08 22:37:18.835474+00
342	1297	single	1	\N	\N	f	2026-03-08 22:37:18.837153+00
343	1301	single	1	\N	\N	f	2026-03-08 22:37:18.840244+00
344	1305	single	21	\N	\N	f	2026-03-08 22:37:18.843258+00
345	1307	single	1	\N	\N	f	2026-03-08 22:37:18.844769+00
346	1308	single	5	\N	\N	f	2026-03-08 22:37:18.845604+00
347	1309	single	11	\N	\N	f	2026-03-08 22:37:18.846362+00
348	1311	single	7	\N	\N	f	2026-03-08 22:37:18.847851+00
349	1327	single	1	\N	\N	f	2026-03-08 22:37:18.858261+00
350	1330	single	27	\N	\N	f	2026-03-08 22:37:18.86122+00
351	1331	single	1	\N	\N	f	2026-03-08 22:37:18.861918+00
352	1337	single	14	\N	\N	f	2026-03-08 22:37:18.865191+00
353	1344	single	1	\N	\N	f	2026-03-08 22:37:18.86874+00
354	1345	single	8	\N	\N	f	2026-03-08 22:37:18.869401+00
355	1346	single	21	\N	\N	f	2026-03-08 22:37:18.869957+00
356	1347	single	1	\N	\N	f	2026-03-08 22:37:18.870467+00
357	1348	single	22	\N	\N	f	2026-03-08 22:37:18.871001+00
358	1349	single	1	\N	\N	f	2026-03-08 22:37:18.871795+00
359	1350	single	15	\N	\N	f	2026-03-08 22:37:18.872909+00
360	1351	single	1	\N	\N	f	2026-03-08 22:37:18.873637+00
361	1359	single	27	\N	\N	f	2026-03-08 22:37:18.878383+00
363	46	single	15	\N	\N	f	2026-03-08 22:37:18.888756+00
364	31	single	15	\N	\N	f	2026-03-08 22:37:18.889353+00
365	1381	single	15	\N	\N	f	2026-03-08 22:37:18.89001+00
366	1391	single	27	\N	\N	f	2026-03-08 22:37:18.894126+00
367	1405	single	27	\N	\N	f	2026-03-08 22:37:18.902357+00
368	1406	single	1	\N	\N	f	2026-03-08 22:37:18.903128+00
369	1407	single	27	\N	\N	f	2026-03-08 22:37:18.903891+00
370	1408	single	27	\N	\N	f	2026-03-08 22:37:18.90455+00
371	1409	single	27	\N	\N	f	2026-03-08 22:37:18.905356+00
372	1410	single	22	\N	\N	f	2026-03-08 22:37:18.906112+00
373	1412	single	18	\N	\N	f	2026-03-08 22:37:18.907432+00
374	1415	single	6	\N	\N	f	2026-03-08 22:37:18.909301+00
375	1416	single	29	\N	\N	f	2026-03-08 22:37:18.910114+00
376	1417	single	10	\N	\N	f	2026-03-08 22:37:18.910829+00
377	1418	single	25	\N	\N	f	2026-03-08 22:37:18.911383+00
378	1420	single	14	\N	\N	f	2026-03-08 22:37:18.912471+00
379	1409	single	1	\N	\N	f	2026-03-08 22:37:18.913813+00
380	1302	single	11	\N	\N	f	2026-03-08 22:37:18.91453+00
381	1432	single	7	\N	\N	f	2026-03-08 22:37:18.920131+00
382	1433	single	14	\N	\N	f	2026-03-08 22:37:18.920867+00
383	1442	single	15	\N	\N	f	2026-03-08 22:37:18.926339+00
384	1444	single	15	\N	\N	f	2026-03-08 22:37:18.927455+00
385	1447	single	14	\N	\N	f	2026-03-08 22:37:18.929514+00
386	1449	single	1	\N	\N	f	2026-03-08 22:37:18.93107+00
387	1451	single	5	\N	\N	f	2026-03-08 22:37:18.932428+00
388	1467	single	1	\N	\N	f	2026-03-08 22:37:18.941206+00
389	1471	single	15	\N	\N	f	2026-03-08 22:37:18.943376+00
390	1475	single	25	\N	\N	f	2026-03-08 22:37:18.945928+00
391	1475	single	14	\N	\N	f	2026-03-08 22:37:18.946573+00
392	1477	single	1	\N	\N	f	2026-03-08 22:37:18.947353+00
396	1481	single	15	\N	\N	f	2026-03-08 22:37:18.949619+00
397	1482	single	29	\N	\N	f	2026-03-08 22:37:18.950382+00
400	1485	single	25	\N	\N	f	2026-03-08 22:37:18.952497+00
402	1487	single	15	\N	\N	f	2026-03-08 22:37:18.953887+00
404	1489	single	15	\N	\N	f	2026-03-08 22:37:18.955085+00
405	1490	single	14	\N	\N	f	2026-03-08 22:37:18.955869+00
406	1505	single	14	\N	\N	f	2026-03-08 22:37:18.965459+00
407	1511	single	25	\N	\N	f	2026-03-08 22:37:18.969426+00
408	1512	single	15	\N	\N	f	2026-03-08 22:37:18.970433+00
409	1513	single	14	\N	\N	f	2026-03-08 22:37:18.971255+00
410	1514	single	14	\N	\N	f	2026-03-08 22:37:18.972013+00
411	1515	single	15	\N	\N	f	2026-03-08 22:37:18.972717+00
412	1526	single	5	\N	\N	f	2026-03-08 22:37:18.978336+00
413	1527	single	14	\N	\N	f	2026-03-08 22:37:18.979385+00
414	1528	single	7	\N	\N	f	2026-03-08 22:37:18.980448+00
415	1529	single	15	\N	\N	f	2026-03-08 22:37:18.981177+00
416	1530	single	25	\N	\N	f	2026-03-08 22:37:18.981921+00
417	1531	single	29	\N	\N	f	2026-03-08 22:37:18.982601+00
418	1533	single	5	\N	\N	f	2026-03-08 22:37:18.983926+00
419	1534	single	14	\N	\N	f	2026-03-08 22:37:18.984604+00
420	1535	single	7	\N	\N	f	2026-03-08 22:37:18.985306+00
421	1536	single	29	\N	\N	f	2026-03-08 22:37:18.986059+00
422	1537	single	1	\N	\N	f	2026-03-08 22:37:18.987155+00
423	1539	single	14	\N	\N	f	2026-03-08 22:37:18.988626+00
424	1544	single	14	\N	\N	f	2026-03-08 22:37:18.991306+00
425	1546	single	14	\N	\N	f	2026-03-08 22:37:18.992325+00
426	1547	single	14	\N	\N	f	2026-03-08 22:37:18.993202+00
427	1548	single	5	\N	\N	f	2026-03-08 22:37:18.993993+00
428	1549	single	5	\N	\N	f	2026-03-08 22:37:18.994812+00
429	1550	single	5	\N	\N	f	2026-03-08 22:37:18.995622+00
430	1554	single	14	\N	\N	f	2026-03-08 22:37:18.998578+00
431	1555	single	14	\N	\N	f	2026-03-08 22:37:18.999602+00
432	1556	single	14	\N	\N	f	2026-03-08 22:37:19.000478+00
433	1562	single	15	\N	\N	f	2026-03-08 22:37:19.004645+00
434	1563	single	15	\N	\N	f	2026-03-08 22:37:19.005529+00
435	1564	single	5	\N	\N	f	2026-03-08 22:37:19.00655+00
436	1565	single	5	\N	\N	f	2026-03-08 22:37:19.007462+00
437	1574	single	27	\N	\N	f	2026-03-08 22:37:19.013545+00
438	1575	single	11	\N	\N	f	2026-03-08 22:37:19.014162+00
439	1581	single	1	\N	\N	f	2026-03-08 22:37:19.017504+00
440	1583	single	14	\N	\N	f	2026-03-08 22:37:19.01904+00
441	1584	single	11	\N	\N	f	2026-03-08 22:37:19.020011+00
442	1597	single	25	\N	\N	f	2026-03-08 22:37:19.029135+00
443	1598	single	25	\N	\N	f	2026-03-08 22:37:19.030023+00
444	1599	single	25	\N	\N	f	2026-03-08 22:37:19.030851+00
445	1600	single	25	\N	\N	f	2026-03-08 22:37:19.031725+00
446	1601	single	25	\N	\N	f	2026-03-08 22:37:19.032508+00
447	1602	single	25	\N	\N	f	2026-03-08 22:37:19.033418+00
448	1603	single	14	\N	\N	f	2026-03-08 22:37:19.03422+00
449	1611	single	14	\N	\N	f	2026-03-08 22:37:19.03923+00
450	1612	single	14	\N	\N	f	2026-03-08 22:37:19.039717+00
451	1614	single	25	\N	\N	f	2026-03-08 22:37:19.040923+00
452	1615	single	25	\N	\N	f	2026-03-08 22:37:19.041719+00
453	1624	single	5	\N	\N	f	2026-03-08 22:37:19.046929+00
454	1626	single	25	\N	\N	f	2026-03-08 22:37:19.048573+00
455	1635	single	25	\N	\N	f	2026-03-08 22:37:19.054043+00
456	1638	single	14	\N	\N	f	2026-03-08 22:37:19.05611+00
457	1639	single	14	\N	\N	f	2026-03-08 22:37:19.056886+00
458	1640	single	14	\N	\N	f	2026-03-08 22:37:19.057726+00
459	1641	single	15	\N	\N	f	2026-03-08 22:37:19.058589+00
460	1642	single	16	\N	\N	f	2026-03-08 22:37:19.059347+00
461	1643	single	16	\N	\N	f	2026-03-08 22:37:19.0602+00
462	1650	single	1	\N	\N	f	2026-03-08 22:37:19.064186+00
463	1651	single	1	\N	\N	f	2026-03-08 22:37:19.064974+00
464	1652	single	1	\N	\N	f	2026-03-08 22:37:19.06557+00
465	1653	single	25	\N	\N	f	2026-03-08 22:37:19.066088+00
466	1654	single	25	\N	\N	f	2026-03-08 22:37:19.066893+00
467	1655	single	25	\N	\N	f	2026-03-08 22:37:19.067806+00
468	1659	single	14	\N	\N	f	2026-03-08 22:37:19.070444+00
469	1660	single	25	\N	\N	f	2026-03-08 22:37:19.071106+00
470	1662	single	12	\N	\N	f	2026-03-08 22:37:19.071961+00
471	1663	single	14	\N	\N	f	2026-03-08 22:37:19.072735+00
472	1664	single	25	\N	\N	f	2026-03-08 22:37:19.073537+00
473	1665	single	12	\N	\N	f	2026-03-08 22:37:19.074342+00
474	1666	single	11	\N	\N	f	2026-03-08 22:37:19.075118+00
475	1667	single	14	\N	\N	f	2026-03-08 22:37:19.075871+00
476	1669	single	16	\N	\N	f	2026-03-08 22:37:19.077034+00
477	1670	single	16	\N	\N	f	2026-03-08 22:37:19.077651+00
478	1671	single	6	\N	\N	f	2026-03-08 22:37:19.078432+00
479	1673	single	14	\N	\N	f	2026-03-08 22:37:19.079848+00
480	1674	single	14	\N	\N	f	2026-03-08 22:37:19.080707+00
481	1703	single	25	\N	\N	f	2026-03-08 22:37:19.098901+00
482	1725	single	6	\N	\N	f	2026-03-08 22:37:19.111268+00
483	1737	single	15	\N	\N	f	2026-03-08 22:37:19.118758+00
484	1740	single	25	\N	\N	f	2026-03-08 22:37:19.120828+00
485	1741	single	15	\N	\N	f	2026-03-08 22:37:19.121572+00
486	1746	single	14	\N	\N	f	2026-03-08 22:37:19.124508+00
487	1747	single	25	\N	\N	f	2026-03-08 22:37:19.125281+00
488	1755	single	20	\N	\N	f	2026-03-08 22:37:19.130483+00
489	1768	single	25	\N	\N	f	2026-03-08 22:37:19.138099+00
490	1770	single	25	\N	\N	f	2026-03-08 22:37:19.139604+00
491	1771	single	1	\N	\N	f	2026-03-08 22:37:19.140405+00
492	1772	single	25	\N	\N	f	2026-03-08 22:37:19.141248+00
493	1773	single	25	\N	\N	f	2026-03-08 22:37:19.142118+00
494	1780	single	25	\N	\N	f	2026-03-08 22:37:19.14649+00
495	1782	single	14	\N	\N	f	2026-03-08 22:37:19.148121+00
496	1786	single	15	\N	\N	f	2026-03-08 22:37:19.150283+00
497	1788	single	15	\N	\N	f	2026-03-08 22:37:19.151714+00
498	1790	single	21	\N	\N	f	2026-03-08 22:37:19.153078+00
499	1791	single	9	\N	\N	f	2026-03-08 22:37:19.153894+00
500	1796	single	15	\N	\N	f	2026-03-08 22:37:19.157099+00
501	1797	single	15	\N	\N	f	2026-03-08 22:37:19.157907+00
502	1815	single	2	\N	\N	f	2026-03-08 22:37:19.16941+00
503	1816	single	18	\N	\N	f	2026-03-08 22:37:19.170437+00
504	1826	single	2	\N	\N	f	2026-03-08 22:37:19.176267+00
505	1830	single	14	\N	\N	f	2026-03-08 22:37:19.17857+00
506	1831	single	15	\N	\N	f	2026-03-08 22:37:19.179296+00
507	1835	single	14	\N	\N	f	2026-03-08 22:37:19.18261+00
508	1838	single	11	\N	\N	f	2026-03-08 22:37:19.18437+00
509	1855	single	2	\N	\N	f	2026-03-08 22:37:19.194614+00
510	1856	single	6	\N	\N	f	2026-03-08 22:37:19.195487+00
511	1857	single	25	\N	\N	f	2026-03-08 22:37:19.196362+00
512	1858	single	6	\N	\N	f	2026-03-08 22:37:19.197141+00
513	1859	single	6	\N	\N	f	2026-03-08 22:37:19.197944+00
514	1860	single	6	\N	\N	f	2026-03-08 22:37:19.198762+00
516	1862	single	1	\N	\N	f	2026-03-08 22:37:19.199837+00
517	1863	single	1	\N	\N	f	2026-03-08 22:37:19.200453+00
518	1864	single	22	\N	\N	f	2026-03-08 22:37:19.2012+00
519	1865	single	1	\N	\N	f	2026-03-08 22:37:19.201975+00
520	1866	single	27	\N	\N	f	2026-03-08 22:37:19.202829+00
521	1867	single	1	\N	\N	f	2026-03-08 22:37:19.203823+00
522	1868	single	25	\N	\N	f	2026-03-08 22:37:19.204699+00
523	1869	single	25	\N	\N	f	2026-03-08 22:37:19.205506+00
524	1870	single	25	\N	\N	f	2026-03-08 22:37:19.206331+00
525	1871	single	25	\N	\N	f	2026-03-08 22:37:19.207132+00
526	1873	single	27	\N	\N	f	2026-03-08 22:37:19.208563+00
527	1875	single	15	\N	\N	f	2026-03-08 22:37:19.209878+00
528	1877	single	10	\N	\N	f	2026-03-08 22:37:19.21127+00
529	1878	single	2	\N	\N	f	2026-03-08 22:37:19.211905+00
530	1880	single	1	\N	\N	f	2026-03-08 22:37:19.212928+00
531	1881	single	1	\N	\N	f	2026-03-08 22:37:19.213822+00
532	1882	single	8	\N	\N	f	2026-03-08 22:37:19.214828+00
533	1883	single	1	\N	\N	f	2026-03-08 22:37:19.215652+00
534	1884	single	7	\N	\N	f	2026-03-08 22:37:19.216481+00
535	1885	single	8	\N	\N	f	2026-03-08 22:37:19.217306+00
536	1887	single	7	\N	\N	f	2026-03-08 22:37:19.218655+00
537	1889	single	15	\N	\N	f	2026-03-08 22:37:19.220273+00
539	1893	single	1	\N	\N	f	2026-03-08 22:37:19.22305+00
540	1894	single	25	\N	\N	f	2026-03-08 22:37:19.223796+00
541	1895	single	25	\N	\N	f	2026-03-08 22:37:19.224391+00
542	1896	single	1	\N	\N	f	2026-03-08 22:37:19.22505+00
543	1898	single	1	\N	\N	f	2026-03-08 22:37:19.226506+00
544	1899	single	27	\N	\N	f	2026-03-08 22:37:19.227358+00
546	1901	single	1	\N	\N	f	2026-03-08 22:37:19.228778+00
547	1902	single	15	\N	\N	f	2026-03-08 22:37:19.229615+00
548	1905	single	25	\N	\N	f	2026-03-08 22:37:19.231663+00
549	1906	single	25	\N	\N	f	2026-03-08 22:37:19.232412+00
550	1908	single	25	\N	\N	f	2026-03-08 22:37:19.233408+00
551	1910	single	5	\N	\N	f	2026-03-08 22:37:19.234452+00
552	1911	single	25	\N	\N	f	2026-03-08 22:37:19.235291+00
554	1913	single	8	\N	\N	f	2026-03-08 22:37:19.236684+00
555	1916	single	1	\N	\N	f	2026-03-08 22:37:19.239153+00
556	1920	single	1	\N	\N	f	2026-03-08 22:37:19.241235+00
558	1922	single	19	\N	\N	f	2026-03-08 22:37:19.242551+00
559	1923	single	15	\N	\N	f	2026-03-08 22:37:19.243208+00
560	1924	single	27	\N	\N	f	2026-03-08 22:37:19.243816+00
561	1925	single	1	\N	\N	f	2026-03-08 22:37:19.244613+00
562	1926	single	18	\N	\N	f	2026-03-08 22:37:19.24538+00
563	1927	single	18	\N	\N	f	2026-03-08 22:37:19.246192+00
564	1928	single	8	\N	\N	f	2026-03-08 22:37:19.246962+00
565	1929	single	22	\N	\N	f	2026-03-08 22:37:19.247728+00
566	1931	single	1	\N	\N	f	2026-03-08 22:37:19.249126+00
568	1933	single	18	\N	\N	f	2026-03-08 22:37:19.250516+00
569	1934	single	18	\N	\N	f	2026-03-08 22:37:19.251291+00
570	1935	single	9	\N	\N	f	2026-03-08 22:37:19.251989+00
571	1937	single	22	\N	\N	f	2026-03-08 22:37:19.253216+00
572	1938	single	8	\N	\N	f	2026-03-08 22:37:19.2544+00
573	1940	single	8	\N	\N	f	2026-03-08 22:37:19.255735+00
574	1941	single	2	\N	\N	f	2026-03-08 22:37:19.256567+00
575	1942	single	7	\N	\N	f	2026-03-08 22:37:19.257403+00
576	1943	single	22	\N	\N	f	2026-03-08 22:37:19.258127+00
577	1946	single	12	\N	\N	f	2026-03-08 22:37:19.259888+00
578	1947	single	1	\N	\N	f	2026-03-08 22:37:19.260613+00
579	1948	single	22	\N	\N	f	2026-03-08 22:37:19.261339+00
580	1949	single	14	\N	\N	f	2026-03-08 22:37:19.262041+00
581	1951	single	12	\N	\N	f	2026-03-08 22:37:19.263272+00
582	1953	single	7	\N	\N	f	2026-03-08 22:37:19.26447+00
583	1954	single	1	\N	\N	f	2026-03-08 22:37:19.265436+00
584	1955	single	1	\N	\N	f	2026-03-08 22:37:19.26619+00
585	1956	single	27	\N	\N	f	2026-03-08 22:37:19.266851+00
586	1957	single	26	\N	\N	f	2026-03-08 22:37:19.267446+00
587	1958	single	27	\N	\N	f	2026-03-08 22:37:19.268005+00
588	1959	single	1	\N	\N	f	2026-03-08 22:37:19.268718+00
589	1960	single	1	\N	\N	f	2026-03-08 22:37:19.269428+00
591	1962	single	27	\N	\N	f	2026-03-08 22:37:19.27087+00
593	1964	single	2	\N	\N	f	2026-03-08 22:37:19.272206+00
594	1965	single	1	\N	\N	f	2026-03-08 22:37:19.272897+00
595	1966	single	25	\N	\N	f	2026-03-08 22:37:19.273777+00
596	1967	single	29	\N	\N	f	2026-03-08 22:37:19.27457+00
597	1968	single	25	\N	\N	f	2026-03-08 22:37:19.275261+00
598	1969	single	25	\N	\N	f	2026-03-08 22:37:19.275926+00
599	1971	single	25	\N	\N	f	2026-03-08 22:37:19.277118+00
600	1973	single	25	\N	\N	f	2026-03-08 22:37:19.278394+00
601	1974	single	25	\N	\N	f	2026-03-08 22:37:19.279436+00
602	1975	single	25	\N	\N	f	2026-03-08 22:37:19.280254+00
603	1976	single	25	\N	\N	f	2026-03-08 22:37:19.281002+00
604	1977	single	25	\N	\N	f	2026-03-08 22:37:19.281782+00
605	1978	single	25	\N	\N	f	2026-03-08 22:37:19.282504+00
606	1979	single	25	\N	\N	f	2026-03-08 22:37:19.283189+00
607	1981	single	1	\N	\N	f	2026-03-08 22:37:19.284411+00
608	1982	single	25	\N	\N	f	2026-03-08 22:37:19.285082+00
609	1983	single	25	\N	\N	f	2026-03-08 22:37:19.285797+00
610	1984	single	25	\N	\N	f	2026-03-08 22:37:19.286462+00
611	1985	single	22	\N	\N	f	2026-03-08 22:37:19.287185+00
612	1986	single	14	\N	\N	f	2026-03-08 22:37:19.28776+00
613	1987	single	25	\N	\N	f	2026-03-08 22:37:19.288342+00
614	1988	single	25	\N	\N	f	2026-03-08 22:37:19.28889+00
615	1989	single	27	\N	\N	f	2026-03-08 22:37:19.289571+00
616	1990	single	25	\N	\N	f	2026-03-08 22:37:19.290488+00
617	1994	single	11	\N	\N	f	2026-03-08 22:37:19.292644+00
618	1995	single	9	\N	\N	f	2026-03-08 22:37:19.293383+00
619	1996	single	1	\N	\N	f	2026-03-08 22:37:19.294062+00
620	1997	single	1	\N	\N	f	2026-03-08 22:37:19.294769+00
621	1998	single	1	\N	\N	f	2026-03-08 22:37:19.295683+00
622	2003	single	25	\N	\N	f	2026-03-08 22:37:19.298663+00
623	2004	single	1	\N	\N	f	2026-03-08 22:37:19.299322+00
624	2005	single	14	\N	\N	f	2026-03-08 22:37:19.300055+00
625	2007	single	25	\N	\N	f	2026-03-08 22:37:19.301301+00
626	2008	single	12	\N	\N	f	2026-03-08 22:37:19.30204+00
627	2009	single	18	\N	\N	f	2026-03-08 22:37:19.302547+00
628	2010	single	14	\N	\N	f	2026-03-08 22:37:19.303119+00
629	2011	single	10	\N	\N	f	2026-03-08 22:37:19.304056+00
630	2012	single	15	\N	\N	f	2026-03-08 22:37:19.304769+00
631	2013	single	1	\N	\N	f	2026-03-08 22:37:19.305538+00
632	2014	single	29	\N	\N	f	2026-03-08 22:37:19.306214+00
633	2016	single	8	\N	\N	f	2026-03-08 22:37:19.307427+00
634	2017	single	21	\N	\N	f	2026-03-08 22:37:19.308133+00
635	2018	single	14	\N	\N	f	2026-03-08 22:37:19.308836+00
636	2019	single	2	\N	\N	f	2026-03-08 22:37:19.309481+00
637	2021	single	1	\N	\N	f	2026-03-08 22:37:19.310648+00
638	2022	single	17	\N	\N	f	2026-03-08 22:37:19.311326+00
639	2023	single	1	\N	\N	f	2026-03-08 22:37:19.312034+00
640	2024	single	2	\N	\N	f	2026-03-08 22:37:19.312711+00
641	2025	single	1	\N	\N	f	2026-03-08 22:37:19.313388+00
642	2026	single	8	\N	\N	f	2026-03-08 22:37:19.314007+00
643	2027	single	8	\N	\N	f	2026-03-08 22:37:19.314569+00
644	2028	single	8	\N	\N	f	2026-03-08 22:37:19.315196+00
645	2029	single	14	\N	\N	f	2026-03-08 22:37:19.315859+00
646	2030	single	2	\N	\N	f	2026-03-08 22:37:19.316535+00
647	2032	single	18	\N	\N	f	2026-03-08 22:37:19.31777+00
648	2037	single	15	\N	\N	f	2026-03-08 22:37:19.320596+00
649	2043	single	27	\N	\N	f	2026-03-08 22:37:19.323702+00
650	2044	single	9	\N	\N	f	2026-03-08 22:37:19.324545+00
651	2045	single	1	\N	\N	f	2026-03-08 22:37:19.325357+00
652	2046	single	29	\N	\N	f	2026-03-08 22:37:19.326059+00
653	2047	single	25	\N	\N	f	2026-03-08 22:37:19.326767+00
654	2053	single	2	\N	\N	f	2026-03-08 22:37:19.329504+00
655	2054	single	14	\N	\N	f	2026-03-08 22:37:19.330209+00
656	2057	single	1	\N	\N	f	2026-03-08 22:37:19.332097+00
657	2058	single	1	\N	\N	f	2026-03-08 22:37:19.332821+00
658	2060	single	1	\N	\N	f	2026-03-08 22:37:19.33359+00
659	2061	single	1	\N	\N	f	2026-03-08 22:37:19.334304+00
660	2062	single	15	\N	\N	f	2026-03-08 22:37:19.334999+00
661	2063	single	1	\N	\N	f	2026-03-08 22:37:19.335729+00
665	2070	single	27	\N	\N	f	2026-03-08 22:37:19.339435+00
666	2071	single	1	\N	\N	f	2026-03-08 22:37:19.340098+00
667	2072	single	25	\N	\N	f	2026-03-08 22:37:19.340887+00
668	2073	single	1	\N	\N	f	2026-03-08 22:37:19.341717+00
670	2076	single	25	\N	\N	f	2026-03-08 22:37:19.343481+00
671	2078	single	1	\N	\N	f	2026-03-08 22:37:19.344541+00
672	2079	single	15	\N	\N	f	2026-03-08 22:37:19.345512+00
673	2080	single	14	\N	\N	f	2026-03-08 22:37:19.3463+00
674	2081	single	18	\N	\N	f	2026-03-08 22:37:19.347241+00
675	2082	single	25	\N	\N	f	2026-03-08 22:37:19.348021+00
676	2083	single	27	\N	\N	f	2026-03-08 22:37:19.348605+00
677	2085	single	15	\N	\N	f	2026-03-08 22:37:19.349565+00
678	2086	single	15	\N	\N	f	2026-03-08 22:37:19.350188+00
680	2088	single	8	\N	\N	f	2026-03-08 22:37:19.351521+00
681	2089	single	8	\N	\N	f	2026-03-08 22:37:19.352255+00
682	2091	single	17	\N	\N	f	2026-03-08 22:37:19.353906+00
683	2094	single	1	\N	\N	f	2026-03-08 22:37:19.355752+00
\.


--
-- Data for Name: vendor_locations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.vendor_locations (id, vendor_id, location_name, created_at) FROM stdin;
1	2	Bogotá	2026-03-08 22:33:38.888532+00
\.


--
-- Data for Name: vendors; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.vendors (id, name, vendor_type, notes, created_at) FROM stdin;
1	DV	wholesaler	\N	2026-03-08 22:33:38.888532+00
2	Elite	farm	\N	2026-03-08 22:33:38.888532+00
3	Magic	wholesaler	\N	2026-03-08 22:33:38.888532+00
4	Agrogana	farm	\N	2026-03-08 22:33:38.888532+00
5	Mayesh	wholesaler	\N	2026-03-08 22:33:38.888532+00
6	Golden	farm	\N	2026-03-08 22:33:38.888532+00
7	Shaw Lake	farm	\N	2026-03-08 22:33:38.888532+00
8	Vivek Flowers	wholesaler	\N	2026-03-08 22:33:38.888532+00
\.


--
-- Data for Name: messages_2026_03_07; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_03_07 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_03_08; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_03_08 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_03_09; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_03_09 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_03_10; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_03_10 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2026_03_11; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages_2026_03_11 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-03-08 22:33:28
20211116045059	2026-03-08 22:33:28
20211116050929	2026-03-08 22:33:28
20211116051442	2026-03-08 22:33:28
20211116212300	2026-03-08 22:33:28
20211116213355	2026-03-08 22:33:28
20211116213934	2026-03-08 22:33:28
20211116214523	2026-03-08 22:33:28
20211122062447	2026-03-08 22:33:28
20211124070109	2026-03-08 22:33:28
20211202204204	2026-03-08 22:33:28
20211202204605	2026-03-08 22:33:28
20211210212804	2026-03-08 22:33:28
20211228014915	2026-03-08 22:33:28
20220107221237	2026-03-08 22:33:28
20220228202821	2026-03-08 22:33:28
20220312004840	2026-03-08 22:33:28
20220603231003	2026-03-08 22:33:28
20220603232444	2026-03-08 22:33:28
20220615214548	2026-03-08 22:33:28
20220712093339	2026-03-08 22:33:28
20220908172859	2026-03-08 22:33:28
20220916233421	2026-03-08 22:33:28
20230119133233	2026-03-08 22:33:28
20230128025114	2026-03-08 22:33:28
20230128025212	2026-03-08 22:33:28
20230227211149	2026-03-08 22:33:28
20230228184745	2026-03-08 22:33:28
20230308225145	2026-03-08 22:33:28
20230328144023	2026-03-08 22:33:28
20231018144023	2026-03-08 22:33:28
20231204144023	2026-03-08 22:33:28
20231204144024	2026-03-08 22:33:28
20231204144025	2026-03-08 22:33:28
20240108234812	2026-03-08 22:33:28
20240109165339	2026-03-08 22:33:28
20240227174441	2026-03-08 22:33:28
20240311171622	2026-03-08 22:33:28
20240321100241	2026-03-08 22:33:28
20240401105812	2026-03-08 22:33:28
20240418121054	2026-03-08 22:33:28
20240523004032	2026-03-08 22:33:28
20240618124746	2026-03-08 22:33:28
20240801235015	2026-03-08 22:33:28
20240805133720	2026-03-08 22:33:28
20240827160934	2026-03-08 22:33:28
20240919163303	2026-03-08 22:33:28
20240919163305	2026-03-08 22:33:28
20241019105805	2026-03-08 22:33:28
20241030150047	2026-03-08 22:33:28
20241108114728	2026-03-08 22:33:28
20241121104152	2026-03-08 22:33:28
20241130184212	2026-03-08 22:33:28
20241220035512	2026-03-08 22:33:28
20241220123912	2026-03-08 22:33:28
20241224161212	2026-03-08 22:33:28
20250107150512	2026-03-08 22:33:28
20250110162412	2026-03-08 22:33:28
20250123174212	2026-03-08 22:33:28
20250128220012	2026-03-08 22:33:28
20250506224012	2026-03-08 22:33:28
20250523164012	2026-03-08 22:33:28
20250714121412	2026-03-08 22:33:28
20250905041441	2026-03-08 22:33:28
20251103001201	2026-03-08 22:33:28
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: iceberg_namespaces; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.iceberg_namespaces (id, bucket_name, name, created_at, updated_at, metadata, catalog_id) FROM stdin;
\.


--
-- Data for Name: iceberg_tables; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.iceberg_tables (id, namespace_id, bucket_name, name, location, created_at, updated_at, remote_table_id, shard_key, shard_id, catalog_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-03-08 22:33:38.156585
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-03-08 22:33:38.158545
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-03-08 22:33:38.161192
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-03-08 22:33:38.168471
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-03-08 22:33:38.172744
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-03-08 22:33:38.173192
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-03-08 22:33:38.176529
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-03-08 22:33:38.177458
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-03-08 22:33:38.17804
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-03-08 22:33:38.180332
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-03-08 22:33:38.181348
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-03-08 22:33:38.183279
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-03-08 22:33:38.184367
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-03-08 22:33:38.185247
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-03-08 22:33:38.185687
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-03-08 22:33:38.195535
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-03-08 22:33:38.197878
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-03-08 22:33:38.198315
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-03-08 22:33:38.198776
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-03-08 22:33:38.199529
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-03-08 22:33:38.199984
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-03-08 22:33:38.201956
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-03-08 22:33:38.208064
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-03-08 22:33:38.210146
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-03-08 22:33:38.211671
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-03-08 22:33:38.212747
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-03-08 22:33:38.213371
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-03-08 22:33:38.213711
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-03-08 22:33:38.214123
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-03-08 22:33:38.214676
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-03-08 22:33:38.215049
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-03-08 22:33:38.215424
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-03-08 22:33:38.216074
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-03-08 22:33:38.21653
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-03-08 22:33:38.216898
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-03-08 22:33:38.217331
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-03-08 22:33:38.21773
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-03-08 22:33:38.219368
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-03-08 22:33:38.220647
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-03-08 22:33:38.227311
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-03-08 22:33:38.22792
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-03-08 22:33:38.228562
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-03-08 22:33:38.228925
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-03-08 22:33:38.229308
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-03-08 22:33:38.229632
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-03-08 22:33:38.23057
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-03-08 22:33:38.233265
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-03-08 22:33:38.234361
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-03-08 22:33:38.235231
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-03-08 22:33:38.247979
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-03-08 22:33:38.249761
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-03-08 22:33:38.282662
52	drop-not-used-indexes-and-functions	bb0cbc7f2206a5a41113363dd22556cc1afd6327	2026-03-08 22:33:38.28298
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-03-08 22:33:38.284812
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-03-08 22:33:38.285209
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-03-08 22:33:38.285421
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: hooks; Type: TABLE DATA; Schema: supabase_functions; Owner: -
--

COPY supabase_functions.hooks (id, hook_table_id, hook_name, created_at, request_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: supabase_functions; Owner: -
--

COPY supabase_functions.migrations (version, inserted_at) FROM stdin;
initial	2026-03-08 22:33:26.815806+00
20210809183423_update_grants	2026-03-08 22:33:26.815806+00
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: supabase_migrations; Owner: -
--

COPY supabase_migrations.schema_migrations (version, statements, name) FROM stdin;
20260308200616	{"-- Stem Normalization Database Schema\n-- 10 tables for managing floral product data\n\n-- ============================================================\n-- 1. vendors\n-- ============================================================\nCREATE TABLE vendors (\n  id          SERIAL PRIMARY KEY,\n  name        VARCHAR(100) NOT NULL UNIQUE,\n  vendor_type VARCHAR(20) NOT NULL CHECK (vendor_type IN ('farm', 'wholesaler')),\n  notes       TEXT,\n  created_at  TIMESTAMPTZ DEFAULT NOW()\n)","-- ============================================================\n-- 2. vendor_locations\n-- ============================================================\nCREATE TABLE vendor_locations (\n  id            SERIAL PRIMARY KEY,\n  vendor_id     INT NOT NULL REFERENCES vendors(id) ON DELETE CASCADE,\n  location_name VARCHAR(100) NOT NULL,\n  created_at    TIMESTAMPTZ DEFAULT NOW(),\n  UNIQUE (vendor_id, location_name)\n)","-- ============================================================\n-- 3. stems\n-- ============================================================\nCREATE TABLE stems (\n  id               SERIAL PRIMARY KEY,\n  stem_category    VARCHAR(100) NOT NULL,\n  stem_subcategory VARCHAR(100),\n  created_at       TIMESTAMPTZ DEFAULT NOW()\n)","CREATE UNIQUE INDEX idx_stems_category_subcategory\n  ON stems (stem_category, COALESCE(stem_subcategory, ''))","-- ============================================================\n-- 4. color_categories\n-- ============================================================\nCREATE TABLE color_categories (\n  id         SERIAL PRIMARY KEY,\n  name       VARCHAR(50) NOT NULL UNIQUE,\n  hex_code   VARCHAR(7),\n  sort_order INT,\n  created_at TIMESTAMPTZ DEFAULT NOW()\n)","-- ============================================================\n-- 5. stem_color_categories\n-- ============================================================\nCREATE TABLE stem_color_categories (\n  id                           SERIAL PRIMARY KEY,\n  stem_id                      INT NOT NULL REFERENCES stems(id) ON DELETE CASCADE,\n  color_type                   VARCHAR(20) NOT NULL CHECK (color_type IN ('single', 'bicolor')),\n  primary_color_category_id    INT NOT NULL REFERENCES color_categories(id),\n  secondary_color_category_id  INT REFERENCES color_categories(id),\n  bicolor_type                 VARCHAR(30) CHECK (bicolor_type IN ('variegated', 'fade', 'tipped', 'striped')),\n  secondary_color_searchable   BOOLEAN DEFAULT FALSE,\n  created_at                   TIMESTAMPTZ DEFAULT NOW(),\n  CONSTRAINT check_bicolor_has_secondary CHECK (\n    (color_type = 'single' AND secondary_color_category_id IS NULL AND bicolor_type IS NULL)\n    OR\n    (color_type = 'bicolor' AND secondary_color_category_id IS NOT NULL AND bicolor_type IS NOT NULL)\n  )\n)","-- ============================================================\n-- 6. varieties\n-- ============================================================\nCREATE TABLE varieties (\n  id         SERIAL PRIMARY KEY,\n  name       VARCHAR(100) NOT NULL UNIQUE,\n  created_at TIMESTAMPTZ DEFAULT NOW()\n)","-- ============================================================\n-- 7. stem_varieties\n-- ============================================================\nCREATE TABLE stem_varieties (\n  id              SERIAL PRIMARY KEY,\n  stem_id         INT NOT NULL REFERENCES stems(id) ON DELETE CASCADE,\n  variety_id      INT NOT NULL REFERENCES varieties(id) ON DELETE CASCADE,\n  legacy_stem_id  INT,\n  created_at      TIMESTAMPTZ DEFAULT NOW(),\n  UNIQUE (stem_id, variety_id)\n)","-- ============================================================\n-- 8. lengths\n-- ============================================================\nCREATE TABLE lengths (\n  id         SERIAL PRIMARY KEY,\n  cm         INT NOT NULL UNIQUE,\n  created_at TIMESTAMPTZ DEFAULT NOW()\n)","-- ============================================================\n-- 9. stem_lengths\n-- ============================================================\nCREATE TABLE stem_lengths (\n  id         SERIAL PRIMARY KEY,\n  stem_id    INT NOT NULL REFERENCES stems(id) ON DELETE CASCADE,\n  length_id  INT NOT NULL REFERENCES lengths(id) ON DELETE CASCADE,\n  created_at TIMESTAMPTZ DEFAULT NOW(),\n  UNIQUE (stem_id, length_id)\n)","-- ============================================================\n-- 10. product_items\n-- ============================================================\nCREATE TABLE product_items (\n  id                      SERIAL PRIMARY KEY,\n  stem_id                 INT NOT NULL REFERENCES stems(id) ON DELETE CASCADE,\n  vendor_id               INT NOT NULL REFERENCES vendors(id) ON DELETE CASCADE,\n  stem_color_category_id  INT REFERENCES stem_color_categories(id),\n  stem_variety_id         INT REFERENCES stem_varieties(id),\n  stem_length_id          INT REFERENCES stem_lengths(id),\n  product_item_name       VARCHAR(255) NOT NULL,\n  vendor_sku              VARCHAR(50),\n  created_at              TIMESTAMPTZ DEFAULT NOW()\n)","-- Indexes for common queries\nCREATE INDEX idx_product_items_stem ON product_items(stem_id)","CREATE INDEX idx_product_items_vendor ON product_items(vendor_id)","CREATE INDEX idx_stem_color_categories_stem ON stem_color_categories(stem_id)","CREATE INDEX idx_stem_varieties_stem ON stem_varieties(stem_id)","CREATE INDEX idx_stem_lengths_stem ON stem_lengths(stem_id)","-- ============================================================\n-- Enable RLS (required for Supabase, but allow all for now)\n-- ============================================================\nALTER TABLE vendors ENABLE ROW LEVEL SECURITY","ALTER TABLE vendor_locations ENABLE ROW LEVEL SECURITY","ALTER TABLE stems ENABLE ROW LEVEL SECURITY","ALTER TABLE color_categories ENABLE ROW LEVEL SECURITY","ALTER TABLE stem_color_categories ENABLE ROW LEVEL SECURITY","ALTER TABLE varieties ENABLE ROW LEVEL SECURITY","ALTER TABLE stem_varieties ENABLE ROW LEVEL SECURITY","ALTER TABLE lengths ENABLE ROW LEVEL SECURITY","ALTER TABLE stem_lengths ENABLE ROW LEVEL SECURITY","ALTER TABLE product_items ENABLE ROW LEVEL SECURITY","-- Allow all operations for authenticated and anon users (internal tool)\nCREATE POLICY \\"Allow all\\" ON vendors FOR ALL USING (true) WITH CHECK (true)","CREATE POLICY \\"Allow all\\" ON vendor_locations FOR ALL USING (true) WITH CHECK (true)","CREATE POLICY \\"Allow all\\" ON stems FOR ALL USING (true) WITH CHECK (true)","CREATE POLICY \\"Allow all\\" ON color_categories FOR ALL USING (true) WITH CHECK (true)","CREATE POLICY \\"Allow all\\" ON stem_color_categories FOR ALL USING (true) WITH CHECK (true)","CREATE POLICY \\"Allow all\\" ON varieties FOR ALL USING (true) WITH CHECK (true)","CREATE POLICY \\"Allow all\\" ON stem_varieties FOR ALL USING (true) WITH CHECK (true)","CREATE POLICY \\"Allow all\\" ON lengths FOR ALL USING (true) WITH CHECK (true)","CREATE POLICY \\"Allow all\\" ON stem_lengths FOR ALL USING (true) WITH CHECK (true)","CREATE POLICY \\"Allow all\\" ON product_items FOR ALL USING (true) WITH CHECK (true)"}	create_stem_schema
20260309000000	{"-- Move colors from stems to varieties\r\n-- Colors belong to varieties (e.g., \\"Freedom rose is red\\"), not stems (e.g., \\"rose has red\\")\r\n\r\n-- A. Create new table\r\nCREATE TABLE variety_color_categories (\r\n  id                           SERIAL PRIMARY KEY,\r\n  variety_id                   INT NOT NULL REFERENCES varieties(id) ON DELETE CASCADE,\r\n  color_type                   VARCHAR(20) NOT NULL CHECK (color_type IN ('single', 'bicolor')),\r\n  primary_color_category_id    INT NOT NULL REFERENCES color_categories(id),\r\n  secondary_color_category_id  INT REFERENCES color_categories(id),\r\n  bicolor_type                 VARCHAR(30) CHECK (bicolor_type IN ('variegated', 'fade', 'tipped', 'striped')),\r\n  secondary_color_searchable   BOOLEAN DEFAULT FALSE,\r\n  created_at                   TIMESTAMPTZ DEFAULT NOW(),\r\n  CONSTRAINT check_bicolor_has_secondary CHECK (\r\n    (color_type = 'single' AND secondary_color_category_id IS NULL AND bicolor_type IS NULL)\r\n    OR\r\n    (color_type = 'bicolor' AND secondary_color_category_id IS NOT NULL AND bicolor_type IS NOT NULL)\r\n  )\r\n)","CREATE UNIQUE INDEX idx_variety_color_unique\r\n  ON variety_color_categories (variety_id, color_type, primary_color_category_id, COALESCE(secondary_color_category_id, 0))","CREATE INDEX idx_variety_color_categories_variety ON variety_color_categories(variety_id)","-- B. Add new FK column to product_items\r\nALTER TABLE product_items ADD COLUMN variety_color_category_id INT REFERENCES variety_color_categories(id)","-- C. Drop old FK column and table\r\nALTER TABLE product_items DROP COLUMN stem_color_category_id","DROP TABLE stem_color_categories CASCADE","-- D. RLS + policy\r\nALTER TABLE variety_color_categories ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Allow all\\" ON variety_color_categories FOR ALL USING (true) WITH CHECK (true)"}	move_colors_to_varieties
\.


--
-- Data for Name: seed_files; Type: TABLE DATA; Schema: supabase_migrations; Owner: -
--

COPY supabase_migrations.seed_files (path, hash) FROM stdin;
supabase/seed.sql	b27e36e31280dc23c4322789810c12bedd106b588fdbb17be6ca28ebb571d5f8
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: -
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: -
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, false);


--
-- Name: color_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.color_categories_id_seq', 30, true);


--
-- Name: lengths_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.lengths_id_seq', 7, true);


--
-- Name: product_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.product_items_id_seq', 2636, true);


--
-- Name: stem_lengths_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.stem_lengths_id_seq', 1, false);


--
-- Name: stem_varieties_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.stem_varieties_id_seq', 2094, true);


--
-- Name: stems_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.stems_id_seq', 2636, true);


--
-- Name: varieties_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.varieties_id_seq', 2094, true);


--
-- Name: variety_color_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.variety_color_categories_id_seq', 683, true);


--
-- Name: vendor_locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.vendor_locations_id_seq', 1, true);


--
-- Name: vendors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.vendors_id_seq', 8, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: -
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: hooks_id_seq; Type: SEQUENCE SET; Schema: supabase_functions; Owner: -
--

SELECT pg_catalog.setval('supabase_functions.hooks_id_seq', 1, false);


--
-- Name: extensions extensions_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: -
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: -
--

ALTER TABLE ONLY _realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: -
--

ALTER TABLE ONLY _realtime.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: color_categories color_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.color_categories
    ADD CONSTRAINT color_categories_name_key UNIQUE (name);


--
-- Name: color_categories color_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.color_categories
    ADD CONSTRAINT color_categories_pkey PRIMARY KEY (id);


--
-- Name: lengths lengths_cm_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lengths
    ADD CONSTRAINT lengths_cm_key UNIQUE (cm);


--
-- Name: lengths lengths_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lengths
    ADD CONSTRAINT lengths_pkey PRIMARY KEY (id);


--
-- Name: product_items product_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_items
    ADD CONSTRAINT product_items_pkey PRIMARY KEY (id);


--
-- Name: stem_lengths stem_lengths_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stem_lengths
    ADD CONSTRAINT stem_lengths_pkey PRIMARY KEY (id);


--
-- Name: stem_lengths stem_lengths_stem_id_length_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stem_lengths
    ADD CONSTRAINT stem_lengths_stem_id_length_id_key UNIQUE (stem_id, length_id);


--
-- Name: stem_varieties stem_varieties_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stem_varieties
    ADD CONSTRAINT stem_varieties_pkey PRIMARY KEY (id);


--
-- Name: stem_varieties stem_varieties_stem_id_variety_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stem_varieties
    ADD CONSTRAINT stem_varieties_stem_id_variety_id_key UNIQUE (stem_id, variety_id);


--
-- Name: stems stems_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stems
    ADD CONSTRAINT stems_pkey PRIMARY KEY (id);


--
-- Name: varieties varieties_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.varieties
    ADD CONSTRAINT varieties_name_key UNIQUE (name);


--
-- Name: varieties varieties_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.varieties
    ADD CONSTRAINT varieties_pkey PRIMARY KEY (id);


--
-- Name: variety_color_categories variety_color_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.variety_color_categories
    ADD CONSTRAINT variety_color_categories_pkey PRIMARY KEY (id);


--
-- Name: vendor_locations vendor_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_locations
    ADD CONSTRAINT vendor_locations_pkey PRIMARY KEY (id);


--
-- Name: vendor_locations vendor_locations_vendor_id_location_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_locations
    ADD CONSTRAINT vendor_locations_vendor_id_location_name_key UNIQUE (vendor_id, location_name);


--
-- Name: vendors vendors_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_name_key UNIQUE (name);


--
-- Name: vendors vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_07 messages_2026_03_07_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_03_07
    ADD CONSTRAINT messages_2026_03_07_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_08 messages_2026_03_08_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_03_08
    ADD CONSTRAINT messages_2026_03_08_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_09 messages_2026_03_09_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_03_09
    ADD CONSTRAINT messages_2026_03_09_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_10 messages_2026_03_10_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_03_10
    ADD CONSTRAINT messages_2026_03_10_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_03_11 messages_2026_03_11_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2026_03_11
    ADD CONSTRAINT messages_2026_03_11_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: iceberg_namespaces iceberg_namespaces_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.iceberg_namespaces
    ADD CONSTRAINT iceberg_namespaces_pkey PRIMARY KEY (id);


--
-- Name: iceberg_tables iceberg_tables_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: hooks hooks_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: -
--

ALTER TABLE ONLY supabase_functions.hooks
    ADD CONSTRAINT hooks_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: -
--

ALTER TABLE ONLY supabase_functions.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (version);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: seed_files seed_files_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--

ALTER TABLE ONLY supabase_migrations.seed_files
    ADD CONSTRAINT seed_files_pkey PRIMARY KEY (path);


--
-- Name: extensions_tenant_external_id_index; Type: INDEX; Schema: _realtime; Owner: -
--

CREATE INDEX extensions_tenant_external_id_index ON _realtime.extensions USING btree (tenant_external_id);


--
-- Name: extensions_tenant_external_id_type_index; Type: INDEX; Schema: _realtime; Owner: -
--

CREATE UNIQUE INDEX extensions_tenant_external_id_type_index ON _realtime.extensions USING btree (tenant_external_id, type);


--
-- Name: tenants_external_id_index; Type: INDEX; Schema: _realtime; Owner: -
--

CREATE UNIQUE INDEX tenants_external_id_index ON _realtime.tenants USING btree (external_id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: idx_product_items_stem; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_items_stem ON public.product_items USING btree (stem_id);


--
-- Name: idx_product_items_vendor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_items_vendor ON public.product_items USING btree (vendor_id);


--
-- Name: idx_stem_lengths_stem; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stem_lengths_stem ON public.stem_lengths USING btree (stem_id);


--
-- Name: idx_stem_varieties_stem; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stem_varieties_stem ON public.stem_varieties USING btree (stem_id);


--
-- Name: idx_stems_category_subcategory; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_stems_category_subcategory ON public.stems USING btree (stem_category, COALESCE(stem_subcategory, ''::character varying));


--
-- Name: idx_variety_color_categories_variety; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_variety_color_categories_variety ON public.variety_color_categories USING btree (variety_id);


--
-- Name: idx_variety_color_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_variety_color_unique ON public.variety_color_categories USING btree (variety_id, color_type, primary_color_category_id, COALESCE(secondary_color_category_id, 0));


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_07_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_03_07_inserted_at_topic_idx ON realtime.messages_2026_03_07 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_08_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_03_08_inserted_at_topic_idx ON realtime.messages_2026_03_08 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_09_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_03_09_inserted_at_topic_idx ON realtime.messages_2026_03_09 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_10_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_03_10_inserted_at_topic_idx ON realtime.messages_2026_03_10 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_03_11_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_2026_03_11_inserted_at_topic_idx ON realtime.messages_2026_03_11 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: -
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_iceberg_namespaces_bucket_id; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX idx_iceberg_namespaces_bucket_id ON storage.iceberg_namespaces USING btree (catalog_id, name);


--
-- Name: idx_iceberg_tables_location; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX idx_iceberg_tables_location ON storage.iceberg_tables USING btree (location);


--
-- Name: idx_iceberg_tables_namespace_id; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX idx_iceberg_tables_namespace_id ON storage.iceberg_tables USING btree (catalog_id, namespace_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: supabase_functions_hooks_h_table_id_h_name_idx; Type: INDEX; Schema: supabase_functions; Owner: -
--

CREATE INDEX supabase_functions_hooks_h_table_id_h_name_idx ON supabase_functions.hooks USING btree (hook_table_id, hook_name);


--
-- Name: supabase_functions_hooks_request_id_idx; Type: INDEX; Schema: supabase_functions; Owner: -
--

CREATE INDEX supabase_functions_hooks_request_id_idx ON supabase_functions.hooks USING btree (request_id);


--
-- Name: messages_2026_03_07_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_07_inserted_at_topic_idx;


--
-- Name: messages_2026_03_07_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_07_pkey;


--
-- Name: messages_2026_03_08_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_08_inserted_at_topic_idx;


--
-- Name: messages_2026_03_08_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_08_pkey;


--
-- Name: messages_2026_03_09_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_09_inserted_at_topic_idx;


--
-- Name: messages_2026_03_09_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_09_pkey;


--
-- Name: messages_2026_03_10_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_10_inserted_at_topic_idx;


--
-- Name: messages_2026_03_10_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_10_pkey;


--
-- Name: messages_2026_03_11_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_11_inserted_at_topic_idx;


--
-- Name: messages_2026_03_11_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_11_pkey;


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: -
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: extensions extensions_tenant_external_id_fkey; Type: FK CONSTRAINT; Schema: _realtime; Owner: -
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_tenant_external_id_fkey FOREIGN KEY (tenant_external_id) REFERENCES _realtime.tenants(external_id) ON DELETE CASCADE;


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: product_items product_items_stem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_items
    ADD CONSTRAINT product_items_stem_id_fkey FOREIGN KEY (stem_id) REFERENCES public.stems(id) ON DELETE CASCADE;


--
-- Name: product_items product_items_stem_length_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_items
    ADD CONSTRAINT product_items_stem_length_id_fkey FOREIGN KEY (stem_length_id) REFERENCES public.stem_lengths(id);


--
-- Name: product_items product_items_stem_variety_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_items
    ADD CONSTRAINT product_items_stem_variety_id_fkey FOREIGN KEY (stem_variety_id) REFERENCES public.stem_varieties(id);


--
-- Name: product_items product_items_variety_color_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_items
    ADD CONSTRAINT product_items_variety_color_category_id_fkey FOREIGN KEY (variety_color_category_id) REFERENCES public.variety_color_categories(id);


--
-- Name: product_items product_items_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_items
    ADD CONSTRAINT product_items_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id) ON DELETE CASCADE;


--
-- Name: stem_lengths stem_lengths_length_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stem_lengths
    ADD CONSTRAINT stem_lengths_length_id_fkey FOREIGN KEY (length_id) REFERENCES public.lengths(id) ON DELETE CASCADE;


--
-- Name: stem_lengths stem_lengths_stem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stem_lengths
    ADD CONSTRAINT stem_lengths_stem_id_fkey FOREIGN KEY (stem_id) REFERENCES public.stems(id) ON DELETE CASCADE;


--
-- Name: stem_varieties stem_varieties_stem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stem_varieties
    ADD CONSTRAINT stem_varieties_stem_id_fkey FOREIGN KEY (stem_id) REFERENCES public.stems(id) ON DELETE CASCADE;


--
-- Name: stem_varieties stem_varieties_variety_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stem_varieties
    ADD CONSTRAINT stem_varieties_variety_id_fkey FOREIGN KEY (variety_id) REFERENCES public.varieties(id) ON DELETE CASCADE;


--
-- Name: variety_color_categories variety_color_categories_primary_color_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.variety_color_categories
    ADD CONSTRAINT variety_color_categories_primary_color_category_id_fkey FOREIGN KEY (primary_color_category_id) REFERENCES public.color_categories(id);


--
-- Name: variety_color_categories variety_color_categories_secondary_color_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.variety_color_categories
    ADD CONSTRAINT variety_color_categories_secondary_color_category_id_fkey FOREIGN KEY (secondary_color_category_id) REFERENCES public.color_categories(id);


--
-- Name: variety_color_categories variety_color_categories_variety_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.variety_color_categories
    ADD CONSTRAINT variety_color_categories_variety_id_fkey FOREIGN KEY (variety_id) REFERENCES public.varieties(id) ON DELETE CASCADE;


--
-- Name: vendor_locations vendor_locations_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendor_locations
    ADD CONSTRAINT vendor_locations_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id) ON DELETE CASCADE;


--
-- Name: iceberg_namespaces iceberg_namespaces_catalog_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.iceberg_namespaces
    ADD CONSTRAINT iceberg_namespaces_catalog_id_fkey FOREIGN KEY (catalog_id) REFERENCES storage.buckets_analytics(id) ON DELETE CASCADE;


--
-- Name: iceberg_tables iceberg_tables_catalog_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_catalog_id_fkey FOREIGN KEY (catalog_id) REFERENCES storage.buckets_analytics(id) ON DELETE CASCADE;


--
-- Name: iceberg_tables iceberg_tables_namespace_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_namespace_id_fkey FOREIGN KEY (namespace_id) REFERENCES storage.iceberg_namespaces(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: color_categories Allow all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all" ON public.color_categories USING (true) WITH CHECK (true);


--
-- Name: lengths Allow all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all" ON public.lengths USING (true) WITH CHECK (true);


--
-- Name: product_items Allow all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all" ON public.product_items USING (true) WITH CHECK (true);


--
-- Name: stem_lengths Allow all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all" ON public.stem_lengths USING (true) WITH CHECK (true);


--
-- Name: stem_varieties Allow all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all" ON public.stem_varieties USING (true) WITH CHECK (true);


--
-- Name: stems Allow all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all" ON public.stems USING (true) WITH CHECK (true);


--
-- Name: varieties Allow all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all" ON public.varieties USING (true) WITH CHECK (true);


--
-- Name: variety_color_categories Allow all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all" ON public.variety_color_categories USING (true) WITH CHECK (true);


--
-- Name: vendor_locations Allow all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all" ON public.vendor_locations USING (true) WITH CHECK (true);


--
-- Name: vendors Allow all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all" ON public.vendors USING (true) WITH CHECK (true);


--
-- Name: color_categories; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.color_categories ENABLE ROW LEVEL SECURITY;

--
-- Name: lengths; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lengths ENABLE ROW LEVEL SECURITY;

--
-- Name: product_items; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_items ENABLE ROW LEVEL SECURITY;

--
-- Name: stem_lengths; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.stem_lengths ENABLE ROW LEVEL SECURITY;

--
-- Name: stem_varieties; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.stem_varieties ENABLE ROW LEVEL SECURITY;

--
-- Name: stems; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.stems ENABLE ROW LEVEL SECURITY;

--
-- Name: varieties; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.varieties ENABLE ROW LEVEL SECURITY;

--
-- Name: variety_color_categories; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.variety_color_categories ENABLE ROW LEVEL SECURITY;

--
-- Name: vendor_locations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.vendor_locations ENABLE ROW LEVEL SECURITY;

--
-- Name: vendors; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.vendors ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: iceberg_namespaces; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.iceberg_namespaces ENABLE ROW LEVEL SECURITY;

--
-- Name: iceberg_tables; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.iceberg_tables ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


--
-- PostgreSQL database dump complete
--

\unrestrict cUm8O2QbyNDeMzVOWAaFHlpBQ2ATeOMFQzBiFwEWFkp0iNLonkOMheN0tvapB9T

