import { useBackend } from 'tgui/backend';
import {
  Box,
  ImageButton,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';

import type { Data, Module as ModuleData } from './types';

export const Modules = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Stack fill vertical>
      <Stack.Item grow>
        <Section
          title="Modules"
          fill
          scrollable
          height="93%"
          buttons={
            data.weapon_lock ? (
              <NoticeBox danger>Modules Locked</NoticeBox>
            ) : null
          }
        >
          <Stack wrap align="space-between" justify="space-between">
            {data.modules_static.map((mod) => (
              <Stack.Item key={mod.ref} basis="32%" grow mt={1} ml={1}>
                <Module mod={mod} activated={data.modules[mod.ref]} />
              </Stack.Item>
            ))}
            {data.emag_modules_static.map((mod) => (
              <Stack.Item key={mod.ref} basis="32%" grow mt={1} ml={1}>
                <Module mod={mod} activated={data.emag_modules[mod.ref]} />
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const Module = (props: { mod: ModuleData; activated: number }) => {
  const { act } = useBackend();
  const { mod, activated } = props;
  return (
    <ImageButton
      dmIcon={mod.icon}
      dmIconState={mod.icon_state}
      selected={activated}
      imageSize={128}
      fluid
      onClick={() => act('toggle_module', { ref: mod.ref })}
      onRightClick={() => act('activate_module', { ref: mod.ref })}
      tooltip={activated ? 'Right click to trigger' : ''}
      tooltipPosition="bottom-end"
      position="relative"
    >
      {!!activated && (
        <Box position="absolute" top={0.5} right={0.5} fontSize={1.5}>
          {activated}
        </Box>
      )}
      <Box>{mod.name}</Box>
    </ImageButton>
  );
};
