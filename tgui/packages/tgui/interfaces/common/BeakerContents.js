import { Box, Flex } from '../../components';

const formatUnits = a => a + ' unit' + (a === 1 ? '' : 's');

/**
 * Displays a beaker's contents
 * @property {object} props
 */
export const BeakerContents = props => {
  const { beakerLoaded, beakerContents = [], buttons } = props;
  return (
    <Box>
      {!beakerLoaded && (
        <Box color="label">
          No beaker loaded.
        </Box>
      ) || beakerContents.length === 0 && (
        <Box color="label">
          Beaker is empty.
        </Box>
      )}
      {beakerContents.map((chemical, i) => (
        <Box key={chemical.name} width="100%">
          <Flex align="center" justify="space-between">
            <Flex.Item color="label">
              {formatUnits(chemical.volume)} of {chemical.name}
            </Flex.Item>
            {!!buttons && (
              <Flex.Item>
                {buttons(chemical, i)}
              </Flex.Item>
            )}
          </Flex>
        </Box>
      ))}
    </Box>
  );
};