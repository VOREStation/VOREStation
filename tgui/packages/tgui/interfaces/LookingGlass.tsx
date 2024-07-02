import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  supportedPrograms: string[];
  currentProgram: string;
  immersion: BooleanLike;
  gravity: BooleanLike;
};

export const LookingGlass = (props) => {
  const { act, data } = useBackend<Data>();

  const { supportedPrograms, currentProgram, immersion, gravity } = data;

  let height = Math.min(180 + supportedPrograms.length * 23, 600);

  return (
    <Window width={300} height={height}>
      <Window.Content scrollable>
        <Section title="Programs">
          {supportedPrograms.map((program) => (
            <Button
              key={program}
              fluid
              icon="eye"
              selected={program === currentProgram}
              onClick={() => act('program', { program: program })}
            >
              {program}
            </Button>
          ))}
        </Section>
        <Section title="Controls">
          <LabeledList>
            <LabeledList.Item label="Gravity">
              <Button
                fluid
                icon="user-astronaut"
                selected={gravity}
                onClick={() => act('gravity')}
              >
                {gravity ? 'Enabled' : 'Disabled'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Full Immersion">
              <Button
                mt={-1}
                fluid
                icon="eye"
                selected={immersion}
                onClick={() => act('immersion')}
              >
                {immersion ? 'Enabled' : 'Disabled'}
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
