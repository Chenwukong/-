shader_type canvas_item;
//10，10，1
uniform float snow_speed = 0.7;
uniform float snow_density = 1.0;
uniform float wind_speed = 0.2;
uniform vec4 snow_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float direction = -1.0;
// 随机函数
float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

// 2D 旋转矩阵
mat2 rot2d(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(vec2(c, -s), vec2(s, c));
}

void fragment() {
    vec2 uv = UV;
    
    // 创建多层雪花
    float snow = 0.0;
    
    // 第一层雪 - 大雪花
    vec2 uv1 = uv * 30.0;
    uv1.y += TIME * snow_speed * direction;
    uv1.x += TIME * wind_speed;
    vec2 grid1 = fract(uv1) - 0.5;
    float size1 = length(grid1);
    snow += (1.0 - smoothstep(0.02, 0.03, size1)) * step(rand(floor(uv1)), snow_density * 0.3);
    
    // 第二层雪 - 中雪花
    vec2 uv2 = uv * 45.0;
    uv2.y += TIME * snow_speed * 1.3 * direction;
    uv2.x += TIME * wind_speed * 1.1;
    vec2 grid2 = fract(uv2) - 0.5;
    float size2 = length(grid2);
    snow += (1.0 - smoothstep(0.01, 0.02, size2)) * step(rand(floor(uv2)), snow_density * 0.3);
    
    // 第三层雪 - 小雪花
    vec2 uv3 = uv * 60.0;
    uv3.y += TIME * snow_speed * 1.6 * direction;
    uv3.x += TIME * wind_speed * 1.2;
    vec2 grid3 = fract(uv3) - 0.5;
    float size3 = length(grid3);
    snow += (1.0 - smoothstep(0.008, 0.015, size3)) * step(rand(floor(uv3)), snow_density * 0.3);
    
    // 输出最终颜色
    COLOR = vec4(snow_color.rgb, snow * snow_color.a);
}