import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { ActivityTab } from 'tgui/components/ActivityTab';
import { Section, Stack, Tabs } from 'tgui-core/components';
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
    display_name,
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

  tabs[0] = (
    <ActivityTab
      hasData={!!belly_mode_data}
      Component={VoreSelectedBellyControls}
      props={{
        editMode,
        bellyDropdownNames,
        belly_name,
        display_name,
        bellyModeData: belly_mode_data!,
      }}
    />
  );

  tabs[1] = (
    <ActivityTab
      hasData={!!belly_description_data}
      Component={VoreSelectedBellyDescriptions}
      props={{
        editMode,
        bellyDescriptionData: belly_description_data!,
        vore_words,
      }}
    />
  );
  tabs[2] = (
    <ActivityTab
      hasData={!!belly_option_data}
      Component={VoreSelectedBellyOptions}
      props={{
        editMode,
        bellyOptionData: belly_option_data!,
      }}
    />
  );
  tabs[3] = (
    <ActivityTab
      hasData={!!belly_sound_data}
      Component={VoreSelectedBellySounds}
      props={{
        editMode,
        bellySoundData: belly_sound_data!,
      }}
    />
  );
  tabs[4] = (
    <ActivityTab
      hasData={!!belly_visual_data}
      Component={VoreSelectedBellyVisuals}
      props={{
        editMode,
        bellyVisualData: belly_visual_data!,
        hostMobtype: host_mobtype!,
      }}
    />
  );
  tabs[5] = (
    <ActivityTab
      hasData={!!belly_interaction_data}
      Component={VoreSelectedBellyInteractions}
      props={{
        editMode,
        bellyDropdownNames,
        bellyInteractData: belly_interaction_data!,
      }}
    />
  );
  tabs[6] = (
    <ActivityTab
      Component={VoreContentsPanel}
      props={{
        outside: true,
        targetBelly,
        onTargetBely: setTargetBelly,
        bellyDropdownNames,
        contents,
        show_pictures,
        icon_overflow,
      }}
    />
  );
  tabs[7] = (
    <ActivityTab
      hasData={!!belly_liquid_data}
      Component={VoreSelectedBellyLiquidOptions}
      props={{
        editMode,
        bellyLiquidData: belly_liquid_data!,
      }}
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
              {!!(index === 6) && `(${content_length})`}
            </Tabs.Tab>
          ))}
        </Tabs>
      </Stack.Item>
      <Stack.Item grow>
        <Section noTopPadding fill scrollable>
          {tabs[activeVoreTab] || 'Error'}
        </Section>
      </Stack.Item>
    </Stack>
  );
};
