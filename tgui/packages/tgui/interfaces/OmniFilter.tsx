import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, LabeledList, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

const getStatusText = (port) => {
  if (port.input) {
    return 'Input';
  }
  if (port.output) {
    return 'Output';
  }
  if (port.f_type) {
    return port.f_type;
  }
  return 'Disabled';
};

type Data = {
  power: BooleanLike;
  config: BooleanLike;
  ports: { dir; input: BooleanLike; output: BooleanLike; f_type: string }[];
  set_flow_rate: number;
  last_flow_rate: number;
};

export const OmniFilter = (props) => {
  const { act, data } = useBackend<Data>();

  const { power, config, ports, set_flow_rate, last_flow_rate } = data;

  return (
    <Window width={360} height={330}>
      <Window.Content>
        <Section
          title={config ? 'Configuration' : 'Status'}
          buttons={
            <Stack>
              <Stack.Item>
                <Button
                  icon="power-off"
                  selected={power}
                  disabled={config}
                  onClick={() => act('power')}
                >
                  {power ? 'On' : 'Off'}
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="wrench"
                  selected={config}
                  onClick={() => act('configure')}
                />
              </Stack.Item>
            </Stack>
          }
        >
          <LabeledList>
            {ports ? (
              ports.map((port) => (
                <LabeledList.Item key={port.dir} label={port.dir + ' Port'}>
                  {config ? (
                    <>
                      <Button
                        selected={port.input}
                        icon="compress-arrows-alt"
                        onClick={() =>
                          act('switch_mode', {
                            mode: 'in',
                            dir: port.dir,
                          })
                        }
                      >
                        IN
                      </Button>
                      <Button
                        selected={port.output}
                        icon="expand-arrows-alt"
                        onClick={() =>
                          act('switch_mode', {
                            mode: 'out',
                            dir: port.dir,
                          })
                        }
                      >
                        OUT
                      </Button>
                      <Button
                        icon="wrench"
                        disabled={port.input || port.output}
                        onClick={() =>
                          act('switch_filter', {
                            mode: port.f_type,
                            dir: port.dir,
                          })
                        }
                      >
                        {port.f_type || 'None'}
                      </Button>
                    </>
                  ) : (
                    getStatusText(port)
                  )}
                </LabeledList.Item>
              ))
            ) : (
              <Box color="bad">No Ports Detected</Box>
            )}
          </LabeledList>
        </Section>
        <Section title="Flow Rate">
          <LabeledList>
            <LabeledList.Item label="Current Flow Rate">
              {last_flow_rate} L/s
            </LabeledList.Item>
            <LabeledList.Item label="Flow Rate Limit">
              {config ? (
                <Button icon="wrench" onClick={() => act('set_flow_rate')}>
                  {set_flow_rate + ' L/s'}
                </Button>
              ) : (
                set_flow_rate + ' L/s'
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
