import type { ComponentProps } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  type Floating,
  NumberInput,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { round, toFixed } from 'tgui-core/math';

export const VorePanelEditNumber = (props: {
  /** Switch between Element editing and display */
  editMode: boolean;
  /** Our backend action on text area blur */
  action: string;
  /** Our secondary backend action on text area blur */
  subAction?: string;
  /** The current displayed number */
  value: number;
  /** The minimum number allowed */
  minValue: number;
  /** The maximum number allowed */
  maxValue: number;
  /** The steps of the input */
  step?: number;
  /** The pixels required for each step */
  stepPixel?: number;
  /** The unit shown behind the number */
  unit?: string;
  /** The color of the displayed text */
  color?: string;
  /** Our displayed tooltip behind the input element */
  tooltip?: string;
  /** The position of the tooltip if static */
  tooltipPosition?: ComponentProps<typeof Floating>['placement'];
  /** The amount of fractional digits shown */
  digits?: number;
}) => {
  const { act } = useBackend();

  const {
    action,
    subAction = '',
    value,
    maxValue,
    minValue,
    step = 1,
    stepPixel = 1,
    editMode,
    unit,
    color,
    tooltip,
    tooltipPosition,
    digits = 0,
  } = props;

  return editMode ? (
    <Stack>
      <Stack.Item>
        <NumberInput
          onChange={(value) =>
            act(action, {
              attribute: subAction,
              val: round(value, digits),
            })
          }
          stepPixelSize={stepPixel}
          value={value}
          maxValue={maxValue}
          minValue={minValue}
          step={step}
          unit={unit}
          format={(val) => toFixed(val, digits)}
        />
      </Stack.Item>
      {tooltip && (
        <Stack.Item>
          <Tooltip content={tooltip} position={tooltipPosition}>
            <Box className="VorePanel__floatingButton">?</Box>
          </Tooltip>
        </Stack.Item>
      )}
    </Stack>
  ) : (
    <Box textColor={color}>
      {value}
      {!!unit && ' ' + unit}
    </Box>
  );
};
