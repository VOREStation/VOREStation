import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
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

  const filteredData = Object.fromEntries(
    Array.from(selectedCharacters).map((name) => [name, characterData[name]]),
  );

  function toggleBelly(name: string | number | null) {
    const stringValue = String(name);
    onSelectedBellies((prev) => {
      const updated = new Set(prev);
      if (updated.has(stringValue)) {
        updated.delete(stringValue);
      } else {
        updated.add(stringValue);
      }
      return updated;
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
          scrollable
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
            {filteredData[activeTab] &&
              Object.values(filteredData[activeTab].bellies).map((value) => (
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
            {!!activeTab &&
              (filteredData[activeTab]?.soulcatcher ? (
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
