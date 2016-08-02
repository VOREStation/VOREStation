#define PROCESS_ACCURACY 10

/obj/item/organ/internal/eyes
	name = "eyeballs"
	icon_state = "eyes"
	gender = PLURAL
	organ_tag = O_EYES
	parent_organ = BP_HEAD
	var/list/eye_colour = list(0,0,0)

/obj/item/organ/internal/eyes/robotize()
	..()
	name = "optical sensor"
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "camera"
	dead_icon = "camera_broken"
	verbs |= /obj/item/organ/internal/eyes/proc/change_eye_color

/obj/item/organ/internal/eyes/robot
	name = "optical sensor"

/obj/item/organ/internal/eyes/robot/New()
	..()
	robotize()

/obj/item/organ/internal/eyes/proc/change_eye_color()
	set name = "Change Eye Color"
	set desc = "Changes your robotic eye color instantly."
	set category = "IC"
	set src in usr

	var/current_color = rgb(eye_colour[1],eye_colour[2],eye_colour[3])
	var/new_color = input("Pick a new color for your eyes.","Eye Color", current_color) as null|color
	if(new_color && owner)
		// input() supplies us with a hex color, which we can't use, so we convert it to rbg values.
		var/list/new_color_rgb_list = hex2rgb(new_color)
		// First, update mob vars.
		owner.r_eyes = new_color_rgb_list[1]
		owner.g_eyes = new_color_rgb_list[2]
		owner.b_eyes = new_color_rgb_list[3]
		// Now sync the organ's eye_colour list.
		update_colour()
		// Finally, update the eye icon on the mob.
		owner.update_eyes()

/obj/item/organ/internal/eyes/replaced(var/mob/living/carbon/human/target)

	// Apply our eye colour to the target.
	if(istype(target) && eye_colour)
		target.r_eyes = eye_colour[1]
		target.g_eyes = eye_colour[2]
		target.b_eyes = eye_colour[3]
		target.update_eyes()
	..()

/obj/item/organ/internal/eyes/proc/update_colour()
	if(!owner)
		return
	eye_colour = list(
		owner.r_eyes ? owner.r_eyes : 0,
		owner.g_eyes ? owner.g_eyes : 0,
		owner.b_eyes ? owner.b_eyes : 0
		)

/obj/item/organ/internal/eyes/take_damage(amount, var/silent=0)
	var/oldbroken = is_broken()
	..()
	if(is_broken() && !oldbroken && owner && !owner.stat)
		owner << "<span class='danger'>You go blind!</span>"

/obj/item/organ/internal/eyes/process() //Eye damage replaces the old eye_stat var.
	..()
	if(!owner)
		return
	if(is_bruised())
		owner.eye_blurry = 20
	if(is_broken())
		owner.eye_blind = 20