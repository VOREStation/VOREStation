import { BooleanLike } from 'common/react';

import { useBackend } from '../../backend';
import { Box, Divider, Flex, Icon, Section, Tabs } from '../../components';
import { digestModeToColor } from './constants';
import { bellyData, hostMob, selectedData } from './types';
import { VoreSelectedBelly } from './VoreSelectedBelly';

export const VoreBellySelectionAndCustomization = (props: {
  our_bellies: bellyData[];
  selected: selectedData;
  host_mobtype: hostMob;
  show_pictures: BooleanLike;
}) => {
  const { act } = useBackend();

  const { our_bellies, selected, show_pictures, host_mobtype } = props;

  return (
    <Flex>
      <Flex.Item shrink>
        <Section title="My Bellies" scrollable>
          <Tabs vertical>
            <Tabs.Tab onClick={() => act('newbelly')}>
              New
              <Icon name="plus" ml={0.5} />
            </Tabs.Tab>
            <Tabs.Tab onClick={() => act('exportpanel')}>
              Export
              <Icon name="file-export" ml={0.5} />
            </Tabs.Tab>
            <Divider />
            {our_bellies.map((belly) => (
              <Tabs.Tab
                key={belly.name}
                selected={!!belly.selected}
                textColor={digestModeToColor[belly.digest_mode]}
                onClick={() => act('bellypick', { bellypick: belly.ref })}
              >
                <Box
                  inline
                  textColor={
                    (belly.selected && digestModeToColor[belly.digest_mode]) ||
                    null
                  }
                >
                  {belly.name} ({belly.contents})
                </Box>
              </Tabs.Tab>
            ))}
          </Tabs>
        </Section>
      </Flex.Item>
      <Flex.Item grow>
        {selected && (
          <Section title={selected.belly_name}>
            <VoreSelectedBelly
              belly={selected}
              show_pictures={show_pictures}
              host_mobtype={host_mobtype}
            />
          </Section>
        )}
      </Flex.Item>
    </Flex>
  );
};
