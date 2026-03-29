import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Button,
  Dropdown,
  Icon,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  bought: { id: string; name: string; on: BooleanLike }[];
  not_bought: { id: string; name: string; ram: number }[];
  available_ram: number;
  emotions: DropdownEntry[];
  current_emotion: number;
};

type DropdownEntry = {
  displayText: string;
  value: string;
};

export const pAIInterface = (props) => {
  const { act, data } = useBackend<Data>();

  const { bought, not_bought, available_ram, emotions, current_emotion } = data;

  return (
    <Window width={450} height={600}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section title="Emotion">
              <LabeledList>
                <LabeledList.Item label="Selected">
                  <Dropdown
                    onSelected={(value) => act('image', { image: value })}
                    options={emotions}
                    selected={emotions[current_emotion - 1].displayText}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section
              fill
              title="Software"
              buttons={
                <Stack align="baseline">
                  <Stack.Item color="label">Available RAM:</Stack.Item>
                  <Stack.Item>
                    <ProgressBar
                      width="150px"
                      value={available_ram}
                      minValue={0}
                      maxValue={100}
                      ranges={{
                        good: [60, Infinity],
                        average: [20, 60],
                        bad: [-Infinity, 20],
                      }}
                    >
                      {available_ram}
                    </ProgressBar>
                  </Stack.Item>
                </Stack>
              }
              scrollable
            >
              <Stack fill>
                <Stack.Item basis="50%">
                  <Stack vertical g={0.5}>
                    <Stack.Item textAlign="center">Downloadable</Stack.Item>
                    <Stack.Divider />
                    {not_bought.map((app) => (
                      <Stack.Item key={app.id}>
                        <Button
                          fluid
                          disabled={app.ram > available_ram}
                          color={app.ram <= available_ram ? 'green' : 'red'}
                          onClick={() => act('purchase', { purchase: app.id })}
                        >
                          <Stack>
                            <Stack.Item
                              grow
                            >{`${app.name} (${app.ram})`}</Stack.Item>
                            <Stack.Item>
                              <Icon name="arrow-right-from-bracket" />
                            </Stack.Item>
                          </Stack>
                        </Button>
                      </Stack.Item>
                    ))}
                  </Stack>
                </Stack.Item>
                <Stack.Divider />
                <Stack.Item basis="50%">
                  <Stack vertical g={0.5}>
                    <Stack.Item textAlign="center">Installed</Stack.Item>
                    <Stack.Divider />
                    {bought.map((app) => (
                      <Stack.Item key={app.id}>
                        <Button
                          fluid
                          selected={app.on}
                          onClick={() => act('software', { software: app.id })}
                        >
                          <Stack>
                            <Stack.Item grow>{app.name}</Stack.Item>
                            <Stack.Item>
                              <Icon name="arrow-up-right-from-square" />
                            </Stack.Item>
                          </Stack>
                        </Button>
                      </Stack.Item>
                    ))}
                  </Stack>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
