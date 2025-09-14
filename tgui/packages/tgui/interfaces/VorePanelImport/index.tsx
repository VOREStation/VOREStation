import { useEffect, useState } from 'react';
import { Window } from 'tgui/layouts';
import { Stack, Tabs } from 'tgui-core/components';
import { CharacterSelector } from './ImportElements/CharacterSelector';
import { FileImport } from './ImportElements/FileImporter';
import { ImportDataSelector } from './ImportElements/ImportDataSelector';
import type { DesiredData } from './types';

export const VorePanelImport = () => {
  const [characterData, setCharacterData] = useState<DesiredData>({});
  const [selectedCharacter, setSelectedCharacter] = useState('');
  const [selectedCharacters, setSelectedCharacters] = useState<Set<string>>(
    new Set(),
  );
  const [selectedBellies, setSelectedBellies] = useState<Set<string>>(
    new Set(),
  );
  const [activeTab, setActiveTab] = useState('');
  const [currentLength, setCurrentLength] = useState(0);
  const [selectedVersions, setSelectedVersions] = useState<string[]>([]);
  const [selectedOrigins, setSelectedOrigins] = useState<string[]>([]);

  const filteredData = Object.fromEntries(
    Array.from(selectedCharacters).map((name) => [name, characterData[name]]),
  );

  const ourCharacters = Object.keys(characterData);

  useEffect(() => {
    if (!activeTab && selectedCharacters.size) {
      setActiveTab(Object.keys(filteredData)[0]);
    }
    if (activeTab && !selectedCharacters.has(activeTab)) {
      setActiveTab('');
      setSelectedBellies(new Set());
    }
  }, [ourCharacters]);

  useEffect(() => {
    const bellies = filteredData[activeTab]?.bellies ?? {};
    const selected = Object.values(bellies).filter((b) =>
      selectedBellies.has(String(b.name)),
    );
    setCurrentLength(JSON.stringify(selected).length);
  }, [selectedBellies, filteredData, activeTab]);

  useEffect(() => {
    const allVersions = Array.from(
      new Set(
        Object.values(filteredData)
          .map((dataEntry) => dataEntry.version)
          .filter((v): v is string => typeof v === 'string'),
      ),
    );

    const allOrigins = Array.from(
      new Set(
        Object.values(filteredData)
          .map((dataEntry) => dataEntry.repo)
          .filter((v): v is string => typeof v === 'string'),
      ),
    );
    setSelectedVersions(allVersions);
    setSelectedOrigins(allOrigins);
  }, [filteredData]);

  function handleTabChange(newTab: string) {
    setActiveTab(newTab);
    setSelectedBellies(new Set());
  }

  return (
    <Window width={520} height={700} theme="abstract">
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <FileImport
              characterData={characterData}
              selectedCharacters={selectedCharacters}
              selectedCharacter={selectedCharacter}
              onCharacterData={setCharacterData}
              onSelectedCharacter={setSelectedCharacter}
              onSelectedCharacters={setSelectedCharacters}
            />
          </Stack.Item>
          <Stack.Item basis="30%">
            <CharacterSelector
              characterData={characterData}
              selectedCharacters={selectedCharacters}
              onCharacterData={setCharacterData}
              onSelectedCharacters={setSelectedCharacters}
              importLength={currentLength}
              selectedVersions={selectedVersions}
              selectedOrigins={selectedOrigins}
            />
          </Stack.Item>
          <Stack.Item>
            <Tabs scrollable>
              {Object.keys(filteredData).map((entry) => (
                <Tabs.Tab
                  selected={entry === activeTab}
                  onClick={() => handleTabChange(entry)}
                  key={entry}
                >
                  {entry}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>
            <ImportDataSelector
              characterData={characterData}
              selectedCharacters={selectedCharacters}
              selectedBellies={selectedBellies}
              onSelectedBellies={setSelectedBellies}
              activeTab={activeTab}
            />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
