import { type Dispatch, type SetStateAction, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Button,
  Divider,
  Input,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import { capitalize, createSearch } from 'tgui-core/string';

import type { ReagentData } from './PublicLibraryWiki/types';
import { WikiChemistryPage } from './PublicLibraryWiki/WikiPages/WikiSubPages/WikiChemistryPage';

type AnalyzerData = ReagentData & { beakerAmount: number };

type Data = { scannedReagents: AnalyzerData[]; beakerTotal: number };

export const ChemAnalyzerPro = () => {
  const { data } = useBackend<Data>();
  const { scannedReagents, beakerTotal } = data;

  const [selectedReagent, setSelectedReagent] = useState<AnalyzerData | null>(
    null,
  );
  const [searchText, setSearchText] = useState('');

  const customSearch = createSearch(
    searchText,
    (search: AnalyzerData) => search.title,
  );
  const toDisplay = scannedReagents.filter(customSearch);

  return (
    <Window width={400} height={700}>
      <Window.Content>
        <Section
          fill
          title={'Chemical analysis of ' + beakerTotal + 'u of Reagents'}
        >
          <Stack fill>
            <AnalyzerSearchList
              title={'Compounts'}
              searchText={searchText}
              onSearchText={setSearchText}
              listEntries={toDisplay}
              basis={'35%'}
              activeEntry={selectedReagent}
              onActiveEntry={setSelectedReagent}
              total={beakerTotal}
            />
            <Stack.Item grow>
              {selectedReagent && (
                <WikiChemistryPage
                  key={selectedReagent.title}
                  chems={selectedReagent}
                  beakerFill={0.25}
                />
              )}
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};

export const AnalyzerSearchList = (props: {
  title: string;
  searchText: string;
  onSearchText: Dispatch<SetStateAction<string>>;
  listEntries: AnalyzerData[];
  basis: string;
  activeEntry: AnalyzerData | null;
  onActiveEntry: Dispatch<SetStateAction<AnalyzerData>>;
  total: number;
}) => {
  const {
    title,
    searchText,
    onSearchText,
    onActiveEntry,
    listEntries,
    activeEntry,
    basis,
    total,
  } = props;

  return (
    <Stack.Item basis={basis}>
      <Section fill title={title}>
        <Stack vertical fill>
          <Stack.Item>
            <Input
              mr="10px"
              fluid
              value={searchText}
              placeholder={'Search for ' + title + '...'}
              onInput={(e, value: string) => onSearchText(value)}
            />
          </Stack.Item>
          <Divider />
          <Stack.Item grow>
            <Section fill scrollable>
              <Stack vertical fill>
                {listEntries.map((entry) => (
                  <Stack.Item key={entry.title}>
                    <ProgressBar
                      color="white"
                      position="absolute"
                      value={!total ? 0 : entry.beakerAmount / total}
                    >
                      <Button
                        color="transparent"
                        textColor={entry === activeEntry ? 'green' : 'red'}
                        fluid
                        onClick={() => {
                          onActiveEntry(entry);
                        }}
                      >
                        {capitalize(entry.title) +
                          ' ' +
                          (
                            (!total ? 0 : entry.beakerAmount / total) * 100
                          ).toFixed() +
                          '%'}
                      </Button>
                    </ProgressBar>
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Section>
    </Stack.Item>
  );
};
