import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import { fileURLToPath } from 'node:url'
import { dirname, join } from 'node:path'
import { readFileSync } from 'node:fs'

const __dirname = dirname(fileURLToPath(import.meta.url))

export default defineConfig({
  plugins: [react()],
  base: '/portal-backoffice/',
  build: {
    outDir: join(__dirname, 'dist'),
    emptyOutDir: true,
    manifest: true,
    assetsInlineLimit: 0,
    rollupOptions: {
      output: {
        entryFileNames: 'assets/js/[name].[hash].js',
        chunkFileNames: 'assets/js/[name].[hash].js',
        assetFileNames: 'assets/[ext]/[name].[hash].[ext]'
      }
    }
  },
  server: {
    https: {
      key: readFileSync(join(__dirname, 'localhost-key.pem')),
      cert: readFileSync(join(__dirname, 'localhost.pem'))
    },
    host: 'localhost',
    port: 3000,
    strictPort: true,
    open: true
  }
})