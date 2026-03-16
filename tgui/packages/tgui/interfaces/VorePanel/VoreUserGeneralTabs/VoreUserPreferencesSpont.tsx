import { LabeledList, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { capitalize } from 'tgui-core/string';
import type { BellyData } from '../types';
import { VorePanelEditToggle } from '../VorePanelElements/VorePanelCommonElements';
import { VorePanelEditDropdown } from '../VorePanelElements/VorePanelEditDropdown';

export const VoreUserPreferencesSpont = (props: {
  editMode: boolean;
  persist_edit_mode: BooleanLike;
  toggleEditMode: React.Dispatch<React.SetStateAction<boolean>>;
  active_belly: string | null;
  our_bellies: BellyData[];
  spont_rear: string | null;
  spont_front: string | null;
  spont_left: string | null;
  spont_right: string | null;
}) => {
  const {
    editMode,
    persist_edit_mode,
    toggleEditMode,
    active_belly,
    our_bellies,
    spont_rear,
    spont_front,
    spont_left,
    spont_right,
  } = props;

  const getBellies = our_bellies.map((belly) => {
    return belly.display_name ? belly.display_name : belly.name;
  });

  const locationNames = [...getBellies, 'Current Selected'];

  const capitalizedName = active_belly && capitalize(active_belly);

  return (
    <Section
      title="Spontaneous Preferences"
      scrollable
      buttons={
        <VorePanelEditToggle
          editMode={editMode}
          persistEditMode={persist_edit_mode}
          toggleEditMode={toggleEditMode}
        />
      }
    >
      <Stack vertical fill>
        <Stack.Item>
          <Stack>
            <Stack.Item basis="49%" grow>
              <LabeledList>
                <LabeledList.Item label="Spont Belly Rear">
                  <VorePanelEditDropdown
                    action="set_spont_belly"
                    subAction="rear"
                    icon="crosshairs"
                    editMode={editMode}
                    options={locationNames}
                    entry={
                      spont_rear
                        ? spont_rear
                        : `Current Selected (${capitalizedName})`
                    }
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Spont Belly Front">
                  <VorePanelEditDropdown
                    action="set_spont_belly"
                    subAction="front"
                    icon="crosshairs"
                    editMode={editMode}
                    options={locationNames}
                    entry={
                      spont_front
                        ? spont_front
                        : `Current Selected (${capitalizedName})`
                    }
                  />
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
            <Stack.Item basis="49%" grow>
              <LabeledList>
                <LabeledList.Item label="Spont Belly Left">
                  <VorePanelEditDropdown
                    action="set_spont_belly"
                    subAction="left"
                    icon="crosshairs"
                    editMode={editMode}
                    options={locationNames}
                    entry={
                      spont_left
                        ? spont_left
                        : `Current Selected (${capitalizedName})`
                    }
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Spont Belly Right">
                  <VorePanelEditDropdown
                    action="set_spont_belly"
                    subAction="right"
                    icon="crosshairs"
                    editMode={editMode}
                    options={locationNames}
                    entry={
                      spont_right
                        ? spont_right
                        : `Current Selected (${capitalizedName})`
                    }
                  />
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
