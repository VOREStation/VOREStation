/*	This code is responsible for the examine tab.  When someone examines something, it copies the examined object's description_info,
	description_fluff, and description_antag, and shows it in a new tab.

	In this file, some atom and mob stuff is defined here.  It is defined here instead of in the normal files, to keep the whole system self-contained.
	This means that this file can be unchecked, along with the other examine files, and can be removed entirely with no effort.
*/

#define EXAMINE_PANEL_PADDING "        "

/atom/
	var/description_info = null //Helpful blue text.
	var/description_fluff = null //Green text about the atom's fluff, if any exists.
	var/description_antag = null //Malicious red text, for the antags.

//Override these if you need special behaviour for a specific type.
/atom/proc/get_description_info()
	if(description_info)
		return description_info
	return

/atom/proc/get_description_fluff()
	if(description_fluff)
		return description_fluff
	return

/atom/proc/get_description_antag()
	if(description_antag)
		return description_antag
	return

// This one is slightly different, in that it must return a list.
/atom/proc/get_description_interaction()
	return list()

// Quickly adds the boilerplate code to add an image and padding for the image.
/proc/desc_panel_image(var/icon_state)
	return "[bicon(description_icons[icon_state])][EXAMINE_PANEL_PADDING]"

/mob/living/get_description_fluff()
	if(flavor_text) //Get flavor text for the green text.
		return flavor_text
	else //No flavor text?  Try for hardcoded fluff instead.
		return ..()

/mob/living/carbon/human/get_description_fluff()
	return print_flavor_text(0)

/* The examine panel itself */

/client/var/description_holders[0]

/client/proc/update_description_holders(atom/A, update_antag_info=0)
	description_holders["info"] = A.get_description_info()
	description_holders["fluff"] = A.get_description_fluff()
	description_holders["antag"] = (update_antag_info)? A.get_description_antag() : ""
	description_holders["interactions"] = A.get_description_interaction()

	description_holders["name"] = "[A.name]"
	description_holders["icon"] = "[bicon(A)]"
	description_holders["desc"] = A.desc

/mob/Stat()
	. = ..()
	if(client && statpanel("Examine"))
		var/description_holders = client.description_holders
		stat(null,"[description_holders["icon"]]    <font size='5'>[description_holders["name"]]</font>") //The name, written in big letters.
		stat(null,"[description_holders["desc"]]") //the default examine text.
		if(description_holders["info"])
			stat(null,"<font color='#084B8A'><b>[description_holders["info"]]</b></font>") //Blue, informative text.
		if(description_holders["interactions"])
			for(var/line in description_holders["interactions"])
				stat(null, "<font color='#084B8A'><b>[line]</b></font>")
		if(description_holders["fluff"])
			stat(null,"<font color='#298A08'><b>[description_holders["fluff"]]</b></font>") //Yellow, fluff-related text.
		if(description_holders["antag"])
			stat(null,"<font color='#8A0808'><b>[description_holders["antag"]]</b></font>") //Red, malicious antag-related text

//override examinate verb to update description holders when things are examined
/mob/examinate(atom/A as mob|obj|turf in view())
	if(..())
		return 1

	update_examine_panel(A)

/mob/proc/update_examine_panel(var/atom/A)
	if(client)
		var/is_antag = ((mind && mind.special_role) || isobserver(src)) //ghosts don't have minds
		client.update_description_holders(A, is_antag)
