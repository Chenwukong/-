shader_type canvas_item;
render_mode blend_mix;

// Wind settings.
uniform float speed = 50.0;
uniform float minStrength : hint_range(0.0, 1.0) = 0.6;
uniform float maxStrength : hint_range(0.0, 1.0) = 0.6;
uniform float strengthScale = 100.0;
uniform float interval = 3.5;
uniform float detail = 1.0;
uniform float distortion : hint_range(0.0, 1.0);
uniform float heightOffset : hint_range(0.0, 1.0);
uniform float offset = 0;  // Custom offset for each asset

float getWind(vec2 vertex, vec2 uv, float time) {
    float diff = pow(maxStrength - minStrength, 2.0);
    float strength = clamp(minStrength + diff + sin(time / interval) * diff, minStrength, maxStrength) * strengthScale;
    float wind = (sin(time) + cos(time * detail)) * strength * max(0.0, (1.0 - uv.y) - heightOffset);
    
    return wind;
}

void vertex() {
    float time = TIME * speed + offset;
    VERTEX.x += getWind(VERTEX.xy, UV, time);
}
