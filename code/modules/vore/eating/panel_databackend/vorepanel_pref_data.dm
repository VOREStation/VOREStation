/datum/vore_look/proc/get_preference_data(mob/owner)
	return list(
		"digestable" = owner.digestable,
		"devourable" = owner.devourable,
		"resizable" = owner.resizable,
		"feeding" = owner.feeding,
		"absorbable" = owner.absorbable,
		"digest_leave_remains" = owner.digest_leave_remains,
		"allowmobvore" = owner.allowmobvore,
		"permit_healbelly" = owner.permit_healbelly,
		"show_vore_fx" = owner.show_vore_fx,
		"can_be_drop_prey" = owner.can_be_drop_prey,
		"can_be_drop_pred" = owner.can_be_drop_pred,
		"latejoin_vore" = owner.latejoin_vore,
		"latejoin_prey" = owner.latejoin_prey,
		"no_spawnpred_warning" = owner.no_latejoin_vore_warning,
		"no_spawnprey_warning" = owner.no_latejoin_prey_warning,
		"no_spawnpred_warning_time" = owner.no_latejoin_vore_warning_time,
		"no_spawnprey_warning_time" = owner.no_latejoin_prey_warning_time,
		"no_spawnpred_warning_save" = owner.no_latejoin_vore_warning_persists,
		"no_spawnprey_warning_save" = owner.no_latejoin_prey_warning_persists,
		"allow_spontaneous_tf" = owner.allow_spontaneous_tf,
		"step_mechanics_active" = owner.step_mechanics_pref,
		"pickup_mechanics_active" = owner.pickup_pref,
		"strip_mechanics_active" = owner.strip_pref,
		"noisy" = owner.noisy,
		//liquid belly prefs
		"liq_rec" = owner.receive_reagents,
		"liq_giv" = owner.give_reagents,
		"liq_apply" = owner.apply_reagents,
		"autotransferable" = owner.autotransferable,
		"noisy_full" = owner.noisy_full, //Belching while full
		"selective_active" = owner.selective_preference, //Reveal active selective mode in prefs

		"allow_mind_transfer" = owner.allow_mind_transfer,
		"drop_vore" = owner.drop_vore,
		"slip_vore" = owner.slip_vore,
		"stumble_vore" = owner.stumble_vore,
		"throw_vore" = owner.throw_vore,
		"phase_vore" = owner.phase_vore,
		"food_vore" = owner.food_vore,
		"consume_liquid_belly" = owner.consume_liquid_belly,
		"digest_pain" = owner.digest_pain,
		"eating_privacy_global" = owner.eating_privacy_global,
		"allow_mimicry" = owner.allow_mimicry,
		//Soulcatcher
		"soulcatcher_allow_capture" = owner.soulcatcher_pref_flags & SOULCATCHER_ALLOW_CAPTURE,
		"soulcatcher_allow_transfer" = owner.soulcatcher_pref_flags & SOULCATCHER_ALLOW_TRANSFER,
		"soulcatcher_allow_takeover" = owner.soulcatcher_pref_flags & SOULCATCHER_ALLOW_TAKEOVER,
		"soulcatcher_allow_deletion" = (global_flag_check(owner.soulcatcher_pref_flags, SOULCATCHER_ALLOW_DELETION) + global_flag_check(owner.soulcatcher_pref_flags, SOULCATCHER_ALLOW_DELETION_INSTANT))
	)

#define SET_TASTE "Set Taste"
#define SET_SMELL "Set Smell"
#define SET_NUTRITION_EX "Set Nutrition Examine"
#define SET_WEIGHT_EX "Set Weight Examine"

/datum/vore_look/proc/get_general_data(mob/owner)
	return list(
		"active_belly" = owner.vore_selected?.name,
		"belly_rub_target" = owner.belly_rub_target,
		// start, vore sprites
		"aestethic_messages" = compile_aesthetic_messages(owner),
		"vore_sprite_color" = owner.vore_sprite_color,
		"vore_sprite_multiply" = owner.vore_sprite_multiply,
		"vore_icon_options" = owner.vore_icon_bellies
	)

/datum/vore_look/proc/compile_aesthetic_messages(mob/owner)
	if(!aset_message_subtab)
		aset_message_subtab = SET_TASTE
	var/list/tab_data = list(
		"possible_messages" = list(SET_TASTE, SET_SMELL, SET_NUTRITION_EX, SET_WEIGHT_EX),
		"aest_subtab" = aset_message_subtab
		)
	if(aset_message_subtab == SET_TASTE)
		tab_data["max_length"] = FLAVOR_MAX
		tab_data["active_message"] = owner.vore_taste
		tab_data["set_action"] = TASTE_FLAVOR
		tab_data["tooltip"] = "What your character tastes like. This text will be printed to the pred after 'X tastes of...' so just put something like 'strawberries and cream'"
	if(aset_message_subtab == SET_SMELL)
		tab_data["max_length"] = FLAVOR_MAX
		tab_data["active_message"] = owner.vore_smell
		tab_data["set_action"] = SMELL_FLAVOR
		tab_data["tooltip"] = "What your character smells like. This text will be printed to the pred after 'X smells of...' so just put something like 'strawberries and cream'"
	if(aset_message_subtab == SET_NUTRITION_EX)
		tab_data["max_length"] = BELLIES_EXAMINE_MAX
		tab_data["active_message"] = owner.nutrition_messages
		tab_data["set_action"] = "set_attribute"
		tab_data["sub_action"] = GENERAL_EXAMINE_NUTRI
		tab_data["tooltip"] = "Change the nutrition display messages on examine."
		tab_data["button_label"] = "Display Nutrition Examine"
		tab_data["button_action"] = "toggle_nutrition_ex"
		tab_data["button_data"] = owner.nutrition_message_visible
		tab_data["button_tooltip"] = "the nutition messages on examine." // those will automatically be preceeded by Enables / Disables!
	if(aset_message_subtab == SET_WEIGHT_EX)
		tab_data["max_length"] = BELLIES_EXAMINE_MAX
		tab_data["active_message"] = owner.weight_messages
		tab_data["set_action"] = "set_attribute"
		tab_data["sub_action"] = GENERAL_EXAMINE_WEIGHT
		tab_data["tooltip"] = "Change the weight display messages on examine."
		tab_data["button_label"] = "Display Weight Examine"
		tab_data["button_action"] = "toggle_weight_ex"
		tab_data["button_data"] = owner.weight_message_visible
		tab_data["button_tooltip"] = "the weight messages on examine." // those will automatically be preceeded by Enables / Disables!
	return tab_data

#undef SET_TASTE
#undef SET_SMELL
#undef SET_NUTRITION_EX
#undef SET_WEIGHT_EX
