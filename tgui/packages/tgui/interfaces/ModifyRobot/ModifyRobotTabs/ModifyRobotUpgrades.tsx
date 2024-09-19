import { useBackend } from 'tgui/backend';
import { Button, Flex, Image, Section, Stack } from 'tgui/components';

import { NoSpriteWarning } from '../components';
import { install2col } from '../constants';
import { Target, Upgrade } from '../types';

export const ModifyRobotUpgrades = (props: { target: Target }) => {
  const { target } = props;

  return (
    <>
      {!target.active && <NoSpriteWarning name={target.name} />}
      <Flex height="35%">
        <Flex.Item width="30%" fill>
          <UpgradeSection
            title="Add Compatibility"
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
            upgrades={target.blacklisted_upgrades}
            action="rem_compatibility"
          />
        </Flex.Item>
      </Flex>
      <Flex height={!target.active ? '45%' : '50%'}>
        <Flex.Item width="25%" fill>
          <UpgradeSection
            title="Utility Upgrade"
            upgrades={target.utility_upgrades}
            action="add_upgrade"
          />
        </Flex.Item>
        <Flex.Item width="25%" fill>
          <UpgradeSection
            title="Basic Upgrade"
            upgrades={target.basic_upgrades}
            action="add_upgrade"
          />
        </Flex.Item>
        <Flex.Item width="25%" fill>
          <UpgradeSection
            title="Advanced Upgrade"
            upgrades={target.advanced_upgrades}
            action="add_upgrade"
          />
        </Flex.Item>
        <Flex.Item width="25%" fill>
          <UpgradeSection
            title="Restricted Upgrade"
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
  upgrades: Upgrade[];
  action: string;
}) => {
  const { act } = useBackend();
  const { title, upgrades, action } = props;
  return (
    <Section title={title} fill scrollable scrollableHorizontal>
      <Stack>
        <Stack.Item width="100%">
          {upgrades.map((upgrade, i) => {
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
                {upgrade.name}
              </Button>
            );
          })}
        </Stack.Item>
      </Stack>
    </Section>
  );
};
