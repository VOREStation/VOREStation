import { useBackend } from '../../backend';
import { Window } from '../../layouts';
import { AtmoControlFuel } from './FuelControls';
import { AtmoControlSensors } from './Sensors';
import { AtmoControlTankCore } from './TankControls';
import { Data } from './types';

export const GeneralAtmoControl = (props) => {
  const { data } = useBackend<Data>();

  // While many of these variables are unused, it's helpful to have a consistent
  // list of all possible parameters in the core component of this UI.
  // So, keep them here and update them as necessary, pretty please.
  const {
    // All
    sensors,
    // Tanks /obj/machinery/computer/general_air_control
    tanks,
    // Core /obj/machinery/computer/general_air_control/supermatter_core
    core,
    // Fuel /obj/machinery/computer/general_air_control/fuel_injection
    fuel,
  } = data;

  return (
    <Window width={600} height={600}>
      <Window.Content>
        <AtmoControlSensors sensors={sensors} />
        {(core || tanks) && <AtmoControlTankCore />}
        {fuel && <AtmoControlFuel />}
      </Window.Content>
    </Window>
  );
};
