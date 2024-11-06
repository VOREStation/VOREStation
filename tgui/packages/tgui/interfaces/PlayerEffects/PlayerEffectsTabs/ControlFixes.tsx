import { useBackend } from '../../../backend';
import { Button, Section } from '../../../components';

export const ControlFixes = (props) => {
  const { act } = useBackend();

  return (
    <Section title="Bug Fixes">
      <Button fluid onClick={() => act('rejuvenate')}>
        Rejuvenate
      </Button>
      <Button fluid onClick={() => act('popup-box')}>
        Send Message Box
      </Button>
      <Button fluid onClick={() => act('stop-orbits')}>
        Clear All Orbiters
      </Button>
      <Button fluid onClick={() => act('revert-mob-tf')}>
        Revert Mob Transformation
      </Button>
    </Section>
  );
};
