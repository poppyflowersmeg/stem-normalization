import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../lib/supabase'
import { fetchAll } from '../lib/fetchAll'
import type { VarietyWithStems } from '../lib/types'

export function useVarieties() {
  return useQuery({
    queryKey: ['varieties'],
    queryFn: async () => {
      return fetchAll<VarietyWithStems>(() =>
        supabase
          .from('varieties')
          .select('*, stem_varieties(*, stems(*))')
          .order('name')
      )
    }
  })
}

export function useCreateVariety() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (variety: { name: string }) => {
      const { data, error } = await supabase.from('varieties').insert(variety).select().single()
      if (error) throw error
      return data
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['varieties'] })
  })
}

export function useUpdateVariety() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async ({ id, name }: { id: number; name: string }) => {
      const { data, error } = await supabase.from('varieties').update({ name }).eq('id', id).select().single()
      if (error) throw error
      return data
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['varieties'] })
  })
}

export function useDeleteVariety() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (id: number) => {
      const { error } = await supabase.from('varieties').delete().eq('id', id)
      if (error) throw error
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['varieties'] })
  })
}
