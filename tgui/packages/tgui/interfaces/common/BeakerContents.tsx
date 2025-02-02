import { Box, Stack } from 'tgui-core/components';

const formatUnits = (a) => a + ' unit' + (a === 1 ? '' : 's');

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
          <Box color="label">Beaker is empty.</Box>
        ))}
      {beakerContents.map((chemical, i) => (
        <Box key={chemical.name} width="100%">
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
