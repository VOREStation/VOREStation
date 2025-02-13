import { resolveAsset } from 'tgui/assets';
import { useBackend } from 'tgui/backend';
import { Box, Button, Image } from 'tgui-core/components';

import type { Data } from './types';

export const ResleevingConsolePodSleevers = (props) => {
  const { act, data } = useBackend<Data>();
  const { sleevers, spods, selected_sleever } = data;

  if (sleevers && sleevers.length) {
    return sleevers.map((pod, i) => {
      return (
        <Box key={i} width="64px" textAlign="center" inline mr="0.5rem">
          <Image
            src={resolveAsset(
              'sleeve_' + (pod.occupied ? 'occupied' : 'empty') + '.gif',
            )}
            style={{
              width: '100%',
            }}
          />
          <Box color={pod.occupied ? 'label' : 'bad'}>{pod.name}</Box>
          <Button
            selected={selected_sleever === pod.sleever}
            icon={selected_sleever === pod.sleever && 'check'}
            mt={spods && spods.length ? '3rem' : '1.5rem'}
            onClick={() =>
              act('selectsleever', {
                ref: pod.sleever,
              })
            }
          >
            Select
          </Button>
        </Box>
      );
    });
  }

  return '';
};
