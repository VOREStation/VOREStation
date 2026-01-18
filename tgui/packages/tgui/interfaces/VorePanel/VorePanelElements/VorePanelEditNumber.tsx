import type { ComponentProps, ReactNode } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, type Floating, NumberInput, Stack } from 'tgui-core/components';
import { round, toFixed } from 'tgui-core/math';
import { VorePanelTooltip } from './VorePanelTooltip';

export const VorePanelEditNumber = (
  props: {
    /** Switch between Element editing and display */
    editMode: boolean;
    /** Our backend action on number change */
    action: string;
    /** The current displayed number */
    value: number;
    /** The minimum number allowed */
    minValue: number;
    /** The maximum number allowed */
    maxValue: number;
  } & Partial<{
    /** Our secondary backend action on number change */
    subAction: string;
    /** The steps of the input */
    step: number;
    /** The pixels required for each step */
    stepPixel: number;
    /** The unit shown behind the number */
    unit: string;
    /** The color of the displayed text */
    color: string;
    /** Our displayed tooltip behind the input element */
    tooltip: ReactNode;
    /** The position of the tooltip if static */
    tooltipPosition: ComponentProps<typeof Floating>['placement'];
    /** The amount of fractional digits shown */
    digits: number;
  }>,
) => {
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
          <VorePanelTooltip
            tooltip={tooltip}
            tooltipPosition={tooltipPosition}
            displayText="?"
          />
        </Stack.Item>
      )}
    </Stack>
  ) : (
    <Box textColor={color}>
      {value}
      {!!unit && ` ${unit}`}
    </Box>
  );
};
