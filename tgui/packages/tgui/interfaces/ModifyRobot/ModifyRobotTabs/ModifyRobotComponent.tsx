import { capitalize } from 'common/string';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Dropdown,
  Flex,
  Icon,
  Image,
  Input,
  Section,
  Stack,
} from 'tgui/components';

import { NoSpriteWarning } from '../components';
import { prepareSearch } from '../functions';
import { Cell, Component, Target } from '../types';

export const ModifyRobotComponent = (props: {
  target: Target;
  cell: string | null;
  cells: Record<string, Cell>;
}) => {
  const { target, cell, cells } = props;
  const [searchComponentReplaceText, setSearchComponentReplaceText] =
    useState<string>('');
  const [searchComponentRemoveText, setSearchComponentRemoveText] =
    useState<string>('');
  const [selectedCell, setSelectedCell] = useState<string>(cell || '');
  const cell_options = Object.keys(cells) as Array<string>;

  return (
    <>
      {!target.active && <NoSpriteWarning name={target.name} />}
      <Flex height={!target.active ? '80%' : '85%'}>
        <Flex.Item width="40%" fill>
          <ComponentSection
            title="Repair Component"
            searchText={searchComponentReplaceText}
            onSearchText={setSearchComponentReplaceText}
            components={target.components}
            action="add_component"
            buttonColor="green"
            buttonIcon="arrows-spin"
            celltype={cells[selectedCell]?.path}
            selected_cell={selectedCell}
            cell={cell || undefined}
          />
        </Flex.Item>
        <Flex.Item width="30%">
          <Stack vertical>
            <Stack.Item>
              <Image
                src={'data:image/jpeg;base64, ' + target.side_alt}
                style={{
                  display: 'block',
                  marginLeft: 'auto',
                  marginRight: 'auto',
                  width: '200px',
                }}
              />
            </Stack.Item>
            <Stack.Item>
              <Section title="Powercell">
                Current cell:{' '}
                {cell ? (
                  capitalize(cell)
                ) : (
                  <Box inline color="red">
                    No cell installed!
                  </Box>
                )}
                <Dropdown
                  width="100%"
                  selected={selectedCell}
                  options={cell_options}
                  onSelected={setSelectedCell}
                />
                <Stack vertical>
                  <Stack.Item>
                    Charge State: {cells[selectedCell]?.charge} /{' '}
                    {cells[selectedCell]?.max_charge}
                  </Stack.Item>
                  <Stack.Item>
                    Charge Rate: {cells[selectedCell]?.charge_amount}
                  </Stack.Item>
                  <Stack.Item>
                    Self Charge:{' '}
                    {cells[selectedCell]?.self_charge ? 'Yes' : 'No'}
                  </Stack.Item>
                </Stack>
              </Section>
            </Stack.Item>
          </Stack>
        </Flex.Item>
        <Flex.Item width="30%" fill>
          <ComponentSection
            title="Remove Component"
            searchText={searchComponentRemoveText}
            onSearchText={setSearchComponentRemoveText}
            components={target.components}
            action="rem_component"
            buttonColor="red"
            buttonIcon="burst"
          />
        </Flex.Item>
      </Flex>
    </>
  );
};

const ComponentSection = (props: {
  title: string;
  searchText: string;
  onSearchText: Function;
  components: Component[];
  action: string;
  buttonColor: string;
  buttonIcon: string;
  celltype?: string;
  selected_cell?: string;
  cell?: string;
}) => {
  const { act } = useBackend();
  const {
    title,
    searchText,
    onSearchText,
    components,
    action,
    buttonColor,
    buttonIcon,
    celltype,
    selected_cell,
    cell,
  } = props;
  return (
    <Section title={title} fill scrollable>
      <Input
        fluid
        value={searchText}
        placeholder="Search for components..."
        onInput={(e, value: string) => onSearchText(value)}
      />
      <Divider />
      <Stack>
        <Stack.Item width="100%">
          {prepareSearch(components, searchText).map((component, i) => {
            return (
              <Button
                fluid
                key={i}
                tooltip={getComponentTooltip(
                  component,
                  action,
                  selected_cell,
                  cell,
                )}
                color={getComponentColor(component, action)}
                disabled={checkDisabled(component, action, selected_cell, cell)}
                onClick={() =>
                  act(action, {
                    component: component.ref,
                    cell: celltype,
                  })
                }
              >
                <Stack vertical>
                  <Stack.Item>
                    <Flex varticalAlign="center">
                      <Flex.Item>
                        {capitalize(component.name)}{' '}
                        {action === 'add_component' &&
                          '(' + component.max_damage + ')'}
                      </Flex.Item>
                      <Flex.Item grow />
                      <Flex.Item>
                        <Icon
                          name={buttonIcon}
                          backgroundColor={buttonColor}
                          size={1.5}
                        />
                      </Flex.Item>
                    </Flex>
                  </Stack.Item>
                  <Stack.Item>
                    {action === 'add_component' &&
                      'Brute Damage: ' + component.brute_damage}
                  </Stack.Item>
                  {action === 'add_component' &&
                    'Electronics Damage: ' + component.electronics_damage}
                  <Stack.Item />
                </Stack>
              </Button>
            );
          })}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

function checkDisabled(
  component: Component,
  action: string,
  selected_cell: string | undefined,
  cell: string | undefined,
): boolean {
  switch (action) {
    case 'rem_component':
      return !component.exists;
    case 'add_component':
      if (
        selected_cell &&
        cell &&
        component.name === 'power cell' &&
        selected_cell !== cell
      ) {
        return false;
      }
      return (
        component.installed === 1 &&
        !!component.exists &&
        component.brute_damage === 0 &&
        component.electronics_damage === 0
      );
  }
  return false;
}

function getComponentTooltip(
  component: Component,
  action: string,
  selected_cell: string | undefined,
  cell: string | undefined,
): string {
  switch (action) {
    case 'add_component':
      if (component.installed === 0 || !component.exists) {
        return 'Component missing!';
      }
      if (
        component.installed === -1 ||
        component.brute_damage + component.electronics_damage >=
          component.max_damage
      ) {
        return 'Component destroyed!';
      }
      if (checkDisabled(component, action, selected_cell, cell)) {
        return 'Disabled due to fully intact component!';
      }
      return '';
    case 'rem_component':
      return component.exists ? '' : 'Disabled due to missing component!';
  }
  return '';
}

function getComponentColor(
  component: Component,
  action: string,
): string | undefined {
  switch (action) {
    case 'add_component':
      if (
        component.brute_damage + component.electronics_damage >=
          component.max_damage ||
        component.installed !== 1 ||
        !component.exists
      ) {
        return 'black';
      }
      if (
        (component.brute_damage + component.electronics_damage) /
          component.max_damage >
        0.66
      ) {
        return 'red';
      }
      if (
        (component.brute_damage + component.electronics_damage) /
          component.max_damage >
        0.33
      ) {
        return 'orange';
      }
      if (
        (component.brute_damage + component.electronics_damage) /
          component.max_damage >
        0
      ) {
        return 'yellow';
      }
      return undefined;
    case 'rem_component':
      return undefined;
  }
  return '';
}
