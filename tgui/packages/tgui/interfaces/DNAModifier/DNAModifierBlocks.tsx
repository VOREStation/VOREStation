import { useBackend } from '../../backend';
import { Box, Button, Flex } from '../../components';

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
  let dnaBlocks: React.JSX.Element[] = [];
  for (let block = 0; block < characters.length; block += blockSize) {
    const realBlock: number = block / blockSize + 1;
    let subBlocks: React.JSX.Element[] = [];
    for (let subblock = 0; subblock < blockSize; subblock++) {
      const realSubblock: number = subblock + 1;
      subBlocks.push(
        <Button
          selected={
            selectedBlock === realBlock && selectedSubblock === realSubblock
          }
          mb="0"
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
      <Flex.Item flex="0 0 16%" mb="1rem">
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
      </Flex.Item>,
    );
  }
  return <Flex wrap="wrap">{dnaBlocks}</Flex>;
};
