// ---------------------------------------------
// -!-!-!-!-!-!-!-!- READ ME -!-!-!-!-!-!-!-!-!-
// ---------------------------------------------

//Beep beep hello
//
//Use this file to define the exclusive abilities of the spidertaur folk
//
//ahuhuhuhu
//-Antsnap

obj/item/clothing/suit/web_bindings
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	name = "web bindings"
	desc = "A webbed cocoon that completely restrains the wearer."
	icon_state = "web_bindings"
	item_state = "web_bindings_mob"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL

/* //Commenting all this out, as people keep abusing it. Sorry!
mob/proc/weaveWeb()
	set name = "Weave Web"
	set category = "Species Powers"
	if(nutrition >= 500) //People decided to abuse it. Sorry. It was asked to be made so it couldn't be spammed, and what do ya know, people are spamming it everywhere.
		src.visible_message("<span class='notice'>\the [src] weaves a web from their spinneret silk.</span>")
		nutrition -= 500
		spawn(30) //3 seconds to form
		new /obj/effect/spider/stickyweb(src.loc)
	else
		to_chat(src, "You do not have enough nutrition to create webbing!")
*/

mob/proc/weaveWebBindings()
	set name = "Weave Web Bindings"
	set category = "Species Powers"
	if(nutrition >= 30) //This isn't a huge problem. This is so you can bind people up.
		src.visible_message("<span class='notice'>\the [src] pulls silk from their manibles and delicately weaves it into bindings.</span>")
		nutrition -= 30
		spawn(30) //5 seconds to weave the bindings~
			var/obj/item/clothing/suit/web_bindings/bindings = new() //This sprite is amazing, I must say.
			src.put_in_hands(bindings)
	else
		to_chat(src, "You do not have enough nutrition to create webbing!") //CK~
