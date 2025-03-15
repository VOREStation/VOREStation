import { Box, Section, Stack } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { localPrefs } from '../types';
import { VoreUserPreferenceItem } from '../VoreUserPreferenceItem';

export const VoreUserPreferencesSoulcatcher = (props: {
  soulcatcher_allow_capture: BooleanLike;
  preferences: localPrefs;
}) => {
  const { soulcatcher_allow_capture, preferences } = props;

  return (
    <Section
      title="Soulcatcher Preferences"
      buttons={
        <Box nowrap>
          <VoreUserPreferenceItem
            spec={preferences.soulcatcher}
            tooltipPosition="top"
          />
        </Box>
      }
    >
      {soulcatcher_allow_capture ? (
        <Stack wrap="wrap" justify="center">
          <Stack.Item
            basis="32%"
            style={{
              marginLeft: '0.5em', // Remove if tgui core implements gap
            }}
          >
            <VoreUserPreferenceItem
              spec={preferences.soulcatcher_transfer}
              tooltipPosition="right"
            />
          </Stack.Item>
          <Stack.Item basis="32%">
            <VoreUserPreferenceItem
              spec={preferences.soulcatcher_takeover}
              tooltipPosition="top"
            />
          </Stack.Item>
          <Stack.Item basis="32%">
            <VoreUserPreferenceItem
              spec={preferences.soulcatcher_delete}
              tooltipPosition="left"
            />
          </Stack.Item>
        </Stack>
      ) : (
        ''
      )}
    </Section>
  );
};
