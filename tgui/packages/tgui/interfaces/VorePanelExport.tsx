import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Button, Section } from '../components';
import { BooleanLike } from 'common/react';

const ModeSpan = {
  'Hold': '<span class="badge text-bg-secondary">Hold</span>',
  'Digest': '<span class="badge text-bg-danger">Digest</span>',
  'Absorb': '<span class="badge text-bg-light">Absorb</span>',
  'Drain': '<span class="badge text-bg-warning">Drain</span>',
  'Selective': '<span class="badge text-bg-warning">Selective</span>',
  'Unabsorb': '<span class="badge text-bg-light">Unabsorb</span>',
  'Heal': '<span class="badge text-bg-success">Heal</span>',
  'Shrink': '<span class="badge text-bg-info">Shrink</span>',
  'Grow': '<span class="badge text-bg-info">Grow</span>',
  'Size Steal': '<span class="badge text-bg-info">Size Steal</span>',
  'Encase In Egg': '<span class="badge text-bg-primary">Encase In Egg</span>',
};

const ItemModeSpan = {
  'Hold': '<span class="badge text-bg-secondary">Item: Hold</span>',
  'Digest (Food Only)': '<span class="badge text-bg-danger">Item: Digest (Food Only)</span>',
  'Digest': '<span class="badge text-bg-danger">Item: Digest</span>',
};

const AddonIcon = {
  'Numbing': '',
  'Stripping': '',
  'Leave Remains': '',
  'Muffles': 'bi-volume-mute',
  'Affect Worn Items': '',
  'Jams Sensors': 'bi-wifi-off',
  'Complete Absorb': '',
};

const GetAddons = (addons: string[]) => {
  let result: string[] = [];

  addons?.forEach((addon) => {
    result.push('<span class="badge text-bg-secondary"><i class="' + AddonIcon[addon] + '"></i>' + addon + '</span>');
  });

  if (result.length === 0) {
    result.push('No Addons Set');
  }

  return result;
};

type Data = {
  db_version: string;
  db_repo: string;
  mob_name: string;
  bellies: Belly[];
};

type Belly = {
  // General Information
  name: string;
  desc: string;
  absorbed_desc: string;
  vore_verb: string;
  release_verb: string;

  // Controls
  mode: string;
  addons: string[];
  item_mode: string;

  // Options
  digest_brute: number;
  digest_burn: number;
  digest_oxy: number;
  digest_tox: number;
  digest_clone: number;

  can_taste: BooleanLike;
  contaminates: BooleanLike;
  contamination_flavor: string;
  contamination_color: string;
  nutrition_percent: number;
  bulge_size: number;
  display_absorbed_examine: BooleanLike;
  save_digest_mode: BooleanLike;
  emote_active: BooleanLike;
  emote_time: number;
  shrink_grow_size: number;
  egg_type: string;
  selective_preference: string;

  // Messages
  struggle_messages_outside: string[];
  struggle_messages_inside: string[];
  absorbed_struggle_messages_outside: string[];
  absorbed_struggle_messages_inside: string[];
  digest_messages_owner: string[];
  digest_messages_prey: string[];
  absorb_messages_owner: string[];
  absorb_messages_prey: string[];
  unabsorb_messages_owner: string[];
  unabsorb_messages_prey: string[];
  examine_messages: string[];
  examine_messages_absorbed: string[];

  // emote_list: any[];
  emotes_digest;
  emotes_hold;
  emotes_holdabsorbed;
  emotes_absorb;
  emotes_heal;
  emotes_drain;
  emotes_steal;
  emotes_egg;
  emotes_shrink;
  emotes_grow;
  emotes_unabsorb;

  // Sounds
  is_wet: BooleanLike;
  wet_loop: BooleanLike;
  fancy_vore: BooleanLike;
  vore_sound: string;
  release_sound: string;

  // Visuals (Vore FX)
  disable_hud: BooleanLike;

  // Interactions
  escapable: BooleanLike;

  escapechance: number;
  escapetime: number;

  transferchance: number;
  transferlocation: string;

  transferchance_secondary: number;
  transferlocation_secondary: string;

  absorbchance: number;
  digestchance: number;
};

// prettier-ignore
const generateBellyString = (belly: Belly, index: number) => {
  const {
    // General Information
    name,
    desc,
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
  result += '<div role="messagesTabpanel">'; // Start Div messagesTabpanel
  result += '<div class="row"><div class="col-4">';
  result += '<div class="list-group" id="messagesList" role="messagesTablist">';
  result += '<a class="list-group-item list-group-item-action active" data-bs-toggle="list" href="#struggleMessagesOutside' + index + '" role="tab">Struggle Messages (Outside)</a>';
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

  result += '<div class="tab-pane fade show active" id="struggleMessagesOutside' + index + '" role="messagesTabpanel">';
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

const getCurrentTimestamp = (): string => {
  let now = new Date();
  let hours = String(now.getHours());
  if (hours.length < 2) {
    hours = '0' + hours;
  }
  let minutes = String(now.getMinutes());
  if (minutes.length < 2) {
    minutes = '0' + minutes;
  }
  let dayofmonth = String(now.getDate());
  if (dayofmonth.length < 2) {
    dayofmonth = '0' + dayofmonth;
  }
  let month = String(now.getMonth() + 1); // 0-11
  if (month.length < 2) {
    month = '0' + month;
  }
  let year = String(now.getFullYear());

  return ' ' + year + '-' + month + '-' + dayofmonth + ' (' + hours + ' ' + minutes + ')';
};

const downloadPrefs = (context, extension: string) => {
  const { act, data } = useBackend<Data>(context);

  const { db_version, db_repo, mob_name, bellies } = data;

  let datesegment = getCurrentTimestamp();

  let filename = mob_name + datesegment + extension;
  let blob;

  if (extension === '.html') {
    let style = '<style>' + '</style>';

    blob = new Blob(
      [
        '<!DOCTYPE html><html lang="en"><head>' +
          '<meta charset="utf-8">' +
          '<meta name="viewport" content="width=device-width, initial-scale=1">' +
          '<title>' +
          bellies.length +
          ' Exported Bellies (DB_VER: ' +
          db_repo +
          '-' +
          db_version +
          ')</title>' +
          '<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-gH2yIJqKdNHPEq0n4Mqa/HGKIhSkIHeL5AyhkYV8i59U5AR6csBvApHHNl/vI1Bx" crossorigin="anonymous">' +
          '<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css">' +
          style +
          '</head><body class="py-4"><main><div class="container"><h2>Bellies of ' +
          mob_name +
          '</h2><p class="lead">Generated on: ' +
          datesegment +
          '</p><div class="accordion" id="accordionBellies">',
      ],
      {
        type: 'text/html;charset=utf8',
      }
    );
    bellies.forEach((belly, i) => {
      blob = new Blob([blob, generateBellyString(belly, i)], { type: 'text/html;charset=utf8' });
    });
    blob = new Blob(
      [
        blob,
        '</div>',
        '<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-A3rJD856KowSb7dwlZdYEkO39Gagi7vIsF0jrRAoQmDKKtQBHUuLZ9AsSv4jD4Xa" crossorigin="anonymous"></script>',
        '</div></main></body></html>',
      ],
      { type: 'text/html;charset=utf8' }
    );
  }

  if (extension === '.vrdb') {
    blob = new Blob([JSON.stringify(bellies)], { type: 'application/json' });
  }

  (window.navigator as any).msSaveOrOpenBlob(blob, filename);
};

export const VorePanelExport = () => {
  return (
    <Window width={790} height={560} theme="abstract" resizeable>
      <Window.Content>
        <VorePanelExportContent />
      </Window.Content>
    </Window>
  );
};

const VorePanelExportContent = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  const { bellies } = data;

  return (
    <Section title="Vore Export Panel">
      <Section title="Export">
        <Button fluid icon="file-alt" onClick={() => downloadPrefs(context, '.html')}>
          Export (HTML)
        </Button>
        <Button fluid icon="file-alt" onClick={() => downloadPrefs(context, '.vrdb')}>
          Export (VRDB)
        </Button>
      </Section>
    </Section>
  );
};
