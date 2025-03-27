/mob
	var/digestable = TRUE				// Can the mob be digested inside a belly?
	var/devourable = TRUE				// Can the mob be devoured at all?
	var/feeding = TRUE					// Can the mob be vorishly force fed or fed to others?
	var/absorbable = TRUE				// Are you allowed to absorb this person?
	var/resizable = TRUE				// Can other people resize you? (Usually ignored for self-resizes)
	var/digest_leave_remains = FALSE	// Will this mob leave bones/skull/etc after the melty demise?
	var/allowmobvore = TRUE				// Will simplemobs attempt to eat the mob?
	var/obj/belly/vore_selected			// Default to no vore capability.
	var/list/vore_organs = list()		// List of vore containers inside a mob
	var/absorbed = FALSE				// If a mob is absorbed into another
	var/vore_taste = null				// What the character tastes like
	var/vore_smell = null				// What the character smells like
	var/noisy = FALSE					// Toggle audible hunger.
	var/permit_healbelly = TRUE
	var/stumble_vore = TRUE				//Enabled by default since you have to enable drop pred/prey to do this anyway
	var/slip_vore = TRUE				//Enabled by default since you have to enable drop pred/prey to do this anyway
	var/drop_vore = TRUE				//Enabled by default since you have to enable drop pred/prey to do this anyway
	var/throw_vore = TRUE				//Enabled by default since you have to enable drop pred/prey to do this anyway
	var/food_vore = TRUE				//Enabled by default since you have to enable drop pred/prey to do this anyway
	var/consume_liquid_belly = FALSE	//starting off because if someone is into that, they'll toggle it first time they get the error. Otherway around would be more pref breaky.
	var/digest_pain = TRUE
	var/can_be_drop_prey = FALSE
	var/can_be_drop_pred = FALSE
	var/allow_spontaneous_tf = FALSE	// Obviously.
	var/show_vore_fx = TRUE				// Show belly fullscreens
	var/selective_preference = DM_DEFAULT	// Preference for selective bellymode
	var/text_warnings = TRUE 			// Allows us to dismiss the text limit warning messages after viewing it once per round
	var/eating_privacy_global = FALSE 	// Makes eating attempt/success messages only reach for subtle range if true, overwritten by belly-specific var
	var/allow_mimicry = TRUE 	// Allows mimicking their character
	var/allow_mind_transfer = FALSE			//Allows ones mind to be taken over or swapped
	var/nutrition_message_visible = TRUE
	var/list/nutrition_messages = list( // Someday I would like for it to be possible to name the character or refer to specific pronouns... but that is out of scope for me. -Ace
							"You can hear their empty stomach snarling from across the room. They must be starving!",
							"You notice a faint growling occasionally rumble from their hungry gut.",
							"",
							"They seem quite content, if perhaps a little stuffed. Their stomach gurgles with a little more food than is necessary at the moment.",
							"They look very satisfied, subconsciously licking their lips as their digestive system churns along an excessively rich meal.",
							"Their face is pleasantly flushed, breathing a bit more heavily than usual as their belly works some mighty feast into soupy nutrients. There's enough sloshing around in there to leave them feeling bloated for hours.",
							"Their face looks a little woozy while their breathing is somewhat panting. If you listen closely, you can hear a series of lurid wet blorps as their body works down what would have been enough calories to feed a small party.",
							"Their expression looks dazed and maybe a little uncomfortable while their breathing consists of deep, long, queasy-sounding gasps. If you pay attention, you can make out the constant gushing from their insides as digestion struggles to cope with a whole buffet worth of mush.",
							"Their expression looks downright hedonistic while their breathing is slow and lethargic. You can plainly hear a series of thick, lurid glorps as their gut strains to process nearly its limit worth of densely packed chyme.",
							"Their drooling expression looks pale and clammy, their breathing is weak and heaving, and you vividly overhear the emulsion of calorie-dense foodstuff working slowly through their guts with awful, bubbling GROANS... Maybe they don't consciously realize it, but they are definitely at their limit. Eating more won't make a difference at this point; their body couldn't soak up any more nutrients even if they want it to."
							)
	var/weight_message_visible = TRUE
	var/list/weight_messages = list(
							"They are terribly lithe and frail!",
							"They have a very slender frame.",
							"They have a lightweight, athletic build.",
							"They have a healthy, average body.",
							"They have a thick, curvy physique.",
							"They have a plush, chubby figure.",
							"They have an especially plump body with a round potbelly and large hips.",
							"They have a very fat frame with a bulging potbelly, squishy rolls of pudge, very wide hips, and plump set of jiggling thighs.",
							"They are incredibly obese. Their massive potbelly sags over their waistline while their fat ass would probably require two chairs to sit down comfortably!",
							"They are so morbidly obese, you wonder how they can even stand, let alone waddle around the station. They can't get any fatter without being immobilized.")

	var/vore_capacity = 0				// Maximum capacity, -1 for unlimited
	var/vore_capacity_ex = list("stomach" = 0) //expanded list of capacities
	var/vore_fullness = 0				// How "full" the belly is (controls icons)
	var/list/vore_fullness_ex = list("stomach" = 0) // Expanded list of fullness
	var/belly_size_multiplier = 1
	var/vore_sprite_multiply = list("stomach" = FALSE, "taur belly" = FALSE)
	var/vore_sprite_color = list("stomach" = "#000", "taur belly" = "#000")

	var/list/vore_icon_bellies = list("stomach")
	var/updating_fullness = FALSE
	var/obj/belly/previewing_belly

	var/vore_icons = 0					// Bitfield for which fields we have vore icons for.
	var/vore_eyes = FALSE				// For mobs with fullness specific eye overlays.

	var/obj/soulgem/soulgem				// Soulcatcher. Needs to be up-ported sometime.

	var/receive_reagents = FALSE			//Pref for people to avoid others transfering reagents into them.
	var/give_reagents = FALSE				//Pref for people to avoid others taking reagents from them.
	var/apply_reagents = TRUE				//Pref for people to avoid having stomach reagents applied to them
	var/latejoin_vore = FALSE				//If enabled, latejoiners can spawn into this, assuming they have a client
	var/latejoin_prey = FALSE				//If enabled, latejoiners can spawn ontop of and instantly eat the victim
	var/noisy_full = FALSE					//Enables belching when a mob has overeaten
	var/phase_vore = TRUE					//Enabled by default since you have to enable drop pred/prey to do this anyway
	var/strip_pref = TRUE					//Enables the ability for worn items to be stripped
	var/no_latejoin_vore_warning = FALSE	//Auto accepts pred spwan notifications (roundbased / saveable)
	var/no_latejoin_prey_warning = FALSE	//Auto accepts prey spawn notifications (roundbased / saveable)
	var/no_latejoin_vore_warning_time = 15	//Time until accepting prey
	var/no_latejoin_prey_warning_time = 15	//Time until accepting pred
	var/no_latejoin_vore_warning_persists = FALSE	//Do we save it?
	var/no_latejoin_prey_warning_persists = FALSE	//Do we save it?
	var/belly_rub_target = null
	var/soulcatcher_pref_flags = 0			//Default disabled

	var/voice_freq = 42500	// Preference for character voice frequency
	var/list/voice_sounds_list = list()	// The sound list containing our voice sounds!
	var/enabled = TRUE //Pauses a mob if disabled (Prevents life ticks from happening)
	var/died_in_vr = FALSE //For virtual reality sleepers
	var/last_move_time = 0 //For movement smoothing
