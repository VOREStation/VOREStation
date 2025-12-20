// This file contains all of the trait sources, or all of the things that grant traits.
// Several things such as `type` or `REF(src)` may be used in the ADD_TRAIT() macro as the "source", but this file contains all of the defines for immutable static strings.

/// cannot be removed without admin intervention
#define ROUNDSTART_TRAIT "roundstart"

/// Trait given by an Action datum
#define ACTION_TRAIT "action"
/// trait associated to being held in a chokehold
#define CHOKEHOLD_TRAIT "chokehold"

/// This trait comes from when a mob is currently typing.
#define CURRENTLY_TYPING_TRAIT "currently_typing"

/// Trait that is given by unholy effects or corruption. Can be dispelled by a chaplain with a nullrod.
#define UNHOLY_TRAIT "unholy"
