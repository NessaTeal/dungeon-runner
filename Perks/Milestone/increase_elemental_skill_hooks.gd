extends PerkHooks

func on_upgrade():
	SaveData.instance.elemental_limit += 1

func on_downgrade():
	SaveData.instance.elemental_limit -= 1
	
func can_be_downgraded():
	return Perks.can_buy_elemental()
