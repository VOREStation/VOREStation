import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  operating: BooleanLike;
  metal_amount: number;
};

export const AncientDroneFab = (props) => {
  const { act, data } = useBackend<Data>();

  const { operating, metal_amount } = data;

  return (
    <Window width={400} height={270} theme="malfunction">
      <Window.Content>
        <Stack fill vertical>
          {operating ? (
            <Stack.Item>
              <NoticeBox bold>Please wait until completion...</NoticeBox>
            </Stack.Item>
          ) : (
            <Stack.Item grow>
              <Section
                fill
                title="Drone Production"
                buttons={
                  <ProgressBar
                    minValue={0}
                    maxValue={150000}
                    value={metal_amount}
                    ranges={{
                      bad: [0, 25000],
                      average: [25000, 75000],
                    }}
                  >
                    Metal Amount: {metal_amount} / 150000
                  </ProgressBar>
                }
              >
                <Stack vertical>
                  <ProductionEntry
                    action="build_l_arm"
                    label="Left Arm"
                    cost="25,000"
                  />
                  <ProductionEntry
                    action="build_r_arm"
                    label="Right Arm"
                    cost="25,000"
                  />
                  <ProductionEntry
                    action="build_l_leg"
                    label="Left Leg"
                    cost="25,000"
                  />
                  <ProductionEntry
                    action="build_r_leg"
                    label="Right Leg"
                    cost="25,000"
                  />
                  <ProductionEntry
                    action="build_chest"
                    label="Robot Chest"
                    cost="50,000"
                  />
                  <ProductionEntry
                    action="build_head"
                    label="Robot Head"
                    cost="50,000"
                  />
                  <ProductionEntry
                    action="build_frame"
                    label="Robot Frame"
                    cost="75,000"
                  />
                </Stack>
              </Section>
            </Stack.Item>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};

const ProductionEntry = (props: {
  action: string;
  label: string;
  cost: string;
}) => {
  const { action, label, cost } = props;
  const { act } = useBackend<Data>();

  return (
    <Stack.Item>
      <Stack>
        <Stack.Item basis="30%">
          <Button onClick={() => act(action)}>{label}</Button>
        </Stack.Item>
        <Stack.Item>
          <Box inline color="label">
            ({cost} cc metal)
          </Box>
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
};
