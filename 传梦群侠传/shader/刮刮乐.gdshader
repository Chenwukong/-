shader_type canvas_item;

uniform sampler2D mask_texture;

void fragment() {
    // 获取ColorRect的原始颜色（应该是黑色）
    vec4 base_color = COLOR;
    
    // 获取mask纹理
    vec4 mask = texture(mask_texture, UV);
    
    // mask的红色通道控制透明度
    // mask为黑色(0)时：base_color.a *= (1.0 - 0) = 1.0 (不透明)
    // mask为白色(1)时：base_color.a *= (1.0 - 1) = 0.0 (透明)
    base_color.a *= (1.0 - mask.r);
    
    COLOR = base_color;
}