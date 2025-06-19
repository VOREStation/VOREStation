import type { ComponentProps } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, type Floating, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { VorePanelColorBox } from './VorePanelCommonElements';
import { VorePanelEditNumber } from './VorePanelEditNumber';

export const VorePanelEditColor = (props: {
  /** Switch between Element editing and display */
  editMode: boolean;
  /** Our backend action on click */
  action: string;
  /** Our secondary backend action on click */
  subAction?: string;
  /** Our color value sent to byond */
  value_of: BooleanLike | string;
  /** The displayed color of the color box */
  back_color: string;
  /** A number representing the alpha value for alpha inputs */
  alpha?: number;
  /** Optional label to show before the color box */
  name_of?: string;
  /** Our displayed tooltip behind the input element */
  tooltip?: string;
  /** The position of the tooltip if static */
  tooltipPosition?: ComponentProps<typeof Floating>['placement'];
  /** Removes the spacing behind the color box */
  removePlaceholder?: boolean;
}) => {
  const { act } = useBackend();
  const {
    editMode,
    action,
    subAction = '',
    value_of,
    back_color,
    alpha,
    name_of,
    tooltip,
    tooltipPosition,
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
              tooltipPosition={tooltipPosition}
            />
          )}
        </Stack.Item>
      )}
      {!removePlaceholder && <Stack.Item grow />}
    </>
  );
};
