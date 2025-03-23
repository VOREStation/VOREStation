import { useEffect, useState } from 'react';
import {
  Box,
  Divider,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';

export const WikiLoadingPage = (props: { endTime: number }) => {
  const { endTime } = props;

  const [ourProgress, setOurProgress] = useState(0);
  const [updateProgress, setUpdateProgress] = useState(false);

  useEffect(() => {
    if (ourProgress < endTime - 100) {
      setTimeout(() => {
        setOurProgress(ourProgress + 100);
        setUpdateProgress(!updateProgress);
      }, 100);
    } else {
      setOurProgress(endTime);
    }
  }, [updateProgress]);

  return (
    <Section fillPositionedParent>
      <Stack vertical fill>
        <Stack.Item>
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
        </Stack.Item>
        <Divider />
        <Stack.Item>
          <ProgressBar value={ourProgress} maxValue={endTime} />
        </Stack.Item>
        <Divider />
        <Stack.Item>
          <Box textAlign="center" fontSize="64px">
            Have you bingled that?
          </Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
