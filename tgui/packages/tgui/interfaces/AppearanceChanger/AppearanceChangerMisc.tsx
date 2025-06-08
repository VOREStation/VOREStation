import { useBackend } from 'tgui/backend';
import {
  Button,
  ColorBox,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';

import type { Data } from './types';

export const AppearanceChangerMisc = (props) => {
  const { act, data } = useBackend<Data>();
  const { specimen } = data;
  return (
    <Section title="Misc" fill scrollable>
      <Stack vertical fill>
        <Section title="Load Currently Selected Savefile">
          <LabeledList.Item label="Load Savefile">
            <Button icon="pen" onClick={() => act('load_saveslot')}>
              {'Load'}
            </Button>
          </LabeledList.Item>
        </Section>
        <Section title="Appearance">
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
          <LabeledList.Item label="Custom Species Name">
            <Button icon="pen" onClick={() => act('race_name')}>
              {data.species_name ? data.species_name : specimen}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Species Sound">
            <Button icon="pen" onClick={() => act('species_sound')}>
              {data.species_sound}
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
        <Section title="Blood">
          <LabeledList.Item label="Blood Reagent">
            <Button icon="pen" onClick={() => act('blood_reagent')}>
              {data.blood_reagent}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Blood Color">
            <Stack align="center">
              <Stack.Item>
                <Button icon="pen" onClick={() => act('blood_color')}>
                  {data.blood_color}
                </Button>
              </Stack.Item>
              <Stack.Item>
                <ColorBox color={data.blood_color} mr={1} />
              </Stack.Item>
            </Stack>
          </LabeledList.Item>
        </Section>
      </Stack>
    </Section>
  );
};
