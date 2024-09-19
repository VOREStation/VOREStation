import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Dropdown,
  Flex,
  Icon,
  Image,
  Section,
  Stack,
} from 'tgui/components';

import { Source, Target } from '../types';

export const ModifyRobotModules = (props: {
  target: Target;
  source: Source;
  model_options: string[];
}) => {
  const { target, source, model_options } = props;
  const { act } = useBackend();

  return (
    <Flex>
      <Flex.Item width="40%">
        <Section title="Source Module">
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
            <>
              <Divider />
              <Image
                src={'data:image/jpeg;base64, ' + source.front}
                style={{
                  display: 'block',
                  marginLeft: 'auto',
                  marginRight: 'auto',
                  height: '200px',
                }}
              />
              <Divider />
              <Stack fill>
                <Stack.Item width="100%">
                  {source.modules.map((modul_option, i) => {
                    return (
                      <Button
                        fluid
                        key={i}
                        onClick={() =>
                          act('add_module', {
                            new_module: modul_option.ref,
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
                              name="arrow-right-to-bracket"
                              backgroundColor="green"
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
          )}
        </Section>
      </Flex.Item>
      <Flex.Item grow />
      <Flex.Item width="40%">
        <Section title="Destination Module">
          <Box>{target ? target.module : ''}</Box>
          <Button.Confirm
            fluid
            icon="arrow-rotate-left"
            confirmColor="red"
            confirmIcon="triangle-exclamation"
            onClick={() => act('reset_module')}
          >
            Reset Module
          </Button.Confirm>
          <Divider />
          <Image
            src={'data:image/jpeg;base64, ' + target.front}
            style={{
              display: 'block',
              marginLeft: 'auto',
              marginRight: 'auto',
              height: '200px',
            }}
          />
          <Divider />
          <Stack fill>
            <Stack.Item width="100%">
              {target.modules.map((modul_option, i) => {
                return (
                  <Button
                    fluid
                    key={i}
                    onClick={() =>
                      act('rem_module', {
                        old_module: modul_option.ref,
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
                        <Icon name="trash" backgroundColor="red" size={1.5} />
                      </Flex.Item>
                    </Flex>
                  </Button>
                );
              })}
            </Stack.Item>
          </Stack>
        </Section>
      </Flex.Item>
    </Flex>
  );
};
