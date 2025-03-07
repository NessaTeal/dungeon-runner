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
	float plane_x = 0.0;
	float plane_y = -1.0;
	float plane_z = 5.67128182;
	float plane_k = 9.0;
	vec3 plane = vec3(plane_x, plane_y, plane_z);
	vec3 camera_origin = vec3(8.0, 4.5, 6.363487333342628);
	vec3 point = vec3((UV.x * 0.6 + 0.2) * 16.0, (UV.y * 0.6 + 0.2) * 9.0, 0.0);
	vec3 ray = point - camera_origin;
	vec3 tmp = ray * plane;
	float t_mult = tmp.x + tmp.y + tmp.z;
	vec3 tmp_2 = point * plane;
	float result = tmp_2.x + tmp_2.y + tmp_2.z + plane_k;
	float t = result / -t_mult;
	float x = (point.x + ray.x * t) / 16.0;
	float y = (point.y + ray.y * t) / 9.0;
	
	//vec4 result = vec3(ray) * plane;
	//if (UV.x >= 0.5) {
		//k = -1.0;
	//}
	//float FOV = 51.5 / PI;
	//float angle = 0.0;
	//float angle_const = 51.5 / PI;
	//float x = ((sin((UV.x - 0.5) * PI) + 1.0) / 2.0) * cos(UV.y * (FOV - angle_const));
	//float x = UV.x;
	//float x = UV.x - (UV.x - 0.5) * 0.35 * sin(PI / 4.0 + UV.y * PI / 4.0);
	//float x = UV.x - (UV.x - 0.5) * 0.5 * UV.y;
	
	COLOR = texture(TEXTURE, vec2(x, y));
	
	//COLOR = texture(TEXTURE, vec2(x * 0.5 + 0.25, UV.y * 0.5 + 0.5));
}