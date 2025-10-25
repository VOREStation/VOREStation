import { useBackend } from 'tgui/backend';
import { Box, Section, Stack } from 'tgui-core/components';
import { formatUnits } from '../common/BeakerContents';
import type { Data } from './types';

export const BorgHypoRecipeDisplay = (props) => {
  const { act, data } = useBackend<Data>();
  const { recordingRecipe } = data;

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
      title="Recipe Creation"
      fill
      scrollable
      buttons={
        !recording ? null : (
          <Stack>
            <Box color="Bad" inline bold>
              Recording in progress...
            </Box>
          </Stack>
        )
      }
    >
      {recording && (
        <Stack align="start" justify="space-between" direction="column">
          {recordedContents.map((reagent, i) => (
            <Stack.Item key={i} color="label">
              {formatUnits(reagent.volume)} of {reagent.name}
            </Stack.Item>
          ))}
        </Stack>
      )}
    </Section>
  );
};
