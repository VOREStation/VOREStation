import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section } from 'tgui-core/components';

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
        </LabeledList>
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
