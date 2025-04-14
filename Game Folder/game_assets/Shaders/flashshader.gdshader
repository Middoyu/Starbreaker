shader_type canvas_item;

uniform float applied_effect : hint_range(0, 1) = 0.0;
uniform vec4 color : source_color = vec4(1.0);

void fragment() {
	vec4 input_color = texture(TEXTURE, UV);
	COLOR = mix(input_color, color, applied_effect);
	COLOR.a = input_color.a;
}