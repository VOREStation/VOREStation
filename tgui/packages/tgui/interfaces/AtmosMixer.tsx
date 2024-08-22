import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button, LabeledList, NumberInput, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  on: BooleanLike;
  set_pressure: number;
  max_pressure: number;
  node1_concentration: number;
  node2_concentration: number;
  node1_dir: string;
  node2_dir: string;
};

export const AtmosMixer = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    on,
    set_pressure,
    max_pressure,
    node1_concentration,
    node2_concentration,
    node1_dir,
    node2_dir,
  } = data;

  return (
    <Window width={370} height={195}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Power">
              <Button
                icon={on ? 'power-off' : 'times'}
                selected={on}
                onClick={() => act('power')}
              >
                {on ? 'On' : 'Off'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Output Pressure">
              <NumberInput
                animated
                value={set_pressure}
                unit="kPa"
                width="75px"
                minValue={0}
                maxValue={max_pressure}
                step={10}
                onChange={(value: number) =>
                  act('pressure', {
                    pressure: value,
                  })
                }
              />
              <Button
                ml={1}
                icon="plus"
                disabled={set_pressure === max_pressure}
                onClick={() =>
                  act('pressure', {
                    pressure: 'max',
                  })
                }
              >
                Max
              </Button>
            </LabeledList.Item>
            <LabeledList.Divider size={1} />
            <LabeledList.Item color="label">
              <u>Concentrations</u>
            </LabeledList.Item>
            <LabeledList.Item label={'Node 1 (' + node1_dir + ')'}>
              <NumberInput
                animated
                value={node1_concentration}
                unit="%"
                width="60px"
                step={1}
                minValue={0}
                maxValue={100}
                stepPixelSize={2}
                onDrag={(value: number) =>
                  act('node1', {
                    concentration: value,
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label={'Node 2 (' + node2_dir + ')'}>
              <NumberInput
                animated
                value={node2_concentration}
                unit="%"
                width="60px"
                step={1}
                minValue={0}
                maxValue={100}
                stepPixelSize={2}
                onDrag={(value: number) =>
                  act('node2', {
                    concentration: value,
                  })
                }
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
