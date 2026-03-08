import { useState } from 'react'
import { useStems, useCreateStem, useUpdateStem, useDeleteStem, useStemDetail } from '../hooks/useStems'
import { Modal } from '../components/Modal'
import { useToast } from '../components/Toast'
import type { StemWithCounts } from '../lib/types'

export function Stems() {
  const { data: stems, isLoading } = useStems()
  const create = useCreateStem()
  const update = useUpdateStem()
  const del = useDeleteStem()
  const { showToast } = useToast()

  const [search, setSearch] = useState('')
  const [editStem, setEditStem] = useState<StemWithCounts | null>(null)
  const [showCreate, setShowCreate] = useState(false)
  const [deleteStem, setDeleteStem] = useState<StemWithCounts | null>(null)
  const [expandedId, setExpandedId] = useState<number | null>(null)

  const [formCategory, setFormCategory] = useState('')
  const [formSubcategory, setFormSubcategory] = useState('')

  const { data: detail } = useStemDetail(expandedId)

  const filtered = stems?.filter(s => {
    if (!search) return true
    const q = search.toLowerCase()
    return s.stem_category.toLowerCase().includes(q) ||
      s.stem_subcategory?.toLowerCase().includes(q)
  }) || []

  function openCreate() {
    setFormCategory('')
    setFormSubcategory('')
    setShowCreate(true)
  }

  function openEdit(stem: StemWithCounts) {
    setFormCategory(stem.stem_category)
    setFormSubcategory(stem.stem_subcategory || '')
    setEditStem(stem)
  }

  async function handleSave() {
    const payload = {
      stem_category: formCategory,
      stem_subcategory: formSubcategory || null,
    }
    try {
      if (editStem) {
        await update.mutateAsync({ id: editStem.id, ...payload })
        showToast('Stem updated')
        setEditStem(null)
      } else {
        await create.mutateAsync(payload)
        showToast('Stem created')
        setShowCreate(false)
      }
    } catch (e: any) {
      showToast(`Error: ${e.message}`)
    }
  }

  async function handleDelete() {
    if (!deleteStem) return
    try {
      await del.mutateAsync(deleteStem.id)
      showToast('Stem deleted')
      setDeleteStem(null)
    } catch (e: any) {
      showToast(`Error: ${e.message}`)
    }
  }

  const formModal = (showCreate || editStem) && (
    <Modal
      title={editStem ? 'Edit Stem' : 'New Stem'}
      onClose={() => { setShowCreate(false); setEditStem(null) }}
      footer={
        <>
          <button className="btn btn-secondary" onClick={() => { setShowCreate(false); setEditStem(null) }}>Cancel</button>
          <button className="btn btn-primary" onClick={handleSave} disabled={!formCategory}>
            {editStem ? 'Save' : 'Create'}
          </button>
        </>
      }
    >
      <div className="form-row">
        <label>Category</label>
        <input type="text" value={formCategory} onChange={e => setFormCategory(e.target.value)} placeholder="e.g. rose, carnation, greenery" />
      </div>
      <div className="form-row">
        <label>Subcategory (optional)</label>
        <input type="text" value={formSubcategory} onChange={e => setFormSubcategory(e.target.value)} placeholder="e.g. spray, garden, hanging" />
      </div>
    </Modal>
  )

  return (
    <div className="page">
      <div className="page-header">
        <h1 className="page-title">Stems{stems && <span className="page-count">({filtered.length})</span>}</h1>
        <button className="btn btn-primary" onClick={openCreate}>+ Add Stem</button>
      </div>
      <div className="toolbar">
        <div className="search-wrap">
          <span className="search-icon">🔍</span>
          <input className="search-input" type="text" placeholder="Search stems…" value={search} onChange={e => setSearch(e.target.value)} />
        </div>
      </div>
      <div className="table-wrap">
        <div className="table-scroll">
          <table className="data-table">
            <thead>
              <tr>
                <th></th>
                <th>Category</th>
                <th>Subcategory</th>
                <th>Varieties</th>
                <th>Products</th>
                <th style={{ width: 80 }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {isLoading ? (
                Array.from({ length: 6 }).map((_, i) => (
                  <tr key={i}>{Array.from({ length: 6 }).map((_, j) => <td key={j}><div className="skeleton" style={{ width: '70%' }} /></td>)}</tr>
                ))
              ) : filtered.length === 0 ? (
                <tr><td colSpan={6}><div className="empty-state"><p>🌿</p><p>No stems found</p></div></td></tr>
              ) : filtered.map(stem => (
                <>
                  <tr key={stem.id} style={{ cursor: 'pointer' }} onClick={() => setExpandedId(expandedId === stem.id ? null : stem.id)}>
                    <td style={{ width: 30, textAlign: 'center', fontSize: '.75rem' }}>
                      {expandedId === stem.id ? '▼' : '▶'}
                    </td>
                    <td style={{ fontWeight: 600 }}>{stem.stem_category}</td>
                    <td style={{ color: stem.stem_subcategory ? 'var(--text)' : 'var(--muted)' }}>
                      {stem.stem_subcategory || '—'}
                    </td>
                    <td>{stem.stem_varieties?.[0]?.count ?? 0}</td>
                    <td>{stem.product_items?.[0]?.count ?? 0}</td>
                    <td>
                      <div className="actions-cell" onClick={e => e.stopPropagation()}>
                        <button className="btn-icon" title="Edit" onClick={() => openEdit(stem)}>✏️</button>
                        <button className="btn-icon" title="Delete" onClick={() => setDeleteStem(stem)}>🗑️</button>
                      </div>
                    </td>
                  </tr>
                  {expandedId === stem.id && detail && (
                    <tr key={`exp-${stem.id}`}>
                      <td colSpan={6} style={{ padding: 0 }}>
                        <div className="expandable-content">
                          <div className="expand-section">
                            <div className="expand-section-title">Varieties ({detail.stem_varieties?.length || 0})</div>
                            <div className="chip-list">
                              {detail.stem_varieties?.length > 0
                                ? detail.stem_varieties.map((sv: any) => (
                                  <span key={sv.id} className="chip variety-chip">
                                    {sv.varieties?.variety_color_categories?.map((vcc: any) => (
                                      <span key={vcc.id} className="color-dot" style={{ background: vcc.color_categories?.hex_code || '#ccc' }} title={vcc.color_categories?.name} />
                                    ))}
                                    {sv.varieties?.name}
                                  </span>
                                ))
                                : <span style={{ fontSize: '.82rem', color: 'var(--muted)' }}>No varieties linked</span>
                              }
                            </div>
                          </div>
                        </div>
                      </td>
                    </tr>
                  )}
                </>
              ))}
            </tbody>
          </table>
        </div>
      </div>
      {formModal}
      {deleteStem && (
        <Modal title="Delete Stem" onClose={() => setDeleteStem(null)} footer={
          <><button className="btn btn-secondary" onClick={() => setDeleteStem(null)}>Cancel</button>
          <button className="btn btn-danger" onClick={handleDelete}>Delete</button></>
        }>
          <div className="confirm-body">
            <p>Delete stem</p>
            <p className="confirm-name">{deleteStem.stem_category}{deleteStem.stem_subcategory ? ` (${deleteStem.stem_subcategory})` : ''}</p>
            <p style={{ fontSize: '.82rem', color: 'var(--amber)', marginTop: 8 }}>⚠️ This will cascade to varieties, colors, and product items</p>
          </div>
        </Modal>
      )}
    </div>
  )
}
