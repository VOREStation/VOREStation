import { useBackend } from '../../backend';
import { Button, Section } from '../../components';
import { Data } from './types';

export const RequestConsoleSettings = (props) => {
  const { act, data } = useBackend<Data>();
  const { silent } = data;
  return (
    <Section title="Settings">
      <Button
        selected={!silent}
        icon={silent ? 'volume-mute' : 'volume-up'}
        onClick={() => act('toggleSilent')}
      >
        Speaker {silent ? 'OFF' : 'ON'}
      </Button>
    </Section>
  );
};
