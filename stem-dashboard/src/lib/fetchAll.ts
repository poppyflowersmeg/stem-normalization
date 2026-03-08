import { supabase } from './supabase'
import type { PostgrestFilterBuilder } from '@supabase/postgrest-js'

const PAGE_SIZE = 1000

/**
 * Fetch all rows from a Supabase query, paginating through the 1000-row default limit.
 * Pass a function that builds the query (without .range()).
 */
export async function fetchAll<T>(
  buildQuery: () => PostgrestFilterBuilder<any, any, T[]>
): Promise<T[]> {
  const all: T[] = []
  let from = 0

  while (true) {
    const { data, error } = await buildQuery().range(from, from + PAGE_SIZE - 1)
    if (error) throw error
    if (!data || data.length === 0) break
    all.push(...data)
    if (data.length < PAGE_SIZE) break
    from += PAGE_SIZE
  }

  return all
}
