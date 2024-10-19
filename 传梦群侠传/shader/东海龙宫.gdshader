shader_type canvas_item;

uniform vec4 water_deep : source_color = vec4(0.0, 0.4, 1, 0.3);  // 调整透明度和颜色深度
uniform vec4 water_shallow : source_color = vec4(0.0, 0.7, 1, 0.15);  // 调整浅水区的颜色
uniform float time_scale : hint_range(0.0, 1.0) = 0.1;  // 时间缩放，调整水波的速度
uniform float wave_scale : hint_range(1.0, 20.0) = 15.0;  // 波的规模，增强水波的密集程度
uniform float distortion_strength : hint_range(0.0, 0.1) = 0.05;  // 调整波纹的扭曲强度

// 改进后的 2D 噪声函数
vec2 hash(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(dot(hash(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0)),
                   dot(hash(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0)), u.x),
               mix(dot(hash(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0)),
                   dot(hash(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0)), u.x), u.y);
}

void fragment() {
    vec2 uv = UV;
    float time = TIME * time_scale;
    
    // 创建多层波浪，增加细节
    float wave1 = noise(uv * wave_scale + time * vec2(1.0, 0.5));
    float wave2 = noise(uv * wave_scale * 2.0 + time * vec2(-0.5, 1.0));
    float wave3 = noise(uv * wave_scale * 4.0 + time * vec2(0.8, -0.6));
    float wave4 = noise(uv * wave_scale * 8.0 + time * vec2(1.5, -1.0));
    
    // 综合波浪效果，使得水波更加细腻自然
    float waves = (wave1 + wave2 * 0.5 + wave3 * 0.25 + wave4 * 0.125) / (1.0 + 0.5 + 0.25 + 0.125);
    
    // 创建波纹扭曲效果
    vec2 distortion = vec2(waves, waves) * distortion_strength;
    
    // 应用扭曲效果到 UV 上
    vec2 distorted_uv = uv + distortion;
    
    // 基于扭曲后的 UV 创建颜色渐变
    vec4 water_color = mix(water_deep, water_shallow, smoothstep(0.2, 0.8, distorted_uv.y));
    
    // 为水添加波纹效果，使水看起来更加动态
    water_color += waves * 0.1;
    
    // 添加一些闪光效果，模拟阳光反射
    float sparkle = pow(noise(uv * 50.0 + time * 5.0), 8.0) * 0.3;  // 提高噪声的指数，使闪光更柔和
    water_color += vec4(1.0, 1.0, 1.0, 1.0) * sparkle;  // 添加白色闪光
    
    // 设置最终颜色
    COLOR = water_color;
}
