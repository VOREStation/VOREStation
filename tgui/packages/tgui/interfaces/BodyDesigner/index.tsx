import { useBackend } from '../../backend';
import { Box, Button } from '../../components';
import { Window } from '../../layouts';
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
    <Window width={400} height={650}>
      <Window.Content>
        {disk ? (
          <Box>
            <Button
              icon="save"
              onClick={() => act('savetodisk')}
              disabled={!activeBodyRecord}
            >
              Save To Disk
            </Button>
            <Button
              icon="save"
              onClick={() => act('loadfromdisk')}
              disabled={!diskStored}
            >
              Load From Disk
            </Button>
            <Button icon="eject" onClick={() => act('ejectdisk')}>
              Eject
            </Button>
          </Box>
        ) : (
          ''
        )}
        {body}
      </Window.Content>
    </Window>
  );
};
