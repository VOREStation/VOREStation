import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { capitalize } from 'tgui-core/string';

import type { localPrefs } from '../types';
import { VoreUserPreferenceItem } from '../VoreUserPreferenceItem';

export const VoreUserPreferencesDevouring = (props: {
  devourable: BooleanLike;
  digestModeToColor: Record<string, string | undefined>;
  selective_active: string;
  preferences: localPrefs;
}) => {
  const { act } = useBackend();
  const { devourable, digestModeToColor, selective_active, preferences } =
    props;

  return (
    <Section
      title="Devouring Preferences"
      buttons={
        <Box nowrap>
          <VoreUserPreferenceItem
            spec={preferences.devour}
            tooltipPosition="top"
          />
        </Box>
      }
    >
      {devourable ? (
        <Stack wrap="wrap" justify="center">
          <Stack.Item basis="32%">
            <VoreUserPreferenceItem
              spec={preferences.healbelly}
              tooltipPosition="right"
            />
          </Stack.Item>
          <Stack.Item basis="32%" grow>
            <VoreUserPreferenceItem
              spec={preferences.digestion}
              tooltipPosition="top"
            />
          </Stack.Item>
          <Stack.Item basis="32%">
            <VoreUserPreferenceItem
              spec={preferences.absorbable}
              tooltipPosition="left"
            />
          </Stack.Item>
          <Stack.Item basis="32%">
            <Button
              fluid
              backgroundColor={digestModeToColor[selective_active]}
              tooltip="Allows to set the personal belly mode preference for selective bellies."
              tooltipPosition="right"
              onClick={() => act('switch_selective_mode_pref')}
            >
              {'Selective Mode Preference: ' + capitalize(selective_active)}
            </Button>
          </Stack.Item>
          <Stack.Item basis="32%" grow>
            <VoreUserPreferenceItem
              spec={preferences.mobvore}
              tooltipPosition="top"
            />
          </Stack.Item>
          <Stack.Item basis="32%">
            <VoreUserPreferenceItem
              spec={preferences.autotransferable}
              tooltipPosition="left"
            />
          </Stack.Item>
          <Stack.Item basis="32%">
            <VoreUserPreferenceItem
              spec={preferences.strippref}
              tooltipPosition="right"
            />
          </Stack.Item>
          <Stack.Item basis="32%" grow>
            <VoreUserPreferenceItem
              spec={preferences.liquid_apply}
              tooltipPosition="top"
            />
          </Stack.Item>
          <Stack.Item basis="32%">
            <VoreUserPreferenceItem
              spec={preferences.remains}
              tooltipPosition="left"
            />
          </Stack.Item>
          <Stack.Item basis="34%">
            <VoreUserPreferenceItem
              spec={preferences.toggle_digest_pain}
              tooltipPosition="right"
            />
          </Stack.Item>
        </Stack>
      ) : (
        ''
      )}
    </Section>
  );
};
