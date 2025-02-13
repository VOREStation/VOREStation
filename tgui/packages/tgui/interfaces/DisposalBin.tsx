import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  mode: number;
  pressure: number;
  isAI: BooleanLike;
  panel_open: BooleanLike;
  flushing: BooleanLike;
};

export const DisposalBin = (props) => {
  const { act, data } = useBackend<Data>();
  const { mode, pressure, isAI, panel_open, flushing } = data;
  let stateColor;
  let stateText;
  if (mode === 2) {
    stateColor = 'good';
    stateText = 'Ready';
  } else if (mode <= 0) {
    stateColor = 'bad';
    stateText = 'N/A';
  } else if (mode === 1) {
    stateColor = 'average';
    stateText = 'Pressurizing';
  } else {
    stateColor = 'average';
    stateText = 'Idle';
  }
  return (
    <Window width={300} height={250}>
      <Window.Content>
        <Section>
          <Box bold m={1}>
            Status
          </Box>
          <LabeledList>
            <LabeledList.Item label="State" color={stateColor}>
              {stateText}
            </LabeledList.Item>
            <LabeledList.Item label="Pressure">
              <ProgressBar
                ranges={{
                  bad: [-Infinity, 0],
                  average: [0, 99],
                  good: [99, Infinity],
                }}
                value={pressure}
                minValue={0}
                maxValue={100}
              />
            </LabeledList.Item>
          </LabeledList>
          <Box bold m={1}>
            Controls
          </Box>
          <LabeledList>
            <LabeledList.Item label="Handle">
              <Button
                icon="toggle-off"
                disabled={isAI || panel_open}
                selected={flushing ? null : true}
                onClick={() => act('disengageHandle')}
              >
                Disengaged
              </Button>
              <Button
                icon="toggle-on"
                disabled={isAI || panel_open}
                selected={flushing ? true : null}
                onClick={() => act('engageHandle')}
              >
                Engaged
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Power">
              <Button
                icon="toggle-off"
                disabled={mode === -1}
                selected={mode ? null : true}
                onClick={() => act('pumpOff')}
              >
                Off
              </Button>
              <Button
                icon="toggle-on"
                disabled={mode === -1}
                selected={mode ? true : null}
                onClick={() => act('pumpOn')}
              >
                On
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Eject">
              <Button
                icon="sign-out-alt"
                disabled={isAI}
                onClick={() => act('eject')}
              >
                Eject Contents
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
