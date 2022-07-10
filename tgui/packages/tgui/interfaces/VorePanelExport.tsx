import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Button, Divider, Section } from '../components';
import { BooleanLike } from 'common/react';

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

  // Controls
  mode: string;
  addons: string[];
  item_mode: string;

  // Options
  digest_brute: number;
  digest_burn: number;
  digest_oxy: number;

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

  emote_list: any[];

  // Sounds
  is_wet: BooleanLike;
  wet_loop: BooleanLike;
  fancy_vore: BooleanLike;
  vore_sound: string;
  release_sound: string;

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

const generateBellyString = (belly: Belly) => {
  const {
    // General Information
    name,
    desc,
    absorbed_desc,
    vore_verb,

    // Controls
    mode,
    addons,
    item_mode,

    // Options
    digest_brute,
    digest_burn,
    digest_oxy,

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

    emote_list,

    // Sounds
    is_wet,
    wet_loop,
    fancy_vore,
    vore_sound,
    release_sound,

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

  let result = '<details>';
  result +=
    '<summary>=== ' +
    name +
    ' - (<span style="color: red;">' +
    digest_brute +
    '</span >/<span style="color: orange;">' +
    digest_burn +
    '</span>/<span style="color: blue;">' +
    digest_oxy +
    '</span>) ===</summary>';
  result += '<p><b>== Controls ==</b><br>';
  result += 'Mode:<br>' + mode + '<br><br>';
  result += 'Addons:<br>' + addons + '<br><br>';
  result += 'Item Mode:<br>' + item_mode + '<br><br>';
  result += '<b>== Descriptions ==</b><br>';
  result += 'Verb:<br>' + vore_verb + '<br><br>';
  result += 'Description:<br>"' + desc + '"<br><br>';
  result += 'Absorbed Description:<br>"' + absorbed_desc + '"<br><br>';
  result += '<b>== Messages ==</b><br>';

  result += '<details><summary>Struggle Messages (Outside):</summary><p>';
  struggle_messages_outside?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p>';

  result += '<details><summary>Struggle Messages (Inside):</summary><p>';
  struggle_messages_inside?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p>';

  result += '<details><summary>Absorbed Struggle Messages (Outside):</summary><p>';
  absorbed_struggle_messages_outside?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p>';

  result += '<details><summary>Absorbed Struggle Messages (Inside):</summary><p>';
  absorbed_struggle_messages_inside?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p>';

  result += '<details><summary>Digest Messages (Owner):</summary><p>';
  digest_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p>';

  result += '<details><summary>Digest Messages (Prey):</summary><p>';
  digest_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p>';

  result += '<details><summary>Absorb Messages (Owner):</summary><p>';
  absorb_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p>';

  result += '<details><summary>Absorb Messages (Prey):</summary><p>';
  absorb_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p>';

  result += '<details><summary>Unabsorb Messages (Owner):</summary><p>';
  unabsorb_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p>';

  result += '<details><summary>Unabsorb Messages (Prey):</summary><p>';
  unabsorb_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p>';

  result += '<details><summary>Examine Messages:</summary><p>';
  examine_messages?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</details></p>';

  result += '<details><summary>Examine Messages (Absorbed):</summary><p>';
  examine_messages_absorbed?.forEach((msg) => {
    result += msg + '<br>';
  });

  emote_list?.forEach(([EL, emote]) => {
    result += '<details><summary>Idle Messages (' + EL + '):</summary><p>';
    result += emote + '<br>';
  });

  result += '</details></p><br>';
  result += '<b>== Options ==</b><br>';
  result +=
    'Can Taste:<br>' +
    (can_taste ? '<span style="color: green;">Yes' : '<span style="color: red;">No') +
    '</span><br><br>';
  result +=
    'Contaminates:<br>' +
    (contaminates ? '<span style="color: green;">Yes' : '<span style="color: red;">No') +
    '</span><br><br>';
  result += 'Contamination Flavor:<br>' + contamination_flavor + '<br><br>';
  result += 'Contamination Color:<br>' + contamination_color + '<br><br>';
  result += 'Nutritional Gain:<br>' + nutrition_percent + '%<br><br>';
  result += 'Required Examine Size:<br>' + bulge_size * 100 + '%<br><br>';
  result +=
    'Display Absorbed Examines:<br>' +
    (display_absorbed_examine ? '<span style="color: green;">True' : '<span style="color: red;">False') +
    '</span><br><br>';
  result +=
    'Save Digest Mode:<br>' +
    (save_digest_mode ? '<span style="color: green;">True' : '<span style="color: red;">False') +
    '</span><br><br>';
  result +=
    'Idle Emotes:<br>' +
    (emote_active ? '<span style="color: green;">Active' : '<span style="color: red;">Inactive') +
    '</span><br><br>';
  result += 'Idle Emote Delay:<br>' + emote_time + ' seconds<br><br>';
  result += 'Shrink/Grow Size:<br>' + shrink_grow_size * 100 + '%<br><br>';
  result += 'Egg Type:<br>' + egg_type + '<br><br>';
  result += '<b>== Sounds ==</b><br>';
  result +=
    'Fleshy Belly:<br>' +
    (is_wet ? '<span style="color: green;">Enabled' : '<span style="color: red;">Disabled') +
    '</span><br><br>';
  result +=
    'Internal Loop:<br>' +
    (wet_loop ? '<span style="color: green;">Enabled' : '<span style="color: red;">Disabled') +
    '</span><br><br>';
  result +=
    'Use Fancy Sounds:<br>' +
    (fancy_vore ? '<span style="color: green;">Enabled' : '<span style="color: red;">Disabled') +
    '</span><br><br>';
  result += 'Vore Sound:<br>' + vore_sound + '<br><br>';
  result += 'Release Sound:<br>' + release_sound + '<br><br>';
  result +=
    '<b>== Interactions (' +
    (escapable ? '<span style="color: green;">Enabled' : '<span style="color: red;">Disabled') +
    '</span>) ==</b><br>';
  result += 'Escape Chance:<br>' + escapechance + '%<br><br>';
  result += 'Escape Time:<br>' + escapetime / 10 + 's<br><br>';
  result += 'Transfer Chance:<br>' + transferchance + '%<br><br>';
  result += 'Transfer Location:<br>' + transferlocation + '<br><br>';
  result += 'Secondary Transfer Chance:<br>' + transferchance_secondary + '%<br><br>';
  result += 'Secondary Transfer Location:<br>' + transferlocation_secondary + '<br><br>';
  result += 'Absorb Chance:<br>' + absorbchance + '%<br><br>';
  result += 'Digest Chance:<br>' + digestchance + '%<br><br>';
  result += '</p></details>';
  result += '<hr>';

  return result;
};

const downloadPrefs = (context, extension: string) => {
  const { act, data } = useBackend<Data>(context);

  const { db_version, db_repo, mob_name, bellies } = data;

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

  let datesegment = ' ' + year + '-' + month + '-' + dayofmonth + ' (' + hours + ' ' + minutes + ')';

  let filename = mob_name + datesegment + extension;
  let blob;

  if (extension === '.html') {
    let style = '<style>' + '</style>';

    blob = new Blob(
      [
        '<!DOCTYPE html><html lang="en"><head><title>' +
          bellies.length +
          ' Exported Bellies (DB_VER: ) ' +
          db_repo +
          '-' +
          db_version +
          '</title>' +
          style +
          '</head><body><h2>Bellies of ' +
          mob_name +
          '</h2>',
      ],
      {
        type: 'text/html;charset=utf8',
      }
    );
    bellies.forEach((belly) => {
      blob = new Blob([blob, generateBellyString(belly)], { type: 'text/html;charset=utf8' });
    });
    blob = new Blob([blob, '</body></html>'], { type: 'text/html;charset=utf8' });
  } else if (extension === '.vsbd') {
    blob = new Blob([JSON.stringify(bellies)], { type: 'application/json;charset=utf8' });
  }

  (window.navigator as any).msSaveOrOpenBlob(blob, filename);
};

const importPrefs = (context, extension: string) => {
  const { act, data } = useBackend<Data>(context);

  let string = '';

  let belly: Belly = JSON.parse(string);

  act('import', belly);
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
      <Section title="Export/Import">
        <Button fluid icon="file-alt" onClick={() => downloadPrefs(context, '.html')}>
          Export (HTML)
        </Button>
        <Button disabled fluid icon="file" onClick={() => downloadPrefs(context, '.vrdb')}>
          Export (VRDB) [WIP]
        </Button>
        <Divider />
        <Button disabled fluid icon="file" onClick={() => importPrefs(context, '.vrdb')}>
          Import (VRDB) [WIP]
        </Button>
      </Section>
    </Section>
  );
};
