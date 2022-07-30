/obj/item/selectable_item
	name = "selectable item"
	desc = "If you find this, you should definitely report this..."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"
	var/preface_string = "You are about to select an item. Are you sure you want to use it and select one?"
	var/preface_title = "selectable item"
	var/selection_string = "Select an item:"
	var/selection_title = "Item Selection"
	var/list/item_options = list("Gift" = /obj/item/a_gift,
								 "Health Analyzer" = /obj/item/healthanalyzer)

/obj/item/selectable_item/attack_self(mob/user as mob)
	tgui_alert(user, {"[preface_string]"}, preface_title)
	var/chosen_item = tgui_input_list(usr, selection_string, selection_title, item_options)
	chosen_item = item_options[chosen_item]
	if(!QDELETED(src) && chosen_item)
		user.drop_item()
		var/obj/item/result = new chosen_item(get_turf(user))
		user.put_in_active_hand(result)
		result.add_fingerprint(user)
		qdel(src)
	return


/obj/item/selectable_item/chemistrykit
	icon = 'icons/obj/chemical_vr.dmi'
	icon_state = "chemkit"
	selection_string = "Select a chemical:"
	selection_title = "Chemical Selection"

/obj/item/selectable_item/chemistrykit/size
	name = "size chemistry kit"
	desc = "A pre-arranged home chemistry kit. This one is for rather specific set of size-altering chemicals."
	preface_string = "This kit can be used to create a vial of a size-altering chemical, but there's only enough material for one."
	preface_title = "Size Chemistry Kit"
	item_options = list("Macrocillin" = /obj/item/reagent_containers/glass/beaker/vial/macrocillin,
						"Microcillin" = /obj/item/reagent_containers/glass/beaker/vial/microcillin,
						"Normalcillin" = /obj/item/reagent_containers/glass/beaker/vial/normalcillin)

/obj/item/selectable_item/chemistrykit/gender
	name = "gender chemistry kit"
	desc = "A pre-arranged home chemistry kit. This one is for rather specific set of gender-altering chemicals."
	preface_string = "This kit can be used to create a vial of a gender-altering chemical, but there's only enough material for one."
	preface_title = "Gender Chemistry Kit"
	item_options = list("Androrovir" = /obj/item/reagent_containers/glass/beaker/vial/androrovir,
						"Gynorovir" = /obj/item/reagent_containers/glass/beaker/vial/gynorovir,
						"Androgynorovir" = /obj/item/reagent_containers/glass/beaker/vial/androgynorovir)
