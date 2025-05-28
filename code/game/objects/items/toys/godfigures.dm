/obj/item/godfig
	name = "religious icon"
	desc = "A painted holy figure of a plain looking human man in a robe."
	description_info = "Right click to select a new sprite to fit your needs."
	icon = 'icons/obj/chaplain.dmi'
	icon_state = "mrobe"
	force = 10
	throw_speed = 1
	throw_range = 4
	throwforce = 10
	w_class = ITEMSIZE_SMALL


/obj/item/godfig/verb/resprite_figure()
	set name = "Customize Figure"
	set category = "Object"
	set desc = "Click to choose an appearance for your icon."

	var/mob/M = usr
	var/list/options = list()
	options["Painted - Robed Human Female"] = "frobe"
	options["Painted - Robed Human Male (Pale)"] = "mrobe"
	options["Painted - Robed Human Male (Dark)"] = "mrobedark"
	options["Painted - Bearded Human"] = "mpose"
	options["Painted - Human Male Warrior"] = "mwarrior"
	options["Painted - Human Female Warrior"] = "fwarrior"
	options["Painted - Human Male Hammer"] = "hammer"
	options["Painted - Horned God"] = "horned"
	options["Obsidian - Human Male"] = "onyxking"
	options["Obsidian - Human Female"] = "onyxqueen"
	options["Obsidian - Animal Headed Male"] = "onyxanimalm"
	options["Obsidian - Animal Headed Female"] = "onyxanimalf"
	options["Obsidian - Bird Headed Figure"] = "onyxbird"
	options["Stone - Seated Figure"] = "stoneseat"
	options["Stone - Head"] = "stonehead"
	options["Stone - Dwarf"] = "stonedwarf"
	options["Stone - Animal"] = "stoneanimal"
	options["Stone - Fertility"] = "stonevenus"
	options["Stone - Snake"] = "stonesnake"
	options["Bronze - Elephantine"] = "elephant"
	options["Bronze - Many-armed"] = "bronzearms"
	options["Robot"] = "robot"
	options["Singularity"] = "singularity"
	options["Gemstone Eye"] = "gemeye"
	options["Golden Skull"] = "skull"
	options["Goatman"] = "devil"
	options["Sun Gem"] = "sun"
	options["Moon Gem"] = "moon"
	options["Tajaran Figure"] = "catrobe"

	var/choice = tgui_input_list(M, "Choose your icon!", "Customize Figure", options)
	if(src && choice && !M.stat && in_range(M,src))
		icon_state = options[choice]
		if(options[choice] == "frobe")
			desc = "A painted holy figure of a plain looking human woman in a robe."
		else if(options[choice] == "mrobe")
			desc = "A painted holy figure of a plain looking human man in a robe."
		else if(options[choice] == "mrobedark")
			desc = "A painted holy figure of a plain looking human man in a robe.."
		else if(options[choice] == "mpose")
			desc = "A painted holy figure of a rather grandiose bearded human."
		else if(options[choice] == "mwarrior")
			desc = "A painted holy figure of a powerful human male warrior."
		else if(options[choice] == "fwarrior")
			desc = "A painted holy figure of a powerful human female warrior."
		else if(options[choice] == "hammer")
			desc = "A painted holy figure of a human holding a hammer aloft."
		else if(options[choice] == "horned")
			desc = "A painted holy figure of a human man crowned with antlers."
		else if(options[choice] == "onyxking")
			desc = "An obsidian holy figure of a human man wearing a grand hat."
		else if(options[choice] == "onyxqueen")
			desc = "An obsidian holy figure of a human woman wearing a grand hat."
		else if(options[choice] == "onyxanimalm")
			desc = "An obsidian holy figure of a human man with the head of an animal."
		else if(options[choice] == "onyxanimalf")
			desc = "An obsidian holy figure of a human woman with the head of an animal."
		else if(options[choice] == "onyxbird")
			desc = "An obsidian holy figure of a human with the head of a bird."
		else if(options[choice] == "stoneseat")
			desc = "A stone holy figure of a cross-legged human."
		else if(options[choice] == "stonehead")
			desc = "A stone holy figure of an imposing crowned head."
		else if(options[choice] == "stonedwarf")
			desc = "A stone holy figure of a somewhat ugly dwarf."
		else if(options[choice] == "stoneanimal")
			desc = "A stone holy figure of a four-legged animal of some sort."
		else if(options[choice] == "stonevenus")
			desc = "A stone holy figure of a lovingly rendered pregnant woman."
		else if(options[choice] == "stonesnake")
			desc = "A stone holy figure of a coiled snake ready to strike."
		else if(options[choice] == "elephant")
			desc = "A bronze holy figure of a dancing human with the head of an elephant."
		else if(options[choice] == "bronzearms")
			desc = "A bronze holy figure of a human.with four arms."
		else if(options[choice] == "robot")
			desc = "A titanium holy figure of a synthetic humanoid."
		else if(options[choice] == "singularity")
			desc = "A holy figure of some kind of energy formation."
		else if(options[choice] == "gemeye")
			desc = "A gemstone holy figure of a sparkling eye."
		else if(options[choice] == "skull")
			desc = "A golden holy figure of a humanoid skull."
		else if(options[choice] == "devil")
			desc = "A painted holy figure of a seated humanoid goat with wings."
		else if(options[choice] == "sun")
			desc = "A holy figure of a star."
		else if(options[choice] == "moon")
			desc = "A holy figure of a small planetoid."
		else if(options[choice] == "catrobe")
			desc = "A painted holy figure of a plain looking Tajaran in a robe."

		to_chat(M, "The religious icon is now a [choice]. All hail!")
		return 1



/obj/item/godfig/verb/rename_fig()
	set name = "Name Figure"
	set category = "Object"
	set desc = "Rename your icon."

	var/mob/M = usr
	if(!M.mind)	return 0

	var/input = sanitizeSafe(tgui_input_text(usr, "What do you want to name the icon?", ,"", null, MAX_NAME_LEN), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = "icon of " + input
		to_chat(M, "You name the figure. Glory to [input]!.")
		return 1
