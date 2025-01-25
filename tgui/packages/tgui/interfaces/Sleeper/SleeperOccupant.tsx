import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';

import { stats, tempColors } from './constants';
import { Data } from './types';

export const SleeperOccupant = (props) => {
  const { act, data } = useBackend<Data>();
  const { occupant, auto_eject_dead, stasis } = data;
  return (
    <Section
      title="Occupant"
      buttons={
        <>
          <Box color="label" inline>
            Auto-eject if dead:&nbsp;
          </Box>
          <Button
            icon={auto_eject_dead ? 'toggle-on' : 'toggle-off'}
            selected={auto_eject_dead}
            onClick={() =>
              act('auto_eject_dead_' + (auto_eject_dead ? 'off' : 'on'))
            }
          >
            {auto_eject_dead ? 'On' : 'Off'}
          </Button>
          <Button icon="user-slash" onClick={() => act('ejectify')}>
            Eject
          </Button>
          <Button onClick={() => act('changestasis')}>{stasis}</Button>
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
          >
            {toFixed(occupant.health)}
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="Status" color={stats[occupant.stat][0]}>
          {stats[occupant.stat][1]}
        </LabeledList.Item>
        <LabeledList.Item label="Temperature">
          <ProgressBar
            minValue={0}
            maxValue={1}
            value={occupant.bodyTemperature / occupant.maxTemp}
            color={tempColors[occupant.temperatureSuitability + 3]}
          >
            {toFixed(occupant.btCelsius)}&deg;C,
            {toFixed(occupant.btFaren)}&deg;F
          </ProgressBar>
        </LabeledList.Item>
        {!!occupant.hasBlood && (
          <>
            <LabeledList.Item label="Blood Level">
              <ProgressBar
                minValue={0}
                maxValue={1}
                value={occupant.bloodLevel! / occupant.bloodMax!}
                ranges={{
                  bad: [-Infinity, 0.6],
                  average: [0.6, 0.9],
                  good: [0.6, Infinity],
                }}
              >
                {occupant.bloodPercent}%, {occupant.bloodLevel}cl
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Pulse" verticalAlign="middle">
              {occupant.pulse} BPM
            </LabeledList.Item>
          </>
        )}
      </LabeledList>
    </Section>
  );
};
