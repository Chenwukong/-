shader_type canvas_item;

uniform float heat_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float heat_wave_speed : hint_range(0.0, 10.0) = 2.0;
uniform float heat_wave_scale : hint_range(0.0, 0.5) = 0.05;
uniform vec4 heat_color : source_color = vec4(1.0, 0.6, 0.2, 0.3);
void fragment() {
    // 创建热浪扭曲效果
    vec2 distorted_uv = UV;
    distorted_uv.y += sin(UV.x * 1.0 + TIME * heat_wave_speed) * heat_wave_scale;
    distorted_uv.x += cos(UV.y * 1.0 + TIME * heat_wave_speed) * heat_wave_scale;
    
    // 采样纹理
    vec4 original_color = texture(TEXTURE, distorted_uv);
    
    // 热色叠加
    vec4 final_color = mix(
        original_color, 
        original_color * heat_color, 
        heat_intensity
    );
    
    // 热浪波动效果
    float heat_wave = sin(UV.y * 10.0 + TIME * 3.0) * 0.5 + 0.5;
    final_color.rgb += heat_wave * heat_color.rgb * heat_intensity * 0.2;
    
    COLOR = final_color;
}