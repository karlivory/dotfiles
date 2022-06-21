local M = {}

-- local merge_tb = vim.tbl_deep_extend

M.load_mappings = function(mappings, mapping_opt)
    -- set mapping function with/without whichkey
    local map_func
    local whichkey_exists, wk = pcall(require, "which-key")

    if whichkey_exists then
        map_func = function(keybind, mapping_info, opts)
            wk.register({ [keybind] = mapping_info }, opts)
        end
    else
        map_func = function(keybind, mapping_info, opts)
            local mode = opts.mode
            opts.mode = nil
            vim.keymap.set(mode, keybind, mapping_info[1], opts)
        end
    end

    mappings = mappings or require "nvim.core.mappings"

    for _, section_mappings in pairs(mappings) do
        for mode, mode_mappings in pairs(section_mappings) do
            local opts = {}
            opts.mode = mode
            for keybind, mapping_info in pairs(mode_mappings) do
                map_func(keybind, mapping_info, opts)
            end
        end
    end
end

-- load plugin after entering vim ui
M.packer_lazy_load = function(plugin)
    vim.defer_fn(function()
        require("packer").loader(plugin)
    end, 0)
end

return M
