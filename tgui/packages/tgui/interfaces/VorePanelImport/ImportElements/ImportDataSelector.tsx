import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Input, Section, Stack } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';
import type { DesiredData } from '../types';

export const ImportDataSelector = (props: {
  characterData: DesiredData;
  selectedCharacters: Set<string>;
  selectedBellies: Set<string>;
  onSelectedBellies: React.Dispatch<React.SetStateAction<Set<string>>>;
  activeTab: string;
}) => {
  const { act } = useBackend();
  const {
    characterData,
    selectedCharacters,
    selectedBellies,
    onSelectedBellies,
    activeTab,
  } = props;

  const [searchText, setSearchText] = useState('');

  const filteredData = Object.fromEntries(
    Array.from(selectedCharacters).map((name) => [name, characterData[name]]),
  );

  const bellySearch = createSearch(
    searchText,
    (belly: { name: string }) => belly.name,
  );

  const belliesToShow = Object.values(
    filteredData[activeTab]?.bellies ?? [],
  ).filter(bellySearch);

  function toggleBelly(name: string | number | null) {
    const stringValue = String(name);
    onSelectedBellies((prevSet) => {
      const nextSet = new Set(prevSet);
      if (nextSet.has(stringValue)) {
        nextSet.delete(stringValue);
      } else {
        nextSet.add(stringValue);
      }
      return nextSet;
    });
  }

  function toggleAllBellies() {
    const allBellyNames = Object.values(
      filteredData[activeTab]?.bellies ?? {},
    ).map((b) => String(b.name));
    const allSelected = allBellyNames.every((name) =>
      selectedBellies.has(name),
    );

    onSelectedBellies(allSelected ? new Set() : new Set(allBellyNames));
  }

  function handleImport() {
    const bellies = filteredData[activeTab]?.bellies ?? {};

    const selected = Object.values(bellies).filter((b) =>
      selectedBellies.has(String(b.name)),
    );
    act('import_bellies', { data: selected });
  }

  return (
    <Stack fill>
      <Stack.Item grow>
        <Section
          fill
          title="Bellies"
          buttons={
            <Stack>
              <Stack.Item>
                <Button
                  onClick={() => toggleAllBellies()}
                  disabled={!(activeTab && filteredData[activeTab]?.bellies)}
                >
                  Toggle All
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  onClick={() => handleImport()}
                  disabled={!(activeTab && filteredData[activeTab]?.bellies)}
                >
                  Import
                </Button>
              </Stack.Item>
            </Stack>
          }
        >
          <Stack fill vertical>
            <Stack.Item>
              <Input
                fluid
                value={searchText}
                onChange={setSearchText}
                placeholder="Search bellies..."
              />
            </Stack.Item>
            <Stack.Divider />
            <Stack.Item grow>
              <Section fill scrollable>
                <Stack fill vertical>
                  {belliesToShow.map((value) => (
                    <Stack.Item key={value.name}>
                      <Button.Checkbox
                        checked={selectedBellies.has(String(value.name))}
                        onClick={() => toggleBelly(value.name)}
                      >
                        {value.name}
                      </Button.Checkbox>
                    </Stack.Item>
                  ))}
                </Stack>
              </Section>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section
          scrollable
          fill
          title="Soulcatcher"
          buttons={
            <Button
              disabled={!(activeTab && filteredData[activeTab]?.soulcatcher)}
              onClick={() =>
                act('import_soulcatcher', {
                  data: filteredData[activeTab]?.soulcatcher,
                })
              }
            >
              Import
            </Button>
          }
        >
          <Stack fill vertical>
            {!!filteredData[activeTab] &&
              (filteredData[activeTab].soulcatcher ? (
                <Stack.Item>
                  {filteredData[activeTab].soulcatcher.name}
                </Stack.Item>
              ) : (
                <>
                  <Stack.Item>
                    <Box color="red">No data Found</Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Box color="red">
                      {`Version ${filteredData[activeTab]?.version} < 0.2`}
                    </Box>
                  </Stack.Item>
                </>
              ))}
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
