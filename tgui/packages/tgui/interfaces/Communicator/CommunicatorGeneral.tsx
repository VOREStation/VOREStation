import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  ByondUi,
  Icon,
  Section,
  Stack,
} from 'tgui-core/components';
import { decodeHtmlEntities } from 'tgui-core/string';

import { HOMETAB } from './constants';
import { Data } from './types';

export const TemplateError = (props: { currentTab: number }) => {
  return (
    <Section title="Error!">
      You tried to access tab #{props.currentTab}, but there was no template
      defined!
    </Section>
  );
};
export const CommunicatorHeader = (props) => {
  const { act, data } = useBackend<Data>();

  const { time, connectionStatus, owner, occupation } = data;

  return (
    <Section>
      <Stack align="center" justify="space-between">
        <Stack.Item color="average">{time}</Stack.Item>
        <Stack.Item>
          <Icon
            color={connectionStatus === 1 ? 'good' : 'bad'}
            name={connectionStatus === 1 ? 'signal' : 'exclamation-triangle'}
          />
        </Stack.Item>
        <Stack.Item color="average">{decodeHtmlEntities(owner)}</Stack.Item>
        <Stack.Item color="average">
          {decodeHtmlEntities(occupation)}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const CommunicatorFooter = (props: {
  videoSetting: number;
  setVideoSetting: Function;
}) => {
  const { act, data } = useBackend<Data>();

  const { flashlight } = data;

  const { videoSetting, setVideoSetting } = props;

  return (
    <Stack>
      <Stack.Item basis={videoSetting === 2 ? '60%' : '80%'}>
        <Button
          p={1}
          fluid
          icon="home"
          iconSize={2}
          textAlign="center"
          onClick={() => act('switch_tab', { switch_tab: HOMETAB })}
        />
      </Stack.Item>
      <Stack.Item basis="20%">
        <Button
          icon="lightbulb"
          iconSize={2}
          p={1}
          fluid
          textAlign="center"
          selected={flashlight}
          tooltip="Flashlight"
          tooltipPosition="top"
          onClick={() => act('Light')}
        />
      </Stack.Item>
      {videoSetting === 2 && (
        <Stack.Item basis="20%">
          <Button
            icon="video"
            iconSize={2}
            p={1}
            fluid
            textAlign="center"
            tooltip="Open Video"
            tooltipPosition="top"
            onClick={() => setVideoSetting(1)}
          />
        </Stack.Item>
      )}
    </Stack>
  );
};

export const VideoComm = (props: {
  videoSetting: number;
  setVideoSetting: Function;
}) => {
  const { act, data } = useBackend<Data>();

  const { mapRef } = data;

  const { videoSetting, setVideoSetting } = props;

  if (videoSetting === 0) {
    return (
      <Box width="100%" height="100%">
        <ByondUi
          width="100%"
          height="95%"
          params={{
            id: mapRef,
            type: 'map',
          }}
        />
        <Stack justify="space-between" mt={0.5}>
          <Stack.Item grow>
            <Button
              textAlign="center"
              fluid
              fontSize={1.5}
              icon="window-minimize"
              onClick={() => setVideoSetting(1)}
            />
          </Stack.Item>
          <Stack.Item grow>
            <Button
              textAlign="center"
              fluid
              fontSize={1.5}
              color="bad"
              icon="video-slash"
              onClick={() => act('endvideo')}
            />
          </Stack.Item>
          <Stack.Item grow>
            <Button
              textAlign="center"
              fluid
              fontSize={1.5}
              color="bad"
              icon="phone-slash"
              onClick={() => act('hang_up')}
            />
          </Stack.Item>
        </Stack>
      </Box>
    );
  } else if (videoSetting === 1) {
    return (
      <Box
        style={{
          position: 'absolute',
          right: '5px',
          bottom: '50px',
          zIndex: '1',
        }}
      >
        <Section p={0} m={0}>
          <Stack justify="space-between">
            <Stack.Item grow>
              <Button
                textAlign="center"
                fluid
                fontSize={1.5}
                icon="window-minimize"
                onClick={() => setVideoSetting(2)}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Button
                textAlign="center"
                fluid
                fontSize={1.5}
                icon="window-maximize"
                onClick={() => setVideoSetting(0)}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Button
                textAlign="center"
                fluid
                fontSize={1.5}
                color="bad"
                icon="video-slash"
                onClick={() => act('endvideo')}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Button
                textAlign="center"
                fluid
                fontSize={1.5}
                color="bad"
                icon="phone-slash"
                onClick={() => act('hang_up')}
              />
            </Stack.Item>
          </Stack>
        </Section>
        <ByondUi
          width="200px"
          height="200px"
          params={{
            id: mapRef,
            type: 'map',
          }}
        />
      </Box>
    );
  }
  return null;
};
