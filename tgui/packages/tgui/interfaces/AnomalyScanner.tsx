import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
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
  modifier: string;
  countdown: number;
};

export const AnomalyScanner = (props) => {
  const { act, data } = useBackend<Data>();

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
  } = data;

  let calcHeight = 350;
  if (modifier) calcHeight += 25;

  return (
    <Window width={400} height={calcHeight}>
      <Window.Content>
        {anomaly_name ? (
          <>
            <Section
              title={capitalizeAll(anomaly_name)}
              buttons={
                <Stack>
                  <Stack.Item>
                    <Button icon="print" onClick={() => act('print')}>
                      Print Report
                    </Button>
                  </Stack.Item>
                </Stack>
              }
            >
              <LabeledList>
                <LabeledList.Item label="Current severity">
                  {severity}%
                </LabeledList.Item>
                <LabeledList.Item label="Current anomaly state">
                  {stability}
                </LabeledList.Item>
                <LabeledList.Item label="Point output">
                  {point_output}
                </LabeledList.Item>
                <LabeledList.Item label="Time until next pulse">
                  {round(countdown, 0)} seconds
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <Section title="Particle Reaction Analysis">
              <LabeledList>
                <LabeledList.Item label="Danger Type">
                  {danger_type}
                </LabeledList.Item>
                <LabeledList.Item label="Unstable Type">
                  {unstable_type}
                </LabeledList.Item>
                <LabeledList.Item label="Containment Type">
                  {containment_type}
                </LabeledList.Item>
                <LabeledList.Item label="Transformation Type">
                  {transformation_type}
                </LabeledList.Item>
              </LabeledList>
            </Section>
            {modifier && (
              <Section title="Behavior Deviation Analysis">
                <Box>{modifier}</Box>
              </Section>
            )}
          </>
        ) : (
          <NoticeBox>No anomaly scanned</NoticeBox>
        )}
      </Window.Content>
    </Window>
  );
};
