import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  LabeledList,
  NoticeBox,
  Section,
  Tabs,
} from 'tgui-core/components';
import { explosionTypes } from './constants';
import { getSeverity } from './functions';
import type { Data, Explosion } from './types';

export const DopplerArray = (props) => {
  const { act, data } = useBackend<Data>();
  const [activeTab, setActiveTab] = useState('All');

  const { explosions } = data;

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

  return (
    <Window width={300} height={500}>
      <Window.Content scrollable>
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
        {visibleExplosions?.length ? (
          visibleExplosions.map((exp) => (
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
      </Window.Content>
    </Window>
  );
};
