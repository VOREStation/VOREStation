// This file contains all of the "static" define strings that tie to a trait.
// WARNING: The sections here actually matter in this file as it's tested by CI. Please do not toy with the sections."

// BEGIN TRAIT DEFINES

/*
Remember to update _globalvars/traits.dm if you're adding/removing/renaming traits.
*/

/// Trait given to a mob that is currently thinking (giving off the "thinking" icon), used in an IC context
#define TRAIT_THINKING_IN_CHARACTER "currently_thinking_IC"

/// Climbable trait, given and taken by the climbable element when added or removed. Exists to be easily checked via HAS_TRAIT().
#define TRAIT_CLIMBABLE "trait_climbable"

/// Prevents the affected object from opening a loot window via alt click. See atom/click_alt()
#define TRAIT_ALT_CLICK_BLOCKER "no_alt_click"

/// Unlucky trait. Given by the 'unlucky' trait in character select. Checked by various things to cause unlucky interactions.
#define TRAIT_UNLUCKY "trait_unlucky"

#define TRAIT_INCAPACITATED "incapacitated"

#define TRAIT_NOFIRE "nonflammable"
#define TRAIT_NOFIRE_SPREAD "no_fire_spreading"
/// Mobs that have this trait cannot be extinguished
#define TRAIT_NO_EXTINGUISH "no_extinguish"
/// Tells us that the mob urrently has the fire_handler/wet_stacks status effect
#define TRAIT_IS_WET "is_wet"
/// Mobs with this trait stay wet for longer and resist fire decaying wetness
#define TRAIT_WET_FOR_LONGER "wet_for_longer"
/// Mobs with this trait will be immune to slipping while also being slippery themselves when lying on the floor
#define TRAIT_SLIPPERY_WHEN_WET "slippery_when_wet"
/// Stops the mob from slipping on water, or banana peels, or pretty much anything that doesn't have [GALOSHES_DONT_HELP] set
#define TRAIT_NO_SLIP_WATER "noslip_water"
/// Owner will ignore any fire protection when calculating fire damage
#define TRAIT_IGNORE_FIRE_PROTECTION "ignore_fire_protection"
/// Owner will slam down heavily into the ground upon falling from a height!
#define TRAIT_HEAVY_LANDING "trait_heavy_landing"
/// Owner is immune to ingested toxins. (Any reagent/toxin subtype)
#define INGESTED_TOXIN_IMMUNE "ingested_toxin_immune"
/// If using melee, attacks will use the 'get_sparring_variant' if possible
#define TRAIT_NONLETHAL_BLOWS "trait_nonlethal_blows"
/// Are we immune to specifically tesla?
#define TRAIT_TESLA_SHOCKIMMUNE "tesla_shock_immunity"
/// Do we show up as a changeling / the wrong body-mind pair to sleevmates
#define UNIQUE_MINDSTRUCTURE "unique_mindstructure"
/// Owner is immune to hallucinations
#define TRAIT_MADNESS_IMMUNE "supermatter_madness_immune"
/// Owner will move faster when hands are empty.
#define UNUSUAL_RUNNING "unusual_running"
/// Owner is corrupted via redspace. Used downstream. SHOULD NOT BE USED LIGHTLY. HORROR THEMES.
#define TRAIT_REDSPACE_CORRUPTED "redspace_corrupted"
// allows draining of power cells for nutrition
#define TRAIT_ELECTROVORE "electrovore"
// allows draining or recharging of power cells via nutrition
#define TRAIT_ELECTROVORE_OBLIGATE "electrovore_obligate"
// adds wet stacks when licking someone
#define TRAIT_SLOBBER "slobber"

//From TG:

/// Mobs with this trait do care about a few grisly things, such as digging up graves. They also really do not like bringing people back to life or tending wounds, but love autopsies and amputations.
#define TRAIT_MORBID "morbid"

/// Trait that tracks if something has been renamed. Typically holds a REF() to the object itself (AKA src) for wide addition/removal.
#define TRAIT_WAS_RENAMED "was_renamed"

///Used for managing KEEP_TOGETHER in [/atom/var/appearance_flags]
#define TRAIT_KEEP_TOGETHER "keep-together"

/// Trait that is added to fishes that someone already caught, be it in-game or just theoretically, such as when they're bought
/// Prevents fishing achievement from being granted by catching one of these
#define TRAIT_NO_FISHING_ACHIEVEMENT "no_fishing_achievement"

///fish traits
#define TRAIT_FISH_STASIS "fish_stasis"
#define TRAIT_FISH_FLOPPING "fish_flopping"
#define TRAIT_RESIST_PSYCHIC "resist_psychic"
#define TRAIT_RESIST_EMULSIFY "resist_emulsify"
#define TRAIT_FISH_SELF_REPRODUCE "fish_self_reproduce"
#define TRAIT_FISH_NO_MATING "fish_no_mating"
#define TRAIT_YUCKY_FISH "yucky_fish"
#define TRAIT_FISH_TOXIN_IMMUNE "fish_toxin_immune"
#define TRAIT_FISH_CROSSBREEDER "fish_crossbreeder"
#define TRAIT_FISH_AMPHIBIOUS "fish_amphibious"
///Trait needed for the lubefish evolution
#define TRAIT_FISH_FED_LUBE "fish_fed_lube"
#define TRAIT_FISH_WELL_COOKED "fish_well_cooked"
#define TRAIT_FISH_NO_HUNGER "fish_no_hunger"
///Fish with this trait only sell for 1/20 of the original price when exported. For fish cases and trophy mounts.
#define TRAIT_FISH_LOW_PRICE "fish_from_case"
///Fish will also occasionally fire weak tesla zaps
#define TRAIT_FISH_ELECTROGENESIS "fish_electrogenesis"
///Offsprings from this fish will never be of its same type (unless it's self-reproducing).
#define TRAIT_FISH_RECESSIVE "fish_recessive"
///This fish comes equipped with a stinger (increased damage and potentially venomous if also toxic)
#define TRAIT_FISH_STINGER "fish_stinger"
///This fish is currently on cooldown and cannot splash ink unto people's faces
#define TRAIT_FISH_INK_ON_COOLDOWN "fish_ink_on_cooldown"
///This fish requires two hands to carry even if smaller than FISH_SIZE_TWO_HANDS_REQUIRED, as long as it's bulky-sized.
#define TRAIT_FISH_SHOULD_TWOHANDED "fish_should_twohanded"
///This fish won't be killed when cooked.
#define TRAIT_FISH_SURVIVE_COOKING "fish_survive_cooking"
///This fish is healed by milk and hurt by bone hurting juice
#define TRAIT_FISH_MADE_OF_BONE "fish_made_of_bone"
///The traits of this fish have been edited by a fish gene-gun at least once. It'll die the next time the fish genegun is used on them.
#define TRAIT_FISH_GENEGUNNED "fish_genegunned"
/**
 * This fish has been fed teslium without the electrogenesis having trait.
 * Gives the electrogenesis, but at halved output, and it hurts the fish over time.
 */
#define TRAIT_FISH_ON_TESLIUM "fish_on_teslium"
/// This fish has been fed growth serum or something and will grow 5 times faster, up to 50% weight and size gain when fed.
#define TRAIT_FISH_QUICK_GROWTH "fish_quick_growth"
/// This fish has been fed mutagen or something. Evolutions will have more than twice the probability
#define TRAIT_FISH_MUTAGENIC "fish_mutagenic"
/// This fish has just been spawned as a result of the fishing minigame - Check for this trait when doing anything that shouldn't be done when catching the fish from an aquarium.
#define TRAIT_FISH_JUST_SPAWNED "fish_just_spawned"


/// You won't catch duds while fishing with this rod.
#define TRAIT_ROD_REMOVE_FISHING_DUD "rod_remove_fishing_dud"
/// This rod ignores environmental conditions for fishing (like low light for nocturnal fish)
#define TRAIT_ROD_IGNORE_ENVIRONMENT "rod_ignore_environment"
/// This rod attracts fish with the shiny lover fish trait
#define TRAIT_ROD_ATTRACT_SHINY_LOVERS "rod_attract_shiny_lovers"
/// This rod can be used to fish on lava
#define TRAIT_ROD_LAVA_USABLE "rod_lava_usable"
/// Stuff that can go inside fish cases and aquariums
#define TRAIT_AQUARIUM_CONTENT "aquarium_content"
/// If the item can be used as a bit.
#define TRAIT_FISHING_BAIT "fishing_bait"
/// This bait will kill any fish that doesn't have it on its favorite_bait list
#define TRAIT_POISONOUS_BAIT "poisonous_bait"
/// The quality of the bait. It influences odds of catching fish
#define TRAIT_BASIC_QUALITY_BAIT "baic_quality_bait"
#define TRAIT_GOOD_QUALITY_BAIT "good_quality_bait"
#define TRAIT_GREAT_QUALITY_BAIT "great_quality_bait"
/// Baits with this trait will ignore bait preferences and related fish traits.
#define TRAIT_OMNI_BAIT "omni_bait"
/// The bait won't be consumed when used
#define TRAIT_BAIT_UNCONSUMABLE "bait_unconsumable"
/**
 * This bait won't apply TRAIT_ROD_REMOVE_FISHING_DUD to the rod it's attached on,
 * instead, it'll allow the fishing dud to be there unless there's at least one fish that likes the bait
 */
#define TRAIT_BAIT_ALLOW_FISHING_DUD "bait_dont_affect_fishing_dud"
/**
 * This location has the aquarium component. Not much different than a GetComponent()
 * disguised as an 'is_x' macro, but I don't have to hide anything here.
 * I just don't want a confusing 'is_aquarium(A)' macro which people think it's interchangable with
 * an 'istype(A, /obj/structure/aquarium)' when it's the component what truly matters.
 */
#define TRAIT_IS_AQUARIUM "is_aquarium"
/// A location (probably aquarium) that amplifies the zaps of electricity-generating fish.
#define TRAIT_BIOELECTRIC_GENERATOR "bioelectric_generator"
/// A location (likely aquarium) that doesn't allow fish to growth and reproduce
#define TRAIT_STOP_FISH_REPRODUCTION_AND_GROWTH "stop_fish_reproduction_and_growth"
/// This is an aquarium with an open panel
#define TRAIT_AQUARIUM_PANEL_OPEN "aquarium_panel_open"
/// For locations that prevent fish flopping animation, namely aquariums
#define TRAIT_STOP_FISH_FLOPPING "stop_fish_flopping"

/// This mob likes to eat fish. Raw, uncut fish.
#define TRAIT_FISH_EATER "fish_eater"
///Added to mob or mind, changes the icons of the fish shown in the minigame UI depending on the possible reward.
#define TRAIT_REVEAL_FISH "reveal_fish"
///This trait gets you a list of fishes that can be caught when examining a fishing spot.
#define TRAIT_EXAMINE_FISHING_SPOT "examine_fishing_spot"
///lobstrosities and carps will prioritize/flee from those that have this trait (given by the skill-locked hat)
#define TRAIT_SCARY_FISHERMAN "scary_fisherman"
/// Atoms with this trait can be right-clicked with a fish to release them, presumably back in the fishing spot they were caught from.
#define TRAIT_CATCH_AND_RELEASE "catch_and_release"
///This trait lets you get the size and weight of the fish by examining them
#define TRAIT_EXAMINE_FISH "examine_fish"
///This trait lets you roughly know if the fish is dead, starving, drowning or sick by examining them
#define TRAIT_EXAMINE_DEEPER_FISH "examine_deeper_fish"
///Trait given to turfs or objects that can be fished from
#define TRAIT_FISHING_SPOT "fishing_spot"
///This trait prevents the fishing spot from being linked to the fish-porter when a multitool is being used.
#define TRAIT_UNLINKABLE_FISHING_SPOT "unlinkable_fishing_spot"
///Trait given to mobs that can fish without a rod
#define TRAIT_PROFOUND_FISHER "profound_fisher"
/// If an atom has this trait, then you can toss a bottle with a message in it.
#define TRAIT_MESSAGE_IN_A_BOTTLE_LOCATION "message_in_a_bottle_location"
/// Stops other objects of the same type from being inserted inside the same aquarium it's in.
#define TRAIT_UNIQUE_AQUARIUM_CONTENT "unique_aquarium_content"

#define TRAIT_EXPERT_FISHER "expert_fisher" // fishing is easier
#define TRAIT_NAIVE "naive"
/// This object has been slathered with a speed potion
#define TRAIT_SPEED_POTIONED "speed_potioned"

/// Unlinks gliding from movement speed, meaning that there will be a delay between movements rather than a single move movement between tiles
#define TRAIT_NO_GLIDE "no_glide"
/// Prevents usage of manipulation appendages (picking, holding or using items, manipulating storage).
#define TRAIT_HANDS_BLOCKED "handsblocked"
/// Does this item bypass ranged armor checks?
#define TRAIT_BYPASS_RANGED_ARMOR "bypass_ranged_armor"
#define TRAIT_DEAF "deaf"
/// Properly wielded two handed item
#define TRAIT_WIELDED "wielded"
