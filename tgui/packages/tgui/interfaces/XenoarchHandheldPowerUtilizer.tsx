import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, NumberInput, Section, ProgressBar } from '../components';
import { Window } from '../layouts';

type Data = {
  inserted_battery: BooleanLike;
  anomaly: string;
  charge: number;
  capacity: number;
  timeleft: number;
  activated: BooleanLike;
  duration: number;
  interval: number;
};

export const XenoarchHandheldPowerUtilizer = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    inserted_battery,
    anomaly,
    charge,
    capacity,
    timeleft,
    activated,
    duration,
    interval,
  } = data;

  return (
    <Window width={400} height={500}>
      <Window.Content>
        <Section
          title="Anomaly Power Utilizer"
          buttons={
            <Button
              disabled={!inserted_battery}
              icon="eject"
              onClick={() => act('ejectbattery')}>
              Eject Battery
            </Button>
          }>
          {(inserted_battery && (
            <LabeledList>
              <LabeledList.Item label="Inserted Battery">
                {inserted_battery}
              </LabeledList.Item>
              <LabeledList.Item label="Anomalies Detected">
                {anomaly || 'N/A'}
              </LabeledList.Item>
              <LabeledList.Item label="Charge">
                <ProgressBar value={charge} maxValue={capacity}>
                  {charge} / {capacity}
                </ProgressBar>
              </LabeledList.Item>
              <LabeledList.Item label="Time Left Activated">
                {timeleft}
              </LabeledList.Item>
              <LabeledList.Item label="Power">
                <Button fluid icon="power-off" onClick={() => act('startup')}>
                  {activated ? 'Activated' : 'Deactivated'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Activation Duration">
                <NumberInput
                  unit="s"
                  fluid
                  minValue={0}
                  value={duration}
                  stepPixelSize={4}
                  maxValue={30}
                  onDrag={(e, val) =>
                    act('changeduration', { duration: val * 10 })
                  }
                />
              </LabeledList.Item>
              <LabeledList.Item label="Activation Interval">
                <NumberInput
                  unit="s"
                  fluid
                  minValue={0}
                  value={interval}
                  stepPixelSize={10}
                  maxValue={10}
                  onDrag={(e, val) =>
                    act('changeinterval', { interval: val * 10 })
                  }
                />
              </LabeledList.Item>
            </LabeledList>
          )) || (
            <Box color="bad">No battery inserted. Please insert a cell.</Box>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
