shader_type canvas_item;

// 可调节的参数
uniform float time_scale : hint_range(0.1, 5.0) = 1.0;
uniform float star_density : hint_range(0.1, 2.0) = 1.0;
uniform float star_brightness : hint_range(0.5, 3.0) = 1.5;
uniform float twinkle_speed : hint_range(0.5, 5.0) = 2.0;
uniform vec3 nebula_color : source_color = vec3(0.2, 0.1, 0.4);
uniform vec3 star_color : source_color = vec3(1.0, 0.9, 0.8);
uniform float nebula_intensity : hint_range(0.0, 1.0) = 0.3;

// 随机数生成函数
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// 噪声函数
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// 分层噪声
float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 0.0;
    
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    
    return value;
}

// 创建星星
float stars(vec2 st, float num_cells) {
    st *= num_cells;
    vec2 i_st = floor(st);
    vec2 f_st = fract(st);
    
    float m_dist = 2.0;
    
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 neighbor = vec2(float(x), float(y));
            vec2 offset = neighbor + random(i_st + neighbor) - 0.5;
            vec2 diff = neighbor + offset - f_st;
            float dist = length(diff);
            m_dist = min(m_dist, dist);
        }
    }
    
    return 1.0 - smoothstep(0.0, 0.1, m_dist);
}

// 主函数
void fragment() {
    vec2 st = UV;
    float time = TIME * time_scale;
    
    // 创建深空背景
    vec3 bg_color = vec3(0.0, 0.0, 0.05);
    
    // 添加星云效果
    float nebula = fbm(st * 3.0 + time * 0.1);
    nebula = smoothstep(0.4, 0.8, nebula);
    vec3 nebula_final = nebula_color * nebula * nebula_intensity;
    
    // 创建不同大小的星星层
    float stars1 = stars(st + time * 0.05, 15.0 * star_density);
    float stars2 = stars(st + time * 0.03, 25.0 * star_density);
    float stars3 = stars(st + time * 0.01, 40.0 * star_density);
    
    // 添加闪烁效果
    float twinkle1 = sin(time * twinkle_speed + random(st) * 6.28) * 0.5 + 0.5;
    float twinkle2 = sin(time * twinkle_speed * 1.3 + random(st * 2.0) * 6.28) * 0.5 + 0.5;
    float twinkle3 = sin(time * twinkle_speed * 0.7 + random(st * 3.0) * 6.28) * 0.5 + 0.5;
    
    // 组合星星效果
    float all_stars = stars1 * twinkle1 * 1.0 + 
                     stars2 * twinkle2 * 0.7 + 
                     stars3 * twinkle3 * 0.5;
    
    // 添加一些大而亮的星星
    float bright_stars = stars(st * 8.0 * star_density, 1.0);
    float bright_twinkle = sin(time * twinkle_speed * 0.5 + random(st * 4.0) * 6.28) * 0.5 + 0.5;
    bright_stars *= bright_twinkle * 2.0;
    
    // 最终颜色组合
    vec3 star_final = star_color * (all_stars + bright_stars) * star_brightness;
    
    // 添加微妙的渐变
    float gradient = smoothstep(0.0, 1.0, length(st - 0.5));
    bg_color *= (1.0 - gradient * 0.3);
    
    // 组合所有效果
    vec3 final_color = bg_color + nebula_final + star_final;
    
    // 增加对比度
    final_color = smoothstep(0.0, 1.0, final_color);
    
    COLOR = vec4(final_color, 1.0);
}
