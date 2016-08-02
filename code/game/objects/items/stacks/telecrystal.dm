/obj/item/stack/telecrystal
	name = "telecrystal"
	desc = "It seems to be pulsing with suspiciously enticing energies."
	description_antag = "Telecrystals can be activated by utilizing them on devices with an actively running uplink. They will not activate on unactivated uplinks."
	singular_name = "telecrystal"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "telecrystal"
	w_class = 1
	max_amount = 240
	flags = NOBLUDGEON
	origin_tech = list(TECH_MATERIAL = 6, TECH_BLUESPACE = 4)

/obj/item/stack/telecrystal/afterattack(var/obj/item/I as obj, mob/user as mob, proximity)
	if(!proximity)
		return
	if(istype(I, /obj/item))
		if(I.hidden_uplink && I.hidden_uplink.active) //No metagaming by using this on every PDA around just to see if it gets used up.
			I.hidden_uplink.uses += amount
			I.hidden_uplink.update_nano_data()
			nanomanager.update_uis(I.hidden_uplink)
			use(amount)
			user << "<span class='notice'>You slot \the [src] into \the [I] and charge its internal uplink.</span>"

/obj/item/stack/telecrystal/attack_self(mob/user as mob)
	if(user.mind.accept_tcrystals) //Checks to see if antag type allows for tcrystals
		user << "<span class='notice'>You use \the [src], adding [src.amount] to your balance.</span>"
		user.mind.tcrystals += amount
		use(amount)
	return