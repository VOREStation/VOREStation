import {
  ItemModeSpan,
  ModeSpan,
  STRUGGLE_OUTSIDE_ABSORBED_MESSAGE,
  STRUGGLE_OUTSIDE_MESSAGE,
} from './constants';
import {
  formatListEmotes,
  formatListItems,
  formatListMessages,
  getYesNo,
} from './functions';
import type { Belly, EmoteEntry, SettingItem } from './types';

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
    display_name,
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
    bellytemperature,
    temperature_damage,

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
    displayed_message_flags,
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
    reagent_gen_cost_limit,
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
  result += `<div class="accordion-item"><h2 class="accordion-header" id="heading${index}">`;
  result += `<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse${index}" aria-expanded="false" aria-controls="collapse${index}">`;

  const damageTypes = [
    { value: digest_brute, color: 'red' },
    { value: digest_burn, color: 'orange' },
    { value: digest_oxy, color: 'blue' },
    { value: digest_tox, color: 'green' },
    { value: digest_clone, color: 'purple' },
  ];

  const damageSpans = damageTypes
    .map(({ value, color }) => `<span style="color: ${color};">${value}</span>`)
    .join('/');

  const temperatureCelsius = Math.round((bellytemperature - 273.15) * 10) / 10;
  const temperatureSpan = `<span${temperature_damage ? ' style="color: red;"' : ''}>${temperatureCelsius}°C</span>`;

  result += `${name} - (${damageSpans}/${temperatureSpan}) - ${ModeSpan[mode]} - ${ItemModeSpan[item_mode]}`;

  result += '</button></h2>';

  result += `<div id="collapse${index}" class="accordion-collapse collapse" aria-labelledby="heading${index}" data-bs-parent="#accordionBellies">`;
  result += '<div class="accordion-body">';
  result += `Addons:<br>${GetAddons(addons)}<br><br>`;

  result += '<b>== Descriptions ==</b><br>';

  const infoFields = [
    { label: 'Vore Verb', value: vore_verb },
    { label: 'Release Verb', value: release_verb },
    { label: 'Description', value: `"${desc}"` },
    { label: 'Absorbed Description', value: `"${absorbed_desc}"` },
  ];

  infoFields.forEach(({ label, value }) => {
    result += `${label}:<br>${value}<br><br>`;
  });

  result += '<hr>';

  result += '<b>== Messages ==</b><br>';
  result += `Show All Interactive Messages: ${
    message_mode
      ? '<span style="color: green;">Yes'
      : '<span style="color: red;">No'
  }</span><br>`;
  result += '<div role="messagesTabpanel">'; // Start Div messagesTabpanel
  result += '<div class="row"><div class="col-4">';
  result += '<div class="list-group" id="messagesList" role="messagesTablist">';

  const tabLinks: {
    id: string;
    label: string;
    active?: boolean;
    enabled?: boolean;
  }[] = [
    {
      id: 'escapeAttemptMessagesOwner',
      label: 'Escape Attempt Messages (Owner)',
      active: true,
    },
    {
      id: 'escapeAttemptMessagesPrey',
      label: 'Escape Attempt Messages (Prey)',
    },
    { id: 'escapeMessagesOwner', label: 'Escape Message (Owner)' },
    { id: 'escapeMessagesPrey', label: 'Escape Message (Prey)' },
    { id: 'escapeMessagesOutside', label: 'Escape Message (Outside)' },
    { id: 'escapeItemMessagesOwner', label: 'Escape Item Messages (Owner)' },
    { id: 'escapeItemMessagesPrey', label: 'Escape Item Messages (Prey)' },
    {
      id: 'escapeItemMessagesOutside',
      label: 'Escape Item Messages (Outside)',
    },
    { id: 'escapeFailMessagesOwner', label: 'Escape Fail Messages (Owner)' },
    { id: 'escapeFailMessagesPrey', label: 'Escape Fail Messages (Prey)' },
    {
      id: 'escapeAttemptAbsorbedMessagesOwner',
      label: 'Escape Attempt Absorbed Messages (Owner)',
    },
    {
      id: 'escapeAttemptAbsorbedMessagesPrey',
      label: 'Escape Attempt Absorbed Messages (Prey)',
    },
    {
      id: 'escapeAbsorbedMessagesOwner',
      label: 'Escape Absorbed Messages (Owner)',
    },
    {
      id: 'escapeAbsorbedMessagesPrey',
      label: 'Escape Absorbed Messages (Prey)',
    },
    {
      id: 'escapeAbsorbedMessagesOutside',
      label: 'Escape Absorbed Messages (Outside)',
    },
    {
      id: 'escapeFailAbsorbedMessagesOwner',
      label: 'Escape Fail Absorbed Messages (Owner)',
    },
    {
      id: 'escapeFailAbsorbedMessagesPrey',
      label: 'Escape Fail Absorbed Messages (Prey)',
    },
    {
      id: 'primaryTransferMessagesOwner',
      label: 'Primary Transfer Messages (Owner)',
    },
    {
      id: 'primaryTransferMessagesPrey',
      label: 'Primary Transfer Messages (Prey)',
    },
    {
      id: 'secondaryTransferMessagesOwner',
      label: 'Secondary Transfer Messages (Owner)',
    },
    {
      id: 'secondaryTransferMessagesPrey',
      label: 'Secondary Transfer Messages (Prey)',
    },
    {
      id: 'digestChanceMessagesOwner',
      label: 'Digest Chance Messages (Owner)',
    },
    { id: 'digestChanceMessagesPrey', label: 'Digest Chance Messages (Prey)' },
    {
      id: 'absorbChanceMessagesOwner',
      label: 'Absorb Chance Messages (Owner)',
    },
    { id: 'absorbChanceMessagesPrey', label: 'Absorb Chance Messages (Prey)' },
    {
      id: 'struggleMessagesOutside',
      label: 'Struggle Messages (Outside)',
      enabled: (displayed_message_flags & STRUGGLE_OUTSIDE_MESSAGE) > 0,
    },
    { id: 'struggleMessagesInside', label: 'Struggle Messages (Inside)' },
    {
      id: 'absorbedStruggleOutside',
      label: 'Absorbed Struggle Messages (Outside)',
      enabled:
        (displayed_message_flags & STRUGGLE_OUTSIDE_ABSORBED_MESSAGE) > 0,
    },
    {
      id: 'absorbedStruggleInside',
      label: 'Absorbed Struggle Messages (Inside)',
    },
    { id: 'digestMessagesOwner', label: 'Digest Messages (Owner)' },
    { id: 'digestMessagesPrey', label: 'Digest Messages (Prey)' },
    { id: 'absorbMessagesOwner', label: 'Absorb Messages (Owner)' },
    { id: 'absorbMessagesPrey', label: 'Absorb Messages (Prey)' },
    { id: 'unabsorbMessagesOwner', label: 'Unabsorb Messages (Owner)' },
    { id: 'unabsorbMessagesPrey', label: 'Unabsorb Messages (Prey)' },
    { id: 'examineMessages', label: 'Examine Messages' },
    { id: 'examineMessagesAbsorbed', label: 'Examine Messages (Absorbed)' },
    { id: 'trash_eater_in', label: 'Trash Eater Ingest Messages' },
    { id: 'trash_eater_out', label: 'Item Expel Messages' },
  ];

  tabLinks.forEach(({ id, label, enabled }, i) => {
    const isActive = i === 0 ? ' active' : '';
    const status = enabled === undefined ? '' : getYesNo(enabled);

    result += `<a class="list-group-item list-group-item-action${isActive}" data-bs-toggle="list" href="#${id}${index}" role="tab">${label}${status}</a>`;
  });

  result += '</div></div>';

  result += '<div class="col-8">';
  result += '<div class="tab-content">';

  const messageTypes: [string, string[] | null][] = [
    ['escapeAttemptMessagesOwner', escape_attempt_messages_owner],
    ['escapeAttemptMessagesPrey', escape_attempt_messages_prey],
    ['escapeMessagesOwner', escape_messages_owner],
    ['escapeMessagesPrey', escape_messages_prey],
    ['escapeMessagesOutside', escape_messages_outside],
    ['escapeItemMessagesOwner', escape_item_messages_owner],
    ['escapeItemMessagesPrey', escape_item_messages_prey],
    ['escapeItemMessagesOutside', escape_item_messages_outside],
    ['escapeFailMessagesOwner', escape_fail_messages_owner],
    ['escapeFailMessagesPrey', escape_fail_messages_prey],
    [
      'escapeAttemptAbsorbedMessagesOwner',
      escape_attempt_absorbed_messages_owner,
    ],
    [
      'escapeAttemptAbsorbedMessagesPrey',
      escape_attempt_absorbed_messages_prey,
    ],
    ['escapeAbsorbedMessagesOwner', escape_absorbed_messages_owner],
    ['escapeAbsorbedMessagesPrey', escape_absorbed_messages_prey],
    ['escapeAbsorbedMessagesOutside', escape_absorbed_messages_outside],
    ['escapeFailAbsorbedMessagesOwner', escape_fail_absorbed_messages_owner],
    ['escapeFailAbsorbedMessagesPrey', escape_fail_absorbed_messages_prey],
    ['primaryTransferMessagesOwner', primary_transfer_messages_owner],
    ['primaryTransferMessagesPrey', primary_transfer_messages_prey],
    ['secondaryTransferMessagesOwner', secondary_transfer_messages_owner],
    ['secondaryTransferMessagesPrey', secondary_transfer_messages_prey],
    ['primaryAutoTransferMessagesOwner', primary_autotransfer_messages_owner],
    ['primaryAutoTransferMessagesPrey', primary_autotransfer_messages_prey],
    [
      'secondaryAutoTransferMessagesOwner',
      secondary_autotransfer_messages_owner,
    ],
    ['secondaryAutoTransferMessagesPrey', secondary_autotransfer_messages_prey],
    ['digestChanceMessagesOwner', digest_chance_messages_owner],
    ['digestChanceMessagesPrey', digest_chance_messages_prey],
    ['absorbChanceMessagesOwner', absorb_chance_messages_owner],
    ['absorbChanceMessagesPrey', absorb_chance_messages_prey],
    ['struggleMessagesOutside', struggle_messages_outside],
    ['struggleMessagesInside', struggle_messages_inside],
    ['absorbedStruggleOutside', absorbed_struggle_messages_outside],
    ['absorbedStruggleInside', absorbed_struggle_messages_inside],
    ['digestMessagesOwner', digest_messages_owner],
    ['digestMessagesPrey', digest_messages_prey],
    ['absorbMessagesOwner', absorb_messages_owner],
    ['absorbMessagesPrey', absorb_messages_prey],
    ['unabsorbMessagesOwner', unabsorb_messages_owner],
    ['unabsorbMessagesPrey', unabsorb_messages_prey],
    ['examineMessages', examine_messages],
    ['examineMessagesAbsorbed', examine_messages_absorbed],
    ['trash_eater_in', trash_eater_in],
    ['trash_eater_out', trash_eater_out],
  ];

  messageTypes.forEach(([messageKey, messageData], i) => {
    result += formatListMessages(`${messageKey}${index}`, messageData, i === 0);
  });
  result += '</div>';
  result += '</div></div>';
  result += '</div>'; // End Div messagesTabpanel

  result += '<details><summary>= Idle Messages =</summary><p>';

  const emoteSections: EmoteEntry[] = [
    { label: 'Idle Messages (Hold)', messages: emotes_hold },
    { label: 'Idle Messages (Hold Absorbed)', messages: emotes_holdabsorbed },
    { label: 'Idle Messages (Digest)', messages: emotes_digest },
    { label: 'Idle Messages (Absorb)', messages: emotes_absorb },
    { label: 'Idle Messages (Unabsorb)', messages: emotes_unabsorb },
    { label: 'Idle Messages (Drain)', messages: emotes_drain },
    { label: 'Idle Messages (Heal)', messages: emotes_heal },
    { label: 'Idle Messages (Size Steal)', messages: emotes_steal },
    { label: 'Idle Messages (Shrink)', messages: emotes_shrink },
    { label: 'Idle Messages (Grow)', messages: emotes_grow },
    { label: 'Idle Messages (Encase In Egg)', messages: emotes_egg },
  ];

  result += formatListEmotes(emoteSections);

  result += '</details></p><br>';

  result += '<hr>';

  result += `<div class="accordion" id="settingsAccordion${index}">`;

  // OPTIONS

  result += '<div class="accordion-item">';
  result += `<h2 class="accordion-header" id="settingsAccordion${index}-headingOne">`;
  result += `<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#settingsAccordion${index}-collapseOne" aria-expanded="true" aria-controls="settingsAccordion${index}-collapseOne">`;
  result += '<b>== Options ==</b><br>';
  result += '</button></h2>';

  result += `<div id="settingsAccordion${index}-collapseOne" class="accordion-collapse collapse" aria-labelledby="settingsAccordion${index}-headingOne">`;
  result += '<div class="accordion-body">';
  result += '<ul class="list-group">';

  const settingItem: SettingItem[] = [
    {
      label: 'Can Taste',
      value: can_taste,
      formatter: (val: boolean): string => getYesNo(val),
    },
    {
      label: 'Feedable',
      value: is_feedable,
      formatter: (val: boolean): string => getYesNo(val),
    },
    {
      label: 'Contaminates',
      value: contaminates,
      formatter: (val: boolean): string => getYesNo(val),
    },
    { label: 'Contamination Flavor', value: contamination_flavor },
    { label: 'Contamination Color', value: contamination_color },
    {
      label: 'Nutritional Gain',
      value: nutrition_percent,
      formatter: (val: number): string => `${val}%`,
    },
    {
      label: 'Required Examine Size',
      value: bulge_size,
      formatter: (val: number): string => `${val * 100}%`,
    },
    {
      label: 'Display Absorbed Examines',
      value: display_absorbed_examine,
      formatter: (val: boolean): string =>
        val
          ? '<span style="color: green;">True</span>'
          : '<span style="color: red;">False</span>',
    },
    {
      label: 'Save Digest Mode',
      value: save_digest_mode,
      formatter: (val: boolean): string =>
        val
          ? '<span style="color: green;">True</span>'
          : '<span style="color: red;">False</span>',
    },
    {
      label: 'Idle Emotes',
      value: emote_active,
      formatter: (val: boolean): string =>
        val
          ? '<span style="color: green;">Active</span>'
          : '<span style="color: red;">Inactive</span>',
    },
    {
      label: 'Idle Emote Delay',
      value: emote_time,
      formatter: (val: number): string => `${val} seconds`,
    },
    {
      label: 'Shrink/Grow Size',
      value: shrink_grow_size,
      formatter: (val: number): string => `${val * 100}%`,
    },
    {
      label: 'Vore Spawn Blacklist',
      value: vorespawn_blacklist,
      formatter: (val: boolean): string => getYesNo(val),
    },
    {
      label: 'Vore Spawn Whitelist',
      value: vorespawn_whitelist,
      formatter: (val: string[]): string =>
        val.length ? val.join(', ') : 'Anyone!',
    },
    {
      label: 'Vore Spawn Absorbed',
      value: vorespawn_absorbed,
      formatter: (val: number): string =>
        val === 0
          ? '<span style="color: red;">No</span>'
          : val === 1
            ? '<span style="color: green;">Yes</span>'
            : '<span style="color: orange;">Prey Choice</span>',
    },
    { label: 'Egg Type', value: egg_type },
    { label: 'Selective Mode Preference', value: selective_preference },
  ];

  result += formatListItems(settingItem);

  result += '</ul>';
  result += '</div></div></div>';

  // END OPTIONS
  // SOUNDS

  result += '<div class="accordion-item">';
  result += `<h2 class="accordion-header" id="settingsAccordion${index}-headingTwo">`;
  result += `<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#settingsAccordion${index}-collapseTwo" aria-expanded="true" aria-controls="settingsAccordion${index}-collapseTwo">`;
  result += '<b>== Sounds ==</b><br>';
  result += '</button></h2>';

  result += `<div id="settingsAccordion${index}-collapseTwo" class="accordion-collapse collapse" aria-labelledby="settingsAccordion${index}-headingTwo">`;
  result += '<div class="accordion-body">';
  result += '<ul class="list-group">';

  const soundItems = [
    { label: 'Fleshy Belly', value: is_wet, formatter: getYesNo },
    { label: 'Internal Loop', value: wet_loop, formatter: getYesNo },
    { label: 'Use Fancy Sounds', value: fancy_vore, formatter: getYesNo },
    { label: 'Vore Sound', value: vore_sound },
    { label: 'Release Sound', value: release_sound },
  ];

  result += formatListItems(soundItems);

  result += '</ul>';
  result += '</div></div></div>';

  // END SOUNDS
  // VISUALS

  result += '<div class="accordion-item">';
  result += `<h2 class="accordion-header" id="settingsAccordion${index}-headingVisuals">`;
  result += `<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#settingsAccordion${index}-collapseVisuals" aria-expanded="true" aria-controls="settingsAccordion${index}-collapseVisuals">`;
  result += '<b>== Visuals ==</b><br>';
  result += '</button></h2>';

  result += `<div id="settingsAccordion${index}-collapseVisuals" class="accordion-collapse collapse" aria-labelledby="settingsAccordion${index}-headingVisuals>`;
  result += '<div class="accordion-body">';
  result += '<b>Vore Sprites</b>';
  result += '<ul class="list-group">';

  const visualItems = [
    {
      label: 'Affect Vore Sprites',
      value: affects_vore_sprites,
      formatter: getYesNo,
    },
    {
      label: 'Count Absorbed prey for vore sprites',
      value: count_absorbed_prey_for_sprite,
      formatter: getYesNo,
    },
    {
      label: 'Animation when prey resist',
      value: resist_triggers_animation,
      formatter: getYesNo,
    },
    { label: 'Vore Sprite Size Factor', value: size_factor_for_sprite },
    { label: 'Belly Sprite to affect', value: belly_sprite_to_affect },
  ];

  result += formatListItems(visualItems);

  result += '</ul>';
  result += '<b>Belly Fullscreens Preview and Coloring</b>';
  result += '<ul class="list-group">';

  const bellyColorItems = [
    { label: 'Fullscreen Color', value: belly_fullscreen_color },
    { label: 'Fullscreen Color 2', value: belly_fullscreen_color2 },
    { label: 'Fullscreen Color 3', value: belly_fullscreen_color3 },
    { label: 'Fullscreen Color 4', value: belly_fullscreen_color4 },
    { label: 'Fullscreen Alpha', value: belly_fullscreen_alpha },
  ];

  bellyColorItems.forEach(({ label, value }) => {
    const isColorCode = typeof value === 'string' && value.startsWith('#');
    result += `<li class="list-group-item">${label}: ${
      isColorCode ? `<span style="color: ${value};">${value}</span>` : value
    }</li>`;
  });

  result += '</ul>';
  result += '<b>Vore FX</b>';
  result += '<ul class="list-group">';
  result += `<li class="list-group-item">Disable Prey HUD: ${disable_hud ? '<span style="color: green;">Yes' : '<span style="color: red;">No'}</li>`;
  result += '</ul>';
  result += '</div></div></div>';

  // END VISUALS
  // INTERACTIONS

  result += '<div class="accordion-item">';
  result += `<h2 class="accordion-header" id="settingsAccordion${index}-headingThree">`;
  result += `<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#settingsAccordion${index}-collapseThree" aria-expanded="true" aria-controls="settingsAccordion${index}-collapseThree">`;
  result += '<b>== Interactions ==</b>';
  result += '</button></h2>';

  result += `<div id="settingsAccordion${index}-collapseThree" class="accordion-collapse collapse" aria-labelledby="settingsAccordion${index}-headingThree">`;
  result += '<div class="accordion-body">';
  result += `<b>Belly Interactions (${
    escapable === 1
      ? '<span style="color: green;">Enabled (Default)'
      : escapable === 2
        ? '<span style="color: green;">Enabled (Intent)'
        : '<span style="color: red;">Disabled'
  }</span>)</b>`;

  result += '<ul class="list-group">';

  const interactionItems = [
    { label: 'Escape Chance', value: escapechance, suffix: '%' },
    {
      label: 'Escape Chance (Absorbed)',
      value: escapechance_absorbed,
      suffix: '%',
    },
    { label: 'Escape Time', value: escapetime / 10, suffix: 's' },
    { label: 'Transfer Chance', value: transferchance, suffix: '%' },
    { label: 'Transfer Location', value: transferlocation },
    {
      label: 'Secondary Transfer Chance',
      value: transferchance_secondary,
      suffix: '%',
    },
    { label: 'Secondary Transfer Location', value: transferlocation_secondary },
    { label: 'Absorb Chance', value: absorbchance, suffix: '%' },
    { label: 'Digest Chance', value: digestchance, suffix: '%' },
    { label: 'Belch Chance', value: belchchance, suffix: '%' },
  ];

  result += formatListItems(interactionItems);

  result += '</ul>';
  result += '<hr>';
  result += `<b>Auto-Transfer Options (${
    autotransfer_enabled
      ? '<span style="color: green;">Enabled'
      : '<span style="color: red;">Disabled'
  }</span>)</b>`;
  result += '<ul class="list-group">';

  const transferItems = [
    { label: 'Auto-Transfer Time', value: autotransferwait / 10, suffix: 's' },
    { label: 'Auto-Transfer Chance', value: autotransferchance, suffix: '%' },
    { label: 'Auto-Transfer Location', value: autotransferlocation },
    {
      label: 'Auto-Transfer Chance (Secondary)',
      value: autotransferchance_secondary,
      suffix: '%',
    },
    {
      label: 'Auto-Transfer Location (Secondary)',
      value: autotransferlocation_secondary,
    },
    { label: 'Auto-Transfer Min Amount', value: autotransfer_min_amount },
    { label: 'Auto-Transfer Max Amount', value: autotransfer_max_amount },

    {
      label: 'Auto-Transfer Primary Chance',
      value: autotransferchance,
      suffix: '%',
    },
    { label: 'Auto-Transfer Primary Location', value: autotransferlocation },
    {
      label: 'Auto-Transfer Primary Location Extras',
      value: autotransferextralocation.join(', '),
    },

    {
      label: 'Auto-Transfer Primary Whitelist (Mobs)',
      value: GetAutotransferFlags(autotransfer_whitelist, true),
    },
    {
      label: 'Auto-Transfer Primary Whitelist (Items)',
      value: GetAutotransferFlags(autotransfer_whitelist_items, true),
    },
    {
      label: 'Auto-Transfer Primary Blacklist (Mobs)',
      value: GetAutotransferFlags(autotransfer_blacklist, false),
    },
    {
      label: 'Auto-Transfer Primary Blacklist (Items)',
      value: GetAutotransferFlags(autotransfer_blacklist_items, false),
    },

    {
      label: 'Auto-Transfer Secondary Chance',
      value: autotransferchance_secondary,
      suffix: '%',
    },
    {
      label: 'Auto-Transfer Secondary Location',
      value: autotransferlocation_secondary,
    },
    {
      label: 'Auto-Transfer Secondary Location Extras',
      value: autotransferextralocation_secondary.join(', '),
    },

    {
      label: 'Auto-Transfer Secondary Whitelist (Mobs)',
      value: GetAutotransferFlags(autotransfer_secondary_whitelist, true),
    },
    {
      label: 'Auto-Transfer Secondary Whitelist (Items)',
      value: GetAutotransferFlags(autotransfer_secondary_whitelist_items, true),
    },
    {
      label: 'Auto-Transfer Secondary Blacklist (Mobs)',
      value: GetAutotransferFlags(autotransfer_secondary_blacklist, false),
    },
    {
      label: 'Auto-Transfer Secondary Blacklist (Items)',
      value: GetAutotransferFlags(
        autotransfer_secondary_blacklist_items,
        false,
      ),
    },
  ];

  result += formatListItems(transferItems);

  result += '</ul>';
  result += '</div></div></div>';

  // END INTERACTIONS
  // LIQUID OPTIONS

  result += '<div class="accordion-item">';
  result += `<h2 class="accordion-header" id="settingsAccordion${index}-headingFour">`;
  result += `<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#settingsAccordion${index}-collapseFour" aria-expanded="true" aria-controls="settingsAccordion${index}-collapseFour">`;
  result += `<b>== Liquid Options (${
    show_liquids
      ? '<span style="color: green;">Liquids On'
      : '<span style="color: red;">Liquids Off'
  }</span>) ==</b>`;
  result += '</button></h2>';

  result += `<div id="settingsAccordion${index}-collapseFour" class="accordion-collapse collapse" aria-labelledby="settingsAccordion${index}-headingFour">`;
  result += '<div class="accordion-body">';
  result += '<ul class="list-group">';
  result += `<li class="list-group-item">Generate Liquids: ${
    reagentbellymode
      ? '<span style="color: green;">On'
      : '<span style="color: red;">Off'
  }</li>`;

  const liquidItems = [
    { label: 'Liquid Type', value: reagent_chosen },
    { label: 'Liquid Name', value: reagent_name },
    { label: 'Transfer Verb', value: reagent_transfer_verb },
    { label: 'Generation Time', value: gen_time_display },
    { label: 'Liquid Capacity', value: custom_max_volume },
    {
      label: 'Generation Limit (Nutrition / Charge) %',
      value: reagent_gen_cost_limit,
    },
  ];

  result += formatListItems(liquidItems);

  result += `<li class="list-group-item">Slosh Sounds: ${
    vorefootsteps_sounds
      ? '<span style="color: green;">On'
      : '<span style="color: red;">Off'
  }</li>`;
  result += `<li class="list-group-item">Liquid Addons: ${GetLiquidAddons(reagent_mode_flag_list)}</li>`;
  result += '</ul>';
  result += '</div></div></div>';

  // END LIQUID OPTIONS
  // LIQUID MESSAGES

  result += '<div class="accordion-item">';
  result += `<h2 class="accordion-header" id="settingsAccordion${index}-headingFive">`;
  result += `<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#settingsAccordion${index}-collapseFive" aria-expanded="true" aria-controls="settingsAccordion${index}-collapseFive">`;
  result += `<b>== Liquid Messages (${
    show_liquids
      ? '<span style="color: green;">Messages On'
      : '<span style="color: red;">Messages Off'
  }</span>) ==</b>`;
  result += '</button></h2>';

  result += `<div id="settingsAccordion${index}-collapseFive" class="accordion-collapse collapse" aria-labelledby="settingsAccordion${index}-headingFive">`;
  result += '<div class="accordion-body">';

  result += '<div role="liquidMessagesTabpanel">'; // Start Div liquidMessagesTabpanel
  result += '<div class="row"><div class="col-4">';
  result +=
    '<div class="list-group" id="liquidMessagesList" role="messagesTablist">';

  const fullnessItems = [
    ['examineMessage0_20', liquid_fullness1_messages, '0 to 20%'],
    ['examineMessage20_40', liquid_fullness2_messages, '20 to 40%'],
    ['examineMessage40_60', liquid_fullness3_messages, '40 to 60%'],
    ['examineMessage60_80', liquid_fullness4_messages, '60 to 80%'],
    ['examineMessage80_100', liquid_fullness5_messages, '80 to 100%'],
  ];

  fullnessItems.forEach(([idPrefix, messages, label], i) => {
    const activeClass = i === 0 ? 'active' : '';
    const isOn = messages
      ? '<span style="color: green;">On</span>'
      : '<span style="color: red;">Off</span>';
    result += `<a class="list-group-item list-group-item-action ${activeClass}" data-bs-toggle="list" href="#${idPrefix}${index}" role="tab">Examine Message (${label}) (${isOn})</a>`;
  });

  result += '</div></div>';

  result += '<div class="col-8">';
  result += '<div class="tab-content">';

  const fullnessMessages: [string, string[]][] = [
    ['examineMessage0_20', fullness1_messages],
    ['examineMessage20_40', fullness2_messages],
    ['examineMessage40_60', fullness3_messages],
    ['examineMessage60_80', fullness4_messages],
    ['examineMessage80_100', fullness5_messages],
  ];

  fullnessMessages.forEach(([idPrefix, messages], i) => {
    const classes = i === 0 ? 'tab-pane fade show active' : 'tab-pane fade';
    result += `<div class="${classes}" id="${idPrefix}${index}" role="liquidMessagesTabpanel">`;
    messages?.forEach((msg) => {
      result += `${msg}<br>`;
    });
    result += '</div>';
  });

  result += '</div>';
  result += '</div></div>';
  result += '</div>'; // End Div liquidMessagesTabpanel

  result += '</div></div></div>';

  // END LIQUID MESSAGES

  result += '</div></div></div>';

  return result;
};
