shader_type canvas_item;

uniform float radius : hint_range(0.0, 1.5);
uniform vec2 center;

void fragment() {
    vec2 uv = UV;
    float dist = distance(uv, center);
    float alpha = smoothstep(radius, radius - 0.02, dist);
    COLOR = vec4(0.0, 0.0, 0.0, alpha);
}
