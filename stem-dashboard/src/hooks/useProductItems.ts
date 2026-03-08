import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../lib/supabase'
import { fetchAll } from '../lib/fetchAll'
import type { ProductItemWithRelations } from '../lib/types'

export function useProductItems() {
  return useQuery({
    queryKey: ['product_items'],
    queryFn: async () => {
      return fetchAll<ProductItemWithRelations>(() =>
        supabase
          .from('product_items')
          .select(`
            *,
            stems (*),
            vendors (*),
            variety_color_categories (*, color_categories:primary_color_category_id (*)),
            stem_varieties (*, varieties (*)),
            stem_lengths (*, lengths (*))
          `)
          .order('product_item_name')
      )
    }
  })
}

export function useCreateProductItem() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (item: {
      stem_id: number
      vendor_id: number
      variety_color_category_id?: number | null
      stem_variety_id?: number | null
      stem_length_id?: number | null
      product_item_name: string
      vendor_sku?: string | null
    }) => {
      const { data, error } = await supabase
        .from('product_items')
        .insert(item)
        .select()
        .single()
      if (error) throw error
      return data
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['product_items'] })
  })
}

export function useUpdateProductItem() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async ({ id, ...updates }: { id: number } & Partial<{
      stem_id: number
      vendor_id: number
      variety_color_category_id: number | null
      stem_variety_id: number | null
      stem_length_id: number | null
      product_item_name: string
      vendor_sku: string | null
    }>) => {
      const { data, error } = await supabase
        .from('product_items')
        .update(updates)
        .eq('id', id)
        .select()
        .single()
      if (error) throw error
      return data
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['product_items'] })
  })
}

export function useDeleteProductItem() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (id: number) => {
      const { error } = await supabase.from('product_items').delete().eq('id', id)
      if (error) throw error
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['product_items'] })
  })
}
