import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Button,
  ByondUi,
  Dropdown,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';
import { type BooleanLike, classes } from 'tgui-core/react';
import { createSearch } from 'tgui-core/string';

type activeCamera = { name: string; status: BooleanLike } | null;

export type camera = { name: string; networks: string[] };

export type Data = {
  activeCamera: activeCamera;
  mapRef: string;
  cameras: camera[];
  allNetworks: string[];
};

/**
 * Returns previous and next camera names relative to the currently
 * active camera.
 */
export const prevNextCamera = (
  cameras: camera[],
  activeCamera: activeCamera,
) => {
  if (!activeCamera) {
    return [];
  }
  const index = cameras.findIndex(
    (camera) => camera.name === activeCamera.name,
  );
  return [cameras[index - 1]?.name, cameras[index + 1]?.name];
};

function notEmpty<TValue>(value: TValue | null | undefined): value is TValue {
  return value !== null && value !== undefined;
}

/**
 * Camera selector.
 *
 * Filters cameras, applies search terms and sorts the alphabetically.
 */
export const selectCameras = (
  cameras: camera[],
  searchText: string = '',
  networkFilter: string = '',
): camera[] => {
  const testSearch = createSearch(searchText, (camera: camera) => camera.name);

  return cameras
    .filter((camera) => notEmpty(camera?.name))
    .filter((camera) => {
      if (!searchText) {
        return true;
      } else {
        return testSearch(camera);
      }
    })
    .filter((camera) => {
      if (!networkFilter) {
        return true;
      } else {
        return camera.networks.includes(networkFilter);
      }
    })
    .sort((a, b) => a.name.localeCompare(b.name));
};

export const CameraConsole = (props) => {
  const { act, data } = useBackend<Data>();
  const { mapRef, activeCamera } = data;

  const { cameras } = data;

  const selected_cameras: camera[] = selectCameras(cameras);
  const [prevCameraName, nextCameraName]: string[] = prevNextCamera(
    selected_cameras,
    activeCamera,
  );
  return (
    <Window width={870} height={708}>
      <div className="CameraConsole__left">
        <Window.Content scrollable>
          <CameraConsoleContent />
        </Window.Content>
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
          <Button icon="chevron-left" onClick={() => act('pan', { dir: 8 })} />
          <Button icon="chevron-up" onClick={() => act('pan', { dir: 1 })} />
          <Button icon="chevron-right" onClick={() => act('pan', { dir: 4 })} />
          <Button icon="chevron-down" onClick={() => act('pan', { dir: 2 })} />
        </div>
        <ByondUi
          className="CameraConsole__map"
          params={{
            id: mapRef,
            type: 'map',
          }}
        />
      </div>
    </Window>
  );
};

export const CameraConsoleContent = (props) => {
  const { act, data } = useBackend<Data>();
  const [searchText, setSearchText] = useState<string>('');
  const [networkFilter, setNetworkFilter] = useState<string>('');
  const { activeCamera, allNetworks, cameras } = data;
  allNetworks.sort();
  const selected_cameras: camera[] = selectCameras(
    cameras,
    searchText,
    networkFilter,
  );
  return (
    <Stack vertical height="100%">
      <Stack.Item>
        <Input
          autoFocus
          fluid
          mt={1}
          placeholder="Search for a camera"
          onInput={(e, value: string) => setSearchText(value)}
        />
      </Stack.Item>
      <Stack.Item>
        <Stack>
          <Stack.Item>
            <Dropdown
              autoScroll={false}
              mb={1}
              width={networkFilter ? '155px' : '177px'}
              selected={networkFilter}
              displayText={networkFilter || 'No Filter'}
              options={allNetworks}
              onSelected={(value) => setNetworkFilter(value)}
            />
          </Stack.Item>
          {networkFilter ? (
            <Stack.Item>
              <Button
                width="22px"
                icon="undo"
                color="red"
                onClick={() => {
                  setNetworkFilter('');
                }}
              />
            </Stack.Item>
          ) : (
            ''
          )}
        </Stack>
      </Stack.Item>
      <Stack.Item height="100%">
        <Section fill scrollable>
          {selected_cameras.map((camera) => (
            // We're not using the component here because performance
            // would be absolutely abysmal (50+ ms for each re-render).
            <div
              key={camera.name}
              title={camera.name}
              className={classes([
                'Button',
                'Button--fluid',
                'Button--color--transparent',
                'Button--ellipsis',
                activeCamera &&
                  camera.name === activeCamera.name &&
                  'Button--selected',
              ])}
              onClick={() =>
                act('switch_camera', {
                  name: camera.name,
                })
              }
            >
              {camera.name}
            </div>
          ))}
        </Section>
      </Stack.Item>
    </Stack>
  );
};
