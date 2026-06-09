import { useBackend } from 'tgui/backend';
import {
  Box,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';

type Data = {
  goals: Goal[];
};

type Goal = {
  name: string;
  description: string;
  count: number;
  index: number;
};

export const pda_depgoals = (props) => {
  const { data } = useBackend<Data>();

  const { goals } = data;

  return (
    <Box>
      {(!goals.length && (
        <NoticeBox>No departmental goals found!</NoticeBox>
      )) || <GoalsDisplay />}
    </Box>
  );
};

const GoalsDisplay = (props) => {
  const { data } = useBackend<Data>();
  const { goals } = data;

  return (
    <Stack vertical fill>
      {goals.length > 0 &&
        goals.map((goal) => (
          <Section key={goal.index}>
            <Stack vertical>
              <Stack.Item>
                <Box fontSize="4">{goal.name}</Box>
                <Box fontSize="2" color="gray">
                  {goal.description}
                </Box>
              </Stack.Item>
              <Stack.Item>
                <ProgressBar
                  value={goal.count}
                  minValue={0}
                  maxValue={100}
                  ranges={{
                    good: [85, 100],
                    average: [25, 85],
                    bad: [0, 25],
                  }}
                >
                  <Stack align="baseline">
                    {!!goal.name && <Stack.Item grow>{goal.count}%</Stack.Item>}
                  </Stack>
                </ProgressBar>
              </Stack.Item>
            </Stack>
          </Section>
        ))}
    </Stack>
  );
};
