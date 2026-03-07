import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { LabeledList, ProgressBar, Stack } from 'tgui-core/components';
import { SampleDisplay } from './Sample';
import type { Data } from './types';

export const AnomalyHarvester = (props) => {
  const { act, data } = useBackend<Data>();
  const { points, pointsToGenerate } = data;

  return (
    <Window width={400} height={500}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <LabeledList>
              <LabeledList.Item label="Sample Generation">
                <ProgressBar
                  color="darkred"
                  value={points}
                  minValue={0}
                  maxValue={pointsToGenerate}
                  ranges={{
                    good: [points * 0.85, pointsToGenerate],
                    average: [points * 0.25, pointsToGenerate * 0.85],
                    bad: [0, points * 0.25],
                  }}
                />
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
