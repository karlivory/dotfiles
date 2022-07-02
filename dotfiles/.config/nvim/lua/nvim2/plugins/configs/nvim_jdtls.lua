--[[
 ╔══════════════════════════════════════╗
 ║ Settings for mfussenegger/nvim-jdtls ║
 ╚══════════════════════════════════════╝
--]]
local M = {}

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local home = os.getenv "HOME"
local workspace_folder = home .. "/.local/share/jdtls_workspaces/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local lsp_installer = require "nvim-lsp-installer"
local ok, jdtls = lsp_installer.get_server "jdtls"

if ok == false then
  vim.notify("lsp_installer: jdtls not found, please install it first", vim.log.levels.ERROR)
  return
end

local function get_capabilities()
  -- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
  -- Add additional capabilities supported by nvim-cmp
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- turn on `window/workDoneProgress` capability
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  return capabilities
end

local function on_attach(client, bufnr)
  print("attach")
  require("jdtls.dap")
  require("jdtls").setup_dap({ hotcodereplace = "auto" })
  require("jdtls.setup").add_commands()
  require("jdtls.dap").setup_dap_main_class_configs()
  require'jdtls'.setup_dap()
  require'lsp-status'.register_progress()
  -- lsp_utils.on_attach(client, bufnr)

  -- TEMPORARY PLACE FOR THESE --------------------------------------------------
  -- array of mappings to setup; {<capability_name>, <mode>, <lhs>, <rhs>}
  local key_mappings = {
    {"document_range_formatting", "v", "<Space>f", "<Esc><Cmd>lua vim.lsp.buf.range_formatting()<CR>"},
    {"signature_help", "i", "<c-space>",  "<Cmd>lua vim.lsp.buf.signature_help()<CR>"},
  }

  local api = vim.api
  local opts = { silent = true; noremap = true; }

  for _, mappings in pairs(key_mappings) do
    local capability, mode, lhs, rhs = unpack(mappings)
    if client.resolved_capabilities[capability] then
      api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end
  end
  --------------------------------------------------------------------------------
end

local config = {
  cmd = {
    '/usr/lib/jvm/java-11-openjdk-amd64/bin/java',
    '-javaagent:/home/karl/.local/ls/java/lombok.jar',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '-Xmx2g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', '/home/karl/.local/ls/java/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
    '-configuration', '/home/karl/.local/ls/java/jdtls/config_linux',
    '-data', home .. "/.local/share/jdtls_workspaces/" .. vim.fn.fnamemodify(jdtls:get_default_options().root_dir, ":p:h:t")
  },
  init_options = {
    bundles = {
      vim.fn.expand(home .. "/.local/ls/java/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar")
    },
  },
  settings = {
    java = {
      format = {
        comments = {
          enabled = false,
        },
        settings = {
          url = "https://gist.githubusercontent.com/ikws4/7880fdcb4e3bf4a38999a628d287b1ab/raw/9005c451ed1ff629679d6100e22d63acc805e170/jdtls-formatter-style.xml",
        },
      },
    },
  },
  capabilities = get_capabilities(),
  flags = {
    allow_incremental_sync = true,
    debounce_text_changes = 150,
    server_side_fuzzy_completion = true
  },
  on_attach = on_attach,
  root_dir = jdtls:get_default_options().root_dir
}
function M.setup()
  local ok, dap = pcall(require, "nvim.plugins.configs.nvim_dap")
  local ok, dapui = pcall(require, "nvim.plugins.configs.nvim_dap_ui")
  local ok, jdtls = pcall(require, "jdtls")

  local finders = require'telescope.finders'
  local sorters = require'telescope.sorters'
  local actions = require'telescope.actions'
  local pickers = require'telescope.pickers'
  require('jdtls.ui').pick_one_async = function(items, prompt, label_fn, cb)
    local opts = {}
    pickers.new(opts, {
      prompt_title = prompt,
      finder    = finders.new_table {
        results = items,
        entry_maker = function(entry)
          return {
            value = entry,
            display = label_fn(entry),
            ordinal = label_fn(entry),
          }
        end,
      },
      sorter = sorters.get_generic_fuzzy_sorter(),
      attach_mappings = function(prompt_bufnr)
        actions.goto_file_selection_edit:replace(function()
          local selection = actions.get_selected_entry(prompt_bufnr)
          actions.close(prompt_bufnr)

          cb(selection.value)
        end)

        return true
      end,
    }):find()
  end

  jdtls.start_or_attach(config)
end

-- Organize import on save
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*.java",
--   callback = function()
--     local params = vim.lsp.util.make_range_params()
--     local bufnr = vim.api.nvim_get_current_buf()
--     params.context = {
--       diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr),
--     }
--     local result, err = vim.lsp.buf_request_sync(0, "java/organizeImports", params)
--
--     if err then
--       print("Error on organize imports: " .. err)
--       return
--     end
--
--     if result and result[1].result then
--       vim.lsp.util.apply_workspace_edit(result[1].result, "utf-16")
--     end
--   end,
-- })

print("D")
return M
