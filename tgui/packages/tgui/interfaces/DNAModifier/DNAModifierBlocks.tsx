import { useBackend } from 'tgui/backend';
import { Box, Button, Stack } from 'tgui-core/components';

export const DNAModifierBlocks = (props: {
  dnaString: string;
  selectedBlock: number;
  selectedSubblock: number;
  blockSize: number;
  action: string;
}) => {
  const { act } = useBackend();

  const { dnaString, selectedBlock, selectedSubblock, blockSize, action } =
    props;

  const characters: string[] = dnaString.split('');
  const dnaBlocks: React.JSX.Element[] = [];
  for (let block = 0; block < characters.length; block += blockSize) {
    const realBlock: number = block / blockSize + 1;
    const subBlocks: React.JSX.Element[] = [];
    for (let subblock = 0; subblock < blockSize; subblock++) {
      const realSubblock: number = subblock + 1;
      subBlocks.push(
        <Button
          selected={
            selectedBlock === realBlock && selectedSubblock === realSubblock
          }
          mb="0"
          width="20px"
          height="20px"
          onClick={() =>
            act(action, {
              block: realBlock,
              subblock: realSubblock,
            })
          }
        >
          {characters[block + subblock]}
        </Button>,
      );
    }
    dnaBlocks.push(
      <Stack.Item
        mb="1rem"
        style={realBlock === 1 ? { marginLeft: '0.5em' } : {}} // Remove once tgui core uses gap
      >
        <Box
          inline
          width="20px"
          height="20px"
          mr="0.5rem"
          lineHeight="20px"
          backgroundColor="rgba(0, 0, 0, 0.33)"
          fontFamily="monospace"
          textAlign="center"
        >
          {realBlock}
        </Box>
        {subBlocks}
      </Stack.Item>,
    );
  }
  return <Stack wrap="wrap">{dnaBlocks}</Stack>;
};
