import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, LabeledList, Section } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

type Data = {
  assembled: BooleanLike;
  power: BooleanLike;
  strength: number;
};

export const ParticleAccelerator = (props) => {
  const { act, data } = useBackend<Data>();
  const { assembled, power, strength } = data;
  return (
    <Window width={350} height={185}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item
              label="Status"
              buttons={
                <Button icon={'sync'} onClick={() => act('scan')}>
                  Run Scan
                </Button>
              }
            >
              <Box color={assembled ? 'good' : 'bad'}>
                {assembled
                  ? 'Ready - All parts in place'
                  : 'Unable to detect all parts'}
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Particle Accelerator Controls">
          <LabeledList>
            <LabeledList.Item label="Power">
              <Button
                icon={power ? 'power-off' : 'times'}
                selected={power}
                disabled={!assembled}
                onClick={() => act('power')}
              >
                {power ? 'On' : 'Off'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Particle Strength">
              <Button
                icon="backward"
                disabled={!assembled}
                onClick={() => act('remove_strength')}
              />{' '}
              {String(strength).padStart(1, '0')}{' '}
              <Button
                icon="forward"
                disabled={!assembled}
                onClick={() => act('add_strength')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
