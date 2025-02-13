import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Icon,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import { capitalize } from 'tgui-core/string';

import { NoSpriteWarning } from '../components';
import { prepareSearch } from '../functions';
import type { Target } from '../types';

export const ModifyRobotRadio = (props: { target: Target }) => {
  const { target } = props;
  const [searchChannelAddText, setSearchChannelAddText] = useState<string>('');
  const [searchChannelRemoveText, setSearchChannelRemoveText] =
    useState<string>('');

  return (
    <>
      {!target.active && <NoSpriteWarning name={target.name} />}
      <Stack height={!target.active ? '75%' : '80%'}>
        <Stack.Item width="30%">
          <RadioSection
            title="Add Radio Channel"
            searchText={searchChannelAddText}
            onSearchText={setSearchChannelAddText}
            channels={target.availalbe_channels}
            action="add_channel"
            buttonColor="green"
            buttonIcon="arrow-right-to-bracket"
          />
        </Stack.Item>
        <Stack.Item width="40%">
          <Stack>
            <Stack.Item grow />
            <Stack.Item>
              <Box
                className={classes([target.sprite_size, target.sprite + 'N'])}
              />
            </Stack.Item>
            <Stack.Item grow />
          </Stack>
        </Stack.Item>
        <Stack.Item width="30%">
          <RadioSection
            title="Remove Radio Channel"
            searchText={searchChannelRemoveText}
            onSearchText={setSearchChannelRemoveText}
            channels={target.radio_channels}
            action="rem_channel"
            buttonColor="red"
            buttonIcon="trash"
          />
        </Stack.Item>
      </Stack>
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
                <Stack fill align="center">
                  <Stack.Item grow overflow="hidden">
                    {capitalize(channel)}
                  </Stack.Item>
                  <Stack.Item>
                    <Icon
                      name={buttonIcon}
                      backgroundColor={buttonColor}
                      size={1.5}
                    />
                  </Stack.Item>
                </Stack>
              </Button>
            );
          })}
        </Stack.Item>
      </Stack>
    </Section>
  );
};
