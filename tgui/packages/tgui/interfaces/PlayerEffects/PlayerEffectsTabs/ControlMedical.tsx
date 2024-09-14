import { useBackend } from '../../../backend';
import { Button, Section } from '../../../components';

export const ControlMedical = (props) => {
  const { act } = useBackend();

  return (
    <Section title="Medical Effects">
      <Button fluid onClick={() => act('appendicitis')}>
        Appendicitis
      </Button>
      <Button fluid onClick={() => act('repair_organ')}>
        Repair Organ
      </Button>
      <Button fluid onClick={() => act('damage_organ')}>
        Damage Organ/Limb
      </Button>
      <Button fluid onClick={() => act('break_bone')}>
        Break Bone
      </Button>
      <Button fluid onClick={() => act('drop_organ')}>
        Drop Organ/Limb
      </Button>
      <Button fluid onClick={() => act('assist_organ')}>
        Make Organ Assisted
      </Button>
      <Button fluid onClick={() => act('robot_organ')}>
        Make Organ Robotic
      </Button>
      <Button fluid onClick={() => act('rejuvenate')}>
        Rejuvenate
      </Button>
      <Button fluid onClick={() => act('stasis')}>
        Toggle Stasis
      </Button>
    </Section>
  );
};
