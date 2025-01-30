/obj/structure/fitness
	icon = 'icons/obj/stationobjs.dmi'
	anchored = TRUE
	var/fitness_being_used = 0
	var/weightloss_power = 1

/obj/structure/fitness/punchingbag
	name = "punching bag"
	desc = "A punching bag."
	icon_state = "punchingbag"
	density = TRUE
	var/list/hit_message = list("hit", "punch", "kick", "robust")

/obj/structure/fitness/punchingbag/attack_hand(var/mob/living/carbon/human/user)
	if(!istype(user))
		..()
		return
	if(user.nutrition < 20)
		to_chat(user, span_warning("You need more energy to use the punching bag. Go eat something."))
	else
		if(user.a_intent == I_HURT)
			user.setClickCooldown(user.get_attack_speed())
			flick("[icon_state]_hit", src)
			playsound(src, 'sound/effects/woodhit.ogg', 25, 1, -1)
			user.do_attack_animation(src)
			user.adjust_nutrition(-5)
			user.weight -= 0.25 * weightloss_power * (0.01 * user.weight_loss)
			to_chat(user, span_warning("You [pick(hit_message)] \the [src]."))

/obj/structure/fitness/weightlifter
	name = "weightlifting machine"
	desc = "A machine used to lift weights."
	icon_state = "weightlifter"
	blocks_emissive = EMISSIVE_BLOCK_UNIQUE
	var/weight = 1
	var/list/qualifiers = list("with ease", "without any trouble", "with great effort")

/obj/structure/fitness/weightlifter/attackby(obj/item/W as obj, mob/user as mob)
	if(W.has_tool_quality(TOOL_WRENCH))
		playsound(src, 'sound/items/Deconstruct.ogg', 75, 1)
		weight = ((weight) % qualifiers.len) + 1
		to_chat(user, "You set the machine's weight level to [weight].")

/obj/structure/fitness/weightlifter/attack_hand(var/mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(user.loc != src.loc)
		to_chat(user, span_warning("You must be on the weight machine to use it."))
		return
	if(user.nutrition < 50)
		to_chat(user, span_warning("You need more energy to lift weights. Go eat something."))
		return
	if(fitness_being_used)
		to_chat(user, span_warning("The weight machine is already in use by somebody else."))
		return
	else
		fitness_being_used = 1
		playsound(src, 'sound/effects/weightlifter.ogg', 50, 1)
		user.set_dir(SOUTH)
		flick("[icon_state]_[weight]", src)
		if(do_after(user, 20 + (weight * 10)))
			playsound(src, 'sound/effects/weightdrop.ogg', 25, 1)
			user.adjust_nutrition(weight * -10)
			var/weightloss_enhanced = weightloss_power * (weight * 0.5)
			user.weight -= 0.25 * weightloss_enhanced * (0.01 * user.weight_loss)
			to_chat(user, span_notice("You lift the weights [qualifiers[weight]]."))
			fitness_being_used = 0
		else
			to_chat(user, span_notice("Against your previous judgement, perhaps working out is not for you."))
			fitness_being_used = 0
