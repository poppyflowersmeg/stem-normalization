


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";





SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."color_categories" (
    "id" integer NOT NULL,
    "name" character varying(50) NOT NULL,
    "hex_code" character varying(7),
    "sort_order" integer,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."color_categories" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."color_categories_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."color_categories_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."color_categories_id_seq" OWNED BY "public"."color_categories"."id";



CREATE TABLE IF NOT EXISTS "public"."lengths" (
    "id" integer NOT NULL,
    "cm" integer NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."lengths" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."lengths_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."lengths_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."lengths_id_seq" OWNED BY "public"."lengths"."id";



CREATE TABLE IF NOT EXISTS "public"."product_items" (
    "id" integer NOT NULL,
    "stem_id" integer NOT NULL,
    "vendor_id" integer NOT NULL,
    "stem_color_category_id" integer,
    "stem_variety_id" integer,
    "stem_length_id" integer,
    "product_item_name" character varying(255) NOT NULL,
    "vendor_sku" character varying(50),
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."product_items" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."product_items_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."product_items_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."product_items_id_seq" OWNED BY "public"."product_items"."id";



CREATE TABLE IF NOT EXISTS "public"."stem_color_categories" (
    "id" integer NOT NULL,
    "stem_id" integer NOT NULL,
    "color_type" character varying(20) NOT NULL,
    "primary_color_category_id" integer NOT NULL,
    "secondary_color_category_id" integer,
    "bicolor_type" character varying(30),
    "secondary_color_searchable" boolean DEFAULT false,
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "check_bicolor_has_secondary" CHECK ((((("color_type")::"text" = 'single'::"text") AND ("secondary_color_category_id" IS NULL) AND ("bicolor_type" IS NULL)) OR ((("color_type")::"text" = 'bicolor'::"text") AND ("secondary_color_category_id" IS NOT NULL) AND ("bicolor_type" IS NOT NULL)))),
    CONSTRAINT "stem_color_categories_bicolor_type_check" CHECK ((("bicolor_type")::"text" = ANY ((ARRAY['variegated'::character varying, 'fade'::character varying, 'tipped'::character varying, 'striped'::character varying])::"text"[]))),
    CONSTRAINT "stem_color_categories_color_type_check" CHECK ((("color_type")::"text" = ANY ((ARRAY['single'::character varying, 'bicolor'::character varying])::"text"[])))
);


ALTER TABLE "public"."stem_color_categories" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."stem_color_categories_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."stem_color_categories_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."stem_color_categories_id_seq" OWNED BY "public"."stem_color_categories"."id";



CREATE TABLE IF NOT EXISTS "public"."stem_lengths" (
    "id" integer NOT NULL,
    "stem_id" integer NOT NULL,
    "length_id" integer NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."stem_lengths" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."stem_lengths_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."stem_lengths_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."stem_lengths_id_seq" OWNED BY "public"."stem_lengths"."id";



CREATE TABLE IF NOT EXISTS "public"."stem_varieties" (
    "id" integer NOT NULL,
    "stem_id" integer NOT NULL,
    "variety_id" integer NOT NULL,
    "legacy_stem_id" integer,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."stem_varieties" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."stem_varieties_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."stem_varieties_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."stem_varieties_id_seq" OWNED BY "public"."stem_varieties"."id";



CREATE TABLE IF NOT EXISTS "public"."stems" (
    "id" integer NOT NULL,
    "stem_category" character varying(100) NOT NULL,
    "stem_subcategory" character varying(100),
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."stems" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."stems_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."stems_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."stems_id_seq" OWNED BY "public"."stems"."id";



CREATE TABLE IF NOT EXISTS "public"."varieties" (
    "id" integer NOT NULL,
    "name" character varying(100) NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."varieties" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."varieties_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."varieties_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."varieties_id_seq" OWNED BY "public"."varieties"."id";



CREATE TABLE IF NOT EXISTS "public"."vendor_locations" (
    "id" integer NOT NULL,
    "vendor_id" integer NOT NULL,
    "location_name" character varying(100) NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."vendor_locations" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."vendor_locations_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."vendor_locations_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."vendor_locations_id_seq" OWNED BY "public"."vendor_locations"."id";



CREATE TABLE IF NOT EXISTS "public"."vendors" (
    "id" integer NOT NULL,
    "name" character varying(100) NOT NULL,
    "vendor_type" character varying(20) NOT NULL,
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "vendors_vendor_type_check" CHECK ((("vendor_type")::"text" = ANY ((ARRAY['farm'::character varying, 'wholesaler'::character varying])::"text"[])))
);


ALTER TABLE "public"."vendors" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."vendors_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."vendors_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."vendors_id_seq" OWNED BY "public"."vendors"."id";



ALTER TABLE ONLY "public"."color_categories" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."color_categories_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."lengths" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."lengths_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."product_items" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."product_items_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."stem_color_categories" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."stem_color_categories_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."stem_lengths" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."stem_lengths_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."stem_varieties" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."stem_varieties_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."stems" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."stems_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."varieties" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."varieties_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."vendor_locations" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."vendor_locations_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."vendors" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."vendors_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."color_categories"
    ADD CONSTRAINT "color_categories_name_key" UNIQUE ("name");



ALTER TABLE ONLY "public"."color_categories"
    ADD CONSTRAINT "color_categories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."lengths"
    ADD CONSTRAINT "lengths_cm_key" UNIQUE ("cm");



ALTER TABLE ONLY "public"."lengths"
    ADD CONSTRAINT "lengths_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."product_items"
    ADD CONSTRAINT "product_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."stem_color_categories"
    ADD CONSTRAINT "stem_color_categories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."stem_lengths"
    ADD CONSTRAINT "stem_lengths_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."stem_lengths"
    ADD CONSTRAINT "stem_lengths_stem_id_length_id_key" UNIQUE ("stem_id", "length_id");



ALTER TABLE ONLY "public"."stem_varieties"
    ADD CONSTRAINT "stem_varieties_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."stem_varieties"
    ADD CONSTRAINT "stem_varieties_stem_id_variety_id_key" UNIQUE ("stem_id", "variety_id");



ALTER TABLE ONLY "public"."stems"
    ADD CONSTRAINT "stems_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."varieties"
    ADD CONSTRAINT "varieties_name_key" UNIQUE ("name");



ALTER TABLE ONLY "public"."varieties"
    ADD CONSTRAINT "varieties_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."vendor_locations"
    ADD CONSTRAINT "vendor_locations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."vendor_locations"
    ADD CONSTRAINT "vendor_locations_vendor_id_location_name_key" UNIQUE ("vendor_id", "location_name");



ALTER TABLE ONLY "public"."vendors"
    ADD CONSTRAINT "vendors_name_key" UNIQUE ("name");



ALTER TABLE ONLY "public"."vendors"
    ADD CONSTRAINT "vendors_pkey" PRIMARY KEY ("id");



CREATE INDEX "idx_product_items_stem" ON "public"."product_items" USING "btree" ("stem_id");



CREATE INDEX "idx_product_items_vendor" ON "public"."product_items" USING "btree" ("vendor_id");



CREATE INDEX "idx_stem_color_categories_stem" ON "public"."stem_color_categories" USING "btree" ("stem_id");



CREATE INDEX "idx_stem_lengths_stem" ON "public"."stem_lengths" USING "btree" ("stem_id");



CREATE INDEX "idx_stem_varieties_stem" ON "public"."stem_varieties" USING "btree" ("stem_id");



CREATE UNIQUE INDEX "idx_stems_category_subcategory" ON "public"."stems" USING "btree" ("stem_category", COALESCE("stem_subcategory", ''::character varying));



ALTER TABLE ONLY "public"."product_items"
    ADD CONSTRAINT "product_items_stem_color_category_id_fkey" FOREIGN KEY ("stem_color_category_id") REFERENCES "public"."stem_color_categories"("id");



ALTER TABLE ONLY "public"."product_items"
    ADD CONSTRAINT "product_items_stem_id_fkey" FOREIGN KEY ("stem_id") REFERENCES "public"."stems"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."product_items"
    ADD CONSTRAINT "product_items_stem_length_id_fkey" FOREIGN KEY ("stem_length_id") REFERENCES "public"."stem_lengths"("id");



ALTER TABLE ONLY "public"."product_items"
    ADD CONSTRAINT "product_items_stem_variety_id_fkey" FOREIGN KEY ("stem_variety_id") REFERENCES "public"."stem_varieties"("id");



ALTER TABLE ONLY "public"."product_items"
    ADD CONSTRAINT "product_items_vendor_id_fkey" FOREIGN KEY ("vendor_id") REFERENCES "public"."vendors"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."stem_color_categories"
    ADD CONSTRAINT "stem_color_categories_primary_color_category_id_fkey" FOREIGN KEY ("primary_color_category_id") REFERENCES "public"."color_categories"("id");



ALTER TABLE ONLY "public"."stem_color_categories"
    ADD CONSTRAINT "stem_color_categories_secondary_color_category_id_fkey" FOREIGN KEY ("secondary_color_category_id") REFERENCES "public"."color_categories"("id");



ALTER TABLE ONLY "public"."stem_color_categories"
    ADD CONSTRAINT "stem_color_categories_stem_id_fkey" FOREIGN KEY ("stem_id") REFERENCES "public"."stems"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."stem_lengths"
    ADD CONSTRAINT "stem_lengths_length_id_fkey" FOREIGN KEY ("length_id") REFERENCES "public"."lengths"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."stem_lengths"
    ADD CONSTRAINT "stem_lengths_stem_id_fkey" FOREIGN KEY ("stem_id") REFERENCES "public"."stems"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."stem_varieties"
    ADD CONSTRAINT "stem_varieties_stem_id_fkey" FOREIGN KEY ("stem_id") REFERENCES "public"."stems"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."stem_varieties"
    ADD CONSTRAINT "stem_varieties_variety_id_fkey" FOREIGN KEY ("variety_id") REFERENCES "public"."varieties"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."vendor_locations"
    ADD CONSTRAINT "vendor_locations_vendor_id_fkey" FOREIGN KEY ("vendor_id") REFERENCES "public"."vendors"("id") ON DELETE CASCADE;



CREATE POLICY "Allow all" ON "public"."color_categories" USING (true) WITH CHECK (true);



CREATE POLICY "Allow all" ON "public"."lengths" USING (true) WITH CHECK (true);



CREATE POLICY "Allow all" ON "public"."product_items" USING (true) WITH CHECK (true);



CREATE POLICY "Allow all" ON "public"."stem_color_categories" USING (true) WITH CHECK (true);



CREATE POLICY "Allow all" ON "public"."stem_lengths" USING (true) WITH CHECK (true);



CREATE POLICY "Allow all" ON "public"."stem_varieties" USING (true) WITH CHECK (true);



CREATE POLICY "Allow all" ON "public"."stems" USING (true) WITH CHECK (true);



CREATE POLICY "Allow all" ON "public"."varieties" USING (true) WITH CHECK (true);



CREATE POLICY "Allow all" ON "public"."vendor_locations" USING (true) WITH CHECK (true);



CREATE POLICY "Allow all" ON "public"."vendors" USING (true) WITH CHECK (true);



ALTER TABLE "public"."color_categories" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."lengths" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."product_items" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."stem_color_categories" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."stem_lengths" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."stem_varieties" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."stems" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."varieties" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."vendor_locations" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."vendors" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";





GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";














































































































































































GRANT ALL ON TABLE "public"."color_categories" TO "anon";
GRANT ALL ON TABLE "public"."color_categories" TO "authenticated";
GRANT ALL ON TABLE "public"."color_categories" TO "service_role";



GRANT ALL ON SEQUENCE "public"."color_categories_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."color_categories_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."color_categories_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."lengths" TO "anon";
GRANT ALL ON TABLE "public"."lengths" TO "authenticated";
GRANT ALL ON TABLE "public"."lengths" TO "service_role";



GRANT ALL ON SEQUENCE "public"."lengths_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."lengths_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."lengths_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."product_items" TO "anon";
GRANT ALL ON TABLE "public"."product_items" TO "authenticated";
GRANT ALL ON TABLE "public"."product_items" TO "service_role";



GRANT ALL ON SEQUENCE "public"."product_items_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."product_items_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."product_items_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."stem_color_categories" TO "anon";
GRANT ALL ON TABLE "public"."stem_color_categories" TO "authenticated";
GRANT ALL ON TABLE "public"."stem_color_categories" TO "service_role";



GRANT ALL ON SEQUENCE "public"."stem_color_categories_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."stem_color_categories_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."stem_color_categories_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."stem_lengths" TO "anon";
GRANT ALL ON TABLE "public"."stem_lengths" TO "authenticated";
GRANT ALL ON TABLE "public"."stem_lengths" TO "service_role";



GRANT ALL ON SEQUENCE "public"."stem_lengths_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."stem_lengths_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."stem_lengths_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."stem_varieties" TO "anon";
GRANT ALL ON TABLE "public"."stem_varieties" TO "authenticated";
GRANT ALL ON TABLE "public"."stem_varieties" TO "service_role";



GRANT ALL ON SEQUENCE "public"."stem_varieties_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."stem_varieties_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."stem_varieties_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."stems" TO "anon";
GRANT ALL ON TABLE "public"."stems" TO "authenticated";
GRANT ALL ON TABLE "public"."stems" TO "service_role";



GRANT ALL ON SEQUENCE "public"."stems_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."stems_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."stems_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."varieties" TO "anon";
GRANT ALL ON TABLE "public"."varieties" TO "authenticated";
GRANT ALL ON TABLE "public"."varieties" TO "service_role";



GRANT ALL ON SEQUENCE "public"."varieties_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."varieties_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."varieties_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."vendor_locations" TO "anon";
GRANT ALL ON TABLE "public"."vendor_locations" TO "authenticated";
GRANT ALL ON TABLE "public"."vendor_locations" TO "service_role";



GRANT ALL ON SEQUENCE "public"."vendor_locations_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."vendor_locations_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."vendor_locations_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."vendors" TO "anon";
GRANT ALL ON TABLE "public"."vendors" TO "authenticated";
GRANT ALL ON TABLE "public"."vendors" TO "service_role";



GRANT ALL ON SEQUENCE "public"."vendors_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."vendors_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."vendors_id_seq" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";































