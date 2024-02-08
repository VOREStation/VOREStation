import { filter, sortBy } from '../../common/collections';
import { flow } from '../../common/fp';
import { createSearch } from '../../common/string';
import { useBackend } from '../backend';
import { Button, ByondUi } from '../components';
import { NtosWindow } from '../layouts';
import { CameraConsoleContent } from './CameraConsole';

/**
 * Returns previous and next camera names relative to the currently
 * active camera.
 */
export const prevNextCamera = (cameras, activeCamera) => {
  if (!activeCamera) {
    return [];
  }
  const index = cameras.findIndex(
    (camera) => camera.name === activeCamera.name
  );
  return [cameras[index - 1]?.name, cameras[index + 1]?.name];
};

/**
 * Camera selector.
 *
 * Filters cameras, applies search terms and sorts the alphabetically.
 */
export const selectCameras = (cameras, searchText = '', networkFilter = '') => {
  const testSearch = createSearch(searchText, (camera) => camera.name);
  return flow([
    // Null camera filter
    filter((camera) => camera?.name),
    // Optional search term
    searchText && filter(testSearch),
    // Optional network filter
    networkFilter &&
      filter((camera) => camera.networks.includes(networkFilter)),
    // Slightly expensive, but way better than sorting in BYOND
    sortBy((camera) => camera.name),
  ])(cameras);
};

export const NtosCameraConsole = (props) => {
  const { act, data } = useBackend();
  const { mapRef, activeCamera } = data;
  const cameras = selectCameras(data.cameras);
  const [prevCameraName, nextCameraName] = prevNextCamera(
    cameras,
    activeCamera
  );
  return (
    <NtosWindow width={870} height={708}>
      <NtosWindow.Content>
        <div className="CameraConsole__left">
          <CameraConsoleContent />
        </div>
        <div className="CameraConsole__right">
          <div className="CameraConsole__toolbar">
            <b>Camera: </b>
            {(activeCamera && activeCamera.name) || '—'}
          </div>
          <div className="CameraConsole__toolbarRight">
            SEL:
            <Button
              icon="chevron-left"
              disabled={!prevCameraName}
              onClick={() =>
                act('switch_camera', {
                  name: prevCameraName,
                })
              }
            />
            <Button
              icon="chevron-right"
              disabled={!nextCameraName}
              onClick={() =>
                act('switch_camera', {
                  name: nextCameraName,
                })
              }
            />
            | PAN:
            <Button
              icon="chevron-left"
              onClick={() => act('pan', { dir: 8 })}
            />
            <Button icon="chevron-up" onClick={() => act('pan', { dir: 1 })} />
            <Button
              icon="chevron-right"
              onClick={() => act('pan', { dir: 4 })}
            />
            <Button
              icon="chevron-down"
              onClick={() => act('pan', { dir: 2 })}
            />
          </div>
          <ByondUi
            className="CameraConsole__map"
            params={{
              id: mapRef,
              type: 'map',
            }}
          />
        </div>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
