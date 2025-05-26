import { LabeledList, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { capitalize } from 'tgui-core/string';

import { aestehticTabsToIcons } from '../constants';
import type { aestMessageData, bellyData } from '../types';
import { VorePanelEditToggle } from '../VorePanelElements/VorePanelCommonElements';
import { VorePanelEditTextTabs } from '../VorePanelElements/VorePaneldEditTextTabs';
import { VorePanelEditColor } from '../VorePanelElements/VorePanelEditColor';
import { VorePanelEditDropdown } from '../VorePanelElements/VorePanelEditDropdown';
import { VorePanelEditSwitch } from '../VorePanelElements/VorePanelEditSwitch';

export const VoreUserPreferencesAesthetic = (props: {
  editMode: boolean;
  toggleEditMode: React.Dispatch<React.SetStateAction<boolean>>;
  active_belly: string | null;
  our_bellies: bellyData[];
  belly_rub_target: string | null;
  vore_sprite_color: Record<string, string>;
  vore_sprite_multiply: Record<string, BooleanLike>;
  vore_icon_options: string[];
  aestethicMessages: aestMessageData;
}) => {
  const {
    editMode,
    toggleEditMode,
    active_belly,
    belly_rub_target,
    our_bellies,
    vore_sprite_color,
    vore_sprite_multiply,
    vore_icon_options,
    aestethicMessages,
  } = props;

  const sanitizeCorruption =
    aestethicMessages.active_message === null
      ? ''
      : Array.isArray(aestethicMessages.active_message) ||
          typeof aestethicMessages.active_message === 'string'
        ? aestethicMessages.active_message
        : [];

  const getBellies = our_bellies.map((belly) => {
    return belly.name;
  });

  const locationNames = [...getBellies, 'Current Selected'];

  const capitalizedName = active_belly && capitalize(active_belly);

  return (
    <Section
      fill
      title="Aesthetic Preferences"
      scrollable
      buttons={
        <VorePanelEditToggle
          editMode={editMode}
          toggleEditMode={toggleEditMode}
        />
      }
    >
      <Stack vertical fill>
        <Stack.Item>
          <Stack>
            <Stack.Item basis="49%" grow>
              <LabeledList>
                {vore_icon_options.map((entry) => (
                  <LabeledList.Item key={entry} label={capitalize(entry)}>
                    <Stack align="center">
                      <VorePanelEditColor
                        removePlaceholder
                        editMode={editMode}
                        action="set_vs_color"
                        subAction={entry}
                        back_color={vore_sprite_color[entry]}
                        tooltip={
                          "Modify the sprite color of your '" +
                          entry +
                          "' sprite."
                        }
                        value_of={undefined}
                      />
                      <Stack.Item>
                        <VorePanelEditSwitch
                          hideIcon
                          editMode={editMode}
                          action="toggle_vs_multiply"
                          subAction={entry}
                          active={!!vore_sprite_multiply[entry]}
                          tooltip={
                            "Switch between color multiply and add mode for your '" +
                            entry +
                            "' sprite."
                          }
                          color={!editMode ? 'white' : undefined}
                          content={
                            vore_sprite_multiply[entry] ? 'Multiply' : 'Add'
                          }
                        />
                      </Stack.Item>
                    </Stack>
                  </LabeledList.Item>
                ))}
              </LabeledList>
            </Stack.Item>
            <Stack.Item basis="49%" grow>
              <LabeledList>
                <LabeledList.Item label="Belly Rub Target">
                  <VorePanelEditDropdown
                    action={'set_belly_rub'}
                    icon="crosshairs"
                    editMode={editMode}
                    options={locationNames}
                    entry={
                      belly_rub_target
                        ? belly_rub_target
                        : 'Current Selected (' + capitalizedName + ')'
                    }
                  />
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item grow>
          <Section fill>
            <VorePanelEditTextTabs
              exactLength
              editMode={editMode}
              messsageOptions={aestethicMessages.possible_messages}
              activeTab={aestethicMessages.aest_subtab}
              tabAction="change_aset_message_option"
              tabsToIcons={aestehticTabsToIcons}
              tooltip={aestethicMessages.tooltip}
              maxLength={aestethicMessages.max_length}
              activeMessage={sanitizeCorruption}
              action={aestethicMessages.set_action}
              listAction="b_msgs"
              disableLegacyInput={!Array.isArray(sanitizeCorruption)}
              subAction={aestethicMessages.sub_action}
              button_action={aestethicMessages.button_action}
              button_label={aestethicMessages.button_label}
              button_data={!!aestethicMessages.button_data}
              button_tooltip={aestethicMessages.button_tooltip}
            />
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
