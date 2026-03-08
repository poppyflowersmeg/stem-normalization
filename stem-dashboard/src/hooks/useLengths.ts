import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../lib/supabase'
import type { LengthWithCount } from '../lib/types'

export function useLengths() {
  return useQuery({
    queryKey: ['lengths'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('lengths')
        .select('*, stem_lengths(count)')
        .order('cm')
      if (error) throw error
      return data as LengthWithCount[]
    }
  })
}

export function useCreateLength() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (length: { cm: number }) => {
      const { data, error } = await supabase.from('lengths').insert(length).select().single()
      if (error) throw error
      return data
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['lengths'] })
  })
}

export function useDeleteLength() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (id: number) => {
      const { error } = await supabase.from('lengths').delete().eq('id', id)
      if (error) throw error
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['lengths'] })
  })
}
