return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        local npairs = require("nvim-autopairs")
        npairs.setup({
            check_ts = true,
            map_bs = true, -- 必须开启：退格一键删除成对符号
            enable_moveright = true,
        })

        -- HTML, XML, SVG <> 自动补全
        local Rule = require("nvim-autopairs.rule")
        npairs.add_rules({
            Rule("<", ">", { "html", "htm", "HTML", "xml", "XML", "svg", "SVG"})
                :with_pair(function(opts)
                    local prev = opts.line:sub(opts.col - 1, opts.col - 1)
                    if prev == "=" then return false end -- 不补全属性里的 <
                    return true
                end)
        })

        -- 与 cmp 集成
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp = require("cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end
}
