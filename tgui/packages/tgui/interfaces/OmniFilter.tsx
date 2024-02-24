import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

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
            <>
              <Button
                icon="power-off"
                content={power ? 'On' : 'Off'}
                selected={power}
                disabled={config}
                onClick={() => act('power')}
              />
              <Button
                icon="wrench"
                selected={config}
                onClick={() => act('configure')}
              />
            </>
          }
        >
          <LabeledList>
            {ports ? (
              ports.map((port) => (
                <LabeledList.Item key={port.dir} label={port.dir + ' Port'}>
                  {config ? (
                    <>
                      <Button
                        content="IN"
                        selected={port.input}
                        icon="compress-arrows-alt"
                        onClick={() =>
                          act('switch_mode', {
                            mode: 'in',
                            dir: port.dir,
                          })
                        }
                      />
                      <Button
                        content="OUT"
                        selected={port.output}
                        icon="expand-arrows-alt"
                        onClick={() =>
                          act('switch_mode', {
                            mode: 'out',
                            dir: port.dir,
                          })
                        }
                      />
                      <Button
                        icon="wrench"
                        disabled={port.input || port.output}
                        content={port.f_type || 'None'}
                        onClick={() =>
                          act('switch_filter', {
                            mode: port.f_type,
                            dir: port.dir,
                          })
                        }
                      />
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
                <Button
                  icon="wrench"
                  content={set_flow_rate / 10 + ' L/s'}
                  onClick={() => act('set_flow_rate')}
                />
              ) : (
                set_flow_rate / 10 + ' L/s'
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
