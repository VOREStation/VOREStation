import { useBackend } from '../../backend';
import { Button, LabeledList, Section } from '../../components';
import { Data } from './types';

export const CommunicationsConsoleMain = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    messages,
    msg_cooldown,
    emagged,
    cc_cooldown,
    str_security_level,
    levels,
    authmax,
    security_level,
    security_level_color,
    authenticated,
    atcsquelch,
    boss_short,
  } = data;

  const reportText = 'View (' + messages.length + ')';
  let announceText = 'Make Priority Announcement';
  if (msg_cooldown > 0) {
    announceText += ' (' + msg_cooldown + 's)';
  }
  let ccMessageText = emagged ? 'Message [UNKNOWN]' : 'Message ' + boss_short;
  if (cc_cooldown > 0) {
    ccMessageText += ' (' + cc_cooldown + 's)';
  }

  const alertLevelText = str_security_level;
  const alertLevelButtons = levels.map((slevel) => {
    return (
      <Button
        key={slevel.name}
        icon={slevel.icon}
        disabled={!authenticated}
        selected={slevel.id === security_level}
        onClick={() => act('newalertlevel', { level: slevel.id })}
      >
        {slevel.name}
      </Button>
    );
  });

  return (
    <>
      <Section title="Site Manager-Only Actions">
        <LabeledList>
          <LabeledList.Item label="Announcement">
            <Button
              icon="bullhorn"
              disabled={!authmax || msg_cooldown > 0}
              onClick={() => act('announce')}
            >
              {announceText}
            </Button>
          </LabeledList.Item>
          {(!!emagged && (
            <LabeledList.Item label="Transmit">
              <Button
                icon="broadcast-tower"
                color="red"
                disabled={!authmax || cc_cooldown > 0}
                onClick={() => act('MessageSyndicate')}
              >
                {ccMessageText}
              </Button>
              <Button
                icon="sync-alt"
                disabled={!authmax}
                onClick={() => act('RestoreBackup')}
              >
                Reset Relays
              </Button>
            </LabeledList.Item>
          )) || (
            <LabeledList.Item label="Transmit">
              <Button
                icon="broadcast-tower"
                disabled={!authmax || cc_cooldown > 0}
                onClick={() => act('MessageCentCom')}
              >
                {ccMessageText}
              </Button>
            </LabeledList.Item>
          )}
        </LabeledList>
      </Section>
      <Section title="Command Staff Actions">
        <LabeledList>
          <LabeledList.Item label="Current Alert" color={security_level_color}>
            {alertLevelText}
          </LabeledList.Item>
          <LabeledList.Item label="Change Alert">
            {alertLevelButtons}
          </LabeledList.Item>
          <LabeledList.Item label="Displays">
            <Button
              icon="tv"
              disabled={!authenticated}
              onClick={() => act('status')}
            >
              Change Status Displays
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Incoming Messages">
            <Button
              icon="folder-open"
              disabled={!authenticated}
              onClick={() => act('messagelist')}
            >
              {reportText}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Misc">
            <Button
              icon="microphone"
              disabled={!authenticated}
              selected={atcsquelch}
              onClick={() => act('toggleatc')}
            >
              {!atcsquelch ? 'ATC Relay Enabled' : 'ATC Relay Disabled'}
            </Button>
          </LabeledList.Item>
        </LabeledList>
      </Section>
    </>
  );
};
