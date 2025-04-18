import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Dropdown,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';

import type {
  abilities,
  bellyData,
  DropdownEntry,
  soulcatcherData,
} from './types';
import { VoreAbilities } from './VoreAbilities';
import { CatchSettings } from './VoreSoulcatcherSettings/CatchSettings';
import { GlobalOptions } from './VoreSoulcatcherSettings/GlobalOptions';
import { GlobalSettings } from './VoreSoulcatcherSettings/GlobalSettings';
import { SoulOptions } from './VoreSoulcatcherSettings/SoulOptions';

export const VoreSoulcatcher = (props: {
  soulcatcher: soulcatcherData | null;
  our_bellies: Required<bellyData[]> & {
    map(arg0: (belly: bellyData) => DropdownEntry): DropdownEntry[];
  };
  abilities: abilities;
}) => {
  const { soulcatcher, our_bellies, abilities } = props;

  const getBellies = our_bellies.map((belly) => {
    return { ...belly, displayText: belly.name, value: belly.ref };
  });

  return (
    <Section scrollable fill>
      {soulcatcher && (
        <VoreSoulcatcherSection
          soulcatcher={soulcatcher}
          overlayBellies={getBellies}
        />
      )}
      <VoreAbilities abilities={abilities} />
    </Section>
  );
};

const VoreSoulcatcherSection = (props: {
  soulcatcher: soulcatcherData;
  overlayBellies: DropdownEntry[];
}) => {
  const { act } = useBackend();

  const { soulcatcher, overlayBellies } = props;

  const {
    active,
    name,
    caught_souls,
    selected_soul,
    interior_design,
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
  } = soulcatcher;

  return (
    <Section
      title={'Soulcatcher (' + name + ')'}
      buttons={
        <Stack>
          <Stack.Item>
            <Button
              onClick={() => act('soulcatcher_rename')}
              icon="pen"
              tooltip="Click here to rename your soulcatcher."
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              onClick={() => act('soulcatcher_toggle')}
              icon={active ? 'toggle-on' : 'toggle-off'}
              tooltip={
                (active ? 'Disables' : 'Enables') +
                ' the ability to capture souls upon vore death.'
              }
              tooltipPosition="top"
              selected={active}
            >
              {active ? 'Soulcatcher On' : 'Soulcatcher Off'}
            </Button>
          </Stack.Item>
        </Stack>
      }
    >
      {active ? (
        <LabeledList>
          <LabeledList.Item label="Captured Souls">
            <Stack inline align="center">
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
          {selected_soul ? <SoulOptions taken_over={taken_over} /> : ''}
          {caught_souls.length ? <GlobalOptions taken_over={taken_over} /> : ''}
          <CatchSettings
            catch_self={catch_self}
            catch_prey={catch_prey}
            catch_drain={catch_drain}
            catch_ghost={catch_ghost}
          />
          <GlobalSettings
            ext_hearing={ext_hearing}
            ext_vision={ext_vision}
            mind_backups={mind_backups}
            sr_projecting={sr_projecting}
            see_sr_projecting={see_sr_projecting}
            show_vore_sfx={show_vore_sfx}
          />
          <LabeledList.Item
            label="Interior Design"
            buttons={
              <Button
                icon="wand-magic-sparkles"
                tooltip="Customize your soulcatcher flavour text."
                tooltipPosition="left"
                onClick={() => act('soulcatcher_interior_design')}
              />
            }
          >
            {interior_design}
          </LabeledList.Item>
          <LabeledList.Item label="Interior SFX">
            <Dropdown
              width="200px"
              selected={selected_sfx}
              options={overlayBellies}
              onSelected={(value) =>
                act('soulcatcher_sfx', {
                  selected_belly: value,
                })
              }
            />
          </LabeledList.Item>
          <LabeledList.Item label="Custom Messages">
            <Stack>
              <Stack.Item>
                <Button onClick={() => act('soulcatcher_capture_message')}>
                  Capture Message
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button onClick={() => act('soulcatcher_transit_message')}>
                  Transit Message
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button onClick={() => act('soulcatcher_release_message')}>
                  Release Message
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button onClick={() => act('soulcatcher_delete_message')}>
                  Delete Message
                </Button>
              </Stack.Item>
            </Stack>
          </LabeledList.Item>
        </LabeledList>
      ) : (
        'Soulcatching disabled.'
      )}
    </Section>
  );
};
