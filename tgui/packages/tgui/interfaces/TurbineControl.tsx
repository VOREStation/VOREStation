import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  Section,
} from '../components';
import { formatPower } from '../format';
import { Window } from '../layouts';

type Data = {
  connected: BooleanLike;
  compressor_broke: BooleanLike;
  turbine_broke: BooleanLike;
  broken: BooleanLike;
  door_status: BooleanLike;
  online: BooleanLike;
  power: number;
  rpm: number;
  temp: number;
};

export const TurbineControl = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    compressor_broke,
    turbine_broke,
    broken,
    door_status,
    online,
    power,
    rpm,
    temp,
  } = data;

  return (
    <Window width={520} height={440}>
      <Window.Content scrollable>
        <Section title="Turbine Controller">
          <LabeledList>
            <LabeledList.Item label="Status">
              {(broken && (
                <Box color="bad">
                  Setup is broken
                  <Button icon="sync" onClick={() => act('reconnect')}>
                    Reconnect
                  </Button>
                </Box>
              )) || (
                <Box color={online ? 'good' : 'bad'}>
                  {online && !compressor_broke && !turbine_broke
                    ? 'Online'
                    : 'Offline'}
                </Box>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Compressor">
              {(compressor_broke && (
                <Box color="bad">Compressor is inoperable.</Box>
              )) ||
                (turbine_broke && (
                  <Box color="bad">Turbine is inoperable.</Box>
                )) || (
                  <Box>
                    <Button.Checkbox
                      checked={online}
                      onClick={() => act(online ? 'power-off' : 'power-on')}
                    >
                      Compressor Power
                    </Button.Checkbox>
                  </Box>
                )}
            </LabeledList.Item>
            <LabeledList.Item label="Vent Doors">
              <Button.Checkbox
                checked={door_status}
                onClick={() => act('doors')}
              >
                {door_status ? 'Closed' : 'Open'}
              </Button.Checkbox>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Turbine Speed">
              {broken ? '--' : <AnimatedNumber value={rpm} />} RPM
            </LabeledList.Item>
            <LabeledList.Item label="Internal Temperature">
              {broken ? '--' : <AnimatedNumber value={temp} />} K
            </LabeledList.Item>
            <LabeledList.Item label="Generated Power">
              {broken ? (
                '--'
              ) : (
                <AnimatedNumber
                  format={(v) => formatPower(v)}
                  value={Number(power)}
                />
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
