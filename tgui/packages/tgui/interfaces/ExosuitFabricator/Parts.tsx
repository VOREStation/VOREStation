import { Fragment } from 'react';
import { useBackend, useSharedState } from 'tgui/backend';
import {
  Box,
  Button,
  Icon,
  Input,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

import { COLOR_BAD, COLOR_KEYS } from './constants';
import {
  getFirstValidPartSet,
  partCondFormat,
  searchFilter,
} from './functions';
import { MaterialAmount } from './Material';
import type { Data, internalPart } from './types';

export const PartSets = (props) => {
  const { data } = useBackend<Data>();

  const { partSets = [], buildableParts = [] } = data;

  const [selectedPartTab, setSelectedPartTab] = useSharedState(
    'part_tab',
    partSets.length ? buildableParts[0] : '',
  );

  return (
    <Tabs vertical>
      {partSets.map(
        (set) =>
          !!buildableParts[set] && (
            <Tabs.Tab
              key={set}
              selected={set === selectedPartTab}
              onClick={() => setSelectedPartTab(set)}
            >
              {set}
            </Tabs.Tab>
          ),
      )}
    </Tabs>
  );
};

export const PartLists = (props: {
  queueMaterials: Record<string, number>;
  materials: Record<string, number>;
}) => {
  const { data } = useBackend<Data>();

  const { partSets = [], buildableParts = [] } = data;

  const { queueMaterials, materials } = props;

  const [selectedPartTab, setSelectedPartTab] = useSharedState(
    'part_tab',
    getFirstValidPartSet(partSets, buildableParts),
  );

  const [searchText, setSearchText] = useSharedState('search_text', '');

  if (!selectedPartTab || !buildableParts[selectedPartTab]) {
    const validSet = getFirstValidPartSet(partSets, buildableParts);
    if (validSet) {
      setSelectedPartTab(validSet);
    } else {
      return;
    }
  }

  let partsObj: { Parts: internalPart[] } = {
    Parts: [],
  };
  const partsList: internalPart[] = [];
  // Build list of sub-categories if not using a search filter.
  if (!searchText) {
    partsObj = { Parts: [] };
    buildableParts[selectedPartTab!].forEach((part) => {
      part['format'] = partCondFormat(materials, queueMaterials, part);
      if (!part.subCategory) {
        partsObj['Parts'].push(part);
        return;
      }
      if (!(part.subCategory in partsObj)) {
        partsObj[part.subCategory] = [];
      }
      partsObj[part.subCategory].push(part);
    });
  } else {
    searchFilter(searchText, buildableParts).forEach((part: internalPart) => {
      part['format'] = partCondFormat(materials, queueMaterials, part);
      partsList.push(part);
    });
  }

  return (
    <>
      <Section>
        <Stack>
          <Stack.Item mr={1}>
            <Icon name="search" />
          </Stack.Item>
          <Stack.Item grow>
            <Input
              fluid
              placeholder="Search for..."
              value={searchText}
              onInput={(e, v) => setSearchText(v)}
            />
          </Stack.Item>
        </Stack>
      </Section>
      {(!!searchText && (
        <PartCategory
          name={'Search Results'}
          parts={partsList}
          forceShow
          placeholder="No matching results..."
        />
      )) ||
        Object.keys(partsObj).map((category) => (
          <PartCategory
            key={category}
            name={category}
            parts={partsObj[category]}
          />
        ))}
    </>
  );
};

const PartCategory = (props: {
  parts: internalPart[];
  name: string;
  forceShow?: boolean;
  placeholder?: string;
}) => {
  const { act, data } = useBackend<Data>();

  const { buildingPart } = data;

  const { parts, name, forceShow, placeholder } = props;

  const [displayMatCost] = useSharedState('display_mats', false);

  return (
    (!!parts.length || forceShow) && (
      <Section
        title={name}
        buttons={
          <Button
            disabled={!parts.length}
            color="good"
            icon="plus-circle"
            onClick={() =>
              act('add_queue_set', {
                part_list: parts.map((part) => part.id),
              })
            }
          >
            Queue All
          </Button>
        }
      >
        {!parts.length && placeholder}
        {parts.map((part) => (
          <Fragment key={part.name}>
            <Stack align="center">
              <Stack.Item>
                <Button
                  disabled={
                    !!buildingPart || part.format.textColor === COLOR_BAD
                  }
                  color="good"
                  height="20px"
                  mr={1}
                  icon="play"
                  onClick={() => act('build_part', { id: part.id })}
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  color="average"
                  height="20px"
                  mr={1}
                  icon="plus-circle"
                  onClick={() => act('add_queue_part', { id: part.id })}
                />
              </Stack.Item>
              <Stack.Item>
                <Box inline textColor={COLOR_KEYS[part.format.textColor]}>
                  {part.name}
                </Box>
              </Stack.Item>
              <Stack.Item grow />
              <Stack.Item>
                <Button
                  icon="question-circle"
                  color="transparent"
                  height="20px"
                  tooltip={
                    'Build Time: ' + part.printTime + 's. ' + (part.desc || '')
                  }
                  tooltipPosition="left"
                />
              </Stack.Item>
            </Stack>
            {displayMatCost && (
              <Stack mb={2}>
                {Object.keys(part.cost).map((material) => (
                  <Stack.Item
                    width={'50px'}
                    key={material}
                    color={COLOR_KEYS[part.format[material].color]}
                  >
                    <MaterialAmount
                      formatmoney
                      style={{
                        transform: 'scale(0.75) translate(0%, 10%)',
                      }}
                      name={material}
                      amount={part.cost[material]}
                    />
                  </Stack.Item>
                ))}
              </Stack>
            )}
          </Fragment>
        ))}
      </Section>
    )
  );
};
