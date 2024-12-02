import { capitalize } from 'common/string';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Flex,
  Icon,
  Input,
  Section,
  Stack,
} from 'tgui/components';
import { classes } from 'tgui-core/react';

import { NoSpriteWarning } from '../components';
import { prepareSearch } from '../functions';
import { Target } from '../types';

export const ModifyRobotRadio = (props: { target: Target }) => {
  const { target } = props;
  const [searchChannelAddText, setSearchChannelAddText] = useState<string>('');
  const [searchChannelRemoveText, setSearchChannelRemoveText] =
    useState<string>('');

  return (
    <>
      {!target.active && <NoSpriteWarning name={target.name} />}
      <Flex height={!target.active ? '75%' : '80%'}>
        <Flex.Item width="30%" fill>
          <RadioSection
            title="Add Radio Channel"
            searchText={searchChannelAddText}
            onSearchText={setSearchChannelAddText}
            channels={target.availalbe_channels}
            action="add_channel"
            buttonColor="green"
            buttonIcon="arrow-right-to-bracket"
          />
        </Flex.Item>
        <Flex.Item width="40%">
          <Flex>
            <Flex.Item grow />
            <Flex.Item>
              <Box
                className={classes([target.sprite_size, target.sprite + 'N'])}
              />
            </Flex.Item>
            <Flex.Item grow />
          </Flex>
        </Flex.Item>
        <Flex.Item width="30%" fill>
          <RadioSection
            title="Remove Radio Channel"
            searchText={searchChannelRemoveText}
            onSearchText={setSearchChannelRemoveText}
            channels={target.radio_channels}
            action="rem_channel"
            buttonColor="red"
            buttonIcon="trash"
          />
        </Flex.Item>
      </Flex>
    </>
  );
};

const RadioSection = (props: {
  title: string;
  searchText: string;
  onSearchText: Function;
  channels: string[];
  action: string;
  buttonColor: string;
  buttonIcon: string;
}) => {
  const { act } = useBackend();
  const {
    title,
    searchText,
    onSearchText,
    channels,
    action,
    buttonColor,
    buttonIcon,
  } = props;
  return (
    <Section title={title} fill scrollable>
      <Input
        fluid
        value={searchText}
        placeholder="Search for channels..."
        onInput={(e, value: string) => onSearchText(value)}
      />
      <Divider />
      <Stack>
        <Stack.Item width="100%">
          {prepareSearch(channels, searchText).map((channel, i) => {
            return (
              <Button
                fluid
                key={i}
                onClick={() =>
                  act(action, {
                    channel: channel,
                  })
                }
              >
                <Flex varticalAlign="center">
                  <Flex.Item>{capitalize(channel)}</Flex.Item>
                  <Flex.Item grow />
                  <Flex.Item>
                    <Icon
                      name={buttonIcon}
                      backgroundColor={buttonColor}
                      size={1.5}
                    />
                  </Flex.Item>
                </Flex>
              </Button>
            );
          })}
        </Stack.Item>
      </Stack>
    </Section>
  );
};
