import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section, Stack } from 'tgui-core/components';

import type { Data } from './types';

export const AppearanceChangerMisc = (props) => {
  const { act, data } = useBackend<Data>();
  const { specimen } = data;
  return (
    <Section title="Misc" fill scrollable>
      <Stack vertical fill>
        <Section title="Scaling">
          <LabeledList.Item label="Species Appearance">
            <Button
              icon="pen"
              disabled={!data.use_custom_icon}
              onClick={() => act('base_icon')}
            >
              {data.base_icon ? data.base_icon : specimen}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Digitigrade">
            <Button icon="pen" onClick={() => act('digitigrade')}>
              {data.digitigrade ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
        </Section>
        <Section title="Scaling">
          <LabeledList.Item label="Scale">
            <Button icon="pen" onClick={() => act('size_scale')}>
              {data.size_scale}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Scale Offset">
            <Button icon="pen" onClick={() => act('offset_override')}>
              {data.offset_override}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Scale Appearance">
            <Button icon="pen" onClick={() => act('scale_appearance')}>
              {data.scale_appearance}
            </Button>
          </LabeledList.Item>
        </Section>
        <Section title="Sizing">
          <LabeledList.Item label="Weight">
            <Button icon="pen" onClick={() => act('weight')}>
              {data.weight}
            </Button>
          </LabeledList.Item>
        </Section>
      </Stack>
    </Section>
  );
};
