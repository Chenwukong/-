shader_type canvas_item;

uniform float blur_amount : hint_range(0.0, 1.0) = 0.3;
uniform float memory_intensity : hint_range(0.0, 1.0) = 0.5;
uniform vec4 memory_color : source_color = vec4(0.8, 0.8, 0.9, 1.0);

void fragment() {
    // 简化的采样模糊
    vec4 blurred_color = vec4(0.0);
    float kernel_size = blur_amount * 0.02;
    
    blurred_color += texture(TEXTURE, UV + vec2(-kernel_size, -kernel_size));
    blurred_color += texture(TEXTURE, UV + vec2(kernel_size, -kernel_size));
    blurred_color += texture(TEXTURE, UV + vec2(-kernel_size, kernel_size));
    blurred_color += texture(TEXTURE, UV + vec2(kernel_size, kernel_size));
    blurred_color += texture(TEXTURE, UV);
    
    blurred_color /= 5.0;
    
    // 添加内存色调
    vec4 tinted_color = mix(blurred_color, memory_color, memory_intensity * 0.5);
    
    // 添加轻微噪点
    float noise = fract(sin(dot(UV, vec2(12.9898, 78.233))) * 43758.5453) * 0.1 * memory_intensity;
    tinted_color.rgb += noise;
    
    // 调整透明度
    tinted_color.a *= 1.0 - (blur_amount * 0.5);
    
    COLOR = tinted_color;
}