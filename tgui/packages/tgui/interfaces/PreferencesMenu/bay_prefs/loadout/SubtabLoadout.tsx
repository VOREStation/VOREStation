/* eslint-disable react/no-danger */
import { Fragment, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack, Table } from 'tgui-core/components';

import {
  type LoadoutData,
  type LoadoutDataConstant,
  type LoadoutDataStatic,
} from './data';

export const SubtabLoadout = (props: {
  data: LoadoutData;
  staticData: LoadoutDataStatic;
  serverData: LoadoutDataConstant;
}) => {
  const { act } = useBackend();
  const { data, staticData, serverData } = props;
  const { gear_slot, total_cost, active_gear_list, gear_tweaks } = data;
  const { categories, max_gear_cost } = staticData;

  const [activeCategory, setActiveCategory] = useState(
    Object.keys(categories)[0],
  );

  const activeCategoryItems = categories[activeCategory];

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Stack fill justify="space-between">
          <Stack.Item>
            <Button onClick={() => act('prev_slot')}>{'<<'}</Button>
            <Box inline color="average" ml={1} mr={1}>
              [{gear_slot}]
            </Box>
            <Button onClick={() => act('next_slot')}>{'>>'}</Button>
          </Stack.Item>
          <Stack.Item>
            <Box color="average" inline mr={1}>
              {total_cost}/{max_gear_cost}
            </Box>
            loadout points spent.
          </Stack.Item>
          <Stack.Item>
            [<Button onClick={() => act('copy_loadout')}>Copy Slot</Button>] [
            <Button onClick={() => act('clear_loadout')}>Clear Loadout</Button>]
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item textAlign="center">
        {Object.keys(categories).map((key) => (
          <Button
            key={key}
            selected={key === activeCategory}
            onClick={() => setActiveCategory(key)}
            mr={1}
            mt={1}
          >
            {key}
          </Button>
        ))}
      </Stack.Item>
      <Stack.Divider />
      <Stack.Item textAlign="center">
        <Box bold fontSize={1.2}>
          {activeCategory}
        </Box>
      </Stack.Item>
      <Stack.Divider />
      <Stack.Item grow>
        <Section mt={1} fill scrollable>
          <Table>
            {activeCategoryItems.map((item) => (
              <Fragment key={item.name}>
                <Table.Row>
                  <Table.Cell collapsing>
                    <Button
                      selected={
                        active_gear_list ? item.name in active_gear_list : false
                      }
                      onClick={() => act('toggle_gear', { gear: item.name })}
                    >
                      {item.name}
                    </Button>
                  </Table.Cell>
                  <Table.Cell collapsing>{item.cost}</Table.Cell>
                  <Table.Cell style={{ wordWrap: 'break-word' }}>
                    {item.desc}
                  </Table.Cell>
                </Table.Row>
                {item.show_roles && item.allowed_roles?.length ? (
                  <Table.Row>
                    <Table.Cell colSpan={2} textAlign="right">
                      Allowed Roles:
                    </Table.Cell>
                    <Table.Cell>{item.allowed_roles.join(',')}</Table.Cell>
                  </Table.Row>
                ) : null}
                {item.name in gear_tweaks ? (
                  <Table.Row>
                    <Table.Cell colSpan={3}>
                      {gear_tweaks[item.name].map((tweak) => (
                        <Box ml={4} key={tweak.ref}>
                          <Button
                            onClick={() =>
                              act('gear_tweak', {
                                gear: item.name,
                                tweak: tweak.ref,
                              })
                            }
                          >
                            <div
                              dangerouslySetInnerHTML={{
                                __html: tweak.contents,
                              }}
                            />
                          </Button>
                        </Box>
                      ))}
                    </Table.Cell>
                  </Table.Row>
                ) : null}
              </Fragment>
            ))}
          </Table>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
