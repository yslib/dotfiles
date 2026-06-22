-- ~/.config/nvim/nvim-memos.lua
return {
    {
        title = "查看当前 buffer 的 filetype",
        cmd = ":set filetype?",
        tags = { "buffer", "filetype" },
        desc = "忘记某个文件当前被识别成什么 filetype 时用。",
    },
    {
        title = "查看某个快捷键绑定到了什么",
        cmd = ":verbose nmap <leader>ff",
        tags = { "keymap", "debug" },
        desc = "verbose 可以显示这个 mapping 是在哪里定义的。",
    },
    {
        title = "查看某个 option 是在哪里设置的",
        cmd = ":verbose set tabstop?",
        tags = { "option", "debug" },
        desc = "排查配置被覆盖时很好用。",
    },
    {
        title = "查看 runtimepath",
        cmd = ":set runtimepath?",
        tags = { "runtime", "plugin" },
        desc = "排查插件加载路径、after 目录、ftplugin 等问题。",
    },
    {
        title = "如何使用原生的quickfix list",
        cmd = "",
        tags = { "quickfix", "native" },
        desc = [[
      设置编译器 :compiler gcc
      输出编译信息到文件：> output.txt 2>&1
      用:cfile output.txt 将编译信息加载到 quickfix list 中
      或者用:cbuffer output.txt 将当前 buffer 的内容加载到 quickfix list 中。
      :copen 打开 quickfix list 窗口。]],
    },
    {
        title = "Vim-surround cheatsheet",
        cmd = "",
        tags = { "surround", "native" },
        desc = [[
        ds: 删除 surround
        cs: 修改 surround
        ys: 添加 surround

        [d|c]s[surround], 其中 surround = s, ", ', (, ), {, }, <, >, t{tag}, etc.

        yss[surround]: 在当前行添加 surround

        S: 在 visual 模式下添加 surround

        速查：
        ys[motion][surround]

        ds"       删除双引号
        ds'       删除单引号
        ds)       删除括号
        dst       删除 tag

        cs"'      双引号改单引号
        cs'"      单引号改双引号
        cs)]      圆括号改方括号
        cst"      tag 改双引号
        cs"<div>  双引号改 div tag

        ysiw"     当前 word 加双引号
        ysiw)     当前 word 加圆括号
        ysiw]     当前 word 加方括号
        ysiw}     当前 word 加花括号
        ysiw<tag> 当前 word 加 tag

        yss"      当前整行加双引号
        yss)      当前整行加圆括号

        Visual 选中后 S"      给选区加双引号
        Visual 选中后 S)      给选区加圆括号
        Visual 选中后 S<tag>  给选区加 tag
      ]],
    }
}
