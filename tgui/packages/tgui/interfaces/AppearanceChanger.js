import { filter, sortBy } from 'common/collections';
import { capitalize, decodeHtmlEntities } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from "../backend";
import { Box, Button, ByondUi, Flex, Icon, LabeledList, ProgressBar, Section, Tabs, ColorBox } from "../components";
import { Window } from "../layouts";

export const AppearanceChanger = (props, context) => {
  const { act, config, data } = useBackend(context);

  const {
    name,
    specimen,
    gender,
    gender_id,
    hair_style,
    facial_hair_style,
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

  const {
    title,
  } = config;

  const change_color = change_eye_color
    || change_skin_tone
    || change_skin_color
    || change_hair_color
    || change_facial_hair_color;

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

  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', firstAccesibleTab);

  return (
    <Window width={700} height={650} title={decodeHtmlEntities(title)}>
      <Window.Content>
        <Section title="Reflection">
          <Flex>
            <Flex.Item grow={1}>
              <LabeledList>
                <LabeledList.Item label="Name">
                  {name}
                </LabeledList.Item>
                <LabeledList.Item label="Species" color={!change_race ? "grey" : null}>
                  {specimen}
                </LabeledList.Item>
                <LabeledList.Item label="Biological Sex" color={!change_gender ? "grey" : null}>
                  {capitalize(gender)}
                </LabeledList.Item>
                <LabeledList.Item label="Gender Identity" color={!change_color ? "grey" : null}>
                  {capitalize(gender_id)}
                </LabeledList.Item>
                <LabeledList.Item label="Hair Style" color={!change_hair ? "grey" : null}>
                  {capitalize(hair_style)}
                </LabeledList.Item>
                <LabeledList.Item label="Facial Hair Style" color={!change_facial_hair ? "grey" : null}>
                  {capitalize(facial_hair_style)}
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
                }} />
            </Flex.Item>
          </Flex>
        </Section>
        <Tabs>
          {change_race ? (
            <Tabs.Tab
              selected={tabIndex === 0}
              onClick={() => setTabIndex(0)}>
              Race
            </Tabs.Tab>
          ) : null}
          {change_gender ? (
            <Tabs.Tab
              selected={tabIndex === 1}
              onClick={() => setTabIndex(1)}>
              Gender & Sex
            </Tabs.Tab>
          ) : null}
          {change_color ? (
            <Tabs.Tab
              selected={tabIndex === 2}
              onClick={() => setTabIndex(2)}>
              Colors
            </Tabs.Tab>
          ) : null}
          {change_hair ? (
            <Tabs.Tab
              selected={tabIndex === 3}
              onClick={() => setTabIndex(3)}>
              Hair
            </Tabs.Tab>
          ) : null}
          {change_facial_hair ? (
            <Tabs.Tab
              selected={tabIndex === 4}
              onClick={() => setTabIndex(4)}>
              Facial Hair
            </Tabs.Tab>
          ) : null}
        </Tabs>
        <Box height="43%">
          {(change_race && tabIndex === 0) ? <AppearanceChangerSpecies /> : null}
          {(change_gender && tabIndex === 1) ? <AppearanceChangerGender /> : null}
          {(change_color && tabIndex === 2) ? <AppearanceChangerColors /> : null}
          {(change_hair && tabIndex === 3) ? <AppearanceChangerHair /> : null}
          {(change_facial_hair && tabIndex === 4) ? <AppearanceChangerFacialHair /> : null}
        </Box>
      </Window.Content>
    </Window>
  );
};

const AppearanceChangerSpecies = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    species,
    specimen,
  } = data;

  const sortedSpecies = sortBy(val => val.specimen)(species || []);

  return (
    <Section title="Species" fill scrollable>
      {sortedSpecies.map(spec => (
        <Button
          key={spec.specimen}
          content={spec.specimen}
          selected={specimen === spec.specimen}
          onClick={() => act("race", { race: spec.specimen })} />
      ))}
    </Section>
  );
};

const AppearanceChangerGender = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    gender,
    gender_id,
    genders,
    id_genders,
  } = data;

  return (
    <Section title="Gender & Sex" fill scrollable>
      <LabeledList>
        <LabeledList.Item label="Biological Sex">
          {genders.map(g => (
            <Button
              key={g.gender_key}
              selected={g.gender_key === gender}
              content={g.gender_name}
              onClick={() => act("gender", { "gender": g.gender_key })} />
          ))}
        </LabeledList.Item>
        <LabeledList.Item label="Gender Identity">
          {id_genders.map(g => (
            <Button
              key={g.gender_key}
              selected={g.gender_key === gender_id}
              content={g.gender_name}
              onClick={() => act("gender_id", { "gender_id": g.gender_key })} />
          ))}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const AppearanceChangerColors = (props, context) => {
  const { act, data } = useBackend(context);

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
  } = data;

  return (
    <Section title="Colors" fill scrollable>
      {change_eye_color ? (
        <Box>
          <ColorBox color={eye_color} mr={1} />
          <Button content="Change Eye Color" onClick={() => act("eye_color")} />
        </Box>
      ) : null}
      {change_skin_tone ? (
        <Box>
          <Button content="Change Skin Tone" onClick={() => act("skin_tone")} />
        </Box>
      ) : null}
      {change_skin_color ? (
        <Box>
          <ColorBox color={skin_color} mr={1} />
          <Button content="Change Skin Color" onClick={() => act("skin_color")} />
        </Box>
      ) : null}
      {change_hair_color ? (
        <Box>
          <ColorBox color={hair_color} mr={1} />
          <Button content="Change Hair Color" onClick={() => act("hair_color")} />
        </Box>
      ) : null}
      {change_facial_hair_color ? (
        <Box>
          <ColorBox color={facial_hair_color} mr={1} />
          <Button content="Change Facial Hair Color" onClick={() => act("facial_hair_color")} />
        </Box>
      ) : null}
    </Section>
  );
};

const AppearanceChangerHair = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    hair_style,
    hair_styles,
  } = data;

  return (
    <Section title="Hair" fill scrollable>
      {hair_styles.map(hair => (
        <Button 
          key={hair.hairstyle}
          onClick={() => act("hair", { hair: hair.hairstyle })}
          selected={hair.hairstyle === hair_style}
          content={hair.hairstyle} />
      ))}
    </Section>
  );
};

const AppearanceChangerFacialHair = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    facial_hair_style,
    facial_hair_styles,
  } = data;

  return (
    <Section title="Facial Hair" fill scrollable>
      {facial_hair_styles.map(hair => (
        <Button 
          key={hair.facialhairstyle}
          onClick={() => act("facial_hair", { facial_hair: hair.facialhairstyle })}
          selected={hair.facialhairstyle === facial_hair_style}
          content={hair.facialhairstyle} />
      ))}
    </Section>
  );
};