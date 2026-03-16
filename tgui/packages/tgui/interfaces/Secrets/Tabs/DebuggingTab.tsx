import { useBackend } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';

import { lineHeightDebug } from '../constants';

export const DebuggingTab = (props) => {
  const { act } = useBackend();
  return (
    <Stack fill vertical>
      <Stack.Item>
        <Button
          color="average"
          lineHeight={lineHeightDebug}
          icon="question"
          fluid
          onClick={() => act('maint_access_engiebrig')}
        >
          Change all maintenance doors to engie/brig access only
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          color="average"
          lineHeight={lineHeightDebug}
          icon="question"
          fluid
          onClick={() => act('maint_access_brig')}
        >
          Change all maintenance doors to brig access only
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          color="average"
          lineHeight={lineHeightDebug}
          icon="question"
          fluid
          onClick={() => act('infinite_sec')}
        >
          Remove cap on security officers
        </Button>
      </Stack.Item>
    </Stack>
  );
};
