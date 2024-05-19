import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const CommunicationsConsole = (props) => {
  return (
    <Window width={400} height={600}>
      <Window.Content scrollable>
        <CommunicationsConsoleContent />
      </Window.Content>
    </Window>
  );
};

export const CommunicationsConsoleContent = (props) => {
  const { act, data } = useBackend();

  const { menu_state } = data;

  let mainTemplate = (
    <Box color="bad">
      ERRROR. Unknown menu_state: {menu_state}
      Please report this to NT Technical Support.
    </Box>
  );

  // 1 = main screen
  if (menu_state === 1) {
    mainTemplate = <CommunicationsConsoleMain />;
  } else if (menu_state === 2) {
    // 2 = status screen
    mainTemplate = <CommunicationsConsoleStatusDisplay />;
  } else if (menu_state === 3) {
    // 3 = messages screen
    mainTemplate = <CommunicationsConsoleMessage />;
  }

  return (
    <>
      <CommunicationsConsoleAuth />
      {mainTemplate}
    </>
  );
};

const CommunicationsConsoleMain = (props) => {
  const { act, data } = useBackend();

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

  let reportText = 'View (' + messages.length + ')';
  let announceText = 'Make Priority Announcement';
  if (msg_cooldown > 0) {
    announceText += ' (' + msg_cooldown + 's)';
  }
  let ccMessageText = emagged ? 'Message [UNKNOWN]' : 'Message ' + boss_short;
  if (cc_cooldown > 0) {
    ccMessageText += ' (' + cc_cooldown + 's)';
  }

  let alertLevelText = str_security_level;
  let alertLevelButtons = levels.map((slevel) => {
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

const CommunicationsConsoleAuth = (props) => {
  const { act, data } = useBackend();

  const { authenticated, is_ai, esc_status, esc_callable, esc_recallable } =
    data;

  let authReadable;
  if (!authenticated) {
    authReadable = 'Not Logged In';
  } else if (is_ai) {
    authReadable = 'AI';
  } else if (authenticated === 1) {
    authReadable = 'Command';
  } else if (authenticated === 2) {
    authReadable = 'Site Director';
  } else {
    authReadable = 'ERROR: Report This Bug!';
  }

  return (
    <>
      <Section title="Authentication">
        <LabeledList>
          {(is_ai && (
            <LabeledList.Item label="Access Level">AI</LabeledList.Item>
          )) || (
            <LabeledList.Item label="Actions">
              <Button
                icon={authenticated ? 'sign-out-alt' : 'id-card'}
                selected={authenticated}
                onClick={() => act('auth')}
              >
                {authenticated ? 'Log Out (' + authReadable + ')' : 'Log In'}
              </Button>
            </LabeledList.Item>
          )}
        </LabeledList>
      </Section>
      <Section title="Escape Shuttle">
        <LabeledList>
          {!!esc_status && (
            <LabeledList.Item label="Status">{esc_status}</LabeledList.Item>
          )}
          {!!esc_callable && (
            <LabeledList.Item label="Options">
              <Button
                icon="rocket"
                disabled={!authenticated}
                onClick={() => act('callshuttle')}
              >
                Call Shuttle
              </Button>
            </LabeledList.Item>
          )}
          {!!esc_recallable && (
            <LabeledList.Item label="Options">
              <Button
                icon="times"
                disabled={!authenticated || is_ai}
                onClick={() => act('cancelshuttle')}
              >
                Recall Shuttle
              </Button>
            </LabeledList.Item>
          )}
        </LabeledList>
      </Section>
    </>
  );
};

const CommunicationsConsoleMessage = (props) => {
  const { act, data } = useBackend();

  const { message_current, message_deletion_allowed, authenticated, messages } =
    data;

  if (message_current) {
    return (
      <Section
        title={message_current.title}
        buttons={
          <Button
            icon="times"
            disabled={!authenticated}
            onClick={() => act('messagelist')}
          >
            Return To Message List
          </Button>
        }
      >
        <Box>{message_current.contents}</Box>
      </Section>
    );
  }

  let messageRows = messages.map((m) => {
    return (
      <LabeledList.Item key={m.id} label={m.title}>
        <Button
          icon="eye"
          disabled={
            !authenticated ||
            (message_current && message_current.title === m.title)
          }
          onClick={() => act('messagelist', { msgid: m.id })}
        >
          View
        </Button>
        <Button
          icon="times"
          disabled={!authenticated || !message_deletion_allowed}
          onClick={() => act('delmessage', { msgid: m.id })}
        >
          Delete
        </Button>
      </LabeledList.Item>
    );
  });

  return (
    <Section
      title="Messages Received"
      buttons={
        <Button icon="arrow-circle-left" onClick={() => act('main')}>
          Back To Main Menu
        </Button>
      }
    >
      <LabeledList>
        {(messages.length && messageRows) || (
          <LabeledList.Item label="404" color="bad">
            No messages.
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};

const CommunicationsConsoleStatusDisplay = (props) => {
  const { act, data } = useBackend();

  const { stat_display, authenticated } = data;

  let presetButtons = stat_display['presets'].map((pb) => {
    return (
      <Button
        key={pb.name}
        selected={pb.name === stat_display.type}
        disabled={!authenticated}
        onClick={() => act('setstat', { statdisp: pb.name })}
      >
        {pb.label}
      </Button>
    );
  });
  return (
    <Section
      title="Modify Status Screens"
      buttons={
        <Button icon="arrow-circle-left" onClick={() => act('main')}>
          Back To Main Menu
        </Button>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Presets">{presetButtons}</LabeledList.Item>
        <LabeledList.Item label="Message Line 1">
          <Button
            icon="pencil-alt"
            disabled={!authenticated}
            onClick={() => act('setmsg1')}
          >
            {stat_display.line_1}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Message Line 2">
          <Button
            icon="pencil-alt"
            disabled={!authenticated}
            onClick={() => act('setmsg2')}
          >
            {stat_display.line_2}
          </Button>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
