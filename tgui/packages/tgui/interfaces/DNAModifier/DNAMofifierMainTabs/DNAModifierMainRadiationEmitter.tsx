import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Knob,
  Section,
  Stack,
} from 'tgui-core/components';

import type { Data } from '../types';

export const DNAModifierMainRadiationEmitter = (props) => {
  const { act, data } = useBackend<Data>();

  const { radiationIntensity, radiationDuration, occupant } = data;

  return (
    (occupant && occupant.isViableSubject && (
      <Section fill title="Radiation Emitter">
        <Stack>
          <Stack.Item grow />
          <Stack.Item>
            <Stack align="baseline">
              <Stack.Item>
                <Box color="label">Intensity</Box>
              </Stack.Item>
              <Stack.Item>
                <Knob
                  minValue={1}
                  maxValue={10}
                  stepPixelSize={20}
                  value={radiationIntensity}
                  ml="0"
                  onChange={(e, val) =>
                    act('radiationIntensity', { value: val })
                  }
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow />
          <Stack.Item>
            <Stack align="baseline">
              <Stack.Item>
                <Box color="label">Duration</Box>
              </Stack.Item>
              <Stack.Item>
                <Knob
                  minValue={1}
                  maxValue={20}
                  stepPixelSize={10}
                  unit="s"
                  value={radiationDuration}
                  ml="0"
                  onChange={(e, val) =>
                    act('radiationDuration', { value: val })
                  }
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow />
        </Stack>
        <Divider />
        <Stack fill align="baseline">
          <Stack.Item grow />
          <Stack.Item>
            <Button
              tooltip="Mutates the selected DNA block."
              icon="radiation"
              onClick={() => act('pulseSERadiation')}
            >
              Irradiate Block
            </Button>
          </Stack.Item>
          <Stack.Item grow />
          <Stack.Item>
            <Button
              icon="radiation"
              tooltip="Mutates a random block of DNA."
              tooltipPosition="top"
              mt="0.5rem"
              onClick={() => act('pulseRadiation')}
            >
              Pulse Radiation
            </Button>
          </Stack.Item>
          <Stack.Item grow />
        </Stack>
      </Section>
    )) ||
    null
  );
};
