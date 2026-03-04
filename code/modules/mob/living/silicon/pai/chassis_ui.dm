// Pai chassis selection
/datum/tgui_module/pai_chassis
	name = "PAI Chassis Configurator"
	tgui_id = "PaiChoose"
	var/selected_chassis
	var/selected_color

/datum/tgui_module/pai_chassis/tgui_state(mob/user)
	return GLOB.tgui_self_state

/datum/tgui_module/pai_chassis/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet_batched/pai_icons),
	)

/datum/tgui_module/pai_chassis/tgui_static_data()
	var/list/data = ..()
	var/list/available_sprites = list()
	for(var/key, value in SSpai.get_chassis_list())
		var/datum/pai_sprite/current_sprite = value
		var/model_type = "def"
		if(istype(current_sprite, /datum/pai_sprite/large))
			model_type = "big"
		UNTYPED_LIST_ADD(available_sprites, list("sprite" = current_sprite.name, "belly" = current_sprite.belly_states, "type" = model_type))
	data["pai_chassises"] = available_sprites

	return data

/datum/tgui_module/pai_chassis/tgui_data()
	var/list/data = ..()

	var/mob/living/silicon/pai/pai_host = host
	data["pai_color"] = selected_color ? selected_color : pai_host.eye_color

	var/datum/pai_sprite/sprite_datum = SSpai.chassis_data(selected_chassis || pai_host.chassis_name)
	if(sprite_datum)
		var/datum/asset/spritesheet_batched/pai_icons/spritesheet = get_asset_datum(/datum/asset/spritesheet_batched/pai_icons)
		data["pai_chassis"] = sprite_datum.name
		data["selected_chassis"] = selected_chassis
		data["sprite_datum_class"] = sanitize_css_class_name("[sprite_datum.type]")
		data["sprite_datum_size"] = spritesheet.icon_size_id(data["sprite_datum_class"] + "S") // just get the south icon's size, the rest will be the same

	return data

/datum/tgui_module/pai_chassis/tgui_act(action, list/params,  datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("pick_icon")
			var/new_chassis = params["value"]
			if(new_chassis && (new_chassis in SSpai.get_chassis_list()))
				selected_chassis = new_chassis
			return TRUE
		if("confirm")
			if(!selected_chassis)
				return FALSE
			var/mob/living/silicon/pai/pai_host = host
			if(selected_color)
				pai_host.eye_color = selected_color
			pai_host.change_chassis(selected_chassis)
			return TRUE
		if("change_color")
			var/new_color = sanitize_hexcolor(params["color"])
			if(!new_color)
				return FALSE
			selected_color = new_color
			return TRUE
