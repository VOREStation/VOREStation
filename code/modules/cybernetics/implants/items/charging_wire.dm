#define CHARGE_MODE 1
#define DISCHARGE_MODE 0

#define NUTRITION2CHARGE(nutritiontoget) 7000/450*nutritiontoget
#define CHARGE2NUTRITION(nutritionToGive) ((nutritionToGive) / (7000.0 / 450.0))


#define NUTRITION_PER_CHARGE 10
#define CHARGE_SEGMENT_SIZE 2 SECONDS
#define NUTRITION_SAFE_THRESHOLD 100 //won't go below this when discharging to a battery
#define NUTRITION_CHARGE_CAP 450 //won't go beyond this when charging from an APC

/obj/item/synth_apc_charger //doesn't check if its used by an organic or not. the endoware that spawns this is synth exclusive, so it shouldn't ever be in human hands to begin with beyond fucking around.
	name = "APC connector"
	desc = "A ruggedized connector atop an incredibly thin superconducting kevlar wrapped wire loom. meant for Synthetic crew to charge themselves from APCs or Batteries, or vice versa. In organics, there's usually a slot to install a cell."
	hitsound = 'sound/weapons/whip.ogg' //kinda whippy
	damtype = HALLOSS
	icon = 'code/modules/cybernetics/assets/items.dmi'
	icon_state = "chargecable"

	var/mode = CHARGE_MODE

	attack_verb = list("whipped") //wha cha
	force = 2

/obj/item/synth_apc_charger/Initialize(mapload)
	. = ..()

/obj/item/synth_apc_charger/attack_self(mob/user)
	switch_mode(user)

/obj/item/synth_apc_charger/proc/switch_mode(var/mob/user)
	mode = !mode
	to_chat(user,span_notice("you set [src] to [mode ? "charge": "discharge"]"))

/obj/item/synth_apc_charger/proc/attach_to_apc(var/obj/machinery/power/apc/apc,var/mob/living/user) //these don't work w/ the context of already deployed items
	user.visible_message(span_warning("a thin cable pushes itself from [user]'s wrist, and connects to \the [apc]."),span_notice("You tug the charging cable from your wrist, and connect it to \the [apc]."))

/obj/item/synth_apc_charger/proc/detatch_from_apc(var/obj/machinery/power/apc/apc,var/mob/living/user)
	user.visible_message(span_warning("[user]'s charging cable disconnects from \the [apc] and whips back into their wrist."),span_notice("The charging cable snaps back into its slot in your wrist."))

/obj/item/synth_apc_charger/proc/attach_to_cell(var/obj/item/cell/battery,var/mob/living/user)
	user.visible_message(span_warning("a thin cable pushes itself from [user]'s wrist, and connects to \the [battery]."),span_notice("You tug the charging cable from your wrist, and connect it to \the [battery]."))

/obj/item/synth_apc_charger/proc/detatch_from_cell(var/obj/item/cell/battery,var/mob/living/user)
	user.visible_message(span_warning("[user]'s charging cable disconnects from \the [battery] and whips back into their wrist."),span_notice("The charging cable snaps back into its slot in your wrist."))

/obj/item/synth_apc_charger/afterattack(var/atom/target, var/mob/living/user, proximity)
	if(istype(target,/obj/machinery/power/apc))
		var/obj/machinery/power/apc/apc = target
		if(mode)
			attach_to_apc(apc, user)
			while(do_after(user,CHARGE_SEGMENT_SIZE, target))
				user.nutrition = min(user.nutrition+NUTRITION_PER_CHARGE, NUTRITION_CHARGE_CAP)
				if(user.nutrition == NUTRITION_CHARGE_CAP)
					break
				apc.drain_power(NUTRITION2CHARGE(NUTRITION_PER_CHARGE)) //This is from the large rechargers. No idea what the math is.
			detatch_from_apc(apc, user)
		return

	if(istype(target,/obj/item/cell)) //slurp
		var/obj/item/cell/battery = target
		if(mode) //we're charging
			if(user.nutrition > NUTRITION_CHARGE_CAP)
				to_chat(user,span_warning("You can't charge that, you don't have enough in your cell!"))
				return

			var/max_NURITION_PER_CHARGE = max(NUTRITION_CHARGE_CAP - user.nutrition,0)

			attach_to_cell(battery, user)
			if(do_after(user,CHARGE_SEGMENT_SIZE*2,target))
				var/used_from_cell = battery.use(NUTRITION2CHARGE(max_NURITION_PER_CHARGE))
				var/actual_nutrition = CHARGE2NUTRITION(used_from_cell)
				to_chat(user, span_notice("you charge from the cell!")) //yum yum
				user.nutrition += actual_nutrition
			detatch_from_cell(battery, user)

		else //discharge
			//get capacity
			var/cell_capacity = battery.amount_missing()
			var/max_we_can_provide = user.nutrition - NUTRITION_SAFE_THRESHOLD //if this is > capacity it's over, TODO
			if(max_we_can_provide <= 0)
				to_chat(user,span_warning("Your voltage regulators prohibit providing energy when you're already so low!"))
				return

			var/cell_charge = battery.give(NUTRITION2CHARGE(max_we_can_provide))
			var/nutrition_used = CHARGE2NUTRITION(cell_charge)
			user.nutrition -= nutrition_used
			return

#undef CHARGE_MODE
#undef DISCHARGE_MODE
#undef CHARGE_SEGMENT_SIZE
#undef NUTRITION_SAFE_THRESHOLD
#undef NUTRITION_PER_CHARGE
#undef NUTRITION_CHARGE_CAP

/obj/item/synth_apc_charger/protean
	name = "Surfluid Tendril"
	//temp desc annoy cody
	desc = "A non rugged technically-a-connector atop a variable-thickness pile of nanites. Legally speaking, any videos depicting the usage of this to charge from an APC must be pixelated in Japan."
	icon_state = "chargetendril"


/obj/item/synth_apc_charger/protean/attach_to_apc(var/obj/machinery/power/apc/apc,var/mob/living/user)
	user.visible_message(span_warning("Thin snakelike tendrils grow from [user] and connect to \the [apc]."),span_notice("Thin snakelike tendrils grow from you and connect to \the [apc]."))

/obj/item/synth_apc_charger/protean/detatch_from_apc(var/obj/machinery/power/apc/apc,var/mob/living/user)
	user.visible_message(span_warning("[user]'s snakelike tendrils whip back into their body from \the [apc]."),span_notice("The APC connector tendrils return to your body."))

/obj/item/synth_apc_charger/protean/attach_to_cell(var/obj/item/cell/battery,var/mob/living/user)
	user.visible_message(span_warning("Thin snakelike tendrils grow from [user] and connect to \the [battery]."),span_notice("Thin snakelike tendrils grow from you and connect to \the [battery]."))

/obj/item/synth_apc_charger/protean/detatch_from_cell(var/obj/item/cell/battery,var/mob/living/user)
	user.visible_message(span_warning("[user]'s snakelike tendrils whip back into their body from \the [battery]."),span_notice("The APC connector tendrils return to your body."))
