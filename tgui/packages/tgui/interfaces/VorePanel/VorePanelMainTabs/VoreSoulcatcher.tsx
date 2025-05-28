import { useBackend } from 'tgui/backend';
import {
  Box,
  Dropdown,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';
import { type BooleanLike } from 'tgui-core/react';

import { noSelectionName } from '../constants';
import type { abilities, DropdownEntry, soulcatcherData } from '../types';
import { VorePanelEditToggle } from '../VorePanelElements/VorePanelCommonElements';
import { VorePanelEditTextTabs } from '../VorePanelElements/VorePaneldEditTextTabs';
import { VorePanelEditDropdown } from '../VorePanelElements/VorePanelEditDropdown';
import { VorePanelEditSwitch } from '../VorePanelElements/VorePanelEditSwitch';
import { VorePanelEditText } from '../VorePanelElements/VorePanelEditText';
import { CatchSettings } from '../VoreSoulcatcherSettings/CatchSettings';
import { GlobalOptions } from '../VoreSoulcatcherSettings/GlobalOptions';
import { GlobalSettings } from '../VoreSoulcatcherSettings/GlobalSettings';
import { SoulOptions } from '../VoreSoulcatcherSettings/SoulOptions';
import { VoreAbilities } from './VoreAbilities';

export const VoreSoulcatcher = (props: {
  soulcatcher: soulcatcherData | null;
  our_bellies: Required<{ name: string; ref: string }[]> & {
    map(
      arg0: (belly: { name: string; ref: string }) => DropdownEntry,
    ): DropdownEntry[];
  };
  abilities: abilities;
  toggleEditMode: React.Dispatch<React.SetStateAction<boolean>>;
  editMode: boolean;
  persist_edit_mode: BooleanLike;
}) => {
  const {
    soulcatcher,
    our_bellies,
    abilities,
    toggleEditMode,
    editMode,
    persist_edit_mode,
  } = props;

  const getBellies = our_bellies.map((belly) => {
    return { displayText: belly.name, value: belly.ref };
  });

  const locationNames = [...getBellies, noSelectionName];

  return (
    <Section scrollable fill>
      <Stack vertical fill>
        {soulcatcher && (
          <Stack.Item>
            <VoreSoulcatcherSection
              soulcatcher={soulcatcher}
              overlayBellies={locationNames}
              toggleEditMode={toggleEditMode}
              editMode={editMode}
              persist_edit_mode={persist_edit_mode}
            />
          </Stack.Item>
        )}
        <Stack.Item>
          <VoreAbilities abilities={abilities} />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const VoreSoulcatcherSection = (props: {
  soulcatcher: soulcatcherData;
  overlayBellies: DropdownEntry[];
  toggleEditMode: React.Dispatch<React.SetStateAction<boolean>>;
  editMode: boolean;
  persist_edit_mode: BooleanLike;
}) => {
  const { act } = useBackend();

  const {
    soulcatcher,
    overlayBellies,
    toggleEditMode,
    editMode,
    persist_edit_mode,
  } = props;

  const {
    active,
    name,
    caught_souls,
    selected_soul,
    catch_self,
    catch_prey,
    catch_drain,
    catch_ghost,
    ext_hearing,
    ext_vision,
    mind_backups,
    sr_projecting,
    see_sr_projecting,
    selected_sfx,
    show_vore_sfx,
    taken_over,
    sc_message_data,
  } = soulcatcher;

  return (
    <Section
      title={'Soulcatcher (' + name + ')'}
      fill
      buttons={
        <Stack>
          <Stack.Item>
            <VorePanelEditSwitch
              action="soulcatcher_toggle"
              editMode={editMode}
              active={!!active}
              tooltipPosition="top"
              tooltip={
                (active ? 'Disables' : 'Enables') +
                ' the ability to capture souls upon vore death.'
              }
            />
          </Stack.Item>
          <Stack.Item>
            <VorePanelEditToggle
              editMode={editMode}
              persistEditMode={persist_edit_mode}
              toggleEditMode={toggleEditMode}
            />
          </Stack.Item>
        </Stack>
      }
    >
      {!!active && (
        <Stack vertical>
          <Stack.Item>
            <LabeledList>
              <LabeledList.Item label="Captured Souls">
                <Stack align="center">
                  <Stack.Item>
                    <Dropdown
                      width="200px"
                      selected={selected_soul}
                      options={caught_souls}
                      onSelected={(value) =>
                        act('soulcatcher_select', {
                          selected_soul: value,
                        })
                      }
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Box>{caught_souls.length}</Box>
                  </Stack.Item>
                </Stack>
              </LabeledList.Item>
              {!!selected_soul && <SoulOptions taken_over={taken_over} />}
              {!!caught_souls.length && (
                <GlobalOptions taken_over={taken_over} />
              )}
              <CatchSettings
                editMode={editMode}
                catch_self={catch_self}
                catch_prey={catch_prey}
                catch_drain={catch_drain}
                catch_ghost={catch_ghost}
              />
              <GlobalSettings
                editMode={editMode}
                ext_hearing={ext_hearing}
                ext_vision={ext_vision}
                mind_backups={mind_backups}
                sr_projecting={sr_projecting}
                see_sr_projecting={see_sr_projecting}
                show_vore_sfx={show_vore_sfx}
              />
              <LabeledList.Item label="Interior SFX">
                <VorePanelEditDropdown
                  action="soulcatcher_sfx"
                  editMode={editMode}
                  options={overlayBellies}
                  color={!editMode && !selected_sfx ? 'red' : undefined}
                  entry={selected_sfx || 'Disabled'}
                  tooltip="Allows you to link a belly FX to display to captured souls."
                />
              </LabeledList.Item>
              {editMode && (
                <LabeledList.Item label="Edit Name">
                  <VorePanelEditText
                    action="soulcatcher_rename"
                    editMode={editMode}
                    tooltipPosition="top"
                    limit={60}
                    min={3}
                    entry={name}
                    tooltip={
                      'Adjust the name of your soulcatcher. [3-60 characters].'
                    }
                  />
                </LabeledList.Item>
              )}
            </LabeledList>
          </Stack.Item>
          <Stack.Divider />
          <Stack.Item>
            <VorePanelEditTextTabs
              noHighlight
              editMode={editMode}
              messsageOptions={sc_message_data.possible_messages}
              activeTab={sc_message_data.sc_subtab}
              tabAction="change_sc_message_option"
              tooltip={sc_message_data.tooltip}
              maxLength={sc_message_data.max_length}
              activeMessage={sc_message_data.active_message}
              action={sc_message_data.set_action}
            />
          </Stack.Item>
        </Stack>
      )}
    </Section>
  );
};
