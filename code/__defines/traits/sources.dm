// This file contains all of the trait sources, or all of the things that grant traits.
// Several things such as `type` or `REF(src)` may be used in the ADD_TRAIT() macro as the "source", but this file contains all of the defines for immutable static strings.

/// cannot be removed without admin intervention
#define ROUNDSTART_TRAIT "roundstart"
/// This trait comes from when a mob is currently typing.
#define CURRENTLY_TYPING_TRAIT "currently_typing"
/// Trait given by performing an action (proc, verb, etc. Something that the USER can control)
#define ACTION_TRAIT "action"
/// Trait given by an object being equipped/worn
#define CLOTHING_TRAIT "clothing"
