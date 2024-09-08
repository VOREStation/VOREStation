import { binaryInsertWith, sortBy } from 'common/collections';
import { ReactNode, useState } from 'react';

import { useBackend } from '../../backend';
import { Box, Button, Flex, Input, Section, Tooltip } from '../../components';
import { PreferencesMenuData } from './data';
import features from './preferences/features';
import { FeatureValueInput } from './preferences/features/base';
import { TabbedMenu } from './TabbedMenu';

type PreferenceChild = {
  name: string;
  children: ReactNode;
};

const binaryInsertPreference = (
  collection: PreferenceChild[],
  value: PreferenceChild,
) => binaryInsertWith(collection, value, (child) => child.name);

const sortByName = (array: [string, PreferenceChild[]][]) =>
  sortBy(array, ([name]) => name);

export const GamePreferencesPage = (props) => {
  const { act, data } = useBackend<PreferencesMenuData>();

  const gamePreferences: Record<string, PreferenceChild[]> = {};

  for (const [featureId, value] of Object.entries(
    data.character_preferences.game_preferences,
  )) {
    const feature = features[featureId];

    let nameInner: ReactNode = feature?.name || featureId;

    if (feature?.description) {
      nameInner = (
        <Box
          as="span"
          style={{
            borderBottom: '2px dotted rgba(255, 255, 255, 0.8)',
          }}
        >
          {nameInner}
        </Box>
      );
    }

    let name: ReactNode = (
      <Flex.Item grow={1} pr={2} basis={0} ml={2}>
        {nameInner}
      </Flex.Item>
    );

    if (feature?.description) {
      name = (
        <Tooltip content={feature.description} position="bottom-start">
          {name}
        </Tooltip>
      );
    }

    const child = (
      <Flex align="center" key={featureId} pb={2}>
        {name}

        <Flex.Item grow={1} basis={0}>
          {(feature && (
            <FeatureValueInput
              feature={feature}
              featureId={featureId}
              value={value}
              act={act}
            />
          )) || (
            <Box as="b" color="red">
              ...is not filled out properly!!!
            </Box>
          )}
        </Flex.Item>
      </Flex>
    );

    const entry = {
      name: feature?.name || featureId,
      children: child,
    };

    const category = feature?.category || 'ERROR';

    gamePreferences[category] = binaryInsertPreference(
      gamePreferences[category] || [],
      entry,
    );
  }

  const [search, setSearch] = useState<string>('');
  const [searchVisible, setSearchVisible] = useState(false);

  // For some reason, typescript thinks that this call to filter() can change the shape of the array
  const gamePreferenceEntries: any = sortByName(Object.entries(gamePreferences))
    .map(([category, preferences]) => {
      return [
        category,
        preferences
          .filter(
            (entry) =>
              !search ||
              entry.name.toLowerCase().includes(search.toLowerCase()),
          )
          .map((entry) => entry.children),
      ];
    })
    .filter(([category, prefs]) => prefs.length !== 0);

  return (
    <>
      {!gamePreferenceEntries.length && (
        <Section title="No Results">No results found.</Section>
      )}
      <Box position="absolute" right={4} top={4} style={{ zIndex: '100' }}>
        {searchVisible && (
          <Input
            width={16}
            value={search}
            onInput={(e, val) => setSearch(val)}
            onChange={(e, val) => setSearch(val)}
          />
        )}
        <Button
          selected={searchVisible}
          icon="magnifying-glass"
          tooltip="Search"
          tooltipPosition="bottom"
          onClick={() => {
            setSearchVisible(!searchVisible);
            setSearch('');
          }}
        />
      </Box>
      <TabbedMenu
        categoryEntries={gamePreferenceEntries}
        contentProps={{
          fontSize: 1.5,
        }}
      />
    </>
  );
};
