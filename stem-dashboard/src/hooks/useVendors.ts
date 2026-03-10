import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../lib/supabase'
import type { VendorWithRelations } from '../lib/types'

export function useVendors() {
  return useQuery({
    queryKey: ['vendors'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('vendors')
        .select('*, vendor_locations(*), vendor_offerings(count)')
        .order('name')
      if (error) throw error
      return data as VendorWithRelations[]
    }
  })
}

export function useCreateVendor() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (vendor: { name: string; vendor_type: 'farm' | 'wholesaler'; notes?: string | null }) => {
      const { data, error } = await supabase.from('vendors').insert(vendor).select().single()
      if (error) throw error
      return data
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['vendors'] })
  })
}

export function useUpdateVendor() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async ({ id, ...updates }: { id: number; name?: string; vendor_type?: 'farm' | 'wholesaler'; notes?: string | null }) => {
      const { data, error } = await supabase.from('vendors').update(updates).eq('id', id).select().single()
      if (error) throw error
      return data
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['vendors'] })
  })
}

export function useDeleteVendor() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (id: number) => {
      const { error } = await supabase.from('vendors').delete().eq('id', id)
      if (error) throw error
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['vendors'] })
  })
}

export function useCreateVendorLocation() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (loc: { vendor_id: number; location_name: string }) => {
      const { data, error } = await supabase.from('vendor_locations').insert(loc).select().single()
      if (error) throw error
      return data
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['vendors'] })
  })
}

export function useDeleteVendorLocation() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (id: number) => {
      const { error } = await supabase.from('vendor_locations').delete().eq('id', id)
      if (error) throw error
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['vendors'] })
  })
}
