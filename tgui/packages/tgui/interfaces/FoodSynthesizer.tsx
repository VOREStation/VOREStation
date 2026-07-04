import { classes } from 'common/react';
import { filter, sortBy } from 'common/collections';
import { useBackend, useSharedState } from '../../backend';
import {
  Box,
  Button,
  LabeledList,
  Section,
  Flex,
  Tabs,
  ProgressBar,
  Stack,
  Icon,
} from '../../components';
import { Window } from '../../layouts';
import { flow } from 'common/fp';

export const FoodSynthesizer = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window width={900} height={520} resizable>
      <Window.Content>
        <Section>
          <SynthCartGuage />
        </Section>
        <Section title="Menu Selection">
          <FoodMenuTabs />
        </Section>
        <Flex>
          <Flex.Item grow fill>
            <FoodSelectionMenu />
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};

/** Displays the current Cartridge status. */

const SynthCartGuage = (props, context) => {
  const { data } = useBackend(context);
  const { isThereCart, cartFillStatus } = data;
  const adjustedCartChange = cartFillStatus / 100;
  return (
    <Section title="Cartridge Status">
      {isThereCart ? (
        <LabeledList.Item label="Product Remaining">
          {cartFillStatus ? (
            <ProgressBar color="purple" value={adjustedCartChange} width={20} />
          ) : (
            <ProgressBar color="red" value={adjustedCartChange} width={20} />
          )}
        </LabeledList.Item>
      ) : (
        <LabeledList.Item label="Cartridge Problem">
          <Box color="label">
            One or more cartridges are missing or damaged. <br />
            <br />
            Sabresnacks Co. recommends ordering a genuine Sabresnacks
            replacement cartidge through your local logistical cargo service.
          </Box>
        </LabeledList.Item>
      )}
    </Section>
  );
};

/** Dynamic menu tabs for every listing in catagory groups. */

const FoodMenuTabs = (props, context) => {
  const { act, data } = useBackend(context);
  const { active_menu, menucatagories } = data;
  const menusToShow = menucatagories.sort((a, b) => a.sortorder - b.sortorder);
  const [newMenu, setActiveMenu] = useSharedState(
    context,
    'ActiveMenu',
    data.active_menu
  );

  let handleActivemenu = (newMenu) => {
    setActiveMenu(newMenu);
    act('setactive_menu', { 'setactive_menu': newMenu });
  };

  return (
    <Section>
      <Stack>
        <Stack.Item>
          <Tabs fluid textAlign="center" flexWrap="wrap">
            {menusToShow.map((menu) => (
              <Tabs.Tab
                key={menu.ref}
                icon="list"
                selected={menu.id === active_menu}
                onClick={() => handleActivemenu(menu.id)}>
                {menu.name}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

/** Chooses the menu item, displays information, and an image. Sorts via menu based catagory attribute listed in every catagory item. */

const FoodSelectionMenu = (props, context) => {
  const { act, data } = useBackend(context);
  const { active_menu, recipes, activefood, crew_cookies, activecrew } = data;
  const { hidden } = data.recipes;

  const { iconkey } = props;

  if (!recipes) {
    return <Box color="bad">Recipes records missing!</Box>;
  }

  let handleActivefood = (newFood) => {
    setActiveFood(newFood);
    act('setactive_food', { 'setactive_food': newFood.id });
  };

  const [ActiveFood, setActiveFood] = useSharedState(
    context,
    'ActiveFood',
    data.recipes
  );

  const recipesToShow = flow([
    filter((recipe) => recipe.catagory === active_menu),
    filter((recipe) => !recipe.hidden || hidden),
    sortBy((recipe) => recipe.name),
  ])(recipes);

  let handleActivecookie = (newCookie) => {
    setActiveCookie(newCookie);
    act('setactive_crew', { 'setactive_crew': newCookie.name });
  };

  const [ActiveCookie, setActiveCookie] = useSharedState(
    context,
    'ActiveCookie',
    data.crew_cookies
  );

  const cookiesToShow = flow([
    filter((cookie) => cookie.catagory === active_menu),
    sortBy((cookie) => cookie.name),
  ])(crew_cookies);

  if (active_menu === 'crew') {
    return (
      <Section level={2}>
        <Stack>
          <Stack.Item basis="30%">
            <Section title="Food Selection" scrollable fill height="290px">
              <Tabs vertical>
                {cookiesToShow.map((cookie) => (
                  <Tabs.Tab>
                    <Button
                      key={cookie.name}
                      fluid
                      content={cookie.name}
                      selected={cookie === ActiveCookie}
                      onClick={() => handleActivecookie(cookie)}
                    />
                  </Tabs.Tab>
                ))}
              </Tabs>
            </Section>
          </Stack.Item>
          <Stack.Item grow={1} ml={2}>
            {activecrew ? (
              <Section title="Product Details" fill height="290px">
                <Box key={ActiveCookie.name}>
                  <Stack align="center" justify="flex-start">
                    <Stack.Item>
                      <LabeledList>
                        <LabeledList.Item label="Name">
                          {ActiveCookie.name}
                        </LabeledList.Item>
                        <br />
                        <LabeledList.Item label="Species">
                          {ActiveCookie.species}
                        </LabeledList.Item>
                      </LabeledList>
                      <Button
                        content="Print this Cookie"
                        onClick={() =>
                          act('crewprint', { crewprint: ActiveCookie.name })
                        }>
                        <CrewCookieIcon key={ActiveCookie.name} />
                      </Button>
                      <br />
                      <br />
                      <Box>
                        <Button
                          content="Refresh Information"
                          onClick={() => act('refresh')}
                        />
                      </Box>
                    </Stack.Item>
                  </Stack>
                </Box>
              </Section>
            ) : (
              <Section>
                <Box color="label">Please select an offering.</Box>
                <br />
                <br />
                <br />
                <Box>
                  <Button
                    content="Refresh Information"
                    onClick={() => act('refresh')}
                  />
                </Box>
              </Section>
            )}
          </Stack.Item>
        </Stack>
      </Section>
    );
  }

  return (
    <Section level={2}>
      <Stack>
        <Stack.Item basis="30%">
          <Section title="Food Selection" scrollable fill height="290px">
            <Tabs vertical>
              {recipesToShow.map((recipe) => (
                <Tabs.Tab>
                  <Button
                    key={recipe.ref}
                    fluid
                    content={recipe.name}
                    selected={recipe === ActiveFood}
                    onClick={() => handleActivefood(recipe)}
                  />
                </Tabs.Tab>
              ))}
            </Tabs>
          </Section>
        </Stack.Item>
        <Stack.Item grow={1} ml={4}>
          {activefood ? (
            <Section title="Product Details" fill height="290px">
              <Box>
                <Stack align="center" justify="flex-start">
                  <Stack.Item>
                    <Section>
                      <LabeledList>
                        <LabeledList.Item label="Name">
                          {ActiveFood.name}
                        </LabeledList.Item>
                        <br />
                        <LabeledList.Item label="Description">
                          {ActiveFood.desc}
                        </LabeledList.Item>
                      </LabeledList>
                      <br />
                      <Button
                        content="Print this meal"
                        width={'128px'}
                        height={'128px'}
                        className={classes([
                          'synthesizer128x128',
                          ActiveFood.id,
                        ])}
                        onClick={() => act('make', { make: ActiveFood.ref })}
                      />{' '}
                    </Section>
                  </Stack.Item>
                </Stack>
              </Box>
            </Section>
          ) : (
            <Section>
              <Box color="label">Please select an offering.</Box>
            </Section>
          )}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const CrewCookieIcon = (props, context) => {
  const { data } = useBackend(context);
  const { crewicon } = data;

  return (
    <Section>
      {crewicon ? (
        <img
          src={crewicon.substr(1, crewicon.length - 2)} // RS Edit
          style={{
            position: 'relative',
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            width: '128px',
            height: '128px',
            imageRendering: 'pixelated', // RS Add || For Chromium (516)
            '-ms-interpolation-mode': 'nearest-neighbor', // For IE (515)
          }}
        />
      ) : (
        <Icon
          style={{
            position: 'relative',
            left: 10,
            right: 10,
            top: 10,
            bottom: 10,
            width: '128px',
            height: '128px',
          }}
          fontSize={4}
          name="camera"
        />
      )}
    </Section>
  );
};
