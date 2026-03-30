import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Collapsible,
  Input,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { capitalize, createSearch } from 'tgui-core/string';
import { explosionTypes } from './constants';
import { getSeverity } from './functions';
import type { Data, Explosion } from './types';

export const DopplerArray = (props) => {
  const { act, data } = useBackend<Data>();
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
            <Tabs>
              {['All', ...explosionTypes].map((sev) => (
                <Tabs.Tab
                  key={sev}
                  selected={activeTab === sev}
                  onClick={() => setActiveTab(sev)}
                >
                  {sev}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Stack.Item>
          <Stack.Item>
            <Collapsible color="transparent" title="Search Filter">
              <Stack wrap="wrap">
                {Object.keys(searchFields).map((field) => (
                  <Stack.Item key={field}>
                    <Button.Checkbox
                      checked={searchFields[field]}
                      onClick={() =>
                        setSearchFields({
                          ...searchFields,
                          [field]: !searchFields[field],
                        })
                      }
                    >
                      {capitalize(field.replace(/_/g, ' '))}
                    </Button.Checkbox>
                  </Stack.Item>
                ))}
              </Stack>
              <Input
                placeholder="Search explosions..."
                value={searchText}
                onChange={(value) => setSearchText(value)}
                fluid
              />
            </Collapsible>
          </Stack.Item>
          <Stack.Item grow>
            {filteredExplosions?.length ? (
              filteredExplosions.map((exp) => (
                <Section key={exp.index} title={exp.time}>
                  <LabeledList>
                    <LabeledList.Item label="Coordinates">
                      {exp.x}.{exp.y}.{exp.z}
                    </LabeledList.Item>
                    <LabeledList.Item label="Inner Radius">
                      {exp.devastation_range}
                    </LabeledList.Item>
                    <LabeledList.Item label="Outer Radius">
                      {exp.heavy_impact_range}
                    </LabeledList.Item>
                    <LabeledList.Item label="Shockwave Radius">
                      {exp.light_impact_range}
                    </LabeledList.Item>
                    <LabeledList.Item label="Tachyon Displacement">
                      {exp.seconds_taken}
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              ))
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
