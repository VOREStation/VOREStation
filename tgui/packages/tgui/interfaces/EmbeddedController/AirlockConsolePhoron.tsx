import { useBackend } from 'tgui/backend';
import { Box, Button, Section } from 'tgui-core/components';

import { StandardControls, StatusDisplay } from './EmbeddedControllerHelpers';
import { AirlockConsolePhoronData } from './types';

/**
 * Phoron airlock consoles don't actually cycle *pressure*, they cycle
 * phoron, for use on transitioning to the outside environment of a phoron
 * atmosphere planet.
 * Replaces phoron_airlock_console.tmpl
 */
export const AirlockConsolePhoron = (props) => {
  const { act, data } = useBackend<AirlockConsolePhoronData>();

  const {
    chamber_pressure,
    chamber_phoron,
    interior_status,
    exterior_status,
    processing,
  } = data;

  const status_range = { interior_status, exterior_status };

  const bars = [
    {
      minValue: 0,
      maxValue: 202,
      value: chamber_pressure,
      label: 'Chamber Pressure',
      textValue: chamber_pressure + ' kPa',
      color: (value: number) => {
        return value < 80 || value > 120
          ? 'bad'
          : value < 95 || value > 110
            ? 'average'
            : 'good';
      },
    },
    {
      minValue: 0,
      maxValue: 100,
      value: chamber_phoron,
      label: 'Chamber Phoron',
      textValue: chamber_phoron + ' mol',
      color: (value: number) => {
        return value > 5 ? 'bad' : value > 0.5 ? 'average' : 'good';
      },
    },
  ];

  return (
    <>
      <StatusDisplay bars={bars} />
      <Section title="Controls">
        <StandardControls status_range={status_range} />
        <Box>
          <Button
            disabled={!processing}
            icon="ban"
            color="bad"
            onClick={() => act('abort')}
          >
            Abort
          </Button>
        </Box>
      </Section>
    </>
  );
};
