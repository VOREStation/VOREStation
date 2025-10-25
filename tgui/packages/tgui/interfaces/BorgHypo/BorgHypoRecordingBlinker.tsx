import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Icon, Stack } from 'tgui-core/components';
import type { Data } from './types';

export const BorgHypoRecordingBlinker = (props) => {
  const { data } = useBackend<Data>();
  const isRecording = !!data.recordingRecipe;

  const [blink, setBlink] = useState(false);

  useEffect(() => {
    if (isRecording) {
      const intervalId = setInterval(() => {
        setBlink((v) => !v);
      }, 1000);
      return () => clearInterval(intervalId);
    }
  }, [isRecording]);

  if (!isRecording) {
    return null;
  }

  return (
    <>
      <Stack.Item>
        <Icon mt={0.7} color="bad" name={blink ? 'circle-o' : 'circle'} />
      </Stack.Item>
      <Stack.Item>
        <Box color="bad" inline bold>
          REC
        </Box>
      </Stack.Item>
    </>
  );
};
