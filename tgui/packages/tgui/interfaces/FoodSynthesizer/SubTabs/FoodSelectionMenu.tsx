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
  const { active_menu, recipes, activefood, crew_cookies, activecrew } = data;
  crew_cookies;
  if (!recipes) {
    return <Box color="bad">Recipes records missing!</Box>;
  }

  const recipesToShow = recipes
    .filter((recipe) => recipe.category === active_menu)
    .filter((recipe) => !recipe.hidden)
    .sort((a, b) => a.name.localeCompare(b.name));

  const cookiesToShow = crew_cookies
    .filter((cookie) => cookie.category === active_menu)
    .sort((a, b) => a.name.localeCompare(b.name));

  if (active_menu === 'crew') {
    const selectedCrew = crew_cookies.find((c) => c.name === activecrew);

    return (
      <Section fill>
        <Stack>
          <Stack.Item basis="30%">
            <Section title="Food Selection" scrollable fill height="290px">
              <Tabs vertical>
                {cookiesToShow.map((cookie) => (
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
                ))}
              </Tabs>
            </Section>
          </Stack.Item>
          <Stack.Item grow ml={2}>
            {selectedCrew ? (
              <Section title="Product Details" fill height="290px">
                <Box>
                  <Stack align="center" justify="flex-start">
                    <Stack.Item>
                      <LabeledList>
                        <LabeledList.Item label="Name">
                          {selectedCrew.name}
                        </LabeledList.Item>
                        <br />
                        <LabeledList.Item label="Species">
                          {selectedCrew.species}
                        </LabeledList.Item>
                      </LabeledList>
                      <Button
                        onClick={() =>
                          act('crewprint', {
                            crewprint: selectedCrew.name,
                          })
                        }
                      >
                        Print this Cookie
                        <CrewCookieIcon />
                      </Button>
                      <br />
                      <br />
                      <Box>
                        <Button onClick={() => act('refresh')}>
                          Refresh Information
                        </Button>
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
                  <Button onClick={() => act('refresh')}>
                    Refresh Information
                  </Button>
                </Box>
              </Section>
            )}
          </Stack.Item>
        </Stack>
      </Section>
    );
  }

  const selectedFood = recipes.find((c) => c.name === activefood);
  return (
    <Section fill>
      <Stack>
        <Stack.Item basis="30%">
          <Section title="Food Selection" scrollable fill height="290px">
            <Tabs vertical>
              {recipesToShow.map((recipe) => (
                <Tabs.Tab key={recipe.ref}>
                  <Button
                    fluid
                    selected={selectedFood && recipe.ref === selectedFood.ref}
                    onClick={() =>
                      act('setactive_food', { setactive_food: recipe.id })
                    }
                  >
                    {recipe.name}
                  </Button>
                </Tabs.Tab>
              ))}
            </Tabs>
          </Section>
        </Stack.Item>
        <Stack.Item grow={1} ml={4}>
          {selectedFood ? (
            <Section title="Product Details" fill height="290px">
              <Box>
                <Stack align="center" justify="flex-start">
                  <Stack.Item>
                    <LabeledList>
                      <LabeledList.Item label="Name">
                        {selectedFood.name}
                      </LabeledList.Item>
                      <br />
                      <LabeledList.Item label="Description">
                        {selectedFood.desc || 'No description available.'}
                      </LabeledList.Item>
                    </LabeledList>
                    <br />
                    <Button
                      width="128px"
                      height="128px"
                      className={classes([
                        'synthesizer128x128',
                        selectedFood.id,
                      ])}
                      onClick={() => act('make', { make: selectedFood.ref })}
                    >
                      Print this meal
                    </Button>
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
