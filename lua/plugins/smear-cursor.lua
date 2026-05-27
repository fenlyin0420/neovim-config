-- 指针动画配置
return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  opts = {
    -- 核心动画参数
    stiffness = 0.5,         -- 光标“硬度”，越小越软、拖尾越长
    trailing_stiffness = 0.5,-- 拖尾硬度
    distance_stop_animating = 0.5, -- 移动小于0.5字符时不动画
    matrix_pixel_threshold = 0.5,
    time_interval = 17,       -- 动画帧率（ms，默认17≈60fps）
  },
}
