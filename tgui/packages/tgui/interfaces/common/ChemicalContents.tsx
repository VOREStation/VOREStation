import { Box, Stack } from 'tgui-core/components';

export const formatUnits = (a) => `${a} unit${a === 1 ? '' : 's'}`;

/**
 * Displays a beaker's contents
 * @property {object} props
 */
export const BeakerContents = (props) => {
  const { beakerLoaded, beakerContents = [], buttons } = props;
  return (
    <Box>
      {(!beakerLoaded && <Box color="label">No beaker loaded.</Box>) ||
        (beakerContents.length === 0 && (
          <Box color="label">The beaker is empty.</Box>
        ))}
      {beakerContents.map((chemical, i) => (
        <Box key={i} width="100%">
          <Stack align="center" justify="space-between">
            <Stack.Item color="label">
              {formatUnits(chemical.volume)} of {chemical.name}
            </Stack.Item>
            {!!buttons && <Stack.Item>{buttons(chemical, i)}</Stack.Item>}
          </Stack>
        </Box>
      ))}
    </Box>
  );
};
/** Like above, but for buffer contents */
export const BufferContents = (props) => {
  const { bufferContents = [], buttons } = props;
  return (
    <Box>
      {(bufferContents.length === 0 && (
          <Box color="label">The buffer is empty.</Box>
        ))}
      {bufferContents.map((chemical, i) => (
        <Box key={i} width="100%">
          <Stack align="center" justify="space-between">
            <Stack.Item color="label">
              {formatUnits(chemical.volume)} of {chemical.name}
            </Stack.Item>
            {!!buttons && <Stack.Item>{buttons(chemical, i)}</Stack.Item>}
          </Stack>
        </Box>
      ))}
    </Box>
  );
};
