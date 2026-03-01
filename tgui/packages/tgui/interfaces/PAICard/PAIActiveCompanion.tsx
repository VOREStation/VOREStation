import { useBackend } from 'tgui/backend';
import { Box, Button, Section } from 'tgui-core/components';
import type { ActivePAIData, Data } from './types';

export const PAIActiveCompanion = (props: { activeData: ActivePAIData }) => {
  const { act } = useBackend();

  const { activeData } = props;
  const {
    name,
    health,
    chassis,
    law_zero,
    law_extra,
    master_name,
    master_dna,
    screen_msg,
    radio_data,
  } = activeData;

  return (
    <Section fill scrollable>
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
        {radio_data
          ? `Radio settings ${radio_recieve} | ${radio_transmit}`
          : 'Radio firmware not loaded. Please install a pAI personality to load firmware.'}
      </Section>
    </Section>
  );
};
