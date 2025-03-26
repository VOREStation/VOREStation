import { useEffect, useState } from 'react';
import {
  Box,
  Divider,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';

import { WikiLogo } from '../WikiCommon/WikiLogo';

export const WikiLoadingPage = (props: { endTime: number; tipp: string }) => {
  const { endTime, tipp } = props;

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
    <Section fill>
      <Stack vertical fill>
        <Stack.Item>
          <WikiLogo />
        </Stack.Item>
        <Divider />
        <Stack.Item>
          <ProgressBar value={ourProgress} maxValue={endTime} />
        </Stack.Item>
        <Divider />
        <Stack.Item>
          <Box textAlign="center" color="label">
            Did you know?
          </Box>
        </Stack.Item>
        <Stack.Item>
          <Box textAlign="center" color="red">
            {tipp}
          </Box>
        </Stack.Item>
        <Stack.Item grow />
        <Stack.Item>
          <Box textAlign="center" fontSize="64px">
            Have you bingled that?
          </Box>
        </Stack.Item>
        <Stack.Item grow />
      </Stack>
    </Section>
  );
};
