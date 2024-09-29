import { useBackend } from '../../../backend';
import { Button, Section } from '../../../components';

export const ControlSmites = (props) => {
  const { act } = useBackend();

  return (
    <Section title="Smites">
      <Button fluid onClick={() => act('break_legs')}>
        Break Legs
      </Button>
      <Button fluid onClick={() => act('bluespace_artillery')}>
        Bluespace Artillery
      </Button>
      <Button fluid onClick={() => act('spont_combustion')}>
        Spontaneous Combustion
      </Button>
      <Button fluid onClick={() => act('lightning_strike')}>
        Lightning Bolt
      </Button>
      <Button fluid onClick={() => act('shadekin_attack')}>
        Shadekin Attack
      </Button>
      <Button fluid onClick={() => act('shadekin_vore')}>
        Shadekin Vore
      </Button>
      <Button fluid onClick={() => act('redspace_abduct')}>
        Redspace Abduction
      </Button>
      <Button fluid onClick={() => act('autosave')}>
        Autosave
      </Button>
      <Button fluid onClick={() => act('autosave2')}>
        Autosave AOE
      </Button>
      <Button fluid onClick={() => act('adspam')}>
        Ad Spam
      </Button>
      <Button fluid onClick={() => act('peppernade')}>
        Peppernade
      </Button>
      <Button fluid onClick={() => act('spicerequest')}>
        Spawn Spice
      </Button>
      <Button fluid onClick={() => act('terror')}>
        Terrify
      </Button>
      <Button fluid onClick={() => act('terror_aoe')}>
        Terrify AOE
      </Button>
      <Button fluid onClick={() => act('spin')}>
        Spin
      </Button>
      <Button fluid onClick={() => act('squish')}>
        Squish
      </Button>
      <Button fluid onClick={() => act('pie_splat')}>
        Pie Splat
      </Button>
      <Button fluid onClick={() => act('spicy_air')}>
        Spicy Air
      </Button>
      <Button fluid onClick={() => act('hot_dog')}>
        Hot Dog
      </Button>
      <Button fluid onClick={() => act('mob_tf')}>
        Mob Transformation
      </Button>
    </Section>
  );
};
