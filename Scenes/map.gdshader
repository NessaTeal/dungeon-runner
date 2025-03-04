shader_type canvas_item;



//void fragment() {
	//float perspective = 100.0;
	//
	////float x = ((UV.x - 0.5) / (0.5 + UV.y * perspective)) + 0.5;
	////
	////float y = ((UV.y - 0.5) / (0.5 + UV.x * perspective)) + 0.5;
	////
	////vec2 pos = vec2(x * cos(rotation), y * sin(rotation));
	//
	//float x = ((UV.x - 0.5) / (0.5 + UV.y * perspective)) + 0.5;
	//
	//vec2 pos = vec2(x, UV.y);
	//
	//if (pos.x >= 0.0 && pos.x <= 1.0) {
		//COLOR = texture(TEXTURE, pos);
	//} else {
		//COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	//}
//}

void fragment() {
	//float k = 1.0;
	//if (UV.x >= 0.5) {
		//k = -1.0;
	//}
	float x = (UV.x - 0.5) / (0.5 + UV.y) + 0.5;
	//float x = UV.x - (UV.x - 0.5) * 0.5 * sin(UV.y * PI / 2.0);
	//float x = UV.x - (UV.x - 0.5) * 0.35 * sin(PI / 4.0 + UV.y * PI / 4.0);
	//float x = UV.x - (UV.x - 0.5) * 0.5 * UV.y;
	
	COLOR = texture(TEXTURE, vec2(x * 0.5 + 0.25, 0.5 + (log2(7.0 * UV.y + 1.0) - 1.0) * 0.25));
	
	//COLOR = texture(TEXTURE, vec2(x * 0.5 + 0.25, UV.y * 0.5 + 0.5));
}