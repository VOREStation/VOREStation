import { toFixed } from 'common/math';

import { useBackend } from '../../backend';
import {
  AnimatedNumber,
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from '../../components';
import { stats } from './constants';
import { occupant } from './types';

export const BodyScannerMainOccupant = (props: { occupant: occupant }) => {
  const { act } = useBackend();
  const { occupant } = props;
  return (
    <Section
      title="Occupant"
      buttons={
        <>
          <Button icon="user-slash" onClick={() => act('ejectify')}>
            Eject
          </Button>
          <Button icon="print" onClick={() => act('print_p')}>
            Print Report
          </Button>
        </>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Name">{occupant.name}</LabeledList.Item>
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
            format={(value) => toFixed(value)}
          />
          &deg;C,&nbsp;
          <AnimatedNumber
            value={occupant.bodyTempF}
            format={(value) => toFixed(value)}
          />
          &deg;F
        </LabeledList.Item>
        <LabeledList.Item label="Blood Volume">
          <AnimatedNumber
            value={occupant.blood.volume}
            format={(value) => toFixed(value)}
          />
          units&nbsp;(
          <AnimatedNumber
            value={occupant.blood.percent}
            format={(value) => toFixed(value)}
          />
          %)
        </LabeledList.Item>
        <LabeledList.Item label="Weight">
          {toFixed(occupant.weight) +
            'lbs, ' +
            toFixed(occupant.weight / 2.20463) +
            'kgs'}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
