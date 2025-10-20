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
    uiChemicalsName,
  } = data;
  return (
    <ChemDispenserChemicals
      chemicals={chemicals}
      sectionTitle={uiChemicalsName}
      dispenseAct={(reagentId) => {
        if (selectedReagentId !== reagentId) {
          act('select_reagent', {
            selectedReagentId: reagentId,
          });
        }
      }}
      buttons={<BorgHypoSearch />}
      chemicalButtonSelect={(reagentId) =>
        !isDispensingRecipe && selectedReagentId === reagentId
      }
    />
  );
};
