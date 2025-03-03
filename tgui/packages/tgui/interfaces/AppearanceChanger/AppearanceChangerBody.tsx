import { useBackend } from 'tgui/backend';
import { Button, ColorBox, LabeledList, Section } from 'tgui-core/components';

import type { Data, species } from './types';

export const AppearanceChangerSpecies = (props) => {
  const { act, data } = useBackend<Data>();
  const { species, specimen } = data;

  const sortedSpecies = (species || []).sort((a: species, b: species) =>
    a.specimen.localeCompare(b.specimen),
  );

  return (
    <Section title="Unique Identifiers" fill scrollable>
      <Section title="Species">
        {sortedSpecies.map((spec) => (
          <Button
            key={spec.specimen}
            selected={specimen === spec.specimen}
            onClick={() => act('race', { race: spec.specimen })}
          >
            {spec.specimen}
          </Button>
        ))}
      </Section>
      <Section title="DNA">
        <LabeledList>
          {data.is_design_console ? (
            <LabeledList.Item label="Character Name">
              <Button icon="pen" onClick={() => act('char_name')}>
                {data.name}
              </Button>
            </LabeledList.Item>
          ) : (
            ''
          )}
          <LabeledList.Item label="Custom Species Name">
            <Button icon="pen" onClick={() => act('race_name')}>
              {data.species_name ? data.species_name : specimen}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Species Appearance">
            <Button
              icon="pen"
              disabled={!data.use_custom_icon}
              onClick={() => act('base_icon')}
            >
              {data.base_icon ? data.base_icon : specimen}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Blood Reagent">
            <Button icon="pen" onClick={() => act('blood_reagent')}>
              {data.blood_reagent}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Blood Color">
            <Button icon="pen" onClick={() => act('blood_color')}>
              {data.blood_color}
            </Button>
            <ColorBox color={data.blood_color} mr={1} />
          </LabeledList.Item>
          <LabeledList.Item label="Digitigrade">
            <Button icon="pen" onClick={() => act('digitigrade')}>
              {data.digitigrade ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
          {/* Disabled until species sounds ported up
          <LabeledList.Item label="Species Sound">
            <Button icon="pen" onClick={() => act('species_sound')}>
              {data.species_sound}
            </Button>
          </LabeledList.Item>
          */}
        </LabeledList>
      </Section>
      <Section title="Sizing">
        <LabeledList.Item label="Scale">
          <Button icon="pen" onClick={() => act('size_scale')}>
            {data.size_scale}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Scale Appearance">
          <Button icon="pen" onClick={() => act('scale_appearance')}>
            {data.scale_appearance}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Scale Offset">
          <Button icon="pen" onClick={() => act('offset_override')}>
            {data.offset_override}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Weight">
          <Button icon="pen" onClick={() => act('weight')}>
            {data.weight}
          </Button>
        </LabeledList.Item>
      </Section>
    </Section>
  );
};

export const AppearanceChangerGender = (props) => {
  const { act, data } = useBackend<Data>();

  const { gender, gender_id, genders, id_genders } = data;

  return (
    <Section title="Gender & Sex" fill scrollable>
      <LabeledList>
        <LabeledList.Item label="Biological Sex">
          {genders.map((g) => (
            <Button
              key={g.gender_key}
              selected={g.gender_key === gender}
              onClick={() => act('gender', { gender: g.gender_key })}
            >
              {g.gender_name}
            </Button>
          ))}
        </LabeledList.Item>
        <LabeledList.Item label="Gender Identity">
          {id_genders.map((g) => (
            <Button
              key={g.gender_key}
              disabled={data.is_design_console}
              selected={g.gender_key === gender_id}
              onClick={() => act('gender_id', { gender_id: g.gender_key })}
            >
              {g.gender_name}
            </Button>
          ))}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
