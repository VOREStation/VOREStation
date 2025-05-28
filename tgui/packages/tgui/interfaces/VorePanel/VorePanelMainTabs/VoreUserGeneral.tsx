import { useBackend } from 'tgui/backend';
import { Button, Section, Stack } from 'tgui-core/components';
import { type BooleanLike } from 'tgui-core/react';

import type { bellyData, generalPrefData } from '../types';
import { VoreUserPreferencesAesthetic } from '../VoreUserPreferencesTabs/VoreUserPreferencesAesthetic';
/**
 * Subtemplate of VoreBellySelectionAndCustomization
 */
export const VoreUserGeneral = (props: {
  general_pref_data?: generalPrefData;
  editMode: boolean;
  persist_edit_mode: BooleanLike;
  our_bellies: bellyData[];
  toggleEditMode: React.Dispatch<React.SetStateAction<boolean>>;
}) => {
  const { act } = useBackend();
  const {
    general_pref_data,
    editMode,
    persist_edit_mode,
    our_bellies,
    toggleEditMode,
  } = props;

  return (
    <Section fill>
      <Stack vertical fill>
        {!!general_pref_data && (
          <Stack.Item grow>
            <VoreUserPreferencesAesthetic
              editMode={editMode}
              persist_edit_mode={persist_edit_mode}
              toggleEditMode={toggleEditMode}
              active_belly={general_pref_data.active_belly}
              belly_rub_target={general_pref_data.belly_rub_target}
              aestethicMessages={general_pref_data.aestethic_messages}
              our_bellies={our_bellies}
              vore_sprite_color={general_pref_data.vore_sprite_color}
              vore_sprite_multiply={general_pref_data.vore_sprite_multiply}
              vore_icon_options={general_pref_data.vore_icon_options}
            />
          </Stack.Item>
        )}
        <Stack.Divider />
        <Stack.Item>
          <Section>
            <Stack>
              <Stack.Item basis="49%">
                <Button fluid icon="save" onClick={() => act('saveprefs')}>
                  Save Prefs
                </Button>
              </Stack.Item>
              <Stack.Item basis="49%" grow>
                <Button fluid icon="undo" onClick={() => act('reloadprefs')}>
                  Reload Prefs
                </Button>
              </Stack.Item>
            </Stack>
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
