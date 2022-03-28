/obj/item/weapon/gun/energy/xenobio
	name = "xenobio gun"
	desc = "You shouldn't see this!"
	icon_state = "taserblue"
	fire_sound = 'sound/weapons/taser2.ogg'
	charge_cost = 120 // Twice as many shots.
	projectile_type = /obj/item/projectile/beam/stun/xeno // Place holder for now
	accuracy = 30 // Just use the same hit rate as xenotasers
	var/loadable_item = null
	var/loaded_item = null

/obj/item/weapon/gun/energy/xenobio/examine(var/mob/user)
	. = ..()
	if(loaded_item)
		.+= "A [loaded_item] is slotted into the side."
	else
		.+= "There appears to be an empty slot for attaching a [loadable_item]."

/obj/item/weapon/gun/energy/xenobio/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, loadable_item))
		if(loaded_item)
			to_chat(user, "<font color='blue'>[I] doesn't seem to fit into [src].</font>")
			return
		//var/obj/item/weapon/reagent_containers/glass/beaker/B = I
		user.drop_item()
		I.loc = src
		loaded_item = I
		to_chat(user, "<font color='blue'>You slot [B] into [src].</font>")
		return 1
	..()
/obj/item/weapon/gun/energy/xenobio/monkey_gun
	name = "Bluespace Cube Rehydrater"
	desc = "This advanced weapon will rehydrate and deploy a loaded cube at your target position."
	loadable_item = /obj/item/weapon/reagent_containers/food/snacks/monkeycube

/obj/item/weapon/gun/energy/xenobio/potion_gun
	name = "Ranged Potion Delivery Device"
	desc = "This device is designed to deliver a potion to your target at range, it has a slot to attach a xenobio potion.
	loadable_item = /obj/item/slimepotion

/obj/item/weapon/gun/energy/xenobio/extract_gun
	name = "Ranged Extract Interaction Device"
	desc = "This is the latest in extract interaction technology! No longer shall you stand in harms way when activating a gold slime."
	loadable_item = /obj/item/slime_extract