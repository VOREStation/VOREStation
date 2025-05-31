import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Button,
  Divider,
  Image,
  Input,
  NoticeBox,
  Stack,
} from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import { NoSpriteWarning } from '../components';
import { getModuleIcon, prepareSearch } from '../functions';
import type { Target } from '../types';

export const ModifyRobotMultiBelt = (props: { target: Target }) => {
  const { act } = useBackend();
  const { target } = props;
  const [SearchMultibelt, setSearchMultibelt] = useState<string>('');
  const [searchInstalledtext, setSearchInstalledtext] = useState<string>('');

  return (
    <>
      {!target.active && <NoSpriteWarning name={target.name} />}
      {!target.multibelt ? (
        <NoticeBox danger>No module selected.</NoticeBox>
      ) : (
        <Stack height={!target.active ? '75%' : '80%'}>
          <Stack.Item width="35%">
            <Divider />
            <Divider />
            <Input
              fluid
              value={SearchMultibelt}
              placeholder="Search for tools..."
              onChange={(value: string) => setSearchMultibelt(value)}
            />
            <Divider />
            {prepareSearch(target.multibelt.tools, SearchMultibelt).map(
              (tool, i) => {
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
              },
            )}
          </Stack.Item>
          <Stack.Item grow />
          <Stack.Item>
            <Image
              src={getModuleIcon(target.modules, target.multibelt.name)}
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
              target.multibelt.integrated_tools,
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
      )}
    </>
  );
};
