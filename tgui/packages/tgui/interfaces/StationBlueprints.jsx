import { useBackend } from '../backend';
import { ByondUi } from '../components';
import { Window } from '../layouts';

export const StationBlueprints = (props) => {
  return (
    <Window width={870} height={708}>
      <StationBlueprintsContent />
    </Window>
  );
};

export const StationBlueprintsContent = (props) => {
  const { act, data, config } = useBackend();

  const { mapRef, areas, turfs } = data;
  return (
    <>
      <div className="CameraConsole__left">
        <Window.Content scrollable>Honk!</Window.Content>
      </div>
      <div className="CameraConsole__right">
        <ByondUi
          className="CameraConsole__map"
          params={{
            id: mapRef,
            type: 'map',
          }}
        />
      </div>
    </>
  );
};
