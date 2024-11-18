shader_type canvas_item;

uniform vec4 sand_color : source_color = vec4(0.76, 0.69, 0.5, 1.0); // 沙子的基础颜色
uniform vec4 dust_color : source_color = vec4(0.82, 0.78, 0.65, 1.0); // 扬尘的颜色
uniform float storm_speed : hint_range(0.1, 5.0) = 2.0;    // 风暴速度
uniform float storm_strength : hint_range(0.1, 2.0) = 1.0; // 风暴强度
uniform float storm_density : hint_range(0.1, 5.0) = 2.0;  // 沙尘密度
uniform float turbulence : hint_range(0.1, 2.0) = 1.0;    // 湍流强度

// 噪声函数
float random(vec2 pos) {
    return fract(sin(dot(pos, vec2(12.9898, 78.233))) * 43758.5453123);
}

// 分形噪声
float noise(vec2 pos) {
    vec2 i = floor(pos);
    vec2 f = fract(pos);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// 分层噪声
float fbm(vec2 pos) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 0.0;

    // 添加多层噪声
    for(float i = 0.0; i < 6.0; i++) {
        value += amplitude * noise(pos);
        pos *= 2.0;
        amplitude *= 0.5;
    }

    return value;
}

void fragment() {
    vec2 uv = UV;
    float time = TIME * storm_speed;

    // 创建基础沙尘流动
    float sand_base = fbm(vec2(uv.x * storm_density + time, uv.y * storm_density));

    // 添加水平风效果
    float wind = fbm(vec2(uv.x * 3.0 + time * 1.5, uv.y * 2.0));

    // 添加湍流
    float turb = fbm(vec2(
        uv.x * turbulence + sin(time * 0.5), 
        uv.y * turbulence + cos(time * 0.3)
    ));

    // 组合效果
    float final_noise = sand_base * wind * storm_strength;
    final_noise += turb * 0.3;

    // 添加垂直梯度
    float gradient = 1.0 - uv.y;
    final_noise *= gradient;

    // 颜色混合
    vec4 storm_color = mix(dust_color, sand_color, final_noise);

    // 添加密度变化
    float density_mask = smoothstep(0.2, 0.8, final_noise);

    // 最终颜色
    COLOR = mix(vec4(0.0), storm_color, density_mask);

    // 添加一些随机的沙粒
    float sand_particles = random(uv + time) * final_noise;
    COLOR.rgb += vec3(sand_particles * 0.1);
}


