import { type ReactNode, useState } from 'react';
import { Box, Icon, Section, Tabs } from 'tgui-core/components';

import {
  type GeneralData,
  type GeneralDataConstant,
  type GeneralDataStatic,
} from './data';
import { SubtabBody } from './SubtabBody';
import { SubtabInfo } from './SubtabInfo';
import { SubtabNotes } from './SubtabNotes';
import { SubtabSettings } from './SubtabSettings';
import { SubtabSpecies } from './SubtabSpecies';
import { SubtabTraits } from './SubtabTraits';

// ///////////////
// Main Components
// ///////////////

export const General = (props: {
  data: GeneralData;
  staticData: GeneralDataStatic;
  serverData: GeneralDataConstant;
}) => {
  return (
    <GeneralContent
      data={props.data}
      staticData={props.staticData}
      serverData={props.serverData}
    />
  );
};

enum SubtabState {
  Info = 'Info',
  Species = 'Species',
  Body = 'Body',
  CharSettings = 'CharSettings',
  Notes = 'Notes',
  Traits = 'Traits',
}

const SUBTAB_TO_NAME = {
  [SubtabState.Info]: (
    <Box inline>
      Info <Icon name="circle-info" />
    </Box>
  ),
  [SubtabState.Species]: (
    <Box inline>
      Species <Icon name="dna" />
    </Box>
  ),
  [SubtabState.Body]: (
    <Box inline>
      Physical Attributes <Icon name="person-walking" />
    </Box>
  ),
  [SubtabState.CharSettings]: (
    <Box inline>
      Character Settings <Icon name="gear" />
    </Box>
  ),
  [SubtabState.Notes]: (
    <Box inline>
      Notes <Icon name="clipboard-o" />
    </Box>
  ),
  [SubtabState.Traits]: (
    <Box inline>
      Traits <Icon name="tractor" />
    </Box>
  ),
};

const SUBTAB_TO_COMPONENT: Record<
  SubtabState,
  (props: {
    data: GeneralData;
    staticData: GeneralDataStatic;
    serverData: GeneralDataConstant;
  }) => ReactNode
> = {
  [SubtabState.Info]: (props) => <SubtabInfo {...props} />,
  [SubtabState.Species]: (props) => <SubtabSpecies {...props} />,
  [SubtabState.Body]: (props) => <SubtabBody {...props} />,
  [SubtabState.CharSettings]: (props) => <SubtabSettings {...props} />,
  [SubtabState.Notes]: (props) => <SubtabNotes {...props} />,
  [SubtabState.Traits]: (props) => <SubtabTraits {...props} />,
};

export const GeneralContent = (props: {
  data: GeneralData;
  staticData: GeneralDataStatic;
  serverData: GeneralDataConstant;
}) => {
  const { data, staticData, serverData } = props;

  const all_subtabs = Object.keys(SubtabState).map(
    (string) => string as any as SubtabState,
  );

  const [subtab, setSubtab] = useState<SubtabState>(SubtabState.Info);

  return (
    <Section
      title={
        <Tabs>
          {all_subtabs.map((state) => {
            const title = SUBTAB_TO_NAME[state];
            return (
              <Tabs.Tab
                key={state}
                selected={subtab === state}
                onClick={() => setSubtab(state)}
              >
                {title}
              </Tabs.Tab>
            );
          })}
        </Tabs>
      }
      fill
      scrollable
      mt={1}
      position="relative"
    >
      {SUBTAB_TO_COMPONENT[subtab](props)}
    </Section>
  );
};
