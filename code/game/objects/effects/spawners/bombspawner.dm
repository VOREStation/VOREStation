/client/proc/spawn_tanktransferbomb()
	set category = "Debug"
	set desc = "Spawn a tank transfer valve bomb"
	set name = "Instant TTV"

	if(!check_rights(R_SPAWN)) return

	var/obj/effect/spawner/newbomb/proto = /obj/effect/spawner/newbomb/radio/custom

	var/p = input(usr, "Enter phoron amount (mol):","Phoron", initial(proto.phoron_amt)) as num|null
	if(p == null) return

	var/o = input(usr, "Enter oxygen amount (mol):","Oxygen", initial(proto.oxygen_amt)) as num|null
	if(o == null) return

	var/c = input(usr, "Enter carbon dioxide amount (mol):","Carbon Dioxide", initial(proto.carbon_amt)) as num|null
	if(c == null) return

	new /obj/effect/spawner/newbomb/radio/custom(get_turf(mob), p, o, c)

/obj/effect/spawner/newbomb
	name = "TTV bomb"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"

	var/assembly_type = /obj/item/assembly/signaler

	//Note that the maximum amount of gas you can put in a 70L air tank at 1013.25 kPa and 519K is 16.44 mol.
	var/phoron_amt = 12
	var/oxygen_amt = 18
	var/carbon_amt = 0

/obj/effect/spawner/newbomb/timer
	name = "TTV bomb - timer"
	assembly_type = /obj/item/assembly/timer

/obj/effect/spawner/newbomb/timer/syndicate
	name = "TTV bomb - merc"
	//High yield bombs. Yes, it is possible to make these with toxins
	phoron_amt = 18.5
	oxygen_amt = 28.5

/obj/effect/spawner/newbomb/proximity
	name = "TTV bomb - proximity"
	assembly_type = /obj/item/assembly/prox_sensor

/obj/effect/spawner/newbomb/radio/custom/New(var/newloc, ph, ox, co)
	if(ph != null) phoron_amt = ph
	if(ox != null) oxygen_amt = ox
	if(co != null) carbon_amt = co
	..()
<<<<<<< HEAD

/obj/effect/spawner/newbomb/Initialize(newloc)
	..(newloc)
	var/obj/item/device/transfer_valve/V = new(src.loc)
	var/obj/item/weapon/tank/phoron/PT = new(V)
	var/obj/item/weapon/tank/oxygen/OT = new(V)
=======
	var/obj/item/transfer_valve/V = new(src.loc)
	var/obj/item/tank/phoron/PT = new(V)
	var/obj/item/tank/oxygen/OT = new(V)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

	V.tank_one = PT
	V.tank_two = OT

	PT.master = V
	OT.master = V

	PT.valve_welded = 1
	PT.air_contents.gas["phoron"] = phoron_amt
	PT.air_contents.gas["carbon_dioxide"] = carbon_amt
	PT.air_contents.total_moles = phoron_amt + carbon_amt
	PT.air_contents.temperature = PHORON_MINIMUM_BURN_TEMPERATURE+1
	PT.air_contents.update_values()

	OT.valve_welded = 1
	OT.air_contents.gas["oxygen"] = oxygen_amt
	OT.air_contents.total_moles = oxygen_amt
	OT.air_contents.temperature = PHORON_MINIMUM_BURN_TEMPERATURE+1
	OT.air_contents.update_values()

	var/obj/item/assembly/S = new assembly_type(V)
	V.attached_device = S

	S.holder = V
	S.toggle_secure()

	V.update_icon()
	return INITIALIZE_HINT_QDEL


///////////////////////
//One Tank Bombs, WOOOOOOO! -Luke
///////////////////////

/obj/effect/spawner/onetankbomb
	name = "Single-tank bomb"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"

//	var/assembly_type = /obj/item/assembly/signaler

	//Note that the maximum amount of gas you can put in a 70L air tank at 1013.25 kPa and 519K is 16.44 mol.
	var/phoron_amt = 0
	var/oxygen_amt = 0

<<<<<<< HEAD
/obj/effect/spawner/onetankbomb/New(newloc) //just needs an assembly.
	..(newloc)

	var/type = pick(/obj/item/weapon/tank/phoron/onetankbomb, /obj/item/weapon/tank/oxygen/onetankbomb)
=======
/obj/effect/spawner/onetankbomb/Initialize() //just needs an assembly.
	..()
	var/type = pick(/obj/item/tank/phoron/onetankbomb, /obj/item/tank/oxygen/onetankbomb)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	new type(src.loc)

	qdel(src)

/obj/effect/spawner/onetankbomb/full
	name = "Single-tank bomb"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"

//	var/assembly_type = /obj/item/assembly/signaler

	//Note that the maximum amount of gas you can put in a 70L air tank at 1013.25 kPa and 519K is 16.44 mol.
<<<<<<< HEAD
/obj/effect/spawner/onetankbomb/full/New(newloc) //just needs an assembly.
	..(newloc)

	var/type = pick(/obj/item/weapon/tank/phoron/onetankbomb/full, /obj/item/weapon/tank/oxygen/onetankbomb/full)
=======
/obj/effect/spawner/onetankbomb/full/Initialize() //just needs an assembly.
	. = ..()
	var/type = pick(/obj/item/tank/phoron/onetankbomb/full, /obj/item/tank/oxygen/onetankbomb/full)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	new type(src.loc)

	qdel(src)

/obj/effect/spawner/onetankbomb/frag
	name = "Single-tank bomb"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"

//	var/assembly_type = /obj/item/assembly/signaler

	//Note that the maximum amount of gas you can put in a 70L air tank at 1013.25 kPa and 519K is 16.44 mol.
<<<<<<< HEAD
/obj/effect/spawner/onetankbomb/full/New(newloc) //just needs an assembly.
	..(newloc)

	var/type = pick(/obj/item/weapon/tank/phoron/onetankbomb/full, /obj/item/weapon/tank/oxygen/onetankbomb/full)
	new type(src.loc)

	qdel(src)


=======
/obj/effect/spawner/onetankbomb/frag/Initialize() //just needs an assembly.
	. = ..()
	var/type = pick(/obj/item/tank/phoron/onetankbomb/full, /obj/item/tank/oxygen/onetankbomb/full)
	new type(src.loc)	
	return INITIALIZE_HINT_QDEL
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
