import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section, Stack } from 'tgui-core/components';

import { Data, species } from './types';

export const AppearanceChangerSpecies = (props) => {
  const { act, data } = useBackend<Data>();
  const { species, specimen } = data;

  const sortedSpecies = (species || []).sort((a: species, b: species) =>
    a.specimen.localeCompare(b.specimen),
  );

  return (
    <Section title="Species" fill scrollable>
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

export const AppearanceChangerEars = (props) => {
  const { act, data } = useBackend<Data>();

  const { ear_style, ear_styles } = data;

  ear_styles.sort((a, b) =>
    a.name.toLowerCase().localeCompare(b.name.toLowerCase()),
  );

  return (
    <Stack vertical fill>
      <Stack.Item grow>
        <Section title="Ears" fill scrollable>
          <Button
            onClick={() => act('ear', { clear: true })}
            selected={ear_style === null}
          >
            -- Not Set --
          </Button>
          {ear_styles.map((ear) => (
            <Button
              key={ear.instance}
              onClick={() => act('ear', { ref: ear.instance })}
              selected={ear.name === ear_style}
            >
              {ear.name}
            </Button>
          ))}
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section title="Ears - Secondary" fill scrollable>
          <Button
            onClick={() => act('ear_secondary', { clear: true })}
            selected={data.ear_secondary_style === null}
          >
            -- Not Set --
          </Button>
          {ear_styles.map((ear) => (
            <Button
              key={ear.instance}
              onClick={() => act('ear_secondary', { ref: ear.instance })}
              selected={ear.name === ear_style}
            >
              {ear.name}
            </Button>
          ))}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

export const AppearanceChangerTails = (props) => {
  const { act, data } = useBackend<Data>();

  const { tail_style, tail_styles } = data;

  tail_styles.sort((a, b) =>
    a.name.toLowerCase().localeCompare(b.name.toLowerCase()),
  );

  return (
    <Section title="Tails" fill scrollable>
      <Button
        onClick={() => act('tail', { clear: true })}
        selected={tail_style === null}
      >
        -- Not Set --
      </Button>
      {tail_styles.map((tail) => (
        <Button
          key={tail.instance}
          onClick={() => act('tail', { ref: tail.instance })}
          selected={tail.name === tail_style}
        >
          {tail.name}
        </Button>
      ))}
    </Section>
  );
};

export const AppearanceChangerWings = (props) => {
  const { act, data } = useBackend<Data>();

  const { wing_style, wing_styles } = data;
  wing_styles.sort((a, b) =>
    a.name.toLowerCase().localeCompare(b.name.toLowerCase()),
  );

  return (
    <Section title="Wings" fill scrollable>
      <Button
        onClick={() => act('wing', { clear: true })}
        selected={wing_style === null}
      >
        -- Not Set --
      </Button>
      {wing_styles.map((wing) => (
        <Button
          key={wing.instance}
          onClick={() => act('wing', { ref: wing.instance })}
          selected={wing.name === wing_style}
        >
          {wing.name}
        </Button>
      ))}
    </Section>
  );
};
