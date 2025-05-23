import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, LabeledList, Section, Table } from 'tgui-core/components';
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
  ports: {
    dir;
    input: BooleanLike;
    output: BooleanLike;
    concentration: number;
    con_lock: BooleanLike;
    f_type: string;
  }[];
  set_flow_rate: number;
  last_flow_rate: number;
};

export const OmniMixer = (props) => {
  const { act, data } = useBackend<Data>();

  const { power, config, ports, set_flow_rate, last_flow_rate } = data;

  return (
    <Window width={390} height={330}>
      <Window.Content>
        <Section
          title={config ? 'Configuration' : 'Status'}
          buttons={
            <>
              <Button
                icon="power-off"
                selected={power}
                disabled={config}
                onClick={() => act('power')}
              >
                {power ? 'On' : 'Off'}
              </Button>
              <Button
                icon="wrench"
                selected={config}
                onClick={() => act('configure')}
              />
            </>
          }
        >
          <Table>
            <Table.Row header>
              <Table.Cell textAlign="center">Port</Table.Cell>
              {config ? (
                <>
                  <Table.Cell textAlign="center">Input</Table.Cell>
                  <Table.Cell textAlign="center">Output</Table.Cell>
                </>
              ) : (
                <Table.Cell textAlign="center">Mode</Table.Cell>
              )}
              <Table.Cell textAlign="center">Concentration</Table.Cell>
              {config ? <Table.Cell textAlign="center">Lock</Table.Cell> : null}
            </Table.Row>
            {ports ? (
              ports.map((port) => (
                <PortRow key={port.dir} port={port} config={config} />
              ))
            ) : (
              <Box color="bad">No Ports Detected</Box>
            )}
          </Table>
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

const PortRow = (props) => {
  const { act } = useBackend();
  const { port, config } = props;

  return (
    <Table.Row>
      <Table.Cell textAlign="center">{port.dir + ' Port'}</Table.Cell>
      <Table.Cell textAlign="center">
        {config ? (
          <Button
            selected={port.input}
            disabled={port.output}
            icon="compress-arrows-alt"
            onClick={() =>
              act('switch_mode', {
                mode: port.input ? 'none' : 'in',
                dir: port.dir,
              })
            }
          >
            IN
          </Button>
        ) : (
          getStatusText(port)
        )}
      </Table.Cell>
      <Table.Cell textAlign="center">
        {config ? (
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
        ) : (
          port.concentration * 100 + '%'
        )}
      </Table.Cell>
      {config ? (
        <>
          <Table.Cell textAlign="center" width="20%">
            <Button
              width="100%"
              icon="wrench"
              disabled={!port.input}
              onClick={() =>
                act('switch_con', {
                  dir: port.dir,
                })
              }
            >
              {!port.input ? '-' : port.concentration * 100 + ' %'}
            </Button>
          </Table.Cell>
          <Table.Cell textAlign="center">
            <Button
              icon={port.con_lock ? 'lock' : 'lock-open'}
              disabled={!port.input}
              selected={port.con_lock}
              onClick={() =>
                act('switch_conlock', {
                  dir: port.dir,
                })
              }
            >
              {port.f_type || 'None'}
            </Button>
          </Table.Cell>
        </>
      ) : null}
    </Table.Row>
  );
};
