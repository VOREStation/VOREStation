import { decodeHtmlEntities } from 'common/string';

import { useBackend } from '../../backend';
import { Box, Button, ByondUi, Flex, Icon, Section } from '../../components';
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
      <Flex align="center" justify="space-between">
        <Flex.Item color="average">{time}</Flex.Item>
        <Flex.Item>
          <Icon
            color={connectionStatus === 1 ? 'good' : 'bad'}
            name={connectionStatus === 1 ? 'signal' : 'exclamation-triangle'}
          />
        </Flex.Item>
        <Flex.Item color="average">{decodeHtmlEntities(owner)}</Flex.Item>
        <Flex.Item color="average">{decodeHtmlEntities(occupation)}</Flex.Item>
      </Flex>
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
    <Flex>
      <Flex.Item basis={videoSetting === 2 ? '60%' : '80%'}>
        <Button
          p={1}
          fluid
          icon="home"
          iconSize={2}
          textAlign="center"
          onClick={() => act('switch_tab', { switch_tab: HOMETAB })}
        />
      </Flex.Item>
      <Flex.Item basis="20%">
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
      </Flex.Item>
      {videoSetting === 2 && (
        <Flex.Item basis="20%">
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
        </Flex.Item>
      )}
    </Flex>
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
        <Flex justify="space-between" spacing={1} mt={0.5}>
          <Flex.Item grow={1}>
            <Button
              textAlign="center"
              fluid
              fontSize={1.5}
              icon="window-minimize"
              onClick={() => setVideoSetting(1)}
            />
          </Flex.Item>
          <Flex.Item grow={1}>
            <Button
              textAlign="center"
              fluid
              fontSize={1.5}
              color="bad"
              icon="video-slash"
              onClick={() => act('endvideo')}
            />
          </Flex.Item>
          <Flex.Item grow={1}>
            <Button
              textAlign="center"
              fluid
              fontSize={1.5}
              color="bad"
              icon="phone-slash"
              onClick={() => act('hang_up')}
            />
          </Flex.Item>
        </Flex>
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
          <Flex justify="space-between" spacing={1}>
            <Flex.Item grow={1}>
              <Button
                textAlign="center"
                fluid
                fontSize={1.5}
                icon="window-minimize"
                onClick={() => setVideoSetting(2)}
              />
            </Flex.Item>
            <Flex.Item grow={1}>
              <Button
                textAlign="center"
                fluid
                fontSize={1.5}
                icon="window-maximize"
                onClick={() => setVideoSetting(0)}
              />
            </Flex.Item>
            <Flex.Item grow={1}>
              <Button
                textAlign="center"
                fluid
                fontSize={1.5}
                color="bad"
                icon="video-slash"
                onClick={() => act('endvideo')}
              />
            </Flex.Item>
            <Flex.Item grow={1}>
              <Button
                textAlign="center"
                fluid
                fontSize={1.5}
                color="bad"
                icon="phone-slash"
                onClick={() => act('hang_up')}
              />
            </Flex.Item>
          </Flex>
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
