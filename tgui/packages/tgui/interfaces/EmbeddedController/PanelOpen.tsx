import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  LabeledList,
  NumberInput,
  Section,
} from 'tgui-core/components';
import { round, toFixed } from 'tgui-core/math';

import type { PanelOpenData } from './types';

export const PanelOpen = (props) => {
  const { act, data } = useBackend<PanelOpenData>();

  const { panel_open, tags, frequency, min_freq, max_freq } = data;

  if (!panel_open || !tags) {
    return null;
  }

  return (
    <Section title="Airlock Configuration">
      <LabeledList>
        <LabeledList.Item label="Frequency">
          <NumberInput
            animated
            fluid
            unit="kHz"
            step={0.2}
            stepPixelSize={10}
            value={frequency / 10}
            minValue={min_freq / 10}
            maxValue={max_freq / 10}
            format={(val) => toFixed(val, 1)}
            onDrag={(freq) =>
              act('set_frequency', { freq: round(freq * 10, 0) })
            }
          />
        </LabeledList.Item>
        {Object.entries(tags).map(([tag, value]) => (
          <LabeledList.Item
            label={tag}
            key={tag}
            buttons={
              <Button icon="pencil" onClick={() => act('edit_tag', { tag })}>
                Edit
              </Button>
            }
          >
            {value || <Box color="bad">Unset</Box>}
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};
