/*
      |\      _,,,---,,_
ZZZzz /,`.-'`'    -.  ;-;;,_
     |,4-  ) )-,_. ,\ (  `'-'
    '---''(_/--'  `-'\_)

Defines relating to nodes, and node-adjacent things such as:

* Targetting (may move in the future)
* Flags
* Location flags
*/

#define COMMAND_NODE_DEFAULT_NAME "Unknown_Network_Node"

//while there's nothing nessicarily stopping people from mixing and matching node/network types & their locations
// it's probably best to keep it self contained?

//locations found in the human body. most are copypasta'd
#define CMD_LOC_HEAD "head"
#define CMD_LOC_EYES "eyes"

#define CMD_LOC_TORSO "torso"
#define CMD_LOC_SPINE  "spine"
#define CMD_LOC_GROIN "groin"

#define CMD_LOC_LEGS "legs"
#define CMD_LOC_L_LEG "l_leg"
#define CMD_LOC_R_LEG "r_leg"
#define CMD_LOC_FEET "feet"
#define CMD_LOC_R_FOOT "r_foot"
#define CMD_LOC_L_FOOT "l_foot"

#define CMD_LOC_ARMS "arms"
#define CMD_LOC_HANDS "hands"
#define CMD_LOC_L_ARM "l_arm"
#define CMD_LOC_R_ARM "r_arm"

#define CMD_LOC_L_HAND "l_hand"
#define CMD_LOC_R_HAND "r_hand"

#define CMD_LOC_HEART "heart"
#define CMD_LOC_LUNGS "lungs"
#define CMD_LOC_BRAIN "brain"
#define CMD_LOC_LIVER "liver"
#define CMD_LOC_KIDNEYS "kidneys"
#define CMD_LOC_APPENDIX "appendix"
#define CMD_LOC_VOICE "larynx"
#define CMD_LOC_SPLEEN "spleen"
#define CMD_LOC_STOMACH "stomach"
#define CMD_LOC_INTESTINE "intestine"

//flags. There's not many atm
#define CMD_NODE_FLAG_DATAJACK 0x001 //this node is used for input purposes in terms of datajacks
