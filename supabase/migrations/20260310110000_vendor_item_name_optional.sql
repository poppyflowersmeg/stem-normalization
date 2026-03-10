-- Make vendor_item_name optional on vendor_offerings
ALTER TABLE vendor_offerings ALTER COLUMN vendor_item_name DROP NOT NULL;
