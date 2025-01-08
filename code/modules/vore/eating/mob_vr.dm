/mob
	var/digestable = TRUE				// Can the mob be digested inside a belly?
	var/devourable = TRUE				// Can the mob be devoured at all?
	var/feeding = TRUE					// Can the mob be vorishly force fed or fed to others?
	var/absorbable = TRUE				// Are you allowed to absorb this person?
	var/resizable = TRUE				// Can other people resize you? (Usually ignored for self-resizes)
	var/digest_leave_remains = FALSE	// Will this mob leave bones/skull/etc after the melty demise?
	var/allowmobvore = TRUE				// Will simplemobs attempt to eat the mob?
	var/allow_inbelly_spawning = FALSE	// Will we even bother with attempts of someone to spawn in in one of our bellies?
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
	var/list/nutrition_messages = list(
							"They are starving! You can hear their stomach snarling from across the room!",
							"They are extremely hungry. A deep growl occasionally rumbles from their empty stomach.",
							"",
							"They have a stuffed belly, bloated fat and round from eating too much.",
							"They have a rotund, thick gut. It bulges from their body obscenely, close to sagging under its own weight.",
							"They are sporting a large, round, sagging stomach. It contains at least their body weight worth of glorping slush.",
							"They are engorged with a huge stomach that sags and wobbles as they move. They must have consumed at least twice their body weight. It looks incredibly soft.",
							"Their stomach is firmly packed with digesting slop. They must have eaten at least a few times worth their body weight! It looks hard for them to stand, and their gut jiggles when they move.",
							"They are so absolutely stuffed that you aren't sure how it's possible for them to move. They can't seem to swell any bigger. The surface of their belly looks sorely strained!",
							"They are utterly filled to the point where it's hard to even imagine them moving, much less comprehend it when they do. Their gut is swollen to monumental sizes and amount of food they consumed must be insane.")
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
