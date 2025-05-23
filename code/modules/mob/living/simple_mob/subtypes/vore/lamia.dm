/mob/living/simple_mob/vore/lamia
	name = "purple lamia"
	desc = "Combination snake-human. This one is purple."

	icon = 'icons/mob/vore_lamia.dmi'
	icon_state = "ffta"
	icon_living = "ffta"
	icon_rest = "ffta_rest"
	icon_dead = "ffta_dead"

	harm_intent_damage = 5
	melee_damage_lower = 0
	melee_damage_upper = 0

	response_help = "pets"
	response_disarm = "gently baps"
	response_harm = "hits"

	health = 60
	maxHealth = 60

	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0
	faction = FACTION_LAMIA

	// Vore tags
	vore_active = 1
	vore_capacity = 1
	vore_capacity_ex = list("stomach" = 1, "tail" = 1)
	vore_fullness_ex = list("stomach" = 0, "tail" = 0)
	vore_bump_emote = "coils their tail around"
	vore_icons = 0
	vore_icon_bellies = list("stomach", "tail")
	// Default stomach
	vore_stomach_name = "upper stomach"
	vore_stomach_flavor = "You've ended up inside of the lamia's human stomach. It's pretty much identical to any human stomach, but the valve leading deeper is much bigger."

	// Meaningful stats
	vore_default_mode = DM_HOLD
	vore_digest_chance = 0
	vore_pounce_chance = 65
	vore_bump_chance = 50
	vore_standing_too = TRUE
	vore_escape_chance = 25

	// Special lamia vore tags
	var/vore_upper_transfer_chance = 50
	var/vore_tail_digest_chance = 25
	var/vore_tail_absorb_chance = 0
	var/vore_tail_transfer_chance = 50

	say_list_type = /datum/say_list/lamia
	ai_holder_type = /datum/ai_holder/simple_mob/passive

/mob/living/simple_mob/vore/lamia/update_icon()
	. = ..()

	if(vore_active)
		// Icon_state for fullness is as such if they are CONSCIOUS:
		// [icon_living]_vore_[upper_shows]_[tail_shows]
		// So copper_vore_1_1 is a full upper stomach *and* tail stomach
		// And copper_vore_1_0 is full upper stomach, but empty tail stomach
		// For unconscious: [icon_rest]_vore_[upper]_[tail]
		// For dead, it doesn't show.
		var/upper_shows = vore_fullness_ex["stomach"]
		var/tail_shows = vore_fullness_ex["tail"]

		if(upper_shows || tail_shows)
			if((stat == CONSCIOUS) && (!icon_rest || !resting || !incapacitated(INCAPACITATION_DISABLED)))
				icon_state = "[icon_living]_vore_[upper_shows]_[tail_shows]"
			else if(stat >= DEAD)
				icon_state = icon_dead
			else if(((stat == UNCONSCIOUS) || resting || incapacitated(INCAPACITATION_DISABLED) ) && icon_rest)
				icon_state = "[icon_rest]_vore_[upper_shows]_[tail_shows]"

/mob/living/simple_mob/vore/lamia/init_vore()
	if(!voremob_loaded)
		return
	if(LAZYLEN(vore_organs))
		return
	. = ..()
	var/obj/belly/B = vore_selected

	B.transferchance = vore_upper_transfer_chance
	B.transferlocation = "tail stomach"

	var/obj/belly/tail = new /obj/belly(src)
	tail.immutable = TRUE
	tail.affects_vore_sprites = TRUE
	tail.name = "tail stomach"
	tail.desc = "You slide out into the narrow, constricting tube of flesh that is the lamia's snake half, heated walls and strong muscles all around clinging to your form with every slither."
	tail.digest_mode = vore_default_mode
	tail.mode_flags = vore_default_flags
	tail.item_digest_mode = vore_default_item_mode
	tail.contaminates = vore_default_contaminates
	tail.contamination_flavor = vore_default_contamination_flavor
	tail.contamination_color = vore_default_contamination_color
	tail.escapable = TRUE // needed for transferchance
	tail.escapechance = 0 // No directly escaping a tail, gotta squirm back out.
	tail.digestchance = vore_tail_digest_chance
	tail.absorbchance = vore_tail_absorb_chance
	tail.transferchance = vore_tail_transfer_chance
	tail.transferlocation = "upper stomach"
	tail.human_prey_swallow_time = swallowTime
	tail.nonhuman_prey_swallow_time = swallowTime
	tail.vore_verb = "stuff"
	tail.belly_sprite_to_affect = "tail"

	// Belly Lines by killerdragn (@kilo.ego on discord) from Rogue Star
	B.emote_lists[DM_HOLD] = list(
		"You could feel the %pred drum their fingertips atop your head from outside, the walls ever so subtly clenching inwards to smear you in more of that weakly tingling slime inside.",
		"Ugh, this place wasn't as roomy as you wish it could be, pushing your hands out you found little yield in any direction, but at least you were only along for the ride.",
		"You can feel your body pressed into a balled up shape, %preds %belly giving a reassuring squeeze as if reminding you it had you to itself.",
		"%pred let out a burp, the amount of air available decreasing and leaving their stomach tightening around you while they went about their day, likely thinking about what to do with you.",
		"%pred slithers along with you inside them, content with the weight in their %belly.",
		"%pred lifted their arms above their head and did a little bellydance, smushing and sloshing you around inside.",
		"The %pred hugs their arms around their gut, giving you a firm squeeze."
	)
	B.emote_lists[DM_DIGEST] = list(
		"A persistent gnawing ache was making itself known, with the lamia's %belly churning away telling you it was hard at work digesting you down into calories you needed to get out of here before it was too late.",
		"Everything stings, a prickling tingle wherever %preds stomach acid touched that turned into a dull numbing heat after their stomach melted away your senses. You wondered if anyone was going to help you or if you were destined to become %preds tummyslop.",
		"Gggglllrrrrnn.. Ggwrrgglbllrtgluort. Over time the sounds inside %preds stomach were becoming thicker and sloppier, noticing the level of muck in there has risen, likely with whatever parts of you have already joined it.",
		"%pred jostled their stomach and burped, make it apparent they were enjoying the state of things, that is, you digesting and them seemingly relaxing relishing it, your body weakening and running like melting ice-cream under the sun while they enjoyed the fizzly pleasant tingle radiating from inside their meat filled %belly.",
		"%pred clenches their %belly around you, it just made things hurt more while they continued to digest you and soak you in that disintegrating acid.",
		"Your clothes weren't doing so well and neither were you, the lamia's belly unable to distinguish what was dropped into it, converting anything here into more fuel. Obviously by the state of the too hot pool of chyme rising towards your shoulders you were soon about to find out how it feels to be lamiafat.",
		"%pred lifted their arms above their head and sighed hotly while doing a little lamia bellydance, sloshing and gluorping you and your soupy self around in their %belly.",
		"Your captor gripped the underside of their %belly and lifted it, dunking you under the gooey stomach acids once they let go, everything becoming muffled before you broke the slimy surface tension to free yourself and managed to breath humid acrid 'air' once more."
	)
	B.struggle_messages_inside = list(
		"You push outwards with your hands and lift your head, trying to uncurl yourself in this cramped humid prison, the walls push back and force you back into a ball.",
		"Every twitch and squirm inside just seems to coat you in more and more of that tingling acidic slime.",
		"%pred lets out a small burp thanks to you dislodging a pocket of air inside, leaving you woozier than before.",
		"All your struggling doesn't seem to be doing much other than giving %pred a tummy massage from the inside, their stomach growling louder in response.",
		"Put up as much of a fight as you may, it doesn't seem to do much, perhaps you need to keep trying, but your arms were growing tired.",
		"You struggled with all your might, leaving the lamia winded for a moment, they burped with momentary indigestion."
	)
	B.struggle_messages_outside = list(
		"Struggles and cries emit from %preds %belly, hands pushing out jostling that prey-filled gut side to side.",
		"You were able to make out %preys face pushing out from %preds %belly, they didn't look happy!",
		"%pred burps when someone inside their %belly kicks and wobbles themself around inside.",
		"%preds %belly ggllrrt's and gluts as the curled up shape inside resists being balled up, although they relent and are forced back into compliance.",
		"%pred bops someones head bulging from their %belly. Chastising them for struggling."
	)
	B.digest_messages_prey = list(
		"For all your fighting and struggling you couldn't resist the lamia's efforts to eventually suffuse you down completely into the nutritious sludge you had been whipped up into this whole time, soaking in their acid for so long you had melted down into a dense soup that they are going to be happy feeling pumping through their guts and fattening their body. Congratulations, you're part of a lamia's waistline.",
		"The bulges you made in the lamia's stomach have completely rounded and smoothed over by now. You are left to burble and glub inside %pred as a thick stew. Your things starting to bulge the underside of their swollen belly while whatever was left of you melted away into a slurry in the lamia's gworgling belly, soon to be filtered down through their lower body.",
		"You were far too weak to continue resisting the lamia's %belly, you wanted to rest and nothing more. With no more strength and no fight to give, you submit to the burbling mirepit inside the lamia's %belly , feeling yourself sink below the surface suspended in that dense chyme while suffusing right into it, all those hot tingling sensations just a blurry afterthought as you're completely unmade."
	)
	//TAIL TIME!!!~~~
	tail.emote_lists[DM_HOLD] = list(
		"The walls swaddled your motions, smothering thick flesh idly kneaded and squeezed, conforming to your shapes and keeping you coated in that dull acid.",
		"Ominous low groans and gluorps echoed around you, %pred squeezing down over the shapes you made on their %belly.",
		"The feeling in here wasn't entirely unpleasant when their stomach wasn't too tight, the undulations against your back like a massage, leaving your eyes fluttering shut for a few minutes.",
		"You open your eyes afew what must have been a brief nap, the warm walls seemed to caress your body upon your movement.",
		"You could feel your body squeezed inwards from all sides at random, a ceaseless snuggling of the lamia's stomach paired with one of their hands feeling over your shapes from the outside had you wondering if anyone was around to help.",
		"Your body twisted and bent this way and that as the lamia slithered along.",
		"You seemed to be safe here for now, the walls idly and deftly rubbed along you, you could try to struggle and get out, but that might rile their stomach up."
	)
	tail.emote_lists[DM_DIGEST] = list(
		"The walls ground firmly into you, smearing and coating you in that tingling acid which burned through your clothing.",
		"The lamia's %belly was operating as intended, processing down the meat inside it, that would be you.",
		"Loud gurgling growls vibrated through your body while the lamia's %belly clenched and oppressively smothered you.",
		"For a moment you were rolled onto your stomach and forced under the surface of the acids, thankfully after a flurry of squirming you managed some grip on the slippery walls to get onto your back once more.",
		"Your body was aching in here, soreness turning into a gnawing pain that beckoned you to flee, but which way could you go?",
		"You could hear the lamia musing something about how you didn't stand a chance, a pat atop the softening lump you made in their %belly was as much injury as insult, you were feeling a tad spent.",
		"A fizzling hot slimy bath was doing its best to render you down into a form the lamia's body could work with easier, acids stinging and seeping through your form to reduce its integrity into a uniform slurry.",
		"It was hard to breathe, you could feel the dull tingling heat in your chest from breathing the foggy fumes in here, definitely not good for you but neither is being digested.",
		"You were wondering if you'd be able to get out looking close to how you went in if this goes on any longer, this organ was built to deconstruct things into nutrition after all."
	)
	tail.struggle_messages_inside = list(
		"You twist and turn, nearly drowning yourself in the acid slowly building underneath you.",
		"Kicking and shoving, you jostle and bulge out the lamia's %belly well, but don't seem to make any progress in actually escaping, instead the walls just squeeze down and crush you in retaliation.",
		"You try to work yourself into as much of an uncomfortable shape for your predator as you can, sadly you've been eaten by a flexible lamia, who just laughs at your attempts before straightening their lower body out undoing your effort.",
		"%pred fights back by bending their lower body into an S shape, scrunching you up inside as you attempt to struggle free, resisting your attempts.",
		"All your fidgeting earned you a sudden smack against a hard surface leaving you dazed, it seemed %pred didn't appreciate all your struggles.",
		"You tried hard to get free, pushing your hands upwards against the valve you came in through, starting to work it open before %pred clenches down over you, forcing your escape shut at the last second, you'd have to try harder.",
		"You nearly managed to push with your legs and find some sort of give to force yourself out of their lower stomach but it seemed to resist your attempt.",
		"%pred flopped down atop you outside when you squirmed, listening to your voice and chuckling, suddenly giving you a hug with their arms.",
		"You rocked your hips side to side and shoved your shoulders in a similar motion, trying to make the lamia develop indigestion, a sudden sigh outside instead sounded like you just gave them a wonderful tummy massage from the inside.",
		"You kick your leg to let the lamia know you want out, it seems to just... ignore you, what did you expect?"
	)
	tail.struggle_messages_outside = list(
		"%preds %belly groans deeply from someone struggling inside of it, kicking and jostling it.",
		"Someone struggles inside of %pred, the lamia bending and twisting their tail to bully their prey inside.",
		"It was hard to tell what they were saying, but someone was calling for help from inside of %pred, fighting to get out but the lamia simply shook their head and laughed.",
		"The struggles inside of %preds %belly were growing weaker, but they were still trying to get free.",
		"Deep low ominous groans rose from that belly when whoever was inside stirred it up from the inside with their squirming.",
		"The lamia seemed satisfied from their prey giving them a massage from the inside, a blissed out look on their face when someones hands pushed out and then slipped out of sight.",
		"Someone rolled and turned inside %preds lower body trying to find the way out, making no progress."
	)
	tail.digest_messages_prey = list(
		"You were burbling and bubbling inside this lethal sleeping bag for longer than you ought to be, the only option now was to sleep in forever, barely able to keep your eyes open while your body refused to respond to any input the lamia's %belly had done an efficient job of rendering your entire body down. You didn't have long to think before even your consciousness began to spread out and fill the lamia's lengthy lower stomach in a nutritious puddle left to be squeezed and piped through the rest of their digestive system and sent right onto their body.",
		"It was a grueling feat to go through the many stages of digestion inside a lamia's %belly, forced to lay there and submit to a lethargic digestion and feel yourself break down steadily, for all your efforts and struggling you just couldn't overcome the power of this half-serpent breaking you down over the next few hours, it hurt at first but now it was all just a dull hot swaddling blanket of chyme welcoming you to your new existence as bellysoup.",
		"You kicked, squirmed, twisted, rolled and voiced all your frustrations but none of them would stop %pred from digesting you completely, everything you were and could be reduced to a disgusting caloric sludge inside the lamia's %belly. None of your weak struggles from here on out mattered, you twitched and lurched- pushing your hands out weakly hoping someone could rescue you at this last moment but alas your strength failed and you were forced to become food, thoughts drifting off as your meaty self was squeezed and churned down totally after you lost consciousness."
	)

// FFTA Bra
/mob/living/simple_mob/vore/lamia/bra
	desc = "Combination snake-human. This one is purple. They're wearing a bra."
	icon_state = "ffta_bra"
	icon_living = "ffta_bra"
	icon_rest = "ffta_bra_rest"
	icon_dead = "ffta_bra_dead"

// Albino
/mob/living/simple_mob/vore/lamia/albino
	name = "albino lamia"
	desc = "Combination snake-human. This one is albino."
	icon_state = "albino"
	icon_living = "albino"
	icon_rest = "albino_rest"
	icon_dead = "albino_dead"

/mob/living/simple_mob/vore/lamia/albino/bra
	desc = "Combination snake-human. This one is albino. They're wearing a bra."
	icon_state = "albino_bra"
	icon_living = "albino_bra"
	icon_rest = "albino_bra_rest"
	icon_dead = "albino_bra_dead"

/mob/living/simple_mob/vore/lamia/albino/shirt
	desc = "Combination snake-human. This one is albino. They're wearing a shirt."
	icon_state = "albino_shirt"
	icon_living = "albino_shirt"
	icon_rest = "albino_shirt_rest"
	icon_dead = "albino_shirt_dead"

// Cobra
/mob/living/simple_mob/vore/lamia/cobra
	name = "cobra lamia"
	desc = "Combination snake-human. This one looks like a cobra."
	icon_state = "cobra"
	icon_living = "cobra"
	icon_rest = "cobra_rest"
	icon_dead = "cobra_dead"

/mob/living/simple_mob/vore/lamia/cobra/bra
	desc = "Combination snake-human. This one looks like a cobra. They're wearing a bra."
	icon_state = "cobra_bra"
	icon_living = "cobra_bra"
	icon_rest = "cobra_bra_rest"
	icon_dead = "cobra_bra_dead"

/mob/living/simple_mob/vore/lamia/cobra/shirt
	desc = "Combination snake-human. This one looks like a cobra. They're wearing a shirt."
	icon_state = "cobra_shirt"
	icon_living = "cobra_shirt"
	icon_rest = "cobra_shirt_rest"
	icon_dead = "cobra_shirt_dead"

// Copper
/mob/living/simple_mob/vore/lamia/copper
	name = "copper lamia"
	desc = "Combination snake-human. This one is copper."
	icon_state = "copper"
	icon_living = "copper"
	icon_rest = "copper_rest"
	icon_dead = "copper_dead"

/mob/living/simple_mob/vore/lamia/copper/bra
	desc = "Combination snake-human. This one is copper. They're wearing a bra."
	icon_state = "copper_bra"
	icon_living = "copper_bra"
	icon_rest = "copper_bra_rest"
	icon_dead = "copper_bra_dead"

/mob/living/simple_mob/vore/lamia/copper/shirt
	desc = "Combination snake-human. This one is copper. They're wearing a shirt."
	icon_state = "copper_shirt"
	icon_living = "copper_shirt"
	icon_rest = "copper_shirt_rest"
	icon_dead = "copper_shirt_dead"

// Green
/mob/living/simple_mob/vore/lamia/green
	name = "green lamia"
	desc = "Combination snake-human. This one is green."
	icon_state = "green"
	icon_living = "green"
	icon_rest = "green_rest"
	icon_dead = "green_dead"

/mob/living/simple_mob/vore/lamia/green/bra
	desc = "Combination snake-human. This one is green. They're wearing a bra."
	icon_state = "green_bra"
	icon_living = "green_bra"
	icon_rest = "green_bra_rest"
	icon_dead = "green_bra_dead"

/mob/living/simple_mob/vore/lamia/green/shirt
	desc = "Combination snake-human. This one is green. They're wearing a shirt."
	icon_state = "green_shirt"
	icon_living = "green_shirt"
	icon_rest = "green_shirt_rest"
	icon_dead = "green_shirt_dead"

// Zebra
/mob/living/simple_mob/vore/lamia/zebra
	name = "zebra lamia"
	desc = "Combination snake-human. This one has a zebra pattern."
	icon_state = "zebra"
	icon_living = "zebra"
	icon_rest = "zebra_rest"
	icon_dead = "zebra_dead"

/mob/living/simple_mob/vore/lamia/zebra/bra
	desc = "Combination snake-human. This one has a zebra pattern. They're wearing a bra."
	icon_state = "zebra_bra"
	icon_living = "zebra_bra"
	icon_rest = "zebra_bra_rest"
	icon_dead = "zebra_bra_dead"

/mob/living/simple_mob/vore/lamia/zebra/shirt
	desc = "Combination snake-human. This one has a zebra pattern. They're wearing a shirt."
	icon_state = "zebra_shirt"
	icon_living = "zebra_shirt"
	icon_rest = "zebra_shirt_rest"
	icon_dead = "zebra_shirt_dead"

GLOBAL_LIST_INIT(valid_random_lamias, list(
	/mob/living/simple_mob/vore/lamia,
	/mob/living/simple_mob/vore/lamia/bra,
	/mob/living/simple_mob/vore/lamia/albino,
	/mob/living/simple_mob/vore/lamia/albino/bra,
	/mob/living/simple_mob/vore/lamia/albino/shirt,
	/mob/living/simple_mob/vore/lamia/cobra,
	/mob/living/simple_mob/vore/lamia/cobra/bra,
	/mob/living/simple_mob/vore/lamia/cobra/shirt,
	/mob/living/simple_mob/vore/lamia/copper,
	/mob/living/simple_mob/vore/lamia/copper/bra,
	/mob/living/simple_mob/vore/lamia/copper/shirt,
	/mob/living/simple_mob/vore/lamia/green,
	/mob/living/simple_mob/vore/lamia/green/bra,
	/mob/living/simple_mob/vore/lamia/green/shirt,
	/mob/living/simple_mob/vore/lamia/zebra,
	/mob/living/simple_mob/vore/lamia/zebra/bra,
	/mob/living/simple_mob/vore/lamia/zebra/shirt,
))

/mob/living/simple_mob/vore/lamia/random
/mob/living/simple_mob/vore/lamia/random/New()
	var/mob/living/simple_mob/vore/lamia/new_attrs = pick(GLOB.valid_random_lamias)

	name = initial(new_attrs.name)
	desc = initial(new_attrs.desc)

	icon_state = initial(new_attrs.icon_state)
	icon_living = initial(new_attrs.icon_living)
	icon_rest = initial(new_attrs.icon_rest)
	icon_dead = initial(new_attrs.icon_dead)

	vore_default_mode = initial(new_attrs.vore_default_mode)
	vore_digest_chance = initial(new_attrs.vore_digest_chance)
	vore_pounce_chance = initial(new_attrs.vore_pounce_chance)
	vore_bump_chance = initial(new_attrs.vore_bump_chance)
	vore_standing_too = initial(new_attrs.vore_standing_too)
	vore_escape_chance = initial(new_attrs.vore_escape_chance)

	vore_upper_transfer_chance = initial(new_attrs.vore_upper_transfer_chance)
	vore_tail_digest_chance = initial(new_attrs.vore_tail_digest_chance)
	vore_tail_absorb_chance = initial(new_attrs.vore_tail_absorb_chance)
	vore_tail_transfer_chance = initial(new_attrs.vore_tail_transfer_chance)

	. = ..()

/datum/say_list/lamia
	speak = list("Sss...","Sss!","Hiss!","HSSSSS")
	emote_hear = list("hisses","slithers")
	emote_see = list("shakes her head","coils","stretches","slithers")
