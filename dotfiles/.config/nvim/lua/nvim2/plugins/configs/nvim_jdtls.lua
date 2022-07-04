local M = {}

local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local actions = require('telescope.actions')
local pickers = require('telescope.pickers')
local action_state = require('telescope.actions.state')
local jdtls = require('jdtls')
local home = vim.env.HOME
local root_dir = require('jdtls.setup').find_root({ 'gradlew', 'mvnw' })

local function on_attach(client, bufnr)
  require("jdtls.setup").add_commands()
  require("jdtls.dap").setup_dap_main_class_configs()
  jdtls.setup_dap({ hotcodereplace = "auto" })
  require'lsp-status'.register_progress()
end

local config = {
  handlers = {
    ["language/progressReport"] = require("nvim2.utils").lsp_progress_report_handler,
    ['language/status'] = function() end,
  },
  cmd = {
    '/usr/lib/jvm/java-11-openjdk-amd64/bin/java',
    '-javaagent:' .. home .. '/.local/ls/java/lombok.jar',
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
    '-jar', home .. '/.local/ls/java/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
    '-configuration', home .. '/.local/ls/java/jdtls/config_linux',
    '-data', home .. "/.local/share/jdtls_workspaces/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
  },
  capabilities = {
    workspace = {
      configuration = true
    },
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true
        }
      }
    }
  },
  flags = {
    allow_incremental_sync = true,
    debounce_text_changes = 150,
    server_side_fuzzy_completion = true
  },
  on_attach = on_attach,
  root_dir = root_dir
}

config.settings = {
  java = {
    signatureHelp = { enabled = true };
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*"
      }
    };
    sources = {
      organizeImports = {
        starThreshold = 9999;
        staticStarThreshold = 9999;
      };
    };
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
      }
    };
    configuration = {
      runtimes = {
        {
          name = "JavaSE-11",
          path = "/usr/lib/jvm/java-1.11.0-openjdk-amd64/"
        },
        {
          name = "JavaSE-17",
          path = "/usr/lib/jvm/java-1.17.0-openjdk-amd64/"
        },
      }
    }
  }
}

local extendedClientCapabilities = require'jdtls'.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
config.init_options = {
    bundles = {
      vim.fn.expand(home .. "/.local/ls/java/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar")
    },
    extendedClientCapabilities = extendedClientCapabilities
}

M.setup = function()
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
      attach_mappings = function(prompt_bufnr, map)
        map('i', '<esc>', function()
          actions.close(prompt_bufnr)
        end)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          print(vim.inspect(selection.value.name))
          actions.close(prompt_bufnr)
          cb(selection.value)
        end)

        return true
      end,
    }):find()
  end

  jdtls.start_or_attach(config)
end

return M

