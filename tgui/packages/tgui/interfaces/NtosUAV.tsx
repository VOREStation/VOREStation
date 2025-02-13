import { useBackend } from 'tgui/backend';
import { NtosWindow } from 'tgui/layouts';
import { Box, Button, LabeledList, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  current_uav: { status: string; power: BooleanLike } | null;
  signal_strength: string;
  in_use: number;
  paired_uavs: { name: string; uavref: string }[];
};

export const NtosUAV = (props) => {
  const { act, data } = useBackend<Data>();

  const { current_uav, signal_strength, in_use, paired_uavs } = data;

  return (
    <NtosWindow width={600} height={500}>
      <NtosWindow.Content>
        <Section title="Selected UAV">
          <LabeledList>
            <LabeledList.Item label="UAV">
              {(current_uav && current_uav.status) || '[Not Connected]'}
            </LabeledList.Item>
            <LabeledList.Item label="Signal">
              {(current_uav && signal_strength) || '[Not Connected]'}
            </LabeledList.Item>
            <LabeledList.Item label="Power">
              {(current_uav && (
                <Button
                  icon="power-off"
                  selected={current_uav.power}
                  onClick={() => act('power_uav')}
                >
                  {current_uav.power ? 'Online' : 'Offline'}
                </Button>
              )) ||
                '[Not Connected]'}
            </LabeledList.Item>
            <LabeledList.Item label="Camera">
              {(current_uav && (
                <Button
                  icon="power-off"
                  selected={in_use}
                  disabled={!current_uav.power}
                  onClick={() => act('view_uav')}
                >
                  {current_uav.power ? 'Available' : 'Unavailable'}
                </Button>
              )) ||
                '[Not Connected]'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Paired UAVs">
          {(paired_uavs.length &&
            paired_uavs.map((uav) => (
              <Stack key={uav.uavref}>
                <Stack.Item grow>
                  <Button
                    fluid
                    icon="quidditch"
                    onClick={() =>
                      act('switch_uav', { switch_uav: uav.uavref })
                    }
                  >
                    {uav.name}
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    color="bad"
                    icon="times"
                    onClick={() => act('del_uav', { del_uav: uav.uavref })}
                  />
                </Stack.Item>
              </Stack>
            ))) || <Box color="average">No UAVs Paired.</Box>}
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
