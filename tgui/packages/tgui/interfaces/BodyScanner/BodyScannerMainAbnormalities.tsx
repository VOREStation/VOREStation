import { Box, Section } from 'tgui-core/components';

import { abnormalities } from './constants';
import type { occupant } from './types';

export const BodyScannerMainAbnormalities = (props: { occupant: occupant }) => {
  const { occupant } = props;

  const hasAbnormalities =
    occupant.hasBorer ||
    occupant.blind ||
    occupant.colourblind ||
    occupant.nearsighted ||
    occupant.brokenspine ||
    occupant.hasVirus ||
    occupant.husked ||
    occupant.hasWithdrawl ||
    occupant.humanPrey ||
    occupant.livingPrey ||
    occupant.objectPrey ||
    occupant.hasAllergens;

  if (!hasAbnormalities) {
    return (
      <Section title="Abnormalities">
        <Box color="label">No abnormalities found.</Box>
      </Section>
    );
  }

  return (
    <>
      <Section title="Abnormalities">
        {abnormalities.map((a, i) => {
          if (occupant[a[0] as string]) {
            return (
              <Box key={i} color={a[1] as string} bold={a[1] === 'bad'}>
                {(a[2] as (occupant: occupant) => string)(occupant)}
              </Box>
            );
          }
          return undefined;
        })}
      </Section>
      {occupant.allergens ? (
        <Section title="Allergens">
          {occupant.allergens.map((allergy) => (
            <Box key={allergy} color="bad">
              {allergy}
            </Box>
          ))}
        </Section>
      ) : (
        ''
      )}
    </>
  );
};
