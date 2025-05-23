import { useBackend } from 'tgui/backend';
import { NtosWindow } from 'tgui/layouts';
import { Button, ByondUi } from 'tgui-core/components';

import {
  camera,
  CameraConsoleContent,
  Data,
  prevNextCamera,
  selectCameras,
} from './CameraConsole';

export const NtosCameraConsole = (props) => {
  const { act, data } = useBackend<Data>();
  const { mapRef, activeCamera, cameras } = data;
  const selected_cameras: camera[] = selectCameras(cameras);
  const [prevCameraName, nextCameraName] = prevNextCamera(
    selected_cameras,
    activeCamera,
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
