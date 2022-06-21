local M = {}

function M.on_filetype_open(filetype, callback)
    vim.api.nvim_create_autocmd('FileType', {
        pattern = filetype,
        callback = function()
            vim.schedule(function()
                callback()
            end)
        end,
        once = true,
    })
end

return M
