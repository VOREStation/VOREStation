import { useBackend } from 'tgui/backend';
import { Box, NumberInput, Tooltip } from 'tgui-core/components';

export const VorePanelEditNumber = (props: {
  action: string;
  subAction: string;
  editMode: boolean;
  value: number;
  minValue: number;
  maxValue: number;
  step: number;
  unit?: string;
  color?: string;
  tooltip?: string;
}) => {
  const { act } = useBackend();

  const {
    action,
    subAction,
    value,
    maxValue,
    minValue,
    step,
    editMode,
    unit,
    color,
    tooltip,
  } = props;

  return editMode ? (
    <>
      <NumberInput
        onChange={(value) =>
          act(action, {
            attribute: subAction,
            val: value,
          })
        }
        value={value}
        maxValue={maxValue}
        minValue={minValue}
        step={step}
        unit={unit}
      />
      {tooltip && (
        <Tooltip content={tooltip}>
          <Box className="VorePanel__floatingButton">?</Box>
        </Tooltip>
      )}
    </>
  ) : (
    <Box textColor={color}>{value + ' ' + unit}</Box>
  );
};
