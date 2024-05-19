import { sortBy } from 'common/collections';
import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Icon, NanoMap, Section, Tabs } from '../components';
import { Window } from '../layouts';
import { createLogger } from '../logging';
const logger = createLogger('fuck');

export const AtmosControl = (props) => {
  return (
    <Window width={600} height={440}>
      <Window.Content scrollable>
        <AtmosControlContent />
      </Window.Content>
    </Window>
  );
};

export const AtmosControlContent = (props) => {
  const { act, data, config } = useBackend();

  let sortedAlarms = sortBy((alarm) => alarm.name)(data.alarms || []);

  // sortedAlarms = sortedAlarms.slice(1, 3);

  const [tabIndex, setTabIndex] = useState(0);
  const [zoom, setZoom] = useState(1);

  let body;
  // Alarms View
  if (tabIndex === 0) {
    body = (
      <Section title="Alarms">
        {sortedAlarms.map((alarm) => (
          <Button
            key={alarm.name}
            color={
              alarm.danger === 2 ? 'bad' : alarm.danger === 1 ? 'average' : ''
            }
            onClick={() => act('alarm', { alarm: alarm.ref })}
          >
            {alarm.name}
          </Button>
        ))}
      </Section>
    );
  } else if (tabIndex === 1) {
    // Please note, if you ever change the zoom values,
    // you MUST update styles/components/Tooltip.scss
    // and change the @for scss to match.
    body = (
      <Box height="526px" mb="0.5rem" overflow="hidden">
        <NanoMap zoomScale={data.zoomScale} onZoom={(v) => setZoom(v)}>
          {sortedAlarms
            .filter((x) => ~~x.z === ~~config.mapZLevel)
            .map((cm) => (
              <NanoMap.Marker
                key={cm.ref}
                x={cm.x}
                y={cm.y}
                zoom={zoom}
                icon="bell"
                tooltip={cm.name}
                color={cm.danger ? 'red' : 'green'}
                onClick={() => act('alarm', { alarm: cm.ref })}
              />
            ))}
        </NanoMap>
      </Box>
    );
  }

  return (
    <>
      <Tabs>
        <Tabs.Tab
          key="AlarmView"
          selected={0 === tabIndex}
          onClick={() => setTabIndex(0)}
        >
          <Icon name="table" /> Alarm View
        </Tabs.Tab>
        <Tabs.Tab
          key="MapView"
          selected={1 === tabIndex}
          onClick={() => setTabIndex(1)}
        >
          <Icon name="map-marked-alt" /> Map View
        </Tabs.Tab>
      </Tabs>
      <Box m={2}>{body}</Box>
    </>
  );
};
