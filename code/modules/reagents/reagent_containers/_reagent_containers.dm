/obj/item/reagent_containers
	name = "Container"
	desc = "..."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	w_class = ITEMSIZE_SMALL
	var/amount_per_transfer_from_this = 5
	var/possible_transfer_amounts = list(5,10,15,25,30)
	var/volume = 30
	var/list/starts_with

/obj/item/reagent_containers/verb/set_APTFT() //set amount_per_transfer_from_this
	set name = "Set transfer amount"
	set category = "Object"
	set src in range(0)
	var/N = tgui_input_list(usr, "Amount per transfer from this:","[src]", possible_transfer_amounts)
	if(N)
		amount_per_transfer_from_this = N

/obj/item/reagent_containers/Initialize(mapload)
	. = ..()
	if(!possible_transfer_amounts)
		src.verbs -= /obj/item/reagent_containers/verb/set_APTFT
	create_reagents(volume)

	if(starts_with)
		var/total_so_far = 0
		for(var/string in starts_with)
			var/amt = starts_with[string] || 1
			total_so_far += amt
			reagents.add_reagent(string, amt)
		if(total_so_far > volume)
			warning("[src]([src.type]) starts with more reagents than it has total volume")
		starts_with = null // it should gc, since it's just strings and numbers

/obj/item/reagent_containers/attack_self(mob/user as mob)
	return

/obj/item/reagent_containers/afterattack(obj/target, mob/user, flag)
	return

/obj/item/reagent_containers/proc/reagentlist() // For attack logs
	if(reagents)
		return reagents.get_reagents()
	return "No reagent holder"

/obj/item/reagent_containers/proc/standard_dispenser_refill(var/mob/user, var/obj/structure/reagent_dispensers/target) // This goes into afterattack
	if(!istype(target))
		return 0

	if(target.open_top)
		return 0

	if(!target.reagents || !target.reagents.total_volume)
		balloon_alert(user, "[target] is empty.")
		return 1

	if(reagents && !reagents.get_free_space())
		balloon_alert(user, "[src] is full.")
		return 1

	var/trans = target.reagents.trans_to_obj(src, target:amount_per_transfer_from_this)
	balloon_alert(user, "[trans] units transfered to \the [src]")
	return 1

/obj/item/reagent_containers/proc/standard_splash_mob(var/mob/user, var/mob/target) // This goes into afterattack
	if(!istype(target))
		return

	if(!reagents || !reagents.total_volume)
		balloon_alert(user, "[src] is empty!")
		return 1

	if(target.reagents && !target.reagents.get_free_space())
		balloon_alert(user, "\the [target] is full!")
		return 1

	var/contained = reagentlist()
	add_attack_logs(user,target,"Splashed with [src.name] containing [contained]")
	balloon_alert_visible("[target] is splashed with something by [user]!", "splashed the solution onto [target]")
	reagents.splash(target, reagents.total_volume)
	return 1

/obj/item/reagent_containers/proc/self_feed_message(var/mob/user)
	balloon_alert(user, "you eat \the [src]")

/obj/item/reagent_containers/proc/other_feed_message_start(var/mob/user, var/mob/target)
	balloon_alert_visible(user, "[user] is trying to feed [target] \the [src]!")

/obj/item/reagent_containers/proc/other_feed_message_finish(var/mob/user, var/mob/target)
	balloon_alert_visible(user, "[user] has fed [target] \the [src]!")

/obj/item/reagent_containers/proc/feed_sound(var/mob/user)
	return

/obj/item/reagent_containers/proc/standard_feed_mob(var/mob/user, var/mob/target) // This goes into attack
	if(!istype(target) || !target.can_feed())
		return FALSE

	if(!reagents || !reagents.total_volume)
		balloon_alert(user, "\the [src] is empty.")
		return TRUE

	if(!target.consume_liquid_belly)
		if(liquid_belly_check())
			to_chat(user, span_infoplain("[user == target ? "you can't" : "\The [target] can't"] consume that, it contains something produced from a belly!"))
			return FALSE

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!H.check_has_mouth())
			balloon_alert(user, "[user == target ? "you don't" : "\the [H] doesn't"] have a mouth!")
			return FALSE
		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			balloon_alert(user, "\the [blocked] is in the way!")
			return FALSE

	user.setClickCooldown(user.get_attack_speed(src)) //puts a limit on how fast people can eat/drink things
	if(user == target)
		self_feed_message(user)
		reagents.trans_to_mob(user, issmall(user) ? CEILING(amount_per_transfer_from_this/2, 1) : amount_per_transfer_from_this, CHEM_INGEST)
		feed_sound(user)
		return TRUE

	else
		other_feed_message_start(user, target)
		if(!do_mob(user, target))
			return FALSE
		other_feed_message_finish(user, target)

		var/contained = reagentlist()
		add_attack_logs(user,target,"Fed from [src.name] containing [contained]")
		reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_INGEST)
		feed_sound(user)
		return TRUE

/obj/item/reagent_containers/proc/standard_pour_into(var/mob/user, var/atom/target) // This goes into afterattack and yes, it's atom-level
	if(!target.is_open_container() || !target.reagents)
		return 0

	if(!reagents || !reagents.total_volume)
		balloon_alert(usr, "[src] is empty!")
		return 1

	if(!target.reagents.get_free_space())
		balloon_alert(usr, "[target] is full!")
		return 1

	var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
	balloon_alert(user, "transfered [trans] units to [target]")
	return 1

/obj/item/reagent_containers/proc/liquid_belly_check()
	if(!reagents)
		return FALSE
	for(var/datum/reagent/R in reagents.reagent_list)
		if(R.from_belly)
			return TRUE
	return FALSE

/obj/item/reagent_containers/extrapolator_act(mob/living/user, obj/item/extrapolator/extrapolator, dry_run = FALSE)
	. = ..()
	EXTRAPOLATOR_ACT_SET(., EXTRAPOLATOR_ACT_PRIORITY_ISOLATE)
	var/datum/reagent/blood/blood = reagents.get_reagent(REAGENT_ID_BLOOD)
	EXTRAPOLATOR_ACT_ADD_DISEASES(., blood?.get_diseases())
