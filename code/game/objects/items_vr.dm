/obj/item
	var/list/possessed_voice = list()//Allows for items to be possessed/inhabited by voices.


/obj/item/proc/inhabit_item(var/mob/candidate, var/candidate_name, var/mob/living/candidate_original_form)
	//This makes it so that any object in the game can have something put in it like the cursed sword!
	//This means the proc can also be manually called by admin commands.
	//Handle moving the person into the object.
	var/mob/living/voice/new_voice = new /mob/living/voice(src) 	//Make the voice mob the person is going to be.
	new_voice.transfer_identity(candidate) 			//Now make the voice mob load from the ghost's active character in preferences.
	new_voice.mind = candidate.mind					//Transfer the mind, if any.
	new_voice.ckey = candidate.ckey					//Finally, bring the client over.
	new_voice.tf_mob_holder = candidate_original_form //Save what mob they are! We'll need this for OOC escape and transformation back to their normal form.
	if(candidate_name) 								//Were we given a candidate_name? Great! Name them that.
		new_voice.name = "[candidate_name]"
	else
		new_voice.name = "[name]" 					//No name given? Give them the name of the object they're inhabiting.
	new_voice.real_name = "[new_voice.real_name]" 	//We still know their real name though!
	possessed_voice.Add(new_voice)
	listening_objects |= src
	new_voice.verbs -= /mob/living/voice/verb/change_name //No changing your name! Bad!
	new_voice.verbs -= /mob/living/voice/verb/hang_up //Also you can't hang up. You are the item!