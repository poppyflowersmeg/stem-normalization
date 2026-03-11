export interface Vendor {
  id: number
  name: string
  vendor_type: 'farm' | 'wholesaler'
  notes: string | null
  created_at: string
}

export interface VendorLocation {
  id: number
  vendor_id: number
  location_name: string
  created_at: string
}

export interface Stem {
  id: number
  category: string
  subcategory: string | null
  variety: string | null
  name: string
  created_at: string
}

export interface ColorCategory {
  id: number
  name: string
  hex_code: string | null
  sort_order: number | null
  created_at: string
}

export interface StemColor {
  id: number
  color_type: 'single' | 'bicolor'
  primary_color_category_id: number
  secondary_color_category_id: number | null
  bicolor_type: 'variegated' | 'fade' | 'tipped' | 'striped' | null
  secondary_color_searchable: boolean
  created_at: string
}

export interface VendorOffering {
  id: number
  stem_id: number
  stem_color_id: number | null
  vendor_id: number
  length_cm: number | null
  vendor_item_name: string | null
  vendor_sku: string | null
  is_active: boolean
  created_at: string
}

export interface StemColorWithCategory extends StemColor {
  color_categories: ColorCategory
  secondary_color: ColorCategory | null
}

// Stem list view — embedded vendor offering pills
export interface StemWithRelations extends Stem {
  vendor_offerings: Array<{
    id: number
    vendor_id: number
    stem_color_id: number | null
    length_cm: number | null
    vendor_item_name: string | null
    is_active: boolean
    vendors: Pick<Vendor, 'id' | 'name' | 'vendor_type'>
    stem_colors: StemColorWithCategory | null
  }>
}

// Stem detail view — full vendor offerings for expanded row
export interface StemDetail extends Stem {
  vendor_offerings: Array<VendorOffering & {
    vendors: Vendor
    stem_colors: StemColorWithCategory | null
  }>
}

export interface VendorWithRelations extends Vendor {
  vendor_locations: VendorLocation[]
  vendor_offerings: { count: number }[]
}

export interface ColorCategoryWithCount extends ColorCategory {
  stem_colors: { count: number }[]
}
