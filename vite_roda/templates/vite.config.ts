import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
export default defineConfig({
  plugins: [
    RubyPlugin(),
  ],
  /* Restore Vite defaults */
  build: {
    emptyOutDir: true,
    sourcemap: false,                                                              }
})
