shader_type canvas_item;
uniform vec2 mouse_position = vec2(0.5, 0.5);
uniform vec4 wave_color: source_color = vec4(1.0, 2.0, 4.0, 1.0);
uniform float wave_transparency: hint_range(0.0, 1.0) = 1.0;

// 可选：添加偏移量控制
uniform vec2 pattern_offset = vec2(0.0, 0.0);
uniform float pattern_scale = 10.0;

mat2 rotate2D(float r) {
    return mat2(vec2(cos(r), sin(r)), vec2(-sin(r), cos(r)));
}

void fragment() {
    // 方案1：使用UV坐标（推荐）
    vec2 uv = UV * pattern_scale + pattern_offset;
    
    // 方案2：如果需要基于屏幕坐标，但不跟随镜头
    // vec2 uv = (SCREEN_UV - 0.5) * pattern_scale + pattern_offset;
    
    // 方案3：如果你想要固定的世界坐标系
    // vec2 uv = (FRAGCOORD.xy / TEXTURE_PIXEL_SIZE.y) * 0.001 + pattern_offset;
    
    // Color inicial
    vec3 col = vec3(0.0);
    // Tiempo
    float t = TIME;
    // Variables para el cálculo del ruido
    vec2 n = vec2(0.0), q;
    vec2 N = vec2(0.0);
    // Posición inicial
    vec2 p = uv + sin(t*0.1/10.0);
    // Escala inicial
    float S = 10.0;
    // Matriz de rotación
    mat2 m = rotate2D(1.0 - (mouse_position.x * 0.001));
    // Bucle principal para generar el ruido
    for (float j = 0.0; j < 30.0; j++) {
        // Rotar la posición y el vector normal
        p *= m;
        n *= m;
        // Calcular el valor del ruido
        q = p * S + j + n + t;
        n += sin(q);
        N += cos(q) / S;
        // Aumentar la escala
        S *= 1.2;
    }
    // Evitar divisiones por cero
    float lengthN = max(length(N), 0.001);
    // Calcular el color final
    col = wave_color.rgb * pow((N.x + N.y + 0.4) + 0.005 / lengthN, 2.1);
    COLOR = vec4(col, wave_transparency);
}