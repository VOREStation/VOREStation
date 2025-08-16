import { Box } from 'tgui-core/components';

export const WikiLogo = (props) => {
  return (
    <Box
      textAlign="center"
      fontSize="128px"
      italic
      style={{
        textShadow: '1px 1px 20px #fc4103',
      }}
    >
      <Box textColor="green" inline>
        B
      </Box>
      <Box textColor="red" inline>
        i
      </Box>
      <Box textColor="blue" inline>
        n
      </Box>
      <Box textColor="orange" inline>
        g
      </Box>
      <Box textColor="yellow" inline>
        l
      </Box>
      <Box textColor="teal" inline>
        e
      </Box>
    </Box>
  );
};
