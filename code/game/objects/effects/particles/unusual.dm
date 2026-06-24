/particles/unusual_effect
	icon = 'icons/effects/particles/pollen.dmi'
	icon_state = "pollen"
	width = 100
	height = 100
	count = 1000
	spawning = 4
	lifespan = 0.7 SECONDS
	fade = 1 SECONDS
	grow = -0.01
	velocity = list(0, 0)
	position = generator(GEN_CIRCLE, 0, 15, NORMAL_RAND)
	drift = generator(GEN_VECTOR, list(0, -0.2), list(0, 0.2))
	gravity = list(0, 0.95)
	scale = generator(GEN_VECTOR, list(0.3, 0.3), list(1, 1), NORMAL_RAND)
	rotation = 30
	spin = generator(GEN_NUM, -20, 20)

/particles/unusual_effect/cloud
	icon = 'icons/effects/particles/smoke.dmi'
	icon_state = list("steam_cloud_1" = 1, "steam_cloud_2" = 1, "steam_cloud_3" = 1, "steam_cloud_4" = 1, "steam_cloud_5" = 1)
	color = "#FFFFFF8A"
	count = 5
	spawning = 0.3
	fade = 1.2 SECONDS
	fadein = 0.4 SECONDS
	position = generator(GEN_BOX, list(-17,-15,0), list(24,15,0), NORMAL_RAND)
	scale = generator(GEN_VECTOR, list(0.9,0.9), list(1.1,1.1), NORMAL_RAND)
	drift = generator(GEN_SPHERE, list(-0.01,0), list(0.01,0.01), UNIFORM_RAND)
	spin = generator(GEN_NUM, -2, 2, NORMAL_RAND)
	gravity = list(0.05, 0.28)
	friction = 0.3
	grow = 0.037

/particles/unusual_effect/fire
	count = 10
	spawning = 5
	width = 64
	height = 96
	gradient = list("#FBAF4D", "#FCE6B6", "#FFFFFF")
	lifespan = 1.5 SECONDS
	fade = 1 SECONDS
	fadein = 0.1 SECONDS
	grow = -0.1
	velocity = generator(GEN_CIRCLE, 3, 3, SQUARE_RAND)
	position = generator(GEN_SPHERE, 0, 0, LINEAR_RAND)
	scale = generator(GEN_VECTOR, list(0.5, 0.5), list(1,1), NORMAL_RAND)
	drift = list(0)
