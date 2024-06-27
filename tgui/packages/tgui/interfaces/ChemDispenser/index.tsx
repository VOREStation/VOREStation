import { Window } from '../../layouts';
import { ChemDispenserBeaker } from './ChemDispenserBeaker';
import { ChemDispenserChemicals } from './ChemDispenserChemicals';
import { ChemDispenserSettings } from './ChemDispenserSettings';

export const ChemDispenser = (props) => {
  return (
    <Window width={390} height={655}>
      <Window.Content className="Layout__content--flexColumn">
        <ChemDispenserSettings />
        <ChemDispenserChemicals />
        <ChemDispenserBeaker />
      </Window.Content>
    </Window>
  );
};
