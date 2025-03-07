import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  ByondUi,
  LabeledList,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { capitalize, decodeHtmlEntities } from 'tgui-core/string';

import {
  AppearanceChangerGender,
  AppearanceChangerSpecies,
} from './AppearanceChangerBody';
import { AppearanceChangerBodyRecords } from './AppearanceChangerBodyRecords';
import {
  AppearanceChangerColors,
  AppearanceChangerMarkings,
} from './AppearanceChangerDetails';
import { AppearanceChangerFlavor } from './AppearanceChangerFlavor';
import { AppearanceChangerHeader } from './AppearanceChangerHeader';
import {
  AppearanceChangerHair,
  AppearanceChangerParts,
} from './AppearanceChangerParts';
import {
  TAB_COLORS,
  TAB_EARS,
  TAB_EARS2,
  TAB_FACIAL_HAIR,
  TAB_FLAVOR,
  TAB_GENDER,
  TAB_HAIR,
  TAB_MARKINGS,
  TAB_RACE,
  TAB_TAIL,
  TAB_WINGS,
} from './constants';
import type { Data } from './types';

export const AppearanceChanger = (props) => {
  const { act, config, data } = useBackend<Data>();

  const {
    name,
    specimen,
    gender,
    gender_id,
    hair_style,
    hair_styles,
    facial_hair_style,
    facial_hair_styles,
    ear_style,
    ear_styles,
    ear_secondary_style,
    tail_style,
    tail_styles,
    wing_style,
    wing_styles,
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
    is_design_console,
    selected_a_record,
  } = data;

  const { title } = config;

  const tab: React.JSX.Element[] = [];

  const change_color =
    change_eye_color ||
    change_skin_tone ||
    change_skin_color ||
    change_hair_color ||
    change_facial_hair_color;

  tab[-1] = <AppearanceChangerDefaultError />;
  tab[TAB_RACE] = change_race ? (
    <AppearanceChangerSpecies />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[TAB_FLAVOR] = change_race ? (
    <AppearanceChangerFlavor />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[TAB_GENDER] = change_gender ? (
    <AppearanceChangerGender />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[TAB_COLORS] = change_color ? (
    <AppearanceChangerColors />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[TAB_HAIR] = change_hair ? (
    <AppearanceChangerHair
      key={TAB_HAIR}
      sectionNames={['Hair']}
      possibleStyles={[hair_styles]}
      currentStyle={[hair_style]}
      actions={['hair']}
    />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[TAB_FACIAL_HAIR] = change_facial_hair ? (
    <AppearanceChangerHair
      key={TAB_FACIAL_HAIR}
      sectionNames={['Facial Hair']}
      possibleStyles={[facial_hair_styles]}
      currentStyle={[facial_hair_style]}
      actions={['facial_hair']}
    />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[TAB_EARS] = change_hair ? (
    <AppearanceChangerParts
      key={TAB_EARS}
      sectionNames={['Ears']}
      possibleStyles={[ear_styles]}
      currentStyle={[ear_style]}
      actions={['ear']}
      canClear
    />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[TAB_EARS2] = change_hair ? (
    <AppearanceChangerParts
      key={TAB_EARS2}
      sectionNames={['Ears - Secondary']}
      possibleStyles={[ear_styles]}
      currentStyle={[ear_secondary_style]}
      actions={['ear_secondary']}
      canClear
    />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[TAB_TAIL] = change_hair ? (
    <AppearanceChangerParts
      key={TAB_TAIL}
      sectionNames={['Tail']}
      possibleStyles={[tail_styles]}
      currentStyle={[tail_style]}
      actions={['tail']}
      canClear
    />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[TAB_WINGS] = change_hair ? (
    <AppearanceChangerParts
      key={TAB_WINGS}
      sectionNames={['Wings']}
      possibleStyles={[wing_styles]}
      currentStyle={[wing_style]}
      actions={['wing']}
      canClear
    />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[TAB_MARKINGS] = change_hair ? (
    <AppearanceChangerMarkings />
  ) : (
    <AppearanceChangerDefaultError />
  );

  let firstAccesibleTab = -1;
  if (change_race) {
    firstAccesibleTab = TAB_RACE;
  } else if (change_gender) {
    firstAccesibleTab = TAB_GENDER;
  } else if (change_color) {
    firstAccesibleTab = TAB_COLORS;
  } else if (change_hair) {
    firstAccesibleTab = TAB_HAIR;
  } else if (change_facial_hair) {
    firstAccesibleTab = TAB_FACIAL_HAIR;
  }

  const [tabIndex, setTabIndex] = useState(firstAccesibleTab);

  return (
    <Window width={700} height={850} title={decodeHtmlEntities(title)}>
      {is_design_console && !selected_a_record ? (
        <Window.Content>
          <AppearanceChangerHeader />
          <AppearanceChangerBodyRecords />
        </Window.Content>
      ) : (
        <Window.Content>
          <Stack vertical fill>
            <Stack.Item>
              {is_design_console ? <AppearanceChangerHeader /> : ''}
              <Section title="Reflection">
                <Stack fill>
                  <Stack.Item grow>
                    <Stack fill vertical>
                      <Stack.Item grow>
                        <LabeledList>
                          <LabeledList.Item label="Name">
                            {name}
                          </LabeledList.Item>
                          <LabeledList.Item
                            label="Species"
                            color={!change_race ? 'grey' : undefined}
                          >
                            {specimen}
                          </LabeledList.Item>
                          <LabeledList.Item
                            label="Biological Sex"
                            color={!change_gender ? 'grey' : undefined}
                          >
                            {gender ? capitalize(gender) : 'Not Set'}
                          </LabeledList.Item>
                          <LabeledList.Item
                            label="Gender Identity"
                            color={!change_color ? 'grey' : undefined}
                          >
                            {gender_id ? capitalize(gender_id) : 'Not Set'}
                          </LabeledList.Item>
                          <LabeledList.Item
                            label="Hair Style"
                            color={!change_hair ? 'grey' : undefined}
                          >
                            {hair_style ? capitalize(hair_style) : 'Not Set'}
                          </LabeledList.Item>
                          <LabeledList.Item
                            label="Facial Hair Style"
                            color={!change_facial_hair ? 'grey' : undefined}
                          >
                            {facial_hair_style
                              ? capitalize(facial_hair_style)
                              : 'Not Set'}
                          </LabeledList.Item>
                          <LabeledList.Item
                            label="Ear Style"
                            color={!change_hair ? 'grey' : undefined}
                          >
                            {ear_style ? capitalize(ear_style) : 'Not Set'}
                          </LabeledList.Item>
                          <LabeledList.Item
                            label="Tail Style"
                            color={!change_hair ? 'grey' : undefined}
                          >
                            {tail_style ? capitalize(tail_style) : 'Not Set'}
                          </LabeledList.Item>
                          <LabeledList.Item
                            label="Wing Style"
                            color={!change_hair ? 'grey' : undefined}
                          >
                            {wing_style ? capitalize(wing_style) : 'Not Set'}
                          </LabeledList.Item>
                        </LabeledList>
                      </Stack.Item>
                      <Stack.Item>
                        <Stack fill>
                          <Stack.Item grow />
                          <Stack.Item>
                            <Button onClick={() => act('rotate_view')}>
                              Rotate Preview
                            </Button>
                          </Stack.Item>
                        </Stack>
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                  <Stack.Item>
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
                  </Stack.Item>
                </Stack>
              </Section>
              <Tabs>
                {change_race ? (
                  <Tabs.Tab
                    selected={tabIndex === TAB_RACE}
                    onClick={() => setTabIndex(TAB_RACE)}
                  >
                    Race
                  </Tabs.Tab>
                ) : null}
                {change_race ? (
                  <Tabs.Tab
                    selected={tabIndex === TAB_FLAVOR}
                    onClick={() => setTabIndex(TAB_FLAVOR)}
                  >
                    Flavor
                  </Tabs.Tab>
                ) : null}
                {change_gender ? (
                  <Tabs.Tab
                    selected={tabIndex === TAB_GENDER}
                    onClick={() => setTabIndex(TAB_GENDER)}
                  >
                    Gender & Sex
                  </Tabs.Tab>
                ) : null}
                {change_color ? (
                  <Tabs.Tab
                    selected={tabIndex === TAB_COLORS}
                    onClick={() => setTabIndex(TAB_COLORS)}
                  >
                    Colors
                  </Tabs.Tab>
                ) : null}
                {change_hair ? (
                  <Tabs.Tab
                    selected={tabIndex === TAB_HAIR}
                    onClick={() => setTabIndex(TAB_HAIR)}
                  >
                    Hair
                  </Tabs.Tab>
                ) : null}
                {change_facial_hair ? (
                  <Tabs.Tab
                    selected={tabIndex === TAB_FACIAL_HAIR}
                    onClick={() => setTabIndex(TAB_FACIAL_HAIR)}
                  >
                    Facial Hair
                  </Tabs.Tab>
                ) : null}
                {change_hair ? (
                  <>
                    <Tabs.Tab
                      selected={tabIndex === TAB_EARS}
                      onClick={() => setTabIndex(TAB_EARS)}
                    >
                      Ears
                    </Tabs.Tab>
                    <Tabs.Tab
                      selected={tabIndex === TAB_EARS2}
                      onClick={() => setTabIndex(TAB_EARS2)}
                    >
                      Ears Secondary
                    </Tabs.Tab>
                    <Tabs.Tab
                      selected={tabIndex === TAB_TAIL}
                      onClick={() => setTabIndex(TAB_TAIL)}
                    >
                      Tail
                    </Tabs.Tab>
                    <Tabs.Tab
                      selected={tabIndex === TAB_WINGS}
                      onClick={() => setTabIndex(TAB_WINGS)}
                    >
                      Wings
                    </Tabs.Tab>
                    <Tabs.Tab
                      selected={tabIndex === TAB_MARKINGS}
                      onClick={() => setTabIndex(TAB_MARKINGS)}
                    >
                      Markings
                    </Tabs.Tab>
                  </>
                ) : null}
              </Tabs>
            </Stack.Item>
            <Stack.Item grow>{tab[tabIndex]}</Stack.Item>
          </Stack>
        </Window.Content>
      )}
    </Window>
  );
};

export const AppearanceChangerDefaultError = (props) => {
  return <Box textColor="red">Disabled</Box>;
};
