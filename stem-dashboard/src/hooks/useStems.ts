import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../lib/supabase'
import type { Stem, StemWithRelations, StemDetail, StemColorWithCategory, VendorOfferingWithRelations } from '../lib/types'

const STEM_SELECT = `
  *,
  vendor_offerings (id, vendor_id, stem_color_id, length_cm, vendor_item_name, is_active, vendors (id, name, vendor_type), stem_colors (*, color_categories:primary_color_category_id (*), secondary_color:secondary_color_category_id (*)))
`

export interface StemFilters {
  search?: string
  category?: string
  vendorId?: number
  colorId?: number
  page?: number
  pageSize?: number
}

export function useStems(filters: StemFilters = {}) {
  const { search, category, vendorId, colorId, page = 0, pageSize = 50 } = filters
  return useQuery({
    queryKey: ['stems', { search, category, vendorId, colorId, page, pageSize }],
    queryFn: async () => {
      // Get total count with the same filters (but without pagination)
      let countQuery = supabase.from('stems').select('id', { count: 'exact', head: true })
      let dataQuery = supabase.from('stems').select(STEM_SELECT)

      // Apply filters to both queries
      if (search) {
        const pattern = `%${search}%`
        const filter = `name.ilike.${pattern},category.ilike.${pattern},subcategory.ilike.${pattern},variety.ilike.${pattern}`
        countQuery = countQuery.or(filter)
        dataQuery = dataQuery.or(filter)
      }
      if (category) {
        countQuery = countQuery.eq('category', category)
        dataQuery = dataQuery.eq('category', category)
      }
      if (vendorId) {
        countQuery = countQuery.filter('vendor_offerings.vendor_id', 'eq', vendorId)
        dataQuery = dataQuery.filter('vendor_offerings.vendor_id', 'eq', vendorId)
      }
      const from = page * pageSize
      dataQuery = dataQuery
        .order('category')
        .order('variety', { nullsFirst: true })
        .range(from, from + pageSize - 1)

      const [{ count }, { data, error }] = await Promise.all([countQuery, dataQuery])
      if (error) throw error

      let results = (data as StemWithRelations[]) || []
      // PostgREST nested filters may still return parent rows — filter client-side
      if (vendorId) {
        results = results.filter(s => s.vendor_offerings.some(vo => vo.vendor_id === vendorId))
      }
      // Color filter: check via offering's stem_color
      if (colorId) {
        results = results.filter(s => s.vendor_offerings.some(vo =>
          vo.stem_colors?.primary_color_category_id === colorId
        ))
      }

      return { stems: results, total: count ?? 0 }
    },
    placeholderData: (prev) => prev, // keep previous data while loading next page
  })
}

export function useStemCategories() {
  return useQuery({
    queryKey: ['stem-categories'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('stems')
        .select('category')
      if (error) throw error
      return [...new Set(data.map(s => s.category))].sort()
    },
  })
}

export function useAllStemColors() {
  return useQuery({
    queryKey: ['stem-colors'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('stem_colors')
        .select('*, color_categories:primary_color_category_id (*), secondary_color:secondary_color_category_id (*)')
        .order('color_type')
        .order('primary_color_category_id')
      if (error) throw error
      return data as StemColorWithCategory[]
    },
  })
}

export function useStemList() {
  return useQuery({
    queryKey: ['stem-list'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('stems')
        .select('id, name, category, subcategory, variety')
        .order('name')
      if (error) throw error
      return data as Pick<Stem, 'id' | 'name' | 'category' | 'subcategory' | 'variety'>[]
    },
  })
}

export interface VendorOfferingFilters {
  search?: string
  vendorId?: number
  page?: number
  pageSize?: number
}

export function useVendorOfferingsList(filters: VendorOfferingFilters = {}) {
  const { search, vendorId, page = 0, pageSize = 50 } = filters
  return useQuery({
    queryKey: ['vendor-offerings', { search, vendorId, page, pageSize }],
    queryFn: async () => {
      let countQuery = supabase.from('vendor_offerings').select('id', { count: 'exact', head: true })
      let dataQuery = supabase.from('vendor_offerings').select(`
        *, stems!inner (*), vendors (*),
        stem_colors (*, color_categories:primary_color_category_id (*), secondary_color:secondary_color_category_id (*))
      `)

      if (search) {
        const pattern = `%${search}%`
        // Search across offering name, sku, and stem name
        countQuery = countQuery.or(`vendor_item_name.ilike.${pattern},vendor_sku.ilike.${pattern},stems.name.ilike.${pattern}`)
        dataQuery = dataQuery.or(`vendor_item_name.ilike.${pattern},vendor_sku.ilike.${pattern},stems.name.ilike.${pattern}`)
      }
      if (vendorId) {
        countQuery = countQuery.eq('vendor_id', vendorId)
        dataQuery = dataQuery.eq('vendor_id', vendorId)
      }

      const from = page * pageSize
      dataQuery = dataQuery
        .order('created_at', { ascending: false })
        .range(from, from + pageSize - 1)

      const [{ count }, { data, error }] = await Promise.all([countQuery, dataQuery])
      if (error) throw error

      return { offerings: (data as VendorOfferingWithRelations[]) || [], total: count ?? 0 }
    },
    placeholderData: (prev) => prev,
  })
}

export function useStemDetail(id: number | null) {
  return useQuery({
    queryKey: ['stems', id, 'detail'],
    enabled: id !== null,
    queryFn: async () => {
      const { data, error } = await supabase
        .from('stems')
        .select(`
          *,
          vendor_offerings (*, vendors (*), stem_colors (*, color_categories:primary_color_category_id (*), secondary_color:secondary_color_category_id (*)))
        `)
        .eq('id', id!)
        .single()
      if (error) throw error
      return data as StemDetail
    }
  })
}

export function useCreateStem() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (stem: { category: string; subcategory?: string | null; variety?: string | null; name: string }) => {
      const { data, error } = await supabase.from('stems').insert(stem).select().single()
      if (error) throw error
      return data
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['stems'] })
  })
}

export function useUpdateStem() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async ({ id, ...updates }: { id: number; category?: string; subcategory?: string | null; variety?: string | null; name?: string }) => {
      const { data, error } = await supabase.from('stems').update(updates).eq('id', id).select().single()
      if (error) throw error
      return data
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['stems'] })
  })
}

export function useDeleteStem() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (id: number) => {
      const { error } = await supabase.from('stems').delete().eq('id', id)
      if (error) throw error
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['stems'] })
  })
}

export function useCreateStemColor() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (sc: {
      color_type: 'single' | 'bicolor'
      primary_color_category_id: number
      secondary_color_category_id?: number | null
      bicolor_type?: 'variegated' | 'fade' | 'tipped' | 'striped' | null
    }) => {
      const { data, error } = await supabase
        .from('stem_colors')
        .insert({
          ...sc,
          secondary_color_searchable: sc.color_type === 'bicolor',
        })
        .select(`*, color_categories:primary_color_category_id (*), secondary_color:secondary_color_category_id (*)`)
        .single()
      if (error) throw error
      return data
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['stem-colors'] })
    }
  })
}

export function useCreateVendorOffering() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (offering: {
      stem_id: number
      vendor_id: number
      stem_color_id: number | null
      length_cm: number | null
      vendor_item_name?: string | null
      vendor_sku?: string | null
      is_active?: boolean
    }) => {
      const { data, error } = await supabase
        .from('vendor_offerings')
        .insert({ is_active: true, ...offering })
        .select()
        .single()
      if (error) throw error
      return data
    },
    onSuccess: (_data, variables) => {
      qc.invalidateQueries({ queryKey: ['stems', variables.stem_id, 'detail'] })
      qc.invalidateQueries({ queryKey: ['stems'] })
    }
  })
}

export function useUpdateVendorOffering() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async ({ id, stem_id, ...updates }: {
      id: number
      stem_id: number
      vendor_id?: number
      stem_color_id?: number | null
      length_cm?: number | null
      vendor_item_name?: string | null
      vendor_sku?: string | null
      is_active?: boolean
    }) => {
      const { data, error } = await supabase
        .from('vendor_offerings')
        .update(updates)
        .eq('id', id)
        .select()
        .single()
      if (error) throw error
      return data
    },
    onSuccess: (_data, variables) => {
      qc.invalidateQueries({ queryKey: ['stems', variables.stem_id, 'detail'] })
      qc.invalidateQueries({ queryKey: ['stems'] })
    }
  })
}

export function useDeleteVendorOffering() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async ({ id }: { id: number; stem_id: number }) => {
      const { error } = await supabase.from('vendor_offerings').delete().eq('id', id)
      if (error) throw error
    },
    onSuccess: (_data, variables) => {
      qc.invalidateQueries({ queryKey: ['stems', variables.stem_id, 'detail'] })
      qc.invalidateQueries({ queryKey: ['stems'] })
    }
  })
}
