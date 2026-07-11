import { sanitizeCssClassName } from 'common/css_sanity';
import { useEffect } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  LabeledList,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import { CrewCookieIcon } from '../CrewCookieIcon';
import type { Data } from '../types';

export const FoodSelectionMenu = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    busy,
    menucatagories,
    active_menu,
    activefood,
    crew_cookies,
    activecrew,
  } = data;
  crew_cookies;

  const recipesToShow = menucatagories
    .find((category) => category.id === active_menu)
    ?.recipes.filter((recipe) => !recipe.hidden)
    .sort((a, b) => a.name.localeCompare(b.name));

  const selectedFood = recipesToShow?.find((c) => c.type === activefood);
  const selectedCrew = crew_cookies.find((c) => c.name === activecrew);

  useEffect(() => {
    if (active_menu !== 'crew' && !selectedFood && recipesToShow?.length) {
      act('setactive_food', { setactive_food: recipesToShow[0].type });
    }
  }, [active_menu]);

  if (!recipesToShow) {
    return <Box color="bad">No recipes found!</Box>;
  }

  const cookiesToShow = crew_cookies
    .filter((cookie) => cookie.category === active_menu)
    .sort((a, b) => a.name.localeCompare(b.name));

  return (
    <Section fill>
      <Stack fill>
        <Stack.Item basis="30%">
          <Section
            title="Food Selection"
            scrollable
            fill
            buttons={
              active_menu === 'crew' && (
                <Button
                  onClick={() => act('refresh')}
                  tooltip="Refresh"
                  icon="arrows-rotate"
                />
              )
            }
          >
            <Tabs vertical>
              {active_menu === 'crew'
                ? cookiesToShow.map((cookie) => (
                    <Tabs.Tab key={cookie.name}>
                      <Button
                        fluid
                        selected={
                          selectedCrew && cookie.name === selectedCrew.name
                        }
                        onClick={() => {
                          act('setactive_crew', {
                            setactive_crew: cookie.name,
                          });
                        }}
                      >
                        {cookie.name}
                      </Button>
                    </Tabs.Tab>
                  ))
                : recipesToShow.map((recipe) => (
                    <Tabs.Tab key={recipe.ref}>
                      <Button
                        fluid
                        selected={
                          selectedFood && recipe.ref === selectedFood.ref
                        }
                        onClick={() =>
                          act('setactive_food', {
                            setactive_food: recipe.type,
                          })
                        }
                      >
                        {recipe.name}
                      </Button>
                    </Tabs.Tab>
                  ))}
            </Tabs>
          </Section>
        </Stack.Item>
        <Stack.Item grow ml={1}>
          {active_menu === 'crew' ? (
            selectedCrew ? (
              <Section title="Product Details" fill scrollable>
                <Stack vertical>
                  <Stack.Item>
                    <LabeledList>
                      <LabeledList.Item label="Name">
                        {selectedCrew.name}
                      </LabeledList.Item>
                      <LabeledList.Item label="Species">
                        {selectedCrew.species}
                      </LabeledList.Item>
                    </LabeledList>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      disabled={busy}
                      align="center"
                      color="transparent"
                      onClick={() =>
                        act('crewprint', {
                          crewprint: selectedCrew.name,
                        })
                      }
                    >
                      <CrewCookieIcon />
                      <Box>Print this Cookie</Box>
                    </Button>
                  </Stack.Item>
                </Stack>
              </Section>
            ) : (
              <Box color="label">Please select an offering.</Box>
            )
          ) : selectedFood ? (
            <Section title="Product Details" fill scrollable>
              <Stack vertical>
                <Stack.Item>
                  <LabeledList>
                    <LabeledList.Item label="Name">
                      {selectedFood.name}
                    </LabeledList.Item>
                    <LabeledList.Divider />
                    <LabeledList.Item label="Description">
                      {selectedFood.desc || 'No description available.'}
                    </LabeledList.Item>
                    <LabeledList.Divider />
                  </LabeledList>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    disabled={busy}
                    align="center"
                    color="transparent"
                    onClick={() => act('make', { make: selectedFood.ref })}
                  >
                    <Box
                      className={classes([
                        'synthesizer128x128',
                        sanitizeCssClassName(selectedFood.type),
                      ])}
                    />
                    <Box>Print this meal</Box>
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          ) : (
            <Box color="label">Please select an offering.</Box>
          )}
        </Stack.Item>
      </Stack>
    </Section>
  );
};
