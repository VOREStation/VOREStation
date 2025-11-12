import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Input, Section, Stack } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

type Data = {
  theme: string | null;
  all_decals?: string[] | null;
  all_animations?: string[] | null;
  active_decals: string[];
};

export const RobotDecals = () => {
  const { act, data } = useBackend<Data>();
  const { theme, all_decals, all_animations, active_decals } = data;

  const [decalSearchText, setDecalSearchText] = useState('');
  const [animationSearchText, setAnimationSearchText] = useState('');

  const decalSearcher = createSearch(decalSearchText, (decal: string) => decal);
  const filteredDecals = all_decals?.filter(decalSearcher) ?? [];

  const animationSearcher = createSearch(
    animationSearchText,
    (anim: string) => anim,
  );
  const filteredAnimations = all_animations?.filter(animationSearcher) ?? [];

  return (
    <Window width={350} height={400} theme={theme || 'ntos'}>
      <Window.Content>
        <Stack fill>
          <Stack.Item grow>
            <Section fill title="Robot Decals">
              <Stack vertical fill>
                <Stack.Item>
                  <Input
                    fluid
                    placeholder="Search for decals..."
                    value={decalSearchText}
                    onChange={(value: string) => setDecalSearchText(value)}
                  />
                </Stack.Item>
                <Stack.Divider />
                <Stack.Item grow>
                  <Section fill scrollable>
                    <Stack vertical fill>
                      {!filteredDecals.length ? (
                        <Box color="red">No decals found.</Box>
                      ) : (
                        filteredDecals.map((decal) => (
                          <Stack.Item key={decal}>
                            <Button.Checkbox
                              fluid
                              checked={active_decals.includes(decal)}
                              onClick={() =>
                                act('toggle_decal', { value: decal })
                              }
                            >
                              {decal}
                              {active_decals.includes(decal)
                                ? ` (${active_decals.indexOf(decal) + 1})`
                                : ''}
                            </Button.Checkbox>
                          </Stack.Item>
                        ))
                      )}
                    </Stack>
                  </Section>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill title="Robot Animations">
              <Stack vertical fill>
                <Stack.Item>
                  <Input
                    fluid
                    placeholder="Search for animations..."
                    value={animationSearchText}
                    onChange={(value: string) => setAnimationSearchText(value)}
                  />
                </Stack.Item>
                <Stack.Divider />
                <Stack.Item grow>
                  <Section fill scrollable>
                    <Stack vertical fill>
                      {!filteredAnimations.length ? (
                        <Box color="red">No animations found.</Box>
                      ) : (
                        filteredAnimations.map((anim) => (
                          <Stack.Item key={anim}>
                            <Button
                              fluid
                              ellipsis
                              onClick={() =>
                                act('flick_animation', { value: anim })
                              }
                            >
                              {anim}
                            </Button>
                          </Stack.Item>
                        ))
                      )}
                    </Stack>
                  </Section>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
