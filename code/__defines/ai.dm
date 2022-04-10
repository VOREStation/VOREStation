
/// Used in ai/manage_processing to indicate that the AI should be dequeued from slow and fast AI processing
#define AI_NO_PROCESS 0

/// Used in ai/manage_processing to indicate that the AI should be queued for slow AI processing, and for related subsystem checks
#define AI_PROCESSING (1 << 0)

/// Used in ai/manage_processing to indicate that the AI should be queued for fast AI processing, and for related subsystem checks
#define AI_FASTPROCESSING (1 << 1)
