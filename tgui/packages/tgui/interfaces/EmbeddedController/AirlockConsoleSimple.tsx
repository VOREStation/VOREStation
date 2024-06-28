import { useBackend } from '../../backend';
import { Box, Button, Section } from '../../components';
import { StandardControls, StatusDisplay } from './EmbeddedControllerHelpers';
import { AirlockConsoleSimpleData } from './types';

/**
 * Simple airlock consoles are the least complicated airlock controller.
 * They show the current chamber pressure, two cycle buttons, and two
 * force door buttons. That's it.
 * Replaces simple_airlock_console.tmpl
 */
export const AirlockConsoleSimple = (props) => {
  const { act, data } = useBackend<AirlockConsoleSimpleData>();

  const { exterior_status, chamber_pressure, processing, interior_status } =
    data;

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
