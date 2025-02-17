import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section } from 'tgui-core/components';

import { ShuttleControlSharedShuttleControls } from './ShuttleControlSharedShuttleControls';
import { ShuttleControlSharedShuttleStatus } from './ShuttleControlSharedShuttleStatus';
import type { Data } from './types';

export const ShuttleControlConsoleDefault = (props) => {
  return (
    <>
      <ShuttleControlSharedShuttleStatus />
      <ShuttleControlSharedShuttleControls />
    </>
  );
};

export const ShuttleControlConsoleMulti = (props: {
  destination_name: string;
}) => {
  const { act, data } = useBackend<Data>();
  const { can_cloak, can_pick, legit, cloaked } = data;
  return (
    <>
      <ShuttleControlSharedShuttleStatus />
      <Section title="Multishuttle Controls">
        <LabeledList>
          {(can_cloak && (
            <LabeledList.Item label={legit ? 'ATC Inhibitor' : 'Cloaking'}>
              <Button
                selected={cloaked}
                icon={cloaked ? 'eye' : 'eye-o'}
                onClick={() => act('toggle_cloaked')}
              >
                {cloaked ? 'Enabled' : 'Disabled'}
              </Button>
            </LabeledList.Item>
          )) ||
            ''}
          <LabeledList.Item label="Current Destination">
            <Button
              icon="taxi"
              disabled={!can_pick}
              onClick={() => act('pick')}
            >
              {props.destination_name}
            </Button>
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <ShuttleControlSharedShuttleControls />
    </>
  );
};

export const ShuttleControlConsoleExploration = (props) => {
  const { act, data } = useBackend<Data>();
  const { can_pick, destination_name, fuel_usage, fuel_span, remaining_fuel } =
    data;
  return (
    <>
      <ShuttleControlSharedShuttleStatus engineName="Engines" />
      <Section title="Jump Controls">
        <LabeledList>
          <LabeledList.Item label="Current Destination">
            <Button
              icon="taxi"
              disabled={!can_pick}
              onClick={() => act('pick')}
            >
              {destination_name}
            </Button>
          </LabeledList.Item>
          {(fuel_usage && (
            <>
              <LabeledList.Item label="Est. Delta-V Budget" color={fuel_span}>
                {remaining_fuel} m/s
              </LabeledList.Item>
              <LabeledList.Item label="Avg. Delta-V Per Maneuver">
                {fuel_usage} m/s
              </LabeledList.Item>
            </>
          )) ||
            ''}
        </LabeledList>
      </Section>
      <ShuttleControlSharedShuttleControls />
    </>
  );
};
