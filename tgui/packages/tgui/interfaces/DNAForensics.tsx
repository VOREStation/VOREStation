import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

type Data = {
  scan_progress: number;
  scanning: BooleanLike;
  bloodsamp: string;
  bloodsamp_desc: string;
};

export const DNAForensics = (props) => {
  const { act, data } = useBackend<Data>();
  const { scan_progress, scanning, bloodsamp, bloodsamp_desc } = data;
  return (
    <Window width={540} height={326}>
      <Window.Content>
        <Section
          title="Status"
          buttons={
            <>
              <Button
                selected={scanning}
                disabled={!bloodsamp}
                icon="power-off"
                onClick={() => act('scanItem')}
              >
                {scanning ? 'Halt Scan' : 'Begin Scan'}
              </Button>
              <Button
                disabled={!bloodsamp}
                icon="eject"
                onClick={() => act('ejectItem')}
              >
                Eject Bloodsample
              </Button>
            </>
          }
        >
          <LabeledList>
            <LabeledList.Item label="Scan Progress">
              <ProgressBar
                ranges={{
                  good: [99, Infinity],
                  violet: [-Infinity, 99],
                }}
                value={scan_progress}
                maxValue={100}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Blood Sample">
          {(bloodsamp && (
            <Box>
              {bloodsamp}
              <Box color="label">{bloodsamp_desc}</Box>
            </Box>
          )) || <Box color="bad">No blood sample inserted.</Box>}
        </Section>
      </Window.Content>
    </Window>
  );
};
