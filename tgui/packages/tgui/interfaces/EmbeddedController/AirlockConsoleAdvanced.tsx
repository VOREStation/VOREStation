import { useBackend } from '../../backend';
import { Box, Button, Section } from '../../components';
import { StandardControls, StatusDisplay } from './EmbeddedControllerHelpers';
import { PanelOpen } from './PanelOpen';
import { AirlockConsoleAdvancedData } from './types';

/**
 * Advanced airlock consoles display the external pressure,
 * the internal pressure, and the chamber pressure separately.
 * They also have a PURGE and SECURE option for safety.
 * Replaces advanced_airlock_console.tmpl
 */
export const AirlockConsoleAdvanced = (props) => {
  const { act, data } = useBackend<AirlockConsoleAdvancedData>();

  const {
    external_pressure,
    chamber_pressure,
    internal_pressure,
    processing,
    panel_open,
  } = data;

  const pressure_range = {
    external_pressure,
    internal_pressure,
    chamber_pressure,
  };

  function color(value: number): string {
    return value < 80 || value > 120
      ? 'bad'
      : value < 95 || value > 110
        ? 'average'
        : 'good';
  }

  const bars = [
    {
      minValue: 0,
      maxValue: 202,
      value: external_pressure,
      label: 'External Pressure',
      textValue: external_pressure + ' kPa',
      color: color,
    },
    {
      minValue: 0,
      maxValue: 202,
      value: chamber_pressure,
      label: 'Chamber Pressure',
      textValue: chamber_pressure + ' kPa',
      color: color,
    },
    {
      minValue: 0,
      maxValue: 202,
      value: internal_pressure,
      label: 'Internal Pressure',
      textValue: internal_pressure + ' kPa',
      color: color,
    },
  ];

  return (
    <>
      <StatusDisplay bars={bars} />
      {panel_open ? (
        <PanelOpen />
      ) : (
        <Section title="Controls">
          <StandardControls pressure_range={pressure_range} />
          <Box>
            <Button icon="sync" onClick={() => act('purge')}>
              Purge
            </Button>
            <Button icon="lock-open" onClick={() => act('secure')}>
              Secure
            </Button>
          </Box>
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
      )}
    </>
  );
};
