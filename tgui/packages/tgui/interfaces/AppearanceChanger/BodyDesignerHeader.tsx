import { useBackend } from 'tgui/backend';
import { Box, Button } from 'tgui-core/components';

import { Data } from './types';

export const BodyDesignerHeader = (props) => {
  const { act, data } = useBackend<Data>();
  const { disk, selected_a_record } = data;
  return (
    <Box>
      <Button
        icon="arrow-left"
        disabled={!selected_a_record}
        onClick={() => act('back_to_library')}
      >
        Back
      </Button>
      <Button
        icon="save"
        onClick={() => act('savetodisk')}
        disabled={!disk || !selected_a_record}
      >
        Save To Disk
      </Button>
      <Button icon="save" onClick={() => act('loadfromdisk')} disabled={!disk}>
        Load From Disk
      </Button>
      <Button icon="eject" onClick={() => act('ejectdisk')} disabled={!disk}>
        Eject
      </Button>
    </Box>
  );
};
