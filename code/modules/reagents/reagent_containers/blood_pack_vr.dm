/obj/item/weapon/reagent_containers/blood/attack_self(mob/living/user as mob)
	if(user.a_intent == I_HURT)
		if(reagents.total_volume && volume)
			var/reagent_to_remove = reagents.get_master_reagent_id()
			switch(reagents.get_master_reagent_id())
				if("blood")
					user.show_message("<span class='warning'>You sink your fangs into \the [src] and suck the blood out of it!</span>")
					user.visible_message("<font color='red'>[user] sinks their fangs into \the [src] and drains it!</font>")
					user.nutrition += volume*5
					var/blood_to_remove = volume*0.1 //10%
					if(blood_to_remove < 80)
						blood_to_remove = volume //This is to prevent people from spamming it.
					reagents.remove_reagent(reagent_to_remove, blood_to_remove)
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
