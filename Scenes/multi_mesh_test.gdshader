shader_type spatial;

uniform sampler2D atlas : filter_nearest_mipmap_anisotropic, repeat_disable;
//uniform sampler2D atlas;
varying flat vec4 t;
//uniform vec4[2] g;

void vertex() {
	// Called for every vertex the material is visible on.
	//float a = INSTANCE_CUSTOM.x;
	//COLOR = color;
	//int a = floatBitsToInt(t.x) >> 28;
	t = INSTANCE_CUSTOM;
}

void fragment() {
	//float grass_offset = t.x && 1;
	uint grass_tile = floatBitsToUint(t.x) % 16u;
	uint sand_tile = (floatBitsToUint(t.x) >> 6u) % 16u;
	uint rock_tile = (floatBitsToUint(t.x) >> 12u) % 16u;
	uint dirt_tile = (floatBitsToUint(t.x) >> 18u) % 16u;
	
	uint grass_tile_order = (floatBitsToUint(t.x) >> 4u) % 4u;
	uint sand_tile_order = (floatBitsToUint(t.x) >> 10u) % 4u;
	uint rock_tile_order = (floatBitsToUint(t.x) >> 16u) % 4u;
	uint dirt_tile_order = (floatBitsToUint(t.x) >> 22u) % 4u;
	//float b = float(a);
	vec4 grass = texture(atlas, vec2((float(grass_tile) * 128.0 / 1920.0) + UV.x * (128.0 / 1920.0), UV.y * 0.25));
	vec4 sand = texture(atlas, vec2((float(sand_tile) * 128.0 / 1920.0) + UV.x * (128.0 / 1920.0),  0.25 + UV.y * 0.25));
	vec4 rock = texture(atlas, vec2((float(rock_tile) * 128.0 / 1920.0) + UV.x * (128.0 / 1920.0),  0.5 + UV.y * 0.25));
	vec4 dirt = texture(atlas, vec2((float(dirt_tile) * 128.0 / 1920.0) + UV.x * (128.0 / 1920.0),  0.75 + UV.y * 0.25));
	
	bool grass_visible = (grass_tile_order == 3u) || (((grass_tile_order > sand_tile_order) || (sand.a < 1.0)) && ((grass_tile_order > rock_tile_order) || (rock.a < 1.0)) && ((grass_tile_order > dirt_tile_order) || (dirt.a < 1.0)));
	bool sand_visible = (sand_tile_order == 3u) || (((sand_tile_order > grass_tile_order) || (grass.a < 1.0)) && ((sand_tile_order > rock_tile_order) || (rock.a < 1.0)) && ((sand_tile_order > dirt_tile_order) || (dirt.a < 1.0)));
	bool rock_visible = (rock_tile_order == 3u) || (((rock_tile_order > sand_tile_order) || (sand.a < 1.0)) && ((rock_tile_order > grass_tile_order) || (grass.a < 1.0)) && ((rock_tile_order > dirt_tile_order) || (dirt.a < 1.0)));
	bool dirt_visible = (dirt_tile_order == 3u) || (((dirt_tile_order > sand_tile_order) || (sand.a < 1.0)) && ((dirt_tile_order > rock_tile_order) || (rock.a < 1.0)) && ((dirt_tile_order > grass_tile_order) || (grass.a < 1.0)));
	//ALBEDO = vec3(1.0 * (float(uint(a)) / 64.0), 0.0, 0.0);
	//ALBEDO = vec3(float(a), 0.0, 0.0);
	//ALBEDO = t.xyz;
	ALBEDO = min(grass.rgb * grass.a, float(grass_visible)) + min(sand.rgb * sand.a, float(sand_visible)) + min(rock.rgb * rock.a, float(rock_visible)) + min(dirt.rgb * dirt.a, float(dirt_visible));
}
