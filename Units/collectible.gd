extends Area3D
class_name Collectible

enum Type {
	Apples,
	Grit,
	Souls,
	Culture,
	Count
}

static var apples: int:
	set(value):
		SaveData.instance.collected_resources_data[Type.Apples] = value
	get:
		return SaveData.instance.collected_resources_data[Type.Apples]

static var grit: float:
	set(value):
		SaveData.instance.collected_resources_data[Type.Grit] = value
	get:
		return SaveData.instance.collected_resources_data[Type.Grit]

static var souls: int:
	set(value):
		SaveData.instance.collected_resources_data[Type.Souls] = value
	get:
		return SaveData.instance.collected_resources_data[Type.Souls]

static var culture: int:
	set(value):
		SaveData.instance.collected_resources_data[Type.Culture] = value
	get:
		return SaveData.instance.collected_resources_data[Type.Culture]
