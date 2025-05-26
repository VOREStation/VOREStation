import { Section } from 'tgui-core/components';

import { ServerPreferencesFetcher } from '../ServerPreferencesFetcher';
import {
  type GeneralData,
  type GeneralDataConstant,
  type GeneralDataStatic,
} from './general/data';
import { General } from './general/index';
import { Loadout } from './loadout';
import {
  type LoadoutData,
  type LoadoutDataConstant,
  type LoadoutDataStatic,
} from './loadout/data';
import { Occupation } from './occupation';
import {
  type OccupationData,
  type OccupationDataConstant,
  type OccupationDataStatic,
} from './occupation/data';

enum Tabs {
  General = 'General',
  Occupation = 'Occupation',
  SpecialRoles = 'Special Roles',
  Loadout = 'Loadout',
  Sound = 'Sound',
  Vore = 'Vore',
}

export const BayPrefsEntryPoint = (props: {
  type: string;
  data: any;
  staticData: any;
}) => {
  const { type, data, staticData } = props;

  return (
    <ServerPreferencesFetcher
      render={(serverData) => {
        if (!serverData) {
          return <Section title="Loading..." />;
        }

        const relevantData = serverData.legacy;

        switch (type as Tabs) {
          case Tabs.General:
            return (
              <General
                data={data as GeneralData}
                staticData={staticData as GeneralDataStatic}
                serverData={relevantData as GeneralDataConstant}
              />
            );
          case Tabs.Loadout:
            return (
              <Loadout
                data={data as LoadoutData}
                staticData={staticData as LoadoutDataStatic}
                serverData={relevantData as LoadoutDataConstant}
              />
            );
          case Tabs.Occupation:
            return (
              <Occupation
                data={data as OccupationData}
                staticData={staticData as OccupationDataStatic}
                serverData={relevantData as OccupationDataConstant}
              />
            );
          default:
            return null;
        }
      }}
    />
  );
};
