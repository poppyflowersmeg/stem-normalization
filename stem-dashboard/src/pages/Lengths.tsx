import { useState } from 'react'
import { useLengths, useCreateLength, useDeleteLength } from '../hooks/useLengths'
import { Modal } from '../components/Modal'
import { useToast } from '../components/Toast'
import type { LengthWithCount } from '../lib/types'

export function Lengths() {
  const { data: lengths, isLoading } = useLengths()
  const create = useCreateLength()
  const del = useDeleteLength()
  const { showToast } = useToast()

  const [showCreate, setShowCreate] = useState(false)
  const [deleteLength, setDeleteLength] = useState<LengthWithCount | null>(null)
  const [formCm, setFormCm] = useState('')

  async function handleCreate() {
    try {
      await create.mutateAsync({ cm: Number(formCm) })
      showToast('Length added')
      setShowCreate(false)
      setFormCm('')
    } catch (e: any) {
      showToast(`Error: ${e.message}`)
    }
  }

  async function handleDelete() {
    if (!deleteLength) return
    try {
      await del.mutateAsync(deleteLength.id)
      showToast('Length deleted')
      setDeleteLength(null)
    } catch (e: any) {
      showToast(`Error: ${e.message}`)
    }
  }

  return (
    <div className="page">
      <div className="page-header">
        <h1 className="page-title">Lengths{lengths && <span className="page-count">({lengths.length})</span>}</h1>
        <button className="btn btn-primary" onClick={() => { setFormCm(''); setShowCreate(true) }}>+ Add Length</button>
      </div>

      <div className="table-wrap">
        <div className="table-scroll">
          <table className="data-table">
            <thead>
              <tr>
                <th>Length (cm)</th>
                <th>Stems Using</th>
                <th style={{ width: 80 }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {isLoading ? (
                Array.from({ length: 4 }).map((_, i) => (
                  <tr key={i}>{Array.from({ length: 3 }).map((_, j) => <td key={j}><div className="skeleton" style={{ width: '50%' }} /></td>)}</tr>
                ))
              ) : lengths?.length === 0 ? (
                <tr><td colSpan={3}><div className="empty-state"><p>📏</p><p>No lengths defined</p></div></td></tr>
              ) : lengths?.map(l => (
                <tr key={l.id}>
                  <td style={{ fontWeight: 600, fontSize: '1rem' }}>{l.cm} cm</td>
                  <td>{l.stem_lengths?.[0]?.count ?? 0}</td>
                  <td>
                    <button className="btn-icon" title="Delete" onClick={() => setDeleteLength(l)}>🗑️</button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {showCreate && (
        <Modal title="Add Length" onClose={() => setShowCreate(false)} footer={
          <><button className="btn btn-secondary" onClick={() => setShowCreate(false)}>Cancel</button>
          <button className="btn btn-primary" onClick={handleCreate} disabled={!formCm}>Add</button></>
        }>
          <div className="form-row">
            <label>Length in cm</label>
            <input type="number" value={formCm} onChange={e => setFormCm(e.target.value)} placeholder="e.g. 60" />
          </div>
        </Modal>
      )}

      {deleteLength && (
        <Modal title="Delete Length" onClose={() => setDeleteLength(null)} footer={
          <><button className="btn btn-secondary" onClick={() => setDeleteLength(null)}>Cancel</button>
          <button className="btn btn-danger" onClick={handleDelete}>Delete</button></>
        }>
          <div className="confirm-body">
            <p>Delete length</p>
            <p className="confirm-name">{deleteLength.cm} cm</p>
          </div>
        </Modal>
      )}
    </div>
  )
}
