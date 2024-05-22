import { useBackend } from '../backend';
import {
  Button,
  LabeledList,
  NumberInput,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

export const Tank = (props) => {
  const { act, data } = useBackend();

  const {
    connected,
    showToggle = true,
    maskConnected,
    tankPressure,
    releasePressure,
    defaultReleasePressure,
    minReleasePressure,
    maxReleasePressure,
  } = data;

  return (
    <Window width={400} height={320}>
      <Window.Content>
        <Section
          title="Status"
          buttons={
            !!showToggle && (
              <Button
                icon={connected ? 'air-freshener' : 'lock-open'}
                selected={connected}
                disabled={!maskConnected}
                onClick={() => act('toggle')}
              >
                Mask Release Valve
              </Button>
            )
          }
        >
          <LabeledList>
            <LabeledList.Item label="Mask Connected">
              {maskConnected ? 'Yes' : 'No'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Pressure">
              <ProgressBar
                value={tankPressure / 1013}
                ranges={{
                  good: [0.35, Infinity],
                  average: [0.15, 0.35],
                  bad: [-Infinity, 0.15],
                }}
              >
                {data.tankPressure + ' kPa'}
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Pressure Regulator">
              <Button
                icon="fast-backward"
                disabled={releasePressure === minReleasePressure}
                onClick={() =>
                  act('pressure', {
                    pressure: 'min',
                  })
                }
              />
              <NumberInput
                animated
                value={parseFloat(releasePressure)}
                width="65px"
                unit="kPa"
                minValue={minReleasePressure}
                maxValue={maxReleasePressure}
                onChange={(e, value) =>
                  act('pressure', {
                    pressure: value,
                  })
                }
              />
              <Button
                icon="fast-forward"
                disabled={releasePressure === maxReleasePressure}
                onClick={() =>
                  act('pressure', {
                    pressure: 'max',
                  })
                }
              />
              <Button
                icon="undo"
                disabled={releasePressure === defaultReleasePressure}
                onClick={() =>
                  act('pressure', {
                    pressure: 'reset',
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
