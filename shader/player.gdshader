shader_type canvas_item;

uniform float color_opacity = 0;
uniform vec4 main_color :source_color = vec4(1.0,1.0,1.0,1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 tex_color = texture(TEXTURE,UV);
	vec3 blended_color = mix(tex_color.rgb,main_color.rgb,color_opacity);
	COLOR.rgb = blended_color;
	COLOR.a = tex_color.a;
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
