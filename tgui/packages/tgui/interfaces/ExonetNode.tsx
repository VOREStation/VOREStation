import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Button, Box, Flex, LabeledList, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  on: BooleanLike;
  allowPDAs: BooleanLike;
  allowCommunicators: BooleanLike;
  allowNewscasters: BooleanLike;
  logs: string[];
};

export const ExonetNode = (props) => {
  const { act, data } = useBackend<Data>();

  const { on, allowPDAs, allowCommunicators, allowNewscasters, logs } = data;

  return (
    <Window width={400} height={400} resizable>
      <Window.Content scrollable>
        <Section
          title="Status"
          buttons={
            <Button
              icon="power-off"
              selected={on}
              content={'Power ' + (on ? 'On' : 'Off')}
              onClick={() => act('toggle_power')}
            />
          }>
          <LabeledList>
            <LabeledList.Item label="Incoming PDA Messages">
              <Button
                icon="power-off"
                selected={allowPDAs}
                content={allowPDAs ? 'Open' : 'Closed'}
                onClick={() => act('toggle_PDA_port')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Incoming Communicators">
              <Button
                icon="power-off"
                selected={allowCommunicators}
                content={allowCommunicators ? 'Open' : 'Closed'}
                onClick={() => act('toggle_communicator_port')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Incoming Newscaster Content">
              <Button
                icon="power-off"
                selected={allowNewscasters}
                content={allowNewscasters ? 'Open' : 'Closed'}
                onClick={() => act('toggle_newscaster_port')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Logging">
          <Flex wrap="wrap">
            {logs.map((log, i) => (
              <Flex.Item m="2px" key={i} basis="49%" grow={i % 2}>
                {log}
              </Flex.Item>
            ))}
            {!logs || logs.length === 0 ? (
              <Box color="average">No logs found.</Box>
            ) : null}
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
