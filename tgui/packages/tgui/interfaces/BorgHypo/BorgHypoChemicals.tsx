import { useBackend } from 'tgui/backend';
import { ChemDispenserChemicals } from '../ChemDispenser/ChemDispenserChemicals';
import { BorgHypoSearch } from './BorgHypoSearch';
import type { Data } from './types';

export const BorgHypoChemicals = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    chemicals = [],
    isDispensingRecipe,
    selectedReagentId,
    isDispensingDrinks,
    recordingRecipe,
  } = data;
  const recording = !!recordingRecipe;
  return (
    <ChemDispenserChemicals
      chemicals={chemicals}
      sectionTitle={isDispensingDrinks ? 'Drinks' : 'Chemicals'}
      dispenseAct={(reagentId) => {
        if (recording || selectedReagentId !== reagentId) {
          act('select_reagent', {
            selectedReagentId: reagentId,
          });
        }
      }}
      buttons={<BorgHypoSearch />}
      chemicalButtonSelect={(reagentId) =>
        !recording && selectedReagentId === reagentId && !isDispensingRecipe
      }
    />
  );
};
