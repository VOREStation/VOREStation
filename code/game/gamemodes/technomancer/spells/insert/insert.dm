/obj/item/weapon/spell/insert
	name = "insert template"
	desc = "Tell a coder if you can read this in-game."
	icon_state = "purify"
	cast_methods = CAST_MELEE
	var/spell_color = "#03A728"
	var/obj/item/weapon/inserted_spell/inserting = null

/obj/item/weapon/spell/insert/New()
	..()
	set_light(3, 2, l_color = light_color)

/obj/item/weapon/inserted_spell
	var/mob/living/carbon/human/origin = null
	var/mob/living/host = null

/obj/item/weapon/inserted_spell/New(var/newloc, var/user, var/spell_color)
	..(newloc)
	host = newloc
	origin = user
	if(light_color)
		set_light(3, 2, l_color = spell_color)
	on_insert()

/obj/item/weapon/inserted_spell/proc/on_insert()
	return

/obj/item/weapon/spell/insert/proc/insert(var/mob/living/L, mob/user)
	world << "insert() called"
	if(inserting)
		new inserting(L,user,light_color)
		qdel(src)

/obj/item/weapon/spell/insert/on_melee_cast(atom/hit_atom, mob/user)
	if(istype(hit_atom, /mob/living))
		var/mob/living/L = hit_atom
		insert(L,user)