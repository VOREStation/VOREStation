import { useBackend } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { VorePanelColorBox } from './VorePanelCommonElements';

export const FeatureColorInput = (props: {
  editMode: boolean;
  action_name: string;
  value_of: BooleanLike | string;
  back_color: string;
  name_of?: string;
  tooltip?: string;
}) => {
  const { act } = useBackend();
  const { editMode, action_name, value_of, back_color, name_of, tooltip } =
    props;

  const shownName = name_of ? 'Change' + name_of : undefined;

  return (
    <>
      <Stack.Item shrink>
        <VorePanelColorBox back_color={back_color} />
      </Stack.Item>
      {editMode && (
        <Stack.Item grow>
          <Button
            fluid
            icon="eye-dropper"
            onClick={() => {
              act('set_attribute', { attribute: action_name, val: value_of });
            }}
            tooltip="tooltip"
          >
            {shownName}
          </Button>
        </Stack.Item>
      )}
    </>
  );
};
