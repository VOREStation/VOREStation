/*
 * Defines used for miscellaneous objects.
 */

// Multitool Mode Defines.

#define MULTITOOL_MODE_STANDARD				"Standard"
#define MULTITOOL_MODE_INTCIRCUITS			"Modular Wiring"
#define MULTITOOL_MODE_DOORHACK 			"Advanced Jacking"

// Identity system defines.
#define IDENTITY_UNKNOWN	0 // Nothing is known so far.
#define IDENTITY_PROPERTIES	1 // Basic function of the item, and amount of charges available if it uses them.
#define IDENTITY_QUALITY	2 // Blessed/Uncursed/Cursed status. Some things don't use this.
#define IDENTITY_FULL		IDENTITY_PROPERTIES|IDENTITY_QUALITY // Know everything.

#define IDENTITY_TYPE_NONE		"generic"
#define IDENTITY_TYPE_TECH		"technological"
#define IDENTITY_TYPE_CHEMICAL	"chemical"

// Roguelike object quality defines. Not used at the moment.
#define ROGUELIKE_ITEM_ARTIFACT		2	// Cannot degrade, very rare.
#define ROGUELIKE_ITEM_BLESSED		1	// Better than average and resists cursing.
#define ROGUELIKE_ITEM_UNCURSED		0	// Normal.
#define ROGUELIKE_ITEM_CURSED		-1	// Does bad things, clothing cannot be taken off.

// Consistant messages for certain events.
// Consistancy is import in order to avoid giving too much information away when using an
// unidentified object due to a typo or some other unique difference in message output.
#define ROGUELIKE_MESSAGE_NOTHING "Nothing happens."
#define ROGUELIKE_MESSAGE_UNKNOWN "Something happened, but you're not sure what."

// Cataloguer defines.

// Defines about the reward point scaling. Adjust these if you want points to be more or less common.
#define CATALOGUER_REWARD_TRIVIAL	10		// Very easy things that would take little effort to find, like the grass or an NT banner.
#define CATALOGUER_REWARD_EASY		40		// Fairly easy things, like the common Sif creatures, cave crystals, and the base spiders
#define CATALOGUER_REWARD_MEDIUM	160		// Takes effort to find, like PoI specific things like black boxes, or rarer mobs like the special spiders.
#define CATALOGUER_REWARD_HARD		640		// Requires significant effort, such as scanning all spiders or other compilation-based discoveries, or clearing a dangerous PoI.
#define CATALOGUER_REWARD_SUPERHARD	2560	// Very difficult and dangerous, such as scanning the Advanced Dark Gygax.

// 5	10	20	40	80	160
// 10	40	160	640	2560