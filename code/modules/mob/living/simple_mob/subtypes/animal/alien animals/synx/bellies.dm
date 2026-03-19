/mob/living/simple_mob/animal/synx/load_default_bellies()
	. = ..()
	var/obj/belly/B = vore_selected
	//B.human_prey_swallow_time = 6 SECONDS //doesnt work
	//B.nonhuman_prey_swallow_time = 3 SECONDS //doesnt work
	B.vore_verb = "swallow"
	B.name = "stomach"
	B.desc	= "You're pulled into the snug stomach of the synx. The walls knead weakly around you, coating you in thick, viscous fluids that cling to your body, that soon starts to tingle and burn..."
	B.digest_burn = 1
	B.digest_brute = 0
	B.emote_lists[DM_HOLD] = list(
	"The walls churn around you, soaking you in thick, smelling fluid as you're kneaded and rolled about in the surprisingly roomy, but still snug, space.",
	"The unusually cool stomach rolls around you slowly and lazily, trying to almost knead you to sleep gently as the synx pulses around you.",
	"The thick, viscous fluids cling to your body soaking in deep, giving you a full bath with the kneading of the walls helping to make sure you'll be smelling like synx stomach for days."
	)
	B.emote_lists[DM_DIGEST] = list(
	"The stomach kneads roughly around you, squishing and molding to your shape, with the thick fluids clinging to your body and tingling, making it hard to breathe.",
	"Firm churns of the stomach roll and knead you around, your body tingling as fur sizzles all around you, your body getting nice and tenderized for the stomach.",
	"Your body tingles and the air smells strongly of acid, as the stomach churns around you firmly and slowly, eager to break you down.",
	"You're jostled in the stomach as the synx lets out what can only described as an alien belch, the space around you getting even more snug as the thick acids rise further up your body."
	)
	B.digest_messages_prey = list(
	"Your eyes grow heavy as the air grows thin in the stomach, the burning of the acids slowly putting you into a final slumber, adding you to the synx's hips and tail.",
	"Slowly, the stinging and burning of the acids, and the constant churning is just too much, and with a few final clenches, your body is broken down into fuel for the synx.",
	"The acids and fluids rise up above your head, quickly putting an end to your squirming and conciousness.. the stomach eager to break you down completely.",
	"The synx lets out an audible belch, the last of your air going with it, and with a few audible crunches from the outside, the stomach claims you as food for the parasite."
	)
	B.mode_flags = DM_FLAG_NUMBING	//Prey are more docile when it doesn't hurt.

/* //OC-insert mob removals. Commenting out instead of full removal as there's some good detail here.
/mob/living/simple_mob/animal/synx/ai/pet/asteri/load_default_bellies()
	. = ..()
	var/obj/belly/B = vore_selected
	B.desc    = "The synx eagerly swallows you, taking you from its gullet into its long, serpentine stomach. The internals around you greedily press into your from all sides, keeping you coated in a slick coat of numbing fluids..."
	B.digest_burn = 2
	B.digest_brute = 0 //no brute should be done. ramping up burn as a result. this is acid. -Lo
	B.emote_lists[DM_HOLD] = list(
	"Your taut prison presses and pads into your body, the synx squeezing around you almost constrictingly tight while the rolling pulses of muscle around you keep your squirms well-contained.",
	"You can feel parts of you sink and press into the squishy stomach walls as the synx's gut seems to relax, the wet ambience of its stomach muffling the parasite's various heartbeats.",
	"You can hear the synx teasingly mimic the sounds you've made while it's eaten you, the stomach walls practically massaging more of numbing fluid into you as its innards do their best to tire you out.",
	)
	B.emote_lists[DM_DIGEST] = list(
	"The stomach gives a crushing squeeze around your frame, its body restraining your movements and pressing digestive fluids deeper into you with overwhelming pressure from all sides..",
	"The synx's insides greedily press into you all over, kneading around your body and softening you up for the slurry of numbing acid that's pooled around your melting frame.",
	"You can hear a cacophony of wet churns and gurgles from the synx's body as it works on breaking you down, the parasite eagerly awaiting your final moments.",
	"The tight, fleshy tunnel constricts around you, making it even harder to breathe the already thin air as the digestive cocktail around you wears you out.",
	)
	B.digest_messages_prey = list(
	"You finally give in to the constricting pressure, softened up enough for the acids around you to turn your entire being into a gooey slop to be pumped through its body.",
	"Slipping past the point of saving, your body gives out on you as the stomach walls grind your goopy remains into a chunky sludge, leaving behind only a few acid-soaked bones for it to stash in the vents.",
	"The constant fatal massage pulls you under, your conciousness fading away as you're drawn into a numb, permanent sleep. The body you leave behind is put to good use as a few extra pounds on the synx's frame, its now-wider hips making it just a little harder to squeeze through the vents it's so fond of.",
	"The synx's body gleefully takes what's left of your life, Asteri's usually-repressed sadism overwhelmed with a sinister satisfaction in snuffing you out as your liquefied remains gush into a bit more heft on the parasite's emaciated frame.",
	)
*/
