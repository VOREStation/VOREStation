import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { NtosWindow } from '../layouts';

type Data = {
  armed: BooleanLike;
};

export const NtosRevelation = (props) => {
  const { act, data } = useBackend<Data>();
  const { armed } = data;
  return (
    <NtosWindow width={400} height={250} theme="syndicate">
      <NtosWindow.Content>
        <Section>
          <Button.Input
            fluid
            onCommit={(e, value) =>
              act('PRG_obfuscate', {
                new_name: value,
              })
            }
            mb={1}
          >
            Obfuscate Name...
          </Button.Input>
          <LabeledList>
            <LabeledList.Item
              label="Payload Status"
              buttons={
                <Button
                  color={armed ? 'bad' : 'average'}
                  onClick={() => act('PRG_arm')}
                >
                  {armed ? 'ARMED' : 'DISARMED'}
                </Button>
              }
            />
          </LabeledList>
          <Button fluid bold textAlign="center" color="bad" disabled={!armed}>
            ACTIVATE
          </Button>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
