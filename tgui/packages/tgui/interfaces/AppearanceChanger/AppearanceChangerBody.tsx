import { sortBy } from 'common/collections';

import { useBackend } from '../../backend';
import { Button, LabeledList, Section, Stack } from '../../components';
import { Data, species, styles } from './types';

export const AppearanceChangerSpecies = (props) => {
  const { act, data } = useBackend<Data>();
  const { species, specimen } = data;

  const sortedSpecies = sortBy(species || [], (val: species) => val.specimen);

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

  return (
    <Stack vertical fill>
      <Stack.Item grow={1}>
        <Section title="Ears" fill scrollable>
          <Button
            onClick={() => act('ear', { clear: true })}
            selected={ear_style === null}
          >
            -- Not Set --
          </Button>
          {sortBy(ear_styles, (e: styles) => e.name.toLowerCase()).map(
            (ear) => (
              <Button
                key={ear.instance}
                onClick={() => act('ear', { ref: ear.instance })}
                selected={ear.name === ear_style}
              >
                {ear.name}
              </Button>
            ),
          )}
        </Section>
      </Stack.Item>
      <Stack.Item grow={1}>
        <Section title="Ears - Secondary" fill scrollable>
          <Button
            onClick={() => act('ear_secondary', { clear: true })}
            selected={data.ear_secondary_style === null}
          >
            -- Not Set --
          </Button>
          {sortBy(ear_styles, (e: styles) => e.name.toLowerCase()).map(
            (ear) => (
              <Button
                key={ear.instance}
                onClick={() => act('ear_secondary', { ref: ear.instance })}
                selected={ear.name === ear_style}
              >
                {ear.name}
              </Button>
            ),
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

export const AppearanceChangerTails = (props) => {
  const { act, data } = useBackend<Data>();

  const { tail_style, tail_styles } = data;

  return (
    <Section title="Tails" fill scrollable>
      <Button
        onClick={() => act('tail', { clear: true })}
        selected={tail_style === null}
      >
        -- Not Set --
      </Button>
      {sortBy(tail_styles, (e: styles) => e.name.toLowerCase()).map((tail) => (
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

  return (
    <Section title="Wings" fill scrollable>
      <Button
        onClick={() => act('wing', { clear: true })}
        selected={wing_style === null}
      >
        -- Not Set --
      </Button>
      {sortBy(wing_styles, (e: styles) => e.name.toLowerCase()).map((wing) => (
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
