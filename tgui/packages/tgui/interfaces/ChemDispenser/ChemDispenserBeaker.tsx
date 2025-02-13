import { useBackend } from 'tgui/backend';
import { Box, Button, Section } from 'tgui-core/components';

import { BeakerContents } from '../common/BeakerContents';
import { removeAmounts } from './constants';
import type { Data } from './types';

export const ChemDispenserBeaker = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    isBeakerLoaded,
    beakerCurrentVolume,
    beakerMaxVolume,
    beakerContents = [],
    recipes,
    recordingRecipe,
  } = data;

  const recording = !!recordingRecipe;
  const recordedContents =
    recording &&
    recordingRecipe.map((r) => ({
      id: r.id,
      name: r.id.replace(/_/, ' '),
      volume: r.amount,
    }));

  return (
    <Section
      title={recording ? 'Virtual Beaker' : 'Beaker'}
      fill
      scrollable
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
        beakerLoaded={recordedContents || isBeakerLoaded}
        beakerContents={recordedContents || beakerContents}
        buttons={(chemical) => (
          <>
            <Button
              icon="compress-arrows-alt"
              disabled={recording}
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
                disabled={recording}
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
              disabled={recording}
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
