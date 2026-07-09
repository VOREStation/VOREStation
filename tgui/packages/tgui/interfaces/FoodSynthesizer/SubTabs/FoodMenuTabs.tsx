import { useBackend } from 'tgui/backend';
import { Stack, Tabs } from 'tgui-core/components';
import type { Data } from '../types';

export const FoodMenuTabs = (props) => {
  const { act, data } = useBackend<Data>();
  const { active_menu, menucatagories } = data;

  const menusToShow = [...menucatagories].sort(
    (a, b) => a.sortorder - b.sortorder,
  );

  return (
    <Stack>
      <Stack.Item>
        <Tabs fluid textAlign="center">
          {menusToShow.map((menu) => (
            <Tabs.Tab
              key={menu.ref}
              icon="list"
              selected={menu.id === active_menu}
              onClick={() => act('setactive_menu', { setactive_menu: menu.id })}
            >
              {menu.name}
            </Tabs.Tab>
          ))}
        </Tabs>
      </Stack.Item>
    </Stack>
  );
};
