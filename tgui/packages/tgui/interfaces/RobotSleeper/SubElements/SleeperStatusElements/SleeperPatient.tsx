import { useBackend } from 'tgui/backend';
import { Box, Stack } from 'tgui-core/components';
import { STAT_TO_COLOR } from '../../constants';
import type { Data } from '../../types';

export const SleeperPatient = (props: { name: string }) => {
  const { data } = useBackend<Data>();
  const { our_patient } = data;
  const { name } = props;

  if (!our_patient) {
    return `${name} Unoccupied.`;
  }

  const isParalysed = Math.round(our_patient.paralysis / 4) >= 1;

  return (
    <>
      <Stack.Item grow>
        <Stack>
          <Stack.Item>{our_patient.name}</Stack.Item>
          <Stack.Item>{`=>`}</Stack.Item>
          <Stack.Item>
            <Box color={Object.values(STAT_TO_COLOR)[our_patient.stat]}>
              {Object.keys(STAT_TO_COLOR)[our_patient.stat]}
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Box color={our_patient.crit_pulse ? 'red' : undefined}>
              - Pulse, bpm: {our_patient.pulse}
            </Box>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Box color={our_patient.health > 0 ? undefined : 'red'}>
          {`- Overall Health: ${((100 * our_patient.health) / our_patient.max_health).toFixed()}`}
        </Box>
      </Stack.Item>
      <Stack.Item>
        <Box color={our_patient.brute < 60 ? 'label' : 'red'}>
          {`- Brute Damage: ${our_patient.brute.toFixed()}`}
        </Box>
      </Stack.Item>
      <Stack.Item>
        <Box color={our_patient.oxy < 60 ? 'label' : 'red'}>
          {`- Respiratory Damage: ${our_patient.oxy.toFixed()}`}
        </Box>
      </Stack.Item>
      <Stack.Item>
        <Box color={our_patient.tox < 60 ? 'label' : 'red'}>
          {`- Toxin Content: ${our_patient.tox.toFixed()}`}
        </Box>
      </Stack.Item>
      <Stack.Item>
        <Box color={our_patient.burn < 60 ? 'label' : 'red'}>
          {`- Burn Severity: ${our_patient.burn.toFixed()}`}
        </Box>
      </Stack.Item>
      {(isParalysed ||
        !!our_patient.braindamage ||
        !!our_patient.clonedamage ||
        !!our_patient.ingested_reagents) && <Stack.Divider />}
      {isParalysed && (
        <Stack.Item>
          <Box bold>
            {`Patient paralyzed for: ${Math.round(our_patient.paralysis / 4)} seonds`}
          </Box>
        </Stack.Item>
      )}
      {!!our_patient.braindamage && (
        <Stack.Item>
          <Box color="orange">Significant brain damage detected.</Box>
        </Stack.Item>
      )}
      {!!our_patient.clonedamage && (
        <Stack.Item>
          <Box color="orange">Patient may be improperly cloned.</Box>
        </Stack.Item>
      )}
      {!!our_patient.ingested_reagents &&
        our_patient.ingested_reagents.map((reagent) => (
          <Stack.Item key={reagent.name}>
            <Box inline preserveWhitespace color="label">
              {`${reagent.name}: `}
            </Box>
            <Box inline>{Math.round(reagent.volume * 10) / 10} units</Box>
          </Stack.Item>
        ))}
    </>
  );
};
