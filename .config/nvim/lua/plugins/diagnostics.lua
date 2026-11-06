-- Diagnósticos legibles: mensaje completo bajo la línea del cursor
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        -- quitar el texto a la derecha (se cortaba en el borde de la ventana)
        virtual_text = false,
        -- mostrar el mensaje completo DEBAJO de la línea actual,
        -- empezando en la columna 0 → todo el ancho de ventana para leerlo
        virtual_lines = { only_current_line = true },
        -- ventana flotante de <leader>cd legible también con mensajes largos
        float = {
          border = "rounded",
          wrap = true,
          max_width = 100,
          source = "if_many",
          focusable = true,
        },
      },
    },
  },
}
