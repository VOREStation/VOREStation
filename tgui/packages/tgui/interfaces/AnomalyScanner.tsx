import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { LabeledList, NoticeBox, Section, Stack } from 'tgui-core/components';
import { round } from 'tgui-core/math';
import { capitalizeAll } from 'tgui-core/string';

type Data = {
  anomaly_name: string;
  severity: number;
  stability: string;
  point_output: number;
  danger_type: string;
  unstable_type: string;
  containment_type: string;
  transformation_type: string;
  modifier?: string;
  countdown: number;
};

const colorMap = {
  Decaying: 'yellow',
  Stable: 'green',
} as const;

function getColor(stability: string): string {
  return colorMap[stability] ?? 'bad';
}

export const AnomalyScanner = (props) => {
  const { data } = useBackend<Data>();

  const {
    anomaly_name,
    severity,
    stability,
    point_output,
    danger_type,
    unstable_type,
    containment_type,
    transformation_type,
    modifier,
    countdown,
    theme,
  } = data;

  return (
    <Window width={400} height={325} theme={theme}>
      <Window.Content>
        {anomaly_name ? (
          <Stack vertical fill>
            <Stack.Item grow>
              <Section title={capitalizeAll(anomaly_name)} fill scrollable>
                <LabeledList>
                  <LabeledList.Item label="Current severity">
                    {severity}%
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Current anomaly state"
                    color={getColor(stability)}
                  >
                    {stability}
                  </LabeledList.Item>
                  <LabeledList.Item label="Point output">
                    {round(point_output, 0)}
                  </LabeledList.Item>
                  <LabeledList.Item label="Time until next pulse">
                    {round(countdown, 0)} seconds
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            </Stack.Item>
            <Stack.Item grow>
              <Section title="Particle Reaction Analysis" fill scrollable>
                <LabeledList>
                  <LabeledList.Item label="Danger Type" color="red">
                    {danger_type}
                  </LabeledList.Item>
                  <LabeledList.Item label="Unstable Type" color="pink">
                    {unstable_type}
                  </LabeledList.Item>
                  <LabeledList.Item label="Containment Type" color="yellow">
                    {containment_type}
                  </LabeledList.Item>
                  <LabeledList.Item label="Transformation Type" color="blue">
                    {transformation_type}
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            </Stack.Item>
            {modifier && (
              <Stack.Item grow>
                <Section title="Behavior Deviation Analysis" fill>
                  {modifier}
                </Section>
              </Stack.Item>
            )}
          </Stack>
        ) : (
          <NoticeBox>No anomaly scanned</NoticeBox>
        )}
      </Window.Content>
    </Window>
  );
};
