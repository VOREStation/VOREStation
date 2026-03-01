import { useBackend } from 'tgui/backend';
import { Box, Button, Section } from 'tgui-core/components';
import type { Data } from './types';

export const PAIActiveCompanion = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    name,
    health,
    law_zero,
    law_extra,
    master_name,
    master_dna,
    radio,
    radio_transmit,
    radio_recieve,
    screen_msg,
  } = data;

  return (
    <Box>
      <Section title={name}>{screen_msg}</Section>
      <Section title="Integrity">{health}</Section>
      <Section
        title="Owner"
        buttons={
          <Button
            icon="lightbulb-o"
            disabled={!!master_name && !!master_dna}
            onClick={() => act('setdna')}
          >
            Imprint DNA
          </Button>
        }
      >
        {(!!master_name && !!master_dna) ??
          (`${master_name} : ${master_dna}` || 'unbound')}
      </Section>
      <Section title="Prime directive:">{law_zero}</Section>
      <Section
        title="Additional directives:"
        buttons={
          <Button icon="lightbulb-o" onClick={() => act('setlaws')}>
            Configure
          </Button>
        }
      >
        {law_extra}
      </Section>
      <Section title="Radio Uplink">
        {
          // don't obliterate me kash, this is intentionally temp as hell, replace with the actual radio headset buttons, maybe we add frequency?
          radio ??
            (`Radio settings ${radio_recieve} | ${radio_transmit}` ||
              'Radio firmware not loaded. Please install a pAI personality to load firmware.')
        }
      </Section>
    </Box>
  );
};
