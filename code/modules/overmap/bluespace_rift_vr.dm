/obj/effect/overmap/bluespace_rift
	name = "bluespace rift"
	desc = "Some sort of bluespace rift. Who knows where it leads?"
	icon = 'icons/obj/overmap_vr.dmi'
	icon_state = "portal"
	color = "#2288FF"
	scannable = TRUE       //if set to TRUE will show up on ship sensors for detailed scans

	var/obj/effect/overmap/bluespace_rift/partner
	var/paused

/obj/effect/overmap/bluespace_rift/Initialize(var/mapload, var/new_partner)
	. = ..()
	if(new_partner)
		pair(new_partner)
	
/obj/effect/overmap/bluespace_rift/proc/pair(var/obj/effect/overmap/bluespace_rift/new_partner)
	if(istype(new_partner))
		partner = new_partner
		new_partner.partner = src

/obj/effect/overmap/bluespace_rift/proc/take_this(var/atom/movable/AM)
	paused = TRUE
	AM.forceMove(get_turf(src))
	paused = FALSE

/obj/effect/overmap/bluespace_rift/Crossed(var/atom/movable/AM)
	if(istype(AM, /obj/effect/overmap/visitable/ship) && !paused && partner)
		partner.take_this(AM)
	else
		return ..()

/obj/effect/overmap/bluespace_rift/attack_ghost(var/mob/observer/dead/user)
	if(!partner && user?.client?.holder)
		var/response = tgui_alert(user, "You appear to be staff. This rift has no exit point. If you want to make one, move to where you want it to go, and click 'Make Here', otherwise click 'Cancel'", "Bluespace Rift", list("Cancel","Make Here"))
		if(response == "Make Here")
			new type(get_turf(user), src)
	else if(partner)
		user.forceMove(get_turf(partner))
		to_chat(user, "<span class='notice'>Your ghostly form is pulled through the rift!</span>")
	else
		return ..()
