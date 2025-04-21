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

type Data = {
  network: string;
  temp: { color: string; text: string } | null;
  machinelist: machine[] | [];
  selectedMachine: Required<
    machine & {
      links: machine[] | undefined;
    }
  > | null;
};

type machine = { id: string; name: string };

export const TelecommsMachineBrowser = (props) => {
  const { act, data } = useBackend<Data>();

  const { network, temp, machinelist, selectedMachine } = data;

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
                      Probe Network
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      color="bad"
                      icon="exclamation-triangle"
                      disabled={machinelist.length === 0}
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
        {machinelist && machinelist.length ? (
          <TelecommsBrowser
            title={
              selectedMachine
                ? selectedMachine.name + ' (' + selectedMachine.id + ')'
                : 'Detected Network Entities'
            }
            list={selectedMachine ? selectedMachine.links : machinelist}
            showBack={selectedMachine}
          />
        ) : (
          <Section title="No Devices Found">
            <Button icon="search" onClick={() => act('scan')}>
              Probe Network
            </Button>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};

const TelecommsBrowser = (props) => {
  const { act, data } = useBackend();

  const { list, title, showBack } = props;

  return (
    <Section
      title={title}
      buttons={
        showBack && (
          <Button icon="undo" onClick={() => act('mainmenu')}>
            Back to Main Menu
          </Button>
        )
      }
    >
      <Box color="label">
        <u>Linked entities</u>
      </Box>
      <LabeledList>
        {list.length ? (
          list.map((machine) => (
            <LabeledList.Item
              key={machine.id}
              label={machine.name + ' (' + machine.id + ')'}
            >
              <Button
                icon="eye"
                onClick={() => act('view', { id: machine.id })}
              >
                View
              </Button>
            </LabeledList.Item>
          ))
        ) : (
          <LabeledList.Item color="bad">No links detected.</LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};
