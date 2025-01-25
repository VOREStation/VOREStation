import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  NumberInput,
  Section,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

type Data = {
  on: BooleanLike;
  rate: number;
  max_rate: number;
  last_flow_rate: number;
  filter_types: { name: string; f_type: number; selected: number }[];
};

export const AtmosFilter = (props) => {
  const { act, data } = useBackend<Data>();

  const { on, rate, max_rate, last_flow_rate, filter_types = [] } = data;

  return (
    <Window width={390} height={187}>
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
            <LabeledList.Item label="Transfer Rate">
              <Box inline mr={1}>
                <AnimatedNumber
                  value={last_flow_rate}
                  format={(val) => val + ' L/s'}
                />
              </Box>
              <NumberInput
                animated
                step={1}
                value={rate}
                width="63px"
                unit="L/s"
                minValue={0}
                maxValue={200}
                onDrag={(value: number) =>
                  act('rate', {
                    rate: value,
                  })
                }
              />
              <Button
                ml={1}
                icon="plus"
                disabled={rate === max_rate}
                onClick={() =>
                  act('rate', {
                    rate: 'max',
                  })
                }
              >
                Max
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Filter">
              {filter_types.map((filter) => (
                <Button
                  key={filter.name}
                  selected={filter.selected}
                  onClick={() =>
                    act('filter', {
                      filterset: filter.f_type,
                    })
                  }
                >
                  {filter.name}
                </Button>
              ))}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
