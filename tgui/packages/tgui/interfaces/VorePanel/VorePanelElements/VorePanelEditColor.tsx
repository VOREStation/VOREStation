import { useBackend } from 'tgui/backend';
import { Box, Button, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { VorePanelColorBox } from './VorePanelCommonElements';
import { VorePanelEditNumber } from './VorePanelEditNumber';

export const VorePanelEditColor = (props: {
  editMode: boolean;
  action: string;
  subAction: string;
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
    action,
    subAction,
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
              action={action}
              subAction={subAction}
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
                act(action, { attribute: subAction, val: value_of });
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
