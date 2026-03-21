import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Section, Stack } from 'tgui-core/components';
import type { Data } from './types';
import { WhitelistAddEnttry } from './WhitelistAddEnttry';
import { WhitelistRemoveEntry } from './WhitelistRemoveEntry';

export const WhitelistEdit = () => {
  const { data, act } = useBackend<Data>();
  const {
    alienwhitelist,
    languagewhitelist,
    robotwhitelist,
    jobwhitelist,
    species_with_whitelist,
    language_with_whitelist,
    robot_with_whitelist,
    jobs_with_whitelist,
  } = data;

  const possibleAdds = {
    species: species_with_whitelist,
    language: language_with_whitelist,
    robot: robot_with_whitelist,
    job: jobs_with_whitelist,
  };

  const possibleRemovals = {
    species: alienwhitelist,
    language: languagewhitelist,
    robot: robotwhitelist,
    job: jobwhitelist,
  };

  return (
    <Window width={530} height={495} theme="admin">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Stack>
              <Stack.Item grow />
              <Stack.Item>
                <Button
                  onClick={() => act('reload_alienwhitelist')}
                  tooltip="Reloads the alien whitelist (Species, Languages, Robots)"
                >
                  Reload Alien Whitelist
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  onClick={() => act('reload_jobwhitelist')}
                  tooltip="Reloads the jon whitelist"
                >
                  Reload Job Whitelist
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item>
                <Section fill title="Add">
                  <Stack vertical fill>
                    {Object.entries(possibleAdds).map(([type, value]) => (
                      <Stack.Item key={type}>
                        <WhitelistAddEnttry type={type} entries={value} />
                      </Stack.Item>
                    ))}
                  </Stack>
                </Section>
              </Stack.Item>
              <Stack.Item>
                <Section fill title="Remove">
                  <Stack vertical fill>
                    {Object.entries(possibleRemovals).map(([type, value]) => (
                      <Stack.Item key={type}>
                        <WhitelistRemoveEntry type={type} entries={value} />
                      </Stack.Item>
                    ))}
                  </Stack>
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
