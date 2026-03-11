import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { LabeledList, ProgressBar, Stack } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';
import { SampleDisplay } from './Sample';
import type { Data } from './types';

export const AnomalyHarvester = (props) => {
  const { act, data } = useBackend<Data>();
  const { points, pointsToGenerate, name } = data;

  const progress = (points / pointsToGenerate) * 100;
  return (
    <Window width={400} height={500}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <LabeledList>
              <LabeledList.Item label="Sample Generation">
                <ProgressBar
                  value={progress}
                  minValue={0}
                  maxValue={100}
                  ranges={{
                    good: [85, 100],
                    average: [25, 85],
                    bad: [0, 25],
                  }}
                >
                  <Stack align="baseline">
                    {!!name && <Stack.Item>{capitalize(name)}</Stack.Item>}
                    <Stack.Item grow>{`${progress.toFixed()}%`}</Stack.Item>
                  </Stack>
                </ProgressBar>
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
          <Stack.Item grow>
            <SampleDisplay />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
