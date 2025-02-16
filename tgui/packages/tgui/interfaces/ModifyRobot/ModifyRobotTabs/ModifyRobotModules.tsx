import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Dropdown,
  Icon,
  Image,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import { capitalize } from 'tgui-core/string';

import { NoSpriteWarning } from '../components';
import { prepareSearch } from '../functions';
import type { Module, Source, Target } from '../types';

export const ModifyRobotModules = (props: {
  target: Target;
  source: Source;
  model_options: string[];
}) => {
  const { target, source, model_options } = props;
  const { act } = useBackend();
  const [searchSourceText, setSearchSourceText] = useState<string>('');
  const [searchModuleText, setSearchModulText] = useState<string>('');

  return (
    <>
      {!target.active && <NoSpriteWarning name={target.name} />}
      <Stack height={!target.active ? '75%' : '80%'}>
        <Stack.Item width="40%">
          <Section title="Source Module" scrollable fill>
            <Box>Robot to salvage</Box>
            <Dropdown
              width="100%"
              selected={source ? source.model : ''}
              options={model_options}
              onSelected={(value) =>
                act('select_source', {
                  new_source: value,
                })
              }
            />
            {!!source && (
              <SelectionField
                previewImage={source.sprite}
                previewImageSize={source.sprite_size}
                searchText={searchSourceText}
                onSearchText={setSearchSourceText}
                action="add_module"
                buttonIcon="arrow-right-to-bracket"
                buttonColor="green"
                modules={source.modules}
              />
            )}
          </Section>
        </Stack.Item>
        <Stack.Item grow />
        <Stack.Item>
          <Stack vertical>
            <Stack.Item>
              <Button.Confirm
                width="50px"
                height="50px"
                disabled={!source}
                tooltip="Swaps the source and destination module types."
                icon="arrows-rotate"
                iconSize={4}
                onClick={() => act('swap_module')}
              />
            </Stack.Item>
            <Stack.Item>
              <Button.Confirm
                width="50px"
                height="50px"
                mt={40}
                textAlign="center"
                tooltip={
                  (target.crisis_override ? 'Disable' : 'Enable') +
                  ' ERT module access and reset the robot!'
                }
                color={target.crisis_override ? 'green' : 'yellow'}
                icon="circle-radiation"
                iconSize={4}
                onClick={() => act('ert_toggle')}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow />
        <Stack.Item width="40%">
          <Section title="Destination Module" scrollable fill>
            <Box>{target ? target.module : ''}</Box>
            <Button.Confirm
              fluid
              icon="arrow-rotate-left"
              confirmColor="red"
              confirmIcon="triangle-exclamation"
              onClick={() => act('reset_module')}
              tooltip="Allows to reset the module back to default."
            >
              Reset Module
            </Button.Confirm>
            <Divider />
            <SelectionField
              previewImage={target.sprite}
              previewImageSize={target.sprite_size}
              searchText={searchModuleText}
              onSearchText={setSearchModulText}
              action="rem_module"
              buttonIcon="trash"
              buttonColor="red"
              modules={target.modules}
            />
          </Section>
        </Stack.Item>
      </Stack>
    </>
  );
};

const SelectionField = (props: {
  previewImage: string | undefined;
  previewImageSize: string | undefined;
  searchText: string;
  onSearchText: Function;
  action: string;
  buttonIcon: string;
  buttonColor: string;
  modules: Module[];
}) => {
  const { act } = useBackend();
  const {
    previewImage,
    previewImageSize,
    searchText,
    onSearchText,
    action,
    modules,
    buttonIcon,
    buttonColor,
  } = props;

  return (
    <>
      <Divider />
      <Stack>
        <Stack.Item grow />
        <Stack.Item>
          <Box className={classes([previewImageSize, previewImage + 'S'])} />
        </Stack.Item>
        <Stack.Item grow />
      </Stack>
      <Divider />
      <Input
        fluid
        value={searchText}
        placeholder="Search for modules..."
        onInput={(e, value: string) => onSearchText(value)}
      />
      <Divider />
      <Stack>
        <Stack.Item width="100%">
          {prepareSearch(modules, searchText).map((modul_option, i) => {
            return (
              <Button
                fluid
                key={i}
                tooltip={modul_option.desc}
                onClick={() =>
                  act(action, {
                    module: modul_option.ref,
                  })
                }
              >
                <Stack fill align="center">
                  <Stack.Item>
                    <Image src={modul_option.icon} />
                  </Stack.Item>
                  <Stack.Item grow overflow="hidden" ml="10px">
                    {capitalize(modul_option.name)}
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
    </>
  );
};
