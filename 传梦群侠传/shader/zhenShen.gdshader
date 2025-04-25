shader_type canvas_item;

uniform float time_speed = 1.2;
uniform float noise_scale = 4.0;
uniform float swirl_strength = 0.7;
uniform float alpha_strength = 0.6;

uniform vec4 color1 : source_color = vec4(0.4, 0.0, 0.6, 1.0); // 紫色
uniform vec4 color2 : source_color = vec4(0.0, 0.0, 0.0, 1.0); // 黑色

void fragment() {
	vec2 uv = UV;

	// 偏移中心点，使其以 ColorRect 中心向外扩散
	vec2 center = vec2(0.5, 0.5);
	vec2 offset = uv - center;

	// 增加流动感：扰动 UV 坐标
	float t = TIME * time_speed;
	offset.x += sin(uv.y * 10.0 + t) * 0.05;
	offset.y += cos(uv.x * 10.0 - t * 0.5) * 0.05;

	// 模拟漩涡或波动感
	float swirl = sin((offset.x + t) * noise_scale) * cos((offset.y - t) * noise_scale);

	// 混合颜色
	float factor = clamp(swirl * swirl_strength + 0.5, 0.0, 1.0);
	vec4 final_color = mix(color1, color2, factor);

	// 圆形扩散 fade out
	float dist = length(offset) * 2.0; // 放大 fade 范围
	float fade = smoothstep(1.2, 0.3, dist); // 外围渐隐
	final_color.a *= fade * alpha_strength;

	COLOR = final_color;
}
