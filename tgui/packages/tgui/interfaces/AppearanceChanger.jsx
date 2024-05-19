import { sortBy } from 'common/collections';
import { capitalize, decodeHtmlEntities } from 'common/string';
import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  ByondUi,
  ColorBox,
  Flex,
  LabeledList,
  Section,
  Tabs,
} from '../components';
import { Window } from '../layouts';

export const AppearanceChanger = (props) => {
  const { act, config, data } = useBackend();

  const {
    name,
    specimen,
    gender,
    gender_id,
    hair_style,
    facial_hair_style,
    ear_style,
    tail_style,
    wing_style,
    markings,
    change_race,
    change_gender,
    change_eye_color,
    change_skin_tone,
    change_skin_color,
    change_hair_color,
    change_facial_hair_color,
    change_hair,
    change_facial_hair,
    mapRef,
  } = data;

  const { title } = config;

  const change_color =
    change_eye_color ||
    change_skin_tone ||
    change_skin_color ||
    change_hair_color ||
    change_facial_hair_color;

  let firstAccesibleTab = -1;
  if (change_race) {
    firstAccesibleTab = 0;
  } else if (change_gender) {
    firstAccesibleTab = 1;
  } else if (change_color) {
    firstAccesibleTab = 2;
  } else if (change_hair) {
    firstAccesibleTab = 4;
  } else if (change_facial_hair) {
    firstAccesibleTab = 5;
  }

  const [tabIndex, setTabIndex] = useState(firstAccesibleTab);

  return (
    <Window width={700} height={650} title={decodeHtmlEntities(title)}>
      <Window.Content>
        <Section title="Reflection">
          <Flex>
            <Flex.Item grow={1}>
              <LabeledList>
                <LabeledList.Item label="Name">{name}</LabeledList.Item>
                <LabeledList.Item
                  label="Species"
                  color={!change_race ? 'grey' : null}
                >
                  {specimen}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Biological Sex"
                  color={!change_gender ? 'grey' : null}
                >
                  {gender ? capitalize(gender) : 'Not Set'}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Gender Identity"
                  color={!change_color ? 'grey' : null}
                >
                  {gender_id ? capitalize(gender_id) : 'Not Set'}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Hair Style"
                  color={!change_hair ? 'grey' : null}
                >
                  {hair_style ? capitalize(hair_style) : 'Not Set'}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Facial Hair Style"
                  color={!change_facial_hair ? 'grey' : null}
                >
                  {facial_hair_style
                    ? capitalize(facial_hair_style)
                    : 'Not Set'}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Ear Style"
                  color={!change_hair ? 'grey' : null}
                >
                  {ear_style ? capitalize(ear_style) : 'Not Set'}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Tail Style"
                  color={!change_hair ? 'grey' : null}
                >
                  {tail_style ? capitalize(tail_style) : 'Not Set'}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Wing Style"
                  color={!change_hair ? 'grey' : null}
                >
                  {wing_style ? capitalize(wing_style) : 'Not Set'}
                </LabeledList.Item>
              </LabeledList>
            </Flex.Item>
            <Flex.Item>
              <ByondUi
                style={{
                  width: '256px',
                  height: '256px',
                }}
                params={{
                  id: mapRef,
                  type: 'map',
                }}
              />
            </Flex.Item>
          </Flex>
        </Section>
        <Tabs>
          {change_race ? (
            <Tabs.Tab selected={tabIndex === 0} onClick={() => setTabIndex(0)}>
              Race
            </Tabs.Tab>
          ) : null}
          {change_gender ? (
            <Tabs.Tab selected={tabIndex === 1} onClick={() => setTabIndex(1)}>
              Gender & Sex
            </Tabs.Tab>
          ) : null}
          {change_color ? (
            <Tabs.Tab selected={tabIndex === 2} onClick={() => setTabIndex(2)}>
              Colors
            </Tabs.Tab>
          ) : null}
          {change_hair ? (
            <>
              <Tabs.Tab
                selected={tabIndex === 3}
                onClick={() => setTabIndex(3)}
              >
                Hair
              </Tabs.Tab>
              <Tabs.Tab
                selected={tabIndex === 5}
                onClick={() => setTabIndex(5)}
              >
                Ear
              </Tabs.Tab>
              <Tabs.Tab
                selected={tabIndex === 6}
                onClick={() => setTabIndex(6)}
              >
                Tail
              </Tabs.Tab>
              <Tabs.Tab
                selected={tabIndex === 7}
                onClick={() => setTabIndex(7)}
              >
                Wing
              </Tabs.Tab>
              <Tabs.Tab
                selected={tabIndex === 8}
                onClick={() => setTabIndex(8)}
              >
                Markings
              </Tabs.Tab>
            </>
          ) : null}
          {change_facial_hair ? (
            <Tabs.Tab selected={tabIndex === 4} onClick={() => setTabIndex(4)}>
              Facial Hair
            </Tabs.Tab>
          ) : null}
        </Tabs>
        <Box height="43%">
          {change_race && tabIndex === 0 ? <AppearanceChangerSpecies /> : null}
          {change_gender && tabIndex === 1 ? <AppearanceChangerGender /> : null}
          {change_color && tabIndex === 2 ? <AppearanceChangerColors /> : null}
          {change_hair && tabIndex === 3 ? <AppearanceChangerHair /> : null}
          {change_facial_hair && tabIndex === 4 ? (
            <AppearanceChangerFacialHair />
          ) : null}
          {change_hair && tabIndex === 5 ? <AppearanceChangerEars /> : null}
          {change_hair && tabIndex === 6 ? <AppearanceChangerTails /> : null}
          {change_hair && tabIndex === 7 ? <AppearanceChangerWings /> : null}
          {change_hair && tabIndex === 8 ? <AppearanceChangerMarkings /> : null}
        </Box>
      </Window.Content>
    </Window>
  );
};

const AppearanceChangerSpecies = (props) => {
  const { act, data } = useBackend();
  const { species, specimen } = data;

  const sortedSpecies = sortBy((val) => val.specimen)(species || []);

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

const AppearanceChangerGender = (props) => {
  const { act, data } = useBackend();

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

const AppearanceChangerColors = (props) => {
  const { act, data } = useBackend();

  const {
    change_eye_color,
    change_skin_tone,
    change_skin_color,
    change_hair_color,
    change_facial_hair_color,
    eye_color,
    skin_color,
    hair_color,
    facial_hair_color,
    ears_color,
    ears2_color,
    tail_color,
    tail2_color,
    wing_color,
    wing2_color,
  } = data;

  return (
    <Section title="Colors" fill scrollable>
      {change_eye_color ? (
        <Box>
          <ColorBox color={eye_color} mr={1} />
          <Button onClick={() => act('eye_color')}>Change Eye Color</Button>
        </Box>
      ) : null}
      {change_skin_tone ? (
        <Box>
          <Button onClick={() => act('skin_tone')}>Change Skin Tone</Button>
        </Box>
      ) : null}
      {change_skin_color ? (
        <Box>
          <ColorBox color={skin_color} mr={1} />
          <Button onClick={() => act('skin_color')}>Change Skin Color</Button>
        </Box>
      ) : null}
      {change_hair_color ? (
        <>
          <Box>
            <ColorBox color={hair_color} mr={1} />
            <Button onClick={() => act('hair_color')}>Change Hair Color</Button>
          </Box>
          <Box>
            <ColorBox color={ears_color} mr={1} />
            <Button onClick={() => act('ears_color')}>Change Ears Color</Button>
          </Box>
          <Box>
            <ColorBox color={ears2_color} mr={1} />
            <Button onClick={() => act('ears2_color')}>
              Change Secondary Ears Color
            </Button>
          </Box>
          <Box>
            <ColorBox color={tail_color} mr={1} />
            <Button onClick={() => act('tail_color')}>Change Tail Color</Button>
          </Box>
          <Box>
            <ColorBox color={tail2_color} mr={1} />
            <Button onClick={() => act('tail2_color')}>
              Change Secondary Tail Color
            </Button>
          </Box>
          <Box>
            <ColorBox color={wing_color} mr={1} />
            <Button onClick={() => act('wing_color')}>Change Wing Color</Button>
          </Box>
          <Box>
            <ColorBox color={wing2_color} mr={1} />
            <Button onClick={() => act('wing2_color')}>
              Change Secondary Wing Color
            </Button>
          </Box>
        </>
      ) : null}
      {change_facial_hair_color ? (
        <Box>
          <ColorBox color={facial_hair_color} mr={1} />
          <Button onClick={() => act('facial_hair_color')}>
            Change Facial Hair Color
          </Button>
        </Box>
      ) : null}
    </Section>
  );
};

const AppearanceChangerHair = (props) => {
  const { act, data } = useBackend();

  const { hair_style, hair_styles } = data;

  return (
    <Section title="Hair" fill scrollable>
      {hair_styles.map((hair) => (
        <Button
          key={hair.hairstyle}
          onClick={() => act('hair', { hair: hair.hairstyle })}
          selected={hair.hairstyle === hair_style}
        >
          {hair.hairstyle}
        </Button>
      ))}
    </Section>
  );
};

const AppearanceChangerFacialHair = (props) => {
  const { act, data } = useBackend();

  const { facial_hair_style, facial_hair_styles } = data;

  return (
    <Section title="Facial Hair" fill scrollable>
      {facial_hair_styles.map((hair) => (
        <Button
          key={hair.facialhairstyle}
          onClick={() =>
            act('facial_hair', { facial_hair: hair.facialhairstyle })
          }
          selected={hair.facialhairstyle === facial_hair_style}
        >
          {hair.facialhairstyle}
        </Button>
      ))}
    </Section>
  );
};

const AppearanceChangerEars = (props) => {
  const { act, data } = useBackend();

  const { ear_style, ear_styles } = data;

  return (
    <Section title="Ears" fill scrollable>
      <Button
        onClick={() => act('ear', { clear: true })}
        selected={ear_style === null}
      >
        -- Not Set --
      </Button>
      {sortBy((e) => e.name.toLowerCase())(ear_styles).map((ear) => (
        <Button
          key={ear.instance}
          onClick={() => act('ear', { ref: ear.instance })}
          selected={ear.name === ear_style}
        >
          {ear.name}
        </Button>
      ))}
    </Section>
  );
};

const AppearanceChangerTails = (props) => {
  const { act, data } = useBackend();

  const { tail_style, tail_styles } = data;

  return (
    <Section title="Tails" fill scrollable>
      <Button
        onClick={() => act('tail', { clear: true })}
        selected={tail_style === null}
      >
        -- Not Set --
      </Button>
      {sortBy((e) => e.name.toLowerCase())(tail_styles).map((tail) => (
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

const AppearanceChangerWings = (props) => {
  const { act, data } = useBackend();

  const { wing_style, wing_styles } = data;

  return (
    <Section title="Wings" fill scrollable>
      <Button
        onClick={() => act('wing', { clear: true })}
        selected={wing_style === null}
      >
        -- Not Set --
      </Button>
      {sortBy((e) => e.name.toLowerCase())(wing_styles).map((wing) => (
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

const AppearanceChangerMarkings = (props) => {
  const { act, data } = useBackend();

  const { markings } = data;

  return (
    <Section title="Markings" fill scrollable>
      <Box>
        <Button onClick={() => act('marking', { todo: 1, name: 'na' })}>
          Add Marking
        </Button>
      </Box>
      <LabeledList>
        {markings.map((m) => (
          <LabeledList.Item key={m.marking_name} label={m.marking_name}>
            <ColorBox color={m.marking_color} mr={1} />
            <Button
              onClick={() => act('marking', { todo: 4, name: m.marking_name })}
            >
              Change Color
            </Button>
            <Button
              onClick={() => act('marking', { todo: 0, name: m.marking_name })}
            >
              -
            </Button>
            <Button
              onClick={() => act('marking', { todo: 3, name: m.marking_name })}
            >
              Move down
            </Button>
            <Button
              onClick={() => act('marking', { todo: 2, name: m.marking_name })}
            >
              Move up
            </Button>
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};
