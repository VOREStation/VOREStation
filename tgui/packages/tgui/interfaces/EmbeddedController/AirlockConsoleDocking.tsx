import { useBackend } from 'tgui/backend';
import { Box, Button, Section } from 'tgui-core/components';

import {
  DockStatus,
  StandardControls,
  StatusDisplay,
} from './EmbeddedControllerHelpers';
import { AirlockConsoleDockingData } from './types';

/**
 * This is a mix airlock & docking console. It lets you control the dock status
 * as well as the attached airlock.
 * Replaces docking_airlock_console.tmpl
 */
export const AirlockConsoleDocking = (props) => {
  const { act, data } = useBackend<AirlockConsoleDockingData>();

  const {
    interior_status,
    exterior_status,
    chamber_pressure,
    airlock_disabled,
    override_enabled,
    docking_status,
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
  ];

  return (
    <>
      <Section
        title="Dock"
        buttons={
          airlock_disabled || override_enabled ? (
            <Button
              icon="exclamation-triangle"
              color={override_enabled ? 'red' : ''}
              onClick={() => act('toggle_override')}
            >
              Override
            </Button>
          ) : null
        }
      >
        <DockStatus
          docking_status={docking_status}
          override_enabled={override_enabled}
        />
      </Section>
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
