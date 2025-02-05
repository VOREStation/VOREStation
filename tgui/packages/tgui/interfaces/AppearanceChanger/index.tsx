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
import { Data } from './types';

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
  tab[0] = change_race ? (
    <AppearanceChangerSpecies />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[1] = change_race ? (
    <AppearanceChangerFlavor />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[2] = change_gender ? (
    <AppearanceChangerGender />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[3] = change_color ? (
    <AppearanceChangerColors />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[4] = change_hair ? (
    <AppearanceChangerHair
      key="hair"
      sectionNames={['Hair']}
      possibleStyles={[hair_styles]}
      currentStyle={[hair_style]}
      actions={['hair']}
    />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[5] = change_facial_hair ? (
    <AppearanceChangerHair
      key="facialhair"
      sectionNames={['Facial Hair']}
      possibleStyles={[facial_hair_styles]}
      currentStyle={[facial_hair_style]}
      actions={['facial_hair']}
    />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[6] = change_hair ? (
    <AppearanceChangerParts
      key="ears"
      sectionNames={['Ears', 'Ears - Secondary']}
      possibleStyles={[ear_styles, ear_styles]}
      currentStyle={[ear_style, ear_secondary_style]}
      actions={['ear', 'ear_secondary']}
      canClear
    />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[7] = change_hair ? (
    <AppearanceChangerParts
      key="tail"
      sectionNames={['Tail']}
      possibleStyles={[tail_styles]}
      currentStyle={[tail_style]}
      actions={['tail']}
      canClear
    />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[8] = change_hair ? (
    <AppearanceChangerParts
      key="wings"
      sectionNames={['Wings']}
      possibleStyles={[wing_styles]}
      currentStyle={[wing_style]}
      actions={['wing']}
      canClear
    />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[9] = change_hair ? (
    <AppearanceChangerMarkings />
  ) : (
    <AppearanceChangerDefaultError />
  );

  let firstAccesibleTab = -1;
  if (change_race) {
    firstAccesibleTab = 0;
  } else if (change_gender) {
    firstAccesibleTab = 2;
  } else if (change_color) {
    firstAccesibleTab = 3;
  } else if (change_hair) {
    firstAccesibleTab = 4;
  } else if (change_facial_hair) {
    firstAccesibleTab = 5;
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
                    selected={tabIndex === 0}
                    onClick={() => setTabIndex(0)}
                  >
                    Race
                  </Tabs.Tab>
                ) : null}
                {change_race ? (
                  <Tabs.Tab
                    selected={tabIndex === 1}
                    onClick={() => setTabIndex(1)}
                  >
                    Flavor
                  </Tabs.Tab>
                ) : null}
                {change_gender ? (
                  <Tabs.Tab
                    selected={tabIndex === 2}
                    onClick={() => setTabIndex(2)}
                  >
                    Gender & Sex
                  </Tabs.Tab>
                ) : null}
                {change_color ? (
                  <Tabs.Tab
                    selected={tabIndex === 3}
                    onClick={() => setTabIndex(3)}
                  >
                    Colors
                  </Tabs.Tab>
                ) : null}
                {change_hair ? (
                  <Tabs.Tab
                    selected={tabIndex === 4}
                    onClick={() => setTabIndex(4)}
                  >
                    Hair
                  </Tabs.Tab>
                ) : null}
                {change_facial_hair ? (
                  <Tabs.Tab
                    selected={tabIndex === 5}
                    onClick={() => setTabIndex(5)}
                  >
                    Facial Hair
                  </Tabs.Tab>
                ) : null}
                {change_hair ? (
                  <>
                    <Tabs.Tab
                      selected={tabIndex === 6}
                      onClick={() => setTabIndex(6)}
                    >
                      Ear
                    </Tabs.Tab>
                    <Tabs.Tab
                      selected={tabIndex === 7}
                      onClick={() => setTabIndex(7)}
                    >
                      Tail
                    </Tabs.Tab>
                    <Tabs.Tab
                      selected={tabIndex === 8}
                      onClick={() => setTabIndex(8)}
                    >
                      Wing
                    </Tabs.Tab>
                    <Tabs.Tab
                      selected={tabIndex === 9}
                      onClick={() => setTabIndex(9)}
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
