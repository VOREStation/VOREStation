import { useBackend } from '../../backend';
import { Box, Button, Section } from '../../components';
import { BeakerContents } from '../common/BeakerContents';
import { removeAmounts } from './constants';
import { Data } from './types';

export const ChemDispenserBeaker = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    isBeakerLoaded,
    beakerCurrentVolume,
    beakerMaxVolume,
    beakerContents = [],
  } = data;
  return (
    <Section
      title="Beaker"
      flex="content"
      minHeight="25%"
      buttons={
        <Box>
          {!!isBeakerLoaded && (
            <Box inline color="label" mr={2}>
              {beakerCurrentVolume} / {beakerMaxVolume} units
            </Box>
          )}
          <Button
            icon="eject"
            disabled={!isBeakerLoaded}
            onClick={() => act('ejectBeaker')}
          >
            Eject
          </Button>
        </Box>
      }
    >
      <BeakerContents
        beakerLoaded={isBeakerLoaded}
        beakerContents={beakerContents}
        buttons={(chemical) => (
          <>
            <Button
              icon="compress-arrows-alt"
              onClick={() =>
                act('remove', {
                  reagent: chemical.id,
                  amount: -1,
                })
              }
            >
              Isolate
            </Button>
            {removeAmounts.map((a, i) => (
              <Button
                key={i}
                onClick={() =>
                  act('remove', {
                    reagent: chemical.id,
                    amount: a,
                  })
                }
              >
                {a}
              </Button>
            ))}
            <Button
              onClick={() =>
                act('remove', {
                  reagent: chemical.id,
                  amount: chemical.volume,
                })
              }
            >
              ALL
            </Button>
          </>
        )}
      />
    </Section>
  );
};
