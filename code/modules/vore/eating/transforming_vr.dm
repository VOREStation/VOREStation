/obj/belly/proc/check_eyes(var/mob/living/carbon/human/M)
	var/mob/living/carbon/human/O = owner
	if(!istype(M) || !istype(O))
		return 0
	return (M.r_eyes != O.r_eyes || M.g_eyes != O.g_eyes || M.b_eyes != O.b_eyes)

/obj/belly/proc/change_eyes(var/mob/living/carbon/human/M, message=0)
	var/mob/living/carbon/human/O = owner
	if(!istype(M) || !istype(O))
		return

	M.r_eyes = O.r_eyes
	M.g_eyes = O.g_eyes
	M.b_eyes = O.b_eyes
	M.update_eyes()
	M.update_icons_body()
	if(message)
		to_chat(M, "<span class='notice'>You feel lightheaded and drowsy...</span>")
		to_chat(O, "<span class='notice'>You feel warm as you make subtle changes to your captive's body.</span>")

/obj/belly/proc/check_hair(var/mob/living/carbon/human/M)
	var/mob/living/carbon/human/O = owner
	if(!istype(M) || !istype(O))
		return 0

	if(M.r_hair != O.r_hair || M.g_hair != O.g_hair || M.b_hair != O.b_hair)
		return 1
	if(M.r_facial != O.r_facial || M.g_facial != O.g_facial || M.b_facial != O.b_facial)
		return 1
	if(M.h_style != O.h_style || M.f_style != O.f_style)
		return 1
	return 0

/obj/belly/proc/change_hair(var/mob/living/carbon/human/M, message=0)
	var/mob/living/carbon/human/O = owner
	if(!istype(M) || !istype(O))
		return

	M.r_hair = O.r_hair
	M.g_hair = O.g_hair
	M.b_hair = O.b_hair
	M.r_facial = O.r_facial
	M.g_facial = O.g_facial
	M.b_facial = O.b_facial
	M.h_style = O.h_style
	M.f_style = O.f_style
	M.update_hair()
	if(message)
		to_chat(M, "<span class='notice'>Your body tingles all over...</span>")
		to_chat(O, "<span class='notice'>You tingle as you make noticeable changes to your captive's body.</span>")

/obj/belly/proc/check_skin(var/mob/living/carbon/human/M)
	var/mob/living/carbon/human/O = owner
	if(!istype(M) || !istype(O))
		return 0

	return (M.r_skin != O.r_skin || M.g_skin != O.g_skin || M.b_skin != O.b_skin)

/obj/belly/proc/change_skin(var/mob/living/carbon/human/M, message=0)
	var/mob/living/carbon/human/O = owner
	if(!istype(M) || !istype(O))
		return

	M.r_skin = O.r_skin
	M.g_skin = O.g_skin
	M.b_skin = O.b_skin
	for(var/obj/item/organ/external/Z in M.organs)
		Z.sync_colour_to_human(M)
	M.update_icons_body()
	if(message)
		to_chat(M, "<span class='notice'>Your body tingles all over...</span>")
		to_chat(O, "<span class='notice'>You tingle as you make noticeable changes to your captive's body.</span>")

/obj/belly/proc/check_gender(var/mob/living/carbon/human/M, target_gender)
	var/mob/living/carbon/human/O = owner
	if(!istype(M) || !istype(O))
		return 0

	if(!target_gender)
		target_gender = O.gender

	return (M.gender != target_gender || M.identifying_gender != target_gender)

/obj/belly/proc/change_gender(var/mob/living/carbon/human/M, target_gender, message=0)
	var/mob/living/carbon/human/O = owner
	if(!istype(M) || !istype(O))
		return

	if(!target_gender)
		target_gender = O.gender

	M.gender = target_gender
	M.identifying_gender = target_gender
	if(target_gender == FEMALE)
		M.f_style = "Shaved"
	M.dna.SetUIState(DNA_UI_GENDER,M.gender!=MALE,1)
	M.sync_organ_dna()
	M.update_icons_body()
	if(message)
		to_chat(M, "<span class='notice'>Your body feels very strange...</span>")
		to_chat(O, "<span class='notice'>You feel strange as you alter your captive's gender.</span>")

/obj/belly/proc/check_tail(var/mob/living/carbon/human/M)
	var/mob/living/carbon/human/O = owner
	if(!istype(M) || !istype(O))
		return 0

	if(M.tail_style != O.tail_style)
		return 1
	if(M.r_tail != O.r_tail || M.g_tail != O.g_tail || M.b_tail != O.b_tail)
		return 1
	return 0

/obj/belly/proc/change_tail(var/mob/living/carbon/human/M, message=0)
	var/mob/living/carbon/human/O = owner
	if(!istype(M) || !istype(O))
		return

	M.r_tail = O.r_tail
	M.g_tail = O.g_tail
	M.b_tail = O.b_tail
	M.tail_style = O.tail_style
	M.update_tail_showing()
	if(message)
		to_chat(M, "<span class='notice'>Your body tingles all over...</span>")
		to_chat(O, "<span class='notice'>You tingle as you make noticeable changes to your captive's body.</span>")

/obj/belly/proc/check_tail_nocolor(var/mob/living/carbon/human/M)
	var/mob/living/carbon/human/O = owner
	if(!istype(M) || !istype(O))
		return 0

	return (M.tail_style != O.tail_style)

/obj/belly/proc/change_tail_nocolor(var/mob/living/carbon/human/M, message=0)
	var/mob/living/carbon/human/O = owner
	if(!istype(M) || !istype(O))
		return

	M.tail_style = O.tail_style
	M.update_tail_showing()
	if(message)
		to_chat(M, "<span class='notice'>Your body tingles all over...</span>")
		to_chat(O, "<span class='notice'>You tingle as you make noticeable changes to your captive's body.</span>")

/obj/belly/proc/check_wing(var/mob/living/carbon/human/M)
	var/mob/living/carbon/human/O = owner
	if(!istype(M) || !istype(O))
		return 0

	if(M.wing_style != O.wing_style)
		return 1
	if(M.r_wing != O.r_wing || M.g_wing != O.g_wing || M.b_wing != O.b_wing)
		return 1
	return 0

/obj/belly/proc/change_wing(var/mob/living/carbon/human/M, message=0)
	var/mob/living/carbon/human/O = owner
	if(!istype(M) || !istype(O))
		return

	M.r_wing = O.r_wing
	M.g_wing = O.g_wing
	M.b_wing = O.b_wing
	M.wing_style = O.wing_style
	M.update_wing_showing()
	if(message)
		to_chat(M, "<span class='notice'>Your body tingles all over...</span>")
		to_chat(O, "<span class='notice'>You tingle as you make noticeable changes to your captive's body.</span>")

/obj/belly/proc/check_wing_nocolor(var/mob/living/carbon/human/M)
	var/mob/living/carbon/human/O = owner
	if(!istype(M) || !istype(O))
		return 0

	return (M.wing_style != O.wing_style)

/obj/belly/proc/change_wing_nocolor(var/mob/living/carbon/human/M, message=0)
	var/mob/living/carbon/human/O = owner
	if(!istype(M) || !istype(O))
		return

	M.wing_style = O.wing_style
	M.update_wing_showing()
	if(message)
		to_chat(M, "<span class='notice'>Your body tingles all over...</span>")
		to_chat(O, "<span class='notice'>You tingle as you make noticeable changes to your captive's body.</span>")

/obj/belly/proc/check_ears(var/mob/living/carbon/human/M)
	var/mob/living/carbon/human/O = owner
	if(!istype(M) || !istype(O))
		return 0

	return (M.ear_style != O.ear_style)

/obj/belly/proc/change_ears(var/mob/living/carbon/human/M, message=0)
	var/mob/living/carbon/human/O = owner
	if(!istype(M) || !istype(O))
		return

	M.ear_style = O.ear_style
	M.update_hair()

/obj/belly/proc/check_species(var/mob/living/carbon/human/M)
	var/mob/living/carbon/human/O = owner
	if(!istype(M) || !istype(O))
		return 0

	if(M.species != O.species || M.custom_species != O.custom_species)
		return 1
	return 0

/obj/belly/proc/change_species(var/mob/living/carbon/human/M, message=0, color_action = 0)	//color_action: 0 for default species, 1 to preserve, 2 to transfer from pred
	var/mob/living/carbon/human/O = owner
	if(!istype(M) || !istype(O))
		return

	M.verbs -=  M.species.inherent_verbs	//Take away their unique stuff

	var/list/backup_implants = list()
	for(var/obj/item/organ/I in M.organs)
		for(var/obj/item/weapon/implant/backup/BI in I.contents)
			backup_implants += BI
	if(backup_implants.len)
		for(var/obj/item/weapon/implant/backup/BI in backup_implants)
			BI.forceMove(src)
	if(color_action == 1)
		M.set_species(O.species.name,0,1,M)
	else if(color_action == 2)
		M.set_species(O.species.name,0,1,O)
	else
		M.set_species(O.species.name)
	M.custom_species = O.custom_species

	M.update_icons_body()
	M.update_tail_showing()

	if(backup_implants.len)
		var/obj/item/organ/external/torso = M.get_organ(BP_TORSO)
		for(var/obj/item/weapon/implant/backup/BI in backup_implants)
			BI.forceMove(torso)
			torso.implants += BI

	if(message)
		to_chat(M, "<span class='notice'>You lose sensation of your body, feeling only the warmth of everything around you... </span>")
		to_chat(O, "<span class='notice'>Your body shifts as you make dramatic changes to your captive's body.</span>")

/obj/belly/proc/put_in_egg(var/atom/movable/M, message=0)
	var/mob/living/carbon/human/O = owner
	var/egg_path = /obj/structure/closet/secure_closet/egg
	var/egg_name = "odd egg"

	if(O.vore_egg_type in tf_vore_egg_types)
		egg_path = tf_vore_egg_types[O.vore_egg_type]
		egg_name = "[O.vore_egg_type] egg"

	var/obj/structure/closet/secure_closet/egg/egg = new egg_path(src)
	M.forceMove(egg)
	egg.name = egg_name
	if(message)
		to_chat(M, "<span class='notice'>You lose sensation of your body, feeling only the warmth around you as you're encased in an egg.</span>")
		to_chat(O, "<span class='notice'>Your body shifts as you encase [M] in an egg.</span>")
