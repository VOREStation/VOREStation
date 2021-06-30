///////////////////////////////////////////////
/////////////////// Stage 1 ///////////////////

/datum/disease2/effect/mlem
	name = "Mlemington's Syndrome"
	stage = 1
	chance_maxm = 25

/datum/disease2/effect/mlem/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.say("[pick("Mlem.","MLEM!","Mlem?")]")

/datum/disease2/effect/spin
	name = "Spyndrome"
	stage = 1
	chance_maxm = 7
	var/list/directions = list(2,4,1,8,2,4,1,8,2,4,1,8,2,4,1,8,2,4,1,8)

/datum/disease2/effect/spin/activate(var/mob/living/carbon/mob,var/multiplier)
	if(mob.buckled())
		to_chat(viewers(mob),"<span class='warning'>[mob.name] struggles violently against their restraints!</span>")
	else
		to_chat(viewers(mob),"<span class='warning'>[mob.name] spins around violently!</span>")
		for(var/D in directions)
			mob.dir = D
			sleep(1)
		mob.dir = pick(2,4,1,8) //For that added annoyance

///////////////////////////////////////////////
/////////////////// Stage 2 ///////////////////

/datum/disease2/effect/lang
	name = "Lingual Dissocation"
	stage = 2
	chance_maxm = 2

/datum/disease2/effect/lang/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.set_default_language(pick(mob.languages))

///////////////////////////////////////////////
/////////////////// Stage 3 ///////////////////

/datum/disease2/effect/size
	name = "Mass Revectoring"
	stage = 3
	chance_maxm = 1

/datum/disease2/effect/size/activate(var/mob/living/carbon/mob,var/multiplier)
	var/newsize = rand (25, 200)
	mob.resize(newsize/100)
	to_chat(viewers(mob),"<span class='warning'>[mob.name] suddenly changes size!</span>")

/datum/disease2/effect/flip
	name = "Flipponov's Disease"
	stage = 3
	chance_maxm = 5

/datum/disease2/effect/flip/activate(var/mob/living/carbon/mob,var/multiplier) //Remind me why mob is carbon...?
	if(ishuman(mob))
		var/mob/living/carbon/human/H = mob
		H.emote("flip")
	else
		to_chat(viewers(mob),"<span class='warning'>[mob.name] does a backflip!</span>")
		mob.SpinAnimation(7,1)
