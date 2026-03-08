import { useState, useMemo } from 'react'
import { useProductItems, useCreateProductItem, useUpdateProductItem, useDeleteProductItem } from '../hooks/useProductItems'
import { useStems } from '../hooks/useStems'
import { useVendors } from '../hooks/useVendors'
import { useColors } from '../hooks/useColors'
import { useVarieties } from '../hooks/useVarieties'
import { Modal } from '../components/Modal'
import { useToast } from '../components/Toast'
import type { ProductItemWithRelations } from '../lib/types'

export function ProductItems() {
  const { data: items, isLoading } = useProductItems()
  const { data: stems } = useStems()
  const { data: vendors } = useVendors()
  const { data: colors } = useColors()
  const { data: varieties } = useVarieties()
  const create = useCreateProductItem()
  const update = useUpdateProductItem()
  const del = useDeleteProductItem()
  const { showToast } = useToast()

  const [search, setSearch] = useState('')
  const [vendorFilter, setVendorFilter] = useState('')
  const [categoryFilter, setCategoryFilter] = useState('')
  const [groupBy, setGroupBy] = useState<'none' | 'stem_category' | 'vendor'>('none')
  const [editItem, setEditItem] = useState<ProductItemWithRelations | null>(null)
  const [showCreate, setShowCreate] = useState(false)
  const [deleteItem, setDeleteItem] = useState<ProductItemWithRelations | null>(null)

  // Form state
  const [formName, setFormName] = useState('')
  const [formStemId, setFormStemId] = useState('')
  const [formVendorId, setFormVendorId] = useState('')
  const [formSku, setFormSku] = useState('')

  const filtered = useMemo(() => {
    if (!items) return []
    return items.filter(item => {
      if (search) {
        const q = search.toLowerCase()
        const match = item.product_item_name.toLowerCase().includes(q)
          || item.vendor_sku?.toLowerCase().includes(q)
          || item.stem_varieties?.varieties?.name?.toLowerCase().includes(q)
        if (!match) return false
      }
      if (vendorFilter && item.vendor_id !== Number(vendorFilter)) return false
      if (categoryFilter && item.stems?.stem_category !== categoryFilter) return false
      return true
    })
  }, [items, search, vendorFilter, categoryFilter])

  const grouped = useMemo(() => {
    if (groupBy === 'none') return { '': filtered }
    const groups: Record<string, typeof filtered> = {}
    for (const item of filtered) {
      const key = groupBy === 'stem_category'
        ? item.stems?.stem_category || 'Unknown'
        : item.vendors?.name || 'Unknown'
      if (!groups[key]) groups[key] = []
      groups[key].push(item)
    }
    return Object.fromEntries(Object.entries(groups).sort(([a], [b]) => a.localeCompare(b)))
  }, [filtered, groupBy])

  const categories = useMemo(() => {
    if (!items) return []
    return [...new Set(items.map(i => i.stems?.stem_category).filter(Boolean))].sort()
  }, [items])

  function openCreate() {
    setFormName('')
    setFormStemId('')
    setFormVendorId('')
    setFormSku('')
    setShowCreate(true)
  }

  function openEdit(item: ProductItemWithRelations) {
    setFormName(item.product_item_name)
    setFormStemId(String(item.stem_id))
    setFormVendorId(String(item.vendor_id))
    setFormSku(item.vendor_sku || '')
    setEditItem(item)
  }

  async function handleSave() {
    const payload = {
      product_item_name: formName,
      stem_id: Number(formStemId),
      vendor_id: Number(formVendorId),
      vendor_sku: formSku || null,
    }
    try {
      if (editItem) {
        await update.mutateAsync({ id: editItem.id, ...payload })
        showToast('Product item updated')
        setEditItem(null)
      } else {
        await create.mutateAsync(payload)
        showToast('Product item created')
        setShowCreate(false)
      }
    } catch (e: any) {
      showToast(`Error: ${e.message}`)
    }
  }

  async function handleDelete() {
    if (!deleteItem) return
    try {
      await del.mutateAsync(deleteItem.id)
      showToast('Product item deleted')
      setDeleteItem(null)
    } catch (e: any) {
      showToast(`Error: ${e.message}`)
    }
  }

  const formModal = (showCreate || editItem) && (
    <Modal
      title={editItem ? 'Edit Product Item' : 'New Product Item'}
      onClose={() => { setShowCreate(false); setEditItem(null) }}
      footer={
        <>
          <button className="btn btn-secondary" onClick={() => { setShowCreate(false); setEditItem(null) }}>Cancel</button>
          <button className="btn btn-primary" onClick={handleSave} disabled={!formName || !formStemId || !formVendorId}>
            {editItem ? 'Save' : 'Create'}
          </button>
        </>
      }
    >
      <div className="form-row">
        <label>Product Name</label>
        <input type="text" value={formName} onChange={e => setFormName(e.target.value)} placeholder="Product item name" />
      </div>
      <div className="form-row-2">
        <div className="form-row">
          <label>Stem</label>
          <select value={formStemId} onChange={e => setFormStemId(e.target.value)}>
            <option value="">Select stem…</option>
            {stems?.map(s => (
              <option key={s.id} value={s.id}>
                {s.stem_category}{s.stem_subcategory ? ` (${s.stem_subcategory})` : ''}
              </option>
            ))}
          </select>
        </div>
        <div className="form-row">
          <label>Vendor</label>
          <select value={formVendorId} onChange={e => setFormVendorId(e.target.value)}>
            <option value="">Select vendor…</option>
            {vendors?.map(v => (
              <option key={v.id} value={v.id}>{v.name}</option>
            ))}
          </select>
        </div>
      </div>
      <div className="form-row">
        <label>Vendor SKU</label>
        <input type="text" value={formSku} onChange={e => setFormSku(e.target.value)} placeholder="Optional" />
      </div>
    </Modal>
  )

  const deleteModal = deleteItem && (
    <Modal
      title="Delete Product Item"
      onClose={() => setDeleteItem(null)}
      footer={
        <>
          <button className="btn btn-secondary" onClick={() => setDeleteItem(null)}>Cancel</button>
          <button className="btn btn-danger" onClick={handleDelete}>Delete</button>
        </>
      }
    >
      <div className="confirm-body">
        <p>Are you sure you want to delete</p>
        <p className="confirm-name">{deleteItem.product_item_name}</p>
      </div>
    </Modal>
  )

  return (
    <div className="page">
      <div className="page-header">
        <h1 className="page-title">
          Product Items
          {items && <span className="page-count">({filtered.length})</span>}
        </h1>
        <button className="btn btn-primary" onClick={openCreate}>+ Add Item</button>
      </div>

      <div className="toolbar">
        <div className="search-wrap">
          <span className="search-icon">🔍</span>
          <input
            className="search-input"
            type="text"
            placeholder="Search products, varieties, SKUs…"
            value={search}
            onChange={e => setSearch(e.target.value)}
          />
        </div>
        <select className="filter-select" value={vendorFilter} onChange={e => setVendorFilter(e.target.value)}>
          <option value="">All Vendors</option>
          {vendors?.map(v => <option key={v.id} value={v.id}>{v.name}</option>)}
        </select>
        <select className="filter-select" value={categoryFilter} onChange={e => setCategoryFilter(e.target.value)}>
          <option value="">All Categories</option>
          {categories.map(c => <option key={c} value={c}>{c}</option>)}
        </select>
        <select className="filter-select" value={groupBy} onChange={e => setGroupBy(e.target.value as any)}>
          <option value="none">No Grouping</option>
          <option value="stem_category">Group by Category</option>
          <option value="vendor">Group by Vendor</option>
        </select>
      </div>

      <div className="table-wrap">
        <div className="table-scroll">
          <table className="data-table">
            <thead>
              <tr>
                <th>Product Name</th>
                <th>Vendor</th>
                <th>Category</th>
                <th>Color</th>
                <th>Variety</th>
                <th>SKU</th>
                <th style={{ width: 80 }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {isLoading ? (
                Array.from({ length: 8 }).map((_, i) => (
                  <tr key={i}>
                    {Array.from({ length: 7 }).map((_, j) => (
                      <td key={j}><div className="skeleton" style={{ width: `${60 + Math.random() * 40}%` }} /></td>
                    ))}
                  </tr>
                ))
              ) : filtered.length === 0 ? (
                <tr>
                  <td colSpan={7}>
                    <div className="empty-state">
                      <p>🌸</p>
                      <p>No product items found</p>
                    </div>
                  </td>
                </tr>
              ) : (
                Object.entries(grouped).map(([group, groupItems]) => (
                  <>
                    {group && (
                      <tr key={`group-${group}`} className="group-row">
                        <td colSpan={7}>{group} ({groupItems.length})</td>
                      </tr>
                    )}
                    {groupItems.map(item => (
                      <tr key={item.id}>
                        <td style={{ fontWeight: 600 }}>{item.product_item_name}</td>
                        <td>
                          <span className={`supplier-tag ${item.vendors?.vendor_type === 'wholesaler' ? 'wholesaler' : ''}`}>
                            {item.vendors?.name}
                          </span>
                        </td>
                        <td>
                          {item.stems?.stem_category}
                          {item.stems?.stem_subcategory && <span style={{ color: 'var(--muted)', marginLeft: 4 }}>({item.stems.stem_subcategory})</span>}
                        </td>
                        <td>
                          {item.stem_color_categories?.color_categories && (
                            <span className="color-name-with-swatch">
                              <span
                                className="color-swatch"
                                style={{ background: item.stem_color_categories.color_categories.hex_code || '#ccc' }}
                              />
                              {item.stem_color_categories.color_categories.name}
                            </span>
                          )}
                        </td>
                        <td>{item.stem_varieties?.varieties?.name}</td>
                        <td style={{ fontFamily: "'SF Mono', monospace", fontSize: '.82rem', color: 'var(--muted)' }}>
                          {item.vendor_sku}
                        </td>
                        <td>
                          <div className="actions-cell">
                            <button className="btn-icon" title="Edit" onClick={() => openEdit(item)}>✏️</button>
                            <button className="btn-icon" title="Delete" onClick={() => setDeleteItem(item)}>🗑️</button>
                          </div>
                        </td>
                      </tr>
                    ))}
                  </>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
      {formModal}
      {deleteModal}
    </div>
  )
}
