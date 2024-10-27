import { toFixed } from 'common/math';
import { resolveAsset } from 'tgui/assets';
import { useBackend } from 'tgui/backend';
import { Box, Button, Icon, Image, ProgressBar } from 'tgui-core/components';

import { Data } from './types';

export const ResleevingConsolePodGrowers = (props) => {
  const { act, data } = useBackend<Data>();
  const { pods, spods, selected_pod } = data;

  if (pods && pods.length) {
    return pods.map((pod, i) => {
      let podAction;
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
            selected={selected_pod === pod.pod}
            icon={selected_pod === pod.pod && 'check'}
            mt={spods && spods.length ? '2rem' : '0.5rem'}
            onClick={() =>
              act('selectpod', {
                ref: pod.pod,
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
            src={resolveAsset('pod_' + pod.status + '.gif')}
            style={{
              width: '100%',
            }}
          />
          <Box color="label">{pod.name}</Box>
          <Box bold color={pod.biomass >= 150 ? 'good' : 'bad'} inline>
            <Icon name={pod.biomass >= 150 ? 'circle' : 'circle-o'} />
            &nbsp;
            {pod.biomass}
          </Box>
          {podAction}
        </Box>
      );
    });
  }

  return '';
};
