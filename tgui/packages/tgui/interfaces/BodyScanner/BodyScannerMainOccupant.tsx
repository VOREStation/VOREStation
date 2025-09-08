import { useBackend } from 'tgui/backend';
import {
  AnimatedNumber,
  Button,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';

import { stats } from './constants';
import type { occupant } from './types';

export const BodyScannerMainOccupant = (props: { occupant: occupant }) => {
  const { act } = useBackend();
  const { occupant } = props;
  return (
    <Section
      title="Occupant"
      buttons={
        <Stack>
          <Stack.Item>
            <Button icon="user-slash" onClick={() => act('ejectify')}>
              Eject
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button icon="print" onClick={() => act('print_p')}>
              Print Report
            </Button>
          </Stack.Item>
        </Stack>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Name">{occupant.name}</LabeledList.Item>
        <LabeledList.Item label="Species">{occupant.species}</LabeledList.Item>
        <LabeledList.Item label="Health">
          <ProgressBar
            minValue={0}
            maxValue={1}
            value={occupant.health / occupant.maxHealth}
            ranges={{
              good: [0.5, Infinity],
              average: [0, 0.5],
              bad: [-Infinity, 0],
            }}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Status" color={stats[occupant.stat][0]}>
          {stats[occupant.stat][1]}
        </LabeledList.Item>
        <LabeledList.Item label="Temperature">
          <AnimatedNumber
            value={occupant.bodyTempC}
            format={(value) => value.toFixed()}
          />
          &deg;C,&nbsp;
          <AnimatedNumber
            value={occupant.bodyTempF}
            format={(value) => value.toFixed()}
          />
          &deg;F
        </LabeledList.Item>
        <LabeledList.Item label="Blood Volume">
          <AnimatedNumber
            value={occupant.blood.volume}
            format={(value) => value.toFixed()}
          />
          u&nbsp;(
          <AnimatedNumber
            value={occupant.blood.percent}
            format={(value) => value.toFixed()}
          />
          %)
        </LabeledList.Item>
        <LabeledList.Item label="Weight">
          {`${(occupant.weight / 2.20463).toFixed(1)}kg, `}
          {`${occupant.weight.toFixed()}lbs`}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
