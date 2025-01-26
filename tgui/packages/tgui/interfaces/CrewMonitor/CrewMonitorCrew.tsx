import { createSearch } from 'common/string';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Input, Stack, Table } from 'tgui/components';

import {
  getShownCrew,
  getSortedCrew,
  getStatColor,
  getStatText,
} from './functions';
import { crewmember, Data } from './types';

export const CrewMonitorCrew = (props: { crew: crewmember[] }) => {
  const { act, data } = useBackend<Data>();

  const [nameSearch, setNameSearch] = useState<string>('');
  const [livingStatus, setLivingStatus] = useState<boolean>(true);
  const [unconsciousStatus, setUnconsciousStatus] = useState<boolean>(true);
  const [deceasedStatus, setDeceasedStatus] = useState<boolean>(true);

  const { crew } = props;

  const { isAI, map_levels } = data;

  const levelObject = Object.fromEntries(
    map_levels.map((level) => [level.toString(), true]),
  );

  const [locationSearch, setLocationSearch] = useState<object>(levelObject);

  const [sortType, setSortType] = useState<string>('name');
  const [nameSortOrder, setNameSortOrder] = useState<boolean>(true);
  const [damageSortOrder, setDamageSortOrder] = useState<boolean>(true);
  const [locationSortOrder, setLocationSortOrder] = useState<boolean>(true);

  const testSearch = createSearch(nameSearch, (cm: crewmember) => cm.name);

  const shownCrew: crewmember[] = getShownCrew(
    crew,
    locationSearch,
    deceasedStatus,
    livingStatus,
    unconsciousStatus,
    nameSearch,
    testSearch,
  );

  const sortedCrew: crewmember[] = getSortedCrew(
    shownCrew,
    sortType,
    nameSortOrder,
    damageSortOrder,
    locationSortOrder,
  );

  return (
    <Table>
      <Table.Row header>
        <Table.Cell>Name</Table.Cell>
        <Table.Cell>Status</Table.Cell>
        <Table.Cell>Location</Table.Cell>
      </Table.Row>
      <Table.Row>
        <Table.Cell>
          <Stack>
            <Stack.Item grow>
              <Input
                fluid
                value={nameSearch}
                placeholder="Search for Name..."
                onChange={(e, val) => setNameSearch(val)}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                selected={sortType === 'name'}
                icon={nameSortOrder ? 'arrow-down' : 'arrow-up'}
                height="19px"
                tooltip={nameSortOrder ? 'Descending order' : 'Ascending order'}
                tooltipPosition="bottom-end"
                ml="0.5rem"
                onClick={() => {
                  setSortType('name');
                  setNameSortOrder(!nameSortOrder);
                }}
              />
            </Stack.Item>
          </Stack>
        </Table.Cell>
        <Table.Cell>
          <Button.Checkbox
            checked={livingStatus}
            onClick={() => setLivingStatus(!livingStatus)}
          >
            Livin
          </Button.Checkbox>
          <Button.Checkbox
            checked={unconsciousStatus}
            onClick={() => setUnconsciousStatus(!unconsciousStatus)}
          >
            Uncon
          </Button.Checkbox>
          <Button.Checkbox
            checked={deceasedStatus}
            onClick={() => setDeceasedStatus(!deceasedStatus)}
          >
            Decea
          </Button.Checkbox>
          <Button
            selected={sortType === 'damage'}
            icon={damageSortOrder ? 'arrow-down' : 'arrow-up'}
            height="19px"
            tooltip={damageSortOrder ? 'Descending order' : 'Ascending order'}
            tooltipPosition="bottom-end"
            ml="0.5rem"
            onClick={() => {
              setSortType('damage');
              setDamageSortOrder(!damageSortOrder);
            }}
          />
        </Table.Cell>
        <Table.Cell>
          {map_levels
            .sort((a, b) => Number(a) - Number(b))
            .map((level) => (
              <Button
                key={level}
                selected={locationSearch[level]}
                onClick={() => {
                  setLocationSearch({
                    ...locationSearch,
                    [level]: !locationSearch[level],
                  });
                }}
              >
                {level.toString()}
              </Button>
            ))}
          <Button
            selected={sortType === 'location'}
            icon={locationSortOrder ? 'arrow-down' : 'arrow-up'}
            height="19px"
            tooltip={locationSortOrder ? 'Descending order' : 'Ascending order'}
            tooltipPosition="bottom-end"
            ml="0.5rem"
            onClick={() => {
              setSortType('location');
              setLocationSortOrder(!locationSortOrder);
            }}
          />
        </Table.Cell>
      </Table.Row>
      {sortedCrew.map((cm) => (
        <Table.Row key={cm.ref}>
          <Table.Cell>
            {cm.name} ({cm.assignment})
          </Table.Cell>
          <Table.Cell>
            <Box inline color={getStatColor(cm)}>
              {getStatText(cm)}
            </Box>
            {cm.sensor_type >= 2 ? (
              <Box inline>
                {'('}
                <Box inline color="red">
                  {cm.brute}
                </Box>
                {'|'}
                <Box inline color="orange">
                  {cm.fire}
                </Box>
                {'|'}
                <Box inline color="green">
                  {cm.tox}
                </Box>
                {'|'}
                <Box inline color="blue">
                  {cm.oxy}
                </Box>
                {')'}
              </Box>
            ) : null}
          </Table.Cell>
          <Table.Cell>
            {cm.sensor_type === 3 ? (
              isAI ? (
                <Button
                  fluid
                  icon="location-arrow"
                  onClick={() =>
                    act('track', {
                      track: cm.ref,
                    })
                  }
                >
                  {cm.area + ' (' + cm.x + ', ' + cm.y + ')'}
                </Button>
              ) : (
                cm.area + ' (' + cm.x + ', ' + cm.y + ', ' + cm.z + ')'
              )
            ) : (
              'Not Available'
            )}
          </Table.Cell>
        </Table.Row>
      ))}
    </Table>
  );
};
