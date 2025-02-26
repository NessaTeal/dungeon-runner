shader_type canvas_item;

void vertex() {
	float k = -1.0;
	if (UV.x > 0.5)
		k = 1.0;
	VERTEX = vec2(VERTEX.x + 200.0 * k, VERTEX.y);
}

void fragment() {
	//COLOR = vec4(1,2,3,4);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
