shader_type canvas_item;

uniform vec2 focus_point = vec2(0.5, 0.5); // 中心点
uniform float radius = 0.5; // 法术框半径
uniform float edge_softness = 0.25; // 边缘柔和度
uniform float distortion_strength = 0.02; // 扭曲强度
uniform float glow_strength = 0.4; // 边缘发光强度
uniform vec4 glow_color : source_color = vec4(0.4, 0.8, 1.0, 0.6); // 魔法光晕颜色

// 简单噪声函数，制造边缘不规则
float hash(vec2 p) {
    return fract(sin(dot(p ,vec2(127.1,311.7)))*43758.5453123);
}

float noise(vec2 p){
    vec2 i = floor(p);
    vec2 f = fract(p);
    
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    vec2 u = f*f*(3.0-2.0*f);
    
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

void fragment() {
    vec2 uv = UV;
    
    // 扭曲 UV
    vec2 distortion = vec2(
        noise(uv * 10.0 + TIME) - 0.5,
        noise(uv * 10.0 - TIME) - 0.5
    ) * distortion_strength;
    
    vec2 distorted_uv = uv + distortion;
    
    float dist = distance(distorted_uv, focus_point);
    
    // 边缘加噪声，让边界模糊自然
    float noisy_dist = dist + (noise(uv * 20.0 + TIME) - 0.5) * 0.05;
    
    // 计算主遮罩
    float mask = smoothstep(radius, radius + edge_softness, noisy_dist);
    
    // 发光区域
    float glow = smoothstep(radius - 0.05, radius, noisy_dist);
    
    // 原本的颜色
    vec4 base_color = texture(TEXTURE, uv);
    
    // 混合最终颜色
    COLOR = mix(base_color, glow_color, (1.0 - glow) * glow_strength);
    COLOR = mix(COLOR, vec4(0,0,0,0), mask);
}
