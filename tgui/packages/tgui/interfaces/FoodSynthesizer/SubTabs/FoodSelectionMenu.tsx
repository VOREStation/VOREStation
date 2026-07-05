import { sanitizeCssClassName } from 'common/css_sanity';
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
  const { menucatagories, active_menu, activefood, crew_cookies, activecrew } =
    data;
  crew_cookies;

  const recipesToShow = menucatagories
    .find((category) => category.id === active_menu)
    ?.recipes.filter((recipe) => !recipe.hidden)
    .sort((a, b) => a.name.localeCompare(b.name));

  if (!recipesToShow) {
    return <Box color="bad">No recipes found!</Box>;
  }

  const cookiesToShow = crew_cookies
    .filter((cookie) => cookie.category === active_menu)
    .sort((a, b) => a.name.localeCompare(b.name));

  if (active_menu === 'crew') {
    const selectedCrew = crew_cookies.find((c) => c.name === activecrew);

    return (
      <Section fill>
        <Stack>
          <Stack.Item basis="30%">
            <Section title="Food Selection" scrollable fill>
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
          <Stack.Item grow ml={1}>
            {selectedCrew ? (
              <Section title="Product Details" fill>
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

  const selectedFood = recipesToShow.find((c) => c.type === activefood);
  return (
    <Section fill>
      <Stack fill>
        <Stack.Item basis="30%">
          <Section title="Food Selection" scrollable fill>
            <Tabs vertical>
              {recipesToShow.map((recipe) => (
                <Tabs.Tab key={recipe.ref}>
                  <Button
                    fluid
                    selected={selectedFood && recipe.ref === selectedFood.ref}
                    onClick={() =>
                      act('setactive_food', { setactive_food: recipe.type })
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
          {selectedFood ? (
            <Section title="Product Details" fill>
              <Box>
                <Stack align="center" justify="flex-start">
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
                    <Button
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
