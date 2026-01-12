local M = {}

function M.map_key(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.send_to_tcp_server(ip, port, msg)
    local uv = vim.uv
    local client = uv.new_tcp()

    if client then
        client:connect(ip, port, function(err)
            if err then
                print("connect failed: ", err)
                client:close()
                return
            end
            client:write(msg, function(err)
                if err then
                    print("write error: ", err)
                    client:close()
                else
                    -- 2. 关键步骤：发送 Shutdown (FIN)
                    -- 这告诉 Rust 的 read_to_string "由于 EOF，读取结束"
                    -- 但不会产生 RST 错误
                    client:shutdown(function()
                        -- 3. 确认对方收到 FIN 后，再关闭句柄
                        client:close()
                        vim.schedule(function()
                        end)
                    end)
                end
            end)
        end)
    end
end

function M.get_visual_selection()
    local mode = vim.fn.mode()
    if mode == 'v' or mode == 'V' or mode == '\22' then -- \22 是 CTRL-V
        vim.cmd('normal! \27')                          -- 发送 ESC，退出 Visual 模式，更新 '< 和 '> 标记
    end

    local save_reg = vim.fn.getreg('"')
    local save_regtype = vim.fn.getregtype('"')

    -- 3. 重新选中上一次的选区，并“复制”到未命名寄存器
    -- gv: 重新选中上一次选区
    -- y: 复制
    vim.cmd('normal! gvy')

    -- 4. 从寄存器获取内容
    local selection = vim.fn.getreg('"')

    -- 5. restore reg
    vim.fn.setreg('"', save_reg, save_regtype)

    return selection
end

function M.send_buffer_to(ip, port)
    local mode = vim.api.nvim_get_mode().mode
    local text = "";
    if mode == 'v' or mode == 'V' or mode == '\22' then -- \22 是 CTRL-V
        text = get_visual_selection()
    else
        -- not in visual mode, send the whole buffer
        local all_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        text = table.concat(all_lines, "\n")
    end
    -- vim.notify("Sending to:\n" .. text, vim.log.levels.INFO, { title = "Send" })
    M.send_to_tcp_server(ip, port, text)
end

-- enable copy paste from nvim by ssh connection
vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
        ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
        ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
}

return M
