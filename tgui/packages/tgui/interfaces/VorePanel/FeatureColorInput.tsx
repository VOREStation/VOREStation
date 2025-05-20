import { useBackend } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { VorePanelColorBox } from './VorePanelElements/VorePanelCommonElements';

export const FeatureColorInput = (props: {
  action_name: string;
  value_of: BooleanLike | string;
  back_color: string;
  name_of: string;
}) => {
  const { act } = useBackend();
  const { action_name, value_of, back_color, name_of } = props;
  return (
    <>
      <Stack.Item shrink>
        <VorePanelColorBox back_color={back_color} />
      </Stack.Item>
      <Stack.Item grow>
        <Button
          fluid
          icon="eye-dropper"
          onClick={() => {
            act('set_attribute', { attribute: action_name, val: value_of });
          }}
        >
          Change {name_of}
        </Button>
      </Stack.Item>
    </>
  );
};
