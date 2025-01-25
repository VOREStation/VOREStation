import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
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
import { Target } from '../types';

export const ModifyRobotPKA = (props: { target: Target }) => {
  const { act } = useBackend();
  const { target } = props;
  const [searchModkitText, setSearchModkitText] = useState<string>('');
  const [searchInstalledtext, setSearchInstalledtext] = useState<string>('');

  return (
    <>
      {!target.active && <NoSpriteWarning name={target.name} />}
      {!target.pka ? (
        <NoticeBox danger>{target.name} has no PKA installed.</NoticeBox>
      ) : (
        <Stack height={!target.active ? '75%' : '80%'}>
          <Stack.Item width="35%">
            <Divider />
            <Box>Remaining Capacity: {target.pka.capacity}</Box>
            <Divider />
            <Input
              fluid
              value={searchModkitText}
              placeholder="Search for modkits..."
              onInput={(e, value: string) => setSearchModkitText(value)}
            />
            <Divider />
            {prepareSearch(target.pka.modkits, searchModkitText).map(
              (modkit, i) => {
                return (
                  <Button
                    fluid
                    key={i}
                    disabled={modkit.denied}
                    color="green"
                    tooltip={
                      modkit.denied_by
                        ? 'Modul incompatible with: ' + modkit.denied_by
                        : ''
                    }
                    onClick={() =>
                      act('install_modkit', {
                        modkit: modkit.path,
                      })
                    }
                  >
                    {capitalize(modkit.name)} {modkit.costs}
                  </Button>
                );
              },
            )}
          </Stack.Item>
          <Stack.Item grow />
          <Stack.Item>
            <Image
              src={getModuleIcon(target.modules, target.pka.name)}
              width="150px"
            />
          </Stack.Item>
          <Stack.Item grow />
          <Stack.Item width="35%">
            <Divider />
            <Box>
              Used Capacity: {target.pka.max_capacity - target.pka.capacity}
            </Box>
            <Divider />
            <Input
              fluid
              value={searchInstalledtext}
              placeholder="Search for modkits..."
              onInput={(e, value: string) => setSearchInstalledtext(value)}
            />
            <Divider />
            {prepareSearch(
              target.pka.installed_modkits,
              searchInstalledtext,
            ).map((modkit, i) => {
              return (
                <Button
                  fluid
                  key={i}
                  color="red"
                  onClick={() =>
                    act('remove_modkit', {
                      modkit: modkit.ref,
                    })
                  }
                >
                  {capitalize(modkit.name)} {modkit.costs}
                </Button>
              );
            })}
          </Stack.Item>
        </Stack>
      )}
    </>
  );
};
