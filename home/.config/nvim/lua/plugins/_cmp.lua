return {}

-- local cmp = require('cmp')
-- return {
--   "hrsh7th/nvim-cmp",
--   -- intellij-like completion
--   opts = {
--     preselect = cmp.PreselectMode.Item,
--     mapping = {
--       -- retrain muscle memory: type <Tab> instead...
--       ["<CR>"] = cmp.config.disable,
--       -- ["<CR>"] = cmp.mapping.confirm {
--       --   behavior = cmp.ConfirmBehavior.Replace,
--       --   select = false
--       -- },
--       ["<Up>"] = cmp.config.disable,
--       ["<Down>"] = cmp.config.disable,
--       ["<C-p>"] = cmp.config.disable,
--       ["<C-n>"] = cmp.config.disable,
--       ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
--       ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
--       ["<Tab>"] = cmp.mapping(function(fallback)
--         if cmp.visible() then
--           local entry = cmp.get_selected_entry()
--           if not entry then
--             cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
--           else
--             cmp.confirm({
--               behavior = cmp.ConfirmBehavior.Replace,
--             })
--           end
--         else
--           fallback()
--         end
--       end, { "i", "s", }),
--     }
--   }
-- }
