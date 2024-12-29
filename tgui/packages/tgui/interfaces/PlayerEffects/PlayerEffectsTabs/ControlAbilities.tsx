import { useBackend } from '../../../backend';
import { Button, Section } from '../../../components';

export const ControlAbilities = (props) => {
  const { act } = useBackend();

  return (
    <Section title="Grant Abilities">
      <Button fluid onClick={() => act('vent_crawl')}>
        Vent Crawl
      </Button>
      <Button fluid onClick={() => act('darksight')}>
        Set Darksight
      </Button>
      <Button fluid onClick={() => act('cocoon')}>
        Give Cocoon Transformation
      </Button>
      <Button fluid onClick={() => act('transformation')}>
        Give TF verbs
      </Button>
      <Button fluid onClick={() => act('set_size')}>
        Give Set Size
      </Button>
      <Button fluid onClick={() => act('lleill_energy')}>
        Set Lleill Energy Levels
      </Button>
      <Button fluid onClick={() => act('lleill_invisibility')}>
        Give Lleill Invisibility
      </Button>
      <Button fluid onClick={() => act('beast_form')}>
        Give Leill Beast Form
      </Button>
      <Button fluid onClick={() => act('lleill_transmute')}>
        Give Leill Transmutation
      </Button>
      <Button fluid onClick={() => act('lleill_alchemy')}>
        Give Leill Alchemy
      </Button>
      <Button fluid onClick={() => act('lleill_drain')}>
        Give Lleill Drain
      </Button>
      <Button fluid onClick={() => act('brutal_pred')}>
        Give Brutal Predation
      </Button>
      <Button fluid onClick={() => act('trash_eater')}>
        Give Trash Eater
      </Button>
      <Button fluid onClick={() => act('active_cloaking')}>
        Give Active Cloaking
      </Button>
    </Section>
  );
};
