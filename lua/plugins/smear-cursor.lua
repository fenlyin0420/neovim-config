-- 指针动画配置 - 流行风格：平滑拖尾 + 粒子效果
return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  opts = {
    -- 跨 buffer/window 拖尾动画
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,
    scroll_buffer_space = true,

    -- 插入模式拖尾
    smear_insert_mode = true,

    -- 核心动画参数（变形效果：低刚度 + 适度回弹）
    stiffness = 0.5,
    trailing_stiffness = 0.5,
    stiffness_insert_mode = 0.5,
    trailing_stiffness_insert_mode = 0.5,
    damping = 0.85,
    damping_insert_mode = 0.9,
    distance_stop_animating = 0.1,
    matrix_pixel_threshold = 0.3,
    time_interval = 17,

    -- 光标颜色
    cursor_color = "#f4dbd6",

    -- 关闭粒子，只保留变形效果
    particles_enabled = false,

    -- 透明背景优化
    legacy_computing_symbols_support = false,
    transparent_bg_fallback_color = "#24273a",

    -- 避免双光标
    hide_target_hack = false,
    never_draw_over_target = false,
  },
}
