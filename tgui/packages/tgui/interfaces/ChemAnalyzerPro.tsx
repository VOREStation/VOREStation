import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

import type { ReagentData } from './PublicLibraryWiki/types';
import { WikiSearchList } from './PublicLibraryWiki/WikiCommon/WikiSearchList';
import { WikiChemistryPage } from './PublicLibraryWiki/WikiPages/WikiSubPages/WikiChemistryPage';

type AnalyzerData = ReagentData & { beakerAmount: number };

type Data = { scannedReagents: AnalyzerData[]; beakerToital: number };

export const ChemAnalyzerPro = () => {
  const { data } = useBackend<Data>();
  const { scannedReagents } = data;

  const [selectedReagent, setSelectedReagent] = useState('');
  const [searchText, setSearchText] = useState('');

  const ourReagents = Object.keys(scannedReagents);

  const customSearch = createSearch(searchText, (search: string) => search);
  const toDisplay = ourReagents.filter(customSearch);

  return (
    <Window width={400} height={700}>
      <Window.Content>
        <Stack fill>
          <WikiSearchList
            title={'Compounts'}
            searchText={searchText}
            onSearchText={setSearchText}
            listEntries={toDisplay}
            basis={'20%'}
            activeEntry={selectedReagent}
            onActiveEntry={setSelectedReagent}
          />
          <Stack.Item grow>
            {selectedReagent && (
              <WikiChemistryPage
                key={selectedReagent}
                chems={ourReagents[selectedReagent]}
                beakerFill={0.25}
              />
            )}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
