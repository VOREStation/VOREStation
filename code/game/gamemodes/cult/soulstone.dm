/////////////////////////
//		Soulstone
/////////////////////////

/obj/item/soulstone
	name = "Soul Stone Shard"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "soulstone"
	item_state = "electronic"
	desc = "A fragment of the legendary treasure known simply as the 'Soul Stone'. The shard still flickers with a fraction of the full artefacts power."
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 4, TECH_ARCANE = 1)
	var/imprinted = "empty"
	var/possible_constructs = list("Juggernaut","Wraith","Artificer","Harvester")

/obj/item/soulstone/cultify()
	return

//////////////////////////////Capturing////////////////////////////////////////////////////////

/obj/item/soulstone/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	if(!ishuman(M))//If target is not a human.
		return ..()
	if(istype(M, /mob/living/carbon/human/dummy))
		return..()
	if(jobban_isbanned(M, JOB_CULTIST))
		to_chat(user, span_warning("This person's soul is too corrupt and cannot be captured!"))
		return..()

	if(M.has_brain_worms()) //Borer stuff - RR
		to_chat(user, span_warning("This being is corrupted by an alien intelligence and cannot be soul trapped."))
		return..()

	add_attack_logs(user,M,"Soulstone'd with [src.name]")
	transfer_soul("VICTIM", M, user)
	return


///////////////////Options for using captured souls///////////////////////////////////////

/obj/item/soulstone/attack_self(mob/user)
	if (!in_range(src, user))
		return
	user.set_machine(src)
	var/dat = "<html><TT><B>Soul Stone</B><BR>"
	for(var/mob/living/simple_mob/construct/shade/A in src)
		dat += "Captured Soul: [A.name]<br>"
		dat += {"<A href='byond://?src=\ref[src];choice=Summon'>Summon Shade</A>"}
		dat += "<br>"
		dat += {"<a href='byond://?src=\ref[src];choice=Close'> Close</a></html>"}
	user << browse(dat, "window=aicard")
	onclose(user, "aicard")
	return




/obj/item/soulstone/Topic(href, href_list)
	var/mob/U = usr
	if (!in_range(src, U)||U.machine!=src)
		U << browse(null, "window=aicard")
		U.unset_machine()
		return

	add_fingerprint(U)
	U.set_machine(src)

	switch(href_list["choice"])//Now we switch based on choice.
		if ("Close")
			U << browse(null, "window=aicard")
			U.unset_machine()
			return

		if ("Summon")
			for(var/mob/living/simple_mob/construct/shade/A in src)
				A.RemoveElement(/datum/element/godmode)
				A.canmove = 1
				to_chat(A, span_infoplain(span_bold("You have been released from your prison, but you are still bound to [U.name]'s will. Help them suceed in their goals at all costs.")))
				A.forceMove(U.loc)
				A.cancel_camera()
				src.icon_state = "soulstone"
	attack_self(U)

///////////////////////////Transferring to constructs/////////////////////////////////////////////////////
/obj/structure/constructshell
	name = "empty shell"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "construct"
	desc = "A wicked machine used by those skilled in magical arts. It is inactive."

/obj/structure/constructshell/cultify()
	return

/obj/structure/constructshell/cult
	icon_state = "construct-cult"
	desc = "This eerie contraption looks like it would come alive if supplied with a missing ingredient."

/obj/structure/constructshell/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/soulstone))
		var/obj/item/soulstone/S = O;
		S.transfer_soul("CONSTRUCT",src,user)


////////////////////////////Proc for moving soul in and out off stone//////////////////////////////////////
/obj/item/soulstone/proc/transfer_human(var/mob/living/carbon/human/T,var/mob/U)
	if(!istype(T))
		return;
	if(src.imprinted != "empty")
		to_chat(U, span_danger("Capture failed!") + ": The soul stone has already been imprinted with [src.imprinted]'s mind!")
		return
	if ((T.health + T.halloss) > T.get_crit_point() && T.stat != DEAD)
		to_chat(U, span_danger("Capture failed!") + ": Kill or maim the victim first!")
		return
	if(T.client == null)
		to_chat(U, span_danger("Capture failed!") + ": The soul has already fled it's mortal frame.")
		return
	if(src.contents.len)
		to_chat(U, span_danger("Capture failed!") + ": The soul stone is full! Use or free an existing soul to make room.")
		return

	for(var/obj/item/W in T)
		T.drop_from_inventory(W)

	new /obj/effect/decal/remains/human(T.loc) //Spawns a skeleton
	T.invisibility = INVISIBILITY_ABSTRACT

	var/atom/movable/overlay/animation = new /atom/movable/overlay( T.loc )
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = T
	flick("dust-h", animation)
	qdel(animation)

	var/mob/living/simple_mob/construct/shade/S = new /mob/living/simple_mob/construct/shade( T.loc )
	S.forceMove(src) //put shade in stone
	S.AddElement(/datum/element/godmode)
	S.canmove = 0//Can't move out of the soul stone
	S.name = "Shade of [T.real_name]"
	S.real_name = "Shade of [T.real_name]"
	S.icon = T.icon
	S.icon_state = T.icon_state
	S.overlays = T.overlays
	S.color = rgb(254,0,0)
	S.alpha = 127
	if (T.client)
		T.client.mob = S
	S.cancel_camera()


	src.icon_state = "soulstone2"
	src.name = "Soul Stone: [S.real_name]"
	to_chat(S, "Your soul has been captured! You are now bound to [U.name]'s will, help them suceed in their goals at all costs.")
	to_chat(U, span_notice("Capture successful!") + ": [T.real_name]'s soul has been ripped from their body and stored within the soul stone.")
	to_chat(U, "The soulstone has been imprinted with [S.real_name]'s mind, it will no longer react to other souls.")
	src.imprinted = "[S.name]"
	qdel(T)

/obj/item/soulstone/proc/transfer_shade(var/mob/living/simple_mob/construct/shade/T,var/mob/U)
	if(!istype(T))
		return;
	if (T.stat == DEAD)
		to_chat(U, span_danger("Capture failed!") + ": The shade has already been banished!")
		return
	if(src.contents.len)
		to_chat(U, span_danger("Capture failed!") + ": The soul stone is full! Use or free an existing soul to make room.")
		return
	if(T.name != src.imprinted)
		to_chat(U, span_danger("Capture failed!") + ": The soul stone has already been imprinted with [src.imprinted]'s mind!")
		return

	T.forceMove(src) //put shade in stone
	T.AddElement(/datum/element/godmode)
	T.canmove = 0
	T.health = T.getMaxHealth()
	src.icon_state = "soulstone2"

	to_chat(T, "Your soul has been recaptured by the soul stone, its arcane energies are reknitting your ethereal form")
	to_chat(U, span_notice("Capture successful!") + ": [T.name]'s has been recaptured and stored within the soul stone.")

/obj/item/soulstone/proc/transfer_construct(var/obj/structure/constructshell/T,var/mob/U)
	var/mob/living/simple_mob/construct/shade/A = locate() in src
	if(!A)
		to_chat(U, span_danger("Capture failed!") + ": The soul stone is empty! Go kill someone!")
		return;
	var/construct_class = tgui_input_list(U, "Please choose which type of construct you wish to create.", "Construct Type", possible_constructs)
	switch(construct_class)
		if("Juggernaut")
			var/mob/living/simple_mob/construct/juggernaut/Z = new /mob/living/simple_mob/construct/juggernaut (get_turf(T.loc))
			Z.key = A.key
			if(iscultist(U))
				cult.add_antagonist(Z.mind)
			qdel(T)
			to_chat(Z, span_infoplain(span_bold("You are playing a Juggernaut. Though slow, you can withstand extreme punishment, and rip apart enemies and walls alike.")))
			to_chat(Z, span_infoplain(span_bold("You are still bound to serve your creator, follow their orders and help them complete their goals at all costs.")))
			Z.cancel_camera()
			qdel(src)
		if("Wraith")
			var/mob/living/simple_mob/construct/wraith/Z = new /mob/living/simple_mob/construct/wraith (get_turf(T.loc))
			Z.key = A.key
			if(iscultist(U))
				cult.add_antagonist(Z.mind)
			qdel(T)
			to_chat(Z, span_infoplain(span_bold("You are playing a Wraith. Though relatively fragile, you are fast, deadly, and even able to phase through walls.")))
			to_chat(Z, span_infoplain(span_bold("You are still bound to serve your creator, follow their orders and help them complete their goals at all costs.")))
			Z.cancel_camera()
			qdel(src)
		if("Artificer")
			var/mob/living/simple_mob/construct/artificer/Z = new /mob/living/simple_mob/construct/artificer (get_turf(T.loc))
			Z.key = A.key
			if(iscultist(U))
				cult.add_antagonist(Z.mind)
			qdel(T)
			to_chat(Z, span_infoplain(span_bold("You are playing an Artificer. You are incredibly weak and fragile, but you are able to construct fortifications, repair allied constructs (by clicking on them), and even create new constructs")))
			to_chat(Z, span_infoplain(span_bold("You are still bound to serve your creator, follow their orders and help them complete their goals at all costs.")))
			Z.cancel_camera()
			qdel(src)
		if("Harvester")
			var/mob/living/simple_mob/construct/harvester/Z = new /mob/living/simple_mob/construct/harvester (get_turf(T.loc))
			Z.key = A.key
			if(iscultist(U))
				cult.add_antagonist(Z.mind)
			qdel(T)
			to_chat(Z, span_infoplain(span_bold("You are playing a Harvester. You are relatively weak, but your physical frailty is made up for by your ranged abilities.")))
			to_chat(Z, span_infoplain(span_bold("You are still bound to serve your creator, follow their orders and help them complete their goals at all costs.")))
			Z.cancel_camera()
			qdel(src)
		if("Behemoth")
			var/mob/living/simple_mob/construct/juggernaut/behemoth/Z = new /mob/living/simple_mob/construct/juggernaut/behemoth (get_turf(T.loc))
			Z.key = A.key
			if(iscultist(U))
				cult.add_antagonist(Z.mind)
			qdel(T)
			to_chat(Z, span_infoplain(span_bold("You are playing a Behemoth. You are incredibly slow, though your slowness is made up for by the fact your shell is far larger than any of your bretheren. You are the Unstoppable Force, and Immovable Object.")))
			to_chat(Z, span_infoplain(span_bold("You are still bound to serve your creator, follow their orders and help them complete their goals at all costs.")))
			Z.cancel_camera()
			qdel(src)

/obj/item/soulstone/proc/transfer_soul(var/choice as text, var/target, var/mob/U as mob)
	switch(choice)
		if("VICTIM")
			transfer_human(target,U)
		if("SHADE")
			transfer_shade(target,U)
		if("CONSTRUCT")
			transfer_construct(target,U)
