/obj/item/weapon/storage/box/bloodpacks
	name = "blood packs bags"
	desc = "This box contains blood packs."
	icon_state = "sterile"

/obj/item/weapon/storage/box/bloodpacks/New()
		..()
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)

/obj/item/weapon/reagent_containers/blood
	name = "BloodPack"
	desc = "Contains blood used for transfusion."
	icon = 'icons/obj/bloodpack.dmi'
	icon_state = "empty"
	item_state = "bloodpack_empty"
	volume = 200

	var/blood_type = null

/obj/item/weapon/reagent_containers/blood/New()
	..()
	if(blood_type != null)
		name = "BloodPack [blood_type]"
		reagents.add_reagent("blood", 200, list("donor"=null,"viruses"=null,"blood_DNA"=null,"blood_type"=blood_type,"resistances"=null,"trace_chem"=null))
		update_icon()

/obj/item/weapon/reagent_containers/blood/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/blood/update_icon()
	var/percent = round((reagents.total_volume / volume) * 100)
	if(percent >= 0 && percent <= 9)
		icon_state = "empty"
		item_state = "bloodpack_empty"
	else if(percent >= 10 && percent <= 50)
		icon_state = "half"
		item_state = "bloodpack_half"
	else if(percent >= 51 && percent < INFINITY)
		icon_state = "full"
		item_state = "bloodpack_full"

/obj/item/weapon/reagent_containers/blood/APlus
	blood_type = "A+"

/obj/item/weapon/reagent_containers/blood/AMinus
	blood_type = "A-"

/obj/item/weapon/reagent_containers/blood/BPlus
	blood_type = "B+"

/obj/item/weapon/reagent_containers/blood/BMinus
	blood_type = "B-"

/obj/item/weapon/reagent_containers/blood/OPlus
	blood_type = "O+"

/obj/item/weapon/reagent_containers/blood/OMinus
	blood_type = "O-"

/obj/item/weapon/reagent_containers/blood/empty
	name = "Empty BloodPack"
	desc = "Seems pretty useless... Maybe if there were a way to fill it?"
	icon_state = "empty"
	item_state = "bloodpack_empty"