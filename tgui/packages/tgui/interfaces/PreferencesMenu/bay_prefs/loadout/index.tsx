import { useState } from 'react';
import { Box, Section, Tabs } from 'tgui-core/components';

import {
  type LoadoutData,
  type LoadoutDataConstant,
  type LoadoutDataStatic,
} from './data';
import { SubtabEquipment } from './SubtabEquipment';
import { SubtabLoadout } from './SubtabLoadout';

export const Loadout = (props: {
  data: LoadoutData;
  staticData: LoadoutDataStatic;
  serverData: LoadoutDataConstant;
}) => {
  const { data, staticData, serverData } = props;

  return (
    <LoadoutContent
      data={data}
      staticData={staticData}
      serverData={serverData}
    />
  );
};

enum Subtabs {
  Equipment,
  Loadout,
}

export const LoadoutContent = (props: {
  data: LoadoutData;
  staticData: LoadoutDataStatic;
  serverData: LoadoutDataConstant;
}) => {
  const { data, staticData, serverData } = props;

  const [subtab, setSubtab] = useState(Subtabs.Equipment);

  return (
    <Section
      fill
      scrollable
      title={
        <Tabs>
          <Tabs.Tab
            selected={subtab === Subtabs.Equipment}
            onClick={() => setSubtab(Subtabs.Equipment)}
          >
            Equipment
          </Tabs.Tab>
          <Tabs.Tab
            selected={subtab === Subtabs.Loadout}
            onClick={() => setSubtab(Subtabs.Loadout)}
          >
            Loadout
          </Tabs.Tab>
        </Tabs>
      }
      mt={1}
    >
      {subtab === Subtabs.Equipment ? (
        <SubtabEquipment
          data={data}
          staticData={staticData}
          serverData={serverData}
        />
      ) : subtab === Subtabs.Loadout ? (
        <SubtabLoadout
          data={data}
          staticData={staticData}
          serverData={serverData}
        />
      ) : (
        <Box>Error</Box>
      )}
    </Section>
  );
};
