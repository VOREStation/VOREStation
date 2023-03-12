// For the cardpack decls
#define CARDPACK_BUILDER "builder"
#define CARDPACK_BASICWITCH "basicwitch"
#define CARDPACK_ALCHEMIST "wickedalchemist"
#define CARDPACK_FATEBRINGER "fatebringer"

#define KEY_TYPE "KEY"
#define REACTION_TYPE "REACTION"

/**
 *  ////////////////////////////////////////////
 *  ///              Rules                  ///
 *  ///////////////////////////////////////////
 *
 *  Players start with 5 spell cards, Heretic card starts in play. Game is over when Heretic card dies.
 *  Decks have 30 cards + a Heretic card, with up to 3 duplicate spells. If all cards have been drawn,
 *  reshuffle discarded spells.
 *
 *  Active Heretic actions can only be activated once per round, which are marked by the start of the caster's turn.
 *  Passive Heretic effects are always active when their conditions are met. Heretics cannot exceed max health.
 *
 *  Key spells may only be used on your turn. Reaction spells may be used in reaction to another player's spell,
 *  even if it is not targeting you. You may cast up to 2 spells on your turn, and draw 1 card after ending
 *  your turn. You may only use one reaction spell per round.
 *
 *  Damage types:
 *  Fire | Water | Earth | Wind | Decay | Holy
 *
 *  Suitable for 2-4 players.
 *
 *  The above and any changes to it should be listed in game on the deck box description_info.
 */

/obj/item/deck/saintsandsins
	name = "\improper Saints and Sins deck box"
	desc = "A deck box for the hit collectable card game, Saints and Sins. The instructions appear to be listed on the side."
	icon_state = "deck_box_saintsandsins"
	description_info = "Players start with 5 spell cards, Heretic card starts in play. Game is over when Heretic card dies. Decks have 30 cards + a Heretic card, with up to 3 duplicate spells. If all cards have been drawn, reshuffle discarded spells. <BR><BR>\
	Active Heretic actions can only be activated once per round, which are marked by the start of the caster's turn. Passive Heretic effects are always active when their conditions are met. Heretics cannot exceed max health. <BR><BR>\
	Key spells may only be used on your turn. Reaction spells may be used in reaction to another player's spell, even if it is not targeting you. You may cast up to 2 spells on your turn, and draw 1 card after ending your turn. You may only use one reaction spell per round. <BR><BR>\
	Damage types: <BR><BR>\
	Fire | Water | Earth | Wind | Decay | Holy <BR><BR>\
	Suitable for 2-4 players."
	decktype = /datum/playingcard/saintsandsins
	decklimit = 31

/obj/item/pack/saintsandsins
	name = "\improper Saints and Sins builder pack"
	desc = "A builder pack for hit collectable card game, Saints and Sins. This one will \
    help any aspiring deck builder get started."
	icon_state = "card_pack_saintsandsins"
	decktype = /datum/playingcard/saintsandsins
	var/pack_type = CARDPACK_BUILDER
	var/how_many_cards = 21 /// Boosters give less cards than the builder packs.


/obj/item/pack/saintsandsins/Initialize()
	. = ..()
	var/list/heretic_weights = build_card_weights_list(pack_type, /decl/sas_card/heretic)
	var/list/spell_weights = build_card_weights_list(pack_type, /decl/sas_card/spell)
	for(var/i in 1 to how_many_cards)
		var/datum/playingcard/saintsandsins/P = new
		var/decl/sas_card/picked_card
		if(i == 1) // Just pick one Heretic.
			picked_card = pickweight(heretic_weights)
			P.card_icon = "saintsandsins_heretic"
		else
			picked_card = pickweight(spell_weights)
			P.card_icon = "saintsandsins_spell"
		P.name = picked_card.name
		P.desc = picked_card.desc
		P.back_icon = "card_back_saintsandsins"
		cards += P

/obj/item/pack/saintsandsins/proc/build_card_weights_list(pack_type, root_type)
	. = list()
	var/list/card_types = decls_repository.get_decls_of_subtype(root_type)
	for(var/card_type in card_types)
		var/decl/sas_card/C = card_types[card_type]
		if(pack_type in C.pack_probability)
			.[C] = C.pack_probability[pack_type] || 1

/datum/playingcard/saintsandsins

/**
 * Booster packs
 * Can have special cards not found in builder pack.
 * Add new boosters to /obj/random/saintsandsins_packs please.
 */

/obj/item/pack/saintsandsins/booster
	name = "\improper Saints and Sins booster pack"
	var/booster_type = "Basic Witch Kit"
	pack_type = CARDPACK_BASICWITCH
	how_many_cards = 11

/obj/item/pack/saintsandsins/booster/Initialize()
	. = ..()
	desc = "A booster pack for hit collectable card game, Saints and Sins. This one is labeled '[booster_type]'."

/obj/item/pack/saintsandsins/booster/alchemist
	booster_type = "Wicked Alchemist Kit"
	pack_type = CARDPACK_ALCHEMIST

/obj/item/pack/saintsandsins/booster/fatebringer
	booster_type = "Fatebringer Kit"
	pack_type = CARDPACK_FATEBRINGER

/*
// Builder pack cards can appear in other packs to fluff them up. Pack-specific are less likely to do so, if ever.
*/
/decl/sas_card
	var/name
	var/desc
	var/ability
	var/pack_probability

/*
// Heretics, only one per pack opened.
*/
/decl/sas_card/heretic
	var/health

/decl/sas_card/heretic/New()
	..()
	desc = "Health: [health]. [ability]"

/decl/sas_card/heretic/lady_of_holy_death
	name = "Lady of Holy Death"
	health = 18
	ability = "Restore 1 health every time you deal Decay damage, up to max health."
	pack_probability = list(
		CARDPACK_BUILDER = 10,
		CARDPACK_BASICWITCH = 10,
		CARDPACK_ALCHEMIST = 10,
		CARDPACK_FATEBRINGER = 10
	)

/decl/sas_card/heretic/galeria_the_haruspex
	name = "Galeria the Haruspex"
	health = 17
	ability = "ACTIVE: Block up to 2 damage of any kind for one round."
	pack_probability = list(
		CARDPACK_BUILDER = 10,
		CARDPACK_BASICWITCH = 10,
		CARDPACK_ALCHEMIST = 10,
		CARDPACK_FATEBRINGER = 10
	)

/decl/sas_card/heretic/dutiful_mephistopheles
	name = "Dutiful Mephistopheles"
	health = 19
	ability = "PASSIVE: Reduces Decay damage taken by 2 while increasing Holy damage taken by 3."
	pack_probability = list(
		CARDPACK_BASICWITCH = 6
	)

/decl/sas_card/heretic/woebringer_colette
	name = "Woebringer Colette"
	health = 21
	ability = "ACTIVE: Deal 2 damage of any damage type. Take 2 damage of the same type."
	pack_probability = list(
		CARDPACK_BASICWITCH = 8
	)

/decl/sas_card/heretic/orpheus_the_blind
	name = "Orpheus the Blind"
	health = 18
	ability = "PASSIVE: When below half health, take half damage from spells, rounded up."
	pack_probability = list(
		CARDPACK_BASICWITCH = 4
	)

/decl/sas_card/heretic/plaguebringer
	name = "Plaguebringer"
	health = 20
	ability = "PASSIVE: Immune to damage-over-time spells. When above half health, take 1 Decay damage per round."
	pack_probability = list(
		CARDPACK_ALCHEMIST = 7
	)

/decl/sas_card/heretic/exalted_atomus
	name = "Exalted Atomus"
	health = 17
	ability = "ACTIVE: Declare a damage type at the start of your turn. Nullify that damage type until the start of your next turn."
	pack_probability = list(
		CARDPACK_ALCHEMIST = 4,
		CARDPACK_FATEBRINGER = 4
	)

/decl/sas_card/heretic/katheryn_the_ill_omened
	name = "Katheryn the Ill-omened"
	health = 21
	ability = "ACTIVE: Flip a coin. Heads, draw a card. Tails, take 1 Holy damage."
	pack_probability = list(
		CARDPACK_FATEBRINGER = 6
	)

/decl/sas_card/heretic/slovenly_pritchard
	name = "Slovenly Pritchard"
	health = 18
	ability = "PASSIVE: Nullify the first instance of Holy damage received each round."
	pack_probability = list(
		CARDPACK_FATEBRINGER = 5
	)

/*
// Spells.
*/
/decl/sas_card/spell
	var/spell_type

/decl/sas_card/spell/New()
	..()
	desc = "[ability] [spell_type]."

/decl/sas_card/spell/summon_psychopomp
	name = "Summon Psychopomp"
	ability = "Deals 3 Decay damage to target for 3 rounds."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 5,
		CARDPACK_BASICWITCH = 8
	)

/decl/sas_card/spell/meteor_shower
	name = "Meteor Shower"
	ability = "Deals 5 Fire damage to ALL Heretics."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 5
	)

/decl/sas_card/spell/chastise
	name = "Chastise"
	ability = "Deals 2 Holy damage to target."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 10,
		CARDPACK_BASICWITCH = 10,
		CARDPACK_FATEBRINGER = 10
	)

/decl/sas_card/spell/rebuke
	name = "Rebuke"
	ability = "Nullifies one spell."
	spell_type = REACTION_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 3,
		CARDPACK_BASICWITCH = 6,
		CARDPACK_FATEBRINGER = 6
	)

/decl/sas_card/spell/blessed_invocation
	name = "Blessed Invocation"
	ability = "Restores 5 health to caster."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 3,
		CARDPACK_BASICWITCH = 4,
		CARDPACK_FATEBRINGER = 5
	)

/decl/sas_card/spell/vampyric_bite
	name = "Vampyric Bite"
	ability = "Deals 2 Decay damage to target and restores 2 health to caster."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 7,
		CARDPACK_BASICWITCH = 8
	)

/decl/sas_card/spell/wicked_fountain
	name = "Wicked Fountain"
	ability = "Deals 3 Water damage to target."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 8,
		CARDPACK_BASICWITCH = 10,
		CARDPACK_ALCHEMIST = 10,
		CARDPACK_FATEBRINGER = 10
	)

/decl/sas_card/spell/sick_air
	name = "Sick Air"
	ability = "Deals 1 Wind damage to target for 5 rounds."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 8,
		CARDPACK_ALCHEMIST = 10,
		CARDPACK_FATEBRINGER = 7
	)

/decl/sas_card/spell/flux_of_humors
	name = "Flux of Humors"
	ability = "Restores 2 health to caster for 3 rounds."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 8,
		CARDPACK_BASICWITCH = 10,
		CARDPACK_ALCHEMIST = 10,
		CARDPACK_FATEBRINGER = 10
	)

/decl/sas_card/spell/earthquake
	name = "Earthquake"
	ability = "Deals 3 Earth damage to ALL Heretics for 3 rounds."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 3,
		CARDPACK_BASICWITCH = 5
	)

/decl/sas_card/spell/shifting_soil
	name = "Shifting Soil"
	ability = "Redirect spell to another Heretic."
	spell_type = REACTION_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 8,
		CARDPACK_BASICWITCH = 10,
		CARDPACK_ALCHEMIST = 10,
		CARDPACK_FATEBRINGER = 10
	)

/decl/sas_card/spell/wind_tunnel
	name = "Wind Tunnel"
	ability = "Redirects spell to its caster."
	spell_type = REACTION_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 8,
		CARDPACK_BASICWITCH = 10,
		CARDPACK_FATEBRINGER = 6
	)

/decl/sas_card/spell/awakening
	name = "Awakening"
	ability = "Deals 2 Holy damage to ALL Heretics."
	spell_type = REACTION_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 8,
		CARDPACK_ALCHEMIST = 8,
		CARDPACK_FATEBRINGER = 6
	)

/decl/sas_card/spell/penance
	name = "Penance"
	ability = "Deals 3 Holy damage to target."
	spell_type = REACTION_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 5,
		CARDPACK_BASICWITCH = 7,
		CARDPACK_ALCHEMIST = 7,
		CARDPACK_FATEBRINGER = 7
	)

/decl/sas_card/spell/soothing_breeze
	name = "Soothing Breeze"
	ability = "Blocks up to 4 damage of any kind for one round."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BUILDER = 3,
		CARDPACK_BASICWITCH = 6,
		CARDPACK_ALCHEMIST = 6,
		CARDPACK_FATEBRINGER = 6
	)

///Basic Witch Kit

/decl/sas_card/spell/protection_ward
	name = "Protection Ward"
	ability = "Nullifies damage from the next spell targeting the caster."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 8
	)

/decl/sas_card/spell/blood_drain
	name = "Blood Drain"
	ability = "Deals 1 Water damage to target for 6 rounds."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 8
	)

/decl/sas_card/spell/dance_of_death
	name = "Dance of Death"
	ability = "Discard 2 cards and draw 2 more."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 9
	)

/decl/sas_card/spell/hex
	name = "Hex"
	ability = "Target must discard their whole hand and draw a new one."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 6
	)

/decl/sas_card/spell/crippling_despair
	name = "Crippling Despair"
	ability = "Target may only cast one Key spell on their next turn."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 8
	)

/decl/sas_card/spell/spark_of_pain
	name = "Spark of Pain"
	ability = "Deals 1 Fire damage to target."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 10
	)

/decl/sas_card/spell/devils_tears
	name = "Devil's Tears"
	ability = "Deals 1 Water damage to target."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 10
	)

/decl/sas_card/spell/fist_of_stone
	name = "Fist of Stone"
	ability = "Deals 1 Earth damage to target."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 10
	)

/decl/sas_card/spell/cutting_blow
	name = "Cutting Blow"
	ability = "Deals 1 Wind damage to target."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 10
	)

/decl/sas_card/spell/touch_of_death
	name = "Touch of Death"
	ability = "Deals 1 Decay damage to target."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 10
	)

/decl/sas_card/spell/righteous_accusation
	name = "Righteous Accusation"
	ability = "Deals 1 Holy damage to target."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 10
	)

/decl/sas_card/spell/cold_stare
	name = "Cold Stare"
	ability = "Nullifies any Fire damage from a spell."
	spell_type = REACTION_TYPE
	pack_probability = list(
		CARDPACK_BASICWITCH = 8
	)

///Wicked Alchemist Kit
/decl/sas_card/spell/scorn_of_the_alchemist
	name = "Scorn of the Alchemist"
	ability = "Caster converts the damage type of another spell to one of their choosing."
	spell_type = REACTION_TYPE
	pack_probability = list(
		CARDPACK_ALCHEMIST = 7
	)

/decl/sas_card/spell/a_glass_darkly
	name = "A Glass Darkly"
	ability = "Doubles the damage of the caster's next Key spell."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_ALCHEMIST = 7
	)

/decl/sas_card/spell/panacea
	name = "Panacea"
	ability = "Restores 2 health to caster and one other Heretic."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_ALCHEMIST = 8
	)

/decl/sas_card/spell/scrawling_spellbook
	name = "Scrawling Spellbook"
	ability = "All Heretics draw one card."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_ALCHEMIST = 7
	)

/decl/sas_card/spell/grotesque_experiment
	name = "Grotesque Experiment"
	ability = "Nullify a spell. Its caster draws a card."
	spell_type = REACTION_TYPE
	pack_probability = list(
		CARDPACK_ALCHEMIST = 5
	)

/decl/sas_card/spell/skin_rot
	name = "Skin Rot"
	ability = "Deals 3 Decay damage to all Heretics."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_ALCHEMIST = 7
	)

/decl/sas_card/spell/rosemary_and_thyme
	name = "Rosemary and Thyme"
	ability = "Nullifies all damage-over-time spells currently on caster."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_ALCHEMIST = 6
	)

/decl/sas_card/spell/culling_of_the_firstborn
	name = "Culling of the Firstborn"
	ability = "Caster of the target spell splits the damage with its original target, rounding up."
	spell_type = REACTION_TYPE
	pack_probability = list(
		CARDPACK_ALCHEMIST = 7
	)

/decl/sas_card/spell/blood_boil
	name = "Blood Boil"
	ability = "Deals 1 Decay and 2 Fire damage to target."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_ALCHEMIST = 7
	)

/decl/sas_card/spell/transmogrification
	name = "Transmogrification"
	ability = "Caster chooses a damage type. Deals 2 damage of that type to target."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_ALCHEMIST = 6
	)

///Fatebringer Kit
/decl/sas_card/spell/star_crossed
	name = "Star-crossed"
	ability = "Deal 1 Holy damage to target for two rounds."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_FATEBRINGER = 8
	)

/decl/sas_card/spell/divine_fire
	name = "Divine Fire"
	ability = "Deal 1 Holy damage and 1 Fire damage to target."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_FATEBRINGER = 8
	)

/decl/sas_card/spell/cast_down
	name = "Cast Down"
	ability = "Nullifies target spell and returns it to its caster's hand."
	spell_type = REACTION_TYPE
	pack_probability = list(
		CARDPACK_FATEBRINGER = 6
	)

/decl/sas_card/spell/blood_tithe
	name = "Blood Tithe"
	ability = "Roll 1d4. Deal that much Water damage to ALL Heretics."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_FATEBRINGER = 6
	)

/decl/sas_card/spell/dire_portent
	name = "Dire Portent"
	ability = "Deal 4 Earth damage to target after 3 rounds."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_FATEBRINGER = 4
	)

/decl/sas_card/spell/hatred
	name = "Hatred"
	ability = "Split damage received with another Heretic, rounding up."
	spell_type = REACTION_TYPE
	pack_probability = list(
		CARDPACK_FATEBRINGER = 7
	)

/decl/sas_card/spell/karmic_balance
	name = "Karmic Balance"
	ability = "Deal 2 damage of last received damaged type to target."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_FATEBRINGER = 7
	)

/decl/sas_card/spell/unyielding_faith
	name = "Unyielding Faith"
	ability = "Convert spell's damage type to Holy."
	spell_type = REACTION_TYPE
	pack_probability = list(
		CARDPACK_FATEBRINGER = 7
	)

/decl/sas_card/spell/unnatural_bonds
	name = "Unnatural Bonds"
	ability = "Heal caster and one other Heretic by 3."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_FATEBRINGER = 6
	)

/decl/sas_card/spell/suffering_poppets
	name = "Suffering Poppets"
	ability = "Reflects spell to all other Heretics."
	spell_type = REACTION_TYPE
	pack_probability = list(
		CARDPACK_FATEBRINGER = 5
	)

/decl/sas_card/spell/ancient_pact
	name = "Ancient Pact"
	ability = "Until the start of your next turn, all damage of last received damage type will be healed instead."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_FATEBRINGER = 6
	)

/decl/sas_card/spell/rising_tide
	name = "Rising Tide"
	ability = "Deal 2 Earth damage to all Heretics. Next round, heal all Heretics by 3."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_FATEBRINGER = 6
	)

/decl/sas_card/spell/trial_of_the_witch
	name = "Trial of the Witch"
	ability = "If the caster dealt no damage last round, deal 4 Earth damage to target. Else, deal 1 Wind damage to target."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_FATEBRINGER = 4
	)

/decl/sas_card/spell/bladed_breeze
	name = "Bladed Breeze"
	ability = "Deal 3 Wind damage to target. If this spell is nullified, deal 1 Earth damage instead."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_FATEBRINGER = 6
	)

/decl/sas_card/spell/scrying
	name = "Scrying"
	ability = "Search deck for one spell card. Shuffle afterwards."
	spell_type = KEY_TYPE
	pack_probability = list(
		CARDPACK_FATEBRINGER = 4
	)

#undef CARDPACK_BUILDER
#undef CARDPACK_BASICWITCH
#undef CARDPACK_ALCHEMIST
#undef CARDPACK_FATEBRINGER

#undef KEY_TYPE
#undef REACTION_TYPE
