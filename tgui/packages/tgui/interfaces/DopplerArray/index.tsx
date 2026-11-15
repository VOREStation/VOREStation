import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, NoticeBox, Stack } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';
import { DopplerExplosions } from './DopplerExplosions';
import { DopplerSearch } from './DopplerSearch';
import { DopplerTabs } from './DopplerTabs';
import { getSeverity } from './functions';
import type { Data, Explosion } from './types';

export const DopplerArray = (props) => {
  const { data } = useBackend<Data>();
  const [searchFields, setSearchFields] = useState({
    time: true,
    coordinates: true,
    inner_radius: true,
    outer_radius: true,
    shockwave: true,
    tachyon: true,
  });
  const [searchText, setSearchText] = useState('');
  const [activeTab, setActiveTab] = useState('All');

  const { explosions } = data;

  const searcher = createSearch<Explosion>(searchText, (exp) => {
    const parts: string[] = [];

    if (searchFields.time) parts.push(exp.time);
    if (searchFields.coordinates) parts.push(`${exp.x}.${exp.y}.${exp.z}`);
    if (searchFields.inner_radius) parts.push(exp.devastation_range.toString());
    if (searchFields.outer_radius)
      parts.push(exp.heavy_impact_range.toString());
    if (searchFields.shockwave) parts.push(exp.light_impact_range.toString());
    if (searchFields.tachyon) parts.push(exp.seconds_taken.toString());

    return parts.join(' ');
  });

  const grouped = explosions?.reduce<Record<string, Explosion[]>>(
    (acc, exp) => {
      const severity = getSeverity(exp);

      if (!acc[severity]) {
        acc[severity] = [];
      }

      acc[severity].push(exp);
      return acc;
    },
    {},
  );

  const visibleExplosions =
    activeTab === 'All' ? explosions : grouped?.[activeTab];

  const filteredExplosions = (visibleExplosions ?? []).filter(searcher);

  return (
    <Window width={350} height={500}>
      <Window.Content scrollable>
        <Stack vertical>
          <Stack.Item>
            <DopplerTabs activeTab={activeTab} setActiveTab={setActiveTab} />
          </Stack.Item>
          <Stack.Item>
            <DopplerSearch
              searchFields={searchFields}
              setSearchFields={setSearchFields}
              searchText={searchText}
              setSearchText={setSearchText}
            />
          </Stack.Item>
          <Stack.Item grow>
            {filteredExplosions.length ? (
              <DopplerExplosions explosions={filteredExplosions} />
            ) : (
              <NoticeBox>
                <Box inline verticalAlign="middle">
                  No recorded explosions.
                </Box>
              </NoticeBox>
            )}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
