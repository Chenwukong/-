shader_type canvas_item;

uniform sampler2D noise_texture;
uniform float spread_threshold : hint_range(0.0, 1.0) = 0.0; // 控制蔓延程度
uniform float edge_softness : hint_range(0.0, 0.5) = 0.05;

uniform vec4 background_color : source_color = vec4(1.0);
uniform vec4 ink_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    vec2 uv = UV;

    // 读取噪声值（控制扩散的遮罩）
    float noise = texture(noise_texture, uv).r;

    // 墨迹 alpha：根据 spread_threshold 控制何时出现
    float mask = smoothstep(spread_threshold + edge_softness, spread_threshold, noise);

    COLOR = mix(ink_color, background_color, mask);
}
