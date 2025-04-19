// Vore belly options

#define STRUGGLE_OUTSIDE "smo"
#define STRUGGLE_INSIDE "smi"

#define ABSORBED_STRUGGLE_OUSIDE "asmo"
#define ABSORBED_STRUGGLE_INSIDE "asmi"

#define ESCAPE_ATTEMPT_OWNER "escao"
#define ESCAPE_ATTEMPT_PREY "escap"

#define ESCAPE_OWNER "esco"
#define ESCAPE_PREY "escp"
#define ESCAPE_OUTSIDE "escout"

#define ESCAPE_ITEM_OWNER "escio"
#define ESCAPE_ITEM_PREY "escip"
#define ESCAPE_ITEM_OUTSIDE "esciout"

#define ESCAPE_FAIL_OWNER "escfo"
#define ESCAPE_FAIL_PREY "escfp"

#define ABSORBED_ESCAPE_ATTEMPT_OWNER "aescao"
#define ABSORBED_ESCAPE_ATTEMPT_PREY "aescap"

#define ABSORBED_ESCAPE_OWNER "aesco"
#define ABSORBED_ESCAPE_PREY "aescp"
#define ABSORBED_ESCAPE_OUTSIDE "aescout"

#define FULL_ABSORBED_ESCAPE_OWNER "aescfo"
#define FULL_ABSORBED_ESCAPE_PREY "aescfp"

#define PRIMARY_TRANSFER_OWNER "trnspo"
#define PRIMARY_TRANSFER_PREY "trnspp"

#define SECONDARY_TRANSFER_OWNER "trnsso"
#define SECONDARY_TRANSFER_PREY "trnssp"

#define PRIMARY_AUTO_TRANSFER_OWNER "atrnspo"
#define PRIMARY_AUTO_TRANSFER_PREY "atrnspp"

#define SECONDARY_AUTO_TRANSFER_OWNER "atrnsso"
#define SECONDARY_AUTO_TRANSFER_PREY "atrnssp"

#define DIGEST_CHANCE_OWNER "stmodo"
#define DIGEST_CHANCE_PREY "stmodp"

#define ABSORB_CHANCE_OWNER "stmoao"
#define ABSORB_CHANCE_PREY "stmoap"

#define DIGEST_OWNER "dmo"
#define DIGEST_PREY "dmp"

#define EXAMINES "em"
#define EXAMINES_ABSORBED "ema"

#define ABSORB_OWNER "amo"
#define ABSORB_PREY "amp"

#define UNABSORBS_OWNER "uamo"
#define UNABSORBS_PREY "uamp"

#define BELLY_MODE_DIGEST "im_digest"
#define BELLY_MODE_HOLD "im_hold"
#define BELLY_MODE_HOLD_ABSORB "im_holdabsorbed"
#define BELLY_MODE_ABSORB "im_absorb"
#define BELLY_MODE_HEAL "im_heal"
#define BELLY_MODE_DRAIN "im_drain"
#define BELLY_MODE_STEAL "im_steal"
#define BELLY_MODE_EGG "im_egg"
#define BELLY_MODE_SHRINK "im_shrink"
#define BELLY_MODE_GROW "im_grow"
#define BELLY_MODE_UNABSORB "im_unabsorb"

#define BELLY_TRASH_EATER_IN "te_in"
#define BELLY_TRASH_EATER_OUT "te_out"

#define VB_MESSAGE_SANITY(type) ASSERT(type == STRUGGLE_OUTSIDE || type == STRUGGLE_INSIDE || type == ABSORBED_STRUGGLE_OUSIDE || type == ABSORBED_STRUGGLE_INSIDE || type == ESCAPE_ATTEMPT_OWNER || type == ESCAPE_ATTEMPT_PREY ||\
										type == ESCAPE_PREY || type == ESCAPE_OWNER || type == ESCAPE_OUTSIDE || type == ESCAPE_ITEM_PREY || type == ESCAPE_ITEM_OWNER || type == ESCAPE_ITEM_OUTSIDE || type == ESCAPE_FAIL_PREY ||\
										type == ESCAPE_FAIL_OWNER || type == ABSORBED_ESCAPE_ATTEMPT_OWNER || type == ABSORBED_ESCAPE_ATTEMPT_PREY || type == ABSORBED_ESCAPE_PREY || type == ABSORBED_ESCAPE_OWNER ||\
										type == ABSORBED_ESCAPE_OUTSIDE || type == FULL_ABSORBED_ESCAPE_PREY || type == FULL_ABSORBED_ESCAPE_OWNER || type == PRIMARY_TRANSFER_PREY || type == PRIMARY_TRANSFER_OWNER ||\
										type == SECONDARY_TRANSFER_PREY || type == SECONDARY_TRANSFER_OWNER || type == PRIMARY_AUTO_TRANSFER_PREY || type == PRIMARY_AUTO_TRANSFER_OWNER || type == SECONDARY_AUTO_TRANSFER_PREY ||\
										type == SECONDARY_AUTO_TRANSFER_OWNER || type == DIGEST_CHANCE_PREY || type == DIGEST_CHANCE_OWNER || type == ABSORB_CHANCE_PREY || type == ABSORB_CHANCE_OWNER || type == DIGEST_OWNER ||\
										type == DIGEST_PREY || type == ABSORB_OWNER || type == ABSORB_PREY || type == UNABSORBS_OWNER || type == UNABSORBS_PREY || type == EXAMINES || type == EXAMINES_ABSORBED ||\
										type == BELLY_MODE_DIGEST || type == BELLY_MODE_HOLD || type == BELLY_MODE_HOLD_ABSORB || type == BELLY_MODE_ABSORB || type == BELLY_MODE_HEAL || type == BELLY_MODE_DRAIN ||\
										type == BELLY_MODE_STEAL || type == BELLY_MODE_EGG || type == BELLY_MODE_SHRINK || type == BELLY_MODE_GROW || type == BELLY_MODE_UNABSORB || type == BELLY_TRASH_EATER_IN || type==BELLY_TRASH_EATER_OUT)
