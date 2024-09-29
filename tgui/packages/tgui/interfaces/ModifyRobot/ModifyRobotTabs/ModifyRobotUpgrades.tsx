import { capitalize } from 'common/string';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Button,
  Divider,
  Flex,
  Image,
  Input,
  Section,
  Stack,
} from 'tgui/components';

import { NoSpriteWarning } from '../components';
import { install2col } from '../constants';
import { prepareSearch } from '../functions';
import { Target, Upgrade } from '../types';

export const ModifyRobotUpgrades = (props: { target: Target }) => {
  const { target } = props;
  const [searchAddCompatibilityText, setSearchAddCompatibilityText] =
    useState<string>('');
  const [searchRemoveCompatibilityText, setSearchRemoveCompatibilityText] =
    useState<string>('');
  const [searchUtilityUpgradeText, setsearchUtilityUpgradeText] =
    useState<string>('');
  const [searchBasicUpgradeText, setSearchBasicUpgradeText] =
    useState<string>('');
  const [searchAdvancedUpgradeText, setSearchAdvancedUpgradeText] =
    useState<string>('');
  const [searchRestrictedUpgradeText, setSearchRestrictedUpgradeText] =
    useState<string>('');

  return (
    <>
      {!target.active && <NoSpriteWarning name={target.name} />}
      <Flex height="35%">
        <Flex.Item width="30%" fill>
          <UpgradeSection
            title="Add Compatibility"
            searchText={searchAddCompatibilityText}
            onSearchText={setSearchAddCompatibilityText}
            upgrades={target.whitelisted_upgrades}
            action="add_compatibility"
          />
        </Flex.Item>
        <Flex.Item width="40%">
          <Image
            src={'data:image/jpeg;base64, ' + target.side}
            style={{
              display: 'block',
              marginLeft: 'auto',
              marginRight: 'auto',
              width: '200px',
            }}
          />
        </Flex.Item>
        <Flex.Item width="30%" fill>
          <UpgradeSection
            title="Remove Compatibility"
            searchText={searchRemoveCompatibilityText}
            onSearchText={setSearchRemoveCompatibilityText}
            upgrades={target.blacklisted_upgrades}
            action="rem_compatibility"
          />
        </Flex.Item>
      </Flex>
      <Flex height={!target.active ? '40%' : '45%'}>
        <Flex.Item width="25%" fill>
          <UpgradeSection
            title="Utility Upgrade"
            searchText={searchUtilityUpgradeText}
            onSearchText={setsearchUtilityUpgradeText}
            upgrades={target.utility_upgrades}
            action="add_upgrade"
          />
        </Flex.Item>
        <Flex.Item width="25%" fill>
          <UpgradeSection
            title="Basic Upgrade"
            searchText={searchBasicUpgradeText}
            onSearchText={setSearchBasicUpgradeText}
            upgrades={target.basic_upgrades}
            action="add_upgrade"
          />
        </Flex.Item>
        <Flex.Item width="25%" fill>
          <UpgradeSection
            title="Advanced Upgrade"
            searchText={searchAdvancedUpgradeText}
            onSearchText={setSearchAdvancedUpgradeText}
            upgrades={target.advanced_upgrades}
            action="add_upgrade"
          />
        </Flex.Item>
        <Flex.Item width="25%" fill>
          <UpgradeSection
            title="Restricted Upgrade"
            searchText={searchRestrictedUpgradeText}
            onSearchText={setSearchRestrictedUpgradeText}
            upgrades={target.restricted_upgrades}
            action="add_upgrade"
          />
        </Flex.Item>
      </Flex>
    </>
  );
};

const UpgradeSection = (props: {
  title: string;
  searchText: string;
  onSearchText: Function;
  upgrades: Upgrade[];
  action: string;
}) => {
  const { act } = useBackend();
  const { title, searchText, onSearchText, upgrades, action } = props;
  return (
    <Section title={title} fill scrollable scrollableHorizontal>
      <Input
        fluid
        value={searchText}
        placeholder="Search for upgrades..."
        onInput={(e, value: string) => onSearchText(value)}
      />
      <Divider />
      <Stack>
        <Stack.Item width="100%">
          {prepareSearch(upgrades, searchText).map((upgrade, i) => {
            return (
              <Button
                fluid
                key={i}
                color={
                  upgrade.installed !== undefined
                    ? install2col[upgrade.installed]
                    : undefined
                }
                onClick={() =>
                  act(action, {
                    upgrade: upgrade.path,
                  })
                }
              >
                {capitalize(upgrade.name)}
              </Button>
            );
          })}
        </Stack.Item>
      </Stack>
    </Section>
  );
};
