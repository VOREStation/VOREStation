import { capitalize, decodeHtmlEntities } from 'common/string';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Flex, LabeledList, Section, Tabs } from 'tgui/components';
import { Window } from 'tgui/layouts';
import { ByondUi } from 'tgui-core/components';

import {
  AppearanceChangerEars,
  AppearanceChangerGender,
  AppearanceChangerSpecies,
  AppearanceChangerTails,
  AppearanceChangerWings,
} from './AppearanceChangerBody';
import {
  AppearanceChangerColors,
  AppearanceChangerMarkings,
} from './AppearanceChangerDetails';
import {
  AppearanceChangerFacialHair,
  AppearanceChangerHair,
} from './AppearanceChangerHairs';
import { Data } from './types';

export const AppearanceChanger = (props) => {
  const { act, config, data } = useBackend<Data>();

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

  const tab: React.JSX.Element[] = [];

  const change_color =
    change_eye_color ||
    change_skin_tone ||
    change_skin_color ||
    change_hair_color ||
    change_facial_hair_color;

  const disabled = <Box />;

  tab[-1] = <AppearanceChangerDefaultError />;
  tab[0] = change_race ? (
    <AppearanceChangerSpecies />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[1] = change_gender ? (
    <AppearanceChangerGender />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[2] = change_color ? (
    <AppearanceChangerColors />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[3] = change_hair ? (
    <AppearanceChangerHair />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[4] = change_facial_hair ? (
    <AppearanceChangerFacialHair />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[5] = change_hair ? (
    <AppearanceChangerEars />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[6] = change_hair ? (
    <AppearanceChangerTails />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[7] = change_hair ? (
    <AppearanceChangerWings />
  ) : (
    <AppearanceChangerDefaultError />
  );
  tab[8] = change_hair ? (
    <AppearanceChangerMarkings />
  ) : (
    <AppearanceChangerDefaultError />
  );

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
        <Box height="43%">{tab[tabIndex]}</Box>
      </Window.Content>
    </Window>
  );
};

export const AppearanceChangerDefaultError = (props) => {
  return <Box textColor="red">Disabled</Box>;
};
