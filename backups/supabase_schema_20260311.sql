


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



CREATE TABLE IF NOT EXISTS "public"."stem_colors" (
    "id" integer NOT NULL,
    "color_type" character varying(20) NOT NULL,
    "primary_color_category_id" integer NOT NULL,
    "secondary_color_category_id" integer,
    "bicolor_type" character varying(30),
    "secondary_color_searchable" boolean DEFAULT false,
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "check_bicolor" CHECK ((((("color_type")::"text" = 'single'::"text") AND ("secondary_color_category_id" IS NULL) AND ("bicolor_type" IS NULL)) OR ((("color_type")::"text" = 'bicolor'::"text") AND ("secondary_color_category_id" IS NOT NULL) AND ("bicolor_type" IS NOT NULL)))),
    CONSTRAINT "stem_colors_bicolor_type_check" CHECK ((("bicolor_type")::"text" = ANY ((ARRAY['variegated'::character varying, 'fade'::character varying, 'tipped'::character varying, 'striped'::character varying])::"text"[]))),
    CONSTRAINT "stem_colors_color_type_check" CHECK ((("color_type")::"text" = ANY ((ARRAY['single'::character varying, 'bicolor'::character varying])::"text"[])))
);


ALTER TABLE "public"."stem_colors" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."stem_colors_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."stem_colors_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."stem_colors_id_seq" OWNED BY "public"."stem_colors"."id";



CREATE TABLE IF NOT EXISTS "public"."stems" (
    "id" integer NOT NULL,
    "category" character varying(100) NOT NULL,
    "subcategory" character varying(100),
    "created_at" timestamp with time zone DEFAULT "now"(),
    "variety" character varying(100),
    "name" character varying(255) NOT NULL
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



CREATE TABLE IF NOT EXISTS "public"."vendor_offerings" (
    "id" integer NOT NULL,
    "stem_id" integer NOT NULL,
    "stem_color_id" integer,
    "vendor_id" integer NOT NULL,
    "length_cm" integer,
    "vendor_item_name" character varying(255),
    "vendor_sku" character varying(50),
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."vendor_offerings" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."vendor_offerings_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."vendor_offerings_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."vendor_offerings_id_seq" OWNED BY "public"."vendor_offerings"."id";



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



ALTER TABLE ONLY "public"."stem_colors" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."stem_colors_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."stems" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."stems_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."vendor_locations" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."vendor_locations_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."vendor_offerings" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."vendor_offerings_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."vendors" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."vendors_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."color_categories"
    ADD CONSTRAINT "color_categories_name_key" UNIQUE ("name");



ALTER TABLE ONLY "public"."color_categories"
    ADD CONSTRAINT "color_categories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."stem_colors"
    ADD CONSTRAINT "stem_colors_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."stems"
    ADD CONSTRAINT "stems_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."vendor_locations"
    ADD CONSTRAINT "vendor_locations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."vendor_locations"
    ADD CONSTRAINT "vendor_locations_vendor_id_location_name_key" UNIQUE ("vendor_id", "location_name");



ALTER TABLE ONLY "public"."vendor_offerings"
    ADD CONSTRAINT "vendor_offerings_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."vendors"
    ADD CONSTRAINT "vendors_name_key" UNIQUE ("name");



ALTER TABLE ONLY "public"."vendors"
    ADD CONSTRAINT "vendors_pkey" PRIMARY KEY ("id");



CREATE UNIQUE INDEX "idx_stem_colors_unique" ON "public"."stem_colors" USING "btree" ("color_type", "primary_color_category_id", COALESCE("secondary_color_category_id", 0), COALESCE("bicolor_type", ''::character varying));



CREATE UNIQUE INDEX "idx_stems_unique" ON "public"."stems" USING "btree" ("category", COALESCE("subcategory", ''::character varying), COALESCE("variety", ''::character varying));



CREATE INDEX "idx_vendor_offerings_color" ON "public"."vendor_offerings" USING "btree" ("stem_color_id");



CREATE INDEX "idx_vendor_offerings_stem" ON "public"."vendor_offerings" USING "btree" ("stem_id");



CREATE INDEX "idx_vendor_offerings_vendor" ON "public"."vendor_offerings" USING "btree" ("vendor_id");



ALTER TABLE ONLY "public"."stem_colors"
    ADD CONSTRAINT "stem_colors_primary_color_category_id_fkey" FOREIGN KEY ("primary_color_category_id") REFERENCES "public"."color_categories"("id");



ALTER TABLE ONLY "public"."stem_colors"
    ADD CONSTRAINT "stem_colors_secondary_color_category_id_fkey" FOREIGN KEY ("secondary_color_category_id") REFERENCES "public"."color_categories"("id");



ALTER TABLE ONLY "public"."vendor_locations"
    ADD CONSTRAINT "vendor_locations_vendor_id_fkey" FOREIGN KEY ("vendor_id") REFERENCES "public"."vendors"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."vendor_offerings"
    ADD CONSTRAINT "vendor_offerings_stem_color_id_fkey" FOREIGN KEY ("stem_color_id") REFERENCES "public"."stem_colors"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."vendor_offerings"
    ADD CONSTRAINT "vendor_offerings_stem_id_fkey" FOREIGN KEY ("stem_id") REFERENCES "public"."stems"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."vendor_offerings"
    ADD CONSTRAINT "vendor_offerings_vendor_id_fkey" FOREIGN KEY ("vendor_id") REFERENCES "public"."vendors"("id") ON DELETE CASCADE;



CREATE POLICY "Allow all" ON "public"."color_categories" USING (true) WITH CHECK (true);



CREATE POLICY "Allow all" ON "public"."stem_colors" USING (true) WITH CHECK (true);



CREATE POLICY "Allow all" ON "public"."stems" USING (true) WITH CHECK (true);



CREATE POLICY "Allow all" ON "public"."vendor_locations" USING (true) WITH CHECK (true);



CREATE POLICY "Allow all" ON "public"."vendor_offerings" USING (true) WITH CHECK (true);



CREATE POLICY "Allow all" ON "public"."vendors" USING (true) WITH CHECK (true);



ALTER TABLE "public"."color_categories" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."stem_colors" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."stems" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."vendor_locations" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."vendor_offerings" ENABLE ROW LEVEL SECURITY;


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



GRANT ALL ON TABLE "public"."stem_colors" TO "anon";
GRANT ALL ON TABLE "public"."stem_colors" TO "authenticated";
GRANT ALL ON TABLE "public"."stem_colors" TO "service_role";



GRANT ALL ON SEQUENCE "public"."stem_colors_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."stem_colors_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."stem_colors_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."stems" TO "anon";
GRANT ALL ON TABLE "public"."stems" TO "authenticated";
GRANT ALL ON TABLE "public"."stems" TO "service_role";



GRANT ALL ON SEQUENCE "public"."stems_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."stems_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."stems_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."vendor_locations" TO "anon";
GRANT ALL ON TABLE "public"."vendor_locations" TO "authenticated";
GRANT ALL ON TABLE "public"."vendor_locations" TO "service_role";



GRANT ALL ON SEQUENCE "public"."vendor_locations_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."vendor_locations_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."vendor_locations_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."vendor_offerings" TO "anon";
GRANT ALL ON TABLE "public"."vendor_offerings" TO "authenticated";
GRANT ALL ON TABLE "public"."vendor_offerings" TO "service_role";



GRANT ALL ON SEQUENCE "public"."vendor_offerings_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."vendor_offerings_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."vendor_offerings_id_seq" TO "service_role";



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































