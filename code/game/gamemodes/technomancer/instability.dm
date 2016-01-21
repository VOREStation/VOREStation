/mob
	var/obj/screen/wizard/instability/wiz_instability_display = null //Unfortunately, this needs to be a mob var due to HUD code.

/mob/living
	var/instability = 0
	var/last_instability_event = null

/mob/living/proc/adjust_instability()
	return

/mob/living/carbon/human/adjust_instability(var/amount)
	instability = min(max(instability + amount, 0), 200)
	instability_update_hud()

/mob/living/carbon/human/proc/instability_update_hud()
	if(client && hud_used)
		switch(instability)
			if(0 to 10)
				wiz_instability_display.icon_state = "instability-1"
			if(11 to 30)
				wiz_instability_display.icon_state = "instability0"
			if(31 to 50)
				wiz_instability_display.icon_state = "instability1"
			if(51 to 100)
				wiz_instability_display.icon_state = "instability2"
			if(101 to 200)
				wiz_instability_display.icon_state = "instability3"

/mob/living/carbon/human/Life()
	. = ..()
	handle_instability()

/mob/living/carbon/human/proc/handle_instability()
	instability = Clamp(instability, 0, 200)
	instability_update_hud()
	//This should cushon against really bad luck.
	if(instability && last_instability_event < (world.time - 10 SECONDS) && prob(20))
		instability_effects()
		switch(instability)
			if(1 to 10)
				adjust_instability(-1)
			if(11 to 20)
				adjust_instability(-2)
			if(21 to 30)
				adjust_instability(-3)
			if(31 to 40)
				adjust_instability(-4)
			if(41 to 50)
				adjust_instability(-5)
			if(51 to 100)
				adjust_instability(-10)
			if(101 to 200)
				adjust_instability(-20)

/*
[16:18:08] <PsiOmegaDelta> Sparks
[16:18:10] <PsiOmegaDelta> Wormholes
[16:18:16] <PsiOmegaDelta> Random spells firing off on their own
[16:18:22] <PsiOmegaDelta> The possibilities are endless
[16:19:00] <PsiOmegaDelta> Random objects phasing into reality, only to disappear again
[16:19:05] <PsiOmegaDelta> Things briefly duplicating
[16:20:56] <PsiOmegaDelta> Glass cracking, eventually breaking
*/
/mob/living/carbon/human/proc/instability_effects()
	if(instability)
		var/rng = 0
		last_instability_event = world.time
		spawn(1)
			var/image/instability_flash = image('icons/obj/spells.dmi',"instability")
			overlays |= instability_flash
			sleep(4)
			overlays.Remove(instability_flash)
			qdel(instability_flash)
		switch(instability)
			if(1 to 10) //Harmless
				return
			if(11 to 30) //Minor
				rng = rand(0,1)
				switch(rng)
					if(0)
						var/datum/effect/effect/system/spark_spread/sparks = PoolOrNew(/datum/effect/effect/system/spark_spread)
						sparks.set_up(5, 0, src)
						sparks.attach(loc)
//						var/datum/effect/effect/system/spark_spread/spark_system = PoolOrNew(/datum/effect/effect/system/spark_spread)
//						spark_system.set_up(5, 0, get_turf(src))
//						spark_system.attach(src)
						sparks.start()
						visible_message("<span class='warning'>Electrical sparks manifest from nowhere around \the [src]!</span>")
						qdel(sparks)
					if(1)
						return

			if(31 to 50) //Moderate
				rng = rand(0,8)
				switch(rng)
					if(0)
						apply_effect(instability * 0.5, IRRADIATE)
					if(1)
						visible_message("<span class='warning'>\The [src] suddenly collapses!</span>",
						"<span class='danger'>You suddenly feel very weak, and you fall down!</span>")
						Weaken(instability * 0.1)
					if(2)
						if(can_feel_pain())
							apply_effect(instability * 0.5, AGONY)
							src << "<span class='danger'>You feel a sharp pain!</span>"
					if(3)
						apply_effect(instability * 0.5, EYE_BLUR)
						src << "<span class='danger'>Your eyes start to get cloudy!</span>"
					if(4)
						electrocute_act(instability * 0.3, "unstable energies")
					if(5)
						adjustFireLoss(instability * 0.2) //10 burn @ 50 instability
						src << "<span class='danger'>You feel your skin burn!</span>"
					if(6)
						adjustBruteLoss(instability * 0.2) //10 brute @ 50 instability
						src << "<span class='danger'>You feel a sharp pain as an unseen force harms your body!</span>"
					if(7)
						adjustToxLoss(instability * 0.2) //10 tox @ 50 instability
					if(8)
						safe_blink(src, range = 6)
						src << "<span class='warning'>You're teleported against your will!</span>"

			if(51 to 100) //Severe
				rng = rand(0,8)
				switch(rng)
					if(0)
						apply_effect(instability * 0.7, IRRADIATE)
					if(1)
						visible_message("<span class='warning'>\The [src] suddenly collapses!</span>",
						"<span class='danger'>You suddenly feel very light-headed, and faint!</span>")
						Paralyse(instability * 0.1)
					if(2)
						if(can_feel_pain())
							apply_effect(instability * 0.7, AGONY)
							src << "<span class='danger'>You feel an extremly angonizing pain from all over your body!</span>"
					if(3)
						apply_effect(instability * 0.5, EYE_BLUR)
						src << "<span class='danger'>Your eyes start to get cloudy!</span>"
					if(4)
						electrocute_act(instability * 0.5, "extremely unstable energies")
					if(5)
						fire_act()
						src << "<span class='danger'>You spontaneously combust!</span>"
					if(6)
						adjustCloneLoss(instability * 0.05) //5 cloneloss @ 100 instability
						src << "<span class='danger'>You feel your body slowly degenerate.</span>"
					if(7)
						adjustToxLoss(instability * 0.25) //25 tox @ 100 instability
			if(101 to 200) //Lethal
				rng = rand(0,8)
				switch(rng)
					if(0)
						apply_effect(instability, IRRADIATE)
					if(1)
						visible_message("<span class='warning'>\The [src] suddenly collapses!</span>",
						"<span class='danger'>You suddenly feel very light-headed, and faint!</span>")
						Paralyse(instability * 0.1)
					if(2)
						if(can_feel_pain())
							apply_effect(instability, AGONY)
							src << "<span class='danger'>You feel an extremly angonizing pain from all over your body!</span>"
					if(3)
						apply_effect(instability, EYE_BLUR)
						src << "<span class='danger'>Your eyes start to get cloudy!</span>"
					if(4)
						electrocute_act(instability, "extremely unstable energies")
					if(5)
						fire_act()
						src << "<span class='danger'>You spontaneously combust!</span>"
					if(6)
						adjustCloneLoss(instability * 0.10) //5 cloneloss @ 100 instability
						src << "<span class='danger'>You feel your body slowly degenerate.</span>"
					if(7)
						adjustToxLoss(instability * 0.40) //25 tox @ 100 instability
