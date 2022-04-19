/mob/verb/mob_examine(atom/A as mob in view(world.view, get_turf(src)))
	set name = "Mob Examine"
	set desc = "Allows one to examine mobs they can see, even from inside of bellies and objects."
	set category = "IC"

	if((is_blind(src) || usr.stat) && !isobserver(src))
		to_chat(src, "<span class='notice'>Something is there but you can't see it.</span>")
		return 1

	if(!isbelly(loc) && !istype(loc, /obj/item/weapon/holder))
		examinate(A)
		return
	if(!A)
		return
	var/list/results = A.examine(src)
	if(!results || !results.len)
		results = list("You were unable to examine that. Tell a developer!")
	to_chat(src, jointext(results, "<br>"))
	update_examine_panel(A)
