import { Box, Section } from '../../components';
import { abnormalities } from './constants';
import { occupant } from './types';

export const BodyScannerMainAbnormalities = (props: { occupant: occupant }) => {
  const { occupant } = props;

  let hasAbnormalities =
    occupant.hasBorer ||
    occupant.blind ||
    occupant.colourblind ||
    occupant.nearsighted ||
    occupant.hasVirus ||
    occupant.husked;

  hasAbnormalities =
    hasAbnormalities ||
    occupant.humanPrey ||
    occupant.livingPrey ||
    occupant.objectPrey;

  if (!hasAbnormalities) {
    return (
      <Section title="Abnormalities">
        <Box color="label">No abnormalities found.</Box>
      </Section>
    );
  }

  return (
    <Section title="Abnormalities">
      {abnormalities.map((a, i) => {
        if (occupant[a[0] as string]) {
          return (
            <Box key={i} color={a[1] as string} bold={a[1] === 'bad'}>
              {(a[2] as (occupant: occupant) => string)(occupant)}
            </Box>
          );
        }
      })}
    </Section>
  );
};
