import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Stack, Tabs } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { tabToNames } from '../constants';
import type { DropdownEntry, hostMob, selectedData } from '../types';
import { VoreContentsPanel } from '../VoreSelectedBellyTabs/VoreContentsPanel';
import { VoreSelectedBellyControls } from '../VoreSelectedBellyTabs/VoreSelectedBellyControls';
import { VoreSelectedBellyDescriptions } from '../VoreSelectedBellyTabs/VoreSelectedBellyDescriptions';
import { VoreSelectedBellyInteractions } from '../VoreSelectedBellyTabs/VoreSelectedBellyInteractions';
import { VoreSelectedBellyLiquidOptions } from '../VoreSelectedBellyTabs/VoreSelectedBellyLiquidOptions';
import { VoreSelectedBellyOptions } from '../VoreSelectedBellyTabs/VoreSelectedBellyOptions';
import { VoreSelectedBellySounds } from '../VoreSelectedBellyTabs/VoreSelectedBellySounds';
import { VoreSelectedBellyVisuals } from '../VoreSelectedBellyTabs/VoreSelectedBellyVisuals';
/**
 * Subtemplate of VoreBellySelectionAndCustomization
 */
export const VoreSelectedBelly = (props: {
  bellyDropdownNames: DropdownEntry[];
  activeVoreTab: number;
  belly: selectedData;
  show_pictures: BooleanLike;
  host_mobtype: hostMob;
  icon_overflow: BooleanLike;
  vore_words: Record<string, string[]>;
  editMode: boolean;
}) => {
  const { act } = useBackend();
  const {
    bellyDropdownNames,
    activeVoreTab,
    belly,
    show_pictures,
    host_mobtype,
    icon_overflow,
    vore_words,
    editMode,
  } = props;
  const {
    belly_name,
    belly_mode_data,
    belly_description_data,
    belly_option_data,
    belly_sound_data,
    belly_visual_data,
    belly_interaction_data,
    belly_liquid_data,
    contents,
    content_length,
  } = belly;

  const [targetBelly, setTargetBelly] = useState('');

  const tabs: (React.JSX.Element | undefined)[] = [];

  tabs[0] = belly_mode_data && (
    <VoreSelectedBellyControls
      editMode={editMode}
      bellyDropdownNames={bellyDropdownNames}
      belly_name={belly_name}
      bellyModeData={belly_mode_data}
    />
  );
  tabs[1] = belly_description_data && (
    <VoreSelectedBellyDescriptions
      editMode={editMode}
      bellyDescriptionData={belly_description_data}
      vore_words={vore_words}
    />
  );
  tabs[2] = belly_option_data && (
    <VoreSelectedBellyOptions
      editMode={editMode}
      bellyOptionData={belly_option_data}
    />
  );
  tabs[3] = belly_sound_data && (
    <VoreSelectedBellySounds
      editMode={editMode}
      bellySoundData={belly_sound_data}
    />
  );
  tabs[4] = belly_visual_data && (
    <VoreSelectedBellyVisuals
      editMode={editMode}
      bellyVisualData={belly_visual_data}
      hostMobtype={host_mobtype}
    />
  );
  tabs[5] = belly_interaction_data && (
    <VoreSelectedBellyInteractions
      editMode={editMode}
      bellyDropdownNames={bellyDropdownNames}
      bellyInteractData={belly_interaction_data}
    />
  );
  tabs[6] = (
    <VoreContentsPanel
      outside
      targetBelly={targetBelly}
      onTargetBely={setTargetBelly}
      bellyDropdownNames={bellyDropdownNames}
      contents={contents}
      show_pictures={show_pictures}
      icon_overflow={icon_overflow}
    />
  );
  tabs[7] = belly_liquid_data && (
    <VoreSelectedBellyLiquidOptions
      editMode={editMode}
      bellyLiquidData={belly_liquid_data}
    />
  );

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Tabs>
          {tabToNames.map((name, index) => (
            <Tabs.Tab
              key={name}
              selected={activeVoreTab === index}
              onClick={() => act('change_vore_tab', { tab: index })}
            >
              {tabToNames[index]}
              {!!(index === 6) && '(' + content_length + ')'}
            </Tabs.Tab>
          ))}
        </Tabs>
      </Stack.Item>
      <Stack.Item grow>{tabs[activeVoreTab] || 'Error'}</Stack.Item>
    </Stack>
  );
};
