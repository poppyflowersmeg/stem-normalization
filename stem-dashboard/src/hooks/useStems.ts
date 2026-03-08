import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../lib/supabase'
import type { StemWithCounts } from '../lib/types'

export function useStems() {
  return useQuery({
    queryKey: ['stems'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('stems')
        .select('*, stem_varieties(count), stem_color_categories(count), product_items(count)')
        .order('stem_category')
      if (error) throw error
      return data as StemWithCounts[]
    }
  })
}

export function useStemDetail(id: number | null) {
  return useQuery({
    queryKey: ['stems', id],
    enabled: id !== null,
    queryFn: async () => {
      const { data, error } = await supabase
        .from('stems')
        .select(`
          *,
          stem_varieties (*, varieties (*)),
          stem_color_categories (*, color_categories:primary_color_category_id (*)),
          stem_lengths (*, lengths (*)),
          product_items (count)
        `)
        .eq('id', id!)
        .single()
      if (error) throw error
      return data
    }
  })
}

export function useCreateStem() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (stem: { stem_category: string; stem_subcategory?: string | null }) => {
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
    mutationFn: async ({ id, ...updates }: { id: number; stem_category: string; stem_subcategory?: string | null }) => {
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
