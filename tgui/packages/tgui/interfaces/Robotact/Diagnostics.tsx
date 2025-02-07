import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  FitText,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import { toTitleCase } from 'tgui-core/string';

import { Data } from './types';

export const ComponentView = (props) => {
  const { act, data } = useBackend<Data>();

  const { diag_functional, components } = data;

  if (components.length) {
    components.sort((a, b) => a.name.localeCompare(b.name));

    return (
      <Stack wrap align="flex-start" justify="space-between">
        {components.map((mod) => (
          <Stack.Item key={mod.key} basis="24%" grow ml={1}>
            <Section
              title={
                <FitText maxWidth={140} maxFontSize={18}>
                  {toTitleCase(mod.name)}
                </FitText>
              }
              height={12}
              mt={1}
              buttons={
                <Button
                  icon="power-off"
                  disabled={mod.name === 'power cell'}
                  selected={mod.toggled}
                  onClick={() =>
                    act('toggle_component', { component: mod.key })
                  }
                />
              }
            >
              {!!diag_functional && (
                <LabeledList>
                  <LabeledList.Item label="Health">
                    <ProgressBar
                      mb={1}
                      value={
                        mod.max_damage -
                        (mod.brute_damage + mod.electronics_damage)
                      }
                      maxValue={mod.max_damage}
                    >
                      {mod.max_damage -
                        (mod.brute_damage + mod.electronics_damage)}{' '}
                      / {mod.max_damage}
                    </ProgressBar>
                  </LabeledList.Item>
                </LabeledList>
              )}
              {diag_functional ? (
                <LabeledList>
                  <LabeledList.Item label="Brute Damage">
                    {mod.brute_damage}
                  </LabeledList.Item>
                  <LabeledList.Item label="Elect Damage">
                    {mod.electronics_damage}
                  </LabeledList.Item>
                  <LabeledList.Item label="Powered">
                    {mod.is_powered || !mod.idle_usage ? (
                      <Box color="good">Yes</Box>
                    ) : (
                      <Box color="bad">No</Box>
                    )}
                  </LabeledList.Item>
                </LabeledList>
              ) : (
                <NoticeBox danger>DIAGNOSIS UNAVAILABLE</NoticeBox>
              )}
            </Section>
          </Stack.Item>
        ))}
      </Stack>
    );
  }

  return <NoticeBox danger>Diagnosis Module Offline</NoticeBox>;
};
