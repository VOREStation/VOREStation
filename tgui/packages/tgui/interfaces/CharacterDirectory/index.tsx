import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, LabeledList, Section, Stack } from 'tgui-core/components';

import { CharacterDirectoryList } from './CharacterDirectoryList';
import { ViewCharacter } from './CharacterDirectoryViewCharacter';
import type { Data, mobEntry } from './types';

export const CharacterDirectory = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    personalVisibility,
    personalTag,
    personalGenderTag,
    personalSexualityTag,
    personalErpTag,
    personalEventTag,
    directory,
  } = data;

  const [overlay, setOverlay] = useState<mobEntry | null>(null);
  const [overwritePrefs, setOverwritePrefs] = useState<boolean>(false);

  function handleOverlay(value: mobEntry) {
    setOverlay(value);
  }

  return (
    <Window width={816} height={722}>
      <Window.Content scrollable>
        {(overlay && (
          <ViewCharacter overlay={overlay} onOverlay={handleOverlay} />
        )) || (
          <>
            <Section
              title="Settings and Preferences"
              buttons={
                <Stack>
                  <Stack.Item>
                    <Box color="label" inline>
                      Save to current preferences slot:&nbsp;
                    </Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon={overwritePrefs ? 'toggle-on' : 'toggle-off'}
                      selected={overwritePrefs}
                      onClick={() => setOverwritePrefs(!overwritePrefs)}
                    >
                      {overwritePrefs ? 'On' : 'Off'}
                    </Button>
                  </Stack.Item>
                </Stack>
              }
            >
              <LabeledList>
                <LabeledList.Item label="Visibility">
                  <Button
                    fluid
                    onClick={() =>
                      act('setVisible', { overwrite_prefs: overwritePrefs })
                    }
                  >
                    {personalVisibility ? 'Shown' : 'Not Shown'}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Vore Tag">
                  <Button
                    fluid
                    onClick={() =>
                      act('setTag', { overwrite_prefs: overwritePrefs })
                    }
                  >
                    {personalTag}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Gender">
                  <Button
                    fluid
                    onClick={() =>
                      act('setGenderTag', { overwrite_prefs: overwritePrefs })
                    }
                  >
                    {personalGenderTag}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Sexuality">
                  <Button
                    fluid
                    onClick={() =>
                      act('setSexualityTag', {
                        overwrite_prefs: overwritePrefs,
                      })
                    }
                  >
                    {personalSexualityTag}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="ERP Tag">
                  <Button
                    fluid
                    onClick={() =>
                      act('setErpTag', { overwrite_prefs: overwritePrefs })
                    }
                  >
                    {personalErpTag}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Event Pref">
                  <Button
                    fluid
                    onClick={() =>
                      act('setEventTag', { overwrite_prefs: overwritePrefs })
                    }
                  >
                    {personalEventTag}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Advertisement">
                  <Button
                    fluid
                    onClick={() =>
                      act('editAd', { overwrite_prefs: overwritePrefs })
                    }
                  >
                    Edit Ad
                  </Button>
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <CharacterDirectoryList
              directory={directory}
              onOverlay={handleOverlay}
            />
          </>
        )}
      </Window.Content>
    </Window>
  );
};
