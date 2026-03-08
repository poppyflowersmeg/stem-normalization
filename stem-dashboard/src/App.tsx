import { BrowserRouter, Routes, Route } from 'react-router-dom'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { ToastProvider } from './components/Toast'
import { Layout } from './components/Layout'
import { ProductItems } from './pages/ProductItems'
import { Stems } from './pages/Stems'
import { Colors } from './pages/Colors'
import { Varieties } from './pages/Varieties'
import { Lengths } from './pages/Lengths'
import { Vendors } from './pages/Vendors'

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 30_000,
      retry: 1,
    },
  },
})

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <ToastProvider>
        <BrowserRouter>
          <Routes>
            <Route element={<Layout />}>
              <Route path="/" element={<ProductItems />} />
              <Route path="/stems" element={<Stems />} />
              <Route path="/colors" element={<Colors />} />
              <Route path="/varieties" element={<Varieties />} />
              <Route path="/lengths" element={<Lengths />} />
              <Route path="/vendors" element={<Vendors />} />
            </Route>
          </Routes>
        </BrowserRouter>
      </ToastProvider>
    </QueryClientProvider>
  )
}

export default App
