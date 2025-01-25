import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, LabeledList, Section } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

type Data = {
  locked_name: string;
  station_connected: BooleanLike;
  hub_connected: BooleanLike;
  calibrated: BooleanLike;
  teleporter_on: BooleanLike;
};

export const Teleporter = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    locked_name,
    station_connected,
    hub_connected,
    calibrated,
    teleporter_on,
  } = data;

  return (
    <Window width={300} height={200}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Target">
              <Button
                fluid
                icon="bullseye"
                onClick={() => act('select_target')}
              >
                {locked_name}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Calibrated">
              <Button.Checkbox
                fluid
                checked={calibrated}
                color={calibrated ? 'good' : 'bad'}
                onClick={() => act('test_fire')}
              >
                {calibrated ? 'Accurate' : 'Test Fire'}
              </Button.Checkbox>
            </LabeledList.Item>
            <LabeledList.Item label="Teleporter">
              <Button.Checkbox
                fluid
                checked={teleporter_on}
                color={teleporter_on ? 'good' : 'bad'}
                onClick={() => act('toggle_on')}
              >
                {teleporter_on ? 'Online' : 'OFFLINE'}
              </Button.Checkbox>
            </LabeledList.Item>
            <LabeledList.Item label="Station">
              {station_connected ? 'Connected' : 'Not Connected'}
            </LabeledList.Item>
            <LabeledList.Item label="Hub">
              {hub_connected ? 'Connected' : 'Not Connected'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
