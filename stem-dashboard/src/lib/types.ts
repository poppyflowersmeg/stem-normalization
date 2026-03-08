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
  stem_category: string
  stem_subcategory: string | null
  created_at: string
}

export interface ColorCategory {
  id: number
  name: string
  hex_code: string | null
  sort_order: number | null
  created_at: string
}

export interface StemColorCategory {
  id: number
  stem_id: number
  color_type: 'single' | 'bicolor'
  primary_color_category_id: number
  secondary_color_category_id: number | null
  bicolor_type: 'variegated' | 'fade' | 'tipped' | 'striped' | null
  secondary_color_searchable: boolean
  created_at: string
}

export interface Variety {
  id: number
  name: string
  created_at: string
}

export interface StemVariety {
  id: number
  stem_id: number
  variety_id: number
  legacy_stem_id: number | null
  created_at: string
}

export interface Length {
  id: number
  cm: number
  created_at: string
}

export interface StemLength {
  id: number
  stem_id: number
  length_id: number
  created_at: string
}

export interface ProductItem {
  id: number
  stem_id: number
  vendor_id: number
  stem_color_category_id: number | null
  stem_variety_id: number | null
  stem_length_id: number | null
  product_item_name: string
  vendor_sku: string | null
  created_at: string
}

// Joined types for display
export interface ProductItemWithRelations extends ProductItem {
  stems: Stem
  vendors: Vendor
  stem_color_categories: (StemColorCategory & {
    color_categories: ColorCategory
  }) | null
  stem_varieties: (StemVariety & {
    varieties: Variety
  }) | null
  stem_lengths: (StemLength & {
    lengths: Length
  }) | null
}

export interface StemWithCounts extends Stem {
  stem_varieties: { count: number }[]
  stem_color_categories: { count: number }[]
  product_items: { count: number }[]
}

export interface VendorWithRelations extends Vendor {
  vendor_locations: VendorLocation[]
  product_items: { count: number }[]
}

export interface VarietyWithStems extends Variety {
  stem_varieties: (StemVariety & { stems: Stem })[]
}

export interface ColorCategoryWithCount extends ColorCategory {
  stem_color_categories: { count: number }[]
}

export interface LengthWithCount extends Length {
  stem_lengths: { count: number }[]
}
