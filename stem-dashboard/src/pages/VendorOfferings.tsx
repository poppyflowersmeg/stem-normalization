import { useState, useRef, useEffect, useCallback } from 'react'
import {
  useVendorOfferingsList, useStemList, useAllStemColors,
  useCreateVendorOffering, useUpdateVendorOffering, useDeleteVendorOffering,
  useCreateStem, useCreateStemColor,
} from '../hooks/useStems'
import { useVendors } from '../hooks/useVendors'
import { useColors } from '../hooks/useColors'
import { Modal } from '../components/Modal'
import { useToast } from '../components/Toast'
import type { StemColorWithCategory, ColorCategory, VendorOfferingWithRelations } from '../lib/types'

/* ── helpers (shared with Catalog) ── */

function stemColorSwatch(sc: StemColorWithCategory, size = 12) {
  const bg = sc.color_type === 'bicolor' && sc.secondary_color
    ? `linear-gradient(135deg, ${sc.color_categories?.hex_code || '#ccc'} 50%, ${sc.secondary_color.hex_code || '#ccc'} 50%)`
    : sc.color_categories?.hex_code || '#ccc'
  return (
    <span style={{
      display: 'inline-block', width: size, height: size, borderRadius: '50%',
      background: bg, border: '1px solid rgba(0,0,0,.1)', flexShrink: 0,
    }} />
  )
}

function colorDot(hex: string | null, size = 14) {
  return (
    <span style={{
      display: 'inline-block', width: size, height: size, borderRadius: '50%',
      background: hex || '#ccc', border: '1px solid rgba(0,0,0,.1)', flexShrink: 0,
    }} />
  )
}

function stemColorLabel(sc: StemColorWithCategory) {
  const primary = sc.color_categories?.name || '?'
  if (sc.color_type === 'bicolor' && sc.secondary_color) {
    return `${primary} / ${sc.secondary_color.name} — ${sc.bicolor_type}`
  }
  return primary
}

/* ── dropdown styles ── */

const dropdownStyles = {
  trigger: {
    display: 'flex', alignItems: 'center', gap: 6, padding: '6px 10px',
    border: '1px solid var(--border, #d1d5db)', borderRadius: 6, background: 'white',
    cursor: 'pointer', fontSize: '.85rem', width: '100%', minHeight: 34,
  } as React.CSSProperties,
  menu: {
    position: 'absolute', top: '100%', left: 0, right: 0, zIndex: 50,
    background: 'white', border: '1px solid var(--border, #d1d5db)', borderRadius: 6,
    boxShadow: '0 4px 12px rgba(0,0,0,.1)', marginTop: 2, maxHeight: 220, overflowY: 'auto',
  } as React.CSSProperties,
  option: {
    display: 'flex', alignItems: 'center', gap: 8, padding: '6px 10px',
    cursor: 'pointer', fontSize: '.85rem',
  } as React.CSSProperties,
}

/* ── Color picker (same as Catalog) ── */

function OfferingColorPicker({ value, onChange, stemColors, colorCategories }: {
  value: string; onChange: (v: string) => void
  stemColors: StemColorWithCategory[]; colorCategories: ColorCategory[]
}) {
  const [open, setOpen] = useState(false)
  const [filter, setFilter] = useState('')
  const ref = useRef<HTMLDivElement>(null)
  const inputRef = useRef<HTMLInputElement>(null)

  useEffect(() => {
    if (!open) return
    function handler(e: MouseEvent) { if (ref.current && !ref.current.contains(e.target as Node)) { setOpen(false); setFilter('') } }
    document.addEventListener('mousedown', handler)
    requestAnimationFrame(() => inputRef.current?.focus())
    return () => document.removeEventListener('mousedown', handler)
  }, [open])

  const bicolors = stemColors.filter(sc => sc.color_type === 'bicolor')
  const q = filter.toLowerCase()
  const filteredCategories = q ? colorCategories.filter(c => c.name.toLowerCase().includes(q)) : colorCategories
  const filteredBicolors = q ? bicolors.filter(sc => stemColorLabel(sc).toLowerCase().includes(q)) : bicolors

  let display: React.ReactNode = <span style={{ color: 'var(--muted, #9ca3af)' }}>No color</span>
  if (value.startsWith('sc:')) {
    const sc = stemColors.find(s => s.id === Number(value.slice(3)))
    if (sc) display = <>{stemColorSwatch(sc, 14)} <span>{stemColorLabel(sc)}</span></>
  } else if (value.startsWith('cc:')) {
    const cc = colorCategories.find(c => c.id === Number(value.slice(3)))
    if (cc) display = <>{colorDot(cc.hex_code, 14)} <span>{cc.name}</span></>
  }

  const sectionHeader = (label: string) => (
    <div style={{ padding: '4px 10px', fontSize: '.7rem', fontWeight: 600, color: 'var(--muted)', textTransform: 'uppercase' as const, letterSpacing: '.5px', borderTop: '1px solid var(--border, #e5e7eb)', marginTop: 2 }}>{label}</div>
  )

  return (
    <div ref={ref} style={{ position: 'relative', flex: 1 }}>
      <div style={dropdownStyles.trigger} onClick={() => setOpen(!open)}>
        {display}
        <span style={{ marginLeft: 'auto', fontSize: '.7rem', color: 'var(--muted)' }}>▼</span>
      </div>
      {open && (
        <div style={dropdownStyles.menu}>
          <div style={{ padding: '4px 6px', borderBottom: '1px solid var(--border, #e5e7eb)' }}>
            <input ref={inputRef} type="text" value={filter} onChange={e => setFilter(e.target.value)}
              placeholder="Type to filter..." style={{ width: '100%', border: 'none', outline: 'none', fontSize: '.82rem', padding: '4px 4px', background: 'transparent' }} />
          </div>
          {!q && (
            <div style={{ ...dropdownStyles.option, color: 'var(--muted)' }}
              onMouseEnter={e => (e.currentTarget.style.background = '#f3f4f6')} onMouseLeave={e => (e.currentTarget.style.background = '')}
              onClick={() => { onChange(''); setOpen(false); setFilter('') }}>No color</div>
          )}
          {filteredCategories.map(c => (
            <div key={`cc-${c.id}`} style={{ ...dropdownStyles.option, fontWeight: value === `cc:${c.id}` ? 600 : 400 }}
              onMouseEnter={e => (e.currentTarget.style.background = '#f3f4f6')} onMouseLeave={e => (e.currentTarget.style.background = '')}
              onClick={() => { onChange(`cc:${c.id}`); setOpen(false); setFilter('') }}>
              {colorDot(c.hex_code, 14)} <span>{c.name}</span>
            </div>
          ))}
          {filteredBicolors.length > 0 && (<>{sectionHeader('Bicolors')}
            {filteredBicolors.map(sc => (
              <div key={`sc-${sc.id}`} style={{ ...dropdownStyles.option, fontWeight: value === `sc:${sc.id}` ? 600 : 400 }}
                onMouseEnter={e => (e.currentTarget.style.background = '#f3f4f6')} onMouseLeave={e => (e.currentTarget.style.background = '')}
                onClick={() => { onChange(`sc:${sc.id}`); setOpen(false); setFilter('') }}>
                {stemColorSwatch(sc, 14)} <span>{stemColorLabel(sc)}</span>
              </div>
            ))}
          </>)}
          {filteredCategories.length === 0 && filteredBicolors.length === 0 && (
            <div style={{ padding: '8px 10px', fontSize: '.82rem', color: 'var(--muted)', textAlign: 'center' }}>No matches</div>
          )}
        </div>
      )}
    </div>
  )
}

/* ── Stem search picker ── */

function StemPicker({ value, onChange, stems }: {
  value: string; onChange: (v: string) => void
  stems: { id: number; name: string; category: string }[]
}) {
  const [open, setOpen] = useState(false)
  const [filter, setFilter] = useState('')
  const ref = useRef<HTMLDivElement>(null)
  const inputRef = useRef<HTMLInputElement>(null)

  useEffect(() => {
    if (!open) return
    function handler(e: MouseEvent) { if (ref.current && !ref.current.contains(e.target as Node)) { setOpen(false); setFilter('') } }
    document.addEventListener('mousedown', handler)
    requestAnimationFrame(() => inputRef.current?.focus())
    return () => document.removeEventListener('mousedown', handler)
  }, [open])

  const selected = value ? stems.find(s => s.id === Number(value)) : null
  const q = filter.toLowerCase()
  const filtered = q ? stems.filter(s => s.name.toLowerCase().includes(q) || s.category.toLowerCase().includes(q)) : stems.slice(0, 50)

  return (
    <div ref={ref} style={{ position: 'relative' }}>
      <div style={dropdownStyles.trigger} onClick={() => setOpen(!open)}>
        {selected ? (
          <span>{selected.name}</span>
        ) : (
          <span style={{ color: 'var(--muted, #9ca3af)' }}>Create a new Stem</span>
        )}
        <span style={{ marginLeft: 'auto', fontSize: '.7rem', color: 'var(--muted)' }}>▼</span>
      </div>
      {open && (
        <div style={dropdownStyles.menu}>
          <div style={{ padding: '4px 6px', borderBottom: '1px solid var(--border, #e5e7eb)' }}>
            <input ref={inputRef} type="text" value={filter} onChange={e => setFilter(e.target.value)}
              placeholder="Type to search stems..." style={{ width: '100%', border: 'none', outline: 'none', fontSize: '.82rem', padding: '4px 4px', background: 'transparent' }} />
          </div>
          <div style={{ ...dropdownStyles.option, color: 'var(--muted)' }}
            onMouseEnter={e => (e.currentTarget.style.background = '#f3f4f6')} onMouseLeave={e => (e.currentTarget.style.background = '')}
            onClick={() => { onChange(''); setOpen(false); setFilter('') }}>
            Create a new Stem
          </div>
          {filtered.map(s => (
            <div key={s.id} style={{ ...dropdownStyles.option, fontWeight: value === String(s.id) ? 600 : 400 }}
              onMouseEnter={e => (e.currentTarget.style.background = '#f3f4f6')} onMouseLeave={e => (e.currentTarget.style.background = '')}
              onClick={() => { onChange(String(s.id)); setOpen(false); setFilter('') }}>
              <span>{s.name}</span>
              <span style={{ fontSize: '.72rem', color: 'var(--muted)', marginLeft: 'auto' }}>{s.category}</span>
            </div>
          ))}
          {filtered.length === 0 && (
            <div style={{ padding: '8px 10px', fontSize: '.82rem', color: 'var(--muted)', textAlign: 'center' }}>No stems found</div>
          )}
        </div>
      )}
    </div>
  )
}

/* ── page ── */

const PAGE_SIZE = 50

export function VendorOfferings() {
  const { data: vendors } = useVendors()
  const { data: colors } = useColors()
  const { data: stemList } = useStemList()
  const { data: allStemColors } = useAllStemColors()
  const createOffering = useCreateVendorOffering()
  const updateOffering = useUpdateVendorOffering()
  const deleteOffering = useDeleteVendorOffering()
  const createStem = useCreateStem()
  const createStemColor = useCreateStemColor()
  const { showToast } = useToast()

  // Filters + pagination
  const [searchInput, setSearchInput] = useState('')
  const [debouncedSearch, setDebouncedSearch] = useState('')
  const [vendorFilter, setVendorFilter] = useState('')
  const [page, setPage] = useState(0)

  const debounceRef = useRef<ReturnType<typeof setTimeout>>(null)
  const handleSearchChange = useCallback((value: string) => {
    setSearchInput(value)
    clearTimeout(debounceRef.current ?? undefined)
    debounceRef.current = setTimeout(() => { setDebouncedSearch(value); setPage(0) }, 300)
  }, [])
  useEffect(() => () => clearTimeout(debounceRef.current ?? undefined), [])

  const { data, isLoading, isFetching } = useVendorOfferingsList({
    search: debouncedSearch || undefined,
    vendorId: vendorFilter ? Number(vendorFilter) : undefined,
    page, pageSize: PAGE_SIZE,
  })
  const offerings = data?.offerings
  const totalCount = data?.total ?? 0
  const totalPages = Math.ceil(totalCount / PAGE_SIZE)

  // Offering modal
  const [offeringModal, setOfferingModal] = useState<'create' | VendorOfferingWithRelations | null>(null)
  const [offerStemId, setOfferStemId] = useState('')
  const [offerVendorId, setOfferVendorId] = useState('')
  const [offerItemName, setOfferItemName] = useState('')
  const [offerSku, setOfferSku] = useState('')
  const [offerColor, setOfferColor] = useState('')
  const [offerLength, setOfferLength] = useState('')
  const [offerActive, setOfferActive] = useState(true)
  // New stem fields (when stem is blank)
  const [newStemCategory, setNewStemCategory] = useState('')
  const [newStemSubcategory, setNewStemSubcategory] = useState('')
  const [newStemVariety, setNewStemVariety] = useState('')
  const [showMore, setShowMore] = useState(false)

  // Delete confirm
  const [confirmDelete, setConfirmDelete] = useState<VendorOfferingWithRelations | null>(null)

  const isEditing = offeringModal !== null && offeringModal !== 'create'
  const saving = createOffering.isPending || updateOffering.isPending

  function openCreate() {
    setOfferStemId(''); setOfferVendorId(''); setOfferItemName(''); setOfferSku('')
    setOfferColor(''); setOfferLength(''); setOfferActive(true)
    setNewStemCategory(''); setNewStemSubcategory(''); setNewStemVariety('')
    setShowMore(false)
    setOfferingModal('create')
  }

  function openEdit(vo: VendorOfferingWithRelations) {
    setOfferStemId(String(vo.stem_id))
    setOfferVendorId(String(vo.vendor_id))
    setOfferItemName(vo.vendor_item_name || '')
    setOfferSku(vo.vendor_sku || '')
    if (vo.stem_colors?.color_type === 'bicolor') {
      setOfferColor(`sc:${vo.stem_color_id}`)
    } else if (vo.stem_colors) {
      setOfferColor(`cc:${vo.stem_colors.primary_color_category_id}`)
    } else {
      setOfferColor('')
    }
    setOfferLength(vo.length_cm ? String(vo.length_cm) : '')
    setOfferActive(vo.is_active)
    setNewStemCategory(''); setNewStemSubcategory(''); setNewStemVariety('')
    setShowMore(!!(vo.vendor_sku))
    setOfferingModal(vo)
  }

  function closeModal() { setOfferingModal(null) }

  async function handleSave() {
    if (!offerVendorId) return
    // If no stem selected, create one from the item name
    let stemId: number
    if (offerStemId) {
      stemId = Number(offerStemId)
    } else {
      if (!offerItemName) { showToast('Name is required when creating a new stem'); return }
      if (!newStemCategory) { showToast('Category is required when creating a new stem'); return }
      try {
        const newStem = await createStem.mutateAsync({
          category: newStemCategory.toLowerCase(),
          subcategory: newStemSubcategory || null,
          variety: newStemVariety || null,
          name: offerItemName,
        })
        stemId = newStem.id
      } catch (e: any) { showToast(`Error creating stem: ${e.message}`); return }
    }

    try {
      // Resolve color
      let stemColorId: number | null = null
      if (offerColor.startsWith('sc:')) {
        stemColorId = Number(offerColor.slice(3))
      } else if (offerColor.startsWith('cc:')) {
        const ccId = Number(offerColor.slice(3))
        const existing = allStemColors?.find(sc => sc.primary_color_category_id === ccId && sc.color_type === 'single')
        if (existing) {
          stemColorId = existing.id
        } else {
          const created = await createStemColor.mutateAsync({ color_type: 'single', primary_color_category_id: ccId })
          stemColorId = created.id
        }
      }

      const payload = {
        vendor_id: Number(offerVendorId),
        stem_color_id: stemColorId,
        length_cm: offerLength ? Number(offerLength) : null,
        vendor_item_name: offerItemName || null,
        vendor_sku: offerSku || null,
        is_active: offerActive,
      }

      if (offeringModal === 'create') {
        await createOffering.mutateAsync({ stem_id: stemId, ...payload })
        showToast('Offering created')
      } else if (offeringModal) {
        await updateOffering.mutateAsync({ id: offeringModal.id, stem_id: stemId, ...payload })
        showToast('Offering updated')
      }
      closeModal()
    } catch (e: any) { showToast(`Error: ${e.message}`) }
  }

  async function handleDelete() {
    if (!confirmDelete) return
    try {
      await deleteOffering.mutateAsync({ id: confirmDelete.id, stem_id: confirmDelete.stem_id })
      showToast('Offering deleted'); setConfirmDelete(null)
    } catch (e: any) { showToast(`Error: ${e.message}`) }
  }

  return (
    <div className="page">
      <div className="page-header">
        <h1 className="page-title">
          Vendor Offerings
          <span className="page-count">({totalCount}{isFetching && !isLoading ? '...' : ''})</span>
        </h1>
        <button className="btn btn-primary" onClick={openCreate}>+ Add Offering</button>
      </div>

      <div className="toolbar">
        <div className="search-wrap">
          <span className="search-icon">🔍</span>
          <input className="search-input" type="text" placeholder="Search offerings, stems..." value={searchInput} onChange={e => handleSearchChange(e.target.value)} />
        </div>
        <select className="filter-select" value={vendorFilter} onChange={e => { setVendorFilter(e.target.value); setPage(0) }}>
          <option value="">All Vendors</option>
          {vendors?.map(v => <option key={v.id} value={v.id}>{v.name}</option>)}
        </select>
      </div>

      <div className="table-wrap">
        <div className="table-scroll">
          <table className="data-table">
            <thead>
              <tr>
                <th>Stem</th>
                <th>Vendor</th>
                <th>Item Name</th>
                <th>SKU</th>
                <th>Color</th>
                <th>Length</th>
                <th>Active</th>
                <th style={{ width: 60 }}></th>
              </tr>
            </thead>
            <tbody>
              {isLoading ? (
                Array.from({ length: 8 }).map((_, i) => (
                  <tr key={i}>{Array.from({ length: 8 }).map((_, j) => <td key={j}><div className="skeleton" style={{ width: '60%' }} /></td>)}</tr>
                ))
              ) : !offerings?.length ? (
                <tr><td colSpan={8}><div className="empty-state"><p>📦</p><p>No offerings found</p></div></td></tr>
              ) : offerings.map(vo => (
                <tr key={vo.id} style={vo.is_active ? {} : { opacity: 0.45 }}>
                  <td style={{ fontWeight: 600 }}>{vo.stems?.name || '—'}</td>
                  <td>
                    <span className={`supplier-tag ${vo.vendors?.vendor_type === 'wholesaler' ? 'wholesaler' : ''}`}>{vo.vendors?.name}</span>
                  </td>
                  <td>{vo.vendor_item_name || '—'}</td>
                  <td style={{ fontFamily: "'SF Mono', monospace", fontSize: '.82rem', color: 'var(--muted)' }}>{vo.vendor_sku || '—'}</td>
                  <td>
                    {vo.stem_colors ? (
                      <span style={{ display: 'inline-flex', alignItems: 'center', gap: 4 }}>
                        {stemColorSwatch(vo.stem_colors)}
                        <span style={{ fontSize: '.82rem' }}>{stemColorLabel(vo.stem_colors)}</span>
                      </span>
                    ) : '—'}
                  </td>
                  <td>{vo.length_cm ? `${vo.length_cm} cm` : '—'}</td>
                  <td>
                    <span className={`badge ${vo.is_active ? 'badge-active' : 'badge-inactive'}`}>{vo.is_active ? 'Active' : 'Inactive'}</span>
                  </td>
                  <td>
                    <div className="actions-cell">
                      <button className="btn-icon" title="Edit" onClick={() => openEdit(vo)}>✏️</button>
                      <button className="btn-icon" title="Delete" onClick={() => setConfirmDelete(vo)}>🗑️</button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Pagination */}
      {totalPages > 1 && (
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '12px 0', fontSize: '.85rem' }}>
          <span style={{ color: 'var(--muted)' }}>{page * PAGE_SIZE + 1}–{Math.min((page + 1) * PAGE_SIZE, totalCount)} of {totalCount}</span>
          <div style={{ display: 'flex', gap: 4 }}>
            <button className="btn btn-secondary" style={{ padding: '4px 12px', fontSize: '.82rem' }} disabled={page === 0} onClick={() => setPage(0)}>First</button>
            <button className="btn btn-secondary" style={{ padding: '4px 12px', fontSize: '.82rem' }} disabled={page === 0} onClick={() => setPage(p => p - 1)}>Prev</button>
            <span style={{ display: 'flex', alignItems: 'center', padding: '0 8px', color: 'var(--muted)' }}>Page {page + 1} of {totalPages}</span>
            <button className="btn btn-secondary" style={{ padding: '4px 12px', fontSize: '.82rem' }} disabled={page >= totalPages - 1} onClick={() => setPage(p => p + 1)}>Next</button>
            <button className="btn btn-secondary" style={{ padding: '4px 12px', fontSize: '.82rem' }} disabled={page >= totalPages - 1} onClick={() => setPage(totalPages - 1)}>Last</button>
          </div>
        </div>
      )}

      {/* Create/Edit modal */}
      {offeringModal !== null && (
        <Modal
          title={isEditing ? 'Edit Vendor Offering' : 'New Vendor Offering'}
          onClose={closeModal}
          footer={<>
            <button className="btn btn-secondary" onClick={closeModal}>Cancel</button>
            <button className="btn btn-primary" onClick={handleSave} disabled={!offerVendorId || saving}>
              {saving ? '...' : isEditing ? 'Save' : 'Create'}
            </button>
          </>}
        >
          {/* Vendor */}
          <div className="form-row">
            <label>Vendor</label>
            <select value={offerVendorId} onChange={e => setOfferVendorId(e.target.value)}>
              <option value="">Select vendor...</option>
              {vendors?.map(v => <option key={v.id} value={v.id}>{v.name}</option>)}
            </select>
          </div>

          {/* Name */}
          <div className="form-row">
            <label>Name</label>
            <input type="text" value={offerItemName} onChange={e => setOfferItemName(e.target.value)} placeholder="e.g. Acacia Purple Fernleaf" />
          </div>

          {/* Color */}
          <div className="form-row">
            <label>Color</label>
            <OfferingColorPicker
              value={offerColor}
              onChange={setOfferColor}
              stemColors={allStemColors || []}
              colorCategories={colors || []}
            />
          </div>

          {/* Length */}
          <div className="form-row">
            <label>Length (cm, optional)</label>
            <input type="number" value={offerLength} onChange={e => setOfferLength(e.target.value)} placeholder="e.g. 60" />
          </div>

          {/* Stem section */}
          <div style={{
            background: 'var(--surface-hover, #f5f5f4)', borderRadius: 8,
            padding: '10px 12px', marginTop: 4,
          }}>
            <div className="form-row">
              <label>Stem</label>
              <StemPicker value={offerStemId} onChange={setOfferStemId} stems={stemList || []} />
            </div>
            {!offerStemId && (
              <>
                <div className="form-row">
                  <label>Category</label>
                  <input type="text" value={newStemCategory} onChange={e => setNewStemCategory(e.target.value)}
                    placeholder="e.g. Rose, Hydrangea, Carnation" />
                </div>
                <div className="form-row">
                  <label>Subcategory (optional)</label>
                  <input type="text" value={newStemSubcategory} onChange={e => setNewStemSubcategory(e.target.value)}
                    placeholder="e.g. Spray, Garden, Hanging" />
                </div>
                <div className="form-row">
                  <label>Variety (optional)</label>
                  <input type="text" value={newStemVariety} onChange={e => setNewStemVariety(e.target.value)}
                    placeholder="e.g. Freedom, Quicksand, Reef" />
                </div>
              </>
            )}
          </div>

          {/* More section */}
          <div style={{ marginTop: 8 }}>
            <button
              type="button"
              onClick={() => setShowMore(!showMore)}
              style={{
                background: 'none', border: 'none', cursor: 'pointer',
                fontSize: '.82rem', color: 'var(--muted)', padding: 0,
                display: 'flex', alignItems: 'center', gap: 4,
              }}
            >
              <span style={{ fontSize: '.7rem' }}>{showMore ? '▼' : '▶'}</span> More
            </button>
            {showMore && (
              <div style={{ marginTop: 8 }}>
                <div className="form-row">
                  <label>SKU (optional)</label>
                  <input type="text" value={offerSku} onChange={e => setOfferSku(e.target.value)} placeholder="e.g. G1365" />
                </div>
                <div className="form-row">
                  <label style={{ display: 'flex', alignItems: 'center', gap: 8, cursor: 'pointer' }}>
                    <input type="checkbox" checked={offerActive} onChange={e => setOfferActive(e.target.checked)} />
                    Active
                  </label>
                </div>
              </div>
            )}
          </div>
        </Modal>
      )}

      {/* Delete confirm */}
      {confirmDelete && (
        <Modal title="Delete Offering" onClose={() => setConfirmDelete(null)} footer={<>
          <button className="btn btn-secondary" onClick={() => setConfirmDelete(null)}>Cancel</button>
          <button className="btn btn-danger" onClick={handleDelete}>Delete</button>
        </>}>
          <div className="confirm-body">
            <p>Delete offering</p>
            <p className="confirm-name">{confirmDelete.vendor_item_name || 'Unnamed offering'}</p>
            <p style={{ fontSize: '.82rem', color: 'var(--muted)', marginTop: 4 }}>from {confirmDelete.vendors?.name} for {confirmDelete.stems?.name}</p>
          </div>
        </Modal>
      )}
    </div>
  )
}
