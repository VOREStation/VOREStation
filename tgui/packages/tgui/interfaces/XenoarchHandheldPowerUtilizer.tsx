import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  LabeledList,
  NumberInput,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

type Data = {
  inserted_battery: BooleanLike;
  anomaly: string | null;
  charge: number | null;
  capacity: number | null;
  timeleft: number | null;
  activated: BooleanLike;
  duration: number | null;
  interval: number | null;
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
              onClick={() => act('ejectbattery')}
            >
              Eject Battery
            </Button>
          }
        >
          {(inserted_battery && (
            <LabeledList>
              <LabeledList.Item label="Inserted Battery">
                {inserted_battery}
              </LabeledList.Item>
              <LabeledList.Item label="Anomalies Detected">
                {anomaly || 'N/A'}
              </LabeledList.Item>
              <LabeledList.Item label="Charge">
                <ProgressBar value={charge!} maxValue={capacity!}>
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
                  step={1}
                  minValue={0}
                  value={duration!}
                  stepPixelSize={4}
                  maxValue={30}
                  onDrag={(val: number) =>
                    act('changeduration', { duration: val * 10 })
                  }
                />
              </LabeledList.Item>
              <LabeledList.Item label="Activation Interval">
                <NumberInput
                  unit="s"
                  fluid
                  step={1}
                  minValue={0}
                  value={interval!}
                  stepPixelSize={10}
                  maxValue={10}
                  onDrag={(val: number) =>
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
