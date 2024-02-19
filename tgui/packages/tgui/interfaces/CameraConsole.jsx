import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { classes } from 'common/react';
import { createSearch } from 'common/string';
import { useState } from 'react';

import { useBackend } from '../backend';
import { Button, ByondUi, Dropdown, Flex, Input, Section } from '../components';
import { Window } from '../layouts';

/**
 * Returns previous and next camera names relative to the currently
 * active camera.
 */
export const prevNextCamera = (cameras, activeCamera) => {
  if (!activeCamera) {
    return [];
  }
  const index = cameras.findIndex(
    (camera) => camera.name === activeCamera.name,
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

export const CameraConsole = (props) => {
  const { act, data } = useBackend();
  const { mapRef, activeCamera } = data;
  const cameras = selectCameras(data.cameras);
  const [prevCameraName, nextCameraName] = prevNextCamera(
    cameras,
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
  const { act, data } = useBackend();
  const [searchText, setSearchText] = useState('');
  const [networkFilter, setNetworkFilter] = useState('');
  const { activeCamera, allNetworks } = data;
  allNetworks.sort();
  const cameras = selectCameras(data.cameras, searchText, networkFilter);
  return (
    <Flex direction={'column'} height="100%">
      <Flex.Item>
        <Input
          autoFocus
          fluid
          mt={1}
          placeholder="Search for a camera"
          onInput={(e, value) => setSearchText(value)}
        />
      </Flex.Item>
      <Flex.Item>
        <Flex>
          <Flex.Item>
            <Dropdown
              mb={1}
              width={networkFilter ? '155px' : '177px'}
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
          {cameras.map((camera) => (
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
