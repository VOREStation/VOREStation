import { Box, Stack } from 'tgui-core/components';

export const formatUnits = (a) => `${a} unit${a === 1 ? '' : 's'}`;

/**
 * Displays a buffer's contents
 * @property {object} props
 */
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
