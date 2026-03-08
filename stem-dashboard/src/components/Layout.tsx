import { NavLink, Outlet } from 'react-router-dom'
import { useState } from 'react'

const navItems = [
  { to: '/', icon: '🌸', label: 'Product Items' },
  { to: '/stems', icon: '🌿', label: 'Stems' },
  { to: '/colors', icon: '🎨', label: 'Colors' },
  { to: '/varieties', icon: '🌹', label: 'Varieties' },
  { to: '/lengths', icon: '📏', label: 'Lengths' },
  { to: '/vendors', icon: '🏢', label: 'Vendors' },
]

export function Layout() {
  const [collapsed, setCollapsed] = useState(false)

  return (
    <div className="app-layout">
      <aside className={`sidebar ${collapsed ? 'collapsed' : ''}`}>
        <div className="sidebar-brand">
          {collapsed ? '🌺' : 'Poppy Stem Manager'}
        </div>
        <nav className="sidebar-nav">
          {navItems.map(item => (
            <NavLink
              key={item.to}
              to={item.to}
              end={item.to === '/'}
              className={({ isActive }) =>
                `sidebar-link ${isActive ? 'active' : ''}`
              }
            >
              <span className="sidebar-link-icon">{item.icon}</span>
              {!collapsed && item.label}
            </NavLink>
          ))}
        </nav>
        <div className="sidebar-toggle">
          <button onClick={() => setCollapsed(!collapsed)}>
            {collapsed ? '▶' : '◀'}
          </button>
        </div>
      </aside>
      <div className="main-area">
        <Outlet />
      </div>
    </div>
  )
}
