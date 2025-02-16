import math
import json
from PIL import Image

# def create_gradients(extra_fill):
#     grad = Image.linear_gradient("L")

#     black = Image.new("L", (256, extra_fill))
#     white = Image.new("L", (256, extra_fill), 255)

#     mask = Image.new("L", (256, 256 + extra_fill * 2))
#     mask.paste(black)
#     mask.paste(grad, (0, extra_fill))
#     mask.paste(white, (0, 256 + extra_fill))

#     mask = mask.resize((128,128), Image.Resampling.BICUBIC)

#     offset = math.sin(math.radians(45)) * 128
#     rot = mask.rotate(45, Image.Resampling.NEAREST, True)
#     rot = rot.crop((offset / 2, offset / 2, offset * 1.5, offset * 1.5)).resize((128, 128), Image.Resampling.BICUBIC)

#     return {'linear': mask, 'angular': rot}

# def merge_data_at_angle(tile1_data, tile2_data):
#     return {"top": tile2_data['top'], "right": tile1_data['right'], "bottom": tile1_data['bottom'], "left": tile2_data['left']}

# def merge_data_linearly(tile1_data, tile2_data):
#     return {"top": tile2_data['top'], "right": tile2_data['right'][0] + tile1_data['right'][1], "bottom": tile1_data['bottom'], "left": tile1_data['left'][0] + tile2_data['left'][1]}

# def merge_data(tile1_data, tile2_data, type):
#     if type == 'angular':
#         return merge_data_at_angle(tile1_data, tile2_data)
#     else:
#         return merge_data_linearly(tile1_data, tile2_data)

# def rotate_image_and_data_and_push(image, data):
#     rot = image.transpose(Image.Transpose.ROTATE_90)
#     rot_data = data | {"top": data['right'], "right": data['bottom'], "bottom": data['left'], "left": data['top']}
#     all_result_tiles.append(rot)
#     all_result_data.append(rot_data)

#     rot = image.transpose(Image.Transpose.ROTATE_180)
#     rot_data = data | {"top": rot_data['right'], "right": rot_data['bottom'], "bottom": rot_data['left'], "left": rot_data['top']}
#     all_result_tiles.append(rot)
#     all_result_data.append(rot_data)

#     rot = image.transpose(Image.Transpose.ROTATE_270)
#     rot_data = data | {"top": rot_data['right'], "right": rot_data['bottom'], "bottom": rot_data['left'], "left": rot_data['top']}
#     all_result_tiles.append(rot)
#     all_result_data.append(rot_data)

SIZE = 128
DX = 5
DY = 3
# GRADIENT_MARGIN = 2048
# gradients = create_gradients(GRADIENT_MARGIN)

im = Image.open("edited_tilesheet.png")

coords = [
    {
		"x": 2,
		"y": 2
	},
	{
		"x": 0,
		"y": 2
	},
	{
		"x": 1,
		"y": 2
	},
	{
		"x": 0,
		"y": 0
	},
	{
		"x": 3,
		"y": 2
	},
	{
		"x": 0,
		"y": 1
	},
	{
		"x": 4,
		"y": 0
	},
	{
		"x": 2,
		"y": 0
	},
	{
		"x": 2,
		"y": 1
	},
	{
		"x": 4,
		"y": 2
	},
	{
		"x": 3,
		"y": 0
	},
	{
		"x": 1,
		"y": 0
	},
	{
		"x": 3,
		"y": 1
	},
	{
		"x": 4,
		"y": 1
	},
	{
		"x": 1,
		"y": 1
	}
]

atlas = Image.new("RGBA", (15 * SIZE, 4 * SIZE))

for value in [2, 3, 1, 0]:
    for index, coord in enumerate(coords):
        atlas.paste(im.crop((coord['x'] * SIZE, (coord['y'] + value * 3) * SIZE, (coord['x'] + 1) * SIZE, (coord['y'] + value * 3 + 1) * SIZE)), (index * SIZE, value * SIZE))

atlas.save("atlas.png")

# all_result_tiles = []
# all_result_data = []

# fulls = {}

# tiles = {
#     "corner": [[], [], [], []]
# }

# for full in config['fulls']:
#     fulls[full['type']] = im.crop((SIZE * full["x"], SIZE * full["y"], SIZE * (1 + full["x"]), SIZE * (1 + full["y"])))

# dy = 0
# for y in config['v_order']:
#     dx = 0
#     for x in config['h_order']:
#         if y == x:
#             continue
#         for tiles in config['tiles']:
#             type = tiles['type']
#             x0 = tiles['x0']
#             y0 = tiles['y0']
#             dx0 = tiles['dx0']
#             dy0 = tiles['dy0']

#             for yy in [y0, y0 + dy0]:
#                 for xx in [x0, x0 + dx0]:




#         dx += DX

# for transform in config['transforms']:
#     type = transform['type']
#     gradient = gradients[type]
#     weight = transform['weight']
#     tiles = config['tilesets'][transform['tileset']]['tiles']
#     for p1 in range(0, len(tiles)):

#         # all_result_tiles.append(tile1)
#         # all_result_data.append(tile1_data)
#         # rotate_image_and_data_and_push(tile1, tile1_data)

#         for p2 in range(p1 + 1, len(tiles)):
#             tile1_data = tiles[p1]
#             tile1 = im.crop((tile1_data["x"] * SIZE, tile1_data["y"] * SIZE, (tile1_data["x"] + 1) * SIZE, (tile1_data["y"] + 1) * SIZE))
#             tile2_data = tiles[p2]
#             tile2 = im.crop((tile2_data["x"] * SIZE, tile2_data["y"] * SIZE, (tile2_data["x"] + 1) * SIZE, (tile2_data["y"] + 1) * SIZE))

#             res = Image.composite(tile1, tile2, gradient)
#             data = merge_data(tile1_data, tile2_data, type) | {"weight": weight}
#             all_result_tiles.append(res)
#             all_result_data.append(data)
#             rotate_image_and_data_and_push(res, data)

#             if transform['mirror']:
#                 mirror = res.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
#                 mirror_data = data | {"top": data['top'][::-1], "right": data['left'][::-1], "bottom": data['bottom'][::-1], "left": data['right'][::-1]}
#                 all_result_tiles.append(mirror)
#                 all_result_data.append(mirror_data)
#                 rotate_image_and_data_and_push(mirror, mirror_data)

# for tileset in config['tilesets'].values():
#     rotate = tileset['rotate']
#     weight = tileset['weight']

#     for tile in tileset['tiles']:
#         tile_im = im.crop((tile["x"] * SIZE, tile["y"] * SIZE, (tile["x"] + 1) * SIZE, (tile["y"] + 1) * SIZE))
#         data = tile | {"weight": weight}
#         all_result_tiles.append(tile_im)
#         all_result_data.append(data)
#         if rotate:
#             rotate_image_and_data_and_push(tile_im, data)

# ATLAS_LENGTH = 32

# atlas = Image.new("RGBA", (ATLAS_LENGTH * SIZE, (len(all_result_tiles) // ATLAS_LENGTH + 1) * SIZE))

# for i in range(0, len(all_result_tiles)):
#     x = i % ATLAS_LENGTH
#     y = i // ATLAS_LENGTH
#     atlas.paste(all_result_tiles[i], (x * SIZE, y * SIZE))
#     all_result_data[i]['x'] = x
#     all_result_data[i]['y'] = y

# atlas.save("atlas.png")
# with open('output_config.json', 'w', encoding='utf-8') as f:
#     json.dump(all_result_data, f, ensure_ascii=False, indent=4)

# box = (SIZE, SIZE, SIZE * 2, SIZE * 2)
# tile1 = im.crop(box)
# tile2 = im.crop((SIZE * 6, SIZE, SIZE * 7, SIZE * 2))


# tile1.save("tile1.png", "PNG")
# tile2.save("tile2.png", "PNG")
# mask.save("mask.png", "PNG")


# res = Image.composite(tile1, tile2, create_gradients(32)[0]).save("32.png")
# res = Image.composite(tile1, tile2, create_gradients(64)[0]).save("64.png")
# res = Image.composite(tile1, tile2, create_gradients(128)[0]).save("128.png")
# res = Image.composite(tile1, tile2, create_gradients(256)[0]).save("256.png")
# res.save("result.png", "PNG")

# black.show()
# mask.show()