shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.5); // 控制扩散半径
uniform vec4 sand_color : source_color = vec4(0.85, 0.75, 0.45, 1.0); // 沙尘颜色
uniform float noise_scale = 60.0;
uniform float grain_intensity = 0.5; // 颗粒感
uniform float blur_width = 0.05; // 边缘模糊范围
uniform float swirl_speed = 0.5;

float hash(vec2 p) {
    return fract(sin(dot(p ,vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(mix(a, b, u.x), mix(c, d, u.y), u.y);
}

void fragment() {
    vec2 uv = UV;
    vec2 center = vec2(0.5, 0.5);
    
    // 旋转扰动坐标（让风沙更有运动感）
    float angle = TIME * swirl_speed;
	float c = cos(angle);
	float s = sin(angle);
	mat2 rot = mat2(vec2(c, -s), vec2(s, c));   
    vec2 flow_uv = (uv - center) * rot + center;

    // 沙扩散的主控制：以距离为主
    float dist = distance(uv, center);

    // 计算沙尘扩散“边缘模糊”
    float edge = smoothstep(progress + blur_width, progress - blur_width, dist);

    // 噪声扰动 + 粒子感
    float grain = noise(flow_uv * noise_scale + TIME * 0.3);
    float flicker = mix(0.8, 1.2, grain);

    COLOR = sand_color * edge * flicker * grain_intensity;
}
