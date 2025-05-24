import { useBackend } from 'tgui/backend';
import { Box, NumberInput, Tooltip } from 'tgui-core/components';
import { round, toFixed } from 'tgui-core/math';

export const VorePanelEditNumber = (props: {
  action: string;
  subAction: string;
  editMode: boolean;
  value: number;
  minValue: number;
  maxValue: number;
  step?: number;
  stepPixel?: number;
  unit?: string;
  color?: string;
  tooltip?: string;
  digits?: number;
}) => {
  const { act } = useBackend();

  const {
    action,
    subAction,
    value,
    maxValue,
    minValue,
    step = 1,
    stepPixel = 1,
    editMode,
    unit,
    color,
    tooltip,
    digits = 0,
  } = props;

  return editMode ? (
    <>
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
      {tooltip && (
        <Tooltip content={tooltip}>
          <Box className="VorePanel__floatingButton">?</Box>
        </Tooltip>
      )}
    </>
  ) : (
    <Box textColor={color}>
      {value}
      {!!unit && ' ' + unit}
    </Box>
  );
};
