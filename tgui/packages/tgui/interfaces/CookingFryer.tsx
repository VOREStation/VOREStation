import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  DmIcon,
  ProgressBar,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';

import { CookingApplianceStatus, type Data } from './CookingAppliance';

export const CookingFryer = (props) => {
  const { act, data } = useBackend<Data>();

  const { containersRemovable, our_contents } = data;

  return (
    <Window width={600} height={600}>
      <Window.Content scrollable>
        <CookingApplianceStatus />
        <Section title="Containers">
          <Stack align="center" justify="center">
            <Stack.Item position="relative">
              <Stack
                position="absolute"
                top={10}
                align="center"
                justify="space-around"
                left={1.7}
                width="92%"
              >
                {our_contents.map((content, i) => {
                  if (content.empty) {
                    return (
                      <Stack.Item key={i} position="relative">
                        <Stack
                          position="absolute"
                          top={-6}
                          left={-1}
                          height={4}
                          align="center"
                          justify="center"
                        >
                          <Stack.Item>
                            <ProgressBar
                              value={0}
                              maxValue={1}
                              backgroundColor="black"
                              width={8}
                            >
                              N/A
                            </ProgressBar>
                          </Stack.Item>
                        </Stack>
                        <Stack align="center" justify="center" fill vertical>
                          <Stack.Item
                            backgroundColor="black"
                            width={6}
                            height={8}
                            style={{
                              border: '2px solid #48739e',
                              cursor: 'pointer',
                            }}
                            onClick={() => act('slot', { slot: i + 1 })}
                          />
                          <Stack.Item
                            backgroundColor="black"
                            style={{ borderRadius: '4px' }}
                            p={1}
                          >
                            Slot #{i + 1}
                          </Stack.Item>
                        </Stack>
                      </Stack.Item>
                    );
                  }

                  return (
                    <Stack.Item key={i} position="relative">
                      <Stack
                        position="absolute"
                        top={-6}
                        left={-1}
                        height={4}
                        align="center"
                        justify="center"
                      >
                        <Stack.Item>
                          <ProgressBar
                            color={content.progressText[0]}
                            value={content.progress}
                            maxValue={1}
                            backgroundColor="black"
                            width={8}
                          >
                            {content.progressText[1]}
                          </ProgressBar>
                        </Stack.Item>
                      </Stack>
                      <Stack align="center" justify="center" fill vertical>
                        <Stack.Item
                          width={6}
                          height={8}
                          style={{ cursor: 'pointer' }}
                          onClick={() => act('slot', { slot: i + 1 })}
                        >
                          <Stack align="center" justify="center">
                            <Stack.Item>
                              {content.empty ? (
                                'Empty'
                              ) : (
                                <DmIcon
                                  mt={-16}
                                  icon="icons/obj/cooking_machines.dmi"
                                  icon_state="basket"
                                  width="256px"
                                  height="256px"
                                />
                              )}
                            </Stack.Item>
                          </Stack>
                        </Stack.Item>
                        <Tooltip
                          content={
                            content.prediction
                              ? `Predicted Output: ${content.prediction}`
                              : undefined
                          }
                        >
                          <Stack.Item
                            mt={2}
                            ml={-1}
                            backgroundColor="black"
                            style={{
                              borderRadius: '4px',
                              textDecoration: content.prediction
                                ? 'underline'
                                : undefined,
                            }}
                            p={1}
                          >
                            Slot #{i + 1}
                          </Stack.Item>
                        </Tooltip>
                      </Stack>
                    </Stack.Item>
                  );
                })}
              </Stack>
              <DmIcon
                icon="icons/obj/cooking_machines.dmi"
                icon_state="fryer_off"
                width={32}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
