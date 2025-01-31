import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button } from 'tgui-core/components';

import { BodyDesignerBodyRecords } from './BodyDesignerBodyRecords';
import { BodyDesignerMain } from './BodyDesignerMain';
import { BodyDesignerOOCNotes } from './BodyDesignerOOCNotes';
import { BodyDesignerSpecificRecord } from './BodyDesignerSpecificRecord';
import { BodyDesignerStockRecords } from './BodyDesignerStockRecords';
import { Data } from './types';

export const BodyDesigner = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    menu,
    disk,
    diskStored,
    activeBodyRecord,
    stock_bodyrecords,
    bodyrecords,
    mapRef,
  } = data;

  const MenuToTemplate = {
    Main: <BodyDesignerMain />,
    'Body Records': <BodyDesignerBodyRecords bodyrecords={bodyrecords} />,
    'Stock Records': (
      <BodyDesignerStockRecords stock_bodyrecords={stock_bodyrecords} />
    ),
    'Specific Record': (
      <BodyDesignerSpecificRecord
        activeBodyRecord={activeBodyRecord}
        mapRef={mapRef}
      />
    ),
    'OOC Notes': <BodyDesignerOOCNotes activeBodyRecord={activeBodyRecord} />,
  };

  let body = MenuToTemplate[menu];

  return (
    <Window width={750} height={850}>
      <Window.Content>
        <Box>
          <Button
            icon="save"
            onClick={() => act('savetodisk')}
            disabled={!disk || !activeBodyRecord}
          >
            Save To Disk
          </Button>
          <Button
            icon="save"
            onClick={() => act('loadfromdisk')}
            disabled={!disk || !diskStored}
          >
            Load From Disk
          </Button>
          <Button
            icon="eject"
            onClick={() => act('ejectdisk')}
            disabled={!disk}
          >
            Eject
          </Button>
        </Box>
        {body}
      </Window.Content>
    </Window>
  );
};
