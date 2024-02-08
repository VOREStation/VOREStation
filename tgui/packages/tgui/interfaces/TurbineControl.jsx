import { formatPower } from '../format';
import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  Section,
} from '../components';
import { Window } from '../layouts';

export const TurbineControl = (props) => {
  const { act, data } = useBackend();

  const {
    connected,
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
                  <Button
                    icon="sync"
                    onClick={() => act('reconnect')}
                    content="Reconnect"
                  />
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
                      content="Compressor Power"
                      onClick={() => act(online ? 'power-off' : 'power-on')}
                    />
                  </Box>
                )}
            </LabeledList.Item>
            <LabeledList.Item label="Vent Doors">
              <Button.Checkbox
                checked={door_status}
                onClick={() => act('doors')}
                content={door_status ? 'Closed' : 'Open'}
              />
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
