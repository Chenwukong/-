shader_type canvas_item;

uniform sampler2D leaf_texture_1 : source_color;
uniform sampler2D leaf_texture_2 : source_color;
uniform sampler2D leaf_texture_3 : source_color;
uniform sampler2D leaf_texture_4 : source_color;

uniform float time_scale = 1.0;
uniform float fall_speed = 50.0;
uniform float swing_amplitude = 30.0;
uniform float swing_speed = 2.0;
uniform int leaf_count = 20;
uniform float leaf_size = 0.1;

void fragment() {
    vec4 final_color = vec4(0.0);
    vec2 screen_uv = UV;
    float t = TIME * time_scale;

    for (int i = 0; i < leaf_count; i++) {
        float id = float(i);

        // 随机位置和偏移
        float seed_x = fract(sin(id * 12.9898) * 43758.5453);
        float seed_y = fract(sin(id * 78.233) * 12345.6789);
        float offset_time = fract(sin(id * 31.416) * 6543.21);

        vec2 pos = vec2(seed_x, mod(t * fall_speed * 0.01 + seed_y + offset_time, 1.0));
        pos.x += sin(t * swing_speed + id) * swing_amplitude / 100.0;

        vec2 leaf_uv = (screen_uv - pos) / leaf_size + 0.5;

        if (all(greaterThanEqual(leaf_uv, vec2(0.0))) && all(lessThanEqual(leaf_uv, vec2(1.0)))) {
            // 随机选一张贴图
            float tex_choice = fract(sin(id * 99.999) * 10.0);
            vec4 tex;

            if (tex_choice < 0.25) {
                tex = texture(leaf_texture_1, leaf_uv);
            } else if (tex_choice < 0.5) {
                tex = texture(leaf_texture_2, leaf_uv);
            } else if (tex_choice < 0.75) {
                tex = texture(leaf_texture_3, leaf_uv);
            } else {
                tex = texture(leaf_texture_4, leaf_uv);
            }

            float alpha_fade = smoothstep(1.0, 0.8, pos.y);
            final_color = mix(final_color, tex, tex.a * alpha_fade);
        }
    }

    COLOR = final_color;
}
