import { Fragment } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  ColorBox,
  Divider,
  Floating,
  LabeledList,
  Stack,
  Tooltip,
} from 'tgui-core/components';

import {
  Gender,
  type GeneralData,
  type GeneralDataConstant,
  type GeneralDataStatic,
} from './data';

export const gender2icon = (gender: Gender) => {
  switch (gender) {
    case Gender.Female: {
      return 'venus';
    }
    case Gender.Male: {
      return 'mars';
    }
    case Gender.Plural: {
      return 'transgender';
    }
    case Gender.Neuter: {
      return 'neuter';
    }
  }
};

export const gender2pronouns = (gender: Gender) => {
  switch (gender) {
    case Gender.Female: {
      return 'She/Her';
    }
    case Gender.Male: {
      return 'He/Him';
    }
    case Gender.Plural: {
      return 'They/Them';
    }
    case Gender.Neuter: {
      return 'It/Its';
    }
  }
};

export const GenderButton = (props: {
  gender: Gender;
  usePronouns?: boolean;
  setGender: (gender: Gender) => void;
}) => {
  return (
    <Box width={4}>
      <Floating
        placement="right-end"
        content={
          <Stack backgroundColor="black" ml={0.5} pl={0.5} pr={0.5}>
            {Object.keys(Gender).map((x) => (
              <Button
                selected={props.gender === x}
                key={x}
                icon={gender2icon(x as Gender)}
                tooltip={props.usePronouns ? gender2pronouns(x as Gender) : x}
                fontSize="22px"
                width={4}
                height={4}
                verticalAlignContent="middle"
                textAlign="center"
                onClick={() => props.setGender(x as Gender)}
              />
            ))}
          </Stack>
        }
      >
        <Button
          icon={gender2icon(props.gender)}
          tooltipPosition="top"
          verticalAlignContent="middle"
          textAlign="center"
        >
          {props.usePronouns ? gender2pronouns(props.gender) : props.gender}
        </Button>
      </Floating>
    </Box>
  );
};

export const SubtabInfo = (props: {
  data: GeneralData;
  staticData: GeneralDataStatic;
  serverData: GeneralDataConstant;
}) => {
  const { act } = useBackend();
  const { data, staticData, serverData } = props;
  const {
    age,
    bday_day,
    bday_month,
    bday_announce,
    languages,
    languages_can_add,
    language_keys,
    preferred_language,
    runechat_color,
    vore_egg_type,
    autohiss,
    custom_species,
    selects_bodytype,
    custom_base,
  } = data;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Stack justify="space-between">
          <Stack.Item>
            <LabeledList>
              <LabeledList.Item label="Real Name">
                <Button onClick={() => act('rename')}>{data.real_name}</Button>
                <Button
                  onClick={() => act('random_name')}
                  icon="dice"
                  tooltip="Random Name"
                />
                <Button.Checkbox
                  checked={data.be_random_name}
                  selected={data.be_random_name}
                  onClick={() => act('always_random_name')}
                  tooltip="Always Randomize"
                />
              </LabeledList.Item>
              <LabeledList.Item label="Nickname">
                <Button onClick={() => act('nickname')}>
                  {data.nickname || 'No Nickname'}
                </Button>
                {data.nickname ? (
                  <Button
                    icon="x"
                    color="bad"
                    onClick={() => act('reset_nickname')}
                    tooltip="Reset Nickname"
                  />
                ) : null}
              </LabeledList.Item>
              <LabeledList.Item label="Biological Sex">
                <GenderButton
                  gender={data.biological_sex}
                  setGender={(gender: Gender) => act('bio_gender', { gender })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Pronouns">
                <GenderButton
                  gender={data.identifying_gender}
                  setGender={(gender: Gender) => act('id_gender', { gender })}
                  usePronouns
                />
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
          <Stack.Item>
            <LabeledList>
              <LabeledList.Item label="Age">
                <Button onClick={() => act('age')}>{age}</Button>
              </LabeledList.Item>
              <LabeledList.Item label="Birthday">
                <Button onClick={() => act('bday_month')}>{bday_month}</Button>/
                <Button onClick={() => act('bday_day')}>{bday_day}</Button>
              </LabeledList.Item>
              <LabeledList.Item label="Announce Birthday?">
                <Button onClick={() => act('bday_announce')}>
                  {bday_announce ? 'Yes' : 'No'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Egg Type">
                <Button onClick={() => act('vore_egg_type')}>
                  {vore_egg_type}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Autohiss Setting">
                <Button onClick={() => act('autohiss')}>{autohiss}</Button>
              </LabeledList.Item>
              <LabeledList.Item label="Custom Species Name">
                <Button onClick={() => act('custom_species')}>
                  {custom_species || '-Input Name-'}
                </Button>
              </LabeledList.Item>
              {selects_bodytype ? (
                <LabeledList.Item
                  label="Custom Species Icon"
                  tooltip="Your selected species can choose any other race for it's base sprites"
                >
                  <Button onClick={() => act('custom_base')}>
                    {custom_base || 'Human'}
                  </Button>
                </LabeledList.Item>
              ) : null}
            </LabeledList>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Box bold>Languages</Box>
        <Stack>
          <Stack.Item>
            <Box
              style={{ display: 'grid', gridTemplateColumns: '1fr 40px 80px' }}
            >
              {languages.map((language) => (
                <Fragment key={language.name}>
                  <Box>- {language.name}</Box>
                  <Box ml={1}>
                    -{' '}
                    <Button
                      onClick={() =>
                        act('set_custom_key', { lang: language.name })
                      }
                      tooltip="Set Custom Key"
                      icon="keyboard"
                    />
                  </Box>
                  {language.removable ? (
                    <Box textAlign="center" inline ml={1}>
                      -{' '}
                      <Button
                        onClick={() =>
                          act('remove_language', { lang: language.name })
                        }
                      >
                        Remove
                      </Button>
                    </Box>
                  ) : (
                    <div />
                  )}
                </Fragment>
              ))}
            </Box>
            {languages_can_add ? (
              <Box>
                <Button onClick={() => act('add_language')}>
                  Add Language
                </Button>
              </Box>
            ) : null}
          </Stack.Item>
          <Stack.Item>
            <Divider vertical />
          </Stack.Item>
          <Stack.Item>
            <Box bold>Language Keys</Box>
            {language_keys.map((key) => key + ' ')}
            <Button onClick={() => act('change_prefix')}>Change</Button>
            <Button onClick={() => act('reset_prefix')}>Reset</Button>
            <Box bold>Preferred Language</Box>
            <Button inline onClick={() => act('pref_lang')}>
              {preferred_language}
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Divider vertical />
          </Stack.Item>
          <Stack.Item textAlign="center">
            <Box bold>Runechat Color</Box>
            <Tooltip content={runechat_color}>
              <ColorBox color={runechat_color} />
            </Tooltip>
            <Button ml={1} onClick={() => act('pref_runechat_color')}>
              Change
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
