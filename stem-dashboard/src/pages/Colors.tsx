import { useState } from 'react'
import { useColors, useCreateColor, useUpdateColor, useDeleteColor } from '../hooks/useColors'
import { Modal } from '../components/Modal'
import { useToast } from '../components/Toast'
import type { ColorCategoryWithCount } from '../lib/types'

export function Colors() {
  const { data: colors, isLoading } = useColors()
  const create = useCreateColor()
  const update = useUpdateColor()
  const del = useDeleteColor()
  const { showToast } = useToast()

  const [editColor, setEditColor] = useState<ColorCategoryWithCount | null>(null)
  const [showCreate, setShowCreate] = useState(false)
  const [deleteColor, setDeleteColor] = useState<ColorCategoryWithCount | null>(null)

  const [formName, setFormName] = useState('')
  const [formHex, setFormHex] = useState('')
  const [formSort, setFormSort] = useState('')

  function openCreate() {
    setFormName('')
    setFormHex('')
    setFormSort('')
    setShowCreate(true)
  }

  function openEdit(color: ColorCategoryWithCount) {
    setFormName(color.name)
    setFormHex(color.hex_code || '')
    setFormSort(color.sort_order != null ? String(color.sort_order) : '')
    setEditColor(color)
  }

  async function handleSave() {
    const payload = {
      name: formName,
      hex_code: formHex || null,
      sort_order: formSort ? Number(formSort) : null,
    }
    try {
      if (editColor) {
        await update.mutateAsync({ id: editColor.id, ...payload })
        showToast('Color updated')
        setEditColor(null)
      } else {
        await create.mutateAsync(payload)
        showToast('Color created')
        setShowCreate(false)
      }
    } catch (e: any) {
      showToast(`Error: ${e.message}`)
    }
  }

  async function handleDelete() {
    if (!deleteColor) return
    try {
      await del.mutateAsync(deleteColor.id)
      showToast('Color deleted')
      setDeleteColor(null)
    } catch (e: any) {
      showToast(`Error: ${e.message}`)
    }
  }

  const formModal = (showCreate || editColor) && (
    <Modal
      title={editColor ? 'Edit Color' : 'New Color'}
      onClose={() => { setShowCreate(false); setEditColor(null) }}
      footer={
        <>
          <button className="btn btn-secondary" onClick={() => { setShowCreate(false); setEditColor(null) }}>Cancel</button>
          <button className="btn btn-primary" onClick={handleSave} disabled={!formName}>{editColor ? 'Save' : 'Create'}</button>
        </>
      }
    >
      <div className="form-row">
        <label>Color Name</label>
        <input type="text" value={formName} onChange={e => setFormName(e.target.value)} />
      </div>
      <div className="form-row-2">
        <div className="form-row">
          <label>Hex Code</label>
          <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
            <input type="text" value={formHex} onChange={e => setFormHex(e.target.value)} placeholder="#FF5733" style={{ flex: 1 }} />
            {formHex && <span className="color-swatch color-swatch-lg" style={{ background: formHex }} />}
          </div>
        </div>
        <div className="form-row">
          <label>Sort Order</label>
          <input type="number" value={formSort} onChange={e => setFormSort(e.target.value)} />
        </div>
      </div>
    </Modal>
  )

  return (
    <div className="page">
      <div className="page-header">
        <h1 className="page-title">Colors{colors && <span className="page-count">({colors.length})</span>}</h1>
        <button className="btn btn-primary" onClick={openCreate}>+ Add Color</button>
      </div>

      {isLoading ? (
        <div className="card-grid">
          {Array.from({ length: 12 }).map((_, i) => (
            <div key={i} className="color-card">
              <div className="skeleton color-swatch-lg" style={{ borderRadius: '50%', width: 32, height: 32 }} />
              <div className="skeleton" style={{ width: '60%', height: 14 }} />
            </div>
          ))}
        </div>
      ) : (
        <div className="card-grid">
          {colors?.map(color => (
            <div key={color.id} className="color-card" onClick={() => openEdit(color)}>
              <span
                className="color-swatch color-swatch-lg"
                style={{ background: color.hex_code || '#ddd' }}
              />
              <div className="color-card-name">{color.name}</div>
              <div className="color-card-meta">
                {color.variety_color_categories?.[0]?.count ?? 0} varieties
                {color.sort_order != null && ` · #${color.sort_order}`}
              </div>
              <button
                className="btn-ghost btn-sm"
                onClick={e => { e.stopPropagation(); setDeleteColor(color) }}
                style={{ marginTop: 4 }}
              >
                Delete
              </button>
            </div>
          ))}
        </div>
      )}
      {formModal}
      {deleteColor && (
        <Modal title="Delete Color" onClose={() => setDeleteColor(null)} footer={
          <><button className="btn btn-secondary" onClick={() => setDeleteColor(null)}>Cancel</button>
          <button className="btn btn-danger" onClick={handleDelete}>Delete</button></>
        }>
          <div className="confirm-body">
            <p>Delete color</p>
            <p className="confirm-name">{deleteColor.name}</p>
            {(deleteColor.variety_color_categories?.[0]?.count ?? 0) > 0 && (
              <p style={{ fontSize: '.82rem', color: 'var(--amber)', marginTop: 8 }}>
                ⚠️ Used by {deleteColor.variety_color_categories[0].count} varieties
              </p>
            )}
          </div>
        </Modal>
      )}
    </div>
  )
}
