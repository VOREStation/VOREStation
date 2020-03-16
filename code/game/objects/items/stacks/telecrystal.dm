/obj/item/stack/telecrystal
	name = "telecrystal"
	desc = "It seems to be pulsing with suspiciously enticing energies."
	description_antag = "Telecrystals can be activated by utilizing them on devices with an actively running uplink. They will not activate on unactivated uplinks."
	singular_name = "telecrystal"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "telecrystal"
	w_class = ITEMSIZE_TINY
	max_amount = 240
	origin_tech = list(TECH_MATERIAL = 6, TECH_BLUESPACE = 4)
	force = 1 //Needs a token force to ensure you can attack because for some reason you can't attack with 0 force things

/obj/item/stack/telecrystal/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	if(amount >= 5)
		target.visible_message("<span class='warning'>\The [target] has been transported with \the [src] by \the [user].</span>")
		safe_blink(target, 14)
		use(5)
	else
		to_chat(user, "<span class='warning'>There are not enough telecrystals to do that.</span>")

/obj/item/stack/telecrystal/attack_self(mob/user as mob)
	if(user.mind.accept_tcrystals) //Checks to see if antag type allows for tcrystals
		to_chat(user, "<span class='notice'>You use \the [src], adding [src.amount] to your balance.</span>")
		user.mind.tcrystals += amount
		use(amount)
	return