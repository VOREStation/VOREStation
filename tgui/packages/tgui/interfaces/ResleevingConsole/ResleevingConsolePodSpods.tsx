import { resolveAsset } from 'tgui/assets';
import { useBackend } from 'tgui/backend';
import { Box, Button, Icon, Image, ProgressBar } from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';

import { Data } from './types';

export const ResleevingConsolePodSpods = (props) => {
  const { act, data } = useBackend<Data>();
  const { spods, selected_printer } = data;

  if (spods && spods.length) {
    return spods.map((pod, i) => {
      let podAction: React.JSX.Element;
      if (pod.status === 'cloning') {
        podAction = (
          <ProgressBar
            minValue={0}
            maxValue={1}
            value={pod.progress / 100}
            ranges={{
              good: [0.75, Infinity],
              average: [0.25, 0.75],
              bad: [-Infinity, 0.25],
            }}
            mt="0.5rem"
          >
            <Box textAlign="center">{toFixed(pod.progress) + '%'}</Box>
          </ProgressBar>
        );
      } else if (pod.status === 'mess') {
        podAction = (
          <Box bold color="bad" mt="0.5rem">
            ERROR
          </Box>
        );
      } else {
        podAction = (
          <Button
            selected={selected_printer === pod.spod}
            icon={selected_printer === pod.spod && 'check'}
            mt="0.5rem"
            onClick={() =>
              act('selectprinter', {
                ref: pod.spod,
              })
            }
          >
            Select
          </Button>
        );
      }

      return (
        <Box key={i} width="64px" textAlign="center" inline mr="0.5rem">
          <Image
            src={resolveAsset(
              'synthprinter' + (pod.busy ? '_working' : '') + '.gif',
            )}
            style={{
              width: '100%',
            }}
          />
          <Box color="label">{pod.name}</Box>
          <Box bold color={pod.steel >= 15000 ? 'good' : 'bad'} inline>
            <Icon name={pod.steel >= 15000 ? 'circle' : 'circle-o'} />
            &nbsp;
            {pod.steel}
          </Box>
          <Box bold color={pod.glass >= 15000 ? 'good' : 'bad'} inline>
            <Icon name={pod.glass >= 15000 ? 'circle' : 'circle-o'} />
            &nbsp;
            {pod.glass}
          </Box>
          {podAction}
        </Box>
      );
    });
  }

  return '';
};
