// Defines used for movement state evaluation.
#define MOVEMENT_INTENT_WALKING 1
#define MOVEMENT_INTENT_RUNNING 2

#define IS_WALKING(X) (X?.move_intent?.flags & MOVEMENT_INTENT_WALKING)
#define IS_RUNNING(X) (X?.move_intent?.flags & MOVEMENT_INTENT_RUNNING)
