#undef LIGHT_COLOR_INCANDESCENT_TUBE
#define LIGHT_COLOR_INCANDESCENT_TUBE "#E0EFF0"
#undef LIGHT_COLOR_INCANDESCENT_BULB
#define LIGHT_COLOR_INCANDESCENT_BULB "#FFFEB8"

//Fake ambient occlusion filter
#undef AMBIENT_OCCLUSION
#define AMBIENT_OCCLUSION filter(type="drop_shadow", x=0, y=-1, size=2, offset=2, color="#04080F55") //VOREStation Edit for prettier visuals.