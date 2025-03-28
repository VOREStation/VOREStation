import { useBackend } from 'tgui/backend';
import {
  Divider,
  Icon,
  Section,
  Stack,
  Tabs,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { digestModeToColor } from './constants';
import type { bellyData, hostMob, selectedData } from './types';
import { VoreSelectedBelly } from './VoreSelectedBelly';

export const VoreBellySelectionAndCustomization = (props: {
  our_bellies: bellyData[];
  selected: selectedData | null;
  show_pictures: BooleanLike;
  host_mobtype: hostMob;
  icon_overflow: BooleanLike;
  vore_words: Record<string, string[]>;
}) => {
  const { act } = useBackend();

  const {
    our_bellies,
    selected,
    show_pictures,
    host_mobtype,
    icon_overflow,
    vore_words,
  } = props;

  return (
    <Stack fill>
      <Stack.Item shrink basis="20%">
        <Section title="My Bellies" scrollable fill>
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
            {our_bellies.map((belly) => (
              <Tabs.Tab
                key={belly.name}
                selected={!!belly.selected}
                textColor={digestModeToColor[belly.digest_mode]}
                onClick={() => act('bellypick', { bellypick: belly.ref })}
                backgroundColor={belly.prevent_saving ? '#180000' : undefined}
              >
                <Stack
                  fill
                  textColor={
                    (belly.selected && digestModeToColor[belly.digest_mode]) ||
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
          <Section title={selected.belly_name} fill scrollable>
            <VoreSelectedBelly
              vore_words={vore_words}
              belly={selected}
              show_pictures={show_pictures}
              host_mobtype={host_mobtype}
              icon_overflow={icon_overflow}
            />
          </Section>
        )}
      </Stack.Item>
    </Stack>
  );
};
