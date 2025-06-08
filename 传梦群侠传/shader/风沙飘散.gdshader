shader_type canvas_item;

// 控制参数
uniform float dissolve_progress : hint_range(0.0, 1.0) = 0.0;
uniform float wind_force : hint_range(0.0, 1.0) = 0.3;
uniform vec2 wind_dir = vec2(1.0, -0.2);
uniform float noise_scale = 5.0;
uniform vec4 sand_color  = vec4(0.9, 0.7, 0.4, 1.0);

// 简单随机函数
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

// 简单噪声
float noise(vec2 pos) {
    vec2 i = floor(pos);
    vec2 f = fract(pos);
    
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    
    vec2 u = smoothstep(0.0, 1.0, f);
    
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

void fragment() {
    vec2 uv = UV;
    vec4 original = texture(TEXTURE, uv);
    
    // 基础噪声
    float n = noise(uv * noise_scale + TIME * 0.5);
    
    // 从下到上的溶解
    float dissolve_mask = dissolve_progress + (1.0 - uv.y) * 0.3 + n * 0.4;
    
    if (dissolve_mask > 0.7) {
        // 完全溶解 - 显示飘散的沙粒
        vec2 particle_pos = uv + wind_dir * TIME * wind_force;
        float particle_noise = noise(particle_pos * 20.0);
        
        if (particle_noise > 0.6) {
            float alpha = (1.0 - dissolve_mask) * original.a;
            COLOR = vec4(sand_color.rgb, alpha);
        } else {
            COLOR = vec4(0.0, 0.0, 0.0, 0.0);
        }
    } else if (dissolve_mask > 0.5) {
        // 边缘过渡
        float edge = (dissolve_mask - 0.5) / 0.2;
        vec3 color = mix(original.rgb, sand_color.rgb, edge);
        COLOR = vec4(color, original.a);
    } else {
        // 正常显示
        COLOR = original;
    }
}