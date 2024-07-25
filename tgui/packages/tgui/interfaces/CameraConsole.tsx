import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { BooleanLike, classes } from 'common/react';
import { createSearch } from 'common/string';
import { useState } from 'react';

import { useBackend } from '../backend';
import { Button, ByondUi, Dropdown, Flex, Input, Section } from '../components';
import { Window } from '../layouts';

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
  return flow([
    (cameras: camera[]) =>
      // Null camera filter
      filter(cameras, (camera) => notEmpty(camera?.name)),
    (cameras: camera[]) => {
      // Optional search term
      if (!searchText) {
        return cameras;
      } else {
        return filter(cameras, testSearch);
      }
    },
    (cameras: camera[]) => {
      // Optional network filter
      if (!networkFilter) {
        return cameras;
      } else {
        return filter(cameras, (camera) =>
          camera.networks.includes(networkFilter),
        );
      }
    },
    // Slightly expensive, but way better than sorting in BYOND
    (cameras: camera[]) => sortBy(cameras, (camera) => camera.name),
  ])(cameras);
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
    <Flex direction={'column'} height="100%">
      <Flex.Item>
        <Input
          autoFocus
          fluid
          mt={1}
          placeholder="Search for a camera"
          onInput={(e, value: string) => setSearchText(value)}
        />
      </Flex.Item>
      <Flex.Item>
        <Flex>
          <Flex.Item>
            <Dropdown
              autoScroll={false}
              mb={1}
              width={networkFilter ? '155px' : '177px'}
              selected={networkFilter}
              displayText={networkFilter || 'No Filter'}
              options={allNetworks}
              onSelected={(value) => setNetworkFilter(value)}
            />
          </Flex.Item>
          {networkFilter ? (
            <Flex.Item>
              <Button
                width="22px"
                icon="undo"
                color="red"
                onClick={() => {
                  setNetworkFilter('');
                }}
              />
            </Flex.Item>
          ) : (
            ''
          )}
        </Flex>
      </Flex.Item>
      <Flex.Item height="100%">
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
      </Flex.Item>
    </Flex>
  );
};
