/obj/item/weapon/flame/candle/scented
	name = "scented candle"
	desc = "A candle which releases pleasant-smelling oils into the air when burned."

	var/scent //for the desc
	var/decl/scent_type/style
	var/list/scent_types = list(/decl/scent_type/rose,
								/decl/scent_type/cinnamon,
								/decl/scent_type/vanilla,
								/decl/scent_type/seabreeze,
								/decl/scent_type/lavender)

/obj/item/weapon/flame/candle/scented/Initialize()
	. = ..()
	get_scent()

/obj/item/weapon/flame/candle/scented/attack_self(mob/user as mob)
	..()
	if(!lit)
		remove_extension(src, /datum/scent)

/obj/item/weapon/flame/candle/scented/extinguish(var/mob/user, var/no_message)
	..()
	remove_extension(src, /datum/scent)

/obj/item/weapon/flame/candle/scented/light(mob/user)
	..()
	if(lit)
		set_extension(src, style.scent_datum)

/obj/item/weapon/flame/candle/scented/proc/get_scent()
	var/scent_type = DEFAULTPICK(scent_types, null)
	if(scent_type)
		style = decls_repository.get_decl(scent_type)
		color = style.color
		scent = style.scent
	if(scent)
		desc += " This one smells of [scent]."
	update_icon()

