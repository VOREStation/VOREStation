import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Button,
  Divider,
  Image,
  Input,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import { NoSpriteWarning } from '../../components';
import { getModuleIcon, prepareSearch } from '../../functions';
import type { Target } from '../../types';

export const ModifyRobotMultiBelt = (props: { target: Target }) => {
  const { act } = useBackend();
  const { target } = props;
  const { multibelt = [] } = target;
  const [SearchMultibelt, setSearchMultibelt] = useState<string>('');
  const [searchInstalledtext, setSearchInstalledtext] = useState<string>('');
  const [selectedMultibelt, setSelectedMultibelt] = useState<number>(0);

  const currentMultibelt = multibelt[selectedMultibelt];

  useEffect(() => {
    if (currentMultibelt) {
      act('select_multibelt', {
        multibelt: currentMultibelt.ref,
      });
    }
  }, []);

  return (
    <>
      {!target.active && <NoSpriteWarning name={target.name} />}
      {!target.multibelt?.length ? (
        <NoticeBox danger>{target.name} has no Multibelt installed.</NoticeBox>
      ) : (
        <Stack vertical fill>
          <Stack.Item>
            <Tabs>
              {target.multibelt.map((_, i) => (
                <Tabs.Tab
                  key={i}
                  selected={selectedMultibelt === i}
                  onClick={() => {
                    setSelectedMultibelt(i);
                    act('select_multibelt', {
                      multibelt: multibelt[i].ref,
                    });
                  }}
                >
                  {i + 1}: {multibelt[i].name}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable>
              <Stack>
                <Stack.Item width="35%">
                  <Divider />
                  <Input
                    fluid
                    value={SearchMultibelt}
                    placeholder="Search for tools..."
                    onChange={(value: string) => setSearchMultibelt(value)}
                  />
                  <Divider />
                  {prepareSearch(
                    target.multibelt[selectedMultibelt].tools,
                    SearchMultibelt,
                  ).map((tool, i) => {
                    return (
                      <Button
                        fluid
                        key={i}
                        color="green"
                        onClick={() =>
                          act('install_tool', {
                            tool: tool.path,
                          })
                        }
                      >
                        {capitalize(tool.name)}
                      </Button>
                    );
                  })}
                </Stack.Item>
                <Stack.Item grow />
                <Stack.Item>
                  <Image
                    fixErrors
                    src={getModuleIcon(
                      target.modules,
                      target.multibelt[selectedMultibelt].name,
                    )}
                    width="150px"
                  />
                </Stack.Item>
                <Stack.Item grow />
                <Stack.Item width="35%">
                  <Input
                    fluid
                    value={searchInstalledtext}
                    placeholder="Search for tools..."
                    onChange={(value: string) => setSearchInstalledtext(value)}
                  />
                  <Divider />
                  {prepareSearch(
                    target.multibelt[selectedMultibelt].integrated_tools,
                    searchInstalledtext,
                  ).map((tool, i) => {
                    return (
                      <Button
                        fluid
                        key={i}
                        color="red"
                        onClick={() =>
                          act('remove_tool', {
                            tool: tool.ref,
                          })
                        }
                      >
                        {capitalize(tool.name)}
                      </Button>
                    );
                  })}
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      )}
    </>
  );
};
