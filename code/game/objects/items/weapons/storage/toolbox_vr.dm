/obj/item/storage/toolbox/lunchbox/survival
	name = "survival lunchbox"
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "lunchbox_survival"
	item_state_slots = list(slot_r_hand_str = "toolbox_syndi", slot_l_hand_str = "toolbox_syndi")
	desc = "A little lunchbox. This one seems to be much sturdier than normal, made of a durable steel!"
	max_storage_space = ITEMSIZE_COST_SMALL * 6

/obj/item/storage/toolbox/lunchbox/survival/zaddat
	name = "zaddat survival lunchbox"
	starts_with = list(/obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose = 6)
