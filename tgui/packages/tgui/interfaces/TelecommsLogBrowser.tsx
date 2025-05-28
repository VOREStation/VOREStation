import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  universal_translate: BooleanLike;
  network: string;
  temp: { color: string; text: string } | null;
  servers: server[];
  selectedServer: selectedServer | null;
};

type server = { id: string; name: string };

type selectedServer = {
  id: string;
  totalTraffic: number;
  logs: log[] | [];
};

type log = {
  name: string;
  input_type: string;
  id: number;
  parameters: Record<string, string>;
};

export const TelecommsLogBrowser = (props) => {
  const { act, data } = useBackend<Data>();

  const { universal_translate, network, temp, servers, selectedServer } = data;

  return (
    <Window width={575} height={450}>
      <Window.Content scrollable>
        {(temp && temp.color === 'bad' && (
          <NoticeBox danger>
            <Box inline verticalAlign="middle">
              {temp.text}
            </Box>
            <Button
              icon="times-circle"
              style={{
                float: 'right',
              }}
              onClick={() => act('cleartemp')}
            />
            <Box
              style={{
                clear: 'both',
              }}
            />
          </NoticeBox>
        )) ||
          (temp && temp.color !== 'bad' && (
            <NoticeBox warning>
              <Box inline verticalAlign="middle">
                {temp.text}
              </Box>
              <Button
                icon="times-circle"
                style={{
                  float: 'right',
                }}
                onClick={() => act('cleartemp')}
              />
              <Box
                style={{
                  clear: 'both',
                }}
              />
            </NoticeBox>
          )) ||
          ''}
        <Section title="Network Control">
          <LabeledList>
            <LabeledList.Item
              label="Current Network"
              buttons={
                <Stack>
                  <Stack.Item>
                    <Button icon="search" onClick={() => act('scan')}>
                      Refresh
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      color="bad"
                      icon="exclamation-triangle"
                      disabled={servers.length === 0}
                      onClick={() => act('release')}
                    >
                      Flush Buffer
                    </Button>
                  </Stack.Item>
                </Stack>
              }
            >
              <Button icon="pen" onClick={() => act('network')}>
                {network}
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {selectedServer ? (
          <TelecommsSelectedServer
            network={network}
            server={selectedServer}
            universal_translate={universal_translate}
          />
        ) : (
          <TelecommsServerSelection network={network} servers={servers} />
        )}
      </Window.Content>
    </Window>
  );
};

const TelecommsServerSelection = (props: {
  network: string;
  servers: server[];
}) => {
  const { act } = useBackend();
  const { network, servers } = props;

  if (!servers || !servers.length) {
    return (
      <Section title="Detected Telecommunications Servers">
        <Box color="bad">No servers detected.</Box>
        <Button fluid icon="search" onClick={() => act('scan')}>
          Scan
        </Button>
      </Section>
    );
  }

  return (
    <Section title="Detected Telecommunications Servers">
      <LabeledList>
        {servers.map((server) => (
          <LabeledList.Item
            key={server.id}
            label={server.name + ' (' + server.id + ')'}
          >
            <Button icon="eye" onClick={() => act('view', { id: server.id })}>
              View
            </Button>
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

const TelecommsSelectedServer = (props: {
  network: string;
  server: selectedServer;
  universal_translate: BooleanLike;
}) => {
  const { act } = useBackend();
  const { network, server, universal_translate } = props;

  return (
    <Section
      title={'Server (' + server.id + ')'}
      buttons={
        <Button icon="undo" onClick={() => act('mainmenu')}>
          Return
        </Button>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Total Recorded Traffic">
          {server.totalTraffic >= 1024
            ? toFixed(server.totalTraffic / 1024) + ' Terrabytes'
            : server.totalTraffic + ' Gigabytes'}
        </LabeledList.Item>
      </LabeledList>
      <Section title="Stored Logs" mt="4px">
        <Stack wrap="wrap">
          {!server.logs || !server.logs.length
            ? 'No Logs Detected.'
            : server.logs.map((log) => (
                <Stack.Item m="2px" key={log.id} basis="49%" grow={log.id % 2}>
                  <Section
                    title={
                      universal_translate ||
                      log.parameters['uspeech'] ||
                      log.parameters['intelligible'] ||
                      log.input_type === 'Execution Error'
                        ? log.input_type
                        : 'Audio File'
                    }
                    buttons={
                      <Button.Confirm
                        confirmContent="Delete Log?"
                        color="bad"
                        icon="trash"
                        confirmIcon="trash"
                        onClick={() => act('delete', { id: log.id })}
                      />
                    }
                  >
                    {log.input_type === 'Execution Error' ? (
                      <LabeledList>
                        <LabeledList.Item label="Data type">
                          Error
                        </LabeledList.Item>
                        <LabeledList.Item label="Output">
                          {log.parameters['message']}
                        </LabeledList.Item>
                        <LabeledList.Item label="Delete">
                          <Button
                            icon="trash"
                            onClick={() => act('delete', { id: log.id })}
                          />
                        </LabeledList.Item>
                      </LabeledList>
                    ) : universal_translate ||
                      log.parameters['uspeech'] ||
                      log.parameters['intelligible'] ? (
                      <TelecommsLog log={log} />
                    ) : (
                      <TelecommsLog error />
                    )}
                  </Section>
                </Stack.Item>
              ))}
        </Stack>
      </Section>
    </Section>
  );
};

const TelecommsLog = (props: { log?: log; error?: BooleanLike }) => {
  const { log, error } = props;

  const { timecode, name, race, job, message } = (log && log.parameters) || {
    none: 'none',
  };

  if (error) {
    return (
      <LabeledList>
        <LabeledList.Item label="Time Recieved">{timecode}</LabeledList.Item>
        <LabeledList.Item label="Source">Unidentifiable</LabeledList.Item>
        <LabeledList.Item label="Class">{race}</LabeledList.Item>
        <LabeledList.Item label="Contents">Unintelligible</LabeledList.Item>
      </LabeledList>
    );
  }

  return (
    <LabeledList>
      <LabeledList.Item label="Time Recieved">{timecode}</LabeledList.Item>
      <LabeledList.Item label="Source">
        {name} (Job: {job})
      </LabeledList.Item>
      <LabeledList.Item label="Class">{race}</LabeledList.Item>
      <LabeledList.Item label="Contents" className="LabeledList__breakContents">
        {message}
      </LabeledList.Item>
    </LabeledList>
  );
};
