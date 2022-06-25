import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const AssemblyInfrared = (props, context) => {
  const { act, data } = useBackend(context);
  const { on, visible } = data;
  return (
    <Window>
      <Window.Content>
        <Section title="Infrared Unit">
          <LabeledList>
            <LabeledList.Item label="Laser">
              <Button icon="power-off" fluid selected={on} onClick={() => act('state')}>
                {on ? 'On' : 'Off'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Visibility">
              <Button icon="eye" fluid selected={visible} onClick={() => act('visible')}>
                {visible ? 'Able to be seen' : 'Invisible'}
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
