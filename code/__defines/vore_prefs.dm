#define VORE_PREF_TRANSFER(target, source) 												\
	target.digestable = source.digestable;												\
	target.devourable = source.devourable;												\
	target.feeding = source.feeding;													\
	target.absorbable = source.absorbable;												\
	target.allowmobvore = source.allowmobvore;											\
	target.permit_healbelly = source.permit_healbelly;									\
																						\
	target.vore_taste = source.vore_taste;												\
	target.vore_smell = source.vore_smell;												\
	target.noisy = source.noisy;														\
	target.show_vore_fx = source.show_vore_fx;											\
	target.selective_preference = source.selective_preference;							\
	target.digest_leave_remains = source.digest_leave_remains;							\
	target.digest_pain = source.digest_pain;											\
	target.noisy_full = source.noisy_full;												\
	target.eating_privacy_global = source.eating_privacy_global;						\
																						\
	target.can_be_drop_prey = source.can_be_drop_prey;									\
	target.can_be_drop_pred = source.can_be_drop_pred;									\
	target.throw_vore = source.throw_vore;												\
	target.food_vore = source.food_vore;												\
	target.drop_vore = source.drop_vore;												\
	target.slip_vore = source.slip_vore;												\
	target.stumble_vore = source.stumble_vore;											\
	target.phase_vore = source.phase_vore;												\
																						\
	target.resizable = source.resizable;												\
	target.step_mechanics_pref = source.step_mechanics_pref;							\
	target.pickup_pref = source.pickup_pref;											\
	target.allow_spontaneous_tf = source.allow_spontaneous_tf;							\
	target.allow_mind_transfer = source.allow_mind_transfer;							\
	target.allow_mimicry = source.allow_mimicry;										\
																						\
	target.consume_liquid_belly = source.consume_liquid_belly;							\
	target.receive_reagents = source.receive_reagents;									\
	target.apply_reagents = source.apply_reagents;										\
	target.give_reagents = source.give_reagents;										\
																						\
	target.nutrition_messages = source.nutrition_messages;								\
	target.nutrition_message_visible = source.nutrition_message_visible;				\
	target.weight_message_visible = source.weight_message_visible;						\
	target.weight_messages = source.weight_messages;									\
																						\
	target.latejoin_vore = source.latejoin_vore;										\
	target.latejoin_prey = source.latejoin_prey;										\
	target.no_latejoin_vore_warning = source.no_latejoin_vore_warning;					\
	target.no_latejoin_prey_warning = source.no_latejoin_prey_warning;					\
	target.no_latejoin_vore_warning_time = source.no_latejoin_vore_warning_time;		\
	target.no_latejoin_prey_warning_time = source.no_latejoin_prey_warning_time;		\
	target.no_latejoin_vore_warning_persists = source.no_latejoin_vore_warning_persists;\
	target.no_latejoin_prey_warning_persists = source.no_latejoin_prey_warning_persists;\
																						\
	target.autotransferable = source.autotransferable;									\
	target.strip_pref = source.strip_pref;												\
	target.vore_sprite_multiply = source.vore_sprite_multiply;							\
	target.vore_sprite_color = source.vore_sprite_color;								\
	target.belly_rub_target = source.belly_rub_target;									\
																						\
	target.soulcatcher_pref_flags = source.soulcatcher_pref_flags;
