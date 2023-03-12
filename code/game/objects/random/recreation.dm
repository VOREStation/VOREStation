/obj/random/action_figure
	name = "random action figure"
	desc = "This is a random action figure."
	icon = 'icons/obj/toy.dmi'
	icon_state = "assistant"

/obj/random/action_figure/item_to_spawn()
	return pick(/obj/item/toy/figure/cmo,
				/obj/item/toy/figure/assistant,
				/obj/item/toy/figure/atmos,
				/obj/item/toy/figure/bartender,
				/obj/item/toy/figure/borg,
				/obj/item/toy/figure/gardener,
				/obj/item/toy/figure/captain,
				/obj/item/toy/figure/cargotech,
				/obj/item/toy/figure/ce,
				/obj/item/toy/figure/chaplain,
				/obj/item/toy/figure/chef,
				/obj/item/toy/figure/chemist,
				/obj/item/toy/figure/clown,
				/obj/item/toy/figure/corgi,
				/obj/item/toy/figure/detective,
				/obj/item/toy/figure/dsquad,
				/obj/item/toy/figure/engineer,
				/obj/item/toy/figure/geneticist,
				/obj/item/toy/figure/hop,
				/obj/item/toy/figure/hos,
				/obj/item/toy/figure/qm,
				/obj/item/toy/figure/janitor,
				/obj/item/toy/figure/agent,
				/obj/item/toy/figure/librarian,
				/obj/item/toy/figure/md,
				/obj/item/toy/figure/mime,
				/obj/item/toy/figure/miner,
				/obj/item/toy/figure/ninja,
				/obj/item/toy/figure/wizard,
				/obj/item/toy/figure/rd,
				/obj/item/toy/figure/roboticist,
				/obj/item/toy/figure/scientist,
				/obj/item/toy/figure/syndie,
				/obj/item/toy/figure/secofficer,
				/obj/item/toy/figure/warden,
				/obj/item/toy/figure/psychologist,
				/obj/item/toy/figure/paramedic,
				/obj/item/toy/figure/ert,
				/obj/item/toy/figure/un,
				/obj/item/toy/figure/selene,
				/obj/item/toy/figure/nock,
				/obj/item/toy/figure/carrion,
				/obj/item/toy/figure/zaddat,
				/obj/item/toy/figure/discovery,
				/obj/item/toy/figure/rooster,
				/obj/item/toy/figure/barking_dog,
				/obj/item/toy/figure/tajaran,
				/obj/item/toy/figure/red_soldier,
				/obj/item/toy/figure/shitcurity,
				/obj/item/toy/figure/vir_patrolman)

/obj/random/plushie
	name = "random plushie"
	desc = "This is a random plushie."
	icon = 'icons/obj/toy.dmi'
	icon_state = "nymphplushie"

/obj/random/plushie/item_to_spawn()
	return pick(/obj/item/toy/plushie/nymph,
				/obj/item/toy/plushie/mouse,
				/obj/item/toy/plushie/kitten,
				/obj/item/toy/plushie/lizard,
				/obj/item/toy/plushie/black_cat,
				/obj/item/toy/plushie/black_fox,
				/obj/item/toy/plushie/blue_fox,
				/obj/random/carp_plushie,
				/obj/item/toy/plushie/coffee_fox,
				/obj/item/toy/plushie/corgi,
				/obj/item/toy/plushie/crimson_fox,
				/obj/item/toy/plushie/deer,
				/obj/item/toy/plushie/girly_corgi,
				/obj/item/toy/plushie/grey_cat,
				/obj/item/toy/plushie/marble_fox,
				/obj/item/toy/plushie/octopus,
				/obj/item/toy/plushie/orange_cat,
				/obj/item/toy/plushie/orange_fox,
				/obj/item/toy/plushie/pink_fox,
				/obj/item/toy/plushie/purple_fox,
				/obj/item/toy/plushie/red_fox,
				/obj/item/toy/plushie/robo_corgi,
				/obj/item/toy/plushie/siamese_cat,
				/obj/item/toy/plushie/spider,
				/obj/item/toy/plushie/tabby_cat,
				/obj/item/toy/plushie/tuxedo_cat,
				/obj/item/toy/plushie/white_cat)

/obj/random/plushielarge
	name = "random large plushie"
	desc = "This is a randomn large plushie."
	icon = 'icons/obj/toy.dmi'
	icon_state = "droneplushie"

/obj/random/plushielarge/item_to_spawn()
	return pick(/obj/structure/plushie/ian,
				/obj/structure/plushie/drone,
				/obj/structure/plushie/carp,
				/obj/structure/plushie/beepsky)

/obj/random/toy
	name = "random toy"
	desc = "This is a random toy."
	icon = 'icons/obj/toy.dmi'
	icon_state = "ship"

/obj/random/toy/item_to_spawn()
	return pick(/obj/item/toy/bosunwhistle,
				/obj/item/toy/plushie/therapy/red,
				/obj/item/toy/plushie/therapy/purple,
				/obj/item/toy/plushie/therapy/blue,
				/obj/item/toy/plushie/therapy/yellow,
				/obj/item/toy/plushie/therapy/orange,
				/obj/item/toy/plushie/therapy/green,
				/obj/item/toy/cultsword,
				/obj/item/toy/katana,
				/obj/item/toy/snappop,
				/obj/item/toy/sword,
				/obj/random/balloon,
				/obj/item/gun/projectile/revolver/toy/crossbow,
				/obj/item/toy/blink,
				/obj/item/reagent_containers/spray/waterflower,
				/obj/item/toy/eight_ball,
				/obj/item/toy/eight_ball/conch,
				/obj/item/toy/mecha/ripley,
				/obj/item/toy/mecha/fireripley,
				/obj/item/toy/mecha/deathripley,
				/obj/item/toy/mecha/gygax,
				/obj/item/toy/mecha/durand,
				/obj/item/toy/mecha/honk,
				/obj/item/toy/mecha/marauder,
				/obj/item/toy/mecha/seraph,
				/obj/item/toy/mecha/mauler,
				/obj/item/toy/mecha/odysseus,
				/obj/item/toy/mecha/phazon)

/obj/random/balloon
	name = "random balloon"
	desc = "This is a random balloon."
	icon = 'icons/obj/toy.dmi'
	icon_state = "colorballoon"

/obj/random/balloon/item_to_spawn()
	return pick(prob(7);/obj/item/toy/balloon/random,
			prob(2);/obj/item/toy/balloon/latex,
			prob(2);/obj/item/toy/balloon/nitrile,
			prob(1);/obj/item/toy/balloon/syndicate,
			prob(1);/obj/item/toy/balloon/nanotrasen)

/obj/random/saintsandsins_packs
	name = "random Saints and Sins booster pack" // Builder pack not included.
	desc = "This is a random booster pack."
	icon = 'icons/obj/playing_cards.dmi'
	icon_state = "card_pack_saintsandsins"

/obj/random/saintsandsins_packs/item_to_spawn()
	return pick(prob(6);/obj/item/pack/saintsandsins/booster,
			prob(4);/obj/item/pack/saintsandsins/booster/alchemist,
			prob(2);/obj/item/pack/saintsandsins/booster/fatebringer)
