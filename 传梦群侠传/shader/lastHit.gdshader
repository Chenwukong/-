shader_type canvas_item;

uniform sampler2D vertical_gradient;
uniform sampler2D color_gradient;
uniform float size_effect: hint_range(-5.0, 5.0, 0.05) = 0.1;
uniform float speed = 3;
uniform float highlight_strength: hint_range(-4.0, 4.0, 0.05) = 0.5;
uniform bool color_mode_toggle = false;
uniform bool is_horizontal = false;
uniform bool play_once = false; // 新增参数，控制播放状态
uniform bool visibility = false;
void fragment() {

		
    vec4 old_color = COLOR;

    float time = play_once ? min(TIME * speed, 1.0 / speed) : TIME * speed; // 限制时间范围，只播放一次
    float current_time = fract(-time);
    current_time = mix(0.0 - size_effect, 1.0 + size_effect, current_time);
    float effect_lower_bound = current_time - size_effect;
    float effect_upper_bound = current_time + size_effect;
    float position_value = (is_horizontal) ? UV.x : UV.y;
    float effect_distance = smoothstep(effect_lower_bound, current_time, position_value) - smoothstep(current_time, effect_upper_bound, position_value);
    float inner_effect_position = smoothstep(effect_lower_bound, effect_upper_bound, position_value);
    vec2 color_position = (color_mode_toggle) ? vec2(UV.x, inner_effect_position) : vec2(current_time);
    vec4 new_color = vec4(texture(color_gradient, color_position));

    new_color = mix(old_color, new_color, vec4(texture(vertical_gradient, vec2(current_time))));
    COLOR.rgb = mix(old_color.rgb, new_color.rgb, vec3(effect_distance * highlight_strength));
}
