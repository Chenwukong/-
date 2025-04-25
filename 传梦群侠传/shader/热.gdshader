shader_type canvas_item;

uniform float heat_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float heat_wave_speed : hint_range(0.0, 10.0) = 5.0;
uniform float heat_wave_scale : hint_range(0.0, 0.5) = 0.1;
uniform vec4 heat_color : source_color = vec4(1.0, 0.6, 0.2, 0.3);

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
    // 创建更明显的热浪扭曲效果
    vec2 distorted_uv = UV;
    
    // 叠加多层热浪扭曲
    distorted_uv.x += sin(UV.y * 30.0 + TIME * heat_wave_speed) * heat_wave_scale 
                    + cos(UV.x * 25.0 + TIME * heat_wave_speed * 0.7) * (heat_wave_scale * 0.5);
    distorted_uv.y += cos(UV.x * 35.0 + TIME * heat_wave_speed) * heat_wave_scale 
                    + sin(UV.y * 20.0 + TIME * heat_wave_speed * 1.3) * (heat_wave_scale * 0.7);
    
    // 热浪波动效果
    float heat_wave = sin(UV.y * 20.0 + TIME * 3.0) * 0.5 + 0.5;
    
    // 添加随机噪声
    float noise = random(distorted_uv + vec2(TIME * 0.1));
    
    // 创建热色
    vec4 final_color = heat_color;
    final_color.rgb += heat_wave * heat_color.rgb * heat_intensity * 0.3;
    final_color.rgb += noise * heat_intensity * 0.1;
    final_color.a *= heat_intensity * (1.0 - length(distorted_uv - UV) * 2.0);
    
    COLOR = final_color;
}