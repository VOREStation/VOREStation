import { BooleanLike } from 'common/react';
import { capitalize } from 'common/string';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  Flex,
  LabeledList,
  ProgressBar,
  Section,
  Table,
} from '../components';
import { Window } from '../layouts';

type Data = {
  mode: number;
  transfer_max: number;
  output_load: number;
  input_load: number;
  equalise: BooleanLike;
  blink_tick: BooleanLike;
  cells_max: number;
  cells_cur: number;
  cells_list: {
    slot: number;
    used: BooleanLike;
    percentage: number | undefined;
    name: string | undefined;
    id: number;
  }[];
};

export const Batteryrack = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    mode,
    transfer_max,
    output_load,
    input_load,
    equalise,
    blink_tick,
    cells_list,
  } = data;

  return (
    <Window width={500} height={430}>
      <Window.Content scrollable>
        <Section title="Controls">
          <LabeledList>
            <LabeledList.Item label="Current Mode">
              {(mode === 1 && <Box color="good">OUTPUT ONLY</Box>) ||
                (mode === 2 && <Box color="good">INPUT ONLY</Box>) ||
                (mode === 3 && <Box color="good">INPUT AND OUTPUT</Box>) || (
                  <Box color="bad">OFFLINE</Box>
                )}
            </LabeledList.Item>
            <LabeledList.Item label="Input Status">
              <AnimatedNumber value={input_load} /> / {transfer_max} W
            </LabeledList.Item>
            <LabeledList.Item label="Output Status">
              <AnimatedNumber value={output_load} /> / {transfer_max} W
            </LabeledList.Item>
            <LabeledList.Item label="Control Panel">
              <Button selected={mode === 0} onClick={() => act('disable')}>
                OFF
              </Button>
              <Button
                selected={mode === 1}
                onClick={() => act('enable', { enable: 1 })}
              >
                OUT
              </Button>
              <Button
                selected={mode === 2}
                onClick={() => act('enable', { enable: 2 })}
              >
                IN
              </Button>
              <Button
                selected={mode === 3}
                onClick={() => act('enable', { enable: 3 })}
              >
                IN/OUT
              </Button>
              {(equalise && (
                <Button
                  color={blink_tick ? 'red' : 'yellow'}
                  onClick={() => act('equaliseoff')}
                >
                  EQ
                </Button>
              )) || <Button onClick={() => act('equaliseon')}>EQ</Button>}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Cells">
          <Table>
            {cells_list.map((cell) => (
              <Table.Row key={cell.slot}>
                <Table.Cell collapsing>Cell {cell.slot}</Table.Cell>
                <Table.Cell>
                  <ProgressBar
                    value={cell.used ? cell.percentage! : 100}
                    minValue={0}
                    maxValue={100}
                    color={cell.used ? 'good' : 'bad'}
                  >
                    <Flex>
                      <Flex.Item>
                        {!!cell.name && capitalize(cell.name)}
                      </Flex.Item>
                      <Flex.Item grow={1} />
                      <Flex.Item>
                        {cell.used ? cell.percentage + '%' : 'N/C'}
                      </Flex.Item>
                    </Flex>
                  </ProgressBar>
                </Table.Cell>
                <Table.Cell collapsing>
                  <Button
                    icon="eject"
                    disabled={!cell.used}
                    onClick={() => act('ejectcell', { ejectcell: cell.id })}
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
