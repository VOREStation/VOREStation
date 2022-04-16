//Spawner subtypes where the result begins with anomalous properties, primarily for PoI use.

/obj/random/maintenance/anom
	name = "random anomalous clutter"
	desc = "This is a random maintenance-style item with anomalous properties."
	icon_state = "anomaly"

/obj/random/maintenance/anom/item_to_spawn()
	return pick(prob(300);/obj/random/tech_supply/anom,
				prob(200);/obj/random/medical/anom,
				prob(100);/obj/random/firstaid/anom,
				prob(10);/obj/random/contraband/anom,
				prob(50);/obj/random/action_figure/anom,
				prob(50);/obj/random/plushie/anom,
				prob(200);/obj/random/junk/anom,
				prob(200);/obj/random/material/anom,
				prob(50);/obj/random/toy/anom,
				prob(100);/obj/random/tank/anom,
				prob(50);/obj/random/soap/anom,
				prob(60);/obj/random/drinkbottle/anom,
				prob(500);/obj/random/maintenance/clean/anom)

//Guns

/obj/random/gun/random/anomalous
	name = "random anomalous weapon"
	desc = "This is a random energy or ballistic weapon with anomalous properties."
	start_anomalous = TRUE

/obj/random/gun/random/anomalous/item_to_spawn()
	return pick(prob(5);/obj/random/energy/anom,
				prob(5);/obj/random/projectile/random/anom)

/obj/random/energy/anom
	start_anomalous = TRUE

/obj/random/projectile/random/anom
	start_anomalous = TRUE

//Misc objects

/obj/random/tech_supply/anom
	start_anomalous = TRUE

/obj/random/medical/anom
	start_anomalous = TRUE

/obj/random/firstaid/anom
	start_anomalous = TRUE

/obj/random/contraband/anom
	start_anomalous = TRUE

/obj/random/action_figure/anom
	start_anomalous = TRUE

/obj/random/plushie/anom
	start_anomalous = TRUE

/obj/random/junk/anom
	start_anomalous = TRUE

/obj/random/material/anom
	start_anomalous = TRUE

/obj/random/material/anom
	start_anomalous = TRUE

/obj/random/toy/anom
	start_anomalous = TRUE

/obj/random/tank/anom
	start_anomalous = TRUE

/obj/random/soap/anom
	start_anomalous = TRUE

/obj/random/drinkbottle/anom
	start_anomalous = TRUE

/obj/random/maintenance/clean/anom
	start_anomalous = TRUE

/obj/random/technology_scanner/anom
	start_anomalous = TRUE

/obj/random/powercell/anom
	start_anomalous = TRUE

/obj/random/tool/anom
	start_anomalous = TRUE

/obj/random/tool/power/anom
	start_anomalous = TRUE

/obj/random/toolbox/anom
	start_anomalous = TRUE

/obj/random/tech_supply/component
	start_anomalous = TRUE

/obj/random/medical/lite/anom
	start_anomalous = TRUE

/obj/random/tank/anom
	start_anomalous = TRUE

/obj/random/coin/anom
	start_anomalous = TRUE

/obj/random/mug/anom
	start_anomalous = TRUE