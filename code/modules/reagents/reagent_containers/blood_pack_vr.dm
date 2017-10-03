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

/obj/item/weapon/reagent_containers/blood/attack_self(mob/living/user as mob)
	if(user.a_intent == I_HURT)
		if(reagents.total_volume && volume)
			switch(reagents.get_master_reagent_id())
				if("blood")
					user.show_message("<span class='warning'>You sink your fangs into \the [src] and suck the blood out of it!</span>")
					user.visible_message("<font color='red'>[user] sinks their fangs into \the [src] and drains it!</font>")
					user.nutrition += volume*5
					reagents.clear_reagents()
					update_icon()
					return
				else
					user.show_message("<span class='warning'>You take a look at \the [src] and notice that it is not filled with blood!</span>")
					return
		else
			user.show_message("<span class='warning'>You take a look at \the [src] and notice it has nothing in it!</span>")
			return
	else
		return