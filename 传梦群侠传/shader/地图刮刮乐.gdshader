shader_type canvas_item;

// 导出参数以便在编辑器中调整
uniform vec2 wipe_center;
uniform float wipe_radius = 0.05;
uniform sampler2D background_texture;

void fragment() {
    // 获取当前UV坐标
    vec2 uv = UV;
    
    // 计算与刮除中心的距离
    float dist = distance(uv, wipe_center);
    
    // 计算刮除因子（圆形区域）
    float wipe_factor = 1.0 - smoothstep(wipe_radius - 0.01, wipe_radius + 0.01, dist);
    
    // 获取覆盖层颜色
    vec4 overlay_color = texture(TEXTURE, uv);
    
    // 获取背景颜色
    vec4 bg_color = texture(background_texture, uv);
    
    // 混合颜色
    COLOR = mix(overlay_color, bg_color, wipe_factor);
}