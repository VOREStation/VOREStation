import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const InventoryPanel = (props, context) => {
  const { act, data } = useBackend(context);

  const { slots, internalsValid } = data;

  return (
    <Window width={400} height={200} resizable>
      <Window.Content scrollable>
        <Section>
          <LabeledList>
            {slots &&
              slots.length &&
              slots.map((slot) => (
                <LabeledList.Item key={slot.name} label={slot.name}>
                  <Button mb={-1} icon={slot.item ? 'hand-paper' : 'gift'} onClick={() => act(slot.act)}>
                    {slot.item || 'Nothing'}
                  </Button>
                </LabeledList.Item>
              ))}
          </LabeledList>
        </Section>
        {(internalsValid && (
          /* Remove if more actions are added */
          <Section title="Actions">
            {(internalsValid && (
              <Button fluid icon="lungs" onClick={() => act('internals')}>
                Set Internals
              </Button>
            )) ||
              null}
          </Section>
        )) ||
          null}
      </Window.Content>
    </Window>
  );
};
