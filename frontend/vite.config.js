import { fileURLToPath, URL } from "node:url";
import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";

export default defineConfig(({ command }) => {
  const isProduction = command === 'build';
  
  return {
    base: "/tiei_dynamic/",
    plugins: [vue()],
    server: {
      host: '0.0.0.0',
      proxy: {
        '/api/v1': {
          target: 'https://maintenance.cmti.online',
          changeOrigin: true,
          secure: true,
          rewrite: (path) => path
        }
      }
    },
    resolve: {
      alias: {
        "@": fileURLToPath(new URL("./src", import.meta.url)),
      },
    },
    css: {
      preprocessorOptions: {
        less: {
          javascriptEnabled: true,
        },
      },
    },
    define: {
      __VUE_PROD_DEVTOOLS__: !isProduction,
      'process.env.NODE_ENV': JSON.stringify(isProduction ? 'production' : 'development')
    }
  };
});