import { useBackend } from 'tgui/backend';
import { Button, Section, Stack } from 'tgui-core/components';

import type { Data } from './types';

export const ShuttleControlSharedShuttleControls = (props) => {
  const { act, data } = useBackend<Data>();

  const { can_launch, can_cancel, can_force } = data;

  return (
    <Section title="Controls">
      <Stack>
        <Stack.Item grow>
          <Button
            onClick={() => act('move')}
            disabled={!can_launch}
            icon="rocket"
            fluid
          >
            Launch Shuttle
          </Button>
        </Stack.Item>
        <Stack.Item grow>
          <Button
            onClick={() => act('cancel')}
            disabled={!can_cancel}
            icon="ban"
            fluid
          >
            Cancel Launch
          </Button>
        </Stack.Item>
        <Stack.Item grow>
          <Button
            onClick={() => act('force')}
            color="bad"
            disabled={!can_force}
            icon="exclamation-triangle"
            fluid
          >
            Force Launch
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
