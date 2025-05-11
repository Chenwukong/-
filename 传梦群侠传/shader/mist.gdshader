shader_type canvas_item;

// 烟雾参数
uniform vec4 smoke_color : source_color = vec4(0.95, 0.97, 1.0, 0.6);
uniform float density = 0.4;
uniform float speed = 0.3;
uniform float noise_scale = 3.0;
uniform float swirl_strength = 0.5;

// 需要Clouds类型的噪声纹理
uniform sampler2D noise_tex : source_color, repeat_enable;

void fragment() {
    // 分形噪声计算
    vec2 uv = UV * noise_scale;
    vec2 moving_uv = uv + TIME * speed * 0.5;
    
    // 创建涡旋运动
    vec2 swirl_uv = uv * 0.8;
    float angle = TIME * speed * 0.3 * swirl_strength;
    swirl_uv = vec2(
        swirl_uv.x * cos(angle) - swirl_uv.y * sin(angle),
        swirl_uv.x * sin(angle) + swirl_uv.y * cos(angle)
    );
    
    // 三层噪声混合
    float noise1 = texture(noise_tex, moving_uv).r;
    float noise2 = texture(noise_tex, moving_uv * 1.8 + swirl_uv).g * 0.7;
    float noise3 = texture(noise_tex, moving_uv * 0.4 - swirl_uv * 0.6).b * 0.4;
    
    // 动态密度计算
    float dynamic_density = density * (0.8 + sin(TIME * 0.5) * 0.2);
    float combined_noise = (noise1 * 0.6 + noise2 * 0.3 + noise3 * 0.1);
    
    // 烟雾形态生成
    float smoke = smoothstep(dynamic_density - 0.3, dynamic_density + 0.4, combined_noise);
    smoke *= smoothstep(0.1, 0.8, 1.0 - length(UV - 0.5)); // 中心衰减
    
    // 颜色混合
    vec4 final_color = mix(
        vec4(0), 
        smoke_color * (0.9 + noise2 * 0.3), // 颜色变化
        smoke * smoke_color.a
    );
    
    // 与场景混合
    vec4 bg = texture(TEXTURE, UV);
    COLOR = mix(bg, final_color, final_color.a);
    COLOR.a = max(bg.a, final_color.a);
}