import { useBackend } from '../../backend';
import { SleeperChemicals } from './SleeperChemicals';
import { SleeperDamage } from './SleeperDamage';
import { SleeperDialysisPump } from './SleeperDialysisPump';
import { SleeperOccupant } from './SleeperOccupant';
import { Data } from './types';

export const SleeperMain = (props) => {
  const { data } = useBackend<Data>();
  const { dialysis, stomachpumping } = data;
  return (
    <>
      <SleeperOccupant />
      <SleeperDamage />
      <SleeperDialysisPump
        title="Dialysis"
        active={dialysis}
        actToDo="togglefilter"
      />
      <SleeperDialysisPump
        title="Stomach Pump"
        active={stomachpumping}
        actToDo="togglepump"
      />
      <SleeperChemicals />
    </>
  );
};
