import { round } from 'common/math';
import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, Flex, NoticeBox, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const TelecommsLogBrowser = (props, context) => {
  const { act, data } = useBackend(context);

  const { universal_translate, network, temp, servers, selectedServer } = data;

  return (
    <Window width={575} height={450} resizable>
      <Window.Content scrollable>
        {temp ? (
          <NoticeBox danger={temp.color === 'bad'} warning={temp.color !== 'bad'}>
            <Box display="inline-box" verticalAlign="middle">
              {temp.text}
            </Box>
            <Button icon="times-circle" float="right" onClick={() => act('cleartemp')} />
            <Box clear="both" />
          </NoticeBox>
        ) : null}
        <Section title="Network Control">
          <LabeledList>
            <LabeledList.Item
              label="Current Network"
              buttons={
                <Fragment>
                  <Button icon="search" content="Refresh" onClick={() => act('scan')} />
                  <Button
                    color="bad"
                    icon="exclamation-triangle"
                    content="Flush Buffer"
                    disabled={servers.length === 0}
                    onClick={() => act('release')}
                  />
                </Fragment>
              }>
              <Button content={network} icon="pen" onClick={() => act('network')} />
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

const TelecommsServerSelection = (props, context) => {
  const { act, data } = useBackend(context);
  const { network, servers } = props;

  if (!servers || !servers.length) {
    return (
      <Section title="Detected Telecommunications Servers">
        <Box color="bad">No servers detected.</Box>
        <Button fluid content="Scan" icon="search" onClick={() => act('scan')} />
      </Section>
    );
  }

  return (
    <Section title="Detected Telecommunications Servers">
      <LabeledList>
        {servers.map((server) => (
          <LabeledList.Item key={server.id} label={server.name + ' (' + server.id + ')'}>
            <Button content="View" icon="eye" onClick={() => act('view', { id: server.id })} />
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

const TelecommsSelectedServer = (props, context) => {
  const { act, data } = useBackend(context);
  const { network, server, universal_translate } = props;

  return (
    <Section
      title={'Server (' + server.id + ')'}
      buttons={<Button content="Return" icon="undo" onClick={() => act('mainmenu')} />}>
      <LabeledList>
        <LabeledList.Item label="Total Recorded Traffic">
          {server.totalTraffic >= 1024
            ? round(server.totalTraffic / 1024) + ' Terrabytes'
            : server.totalTraffic + ' Gigabytes'}
        </LabeledList.Item>
      </LabeledList>
      <Section title="Stored Logs" mt="4px">
        <Flex wrap="wrap">
          {!server.logs || !server.logs.length
            ? 'No Logs Detected.'
            : server.logs.map((log) => (
              <Flex.Item m="2px" key={log.id} basis="49%" grow={log.id % 2}>
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
                  }>
                  {log.input_type === 'Execution Error' ? (
                    <LabeledList>
                      <LabeledList.Item label="Data type">Error</LabeledList.Item>
                      <LabeledList.Item label="Output">{log.parameters['message']}</LabeledList.Item>
                      <LabeledList.Item label="Delete">
                        <Button icon="trash" onClick={() => act('delete', { id: log.id })} />
                      </LabeledList.Item>
                    </LabeledList>
                  ) : universal_translate || log.parameters['uspeech'] || log.parameters['intelligible'] ? (
                    <TelecommsLog log={log} />
                  ) : (
                    <TelecommsLog error />
                  )}
                </Section>
              </Flex.Item>
            ))}
        </Flex>
      </Section>
    </Section>
  );
};

const TelecommsLog = (props, context) => {
  const { act, data } = useBackend(context);
  const { log, error } = props;

  const { timecode, name, race, job, message } = (log && log.parameters) || { 'none': 'none' };

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
