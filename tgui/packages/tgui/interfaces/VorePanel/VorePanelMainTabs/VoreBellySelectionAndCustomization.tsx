import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Button,
  Divider,
  Icon,
  Input,
  Section,
  Stack,
  Tabs,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { createSearch } from 'tgui-core/string';

import { digestModeToColor } from '../constants';
import type { bellyData, hostMob, selectedData } from '../types';
import { VorePanelEditToggle } from '../VorePanelElements/VorePanelCommonElements';
import { VoreSelectedBelly } from './VoreSelectedBelly';

export const VoreBellySelectionAndCustomization = (props: {
  activeVoreTab?: number;
  our_bellies: bellyData[];
  selected: selectedData | null;
  show_pictures: BooleanLike;
  host_mobtype: hostMob;
  icon_overflow: BooleanLike;
  vore_words: Record<string, string[]>;
  toggleEditMode: React.Dispatch<React.SetStateAction<boolean>>;
  editMode: boolean;
  persist_edit_mode: BooleanLike;
}) => {
  const { act } = useBackend();

  const {
    activeVoreTab = 0,
    our_bellies,
    selected,
    show_pictures,
    host_mobtype,
    icon_overflow,
    vore_words,
    toggleEditMode,
    editMode,
    persist_edit_mode,
  } = props;

  const [showSearch, setShowSearch] = useState(false);
  const [searchedBellies, setSearchedBellies] = useState('');

  const bellySearch = createSearch(
    searchedBellies,
    (belly: bellyData) => belly.name,
  );

  const belliesToDisplay = our_bellies.filter(bellySearch);

  const bellyDropdownNames = our_bellies.map((belly) => {
    return { displayText: belly.name, value: belly.ref };
  });

  return (
    <Stack fill>
      <Stack.Item shrink basis="20%">
        <Section
          title="My Bellies"
          scrollable
          fill
          buttons={
            <Button
              icon="magnifying-glass"
              selected={showSearch}
              onClick={() => setShowSearch(!showSearch)}
            />
          }
        >
          <Tabs vertical>
            <Tabs.Tab onClick={() => act('newbelly')}>
              New
              <Icon name="plus" ml={0.5} />
            </Tabs.Tab>
            <Tabs.Tab onClick={() => act('exportpanel')}>
              Export
              <Icon name="file-export" ml={0.5} />
            </Tabs.Tab>
            <Tabs.Tab onClick={() => act('importpanel')}>
              Import
              <Icon name="file-import" ml={0.5} />
            </Tabs.Tab>
            <Divider />
            {showSearch && (
              <>
                <Input
                  fluid
                  placeholder="Search for bellies..."
                  onChange={(value) => setSearchedBellies(value)}
                />
                <Divider />
              </>
            )}
            {belliesToDisplay.map((belly) => (
              <Tabs.Tab
                key={belly.name}
                selected={!!belly.selected}
                textColor={digestModeToColor[belly.digest_mode!]}
                onClick={() => act('bellypick', { bellypick: belly.ref })}
                backgroundColor={belly.prevent_saving ? '#180000' : undefined}
              >
                <Stack
                  fill
                  textColor={
                    (belly.selected && digestModeToColor[belly.digest_mode!]) ||
                    null
                  }
                >
                  <Stack.Item grow>
                    {belly.name} ({belly.contents})
                  </Stack.Item>
                  <Stack.Item>
                    {!!belly.prevent_saving && (
                      <Tooltip position="right" content="Temporary belly">
                        <Icon
                          name="triangle-exclamation"
                          mr={0.5}
                          color="red"
                        />
                      </Tooltip>
                    )}
                  </Stack.Item>
                </Stack>
              </Tabs.Tab>
            ))}
          </Tabs>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        {selected && (
          <Section
            title={selected.belly_name}
            buttons={
              <VorePanelEditToggle
                editMode={editMode}
                persistEditMode={persist_edit_mode}
                toggleEditMode={toggleEditMode}
              />
            }
            fill
            scrollable
          >
            <VoreSelectedBelly
              bellyDropdownNames={bellyDropdownNames}
              activeVoreTab={activeVoreTab}
              vore_words={vore_words}
              belly={selected}
              show_pictures={show_pictures}
              host_mobtype={host_mobtype}
              icon_overflow={icon_overflow}
              editMode={editMode}
            />
          </Section>
        )}
      </Stack.Item>
    </Stack>
  );
};
