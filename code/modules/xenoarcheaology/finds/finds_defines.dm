/// This is the big file of various xenoarch spawns (what each digsite spawns), digsite spawn rates, and

/// <summary>
/// This is a list of what the depth_scanner can show, depending on what get_responsive_reagent returns below.
/// </summary>
var/global/list/responsive_carriers = list(
	REAGENT_ID_CARBON,
	REAGENT_ID_POTASSIUM,
	REAGENT_ID_HYDROGEN,
	REAGENT_ID_NITROGEN,
	REAGENT_BLOOD,
	REAGENT_ID_MERCURY,
	REAGENT_ID_IRON,
	REAGENT_ID_PHORON)

/// <summary>
/// This is a list of what the depth_scanner shows the user. In order with the above list.
/// </summary>
/// <example>
/// If the get_responsive_reagent returns 'REAGENT_ID_CARBON' it will show up to the user as "Trace organic cells"
/// If the get_responsive_reagent returns "REAGENT_ID_CHLORINE" it will show up to the user as "Metamorphic/igneous rock composite"
/// </example>
var/global/list/finds_as_strings = list(
	"Trace organic cells", 							//Carbon
	"Long exposure particles", 						//Potassium
	"Trace water particles", 						//Hydrogen
	"Crystalline structures", 						//Nitrogen
	"Abnormal energy signatures",					//Occult
	"Metallic derivative", 							//Mercury
	"Metallic composite", 							//Iron
	"Anomalous material") 							//Phoron

/// <summary>
/// This is called when using the depth_scanner on an artifact tile. It tells you what artifact group type is contained inside.
/// Previously, we only used MERCURY, IRON, NITROGEN, POTASSIUM, CARBON, PHORON. Now, we expanded!
/// </summary>
/proc/get_responsive_reagent(var/find_type)
	switch(find_type)
		if(ARCHAEO_STATUETTE, ARCHAEO_INSTRUMENT, ARCHAEO_HANDCUFFS, ARCHAEO_BEARTRAP, ARCHAEO_LIGHTER, ARCHAEO_BOX, ARCHAEO_PEN, ARCHAEO_COIN, ARCHAEO_STOCKPARTS)
			return REAGENT_ID_MERCURY
		if(ARCHAEO_KNIFE, ARCHAEO_TOOL, ARCHAEO_METAL, ARCHAEO_CLAYMORE, ARCHAEO_KATANA, ARCHAEO_LASER, ARCHAEO_GUN, ARCHAEO_REMAINS_ROBOT)
			return REAGENT_ID_IRON
		if(ARCHAEO_CRYSTAL)
			return REAGENT_ID_NITROGEN
		if(ARCHAEO_CULTBLADE, ARCHAEO_SOULSTONE, ARCHAEO_TOME)
			return REAGENT_BLOOD
		if(ARCHAEO_CULTBLADE, ARCHAEO_TELEBEACON, ARCHAEO_CULTROBES)
			return REAGENT_ID_POTASSIUM
		if(ARCHAEO_BOWL, ARCHAEO_URN, ARCHAEO_GASTANK, ARCHAEO_GASMASK) //Moisture or humidity in some way.
			return REAGENT_ID_HYDROGEN
		if(ARCHAEO_FOSSIL, ARCHAEO_SHELL, ARCHAEO_PLANT, ARCHAEO_REMAINS_HUMANOID, ARCHAEO_REMAINS_XENO)
			return REAGENT_ID_CARBON
	return REAGENT_ID_PHORON

/proc/get_random_digsite_type()
	return pick(100;DIGSITE_GARDEN, 90;DIGSITE_HOUSE, 85;DIGSITE_TECHNICAL,  85;DIGSITE_MIDDEN, 80;DIGSITE_TEMPLE, 75;DIGSITE_WAR)

/proc/get_random_find_type(var/digsite)
	. = 0
	switch(digsite)
		if(DIGSITE_GARDEN)
			. = pick(
			100;ARCHAEO_PLANT,
			25;ARCHAEO_SHELL,
			25;ARCHAEO_FOSSIL,
			25;ARCHAEO_REMAINS_HUMANOID,
			25;ARCHAEO_REMAINS_XENO,
			5;ARCHAEO_BEARTRAP,)
		if(DIGSITE_HOUSE)
			. = pick(
			100;ARCHAEO_BOWL,
			100;ARCHAEO_URN,
			100;ARCHAEO_STATUETTE,
			100;ARCHAEO_INSTRUMENT,
			100;ARCHAEO_PEN,
			100;ARCHAEO_LIGHTER,
			100;ARCHAEO_BOX,
			100;ARCHAEO_RING,
			75;ARCHAEO_GASMASK,
			75;ARCHAEO_COIN,
			75;ARCHAEO_UNKNOWN,
			25;ARCHAEO_METAL,
			5;ARCHAEO_ALIEN_BOAT)
		if(DIGSITE_TECHNICAL)
			. = pick(
			125;ARCHAEO_GASMASK,
			100;ARCHAEO_METAL,
			100;ARCHAEO_GASTANK,
			100;ARCHAEO_TELEBEACON,
			100;ARCHAEO_TOOL,
			100;ARCHAEO_STOCKPARTS,
			100;ARCHAEO_ALIEN_ITEM,
			75;ARCHAEO_UNKNOWN,
			50;ARCHAEO_HANDCUFFS,
			50;ARCHAEO_BEARTRAP,
			50;ARCHAEO_IMPERION_CIRCUIT,  //They're not even that USEFUL. Why was it a 1 in 1000 chance?
			25;ARCHAEO_REMAINS_ROBOT,
			10;ARCHAEO_TELECUBE)
		if(DIGSITE_TEMPLE)
			. = pick(
			200;ARCHAEO_CULTROBES,
			200;ARCHAEO_STATUETTE,
			75;ARCHAEO_SOULSTONE,
			75;ARCHAEO_TOME,
			50;ARCHAEO_URN,
			50;ARCHAEO_BOWL,
			50;ARCHAEO_KNIFE,
			50;ARCHAEO_CRYSTAL,
			50;ARCHAEO_RING,
			50;ARCHAEO_UNKNOWN,
			25;ARCHAEO_CULTBLADE,
			25;ARCHAEO_HANDCUFFS,
			25;ARCHAEO_REMAINS_HUMANOID,
			10;ARCHAEO_KATANA,
			10;ARCHAEO_METAL)
		if(DIGSITE_WAR)
			. = pick(
			75;ARCHAEO_KNIFE,
			75;ARCHAEO_KATANA,
			75;ARCHAEO_CLAYMORE,
			75;ARCHAEO_CLUB,
			50;ARCHAEO_UNKNOWN,
			50;ARCHAEO_CULTROBES,
			50;ARCHAEO_CULTBLADE,
			50;ARCHAEO_GASMASK,
			50;ARCHAEO_ALIEN_ITEM,
			50;ARCHAEO_REMAINS_HUMANOID,
			50;ARCHAEO_REMAINS_ROBOT,
			50;ARCHAEO_REMAINS_XENO,
			25;ARCHAEO_HANDCUFFS,
			25;ARCHAEO_BEARTRAP,
			25;ARCHAEO_GUN,
			25;ARCHAEO_LASER,
			25;ARCHAEO_TOOL)
		if(DIGSITE_MIDDEN)
			. = rand(1, MAX_ARCHAEO)
