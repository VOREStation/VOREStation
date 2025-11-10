import { useBackend } from 'tgui/backend';
import { Box, Button } from 'tgui-core/components';

import type { Data } from './types';

export const MenuPageChanger = (props) => {
  const { act, data } = useBackend<Data>();

  const { inv_left, inv_right } = data;

  return (
    <Box>
      <center>
        <Button
          icon="eye"
          disabled={!inv_left}
          onClick={() => act('inv_prev', { inv_prev: 1 })}
        >
          Prev
        </Button>
        <Button
          icon="eye"
          disabled={!inv_right}
          onClick={() => act('inv_nex', { inv_nex: 1 })}
        >
          Next
        </Button>
      </center>
    </Box>
  );
};
