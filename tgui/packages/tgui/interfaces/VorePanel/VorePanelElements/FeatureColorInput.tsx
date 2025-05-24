import { useBackend } from 'tgui/backend';
import { Box, Button, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { VorePanelColorBox } from './VorePanelCommonElements';
import { VorePanelEditNumber } from './VorePanelEditNumber';

export const FeatureColorInput = (props: {
  editMode: boolean;
  action_name: string;
  value_of: BooleanLike | string;
  back_color: string;
  alpha?: number;
  name_of?: string;
  tooltip?: string;
  removePlaceholder?: boolean;
}) => {
  const { act } = useBackend();
  const {
    editMode,
    action_name,
    value_of,
    back_color,
    alpha,
    name_of,
    tooltip,
    removePlaceholder,
  } = props;

  return (
    <>
      {!!name_of && (
        <Stack.Item>
          <Box color="label">{name_of}</Box>
        </Stack.Item>
      )}
      <Stack.Item shrink>
        <VorePanelColorBox back_color={back_color} alpha={alpha} />
      </Stack.Item>
      {editMode && (
        <Stack.Item basis={alpha !== undefined ? '65px' : undefined}>
          {alpha !== undefined ? (
            <VorePanelEditNumber
              action="set_attribute"
              subAction={action_name}
              editMode={editMode}
              value={alpha}
              minValue={0}
              maxValue={255}
              tooltip={tooltip}
            />
          ) : (
            <Button
              fluid
              icon="eye-dropper"
              onClick={() => {
                act('set_attribute', { attribute: action_name, val: value_of });
              }}
              tooltip={tooltip}
            />
          )}
        </Stack.Item>
      )}
      {!removePlaceholder && <Stack.Item grow />}
    </>
  );
};
