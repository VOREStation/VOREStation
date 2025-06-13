import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';

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
        <Stack>
          <Stack.Item>
            {!!isBeakerLoaded && (
              <Box inline color="label" mr={2}>
                {beakerCurrentVolume} / {beakerMaxVolume} units
              </Box>
            )}
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="eject"
              disabled={!isBeakerLoaded}
              onClick={() => act('ejectBeaker')}
            >
              Eject
            </Button>
          </Stack.Item>
        </Stack>
      }
    >
      <BeakerContents
        beakerLoaded={recordedContents || isBeakerLoaded}
        beakerContents={recordedContents || beakerContents}
        buttons={(chemical) => (
          <Stack>
            <Stack.Item>
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
            </Stack.Item>
            {removeAmounts.map((a, i) => (
              <Stack.Item key={i}>
                <Button
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
              </Stack.Item>
            ))}
            <Stack.Item>
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
            </Stack.Item>
          </Stack>
        )}
      />
    </Section>
  );
};
