import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Button, Divider, Section } from '../components';

type Data = { bellies: Belly[] };

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

  emote_list: string[];
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
  } = belly;

  let result = '<details>';
  result += '<summary>=== ' + name + ' ===</summary><br>';
  result += '<b>== Controls ==</b><br>';
  result += 'Mode:<br>' + mode + '<br><br>';
  result += 'Addons:<br>' + addons + '<br><br>';
  result += 'Item Mode:<br>' + item_mode + '<br><br>';
  result += '<p><b>== Descriptions ==</b><br>';
  result += 'Verb:<br>' + vore_verb + '<br><br>';
  result += 'Description:<br>"' + desc + '"<br><br>';
  result += 'Absorbed Description:<br>"' + absorbed_desc + '"<br><br>';
  result += '<b>== Options ==</b><br>';
  result += '[WIP]<br><br>';
  result += '<b>== Sounds ==</b><br>';
  result += '[WIP]<br><br>';
  result += '<b>== Interactions ==</b><br>';
  result += '[WIP]<br><br>';
  result += '<b>== Messages ==</b><br>';

  result += 'Struggle Messages (Outside):<br>';
  struggle_messages_outside?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '<br><br>';

  result += 'Struggle Messages (Inside):<br>';
  struggle_messages_inside?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '<br><br>';

  result += 'Absorbed Struggle Messages (Outside):<br>';
  absorbed_struggle_messages_outside?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '<br><br>';

  result += 'Absorbed Struggle Messages (Inside):<br>';
  absorbed_struggle_messages_inside?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '<br><br>';

  result += 'Digest Messages (Owner):<br>';
  digest_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '<br><br>';

  result += 'Digest Messages (Prey):<br>';
  digest_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '<br><br>';

  result += 'Absorb Messages (Owner):<br>';
  absorb_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '<br><br>';

  result += 'Absorb Messages (Prey):<br>';
  absorb_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '<br><br>';

  result += 'Unabsorb Messages (Owner):<br>';
  unabsorb_messages_owner?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '<br><br>';

  result += 'Unabsorb Messages (Prey):<br>';
  unabsorb_messages_prey?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '<br><br>';

  result += 'Examine Messages:<br>';
  examine_messages?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '<br><br>';

  result += 'Examine Messages (Absorbed):<br>';
  examine_messages_absorbed?.forEach((msg) => {
    result += msg + '<br>';
  });
  result += '</p></details>';

  return result;
};

const downloadPrefs = (context, extension: string) => {
  const { act, data } = useBackend<Data>(context);

  const { bellies } = data;

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

  let filename = 'belly_export' + datesegment + extension;
  let blob;

  if (extension === '.html') {
    let style =
      '<style>' +
      'details > summary { ' +
      ' padding: 4px;' +
      ' width: 200px;' +
      ' background-color: #eeeeee;' +
      ' border: none;' +
      ' box-shadow: 1px 1px 2px #bbbbbb;' +
      ' cursor: pointer;' +
      '}' +
      'details > p {' +
      ' background-color: #eeeeee;' +
      ' padding: 4px;' +
      ' margin: 0;' +
      ' box-shadow: 1px 1px 2px #bbbbbb;' +
      '}' +
      '</style>';

    blob = new Blob(
      [
        '<!DOCTYPE html><html lang="en"><head><title>' +
          bellies.length +
          ' Exported Bellies</title>' +
          style +
          '</head><body>',
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
    <Section title="Belly Data Export">
      <Section title="Export">
        <Button fluid icon="file-alt" onClick={() => downloadPrefs(context, '.html')}>
          Export (HTML)
        </Button>
        <Button fluid icon="file" onClick={() => downloadPrefs(context, '.vsbd')}>
          Export (VSBD) [WIP]
        </Button>
        <Divider />
        <Button fluid icon="file" onClick={() => importPrefs(context, '.vsbd')}>
          Import (VSBD) [WIP]
        </Button>
      </Section>
      <Section title="Bellies">
        {bellies.map((belly) => (
          <p>Name: {belly.name}</p>
        ))}
      </Section>
    </Section>
  );
};
