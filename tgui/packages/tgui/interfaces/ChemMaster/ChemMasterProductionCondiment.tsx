import { useBackend } from 'tgui/backend';
import { Button } from 'tgui-core/components';

import { modalOpen } from '../common/ComplexModal';

export const ChemMasterProductionCondiment = (props) => {
  const { act } = useBackend();
  return (
    <>
      <Button
        icon="box"
        mb="0.5rem"
        onClick={() => modalOpen('create_condi_pack')}
      >
        Create condiment pack (10u max)
      </Button>
      <br />
      <Button
        icon="wine-bottle"
        mb="0"
        onClick={() => act('create_condi_bottle')}
      >
        Create bottle (60u max)
      </Button>
    </>
  );
};
