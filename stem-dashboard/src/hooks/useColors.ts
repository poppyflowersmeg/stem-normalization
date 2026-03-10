import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../lib/supabase'
import type { ColorCategoryWithCount } from '../lib/types'

export function useColors() {
  return useQuery({
    queryKey: ['color_categories'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('color_categories')
        .select('*, stem_colors:stem_colors!primary_color_category_id(count)')
        .order('sort_order', { nullsFirst: false })
        .order('name')
      if (error) throw error
      return data as ColorCategoryWithCount[]
    }
  })
}

export function useCreateColor() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (color: { name: string; hex_code?: string | null; sort_order?: number | null }) => {
      const { data, error } = await supabase.from('color_categories').insert(color).select().single()
      if (error) throw error
      return data
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['color_categories'] })
  })
}

export function useUpdateColor() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async ({ id, ...updates }: { id: number; name?: string; hex_code?: string | null; sort_order?: number | null }) => {
      const { data, error } = await supabase.from('color_categories').update(updates).eq('id', id).select().single()
      if (error) throw error
      return data
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['color_categories'] })
  })
}

export function useDeleteColor() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (id: number) => {
      const { error } = await supabase.from('color_categories').delete().eq('id', id)
      if (error) throw error
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['color_categories'] })
  })
}
