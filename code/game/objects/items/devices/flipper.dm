/*
* Your Multi-Functional Security Companion
*/

// Card
/obj/item/paicard/flipper
	name 		= "Vix"

/obj/item/paicard/flipper/Initialize(mapload)
	emag_act()
	pai = new /mob/living/silicon/pai/flipper(src)
	. = ..()
	desc = "The [name] is a versatile security device designed to protect and empower users in a variety of contexts. With features such as wireless hacking, radio analysis, signal jamming, and physical lock picking, the [name] is the ultimate tool for security professionals, hobbyists, and anyone seeking to better understand and defend against modern threats. Whether you're investigating a security breach, testing your own defenses, or simply curious about the workings of wireless technology, the [name] has you covered."
	setEmotion(4)

// Mob
/mob/living/silicon/pai/flipper
	name 		= "Vix"
	chassis_name = PAI_DEFAULT_EMAGGED_CHASSIS
	default_pai_card_path = /obj/item/paicard/flipper // Triggers the emag state

// Vore
/mob/living/silicon/pai/flipper/init_vore(force)
	var/obj/belly/B = new /obj/belly/flipper/maw(src)
	B.affects_vore_sprites = FALSE
	B.emote_lists[DM_HOLD] = list(
	"The wet, plush lining of [name]'s maw surrounds you, enveloping you in a soft and slightly sticky embrace. The walls pulse and undulate gently, as if alive, creating a soothing rhythm that lulls you into a sense of calm.",
	"You're encased in the warm and humid space of [name]'s maw, the slick surfaces glistening around you. The soft movements of the walls feel almost like the caress of a living creature.",
	"The wet, fleshy walls of [name]'s maw seem to pulse and throb in time with your heartbeat, as if they're alive and responding to your presence. The soft and yielding surface wraps around you like a protective cocoon.",
	"You feel the gentle pressure of [name]'s maw all around you, the slick and wet surfaces pulsating softly. The sensation is oddly comforting, as if you're being cradled in the embrace of a nurturing being.",
	"The warm, moist environment of [name]'s maw surrounds you completely, the walls of flesh glistening and undulating gently. The soft, plush surface seems to mold itself to your form, creating a snug and comfortable space for you to rest in.")
	vore_selected = B

	B = new /obj/belly/flipper/throat(src)
	B.affects_vore_sprites = FALSE
	B.emote_lists[DM_HOLD] = list(
		"The narrow passage of [name]'s throat envelops you in its warm embrace, the smooth metallic walls pressing snugly against your body.",
		"You feel the intricate machinery of [name]'s throat pulse and undulate around you.",
		"As you navigate the cramped yet reassuring space of [name]'s throat, you feel a sense of comfort and safety.",
		"[name]'s throat closes tightly around you, cocooning you in its silken embrace as it works to keep you safe and secure.",
		"The warm, inviting space of [name]'s throat wraps snugly around you, providing a sense of comfort and reassurance.")

	B = new /obj/belly/flipper/stomach(src)
	B.emote_lists[DM_DIGEST] = list(
		"The cavernous stomach of the [name] rumbles and churns,.",
		"The walls of [name]'s stomach squish and squelch around you, the sophisticated machinery working in perfect harmony.",
		"The rhythmic kneading and massaging of [name]'s stomach is both comforting and reassuring.",
		"The warm and inviting embrace of [name]'s stomach envelops you in its comforting embrace.",
		"[name]'s stomach compresses tightly around you, its powerful systems working aroud you.",
		"[name]'s stomach hums and churns around you.")
	. = ..()

//Belly stuff
/obj/belly/flipper
	autotransferchance = 50
	autotransferwait = 150
	escapable = 1
	escapechance = 100
	escapetime = 30
	fancy_vore = 1
	contamination_color = "grey"
	contamination_flavor = "Wet"
	vore_verb = "slurp"
	belly_fullscreen_color = "#711e1e"

/obj/belly/flipper/maw
	name = "Maw"
	desc = "As you're caught off guard by the sudden movement, The AIs mechanical jaws snap shut to trap you. You find yourself inside the warm and soft mechanical maw. The interior of the maw is lined with a smooth, metallic coating that glints in the light. The tongue, lifts you up against the insides of its metallic teeth and against the ridges of its palate, which are covered in various ports and connectors. It's growled breaths gust from its back hatch, blasting you with warm air and making your body shiver. You can sense the maw is preparing to unleash you into its next stage of operation."
	escapechance = 100
	struggle_messages_inside = list(
		"You wriggle and wrestle for purchase against the metallic tongue, which lifts and cocoons you tightly between itself and the palate.",
		"You try to pry at the interlocked teeth, but they don't budge. The jaws snap shut once more, trapping you inside the maw.",
		"You try to wriggle towards the front of the jaws to avoid the next stage of operation. However, the tongue scoops you up and brings you close to the hatch of the back throat.",
		"You brace yourself against the metallic mattress of the tongue, pressing your limbs against the roof, and try to force the jaws open. However, your efforts are futile, and their growled breaths gust over you more forcefully.",
		"You squirm and struggle, trying to find a way out, but the tongue slithers out to wrap around your limbs, tugging you back inside with a noisy sound of metallic lips.")
	autotransferlocation = "Throat"
	belly_fullscreen = "a_tumby"
	vore_sound = "Insertion1"

/obj/belly/flipper/throat
	name = "Throat"
	transferchance = 20
	transferlocation = "Maw"
	escapechance = 0
	desc = "You are swallowed,, surrounded by a warm, oily mechanical tunnel. The walls pulsate rhythmically around you, clenching and relaxing in time with the AI's breathing. You feel a sense of claustrophobia as you are forced deeper and deeper into its throat, inching closer to your final destination."
	struggle_messages_inside = list(
		"You squirm and struggle, trying to push your way back out through the AI's throat. It's no use, however, as the walls continue to squeeze tighter around you.",
		"You try to force your way out through the walls of the throat, but they resist your efforts, leaving you trapped inside the metallic chamber.",
		"The walls of the throat press tightly against you, leaving you struggling for breath as you're pulled deeper into the AI's body.",
		"You strain against the walls of the throat, hoping to force your way out through the metallic chamber. It's no use, however, as they continue to squeeze tighter around you.",
		"You writhe and squirm, trying to escape the claustrophobic confines of the AI's throat. It's no use, however, as you're forced ever deeper into the warm, oily tunnel.")
	autotransferlocation = "Stomach"
	belly_fullscreen = "another_tumby"
	vore_sound = "Tauric Swallow"

/obj/belly/flipper/stomach
	name = "Stomach"
	escapechance = 0
	transferchance = 10
	transferlocation = "Throat"
	desc = "The final destination of your mechanical journey, a warm and soft stomach. After being swallowed, you find yourself immersed in a thick, gooey pool of digestive juices that softly sloshes with each movement of the creature. The walls around you are warm and plush, constantly pulsating with rhythmic undulations that squeeze and massage your entire body. There's no escape from this cozy and comforting chamber, as you feel the gentle yet relentless contractions pushing you deeper into the digestive system. The air is thick and heavy with the scent of acid, which only gets stronger as you sink further down into the stomach. Every now and then, the walls spasm and contract, squeezing the viscous juices all over your body, coating you in their warm and slimy embrace. You can hear the distant gurgles and groans of the digestive system, a reminder of your inescapable fate as its prey."
	digest_mode = DM_DIGEST
	digest_brute = 0
	digest_burn = 2
	struggle_messages_inside = list(
	"You struggle and squirm, but the walls around you are too soft and pliable, yielding to your every movement without any resistance. Every time you try to push your way out, the walls just squeeze you tighter, reminding you that there's no escape from this warm and cozy prison.",
	"You search for any signs of an exit, but the walls around you are too thick and plush, absorbing all of your movements without a trace. You're trapped here, at the mercy of their digestive system, slowly melting away in its warm and slimy embrace.",
	"You press your limbs and body against the soft walls, trying to push your way out. But the walls just close in around you, enveloping you in a tight and suffocating hug. You can feel the warm and slimy digestive juices slowly dissolving your flesh, as you become one with the creature that swallowed you.",
	"You thrash and flail, trying to break free from the soft and pliable walls that surround you. But every movement just makes the stomach walls pulsate and squeeze tighter around you, coaxing you deeper into the creature's digestive system.",
	"You try to resist the relentless contractions of the stomach walls, but they're too warm and plush, too soft and pliable. Every movement you make just sends ripples of pleasure throughout the creature's digestive system, making it squeeze and massage you even harder.")
	belly_fullscreen = "da_tumby"
	vore_sound = "Stomach Move"
