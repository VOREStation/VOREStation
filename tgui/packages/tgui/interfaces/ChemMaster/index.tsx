import { useBackend } from '../../backend';
import { Window } from '../../layouts';
import {
  ComplexModal,
  modalRegisterBodyOverride,
} from '.././common/ComplexModal';
import { analyzeModalBodyOverride } from './ChemMasterAnalyzeModalBodyOverride';
import { ChemMasterBeaker } from './ChemMasterBeaker';
import { ChemMasterBuffer } from './ChemMasterBuffer';
import { ChemMasterProduction } from './ChemMasterProduction';
import { Data } from './types';

export const ChemMaster = (props) => {
  const { data } = useBackend<Data>();
  const {
    condi,
    beaker,
    beaker_reagents = [],
    buffer_reagents = [],
    mode,
    loaded_pill_bottle,
    loaded_pill_bottle_name,
    loaded_pill_bottle_contents_len,
    loaded_pill_bottle_storage_slots,
    pillsprite,
    bottlesprite,
  } = data;
  return (
    <Window width={575} height={500}>
      <ComplexModal />
      <Window.Content scrollable className="Layout__content--flexColumn">
        <ChemMasterBeaker
          beaker={beaker}
          beakerReagents={beaker_reagents}
          bufferNonEmpty={buffer_reagents.length > 0}
        />
        <ChemMasterBuffer mode={mode} bufferReagents={buffer_reagents} />
        <ChemMasterProduction
          isCondiment={condi}
          bufferNonEmpty={buffer_reagents.length > 0}
          loaded_pill_bottle={loaded_pill_bottle}
          loaded_pill_bottle_name={loaded_pill_bottle_name || ''}
          loaded_pill_bottle_contents_len={loaded_pill_bottle_contents_len || 0}
          loaded_pill_bottle_storage_slots={
            loaded_pill_bottle_storage_slots || 0
          }
          pillsprite={pillsprite}
          bottlesprite={bottlesprite}
        />
        {/* Vorestation Remove
        <ChemMasterCustomization
          loaded_pill_bottle={loaded_pill_bottle}
          loaded_pill_bottle_name={loaded_pill_bottle_name || ''}
          loaded_pill_bottle_contents_len={loaded_pill_bottle_contents_len || 0}
          loaded_pill_bottle_storage_slots={
            loaded_pill_bottle_storage_slots || 0
          }
        />
        */}
      </Window.Content>
    </Window>
  );
};

modalRegisterBodyOverride('analyze', analyzeModalBodyOverride);
