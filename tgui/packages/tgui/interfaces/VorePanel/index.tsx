import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Icon, NoticeBox, Stack, Tabs } from 'tgui-core/components';

import type { Data } from './types';
import { VoreBellySelectionAndCustomization } from './VoreBellySelectionAndCustomization';
import { VoreInsidePanel } from './VoreInsidePanel';
import { VoreSoulcatcher } from './VoreSoulcatcher';
import { VoreUserPreferences } from './VoreUserPreferences';

/**
 * There are three main sections to this UI.
 *  - The Inside Panel, where all relevant data for interacting with a belly you're in is located.
 *  - The Belly Selection Panel, where you can select what belly people will go into and customize the active one.
 *  - User Preferences, where you can adjust all of your vore preferences on the fly.
 */

/**
 * CHOMPedits specified here. Read ALL of this if conflicts happen, I can't find a way to add comments line by line.
 *
 * Under VoreSelectedBelly the following strings have been added to const{}:
 *   show_liq, liq_interacts, liq_reagent_gen, liq_reagent_type, liq_reagent_name,
 *   liq_reagent_transfer_verb, liq_reagent_nutri_rate, liq_reagent_capacity, liq_sloshing, liq_reagent_addons,
 *   show_liq_fullness, liq_messages, liq_msg_toggle1, liq_msg_toggle2, liq_msg_toggle3, liq_msg_toggle4,
 *   liq_msg_toggle5, liq_msg1, liq_msg2, liq_msg3, liq_msg4, liq_msg5, sound_volume, egg_name, recycling, storing_nutrition, entrance_logs, item_digest_logs, noise_freq,
 *   custom_reagentcolor, custom_reagentalpha, liquid_overlay, max_liquid_level, mush_overlay, reagent_touches, mush_color, mush_alpha, max_mush, min_mush, item_mush_val,
 *   metabolism_overlay, metabolism_mush_ratio, max_ingested, custom_ingested_color, custom_ingested_alpha
 *
 * To the tabs section of VoreSelectedBelly return
 *       <Tabs.Tab selected={tabIndex === 5} onClick={() => setTabIndex(5)}>
 *        Liquid Options
 *      </Tabs.Tab>
 *      <Tabs.Tab selected={tabIndex === 6} onClick={() => setTabIndex(6)}>
 *        Liquid Messages
 *      </Tabs.Tab>
 *
 * All of the content for tabIndex === 5 and tabIndex === 6
 *
 * Under VoreUserPreferences the following strings have been added to const{}:
 *   liq_rec, liq_giv,
 *
 * To VoreUserPreferences return
 *         <Stack.Item basis="49%">
 *        <Button
 *          onClick={() => act("toggle_liq_rec")}
 *          icon={liq_rec ? "toggle-on" : "toggle-off"}
 *          selected={liq_rec}
 *          fluid
 *          tooltipPosition="top"
 *          tooltip={"This button is for allowing or preventing others from giving you liquids from their vore organs."
 *          + (liq_rec ? " Click here to prevent receiving liquids." : " Click here to allow receiving liquids.")}
 *          >
 *            {liq_rec ? "Receiving Liquids Allowed" : "Do Not Allow Receiving Liquids"}
 *          </Button>
 *      </Stack.Item>
 *      <Stack.Item basis="49%">
 *        <Button
 *          onClick={() => act("toggle_liq_giv")}
 *          icon={liq_giv ? "toggle-on" : "toggle-off"}
 *          selected={liq_giv}
 *          fluid
 *          tooltipPosition="top"
 *           tooltip={"This button is for allowing or preventing others from taking liquids from your vore organs."
 *          + (liq_giv ? " Click here to prevent taking liquids." : " Click here to allow taking liquids.")}
 *          >
 *            {liq_giv ? "Taking Liquids Allowed" : "Do Not Allow Taking Liquids"}
 *          </Button>
 *      </Stack.Item>
 *
 * NEW EDITS 2/25/21: COLORED BELLY OVERLAYS
 * LINE 5:
 *import { Box, Button, ByondUi, Stack, Collapsible, Icon, LabeledList, NoticeBox, Section, Tabs } from "../components";
 *
 * LINE 172 - <Window width={700} height={800} resizable>
 *
 * LINE 301 - belly_fullscreen_color,
 * mapRef,
 *
 * LINE 604 - <Section title="Belly Fullscreens Preview and Coloring">
 *           <Stack direction="row">
 *             <Box backgroundColor={belly_fullscreen_color} width="20px" height="20px" />
 *             <Button
 *               icon="eye-dropper"
 *               onClick={() => act("set_attribute", { attribute: "b_fullscreen_color", val: null })}>
 *               Select Color
 *             </Button>
 *           </Stack>
 *           <ByondUi
 *             style={{
 *               width: '200px',
 *               height: '200px',
 *             }}
 *             params={{
 *               id: mapRef,
 *               type: 'map',
 *             }} />
 *         </Section>
 *         <Section height="260px" style={{ overflow: "auto" }}>
 *           <Section title="Vore FX">
 *             <LabeledList>
 *               <LabeledList.Item label="Disable Prey HUD">
 *                 <Button
 *                   onClick={() => act("set_attribute", { attribute: "b_disable_hud" })}
 *                   icon={disable_hud ? "toggle-on" : "toggle-off"}
 *                   selected={disable_hud}
 *                   >
 *                     {disable_hud ? "Yes" : "No"}
 *                   </Button>
 *               </LabeledList.Item>
 *             </LabeledList>
 *           </Section>
 *           <Section title="Belly Fullscreens Styles">
 *             Belly styles:
 *             <Button
 *               fluid
 *               selected={belly_fullscreen === "" || belly_fullscreen === null}
 *               onClick={() => act("set_attribute", { attribute: "b_fullscreen", val: null })}>
 *               Disabled
 *             </Button>
 *             {Object.keys(possible_fullscreens).map(key => (
 *               <Button
 *                 key={key}
 *                 width="256px"
 *                 height="256px"
 *                 selected={key === belly_fullscreen}
 *                 onClick={() => act("set_attribute", { attribute: "b_fullscreen", val: key })}>
 *                 <Box
 *                   className={classes([
 *                     'vore240x240',
 *                     key,
 *                   ])}
 *                   style={{
 *                     transform: 'translate(0%, 4%)',
 *                   }} />
 *               </Button>
 *             ))}
 *           </Section>
 *         </Section>
 *
 * LINE 900 - const [tabIndex, setTabIndex] = useLocalState('tabIndex', 0);
 *
 * return tabIndex===4 ? null : (
 *
 * New preference added, noisy_full
 * noisy_full enables belching when nutrition exceeds 500, very similar to the noisy preference.
 *
 * That's everything so far.
 *
 */

export const VorePanel = () => {
  const { act, data } = useBackend<Data>();

  const {
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
  } = data;

  const [tabIndex, setTabIndex] = useState(0);

  const tabs: React.JSX.Element[] = [];

  tabs[0] = (
    <VoreBellySelectionAndCustomization
      our_bellies={our_bellies}
      selected={selected}
      show_pictures={show_pictures}
      host_mobtype={host_mobtype}
      icon_overflow={icon_overflow}
      vore_words={vore_words}
    />
  );
  tabs[1] = (
    <VoreSoulcatcher
      our_bellies={our_bellies}
      soulcatcher={soulcatcher}
      abilities={abilities}
    />
  );
  tabs[2] = (
    <VoreUserPreferences
      prefs={prefs}
      selected={selected}
      show_pictures={show_pictures}
      icon_overflow={icon_overflow}
    />
  );

  return (
    <Window width={1000} height={660} theme="abstract">
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
                selected={tabIndex === 0}
                onClick={() => setTabIndex(0)}
              >
                Bellies
                <Icon name="list" ml={0.5} />
              </Tabs.Tab>
              <Tabs.Tab
                selected={tabIndex === 1}
                onClick={() => setTabIndex(1)}
              >
                Soulcatcher
                <Icon name="ghost" ml={0.5} />
              </Tabs.Tab>
              <Tabs.Tab
                selected={tabIndex === 2}
                onClick={() => setTabIndex(2)}
              >
                Preferences
                <Icon name="user-cog" ml={0.5} />
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>{tabs[tabIndex] || 'Error'}</Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
