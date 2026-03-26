shader_type spatial;

uniform sampler2D atlas : filter_nearest_mipmap_anisotropic, repeat_disable;
varying flat vec4 t;

//render_mode blend_premul_alpha;

void vertex() {
	t = INSTANCE_CUSTOM;
}

const float tile_size = 128.0;
const float tiles_x = 16.0;
const float tiles_y = 4.0;
const float texture_width = 4096.0;
const float texture_height = 1024.0;
const float texture_padding = 32.0;
const float delta_x_tile = (tile_size + 2.0 * texture_padding) / texture_width;
const float delta_y_tile = (tile_size + 2.0 * texture_padding) / texture_height;

void fragment() {
	uint grass_tile = floatBitsToUint(t.x) % 16u;
	uint sand_tile = (floatBitsToUint(t.x) >> 6u) % 16u;
	uint rock_tile = (floatBitsToUint(t.x) >> 12u) % 16u;
	uint dirt_tile = (floatBitsToUint(t.x) >> 18u) % 16u;
	
	uint grass_tile_order = (floatBitsToUint(t.x) >> 4u) % 4u;
	uint sand_tile_order = (floatBitsToUint(t.x) >> 10u) % 4u;
	uint rock_tile_order = (floatBitsToUint(t.x) >> 16u) % 4u;
	uint dirt_tile_order = (floatBitsToUint(t.x) >> 22u) % 4u;
	
	vec4 grass = texture(atlas, vec2((float(grass_tile) * delta_x_tile) + UV.x * (tile_size / texture_width) + (texture_padding / texture_width),                        UV.y * (tile_size / texture_height) + (texture_padding /texture_height)));
	vec4 sand  = texture(atlas, vec2((float(sand_tile)  * delta_x_tile) + UV.x * (tile_size / texture_width) + (texture_padding / texture_width), (1.0 * delta_y_tile) + UV.y * (tile_size / texture_height) + (texture_padding / texture_height)));
	vec4 rock  = texture(atlas, vec2((float(rock_tile)  * delta_x_tile) + UV.x * (tile_size / texture_width) + (texture_padding / texture_width), (2.0 * delta_y_tile) + UV.y * (tile_size / texture_height) + (texture_padding / texture_height)));
	vec4 dirt  = texture(atlas, vec2((float(dirt_tile)  * delta_x_tile) + UV.x * (tile_size / texture_width) + (texture_padding / texture_width), (3.0 * delta_y_tile) + UV.y * (tile_size / texture_height) + (texture_padding / texture_height)));
	
    vec4 slot0 = grass * float(grass_tile_order == 0u)
               + sand  * float(sand_tile_order  == 0u)
               + rock  * float(rock_tile_order  == 0u)
               + dirt  * float(dirt_tile_order  == 0u);

    vec4 slot1 = grass * float(grass_tile_order == 1u)
               + sand  * float(sand_tile_order  == 1u)
               + rock  * float(rock_tile_order  == 1u)
               + dirt  * float(dirt_tile_order  == 1u);

    vec4 slot2 = grass * float(grass_tile_order == 2u)
               + sand  * float(sand_tile_order  == 2u)
               + rock  * float(rock_tile_order  == 2u)
               + dirt  * float(dirt_tile_order  == 2u);

    vec4 slot3 = grass * float(grass_tile_order == 3u)
               + sand  * float(sand_tile_order  == 3u)
               + rock  * float(rock_tile_order  == 3u)
               + dirt  * float(dirt_tile_order  == 3u);

    // Composite bottom to top
    vec4 final = slot0;

    final = mix(final, slot1, slot1.a);
    final = mix(final, slot2, slot2.a);
    final = mix(final, slot3, slot3.a);

    ALBEDO = final.rgb;
    ALPHA = final.a;
}
