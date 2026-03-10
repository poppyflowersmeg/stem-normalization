import { useState } from 'react'
import { useVendors, useCreateVendor, useUpdateVendor, useDeleteVendor, useCreateVendorLocation, useDeleteVendorLocation } from '../hooks/useVendors'
import { Modal } from '../components/Modal'
import { useToast } from '../components/Toast'
import type { VendorWithRelations } from '../lib/types'

export function Vendors() {
  const { data: vendors, isLoading } = useVendors()
  const create = useCreateVendor()
  const update = useUpdateVendor()
  const del = useDeleteVendor()
  const createLoc = useCreateVendorLocation()
  const deleteLoc = useDeleteVendorLocation()
  const { showToast } = useToast()

  const [editVendor, setEditVendor] = useState<VendorWithRelations | null>(null)
  const [showCreate, setShowCreate] = useState(false)
  const [deleteVendor, setDeleteVendor] = useState<VendorWithRelations | null>(null)

  const [formName, setFormName] = useState('')
  const [formType, setFormType] = useState<'farm' | 'wholesaler'>('farm')
  const [formNotes, setFormNotes] = useState('')
  const [newLocation, setNewLocation] = useState('')

  function openCreate() {
    setFormName(''); setFormType('farm'); setFormNotes('')
    setShowCreate(true)
  }

  function openEdit(v: VendorWithRelations) {
    setFormName(v.name)
    setFormType(v.vendor_type)
    setFormNotes(v.notes || '')
    setEditVendor(v)
  }

  async function handleSave() {
    const payload = { name: formName, vendor_type: formType, notes: formNotes || null }
    try {
      if (editVendor) {
        await update.mutateAsync({ id: editVendor.id, ...payload })
        showToast('Vendor updated')
        setEditVendor(null)
      } else {
        await create.mutateAsync(payload)
        showToast('Vendor created')
        setShowCreate(false)
      }
    } catch (e: any) {
      showToast(`Error: ${e.message}`)
    }
  }

  async function handleDelete() {
    if (!deleteVendor) return
    try {
      await del.mutateAsync(deleteVendor.id)
      showToast('Vendor deleted')
      setDeleteVendor(null)
    } catch (e: any) {
      showToast(`Error: ${e.message}`)
    }
  }

  async function addLocation(vendorId: number) {
    if (!newLocation.trim()) return
    try {
      await createLoc.mutateAsync({ vendor_id: vendorId, location_name: newLocation.trim() })
      setNewLocation('')
      showToast('Location added')
    } catch (e: any) {
      showToast(`Error: ${e.message}`)
    }
  }

  async function removeLocation(locId: number) {
    try {
      await deleteLoc.mutateAsync(locId)
      showToast('Location removed')
    } catch (e: any) {
      showToast(`Error: ${e.message}`)
    }
  }

  const formModal = (showCreate || editVendor) && (
    <Modal
      title={editVendor ? 'Edit Vendor' : 'New Vendor'}
      onClose={() => { setShowCreate(false); setEditVendor(null) }}
      footer={
        <>
          <button className="btn btn-secondary" onClick={() => { setShowCreate(false); setEditVendor(null) }}>Cancel</button>
          <button className="btn btn-primary" onClick={handleSave} disabled={!formName}>{editVendor ? 'Save' : 'Create'}</button>
        </>
      }
    >
      <div className="form-row">
        <label>Vendor Name</label>
        <input type="text" value={formName} onChange={e => setFormName(e.target.value)} />
      </div>
      <div className="form-row">
        <label>Type</label>
        <div style={{ display: 'flex', gap: 8 }}>
          <div
            className={`type-radio ${formType === 'farm' ? 'selected' : ''}`}
            style={{
              flex: 1, border: `1.5px solid ${formType === 'farm' ? 'var(--stem)' : 'var(--border)'}`,
              borderRadius: 8, padding: '7px 10px', textAlign: 'center', cursor: 'pointer',
              fontWeight: 600, fontSize: '.83rem',
              color: formType === 'farm' ? 'var(--stem)' : 'var(--muted)',
              background: formType === 'farm' ? 'var(--stem-pale)' : 'transparent'
            }}
            onClick={() => setFormType('farm')}
          >
            🌱 Farm
          </div>
          <div
            style={{
              flex: 1, border: `1.5px solid ${formType === 'wholesaler' ? 'var(--poppy)' : 'var(--border)'}`,
              borderRadius: 8, padding: '7px 10px', textAlign: 'center', cursor: 'pointer',
              fontWeight: 600, fontSize: '.83rem',
              color: formType === 'wholesaler' ? 'var(--poppy)' : 'var(--muted)',
              background: formType === 'wholesaler' ? 'var(--poppy-pale)' : 'transparent'
            }}
            onClick={() => setFormType('wholesaler')}
          >
            🏬 Wholesaler
          </div>
        </div>
      </div>
      <div className="form-row">
        <label>Notes</label>
        <textarea value={formNotes} onChange={e => setFormNotes(e.target.value)} placeholder="Optional notes..." />
      </div>

      {editVendor && (
        <div style={{ marginTop: 18, paddingTop: 14, borderTop: '1px solid var(--border)' }}>
          <label>Locations</label>
          <div className="chip-list" style={{ marginBottom: 8 }}>
            {editVendor.vendor_locations?.map(loc => (
              <span key={loc.id} className="chip">
                {loc.location_name}
                <span className="chip-remove" onClick={() => removeLocation(loc.id)}>x</span>
              </span>
            ))}
          </div>
          <div style={{ display: 'flex', gap: 6 }}>
            <input type="text" value={newLocation} onChange={e => setNewLocation(e.target.value)}
              placeholder="Add location..." style={{ flex: 1 }}
              onKeyDown={e => e.key === 'Enter' && addLocation(editVendor.id)}
            />
            <button className="btn btn-secondary btn-sm" onClick={() => addLocation(editVendor.id)}>Add</button>
          </div>
        </div>
      )}
    </Modal>
  )

  return (
    <div className="page">
      <div className="page-header">
        <h1 className="page-title">Vendors{vendors && <span className="page-count">({vendors.length})</span>}</h1>
        <button className="btn btn-primary" onClick={openCreate}>+ Add Vendor</button>
      </div>
      <div className="table-wrap">
        <div className="table-scroll">
          <table className="data-table">
            <thead>
              <tr>
                <th>Name</th>
                <th>Type</th>
                <th>Locations</th>
                <th>Products</th>
                <th>Notes</th>
                <th style={{ width: 80 }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {isLoading ? (
                Array.from({ length: 4 }).map((_, i) => (
                  <tr key={i}>{Array.from({ length: 6 }).map((_, j) => <td key={j}><div className="skeleton" style={{ width: '60%' }} /></td>)}</tr>
                ))
              ) : vendors?.length === 0 ? (
                <tr><td colSpan={6}><div className="empty-state"><p>🏢</p><p>No vendors</p></div></td></tr>
              ) : vendors?.map(v => (
                <tr key={v.id}>
                  <td style={{ fontWeight: 600 }}>{v.name}</td>
                  <td><span className={`badge badge-${v.vendor_type}`}>{v.vendor_type}</span></td>
                  <td>
                    <div className="chip-list">
                      {v.vendor_locations?.map(loc => <span key={loc.id} className="chip">{loc.location_name}</span>)}
                    </div>
                  </td>
                  <td>{v.vendor_offerings?.[0]?.count ?? 0}</td>
                  <td style={{ color: 'var(--muted)', fontStyle: 'italic', fontSize: '.82rem', maxWidth: 200, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                    {v.notes || '—'}
                  </td>
                  <td>
                    <div className="actions-cell">
                      <button className="btn-icon" title="Edit" onClick={() => openEdit(v)}>✏️</button>
                      <button className="btn-icon" title="Delete" onClick={() => setDeleteVendor(v)}>🗑️</button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
      {formModal}
      {deleteVendor && (
        <Modal title="Delete Vendor" onClose={() => setDeleteVendor(null)} footer={
          <><button className="btn btn-secondary" onClick={() => setDeleteVendor(null)}>Cancel</button>
          <button className="btn btn-danger" onClick={handleDelete}>Delete</button></>
        }>
          <div className="confirm-body">
            <p>Delete vendor</p>
            <p className="confirm-name">{deleteVendor.name}</p>
            {(deleteVendor.vendor_offerings?.[0]?.count ?? 0) > 0 && (
              <p style={{ fontSize: '.82rem', color: 'var(--amber)', marginTop: 8 }}>
                Has {deleteVendor.vendor_offerings[0].count} products
              </p>
            )}
          </div>
        </Modal>
      )}
    </div>
  )
}
