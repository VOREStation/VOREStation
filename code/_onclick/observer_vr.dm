/obj/item/device/paicard/attack_ghost(mob/user as mob)
	if(src.pai != null) //Have a person in them already?
		user.examinate(src)
		return
	var/choice = input(user, "You sure you want to inhabit this PAI?") in list("Yes", "No")
	var/pai_name = input(user, "Choose your character's name", "Character Name") as text
	var/actual_pai_name = sanitize_name(pai_name)
	var/pai_key
	if (isnull(pai_name))
		return
	if(choice == "Yes")
		pai_key = user.key
	else
		return
	var/turf/location = get_turf(src)
	var/obj/item/device/paicard/card = new(location)
	var/mob/living/silicon/pai/pai = new(card)
	qdel(src)
	pai.key = pai_key
	card.setPersonality(pai)
	pai.SetName(actual_pai_name)