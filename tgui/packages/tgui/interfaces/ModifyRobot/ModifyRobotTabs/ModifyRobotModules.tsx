import { filter } from 'common/collections';
import { flow } from 'common/fp';
import { createSearch } from 'common/string';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Dropdown,
  Flex,
  Icon,
  Image,
  Input,
  Section,
  Stack,
} from 'tgui/components';

import { NoSpriteWarning } from '../components';
import { Module, Source, Target } from '../types';

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
      <Flex height={!target.active ? '80%' : '85%'}>
        <Flex.Item width="40%" fill>
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
                previewImage={source.front}
                searchText={searchSourceText}
                onSearchText={setSearchSourceText}
                action="add_module"
                buttonIcon="arrow-right-to-bracket"
                buttonColor="green"
                modules={source.modules}
              />
            )}
          </Section>
        </Flex.Item>
        <Flex.Item grow />
        <Flex.Item>
          <Button
            disabled={!source}
            tooltip="Swaps the source and destination module types."
            icon="arrows-rotate"
            iconSize={4}
            onClick={() => act('swap_module')}
          />
        </Flex.Item>
        <Flex.Item grow />
        <Flex.Item width="40%" fill>
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
              previewImage={target.front}
              searchText={searchModuleText}
              onSearchText={setSearchModulText}
              action="rem_module"
              buttonIcon="trash"
              buttonColor="red"
              modules={target.modules}
            />
          </Section>
        </Flex.Item>
      </Flex>
    </>
  );
};

function prepareSearch(modules: Module[], searchText: string = ''): Module[] {
  const testSearch = createSearch(searchText, (module: Module) => module.item);
  return flow([
    (modules: Module[]) => {
      // Optional search term
      if (!searchText) {
        return modules;
      } else {
        return filter(modules, testSearch);
      }
    },
  ])(modules);
}

const SelectionField = (props: {
  previewImage: string | null;
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
      <Image
        src={'data:image/jpeg;base64, ' + previewImage}
        style={{
          display: 'block',
          marginLeft: 'auto',
          marginRight: 'auto',
          height: '200px',
        }}
      />
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
                <Flex varticalAlign="center">
                  <Flex.Item>
                    <Image src={modul_option.icon} />
                  </Flex.Item>
                  <Flex.Item ml="10px">{modul_option.item}</Flex.Item>
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
    </>
  );
};
