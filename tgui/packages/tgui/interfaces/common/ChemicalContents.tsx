import type { Reagent } from 'tgui/interfaces/ChemDispenser/types';
import { Box, Stack } from 'tgui-core/components';

export function formatUnits(a: number) {
  return `${a} unit${a === 1 ? '' : 's'}`;
}

/**
 * Displays a beaker's contents
 */
export const BeakerContents = (props: {
  beakerLoaded: boolean;
  beakerContents: Reagent[];
  buttons?: (chemical: Reagent, i: number) => React.JSX.Element;
}) => {
  const { beakerLoaded, beakerContents = [], buttons } = props;
  return (
    <Box>
      {(!beakerLoaded && <Box color="label">No beaker loaded.</Box>) ||
        (beakerContents.length === 0 && (
          <Box color="label">The beaker is empty.</Box>
        ))}
      {beakerContents.map((chemical, i) => (
        <ChemEntry
          key={chemical.name}
          chemical={chemical}
          buttons={buttons}
          index={i}
        />
      ))}
    </Box>
  );
};

export const BufferContents = (props: {
  bufferContents: Reagent[];
  buttons?: (chemical: Reagent, i: number) => React.JSX.Element;
}) => {
  const { bufferContents = [], buttons } = props;
  return (
    <Box>
      {bufferContents.length === 0 && (
        <Box color="label">The buffer is empty.</Box>
      )}
      {bufferContents.map((chemical, i) => (
        <ChemEntry
          key={chemical.name}
          chemical={chemical}
          buttons={buttons}
          index={i}
        />
      ))}
    </Box>
  );
};

const ChemEntry = (props: {
  chemical: Reagent;
  buttons?: (chemical: Reagent, i: number) => React.JSX.Element;
  index: number;
}) => {
  const { chemical, buttons, index } = props;
  return (
    <Box width="100%">
      <Stack align="center" justify="space-between">
        <Stack.Item color="label">
          {formatUnits(chemical.volume)} of {chemical.name}
        </Stack.Item>
        {!!buttons && <Stack.Item>{buttons(chemical, index)}</Stack.Item>}
      </Stack>
    </Box>
  );
};
