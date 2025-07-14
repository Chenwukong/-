shader_type canvas_item;

// 冲击波参数
uniform float time : hint_range(0.0, 1.0) = 0.0;
uniform float wave_speed : hint_range(0.5, 3.0) = 1.0;
uniform float wave_width : hint_range(0.02, 0.15) = 0.08;
uniform float wave_strength : hint_range(0.0, 2.0) = 1.0;
uniform vec2 center = vec2(0.5, 0.5);
uniform vec4 wave_color : source_color = vec4(1.0, 0.8, 0.3, 1.0);
uniform bool multiple_waves = true;
uniform float wave_count : hint_range(1.0, 5.0) = 3.0;

void fragment() {
    vec2 pos_from_center = UV - center;
    float distance_from_center = length(pos_from_center);
    
    // 冲击波当前位置
    float wave_position = time * wave_speed;
    
    float total_intensity = 0.0;
    
    if (multiple_waves) {
        // 多重冲击波效果
        for (float i = 0.0; i < wave_count; i += 1.0) {
            float wave_offset = i * 0.2; // 波浪间隔
            float current_wave_pos = wave_position - wave_offset;
            
            if (current_wave_pos > 0.0) {
                float wave_distance = abs(distance_from_center - current_wave_pos);
                float wave_intensity = exp(-wave_distance / wave_width);
                
                // 每个波浪的时间衰减
                float individual_fade = max(0.0, 1.0 - (current_wave_pos) / 2.0);
                total_intensity += wave_intensity * individual_fade;
            }
        }
    } else {
        // 单一冲击波
        float wave_distance = abs(distance_from_center - wave_position);
        total_intensity = exp(-wave_distance / wave_width);
    }
    
    // 整体时间衰减
    float time_fade = max(0.0, 1.0 - time / 4.0);
    
    // 距离衰减（避免无限扩散）
    float distance_fade = max(0.0, 1.0 - distance_from_center / 1.2);
    
    // 最终强度
    float final_intensity = total_intensity * time_fade * distance_fade * wave_strength;
    
    // 背景完全透明，只显示冲击波
    COLOR = vec4(wave_color.rgb, final_intensity * wave_color.a);
}