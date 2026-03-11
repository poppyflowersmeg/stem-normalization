import { useState, useRef, useEffect, useCallback } from 'react'
import {
  useStems, useStemCategories, useAllStemColors, useCreateStem, useUpdateStem, useDeleteStem,
  useStemDetail, useCreateVendorOffering, useUpdateVendorOffering, useDeleteVendorOffering,
  useCreateStemColor,
} from '../hooks/useStems'
import { useVendors } from '../hooks/useVendors'
import { useColors } from '../hooks/useColors'
import { Modal } from '../components/Modal'
import { useToast } from '../components/Toast'
import type { StemWithRelations, StemColorWithCategory, ColorCategory, VendorOffering } from '../lib/types'

/* ── helpers ── */

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

/* ── custom dropdown: stem color picker (shows swatch + label) ── */

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

/**
 * Unified color picker for the offering modal.
 * Value format: 'sc:123' (existing bicolor stem_color) | 'cc:45' (color_category — auto-creates stem_color on save) | '' (no color)
 * Shows all color categories as a flat list, plus any bicolor stem_colors for this stem.
 */
function OfferingColorPicker({ value, onChange, stemColors, colorCategories }: {
  value: string
  onChange: (v: string) => void
  stemColors: StemColorWithCategory[]
  colorCategories: ColorCategory[]
}) {
  const [open, setOpen] = useState(false)
  const [filter, setFilter] = useState('')
  const ref = useRef<HTMLDivElement>(null)
  const inputRef = useRef<HTMLInputElement>(null)

  useEffect(() => {
    if (!open) return
    function handler(e: MouseEvent) {
      if (ref.current && !ref.current.contains(e.target as Node)) { setOpen(false); setFilter('') }
    }
    document.addEventListener('mousedown', handler)
    requestAnimationFrame(() => inputRef.current?.focus())
    return () => document.removeEventListener('mousedown', handler)
  }, [open])

  const bicolors = stemColors.filter(sc => sc.color_type === 'bicolor')
  const q = filter.toLowerCase()
  const filteredCategories = q ? colorCategories.filter(c => c.name.toLowerCase().includes(q)) : colorCategories
  const filteredBicolors = q ? bicolors.filter(sc => stemColorLabel(sc).toLowerCase().includes(q)) : bicolors

  // Resolve display for current value
  let display: React.ReactNode = <span style={{ color: 'var(--muted, #9ca3af)' }}>No color</span>
  if (value.startsWith('sc:')) {
    const sc = stemColors.find(s => s.id === Number(value.slice(3)))
    if (sc) display = <>{stemColorSwatch(sc, 14)} <span>{stemColorLabel(sc)}</span></>
  } else if (value.startsWith('cc:')) {
    const cc = colorCategories.find(c => c.id === Number(value.slice(3)))
    if (cc) display = <>{colorDot(cc.hex_code, 14)} <span>{cc.name}</span></>
  }

  const optionStyle = (isSelected: boolean): React.CSSProperties => ({
    ...dropdownStyles.option,
    fontWeight: isSelected ? 600 : 400,
  })

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
            <input
              ref={inputRef}
              type="text"
              value={filter}
              onChange={e => setFilter(e.target.value)}
              placeholder="Type to filter..."
              style={{ width: '100%', border: 'none', outline: 'none', fontSize: '.82rem', padding: '4px 4px', background: 'transparent' }}
            />
          </div>

          {!q && (
            <div
              style={{ ...dropdownStyles.option, color: 'var(--muted)' }}
              onMouseEnter={e => (e.currentTarget.style.background = '#f3f4f6')}
              onMouseLeave={e => (e.currentTarget.style.background = '')}
              onClick={() => { onChange(''); setOpen(false); setFilter('') }}
            >No color</div>
          )}

          {filteredCategories.map(c => (
            <div
              key={`cc-${c.id}`}
              style={optionStyle(value === `cc:${c.id}`)}
              onMouseEnter={e => (e.currentTarget.style.background = '#f3f4f6')}
              onMouseLeave={e => (e.currentTarget.style.background = '')}
              onClick={() => { onChange(`cc:${c.id}`); setOpen(false); setFilter('') }}
            >
              {colorDot(c.hex_code, 14)}
              <span>{c.name}</span>
            </div>
          ))}

          {filteredBicolors.length > 0 && (
            <>
              {sectionHeader('Bicolors')}
              {filteredBicolors.map(sc => (
                <div
                  key={`sc-${sc.id}`}
                  style={optionStyle(value === `sc:${sc.id}`)}
                  onMouseEnter={e => (e.currentTarget.style.background = '#f3f4f6')}
                  onMouseLeave={e => (e.currentTarget.style.background = '')}
                  onClick={() => { onChange(`sc:${sc.id}`); setOpen(false); setFilter('') }}
                >
                  {stemColorSwatch(sc, 14)}
                  <span>{stemColorLabel(sc)}</span>
                </div>
              ))}
            </>
          )}

          {filteredCategories.length === 0 && filteredBicolors.length === 0 && (
            <div style={{ padding: '8px 10px', fontSize: '.82rem', color: 'var(--muted)', textAlign: 'center' }}>No matches</div>
          )}
        </div>
      )}
    </div>
  )
}

/* ── simple color category picker (reused in bicolor form) ── */

function ColorCategoryPicker({ value, onChange, colors, placeholder, style }: {
  value: string
  onChange: (v: string) => void
  colors: ColorCategory[]
  placeholder: string
  style?: React.CSSProperties
}) {
  const [open, setOpen] = useState(false)
  const [filter, setFilter] = useState('')
  const ref = useRef<HTMLDivElement>(null)
  const inputRef = useRef<HTMLInputElement>(null)

  useEffect(() => {
    if (!open) return
    function handler(e: MouseEvent) {
      if (ref.current && !ref.current.contains(e.target as Node)) { setOpen(false); setFilter('') }
    }
    document.addEventListener('mousedown', handler)
    requestAnimationFrame(() => inputRef.current?.focus())
    return () => document.removeEventListener('mousedown', handler)
  }, [open])

  const selected = value ? colors.find(c => c.id === Number(value)) : null
  const q = filter.toLowerCase()
  const filtered = q ? colors.filter(c => c.name.toLowerCase().includes(q)) : colors

  return (
    <div ref={ref} style={{ position: 'relative', ...style }}>
      <div style={dropdownStyles.trigger} onClick={() => setOpen(!open)}>
        {selected ? (
          <>{colorDot(selected.hex_code, 14)} <span>{selected.name}</span></>
        ) : (
          <span style={{ color: 'var(--muted, #9ca3af)' }}>{placeholder}</span>
        )}
        <span style={{ marginLeft: 'auto', fontSize: '.7rem', color: 'var(--muted)' }}>▼</span>
      </div>
      {open && (
        <div style={dropdownStyles.menu}>
          <div style={{ padding: '4px 6px', borderBottom: '1px solid var(--border, #e5e7eb)' }}>
            <input
              ref={inputRef}
              type="text"
              value={filter}
              onChange={e => setFilter(e.target.value)}
              placeholder="Type to filter..."
              style={{ width: '100%', border: 'none', outline: 'none', fontSize: '.82rem', padding: '4px 4px', background: 'transparent' }}
            />
          </div>
          {!q && (
            <div
              style={{ ...dropdownStyles.option, color: 'var(--muted)' }}
              onMouseEnter={e => (e.currentTarget.style.background = '#f3f4f6')}
              onMouseLeave={e => (e.currentTarget.style.background = '')}
              onClick={() => { onChange(''); setOpen(false); setFilter('') }}
            >{placeholder}</div>
          )}
          {filtered.map(c => (
            <div
              key={c.id}
              style={{ ...dropdownStyles.option, fontWeight: value === String(c.id) ? 600 : 400 }}
              onMouseEnter={e => (e.currentTarget.style.background = '#f3f4f6')}
              onMouseLeave={e => (e.currentTarget.style.background = '')}
              onClick={() => { onChange(String(c.id)); setOpen(false); setFilter('') }}
            >
              {colorDot(c.hex_code, 14)}
              <span>{c.name}</span>
            </div>
          ))}
          {filtered.length === 0 && (
            <div style={{ padding: '8px 10px', fontSize: '.82rem', color: 'var(--muted)', textAlign: 'center' }}>No matches</div>
          )}
        </div>
      )}
    </div>
  )
}

/* ── component ── */

const PAGE_SIZE = 50

export function Catalog() {
  const { data: vendors } = useVendors()
  const { data: colors } = useColors()
  const { data: categories } = useStemCategories()
  const { data: allStemColors } = useAllStemColors()
  const createStem = useCreateStem()
  const updateStem = useUpdateStem()
  const deleteStemMut = useDeleteStem()
  const createOffering = useCreateVendorOffering()
  const updateOffering = useUpdateVendorOffering()
  const deleteOffering = useDeleteVendorOffering()
  const createStemColor = useCreateStemColor()
  const { showToast } = useToast()

  // Filters + pagination
  const [searchInput, setSearchInput] = useState('')
  const [debouncedSearch, setDebouncedSearch] = useState('')
  const [categoryFilter, setCategoryFilter] = useState('')
  const [vendorFilter, setVendorFilter] = useState('')
  const [colorFilter, setColorFilter] = useState('')
  const [page, setPage] = useState(0)

  // Debounce search input
  const debounceRef = useRef<ReturnType<typeof setTimeout>>(null)
  const handleSearchChange = useCallback((value: string) => {
    setSearchInput(value)
    clearTimeout(debounceRef.current ?? undefined)
    debounceRef.current = setTimeout(() => {
      setDebouncedSearch(value)
      setPage(0)
    }, 300)
  }, [])
  useEffect(() => () => clearTimeout(debounceRef.current ?? undefined), [])

  // Reset page when filters change
  const handleCategoryChange = (v: string) => { setCategoryFilter(v); setPage(0) }
  const handleVendorChange = (v: string) => { setVendorFilter(v); setPage(0) }
  const handleColorChange = (v: string) => { setColorFilter(v); setPage(0) }

  const { data, isLoading, isFetching } = useStems({
    search: debouncedSearch || undefined,
    category: categoryFilter || undefined,
    vendorId: vendorFilter ? Number(vendorFilter) : undefined,
    colorId: colorFilter ? Number(colorFilter) : undefined,
    page,
    pageSize: PAGE_SIZE,
  })
  const stems = data?.stems
  const totalCount = data?.total ?? 0
  const totalPages = Math.ceil(totalCount / PAGE_SIZE)

  // Expand
  const [expandedId, setExpandedId] = useState<number | null>(null)
  const { data: detail } = useStemDetail(expandedId)

  // Stem CRUD modals
  const [editStem, setEditStem] = useState<StemWithRelations | null>(null)
  const [showCreateStem, setShowCreateStem] = useState(false)
  const [confirmDeleteStem, setConfirmDeleteStem] = useState<StemWithRelations | null>(null)
  const [formCategory, setFormCategory] = useState('')
  const [formSubcategory, setFormSubcategory] = useState('')
  const [formVariety, setFormVariety] = useState('')
  const [formName, setFormName] = useState('')

  // Offering modal — used for both create and edit
  type OfferingEdit = VendorOffering & { vendors: any; stem_colors: StemColorWithCategory | null }
  const [offeringModal, setOfferingModal] = useState<'create' | OfferingEdit | null>(null)
  const [offerVendorId, setOfferVendorId] = useState('')
  const [offerItemName, setOfferItemName] = useState('')
  const [offerSku, setOfferSku] = useState('')
  const [offerColor, setOfferColor] = useState('')  // 'sc:123' | 'cc:45' | ''
  const [offerLength, setOfferLength] = useState('')
  const [offerActive, setOfferActive] = useState(true)

  // Add Color (inline inside offering modal)
  const [showAddColor, setShowAddColor] = useState(false)
  const [newColorPrimary, setNewColorPrimary] = useState('')
  const [newColorSecondary, setNewColorSecondary] = useState('')
  const [newColorBicolorType, setNewColorBicolorType] = useState('')

  // Delete offering confirm
  const [confirmDeleteOffering, setConfirmDeleteOffering] = useState<OfferingEdit | null>(null)

  /* ── derived ── */

  /* ── stem handlers ── */

  function openCreateStem() {
    setFormCategory(''); setFormSubcategory(''); setFormVariety(''); setFormName('')
    setShowCreateStem(true)
  }

  function openEditStem(stem: StemWithRelations) {
    setFormCategory(stem.category)
    setFormSubcategory(stem.subcategory || '')
    setFormVariety(stem.variety || '')
    setFormName(stem.name)
    setEditStem(stem)
  }

  async function handleSaveStem() {
    const variety = formVariety || null
    const name = formName || [formCategory, formSubcategory, formVariety].filter(Boolean).join(' ')
    const payload = { category: formCategory, subcategory: formSubcategory || null, variety, name }
    try {
      if (editStem) {
        await updateStem.mutateAsync({ id: editStem.id, ...payload })
        showToast('Stem updated'); setEditStem(null)
      } else {
        await createStem.mutateAsync(payload)
        showToast('Stem created'); setShowCreateStem(false)
      }
    } catch (e: any) { showToast(`Error: ${e.message}`) }
  }

  async function handleDeleteStem() {
    if (!confirmDeleteStem) return
    try {
      await deleteStemMut.mutateAsync(confirmDeleteStem.id)
      showToast('Stem deleted'); setConfirmDeleteStem(null)
      if (expandedId === confirmDeleteStem.id) setExpandedId(null)
    } catch (e: any) { showToast(`Error: ${e.message}`) }
  }

  /* ── offering handlers ── */

  function openCreateOffering() {
    setOfferVendorId(''); setOfferItemName(''); setOfferSku('')
    setOfferColor(''); setOfferLength(''); setOfferActive(true)
    setShowAddColor(false); resetColorForm()
    setOfferingModal('create')
  }

  function openEditOffering(vo: OfferingEdit) {
    setOfferVendorId(String(vo.vendor_id))
    setOfferItemName(vo.vendor_item_name || '')
    setOfferSku(vo.vendor_sku || '')
    // For single colors, resolve back to cc: format; bicolors stay as sc:
    if (vo.stem_colors?.color_type === 'bicolor') {
      setOfferColor(`sc:${vo.stem_color_id}`)
    } else if (vo.stem_colors) {
      setOfferColor(`cc:${vo.stem_colors.primary_color_category_id}`)
    } else {
      setOfferColor('')
    }
    setOfferLength(vo.length_cm ? String(vo.length_cm) : '')
    setOfferActive(vo.is_active)
    setShowAddColor(false); resetColorForm()
    setOfferingModal(vo)
  }

  function closeOfferingModal() {
    setOfferingModal(null); setShowAddColor(false); resetColorForm()
  }

  async function handleSaveOffering() {
    if (!expandedId || !offerVendorId) return
    try {
      // Resolve stem_color_id from picker value
      let stemColorId: number | null = null
      if (offerColor.startsWith('sc:')) {
        stemColorId = Number(offerColor.slice(3))
      } else if (offerColor.startsWith('cc:')) {
        // Find-or-create a single stem_color for this color category
        const ccId = Number(offerColor.slice(3))
        const existing = allStemColors?.find(
          sc => sc.primary_color_category_id === ccId && sc.color_type === 'single'
        )
        if (existing) {
          stemColorId = existing.id
        } else {
          const created = await createStemColor.mutateAsync({
            color_type: 'single',
            primary_color_category_id: ccId,
          })
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
        await createOffering.mutateAsync({ stem_id: expandedId, ...payload })
        showToast('Offering created')
      } else if (offeringModal) {
        await updateOffering.mutateAsync({ id: offeringModal.id, stem_id: expandedId, ...payload })
        showToast('Offering updated')
      }
      closeOfferingModal()
    } catch (e: any) { showToast(`Error: ${e.message}`) }
  }

  async function handleDeleteOffering() {
    if (!confirmDeleteOffering || !expandedId) return
    try {
      await deleteOffering.mutateAsync({ id: confirmDeleteOffering.id, stem_id: expandedId })
      showToast('Offering deleted'); setConfirmDeleteOffering(null)
    } catch (e: any) { showToast(`Error: ${e.message}`) }
  }

  /* ── color handlers ── */

  function resetColorForm() {
    setNewColorPrimary(''); setNewColorSecondary(''); setNewColorBicolorType('')
  }

  async function handleAddStemColor() {
    if (!newColorPrimary) return
    const isBicolor = !!newColorSecondary
    try {
      const created = await createStemColor.mutateAsync({
        color_type: isBicolor ? 'bicolor' : 'single',
        primary_color_category_id: Number(newColorPrimary),
        secondary_color_category_id: isBicolor ? Number(newColorSecondary) : null,
        bicolor_type: isBicolor ? (newColorBicolorType as any || 'variegated') : null,
      })
      showToast('Bicolor created')
      setOfferColor(`sc:${created.id}`)
      setShowAddColor(false); resetColorForm()
    } catch (e: any) { showToast(`Error: ${e.message}`) }
  }

  /* ── render ── */

  const isEditingOffering = offeringModal !== null && offeringModal !== 'create'
  const offeringSaving = createOffering.isPending || updateOffering.isPending

  return (
    <div className="page">
      <div className="page-header">
        <h1 className="page-title">
          Catalog
          <span className="page-count">({totalCount}{isFetching && !isLoading ? '...' : ''})</span>
        </h1>
        <button className="btn btn-primary" onClick={openCreateStem}>+ Add Stem</button>
      </div>

      <div className="toolbar">
        <div className="search-wrap">
          <span className="search-icon">🔍</span>
          <input className="search-input" type="text" placeholder="Search stems, varieties..." value={searchInput} onChange={e => handleSearchChange(e.target.value)} />
        </div>
        <select className="filter-select" value={categoryFilter} onChange={e => handleCategoryChange(e.target.value)}>
          <option value="">All Categories</option>
          {categories?.map(c => <option key={c} value={c}>{c}</option>)}
        </select>
        <select className="filter-select" value={vendorFilter} onChange={e => handleVendorChange(e.target.value)}>
          <option value="">All Vendors</option>
          {vendors?.map(v => <option key={v.id} value={v.id}>{v.name}</option>)}
        </select>
        <ColorCategoryPicker value={colorFilter} onChange={handleColorChange} colors={colors || []} placeholder="All Colors" style={{ flex: 1 }} />
      </div>

      {/* ── main table ── */}
      <div className="table-wrap">
        <div className="table-scroll">
          <table className="data-table">
            <thead>
              <tr>
                <th style={{ width: 30 }}></th>
                <th style={{ width: 220 }}>Stem</th>
                <th>Offerings</th>
                <th style={{ width: 80 }}>Actions</th>
              </tr>
            </thead>
            {isLoading ? (
              <tbody>
                {Array.from({ length: 8 }).map((_, i) => (
                  <tr key={i}>{Array.from({ length: 4 }).map((_, j) => <td key={j}><div className="skeleton" style={{ width: '70%' }} /></td>)}</tr>
                ))}
              </tbody>
            ) : !stems?.length ? (
              <tbody>
                <tr><td colSpan={4}><div className="empty-state"><p>🌿</p><p>No stems found</p></div></td></tr>
              </tbody>
            ) : stems.map(stem => (
              <tbody key={stem.id}>
                <tr style={{ cursor: 'pointer' }} onClick={() => setExpandedId(expandedId === stem.id ? null : stem.id)}>
                  <td style={{ textAlign: 'center', fontSize: '.75rem' }}>{expandedId === stem.id ? '▼' : '▶'}</td>
                  <td>
                    <div style={{ fontWeight: 600 }}>{stem.name}</div>
                    <div style={{ fontSize: '.78rem', color: 'var(--muted)' }}>
                      {stem.category}{stem.subcategory && <span> / {stem.subcategory}</span>}{stem.variety && <span> / {stem.variety}</span>}
                    </div>
                  </td>
                  <td>
                    {stem.vendor_offerings.length > 0 ? (() => {
                      // Only show active offerings in the pills
                      const activeOfferings = stem.vendor_offerings.filter(vo => vo.is_active)
                      if (!activeOfferings.length) return <span style={{ fontSize: '.78rem', color: 'var(--muted)' }}>All inactive</span>
                      // Group offerings by stem_color_id (null = uncolored)
                      const groups = new Map<string, typeof stem.vendor_offerings>()
                      for (const vo of activeOfferings) {
                        const key = vo.stem_color_id != null ? String(vo.stem_color_id) : '_none'
                        if (!groups.has(key)) groups.set(key, [])
                        groups.get(key)!.push(vo)
                      }
                      // Sort: colored groups first (by color name), uncolored last
                      const sorted = [...groups.entries()].sort((a, b) => {
                        if (a[0] === '_none') return 1
                        if (b[0] === '_none') return -1
                        const aName = a[1][0]?.stem_colors?.color_categories?.name || ''
                        const bName = b[1][0]?.stem_colors?.color_categories?.name || ''
                        return aName.localeCompare(bName)
                      })
                      return (
                        <div style={{ display: 'flex', flexDirection: 'column', gap: 3 }}>
                          {sorted.map(([key, offerings]) => {
                            const sc = offerings[0]?.stem_colors
                            return (
                              <div key={key} style={{ display: 'flex', alignItems: 'center', gap: 4, flexWrap: 'wrap' }}>
                                {/* Color swatch label */}
                                <span style={{
                                  display: 'inline-flex', alignItems: 'center', gap: 3,
                                  fontSize: '.72rem', color: 'var(--muted)', minWidth: 70,
                                }}>
                                  {sc ? <>{stemColorSwatch(sc, 10)} {sc.color_categories?.name}</> : 'no color'}
                                </span>
                                {/* Vendor pills for this color */}
                                {offerings.map(vo => (
                                  <span key={vo.id} style={{
                                    display: 'inline-flex', alignItems: 'center', gap: 3,
                                    padding: '1px 7px', borderRadius: 10, fontSize: '.75rem',
                                    background: 'var(--surface-hover, #f3f4f6)', border: '1px solid var(--border, #e5e7eb)',
                                  }}>
                                    <span style={{ fontWeight: 500 }}>{vo.vendors.name}</span>
                                    {vo.length_cm != null && <span style={{ color: 'var(--muted)', fontSize: '.68rem' }}>{vo.length_cm}cm</span>}
                                  </span>
                                ))}
                              </div>
                            )
                          })}
                        </div>
                      )
                    })() : (
                      <span style={{ fontSize: '.78rem', color: 'var(--muted)' }}>No offerings</span>
                    )}
                  </td>
                  <td>
                    <div className="actions-cell" onClick={e => e.stopPropagation()}>
                      <button className="btn-icon" title="Edit" onClick={() => openEditStem(stem)}>✏️</button>
                      <button className="btn-icon" title="Delete" onClick={() => setConfirmDeleteStem(stem)}>🗑️</button>
                    </div>
                  </td>
                </tr>

                {/* ── expanded detail ── */}
                {expandedId === stem.id && (
                  <tr>
                    <td colSpan={4} style={{ padding: 0 }}>
                      <div className="expandable-content">
                        {!detail ? (
                          <div style={{ padding: '16px 24px', color: 'var(--muted)' }}>Loading details...</div>
                        ) : (
                          <>
                            {/* Vendor offerings section */}
                            <div className="expand-section">
                              <div className="expand-section-title" style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                                <span>Vendor Offerings ({detail.vendor_offerings?.length || 0})</span>
                                <button className="btn btn-primary" style={{ fontSize: '.75rem', padding: '3px 10px' }} onClick={openCreateOffering}>+ Add Offering</button>
                              </div>
                              {detail.vendor_offerings?.length > 0 ? (
                                <table className="data-table sub-table">
                                  <thead>
                                    <tr>
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
                                    {[...detail.vendor_offerings].sort((a, b) => (a.is_active === b.is_active ? 0 : a.is_active ? -1 : 1)).map(vo => (
                                      <tr key={vo.id} style={vo.is_active ? {} : { opacity: 0.45 }}>
                                        <td>
                                          <span className={`supplier-tag ${vo.vendors?.vendor_type === 'wholesaler' ? 'wholesaler' : ''}`}>{vo.vendors?.name}</span>
                                        </td>
                                        <td style={{ fontWeight: 500 }}>{vo.vendor_item_name || '—'}</td>
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
                                            <button className="btn-icon" title="Edit" onClick={() => openEditOffering(vo)}>✏️</button>
                                            <button className="btn-icon" title="Delete" onClick={() => setConfirmDeleteOffering(vo)}>🗑️</button>
                                          </div>
                                        </td>
                                      </tr>
                                    ))}
                                  </tbody>
                                </table>
                              ) : (
                                <span style={{ fontSize: '.82rem', color: 'var(--muted)' }}>No vendor offerings</span>
                              )}
                            </div>
                          </>
                        )}
                      </div>
                    </td>
                  </tr>
                )}
              </tbody>
            ))}
          </table>
        </div>
      </div>

      {/* ── pagination ── */}
      {totalPages > 1 && (
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '12px 0', fontSize: '.85rem' }}>
          <span style={{ color: 'var(--muted)' }}>
            {page * PAGE_SIZE + 1}–{Math.min((page + 1) * PAGE_SIZE, totalCount)} of {totalCount}
          </span>
          <div style={{ display: 'flex', gap: 4 }}>
            <button className="btn btn-secondary" style={{ padding: '4px 12px', fontSize: '.82rem' }} disabled={page === 0} onClick={() => setPage(0)}>First</button>
            <button className="btn btn-secondary" style={{ padding: '4px 12px', fontSize: '.82rem' }} disabled={page === 0} onClick={() => setPage(p => p - 1)}>Prev</button>
            <span style={{ display: 'flex', alignItems: 'center', padding: '0 8px', color: 'var(--muted)' }}>
              Page {page + 1} of {totalPages}
            </span>
            <button className="btn btn-secondary" style={{ padding: '4px 12px', fontSize: '.82rem' }} disabled={page >= totalPages - 1} onClick={() => setPage(p => p + 1)}>Next</button>
            <button className="btn btn-secondary" style={{ padding: '4px 12px', fontSize: '.82rem' }} disabled={page >= totalPages - 1} onClick={() => setPage(totalPages - 1)}>Last</button>
          </div>
        </div>
      )}

      {/* ── Stem create/edit modal ── */}
      {(showCreateStem || editStem) && (
        <Modal
          title={editStem ? 'Edit Stem' : 'New Stem'}
          onClose={() => { setShowCreateStem(false); setEditStem(null) }}
          footer={<>
            <button className="btn btn-secondary" onClick={() => { setShowCreateStem(false); setEditStem(null) }}>Cancel</button>
            <button className="btn btn-primary" onClick={handleSaveStem} disabled={!formCategory || !formName}>{editStem ? 'Save' : 'Create'}</button>
          </>}
        >
          <div className="form-row"><label>Category</label><input type="text" value={formCategory} onChange={e => setFormCategory(e.target.value)} placeholder="e.g. rose, carnation, greenery" /></div>
          <div className="form-row"><label>Subcategory (optional)</label><input type="text" value={formSubcategory} onChange={e => setFormSubcategory(e.target.value)} placeholder="e.g. spray, garden, hanging" /></div>
          <div className="form-row"><label>Variety (optional)</label><input type="text" value={formVariety} onChange={e => setFormVariety(e.target.value)} placeholder="e.g. freedom, reef, quicksand" /></div>
          <div className="form-row"><label>Display Name</label><input type="text" value={formName} onChange={e => setFormName(e.target.value)} placeholder="e.g. rose freedom" /></div>
        </Modal>
      )}

      {/* ── Delete stem confirm ── */}
      {confirmDeleteStem && (
        <Modal title="Delete Stem" onClose={() => setConfirmDeleteStem(null)} footer={<>
          <button className="btn btn-secondary" onClick={() => setConfirmDeleteStem(null)}>Cancel</button>
          <button className="btn btn-danger" onClick={handleDeleteStem}>Delete</button>
        </>}>
          <div className="confirm-body">
            <p>Delete stem</p>
            <p className="confirm-name">{confirmDeleteStem.name}</p>
            <p style={{ fontSize: '.82rem', color: 'var(--amber)', marginTop: 8 }}>This will cascade to colors and vendor offerings</p>
          </div>
        </Modal>
      )}

      {/* ── Offering create/edit modal ── */}
      {offeringModal !== null && (
        <Modal
          title={isEditingOffering ? 'Edit Vendor Offering' : 'New Vendor Offering'}
          onClose={closeOfferingModal}
          footer={<>
            <button className="btn btn-secondary" onClick={closeOfferingModal}>Cancel</button>
            <button className="btn btn-primary" onClick={handleSaveOffering} disabled={!offerVendorId || offeringSaving}>
              {offeringSaving ? '...' : isEditingOffering ? 'Save' : 'Create'}
            </button>
          </>}
        >
          <div className="form-row">
            <label>Vendor</label>
            <select value={offerVendorId} onChange={e => setOfferVendorId(e.target.value)}>
              <option value="">Select vendor...</option>
              {vendors?.map(v => <option key={v.id} value={v.id}>{v.name}</option>)}
            </select>
          </div>
          <div className="form-row">
            <label>Item Name (optional)</label>
            <input type="text" value={offerItemName} onChange={e => setOfferItemName(e.target.value)} placeholder="e.g. Acacia Purple Fernleaf" />
          </div>
          <div className="form-row">
            <label>SKU (optional)</label>
            <input type="text" value={offerSku} onChange={e => setOfferSku(e.target.value)} placeholder="e.g. G1365" />
          </div>
          <div className="form-row">
            <label>Color</label>
            <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
              <OfferingColorPicker
                value={offerColor}
                onChange={setOfferColor}
                stemColors={allStemColors || []}
                colorCategories={colors || []}
              />
              <button
                type="button" className="btn btn-secondary"
                style={{ fontSize: '.78rem', padding: '4px 8px', whiteSpace: 'nowrap' }}
                onClick={() => setShowAddColor(!showAddColor)}
              >+ Bicolor</button>
            </div>
          </div>

          {/* Inline bicolor form */}
          {showAddColor && (
            <div style={{ background: 'var(--surface-hover, #f5f5f4)', padding: '10px 12px', borderRadius: 6, marginTop: 4, marginBottom: 8 }}>
              <div style={{ fontSize: '.82rem', fontWeight: 500, marginBottom: 8 }}>Create a bicolor stem color</div>
              <div className="form-row">
                <label>Primary Color</label>
                <ColorCategoryPicker value={newColorPrimary} onChange={setNewColorPrimary} colors={colors || []} placeholder="Select..." />
              </div>
              <div className="form-row">
                <label>Secondary Color</label>
                <ColorCategoryPicker value={newColorSecondary} onChange={setNewColorSecondary} colors={colors || []} placeholder="Select..." />
              </div>
              <div className="form-row">
                <label>Bicolor Type</label>
                <select value={newColorBicolorType || 'variegated'} onChange={e => setNewColorBicolorType(e.target.value)}>
                  <option value="variegated">variegated</option>
                  <option value="fade">fade</option>
                  <option value="tipped">tipped</option>
                  <option value="striped">striped</option>
                </select>
              </div>
              {/* Preview */}
              {newColorPrimary && newColorSecondary && (() => {
                const pc = colors?.find(c => c.id === Number(newColorPrimary))
                const sc = colors?.find(c => c.id === Number(newColorSecondary))
                return (
                  <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 4, marginBottom: 4 }}>
                    <span style={{ display: 'inline-block', width: 20, height: 20, borderRadius: '50%', background: `linear-gradient(135deg, ${pc?.hex_code || '#ccc'} 50%, ${sc?.hex_code || '#ccc'} 50%)`, border: '1px solid rgba(0,0,0,.12)', flexShrink: 0 }} />
                    <span style={{ fontSize: '.82rem' }}>{pc?.name} / {sc?.name}</span>
                  </div>
                )
              })()}
              <div style={{ display: 'flex', gap: 6, marginTop: 8 }}>
                <button className="btn btn-primary" style={{ fontSize: '.78rem', padding: '4px 12px' }} onClick={handleAddStemColor} disabled={!newColorPrimary || !newColorSecondary || createStemColor.isPending}>
                  {createStemColor.isPending ? '...' : 'Create & Select'}
                </button>
                <button className="btn btn-secondary" style={{ fontSize: '.78rem', padding: '4px 12px' }} onClick={() => { setShowAddColor(false); resetColorForm() }}>Cancel</button>
              </div>
            </div>
          )}

          <div className="form-row">
            <label>Length (cm, optional)</label>
            <input type="number" value={offerLength} onChange={e => setOfferLength(e.target.value)} placeholder="e.g. 60" />
          </div>
          <div className="form-row">
            <label style={{ display: 'flex', alignItems: 'center', gap: 8, cursor: 'pointer' }}>
              <input type="checkbox" checked={offerActive} onChange={e => setOfferActive(e.target.checked)} />
              Active
            </label>
          </div>
        </Modal>
      )}

      {/* ── Delete offering confirm ── */}
      {confirmDeleteOffering && (
        <Modal title="Delete Offering" onClose={() => setConfirmDeleteOffering(null)} footer={<>
          <button className="btn btn-secondary" onClick={() => setConfirmDeleteOffering(null)}>Cancel</button>
          <button className="btn btn-danger" onClick={handleDeleteOffering}>Delete</button>
        </>}>
          <div className="confirm-body">
            <p>Delete offering</p>
            <p className="confirm-name">{confirmDeleteOffering.vendor_item_name || 'Unnamed offering'}</p>
            <p style={{ fontSize: '.82rem', color: 'var(--muted)', marginTop: 4 }}>from {confirmDeleteOffering.vendors?.name}</p>
          </div>
        </Modal>
      )}
    </div>
  )
}
