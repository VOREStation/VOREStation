import { ItemModeSpan, ModeSpan } from './constants';
import type { Belly } from './types';
import {
  GetAddons,
  GetAutotransferFlags,
  GetLiquidAddons,
} from './VorePanelExportBellyStringHelpers';

// prettier-ignore
export const generateBellyString = (belly: Belly, index: number) => {
  const {
    // General Information
    name,
    desc,
    message_mode,
    absorbed_desc,
    vore_verb,
    release_verb,

    // Controls
    mode,
    addons,
    item_mode,

    // Options
    digest_brute,
    digest_burn,
    digest_oxy,
    digest_tox,
    digest_clone,

    can_taste,
    is_feedable,
    contaminates,
    contamination_flavor,
    contamination_color,
    nutrition_percent,
    bulge_size,
    display_absorbed_examine,
    save_digest_mode,
    emote_active,
    emote_time,
    shrink_grow_size,
    vorespawn_blacklist,
    vorespawn_whitelist,
    vorespawn_absorbed,
    egg_type,
    egg_name,
    selective_preference,
    recycling,
    storing_nutrition,
    entrance_logs,
    item_digest_logs,

    // Messages
    struggle_messages_outside,
    struggle_messages_inside,
    absorbed_struggle_messages_outside,
    absorbed_struggle_messages_inside,
    escape_attempt_messages_owner,
    escape_attempt_messages_prey,
    escape_messages_owner,
    escape_messages_prey,
    escape_messages_outside,
    escape_item_messages_owner,
    escape_item_messages_prey,
    escape_item_messages_outside,
    escape_fail_messages_owner,
    escape_fail_messages_prey,
    escape_attempt_absorbed_messages_owner,
    escape_attempt_absorbed_messages_prey,
    escape_absorbed_messages_owner,
    escape_absorbed_messages_prey,
    escape_absorbed_messages_outside,
    escape_fail_absorbed_messages_owner,
    escape_fail_absorbed_messages_prey,
    primary_transfer_messages_owner,
    primary_transfer_messages_prey,
    secondary_transfer_messages_owner,
    secondary_transfer_messages_prey,
    primary_autotransfer_messages_owner,
    primary_autotransfer_messages_prey,
    secondary_autotransfer_messages_owner,
    secondary_autotransfer_messages_prey,
    digest_chance_messages_owner,
    digest_chance_messages_prey,
    absorb_chance_messages_owner,
    absorb_chance_messages_prey,
    digest_messages_owner,
    digest_messages_prey,
    absorb_messages_owner,
    absorb_messages_prey,
    unabsorb_messages_owner,
    unabsorb_messages_prey,
    examine_messages,
    examine_messages_absorbed,
    trash_eater_in,
    trash_eater_out,
    // emote_list,
    emotes_digest,
    emotes_hold,
    emotes_holdabsorbed,
    emotes_absorb,
    emotes_heal,
    emotes_drain,
    emotes_steal,
    emotes_egg,
    emotes_shrink,
    emotes_grow,
    emotes_unabsorb,

    // Sounds
    is_wet,
    wet_loop,
    fancy_vore,
    vore_sound,
    release_sound,
    sound_volume,
    noise_freq,

    // Visuals
    affects_vore_sprites,
    count_absorbed_prey_for_sprite,
    resist_triggers_animation,
    size_factor_for_sprite,
    belly_sprite_to_affect,

    // Visuals (Belly Fullscreens Preview and Coloring)
    belly_fullscreen,
    belly_fullscreen_color,
    belly_fullscreen_color2,
    belly_fullscreen_color3,
    belly_fullscreen_color4,
    belly_fullscreen_alpha,
    colorization_enabled,

    // Visuals (Vore FX)
    disable_hud,

    // Interactions
    escapable,

    escapechance,
    escapechance_absorbed,
    escapetime,

    transferchance,
    transferlocation,

    transferchance_secondary,
    transferlocation_secondary,

    absorbchance,
    digestchance,

    belchchance,

    // Interactions (Auto-Transfer)
    autotransferwait,
    autotransferchance,
    autotransferlocation,
    autotransferextralocation,
    autotransferchance_secondary,
    autotransferlocation_secondary,
    autotransferextralocation_secondary,
    autotransfer_enabled,
    autotransfer_min_amount,
    autotransfer_max_amount,
    autotransfer_whitelist,
    autotransfer_blacklist,
    autotransfer_secondary_whitelist,
    autotransfer_secondary_blacklist,
    autotransfer_whitelist_items,
    autotransfer_blacklist_items,
    autotransfer_secondary_whitelist_items,
    autotransfer_secondary_blacklist_items,

    // Liquid Options
    show_liquids,
    reagentbellymode,
		reagent_chosen,
		reagent_name,
		reagent_transfer_verb,
		gen_time_display,
		custom_max_volume,
		vorefootsteps_sounds,
		reagent_mode_flag_list,
    liquid_overlay,
    max_liquid_level,
    reagent_touches,
    mush_overlay,
    mush_color,
    mush_alpha,
    max_mush,
    min_mush,
    item_mush_val,
    custom_reagentcolor,
    custom_reagentalpha,
    metabolism_overlay,
    metabolism_mush_ratio,
    max_ingested,
    custom_ingested_color,
    custom_ingested_alpha,

    // Liquid Messages
    liquid_fullness1_messages,
    liquid_fullness2_messages,
    liquid_fullness3_messages,
    liquid_fullness4_messages,
    liquid_fullness5_messages,

    fullness1_messages,
    fullness2_messages,
    fullness3_messages,
    fullness4_messages,
    fullness5_messages,
  } = belly;

  let result = '';
  result += '<div class="accordion-item"><h2 class="accordion-header" id="heading' + index + '">';
  result += '<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse' + index + '" aria-expanded="false" aria-controls="collapse' + index + '">';
  result +=
    name +
    ' - (<span style="color: red;">' +
    digest_brute +
    '</span >/<span style="color: orange;">' +
    digest_burn +
    '</span>/<span style="color: blue;">' +
    digest_oxy +
    '</span>/<span style="color: green;">' +
    digest_tox +
    '</span>/<span style="color: purple;">' +
    digest_clone +
    '</span>) - ' +
    ModeSpan[mode] +
    ' - ' +
    ItemModeSpan[item_mode];
  result += '</button></h2>';

  result += '<div id="collapse' + index + '" class="accordion-collapse collapse" aria-labelledby="heading' + index + '" data-bs-parent="#accordionBellies">';
  result += '<div class="accordion-body">';
  result += 'Addons:<br>' + GetAddons(addons) + '<br><br>';

  result += '<b>== Descriptions ==</b><br>';
  result += 'Vore Verb:<br>' + vore_verb + '<br><br>';
  result += 'Release Verb:<br>' + release_verb + '<br><br>';
  result += 'Description:<br>"' + desc + '"<br><br>';
  result += 'Absorbed Description:<br>"' + absorbed_desc + '"<br><br>';

  result += '<hr>';

  result += '<b>== Messages ==</b><br>';
  result +='Show All Interactive Messages: ' + (message_mode ? '<span style="color: green;">Yes' : '<span style="color: red;">No') + '</span><br>';
  result += '<div role="messagesTabpanel">'; // Start Div messagesTabpanel
  result += '<div class="row"><div class="col-4">';
  result += '<div class="list-group" id="messagesList" role="messagesTablist">';
  result += '<a class="list-group-item list-group-item-action active" data-bs-toggle="list" href="#escapeAttemptMessagesOwner' + index + '" role="tab">Escape Attempt Messages (Owner)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#escapeAttemptMessagesPrey' + index + '" role="tab">Escape Attempt Messages (Prey)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#escapeMessagesOwner' + index + '" role="tab">Escape Message (Owner)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#escapeMessagesPrey' + index + '" role="tab">Escape Message (Prey)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#escapeMessagesOutside' + index + '" role="tab">Escape Message (Outside)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#escapeItemMessagesOwner' + index + '" role="tab">Escape Item Messages (Owner)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#escapeItemMessagesPrey' + index + '" role="tab">Escape Item Messages (Prey)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#escapeItemMessagesOutside' + index + '" role="tab">Escape Item Messages (Outside)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#escapeFailMessagesOwner' + index + '" role="tab">Escape Fail Messages (Owner)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#esccapeFailMessagesPrey' + index + '" role="tab">Escape Fail Messages (Prey)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#escapeAttemptAbsorbedMessagesOwner' + index + '" role="tab">Escape Attempt Absorbed Messages (Owner)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#escapeAttemptAbsorbedMessagesPrey' + index + '" role="tab">Escape Attempt Absorbed Messages (Prey)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#escapeAbsorbedMessagesOwner' + index + '" role="tab">Escape Absorbed Messages (Owner)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#escapeAbsorbedMessagesPrey' + index + '" role="tab">Escape Absorbed Messages (Prey)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#escapeAbsorbedMessagesOutside' + index + '" role="tab">Escape Absorbed Messages (Outside)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#escapeFailAbsorbedMessagesOwner' + index + '" role="tab">Escape Fail Absorbed Messages (Owner)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#escapeFailAbsorbedMessagesPrey' + index + '" role="tab">Escape Fail Absorbed Messages (Prey)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#primaryTransferMessagesOwner' + index + '" role="tab">Primary Transfer Messages (Owner)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#primaryTransferMessagesPrey' + index + '" role="tab">Primary Transfer Messages (Prey)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#secondaryTransferMessagesOwner' + index + '" role="tab">Secondary Transfer Messages (Owner)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#secondaryTransferMessagesPrey' + index + '" role="tab">Secondary Transfer Messages (Prey)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#digestChanceMessagesOwner' + index + '" role="tab">Digest Chance Messages (Owner)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#digestChanceMessagesPrey' + index + '" role="tab">Digest Chance Messages (Prey)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#absorbChanceMessagesOwner' + index + '" role="tab">Absorb Chance Messages (Owner)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#absorbChanceMessagesPrey' + index + '" role="tab">Absorb Chance Messages (Prey)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#struggleMessagesOutside' + index + '" role="tab">Struggle Messages (Outside)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#struggleMessagesInside' + index + '" role="tab">Struggle Messages (Inside)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#absorbedStruggleOutside' + index + '" role="tab">Absorbed Struggle Messages (Outside)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#absorbedStruggleInside' + index + '" role="tab">Absorbed Struggle Messages (Inside)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#digestMessagesOwner' + index + '" role="tab">Digest Messages (Owner)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#digestMessagesPrey' + index + '" role="tab">Digest Messages (Prey)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#absorbMessagesOwner' + index + '" role="tab">Absorb Messages (Owner)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#absorbMessagesPrey' + index + '" role="tab">Absorb Messages (Prey)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#unabsorbMessagesOwner' + index + '" role="tab">Unabsorb Messages (Owner)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#unabsorbMessagesPrey' + index + '" role="tab">Unabsorb Messages (Prey)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#examineMessages' + index + '" role="tab">Examine Messages</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#examineMessagesAbsorbed' + index + '" role="tab">Examine Messages (Absorbed)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#trash_eater_in' + index + '" role="tab">Trash Eater Ingest Messages</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#trash_eater_out' + index + '" role="tab">Item Expel Messages</a>';
  result += '</div></div>';

  result += '<div class="col-8">';
  result += '<div class="tab-content">';

  result += '<div class="tab-pane fade show active" id="escapeAttemptMessagesOwner' + index + '" role="messagesTabpanel">';
  escape_attempt_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="escapeAttemptMessagesPrey' + index + '" role="messagesTabpanel">';
  escape_attempt_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="escapeMessagesOwner' + index + '" role="messagesTabpanel">';
  escape_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="escapeMessagesPrey' + index + '" role="messagesTabpanel">';
  escape_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="escapeMessagesOutside' + index + '" role="messagesTabpanel">';
  escape_messages_outside?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="escapeItemMessagesOwner' + index + '" role="messagesTabpanel">';
  escape_item_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="escapeItemMessagesPrey' + index + '" role="messagesTabpanel">';
  escape_item_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="escapeItemMessagesOutside' + index + '" role="messagesTabpanel">';
  escape_item_messages_outside?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="escapeFailMessagesOwner' + index + '" role="messagesTabpanel">';
  escape_fail_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="esccapeFailMessagesPrey' + index + '" role="messagesTabpanel">';
  escape_fail_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="escapeAttemptAbsorbedMessagesOwner' + index + '" role="messagesTabpanel">';
  escape_attempt_absorbed_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="escapeAttemptAbsorbedMessagesPrey' + index + '" role="messagesTabpanel">';
  escape_attempt_absorbed_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="escapeAbsorbedMessagesOwner' + index + '" role="messagesTabpanel">';
  escape_absorbed_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="escapeAbsorbedMessagesPrey' + index + '" role="messagesTabpanel">';
  escape_absorbed_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="escapeAbsorbedMessagesOutside' + index + '" role="messagesTabpanel">';
  escape_absorbed_messages_outside?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="escapeFailAbsorbedMessagesOwner' + index + '" role="messagesTabpanel">';
  escape_fail_absorbed_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="escapeFailAbsorbedMessagesPrey' + index + '" role="messagesTabpanel">';
  escape_fail_absorbed_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="primaryTransferMessagesOwner' + index + '" role="messagesTabpanel">';
  primary_transfer_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="primaryTransferMessagesPrey' + index + '" role="messagesTabpanel">';
  primary_transfer_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="secondaryTransferMessagesOwner' + index + '" role="messagesTabpanel">';
  secondary_transfer_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="secondaryTransferMessagesPrey' + index + '" role="messagesTabpanel">';
  secondary_transfer_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="primaryAutoTransferMessagesOwner' + index + '" role="messagesTabpanel">';
  primary_autotransfer_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="primaryAutoTransferMessagesPrey' + index + '" role="messagesTabpanel">';
  primary_autotransfer_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="secondaryAutoTransferMessagesOwner' + index + '" role="messagesTabpanel">';
  secondary_autotransfer_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="secondaryAutoTransferMessagesPrey' + index + '" role="messagesTabpanel">';
  secondary_autotransfer_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="digestChanceMessagesOwner' + index + '" role="messagesTabpanel">';
  digest_chance_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="digestChanceMessagesPrey' + index + '" role="messagesTabpanel">';
  digest_chance_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="absorbChanceMessagesOwner' + index + '" role="messagesTabpanel">';
  absorb_chance_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="absorbChanceMessagesPrey' + index + '" role="messagesTabpanel">';
  absorb_chance_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="struggleMessagesOutside' + index + '" role="messagesTabpanel">';
  struggle_messages_outside?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="struggleMessagesInside' + index + '" role="messagesTabpanel">';
  struggle_messages_inside?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="absorbedStruggleOutside' + index + '" role="messagesTabpanel">';
  absorbed_struggle_messages_outside?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="absorbedStruggleInside' + index + '" role="messagesTabpanel">';
  absorbed_struggle_messages_inside?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="digestMessagesOwner' + index + '" role="messagesTabpanel">';
  digest_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="digestMessagesPrey' + index + '" role="messagesTabpanel">';
  digest_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="absorbMessagesOwner' + index + '" role="messagesTabpanel">';
  absorb_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="absorbMessagesPrey' + index + '" role="messagesTabpanel">';
  absorb_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="unabsorbMessagesOwner' + index + '" role="messagesTabpanel">';
  unabsorb_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="unabsorbMessagesPrey' + index + '" role="messagesTabpanel">';
  unabsorb_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="examineMessages' + index + '" role="messagesTabpanel">';
  examine_messages?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="examineMessagesAbsorbed' + index + '" role="messagesTabpanel">';
  examine_messages_absorbed?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="trash_eater_in' + index + '" role="messagesTabpanel">';
  trash_eater_in?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="trash_eater_out' + index + '" role="messagesTabpanel">';
  trash_eater_out?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '</div>';
  result += '</div></div>';
  result += '</div>'; // End Div messagesTabpanel

  result += '<details><summary>= Idle Messages =</summary><p>';

  result += '<details><summary>Idle Messages (Hold):</summary><p>';
  emotes_hold?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p><br>';

  result += '<details><summary>Idle Messages (Hold Absorbed):</summary><p>';
  emotes_holdabsorbed?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p><br>';

  result += '<details><summary>Idle Messages (Digest):</summary><p>';
  emotes_digest?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p><br>';

  result += '<details><summary>Idle Messages (Absorb):</summary><p>';
  emotes_absorb?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p><br>';

  result += '<details><summary>Idle Messages (Unabsorb):</summary><p>';
  emotes_unabsorb?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p><br>';

  result += '<details><summary>Idle Messages (Drain):</summary><p>';
  emotes_drain?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p><br>';

  result += '<details><summary>Idle Messages (Heal):</summary><p>';
  emotes_heal?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p><br>';

  result += '<details><summary>Idle Messages (Size Steal):</summary><p>';
  emotes_steal?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p><br>';

  result += '<details><summary>Idle Messages (Shrink):</summary><p>';
  emotes_shrink?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p><br>';

  result += '<details><summary>Idle Messages (Grow):</summary><p>';
  emotes_grow?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p><br>';

  result += '<details><summary>Idle Messages (Encase In Egg):</summary><p>';
  emotes_egg?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p><br>';

  result += '</details></p><br>';

  result += '<hr>';

  result += '<div class="accordion" id="settingsAccordion' + index + '">';

  // OPTIONS

  result += '<div class="accordion-item">';
  result += '<h2 class="accordion-header" id="settingsAccordion' + index + '-headingOne">';
  result += '<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#settingsAccordion' + index + '-collapseOne" aria-expanded="true" aria-controls="settingsAccordion' + index + '-collapseOne">';
  result += '<b>== Options ==</b><br>';
  result += '</button></h2>';

  result += '<div id="settingsAccordion' + index + '-collapseOne" class="accordion-collapse collapse" aria-labelledby="settingsAccordion' + index + '-headingOne">';
  result += '<div class="accordion-body">';
  result += '<ul class="list-group">';
  result += '<li class="list-group-item">Can Taste: ' + (can_taste ? '<span style="color: green;">Yes' : '<span style="color: red;">No') + '</li>';
  result += '<li class="list-group-item">Feedable: ' + (is_feedable ? '<span style="color: green;">Yes' : '<span style="color: red;">No') + '</li>';
  result += '<li class="list-group-item">Contaminates: ' + (contaminates ? '<span style="color: green;">Yes' : '<span style="color: red;">No') + '</li>';
  result += '<li class="list-group-item">Contamination Flavor: ' + contamination_flavor + '</li>';
  result += '<li class="list-group-item">Contamination Color: ' + contamination_color + '</li>';
  result += '<li class="list-group-item">Nutritional Gain: ' + nutrition_percent + '%</li>';
  result += '<li class="list-group-item">Required Examine Size: ' + bulge_size * 100 + '%</li>';
  result += '<li class="list-group-item">Display Absorbed Examines: ' + (display_absorbed_examine ? '<span style="color: green;">True' : '<span style="color: red;">False') + '</li>';
  result += '<li class="list-group-item">Save Digest Mode: ' + (save_digest_mode ? '<span style="color: green;">True' : '<span style="color: red;">False') + '</li>';
  result += '<li class="list-group-item">Idle Emotes: ' + (emote_active ? '<span style="color: green;">Active' : '<span style="color: red;">Inactive') + '</li>';
  result += '<li class="list-group-item">Idle Emote Delay: ' + emote_time + ' seconds</li>';
  result += '<li class="list-group-item">Shrink/Grow Size: ' + shrink_grow_size * 100 + '%</li>';
  result += '<li class="list-group-item">Vore Spawn Blacklist: ' + (vorespawn_blacklist ? '<span style="color: green;">Yes' : '<span style="color: red;">No') + '</li>';
  result += '<li class="list-group-item">Vore Spawn Whitelist: ' + (vorespawn_whitelist.length ? vorespawn_whitelist.join(', ') : 'Anyone!') + '</li>';
  result += '<li class="list-group-item">Vore Spawn Absorbed: ' + (vorespawn_absorbed === 0 ? '<span style="color: red;">No' : vorespawn_absorbed === 1 ? '<span style="color: green;">Yes' : '<span style="color: orange;">Prey Choice') + '</li>';
  result += '<li class="list-group-item">Egg Type: ' + egg_type + '</li>';
  result += '<li class="list-group-item">Selective Mode Preference: ' + selective_preference + '</li>';
  result += '</ul>';
  result += '</div></div></div>';

  // END OPTIONS
  // SOUNDS

  result += '<div class="accordion-item">';
  result += '<h2 class="accordion-header" id="settingsAccordion' + index + '-headingTwo">';
  result += '<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#settingsAccordion' + index + '-collapseTwo" aria-expanded="true" aria-controls="settingsAccordion' + index + '-collapseTwo">';
  result += '<b>== Sounds ==</b><br>';
  result += '</button></h2>';

  result += '<div id="settingsAccordion' + index + '-collapseTwo" class="accordion-collapse collapse" aria-labelledby="settingsAccordion' + index + '-headingTwo">';
  result += '<div class="accordion-body">';
  result += '<ul class="list-group">';
  result += '<li class="list-group-item">Fleshy Belly: ' + (is_wet ? '<span style="color: green;">Yes' : '<span style="color: red;">No') + '</li>';
  result += '<li class="list-group-item">Internal Loop: ' + (wet_loop ? '<span style="color: green;">Yes' : '<span style="color: red;">No') + '</li>';
  result += '<li class="list-group-item">Use Fancy Sounds: ' + (fancy_vore ? '<span style="color: green;">Yes' : '<span style="color: red;">No') + '</li>';
  result += '<li class="list-group-item">Vore Sound: ' + vore_sound + '</li>';
  result += '<li class="list-group-item">Release Sound: ' + release_sound + '</li>';
  result += '</ul>';
  result += '</div></div></div>';

  // END SOUNDS
  // VISUALS

  result += '<div class="accordion-item">';
  result += '<h2 class="accordion-header" id="settingsAccordion' + index + '-headingVisuals">';
  result += '<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#settingsAccordion' + index + '-collapseVisuals" aria-expanded="true" aria-controls="settingsAccordion' + index + '-collapseVisuals">';
  result += '<b>== Visuals ==</b><br>';
  result += '</button></h2>';

  result += '<div id="settingsAccordion' + index + '-collapseVisuals" class="accordion-collapse collapse" aria-labelledby="settingsAccordion' + index + '-headingVisuals>';
  result += '<div class="accordion-body">';
  result += '<b>Vore Sprites</b>';
  result += '<ul class="list-group">';
  result += '<li class="list-group-item">Affect Vore Sprites: ' + (affects_vore_sprites ? '<span style="color: green;">Yes' : '<span style="color: red;">No') + '</li>';
  result += '<li class="list-group-item">Count Absorbed prey for vore sprites: ' + (count_absorbed_prey_for_sprite ? '<span style="color: green;">Yes' : '<span style="color: red;">No') + '</li>';
  result += '<li class="list-group-item">Animation when prey resist: ' + (resist_triggers_animation ? '<span style="color: green;">Yes' : '<span style="color: red;">No') + '</li>';
  result += '<li class="list-group-item">Vore Sprite Size Factor: ' + size_factor_for_sprite + '</li>';
  result += '<li class="list-group-item">Belly Sprite to affect: ' + belly_sprite_to_affect + '</li>';
  result += '</ul>';
  result += '<b>Belly Fullscreens Preview and Coloring</b>';
  result += '<ul class="list-group">';
  result += '<li class="list-group-item">Color: <span style="color: ' + belly_fullscreen_color + ';">' + belly_fullscreen_color + '</span>';
  result += '</ul>';
  result += '<b>Vore FX</b>';
  result += '<ul class="list-group">';
  result += '<li class="list-group-item">Disable Prey HUD: ' + (disable_hud ? '<span style="color: green;">Yes' : '<span style="color: red;">No') + '</li>';
  result += '</ul>';
  result += '</div></div></div>';

  // END VISUALS
  // INTERACTIONS

  result += '<div class="accordion-item">';
  result += '<h2 class="accordion-header" id="settingsAccordion' + index + '-headingThree">';
  result += '<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#settingsAccordion' + index + '-collapseThree" aria-expanded="true" aria-controls="settingsAccordion' + index + '-collapseThree">';
  result += '<b>== Interactions ==</b>';
  result += '</button></h2>';

  result += '<div id="settingsAccordion' + index + '-collapseThree" class="accordion-collapse collapse" aria-labelledby="settingsAccordion' + index + '-headingThree">';
  result += '<div class="accordion-body">';
  result += '<b>Belly Interactions (' +
  (escapable ? '<span style="color: green;">Enabled' : '<span style="color: red;">Disabled') +
  '</span>)</b>';
  result += '<ul class="list-group">';
  result += '<li class="list-group-item">Escape Chance: ' + escapechance + '%</li>';
  result += '<li class="list-group-item">Escape Chance: ' + escapechance_absorbed + '%</li>';
  result += '<li class="list-group-item">Escape Time: ' + escapetime / 10 + 's</li>';
  result += '<li class="list-group-item">Transfer Chance: ' + transferchance + '%</li>';
  result += '<li class="list-group-item">Transfer Location: ' + transferlocation + '</li>';
  result += '<li class="list-group-item">Secondary Transfer Chance: ' + transferchance_secondary + '%</li>';
  result += '<li class="list-group-item">Secondary Transfer Location: ' + transferlocation_secondary + '</li>';
  result += '<li class="list-group-item">Absorb Chance: ' + absorbchance + '%</li>';
  result += '<li class="list-group-item">Digest Chance: ' + digestchance + '%</li>';
  result += '<li class="list-group-item">Belch Chance: ' + belchchance + '%</li>';
  result += '</ul>';
  result += '<hr>';
  result += '<b>Auto-Transfer Options (' +
  (autotransfer_enabled ? '<span style="color: green;">Enabled' : '<span style="color: red;">Disabled') +
  '</span>)</b>';
  result += '<ul class="list-group">';
  result += '<li class="list-group-item">Auto-Transfer Time: ' + autotransferwait / 10 + 's</li>';
  result += '<li class="list-group-item">Auto-Transfer Chance: ' + autotransferchance + '%</li>';
  result += '<li class="list-group-item">Auto-Transfer Location: ' + autotransferlocation + '</li>';
  result += '<li class="list-group-item">Auto-Transfer Chance: ' + autotransferchance_secondary + '%</li>';
  result += '<li class="list-group-item">Auto-Transfer Location: ' + autotransferlocation_secondary + '</li>';
  result += '<li class="list-group-item">Auto-Transfer Min Amount: ' + autotransfer_min_amount + '</li>';
  result += '<li class="list-group-item">Auto-Transfer Max Amount: ' + autotransfer_max_amount + '</li>';
  result += '<li class="list-group-item">Auto-Transfer Primary Chance: ' + autotransferchance + '%</li>';
  result += '<li class="list-group-item">Auto-Transfer Primary Location: ' + autotransferlocation + '</li>';
  result += '<li class="list-group-item">Auto-Transfer Primary Location Extras: ' + autotransferextralocation.join(', ') + '</li>';
  result += '<li class="list-group-item">Auto-Transfer Primary Whitelist (Mobs): ' + GetAutotransferFlags(autotransfer_whitelist, true) + '</li>';
  result += '<li class="list-group-item">Auto-Transfer Primary Whitelist (Items): ' + GetAutotransferFlags(autotransfer_whitelist_items, true) + '</li>';
  result += '<li class="list-group-item">Auto-Transfer Primary Blacklist (Mobs): ' + GetAutotransferFlags(autotransfer_blacklist, false) + '</li>';
  result += '<li class="list-group-item">Auto-Transfer Primary Blacklist (Items): ' + GetAutotransferFlags(autotransfer_blacklist_items, false) + '</li>';
  result += '<li class="list-group-item">Auto-Transfer Secondary Chance: ' + autotransferchance_secondary + '%</li>';
  result += '<li class="list-group-item">Auto-Transfer Secondary Location: ' + autotransferlocation_secondary + '</li>';
  result += '<li class="list-group-item">Auto-Transfer Secondary Location Extras: ' + autotransferextralocation_secondary.join(', ') + '</li>';
  result += '<li class="list-group-item">Auto-Transfer Secondary Whitelist (Mobs): ' + GetAutotransferFlags(autotransfer_secondary_whitelist, true) + '</li>';
  result += '<li class="list-group-item">Auto-Transfer Secondary Whitelist (Items): ' + GetAutotransferFlags(autotransfer_secondary_whitelist_items, true) + '</li>';
  result += '<li class="list-group-item">Auto-Transfer Secondary Blacklist (Mobs): ' + GetAutotransferFlags(autotransfer_secondary_blacklist, false) + '</li>';
  result += '<li class="list-group-item">Auto-Transfer Secondary Blacklist (Items): ' + GetAutotransferFlags(autotransfer_secondary_blacklist_items, false) + '</li>';
  result += '</ul>';
  result += '</div></div></div>';

  // END INTERACTIONS
  // LIQUID OPTIONS

  result += '<div class="accordion-item">';
  result += '<h2 class="accordion-header" id="settingsAccordion' + index + '-headingFour">';
  result += '<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#settingsAccordion' + index + '-collapseFour" aria-expanded="true" aria-controls="settingsAccordion' + index + '-collapseFour">';
  result += '<b>== Liquid Options (' +
  (show_liquids ? '<span style="color: green;">Liquids On' : '<span style="color: red;">Liquids Off') +
  '</span>) ==</b>';
  result += '</button></h2>';

  result += '<div id="settingsAccordion' + index + '-collapseFour" class="accordion-collapse collapse" aria-labelledby="settingsAccordion' + index + '-headingFour">';
  result += '<div class="accordion-body">';
  result += '<ul class="list-group">';
  result += '<li class="list-group-item">Generate Liquids: ' + (reagentbellymode ? '<span style="color: green;">On' : '<span style="color: red;">Off') + '</li>';
  result += '<li class="list-group-item">Liquid Type: ' + reagent_chosen + '</li>';
  result += '<li class="list-group-item">Liquid Name: ' + reagent_name + '</li>';
  result += '<li class="list-group-item">Transfer Verb: ' + reagent_transfer_verb + '</li>';
  result += '<li class="list-group-item">Generation Time: ' + gen_time_display + '</li>';
  result += '<li class="list-group-item">Liquid Capacity: ' + custom_max_volume + '</li>';
  result += '<li class="list-group-item">Slosh Sounds: ' + (vorefootsteps_sounds ? '<span style="color: green;">On' : '<span style="color: red;">Off') + '</li>';
  result += '<li class="list-group-item">Liquid Addons: ' + GetLiquidAddons(reagent_mode_flag_list) + '</li>';
  result += '</ul>';
  result += '</div></div></div>';

  // END LIQUID OPTIONS
  // LIQUID MESSAGES

  result += '<div class="accordion-item">';
  result += '<h2 class="accordion-header" id="settingsAccordion' + index + '-headingFive">';
  result += '<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#settingsAccordion' + index + '-collapseFive" aria-expanded="true" aria-controls="settingsAccordion' + index + '-collapseFive">';
  result += '<b>== Liquid Messages (' +
  (show_liquids ? '<span style="color: green;">Messages On' : '<span style="color: red;">Messages Off') +
  '</span>) ==</b>';
  result += '</button></h2>';

  result += '<div id="settingsAccordion' + index + '-collapseFive" class="accordion-collapse collapse" aria-labelledby="settingsAccordion' + index + '-headingFive">';
  result += '<div class="accordion-body">';

  result += '<div role="liquidMessagesTabpanel">'; // Start Div liquidMessagesTabpanel
  result += '<div class="row"><div class="col-4">';
  result += '<div class="list-group" id="liquidMessagesList" role="messagesTablist">';
  result += '<a class="list-group-item list-group-item-action active" data-bs-toggle="list" href="#examineMessage0_20' + index + '" role="tab">Examine Message (0 to 20%) (' + (liquid_fullness1_messages ? '<span style="color: green;">On' : '<span style="color: red;">Off') + '</span>)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#examineMessage20_40' + index + '" role="tab">Examine Message (20 to 40%) (' + (liquid_fullness2_messages ? '<span style="color: green;">On' : '<span style="color: red;">Off') + '</span>)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#examineMessage40_60' + index + '" role="tab">Examine Message (40 to 60%) (' + (liquid_fullness3_messages ? '<span style="color: green;">On' : '<span style="color: red;">Off') + '</span>)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#examineMessage60_80' + index + '" role="tab">Examine Message (60 to 80%) (' + (liquid_fullness4_messages ? '<span style="color: green;">On' : '<span style="color: red;">Off') + '</span>)</a>';
  result += '<a class="list-group-item list-group-item-action" data-bs-toggle="list" href="#examineMessage80_100' + index + '" role="tab">Examine Message (80 to 100%) (' + (liquid_fullness5_messages ? '<span style="color: green;">On' : '<span style="color: red;">Off') + '</span>)</a>';
  result += '</div></div>';

  result += '<div class="col-8">';
  result += '<div class="tab-content">';

  result += '<div class="tab-pane fade show active" id="examineMessage0_20' + index + '" role="liquidMessagesTabpanel">';
  fullness1_messages?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="examineMessage20_40' + index + '" role="liquidMessagesTabpanel">';
  fullness2_messages?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="examineMessage40_60' + index + '" role="liquidMessagesTabpanel">';
  fullness3_messages?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="examineMessage60_80' + index + '" role="liquidMessagesTabpanel">';
  fullness4_messages?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '<div class="tab-pane fade" id="examineMessage80_100' + index + '" role="liquidMessagesTabpanel">';
  fullness5_messages?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</div>';

  result += '</div>';
  result += '</div></div>';
  result += '</div>'; // End Div liquidMessagesTabpanel

  result += '</div></div></div>';

  // END LIQUID MESSAGES

  result += '</div></div></div>';

  return result;
};
