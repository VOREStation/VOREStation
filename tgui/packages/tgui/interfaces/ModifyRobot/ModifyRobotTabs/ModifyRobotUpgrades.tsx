import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import { capitalize } from 'tgui-core/string';

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
      <Stack height="35%">
        <Stack.Item width="30%">
          <UpgradeSection
            title="Add Compatibility"
            searchText={searchAddCompatibilityText}
            onSearchText={setSearchAddCompatibilityText}
            upgrades={target.whitelisted_upgrades}
            action="add_compatibility"
          />
        </Stack.Item>
        <Stack.Item width="40%">
          <Stack>
            <Stack.Item grow />
            <Stack.Item>
              <Box
                className={classes([target.sprite_size, target.sprite + 'W'])}
              />
            </Stack.Item>
            <Stack.Item grow />
          </Stack>
        </Stack.Item>
        <Stack.Item width="30%">
          <UpgradeSection
            title="Remove Compatibility"
            searchText={searchRemoveCompatibilityText}
            onSearchText={setSearchRemoveCompatibilityText}
            upgrades={target.blacklisted_upgrades}
            action="rem_compatibility"
          />
        </Stack.Item>
      </Stack>
      <Stack height={!target.active ? '40%' : '45%'}>
        <Stack.Item width="25%">
          <UpgradeSection
            title="Utility Upgrade"
            searchText={searchUtilityUpgradeText}
            onSearchText={setsearchUtilityUpgradeText}
            upgrades={target.utility_upgrades}
            action="add_upgrade"
          />
        </Stack.Item>
        <Stack.Item width="25%">
          <UpgradeSection
            title="Basic Upgrade"
            searchText={searchBasicUpgradeText}
            onSearchText={setSearchBasicUpgradeText}
            upgrades={target.basic_upgrades}
            action="add_upgrade"
          />
        </Stack.Item>
        <Stack.Item width="25%">
          <UpgradeSection
            title="Advanced Upgrade"
            searchText={searchAdvancedUpgradeText}
            onSearchText={setSearchAdvancedUpgradeText}
            upgrades={target.advanced_upgrades}
            action="add_upgrade"
          />
        </Stack.Item>
        <Stack.Item width="25%">
          <UpgradeSection
            title="Restricted Upgrade"
            searchText={searchRestrictedUpgradeText}
            onSearchText={setSearchRestrictedUpgradeText}
            upgrades={target.restricted_upgrades}
            action="add_upgrade"
          />
        </Stack.Item>
      </Stack>
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
