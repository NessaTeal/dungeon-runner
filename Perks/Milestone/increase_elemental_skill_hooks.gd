extends PerkHooks

func on_upgrade():
	Meta.save_data.elemental_limit += 1

func on_downgrade():
	Meta.save_data.elemental_limit -= 1
	
func can_be_downgraded():
	return Perks.can_buy_elemental()
