shader_type canvas_item;

uniform vec4 blood_color : source_color = vec4(0.5, 0.0, 0.0, 0.2);
uniform float speed : hint_range(0.1, 100.0) = 40.0;
uniform float scale : hint_range(0.1, 2.0) = 2;
uniform int particle_count : hint_range(10, 300) = 300;
uniform float fade_edge : hint_range(0.0, 0.5) = 0.1;
uniform float center_density : hint_range(0.0, 1.0) = 0.5;

const float TIME_SCALE = 0.01;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

vec4 particle(vec2 uv, vec2 center, float size, float fade) {
    float d = length(uv - center);
    float alpha = smoothstep(size, 0.0, d) * fade;
    return vec4(blood_color.rgb, alpha * blood_color.a);
}

void fragment() {
    vec2 uv = UV - 0.5;
    float aspect_ratio = TEXTURE_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.x;
    uv.y *= aspect_ratio;
    
    vec4 color = vec4(0.0);
    float scaled_time = TIME * speed * TIME_SCALE;
    
    for (int i = 0; i < particle_count; i++) {
        float t = scaled_time + float(i) * 1234.5678;
        float angle = random(vec2(float(i), 1.0)) * 6.28;
        
        float radius = sqrt(random(vec2(float(i), 2.0)));
        radius = mix(radius, fract(radius + t), center_density);
        radius *= 0.5;
        
        vec2 center = vec2(cos(angle), sin(angle)) * radius;
        
        float size = (random(vec2(float(i), 3.0)) * 0.05 + 0.02) * scale;
        float fade = smoothstep(0.5, 0.5 - fade_edge, radius);
        
        color += particle(uv, center, size, fade);
    }
    
    float edge_fade = 1.0 - smoothstep(0.4, 0.5, length(uv));
    color.a *= edge_fade;
    
    COLOR = color;
}