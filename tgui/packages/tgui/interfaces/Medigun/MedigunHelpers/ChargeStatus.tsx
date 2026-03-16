import { Box, LabeledList, ProgressBar, Stack } from 'tgui-core/components';

export const ChargeStatus = (props: {
  name: string;
  color: string;
  charge: number | null;
  max: number | null;
  volume: number | null;
}) => {
  const { name, color, charge, max, volume } = props;

  return (
    <LabeledList.Item label={name}>
      <Stack>
        <Stack.Item grow>
          {charge !== null ? (
            <ProgressBar color={color} value={charge / (max || 1)}>
              {charge.toFixed()} / {max}
            </ProgressBar>
          ) : (
            <Box color="red">Missing Capacitor</Box>
          )}
        </Stack.Item>
        <Stack.Item>
          <Box color="label">Reserve:</Box>
        </Stack.Item>
        <Stack.Item basis="10%">
          {volume !== null ? (
            <Box color={color} bold>
              {volume.toFixed()}
            </Box>
          ) : (
            <Box color="red">Missing Bin</Box>
          )}
        </Stack.Item>
      </Stack>
    </LabeledList.Item>
  );
};
