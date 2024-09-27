import { capitalize } from 'common/string';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Button,
  Divider,
  Flex,
  Icon,
  Image,
  Input,
  Section,
  Stack,
} from 'tgui/components';

import { NoSpriteWarning } from '../components';
import { prepareSearch } from '../functions';
import { Access, Target } from '../types';

export const ModifyRobotAccess = (props: {
  target: Target;
  tab_icon: string;
  all_access: Access[];
}) => {
  const { act } = useBackend();
  const { target, tab_icon, all_access } = props;
  const [searchAccessAll, setSearchAccessAll] = useState<string>('');
  const [searchAccessActive, setSearchAccessActive] = useState<string>('');

  return (
    <>
      {!target.active && <NoSpriteWarning name={target.name} />}
      <Flex height={!target.active ? '75%' : '80%'}>
        <Flex.Item width="30%" fill>
          <AccessSection
            title="Add Access"
            searchText={searchAccessAll}
            onSearchText={setSearchAccessAll}
            access={all_access}
            action="add_access"
            buttonColor="green"
            buttonIcon="arrow-right-to-bracket"
          />
        </Flex.Item>
        <Flex.Item width="40%">
          <Image
            src={tab_icon}
            style={{
              display: 'block',
              marginLeft: 'auto',
              marginRight: 'auto',
              width: '200px',
            }}
          />
          <Stack vertical>
            <Stack.Item>
              <Flex>
                <Flex.Item grow />
                <Flex.Item>
                  <Button
                    height="20px"
                    color="green"
                    icon="satellite"
                    onClick={() => act('add_station')}
                  >
                    Add station access
                  </Button>
                </Flex.Item>
                <Flex.Item grow />
                <Button
                  height="20px"
                  color="red"
                  icon="satellite"
                  onClick={() => act('rem_station')}
                >
                  Remove station access
                </Button>
                <Flex.Item grow />
              </Flex>
            </Stack.Item>
            <Stack.Item mt="40px">
              <Flex>
                <Flex.Item grow />
                <Button
                  height="20px"
                  color="green"
                  icon="building"
                  onClick={() => act('add_centcom')}
                >
                  Add centcom access
                </Button>
                <Flex.Item grow />
                <Button
                  height="20px"
                  color="red"
                  icon="building"
                  onClick={() => act('rem_centcom')}
                >
                  Remove centcom access
                </Button>
                <Flex.Item grow />
              </Flex>
            </Stack.Item>
          </Stack>
        </Flex.Item>
        <Flex.Item width="30%" fill>
          <AccessSection
            title="Remove Access"
            searchText={searchAccessActive}
            onSearchText={setSearchAccessActive}
            access={target.active_access}
            action="rem_access"
            buttonColor="red"
            buttonIcon="trash"
          />
        </Flex.Item>
      </Flex>
    </>
  );
};

const AccessSection = (props: {
  title: string;
  searchText: string;
  onSearchText: Function;
  access: Access[];
  action: string;
  buttonColor: string;
  buttonIcon: string;
}) => {
  const { act } = useBackend();
  const {
    title,
    searchText,
    onSearchText,
    access,
    action,
    buttonColor,
    buttonIcon,
  } = props;
  return (
    <Section title={title} fill scrollable scrollableHorizontal>
      <Input
        fluid
        value={searchText}
        placeholder="Search for access..."
        onInput={(e, value: string) => onSearchText(value)}
      />
      <Divider />
      <Stack>
        <Stack.Item width="100%">
          {prepareSearch(access, searchText).map((acc, i) => {
            return (
              <Button
                fluid
                key={i}
                onClick={() =>
                  act(action, {
                    access: acc.id,
                  })
                }
              >
                <Flex varticalAlign="center">
                  <Flex.Item>{capitalize(acc.name)}</Flex.Item>
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
