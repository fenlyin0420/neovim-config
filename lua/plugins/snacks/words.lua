-- 高亮同一变量配置
return {
    enabled = true,
    debounce = 200,                    -- time in ms to wait before updating
    notify_jump = false,               -- show a notification when jumping
    notify_end = true,                 -- show a notification when reaching the end
    foldopen = true,                   -- open folds after jumping
    jumplist = true,                   -- set jump point before jumping
    modes = { "n", "i", "c" },         -- modes to show references
    keys = {
        ["[w"] = "prev",
        ["]w"] = "next",
    },
    filter = function(buf)         -- what buffers to enable `snacks.words`
        return vim.g.snacks_words ~= false and vim.b[buf].snacks_words ~= false
    end,
}
