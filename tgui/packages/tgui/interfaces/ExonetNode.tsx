import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, LabeledList, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

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
    <Window width={400} height={400}>
      <Window.Content scrollable>
        <Section
          title="Status"
          buttons={
            <Button
              icon="power-off"
              selected={on}
              onClick={() => act('toggle_power')}
            >
              {'Power ' + (on ? 'On' : 'Off')}
            </Button>
          }
        >
          <LabeledList>
            <LabeledList.Item label="Incoming PDA Messages">
              <Button
                icon="power-off"
                selected={allowPDAs}
                onClick={() => act('toggle_PDA_port')}
              >
                {allowPDAs ? 'Open' : 'Closed'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Incoming Communicators">
              <Button
                icon="power-off"
                selected={allowCommunicators}
                onClick={() => act('toggle_communicator_port')}
              >
                {allowCommunicators ? 'Open' : 'Closed'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Incoming Newscaster Content">
              <Button
                icon="power-off"
                selected={allowNewscasters}
                onClick={() => act('toggle_newscaster_port')}
              >
                {allowNewscasters ? 'Open' : 'Closed'}
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Logging">
          <Stack wrap="wrap">
            {logs.map((log, i) => (
              <Stack.Item m="2px" key={i} basis="49%" grow={i % 2}>
                {log}
              </Stack.Item>
            ))}
            {!logs || logs.length === 0 ? (
              <Box color="average">No logs found.</Box>
            ) : null}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
