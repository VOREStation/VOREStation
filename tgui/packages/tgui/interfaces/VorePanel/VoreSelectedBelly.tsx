import { useBackend } from 'tgui/backend';
import { Stack, Tabs } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { tabToNames } from './constants';
import type { hostMob, selectedData } from './types';
import { VoreContentsPanel } from './VoreContentsPanel';
import { VoreSelectedBellyControls } from './VoreSelectedBellyTabs/VoreSelectedBellyControls';
import { VoreSelectedBellyDescriptions } from './VoreSelectedBellyTabs/VoreSelectedBellyDescriptions';
import { VoreSelectedBellyInteractions } from './VoreSelectedBellyTabs/VoreSelectedBellyInteractions';
import { VoreSelectedBellyLiquidOptions } from './VoreSelectedBellyTabs/VoreSelectedBellyLiquidOptions';
import { VoreSelectedBellyOptions } from './VoreSelectedBellyTabs/VoreSelectedBellyOptions';
import { VoreSelectedBellySounds } from './VoreSelectedBellyTabs/VoreSelectedBellySounds';
import { VoreSelectedBellyVisuals } from './VoreSelectedBellyTabs/VoreSelectedBellyVisuals';
/**
 * Subtemplate of VoreBellySelectionAndCustomization
 */
export const VoreSelectedBelly = (props: {
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
    contents,
  } = belly;

  const tabs: (React.JSX.Element | undefined)[] = [];

  tabs[0] = belly_mode_data && (
    <VoreSelectedBellyControls
      editMode={editMode}
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
      host_mobtype={host_mobtype}
    />
  );
  tabs[3] = <VoreSelectedBellySounds belly={belly} />;
  tabs[4] = <VoreSelectedBellyVisuals belly={belly} />;
  tabs[5] = <VoreSelectedBellyInteractions belly={belly} />;
  tabs[6] = (
    <VoreContentsPanel
      outside
      contents={contents}
      show_pictures={show_pictures}
      icon_overflow={icon_overflow}
    />
  );
  tabs[7] = <VoreSelectedBellyLiquidOptions belly={belly} />;

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
              {!!(index === 6) && '(' + contents.length + ')'}
            </Tabs.Tab>
          ))}
        </Tabs>
      </Stack.Item>
      <Stack.Item grow>{tabs[activeVoreTab] || 'Error'}</Stack.Item>
    </Stack>
  );
};
