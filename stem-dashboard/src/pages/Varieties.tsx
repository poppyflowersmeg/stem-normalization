import { useState, useMemo } from 'react'
import { useVarieties, useCreateVariety, useUpdateVariety, useDeleteVariety } from '../hooks/useVarieties'
import { Modal } from '../components/Modal'
import { useToast } from '../components/Toast'
import type { VarietyWithStems } from '../lib/types'

export function Varieties() {
  const { data: varieties, isLoading } = useVarieties()
  const create = useCreateVariety()
  const update = useUpdateVariety()
  const del = useDeleteVariety()
  const { showToast } = useToast()

  const [search, setSearch] = useState('')
  const [editVariety, setEditVariety] = useState<VarietyWithStems | null>(null)
  const [showCreate, setShowCreate] = useState(false)
  const [deleteVariety, setDeleteVariety] = useState<VarietyWithStems | null>(null)
  const [formName, setFormName] = useState('')

  const filtered = useMemo(() => {
    if (!varieties) return []
    if (!search) return varieties
    const q = search.toLowerCase()
    return varieties.filter(v => v.name.toLowerCase().includes(q))
  }, [varieties, search])

  function openCreate() { setFormName(''); setShowCreate(true) }
  function openEdit(v: VarietyWithStems) { setFormName(v.name); setEditVariety(v) }

  async function handleSave() {
    try {
      if (editVariety) {
        await update.mutateAsync({ id: editVariety.id, name: formName })
        showToast('Variety updated')
        setEditVariety(null)
      } else {
        await create.mutateAsync({ name: formName })
        showToast('Variety created')
        setShowCreate(false)
      }
    } catch (e: any) {
      showToast(`Error: ${e.message}`)
    }
  }

  async function handleDelete() {
    if (!deleteVariety) return
    try {
      await del.mutateAsync(deleteVariety.id)
      showToast('Variety deleted')
      setDeleteVariety(null)
    } catch (e: any) {
      showToast(`Error: ${e.message}`)
    }
  }

  return (
    <div className="page">
      <div className="page-header">
        <h1 className="page-title">Varieties{varieties && <span className="page-count">({filtered.length})</span>}</h1>
        <button className="btn btn-primary" onClick={openCreate}>+ Add Variety</button>
      </div>
      <div className="toolbar">
        <div className="search-wrap">
          <span className="search-icon">🔍</span>
          <input className="search-input" type="text" placeholder="Search varieties…" value={search} onChange={e => setSearch(e.target.value)} />
        </div>
      </div>
      <div className="table-wrap">
        <div className="table-scroll">
          <table className="data-table">
            <thead>
              <tr>
                <th>Name</th>
                <th>Stems</th>
                <th style={{ width: 80 }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {isLoading ? (
                Array.from({ length: 10 }).map((_, i) => (
                  <tr key={i}>{Array.from({ length: 3 }).map((_, j) => <td key={j}><div className="skeleton" style={{ width: '60%' }} /></td>)}</tr>
                ))
              ) : filtered.length === 0 ? (
                <tr><td colSpan={3}><div className="empty-state"><p>🌹</p><p>No varieties found</p></div></td></tr>
              ) : filtered.slice(0, 200).map(v => (
                <tr key={v.id}>
                  <td style={{ fontWeight: 600 }}>{v.name}</td>
                  <td>
                    <div className="chip-list">
                      {v.stem_varieties?.map(sv => (
                        <span key={sv.id} className="chip">{sv.stems?.stem_category}</span>
                      ))}
                    </div>
                  </td>
                  <td>
                    <div className="actions-cell">
                      <button className="btn-icon" title="Edit" onClick={() => openEdit(v)}>✏️</button>
                      <button className="btn-icon" title="Delete" onClick={() => setDeleteVariety(v)}>🗑️</button>
                    </div>
                  </td>
                </tr>
              ))}
              {filtered.length > 200 && (
                <tr><td colSpan={3} style={{ textAlign: 'center', color: 'var(--muted)', fontSize: '.82rem', padding: 14 }}>
                  Showing 200 of {filtered.length} — use search to filter
                </td></tr>
              )}
            </tbody>
          </table>
        </div>
      </div>

      {(showCreate || editVariety) && (
        <Modal title={editVariety ? 'Edit Variety' : 'New Variety'} onClose={() => { setShowCreate(false); setEditVariety(null) }}
          footer={<>
            <button className="btn btn-secondary" onClick={() => { setShowCreate(false); setEditVariety(null) }}>Cancel</button>
            <button className="btn btn-primary" onClick={handleSave} disabled={!formName}>{editVariety ? 'Save' : 'Create'}</button>
          </>}
        >
          <div className="form-row">
            <label>Variety Name</label>
            <input type="text" value={formName} onChange={e => setFormName(e.target.value)} placeholder="e.g. freedom, vendela, majolica" />
          </div>
        </Modal>
      )}

      {deleteVariety && (
        <Modal title="Delete Variety" onClose={() => setDeleteVariety(null)} footer={
          <><button className="btn btn-secondary" onClick={() => setDeleteVariety(null)}>Cancel</button>
          <button className="btn btn-danger" onClick={handleDelete}>Delete</button></>
        }>
          <div className="confirm-body">
            <p>Delete variety</p>
            <p className="confirm-name">{deleteVariety.name}</p>
          </div>
        </Modal>
      )}
    </div>
  )
}
