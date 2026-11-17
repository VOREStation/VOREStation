//In general:
//Hot: Orange -> Red -> Oil
//Cold: Blue -> Pink -> Light Pink
//Energetic: Purple -> Green -> Emerald
//Metallic: Metal -> Gold -> Sapphire

//MISC:
// Yellow (Metal + Hot)
// Silver (Metal + Cold)
// Dark Blue (Energetic + Cold)
// Dark Purple (Energetic + Hot)
// Ruby (Energetic + Hot)
// Bluespace (Metal + Hot)
// Amber (Metal + Cold)
// Cerulean (Energetic + Cold)

/**
 * ### Removes certain mutations from the list depending on what type of monkey the slime is fed.
 * Args: types_to_remove
 *
 * Valid args: "cold", "fire", "energetic", "metallic"
 */
/mob/living/simple_mob/slime/xenobio/proc/remove_slime_types(types_to_remove)
	switch(types_to_remove)
		if("cold") //Cold removes hot
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/orange)
		if("fire") //Fire removes cold
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/blue)
		if("energetic") //Energetic removes metallic
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/metal)
		if("metallic") //Metallic removes energetic
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/purple)


//Full hot tree from orange to oil
/mob/living/simple_mob/slime/xenobio/orange/remove_slime_types(types_to_remove)
	switch(types_to_remove)
		if("cold")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/red)
		if("fire")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio)
		if("energetic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/dark_purple)
		if("metallic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/yellow)

/mob/living/simple_mob/slime/xenobio/red/remove_slime_types(types_to_remove)
	switch(types_to_remove)
		if("cold")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/oil)
		if("fire")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/orange)


/mob/living/simple_mob/slime/xenobio/oil/remove_slime_types(types_to_remove)
	switch(types_to_remove)
		if("fire")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/red)


//Full cold tree from blue to light pink
/mob/living/simple_mob/slime/xenobio/blue/remove_slime_types(types_to_remove)
	switch(types_to_remove)
		if("cold")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio)
		if("fire")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/pink)
		if("energetic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/silver)
		if("metallic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/dark_blue)

/mob/living/simple_mob/slime/xenobio/pink/remove_slime_types(types_to_remove)
	switch(types_to_remove)
		if("cold")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/blue)
		if("fire")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/light_pink)

/mob/living/simple_mob/slime/xenobio/light_pink/remove_slime_types(types_to_remove)
	switch(types_to_remove)
		if("cold")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/pink)

//Full energetic tree from purple to emerald
/mob/living/simple_mob/slime/xenobio/purple/remove_slime_types(types_to_remove)
	switch(types_to_remove)
		if("cold")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/dark_purple)
		if("fire")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/dark_blue)
		if("energetic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio)
		if("metallic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/green)

/mob/living/simple_mob/slime/xenobio/green/remove_slime_types(types_to_remove)
	switch(types_to_remove)
		if("energetic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/purple)
		if("metallic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/emerald)

/mob/living/simple_mob/slime/xenobio/emerald/remove_slime_types(types_to_remove)
	switch(types_to_remove)
		if("energetic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/green)

//Full metallic tree from metal to sapphire
/mob/living/simple_mob/slime/xenobio/metal/remove_slime_types(types_to_remove)
	switch(types_to_remove)
		if("cold")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/yellow)
		if("fire")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/silver)
		if("energetic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/gold)
		if("metallic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio)

/mob/living/simple_mob/slime/xenobio/gold/remove_slime_types(types_to_remove)
	switch(types_to_remove)
		if("energetic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/sapphire)
		if("metallic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/metal)

/mob/living/simple_mob/slime/xenobio/sapphire/remove_slime_types(types_to_remove)
	switch(types_to_remove)
		if("metallic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/gold)


// Dark Blue (Energetic + Cold)
// Dark Purple (Energetic + Hot)
// Ruby (Energetic + Hot)
// Cerulean (Energetic + Cold)

/mob/living/simple_mob/slime/xenobio/dark_blue/remove_slime_types(types_to_remove)
	switch(types_to_remove)
		if("cold")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/purple)
		if("fire")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/cerulean)
		if("energetic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/blue)
		if("metallic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/cerulean)

/mob/living/simple_mob/slime/xenobio/dark_purple/remove_slime_types(types_to_remove)
	switch(types_to_remove)
		if("cold")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/ruby)
		if("fire")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/purple)
		if("energetic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/orange)
		if("metallic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/ruby)

/mob/living/simple_mob/slime/xenobio/ruby/remove_slime_types(types_to_remove)
		if("fire")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/dark_purple)
		if("energetic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/dark_purple)

/mob/living/simple_mob/slime/xenobio/cerulean/remove_slime_types(types_to_remove)
		if("cold")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/dark_blue)
		if("metallic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/dark_blue)


// Yellow (Metal + Hot)
// Silver (Metal + Cold)
// Bluespace (Metal + Hot)
// Amber (Metal + Cold)

/mob/living/simple_mob/slime/xenobio/yellow/remove_slime_types(types_to_remove)
	switch(types_to_remove)
		if("cold")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/bluespace)
		if("fire")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/metal)
		if("energetic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/bluespace)
		if("metallic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/orange)

/mob/living/simple_mob/slime/xenobio/silver/remove_slime_types(types_to_remove)
		if("cold")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/metal)
		if("fire")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/amber)
		if("energetic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/amber)
		if("metallic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/blue)


/mob/living/simple_mob/slime/xenobio/bluespace/remove_slime_types(types_to_remove)
		if("cold")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/metal)
		if("fire")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/cerulean)
		if("energetic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/blue)
		if("metallic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/cerulean)
			/mob/living/simple_mob/slime/xenobio/bluespace,
			/mob/living/simple_mob/slime/xenobio/bluespace,
			/mob/living/simple_mob/slime/xenobio/yellow,
			/mob/living/simple_mob/slime/xenobio/yellow

/mob/living/simple_mob/slime/xenobio/amber/remove_slime_types(types_to_remove)
		if("cold")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/silver)
		if("metallic")
			slime_mutation.Remove(/mob/living/simple_mob/slime/xenobio/amber)

		/mob/living/simple_mob/slime/xenobio/silver,
		/mob/living/simple_mob/slime/xenobio/silver,
		/mob/living/simple_mob/slime/xenobio/amber,
		/mob/living/simple_mob/slime/xenobio/amber
