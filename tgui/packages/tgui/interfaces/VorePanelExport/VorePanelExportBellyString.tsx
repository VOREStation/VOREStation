import { ItemModeSpan, ModeSpan } from './constants';
import type { Belly } from './types';
import { GetAddons } from './VorePanelExportBellyStringHelpers';

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
    egg_type,
    selective_preference,

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
  result += '</ul>';
  result += '</div></div></div>';

  // END INTERACTIONS

  result += '</div></div></div>';

  return result;
};
