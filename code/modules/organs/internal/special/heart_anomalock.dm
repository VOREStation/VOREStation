/obj/item/organ/internal/heart/machine/anomalock
	name = "voltaic combat cyberheart"
	desc = "A cutting-edge cyberheart. Voltaic technology allows the heart to keep the body upright in dire circumstances, alongside redirecting anomalous flux energy to fully shield the user from shocks and electro-magnetic pulses. Requires a Flux core as a power source."
	icon_state = "anomalock_heart"
	organ_tag = O_HEART

	COOLDOWN_DECLARE(survival_cooldown)
	///Cooldown for the activation of the organ
	var/survival_cooldown_time = 10 MINUTES
	///The lightning effect on our mob when the implant is active
	var/mutable_appearance/lightning_overlay
	///how long the lightning lasts
	var/lightning_timer

	///The core item the organ runs off.
	var/obj/item/assembly/signaler/anomaly/core
	///Accepted types of anomaly cores.
	var/required_anomaly = /obj/item/assembly/signaler/anomaly/flux
	///If this one starts with a core in.
	var/prebuilt = FALSE
	///If the core is removable once socketed.
	var/core_removable = TRUE

/obj/item/organ/internal/heart/machine/anomalock/handle_organ_mod_special(removed)
	if(!core)
		return

	if(!removed)
		add_lightning_overlay(30 SECONDS)
		playsound(owner, 'sound/machines/defib_zap.ogg', 50, TRUE, -1)
		RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_CRITICAL_CONDITION), PROC_REF(activate_survival))

	if(removed)
		clear_lightning_overlay(owner)
		UnregisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_CRITICAL_CONDITION))
		tesla_zap(owner, 10, 2500, current_jumps = 5)
		QDEL_IN(src, 0)

	..(removed)

/obj/item/organ/internal/heart/machine/anomalock/proc/add_lightning_overlay(time_to_last = 10 SECONDS)
	if(lightning_overlay)
		lightning_overlay = addtimer(CALLBACK(src, PROC_REF(clear_lightning_overlay), owner), time_to_last, (TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE|TIMER_DELETE_ME))
		return
	lightning_overlay = mutable_appearance(icon = 'icons/effects/effects.dmi', icon_state = "lightning")
	owner.add_overlay(lightning_overlay)
	lightning_timer = addtimer(CALLBACK(src, PROC_REF(clear_lightning_overlay), owner), time_to_last, (TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE|TIMER_DELETE_ME))

/obj/item/organ/internal/heart/machine/anomalock/proc/clear_lightning_overlay(mob/organ_owner)
	organ_owner?.cut_overlay(lightning_overlay)
	if(lightning_timer)
		deltimer(lightning_timer)
	lightning_overlay = null

/obj/item/organ/internal/heart/machine/anomalock/proc/activate_survival(mob/living/carbon/organ_owner)
	if(!COOLDOWN_FINISHED(src, survival_cooldown))
		return FALSE

	organ_owner.add_modifier(/datum/modifier/voltaic_overdrive, 30 SECONDS)
	add_lightning_overlay(30 SECONDS)
	COOLDOWN_START(src, survival_cooldown, survival_cooldown_time)
	addtimer(CALLBACK(src, PROC_REF(notify_cooldown), organ_owner), COOLDOWN_TIMELEFT(src, survival_cooldown))
	return TRUE

/obj/item/organ/internal/heart/machine/anomalock/proc/notify_cooldown(mob/living/carbon/organ_owner)
	balloon_alert(organ_owner, "your heart strengthtens")
	playsound(owner, 'sound/machines/defib_zap.ogg', 40)

/obj/item/organ/internal/heart/machine/anomalock/emp_act(severity, recursive)
	add_lightning_overlay(10 SECONDS)

/obj/item/organ/internal/heart/machine/anomalock/attackby(obj/item/W, mob/user)
	if(istype(W, required_anomaly))
		if(core)
			balloon_alert(user, "core already in!")
			return FALSE
		if(do_after(user, 3 SECONDS, src))
			user.unEquip(W, TRUE, src)
			core = W
			balloon_alert(user, "core_installed")
			playsound(src, 'sound/machines/click.ogg')
			update_icon()
			return TRUE

	if(W.has_tool_quality(IS_SCREWDRIVER))
		if(!core)
			balloon_alert(user, "no core!")
			return FALSE
		if(!core_removable)
			balloon_alert(user, "can't remove core!")
			return FALSE
		balloon_alert(user, "removing core...")
		if(!do_after(user, 3 SECONDS, src))
			balloon_alert(user, "interrupted!")
			return
		balloon_alert(user, "core removed")
		core.forceMove(drop_location())
		if(Adjacent(user) && !issilicon(user))
			user.put_in_hands(core)
		core = null
		update_icon()
		return TRUE

	return ..()

/obj/item/organ/internal/heart/machine/anomalock/prebuilt/Initialize(mapload, internal)
	. = ..()
	core = new /obj/item/assembly/signaler/anomaly/flux(src)
	update_icon()

/obj/item/organ/internal/heart/machine/anomalock/update_icon()
	. = ..()
	icon_state = initial(icon_state) + (core ? "-core" : "")

/datum/modifier/voltaic_overdrive
	name = "voltaic_overdrive"
	client_color = "#e9f76b"

/datum/modifier/voltaic_overdrive/tick(seconds_between_ticks)
	. = ..()
	if(holder.health > holder.get_crit_point())
		return

	holder.heal_overall_damage(5, 5)
	holder.adjustOxyLoss(-5)
	holder.adjustToxLoss(-5)
	holder.adjustHalLoss(-5)
	holder.AdjustWeakened(-5)
	holder.AdjustSleeping(-5)
	holder.AdjustStunned(-5)
	holder.eye_blurry = 0

/datum/modifier/voltaic_overdrive/on_applied()
	. = ..()
	REMOVE_TRAIT(src, TRAIT_CRITICAL_CONDITION, STAT_TRAIT)
	holder.reagents.add_reagent(REAGENT_ID_MYELAMINE, 5)
	to_chat(holder, span_userdanger("You feel a burst of energy! It's do or die!"))
	pain_immunity = TRUE

/datum/modifier/voltaic_overdrive/on_expire()
	. = ..()
	holder.balloon_alert(holder, "your heart weakens")
