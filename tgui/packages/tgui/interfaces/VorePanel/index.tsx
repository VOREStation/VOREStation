import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Icon, NoticeBox, Stack, Tabs } from 'tgui-core/components';

import type { Data } from './types';
import { VoreBellySelectionAndCustomization } from './VorePanelMainTabs/VoreBellySelectionAndCustomization';
import { VoreInsidePanel } from './VorePanelMainTabs/VoreInsidePanel';
import { VoreSoulcatcher } from './VorePanelMainTabs/VoreSoulcatcher';
import { VoreUserGeneral } from './VorePanelMainTabs/VoreUserGeneral';
import { VoreUserPreferences } from './VorePanelMainTabs/VoreUserPreferences';

/**
 * There are three main sections to this UI.
 *  - The Inside Panel, where all relevant data for interacting with a belly you're in is located.
 *  - The soulcatcher, which allows to capture prey after digestion to entrap them.
 *  - The Belly Selection Panel, where you can select what belly people will go into and customize the active one.
 *  - User Preferences, where you can adjust all of your vore preferences on the fly.
 */

export const VorePanel = () => {
  const { act, data } = useBackend<Data>();

  const {
    active_tab,
    active_vore_tab,
    persist_edit_mode,
    inside,
    our_bellies,
    selected,
    soulcatcher,
    abilities,
    prefs,
    show_pictures,
    icon_overflow,
    host_mobtype,
    unsaved_changes,
    vore_words,
    general_pref_data,
    min_belly_name,
    max_belly_name,
  } = data;

  const [editMode, setEditMode] = useState(!!persist_edit_mode);

  const tabs: (React.JSX.Element | null | undefined)[] = [];

  tabs[0] = our_bellies && selected && host_mobtype && (
    <VoreBellySelectionAndCustomization
      activeVoreTab={active_vore_tab}
      our_bellies={our_bellies}
      selected={selected}
      show_pictures={show_pictures}
      host_mobtype={host_mobtype}
      icon_overflow={icon_overflow}
      vore_words={vore_words}
      toggleEditMode={setEditMode}
      editMode={editMode}
      persist_edit_mode={persist_edit_mode}
      minBellyName={min_belly_name}
      maxBellyName={max_belly_name}
    />
  );
  tabs[1] = our_bellies && soulcatcher && abilities && (
    <VoreSoulcatcher
      our_bellies={our_bellies}
      soulcatcher={soulcatcher}
      abilities={abilities}
      toggleEditMode={setEditMode}
      editMode={editMode}
      persist_edit_mode={persist_edit_mode}
    />
  );
  tabs[2] = general_pref_data && our_bellies && (
    <VoreUserGeneral
      general_pref_data={general_pref_data}
      our_bellies={our_bellies}
      editMode={editMode}
      toggleEditMode={setEditMode}
      persist_edit_mode={persist_edit_mode}
    />
  );
  tabs[3] = prefs && <VoreUserPreferences prefs={prefs} />;

  return (
    <Window width={1030} height={760} theme="abstract">
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            {(unsaved_changes && (
              <NoticeBox danger>
                <Stack>
                  <Stack.Item basis="90%">Warning: Unsaved Changes!</Stack.Item>
                  <Stack.Item>
                    <Button icon="save" onClick={() => act('saveprefs')}>
                      Save Prefs
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="download"
                      onClick={() => {
                        act('saveprefs');
                        act('exportpanel');
                      }}
                    >
                      Save Prefs & Export Selected Belly
                    </Button>
                  </Stack.Item>
                </Stack>
              </NoticeBox>
            )) ||
              ''}
          </Stack.Item>
          <Stack.Item basis={inside?.desc?.length || 0 > 500 ? '30%' : '20%'}>
            <VoreInsidePanel
              inside={inside}
              show_pictures={show_pictures}
              icon_overflow={icon_overflow}
            />
          </Stack.Item>
          <Stack.Item>
            <Tabs>
              <Tabs.Tab
                selected={active_tab === 0}
                onClick={() => act('change_tab', { tab: 0 })}
              >
                Bellies
                <Icon name="list" ml={0.5} />
              </Tabs.Tab>
              <Tabs.Tab
                selected={active_tab === 1}
                onClick={() => act('change_tab', { tab: 1 })}
              >
                Soulcatcher
                <Icon name="ghost" ml={0.5} />
              </Tabs.Tab>
              <Tabs.Tab
                selected={active_tab === 2}
                onClick={() => act('change_tab', { tab: 2 })}
              >
                General
                <Icon name="user-circle" ml={0.5} />
              </Tabs.Tab>
              <Tabs.Tab
                selected={active_tab === 3}
                onClick={() => act('change_tab', { tab: 3 })}
              >
                Preferences
                <Icon name="user-cog" ml={0.5} />
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>{tabs[active_tab] || 'Error'}</Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
