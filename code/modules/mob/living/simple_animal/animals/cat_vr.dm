/mob/living/simple_animal/cat/fluff/Runtime/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "Stomach"
	B.desc = "The slimy wet insides of Runtime! Not quite as clean as the cat on the outside."

	B.emote_lists[DM_HOLD] = list(
		"Runtime's stomach kneads gently on you and you're fairly sure you can hear her start purring.",
		"Most of what you can hear are slick noises, Runtime breathing, and distant purring.",
		"Runtime seems perfectly happy to have you in there. She lays down for a moment to groom and squishes you against the walls.",
		"The CMO's pet seems to have found a patient of her own, and is treating them with warm, wet kneading walls.",
		"Runtime mostly just lazes about, and you're left to simmer in the hot, slick guts unharmed.",
		"Runtime's master might let you out of this fleshy prison, eventually. Maybe. Hopefully?")

	B.emote_lists[DM_DIGEST] = list(
		"Runtime's stomach is treating you rather like a mouse, kneading acids into you with vigor.",
		"A thick dollop of bellyslime drips from above while the CMO's pet's gut works on churning you up.",
		"Runtime seems to have decided you're food, based on the acrid air in her guts and the pooling fluids.",
		"Runtime's stomach tries to claim you, kneading and pressing inwards again and again against your form.",
		"Runtime flops onto their side for a minute, spilling acids over your form as you remain trapped in them.",
		"The CMO's pet doesn't seem to think you're any different from any other meal. At least, their stomach doesn't.")

	B.digest_messages_prey = list(
		"Runtime's stomach slowly melts your body away. Her stomach refuses to give up it's onslaught, continuing until you're nothing more than nutrients for her body to absorb.",
		"After an agonizing amount of time, Runtime's stomach finally manages to claim you, melting you down and adding you to her stomach.",
		"Runtime's stomach continues to slowly work away at your body before tightly squeezing around you once more, causing the remainder of your body to lose form and melt away into the digesting slop around you.",
		"Runtime's slimy gut continues to constantly squeeze and knead away at your body, the bulge you create inside of her stomach growing smaller as time progresses before soon dissapearing completely as you melt away.",
		"Runtime's belly lets off a soft groan as your body finally gives out, the cat's eyes growing heavy as it settles down to enjoy it's good meal.",
		"Runtime purrs happily as you slowly slip away inside of her gut, your body's nutrients are then used to put a layer of padding on the now pudgy cat.",
		"The acids inside of Runtime's stomach, aided by the constant motions of the smooth walls surrounding you finally manage to melt you away into nothing more mush. She curls up on the floor, slowly kneading the air as her stomach moves its contents — including you — deeper into her digestive system.",
		"Your form begins to slowly soften and break apart, rounding out Runtime's swollen belly. The carnivorous cat rumbles and purrs happily at the feeling of such a filling meal.")
