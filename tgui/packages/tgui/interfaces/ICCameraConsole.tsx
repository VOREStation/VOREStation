import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { ByondUi, Section, Stack } from 'tgui-core/components';
import { type BooleanLike, classes } from 'tgui-core/react';

type activeCamera = { name: string; status: BooleanLike } | null;

type camera = { name: string };

type Data = {
  activeCamera: activeCamera;
  mapRef: string;
  cameras: camera[];
};

export const ICCameraConsole = (props) => {
  const { act, data } = useBackend<Data>();
  const { mapRef, activeCamera, cameras } = data;

  const sortedCameras = [...cameras]
    .filter((c) => c?.name)
    .sort((a, b) => a.name.localeCompare(b.name));

  return (
    <Window width={870} height={708}>
      <div className="CameraConsole__left">
        <Window.Content scrollable>
          <Stack vertical height="100%">
            <Stack.Item height="100%">
              <Section fill scrollable>
                {sortedCameras.map((camera) => (
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
        </Window.Content>
      </div>
      <div className="CameraConsole__right">
        <div className="CameraConsole__toolbar">
          <b>Camera: </b>
          {activeCamera?.name || '—'}
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
