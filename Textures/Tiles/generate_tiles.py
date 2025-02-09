import math
import json
from PIL import Image, ImageFilter

def create_gradients(extra_fill):
    grad = Image.linear_gradient("L")

    black = Image.new("L", (256, extra_fill))
    white = Image.new("L", (256, extra_fill), 255)

    mask = Image.new("L", (256, 256 + extra_fill * 2))
    mask.paste(black)
    mask.paste(grad, (0, extra_fill))
    mask.paste(white, (0, 256 + extra_fill))

    mask = mask.resize((128,128), Image.Resampling.BICUBIC)

    offset = math.sin(math.radians(45)) * 128
    rot = mask.rotate(45, Image.Resampling.NEAREST, True)
    rot = rot.crop((offset / 2, offset / 2, offset * 1.5, offset * 1.5)).resize((128, 128), Image.Resampling.BICUBIC)

    return {'linear': mask, 'angular': rot}

def merge_date_at_angle(tile1_data, tile2_data):
    return {"top": tile1_data['top'], "right": tile2_data['right'], "bottom": tile2_data['bottom'], "left": tile1_data['left']}

def rotate_image_and_data_and_push(image, data):
    rot = image.transpose(Image.Transpose.ROTATE_90)
    rot_data = {"top": data['right'], "right": data['bottom'], "bottom": data['left'], "left": data['top']}
    all_result_tiles.append(rot)
    all_result_data.append(rot_data)

    rot = image.transpose(Image.Transpose.ROTATE_180)
    rot_data = {"top": rot_data['right'], "right": rot_data['bottom'], "bottom": rot_data['left'], "left": rot_data['top']}
    all_result_tiles.append(rot)
    all_result_data.append(rot_data)

    rot = image.transpose(Image.Transpose.ROTATE_270)
    rot_data = {"top": rot_data['right'], "right": rot_data['bottom'], "bottom": rot_data['left'], "left": rot_data['top']}
    all_result_tiles.append(rot)
    all_result_data.append(rot_data)

SIZE = 128
GRADIENT_MARGIN = 2048
gradients = create_gradients(GRADIENT_MARGIN)

config = json.load(open("input_config.json"))
im = Image.open("towerDefense_tilesheet@2.png")

all_result_tiles = []
all_result_data = []

for transform in config['transforms']:
    gradient =  gradients[transform['type']]
    tiles = config['tilesets'][transform['tileset']]
    for p1 in range(0, len(tiles)):
        for p2 in range(p1 + 1, len(tiles)):
            tile1_data = tiles[p1]
            tile2_data = tiles[p2]

            tile1 = im.crop((tile1_data["x"] * SIZE, tile1_data["y"] * SIZE, (tile1_data["x"] + 1) * SIZE, (tile1_data["y"] + 1) * SIZE))
            tile2 = im.crop((tile2_data["x"] * SIZE, tile2_data["y"] * SIZE, (tile2_data["x"] + 1) * SIZE, (tile2_data["y"] + 1) * SIZE))
            res = Image.composite(tile1, tile2, gradient)
            data = merge_date_at_angle(tile1_data, tile2_data)
            all_result_tiles.append(res)
            all_result_data.append(data)
            rotate_image_and_data_and_push(res, data)

            if transform['mirror']:
                mirror = res.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
                mirror_data = {"top": data['top'], "right": data['left'], "bottom": data['bottom'], "left": data['right']}
                all_result_tiles.append(mirror)
                all_result_data.append(mirror_data)
                rotate_image_and_data_and_push(mirror, mirror_data)

ATLAS_LENGTH = 20

atlas = Image.new("RGBA", (ATLAS_LENGTH * SIZE, (len(all_result_tiles) // ATLAS_LENGTH + 1) * SIZE))

for i in range(0, len(all_result_tiles)):
    x = i % ATLAS_LENGTH
    y = i // ATLAS_LENGTH
    atlas.paste(all_result_tiles[i], (x * SIZE, y * SIZE))
    all_result_data[i]['x'] = x
    all_result_data[i]['y'] = y

atlas.save("atlas.png")
with open('output.json', 'w', encoding='utf-8') as f:
    json.dump(all_result_data, f, ensure_ascii=False, indent=4)

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