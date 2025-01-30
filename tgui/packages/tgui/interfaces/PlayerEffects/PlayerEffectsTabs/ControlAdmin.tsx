import { useBackend } from 'tgui/backend';
import { Button, Section } from 'tgui-core/components';

export const ControlAdmin = (props) => {
  const { act } = useBackend();

  return (
    <Section title="Admin Controls">
      <Button fluid onClick={() => act('quick_nif')}>
        Quick NIF
      </Button>
      <Button fluid onClick={() => act('resize')}>
        Resize
      </Button>
      <Button fluid onClick={() => act('teleport')}>
        Teleport
      </Button>
      <Button fluid onClick={() => act('gib')}>
        Gib
      </Button>
      <Button fluid onClick={() => act('dust')}>
        Dust
      </Button>
      <Button fluid onClick={() => act('paralyse')}>
        Paralyse
      </Button>
      <Button fluid onClick={() => act('subtle_message')}>
        Subtle Message
      </Button>
      <Button fluid onClick={() => act('direct_narrate')}>
        Direct Narrate
      </Button>
      <Button fluid onClick={() => act('player_panel')}>
        Open Player Panel
      </Button>
      <Button fluid onClick={() => act('view_variables')}>
        Open View Variables
      </Button>
      <Button fluid onClick={() => act('ai')}>
        Enable/Modify AI
      </Button>
      <Button fluid onClick={() => act('orbit')}>
        Make Marked Datum Orbit
      </Button>
      <Button fluid onClick={() => act('cloaking')}>
        Force Cloaking or Uncloaking
      </Button>
    </Section>
  );
};
