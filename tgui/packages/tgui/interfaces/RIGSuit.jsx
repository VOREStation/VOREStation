import { capitalize, toTitleCase } from 'common/string';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Flex,
  LabeledList,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

export const RIGSuit = (props) => {
  const { act, data } = useBackend();

  const { interfacelock, malf, aicontrol, ai } = data;

  let override = null;

  if (interfacelock || malf) {
    // Interface is offline, or a malf AI took over, either way, the user is
    // no longer permitted to view this interface.
    override = <Box color="bad">--HARDSUIT INTERFACE OFFLINE--</Box>;
  } else if (!ai && aicontrol) {
    // Non-AI trying to control the hardsuit while it's AI control overridden
    override = <Box color="bad">-- HARDSUIT CONTROL OVERRIDDEN BY AI --</Box>;
  }

  return (
    <Window height={480} width={550}>
      <Window.Content scrollable>
        {override || (
          <>
            <RIGSuitStatus />
            <RIGSuitHardware />
            <RIGSuitModules />
          </>
        )}
      </Window.Content>
    </Window>
  );
};

const RIGSuitStatus = (props) => {
  const { act, data } = useBackend();

  const {
    // Power Bar
    chargestatus,
    charge,
    maxcharge,
    // AI Control Toggle
    aioverride,
    // Suit Status
    sealing,
    sealed,
    cooling,
    // Cover Locks
    emagged,
    securitycheck,
    coverlock,
  } = data;

  const SealButton = (
    <Button
      icon={sealing ? 'redo' : sealed ? 'power-off' : 'lock-open'}
      iconSpin={sealing}
      disabled={sealing}
      selected={sealed}
      onClick={() => act('toggle_seals')}
    >
      {'Suit ' +
        (sealing ? 'seals working...' : sealed ? 'is Active' : 'is Inactive')}
    </Button>
  );

  const CoolingButton = (
    <Button
      icon={'power-off'}
      selected={cooling}
      onClick={() => act('toggle_cooling')}
    >
      {'Suit Cooling ' + (cooling ? 'is Active' : 'is Inactive')}
    </Button>
  );

  const AIButton = (
    <Button
      selected={aioverride}
      icon="robot"
      onClick={() => act('toggle_ai_control')}
    >
      {'AI Control ' + (aioverride ? 'Enabled' : 'Disabled')}
    </Button>
  );

  return (
    <Section
      title="Status"
      buttons={
        <>
          {SealButton}
          {AIButton}
          {CoolingButton}
        </>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Power Supply">
          <ProgressBar
            minValue={0}
            maxValue={50}
            value={chargestatus}
            ranges={{
              good: [35, Infinity],
              average: [15, 35],
              bad: [-Infinity, 15],
            }}
          >
            {charge} / {maxcharge}
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="Cover Status">
          {emagged || !securitycheck ? (
            <Box color="bad">Error - Maintenance Lock Control Offline</Box>
          ) : (
            <Button
              icon={coverlock ? 'lock' : 'lock-open'}
              onClick={() => act('toggle_suit_lock')}
            >
              {coverlock ? 'Locked' : 'Unlocked'}
            </Button>
          )}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const RIGSuitHardware = (props) => {
  const { act, data } = useBackend();

  const {
    // Disables buttons while the suit is busy
    sealing,
    // Each piece
    helmet,
    helmetDeployed,
    gauntlets,
    gauntletsDeployed,
    boots,
    bootsDeployed,
    chest,
    chestDeployed,
  } = data;

  return (
    <Section title="Hardware">
      <LabeledList>
        <LabeledList.Item
          label="Helmet"
          buttons={
            <Button
              icon={helmetDeployed ? 'sign-out-alt' : 'sign-in-alt'}
              disabled={sealing}
              selected={helmetDeployed}
              onClick={() => act('toggle_piece', { piece: 'helmet' })}
            >
              {helmetDeployed ? 'Deployed' : 'Deploy'}
            </Button>
          }
        >
          {helmet ? capitalize(helmet) : 'ERROR'}
        </LabeledList.Item>
        <LabeledList.Item
          label="Gauntlets"
          buttons={
            <Button
              icon={gauntletsDeployed ? 'sign-out-alt' : 'sign-in-alt'}
              disabled={sealing}
              selected={gauntletsDeployed}
              onClick={() => act('toggle_piece', { piece: 'gauntlets' })}
            >
              {gauntletsDeployed ? 'Deployed' : 'Deploy'}
            </Button>
          }
        >
          {gauntlets ? capitalize(gauntlets) : 'ERROR'}
        </LabeledList.Item>
        <LabeledList.Item
          label="Boots"
          buttons={
            <Button
              icon={bootsDeployed ? 'sign-out-alt' : 'sign-in-alt'}
              disabled={sealing}
              selected={bootsDeployed}
              onClick={() => act('toggle_piece', { piece: 'boots' })}
            >
              {bootsDeployed ? 'Deployed' : 'Deploy'}
            </Button>
          }
        >
          {boots ? capitalize(boots) : 'ERROR'}
        </LabeledList.Item>
        <LabeledList.Item
          label="Chestpiece"
          buttons={
            <Button
              icon={chestDeployed ? 'sign-out-alt' : 'sign-in-alt'}
              disabled={sealing}
              selected={chestDeployed}
              onClick={() => act('toggle_piece', { piece: 'chest' })}
            >
              {chestDeployed ? 'Deployed' : 'Deploy'}
            </Button>
          }
        >
          {chest ? capitalize(chest) : 'ERROR'}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const RIGSuitModules = (props) => {
  const { act, data } = useBackend();

  const {
    // Seals disable Modules
    sealed,
    sealing,
    // Currently Selected system
    primarysystem,
    // The actual modules.
    modules,
  } = data;

  if (!sealed || sealing) {
    return (
      <Section title="Modules">
        <Box color="bad">HARDSUIT SYSTEMS OFFLINE</Box>
      </Section>
    );
  }

  return (
    <Section title="Modules">
      <Box color="label" mb="0.2rem" fontSize={1.5}>
        Selected Primary: {capitalize(primarysystem || 'None')}
      </Box>
      {modules &&
        modules.map((module, i) => (
          <Section
            key={module.name}
            level={2}
            title={
              toTitleCase(module.name) + (module.damage ? ' (damaged)' : '')
            }
            buttons={
              <>
                {module.can_select ? (
                  <Button
                    selected={module.name === primarysystem}
                    icon="arrow-circle-right"
                    onClick={() =>
                      act('interact_module', {
                        module: module.index,
                        module_mode: 'select',
                      })
                    }
                  >
                    {module.name === primarysystem ? 'Selected' : 'Select'}
                  </Button>
                ) : null}
                {module.can_use ? (
                  <Button
                    icon="arrow-circle-down"
                    onClick={() =>
                      act('interact_module', {
                        module: module.index,
                        module_mode: 'engage',
                      })
                    }
                  >
                    {module.engagestring}
                  </Button>
                ) : null}
                {module.can_toggle ? (
                  <Button
                    selected={module.is_active}
                    icon="arrow-circle-down"
                    onClick={() =>
                      act('interact_module', {
                        module: module.index,
                        module_mode: 'toggle',
                      })
                    }
                  >
                    {module.is_active
                      ? module.deactivatestring
                      : module.activatestring}
                  </Button>
                ) : null}
              </>
            }
          >
            {module.damage >= 2 ? (
              <Box color="bad">-- MODULE DESTROYED --</Box>
            ) : (
              <Flex spacing={1}>
                <Flex.Item grow={1}>
                  <Box color="average">Engage: {module.engagecost}</Box>
                  <Box color="average">Active: {module.activecost}</Box>
                  <Box color="average">Passive: {module.passivecost}</Box>
                </Flex.Item>
                <Flex.Item grow={1}>{module.desc}</Flex.Item>
              </Flex>
            )}
            {module.charges ? (
              <Flex.Item>
                <Section title="Module Charges">
                  <LabeledList>
                    <LabeledList.Item label="Selected">
                      {capitalize(module.chargetype)}
                    </LabeledList.Item>
                    {module.charges.map((charge, i) => (
                      <LabeledList.Item
                        key={charge.caption}
                        label={capitalize(charge.caption)}
                      >
                        <Button
                          selected={module.realchargetype === charge.index}
                          icon="arrow-right"
                          onClick={() =>
                            act('interact_module', {
                              module: module.index,
                              module_mode: 'select_charge_type',
                              charge_type: charge.index,
                            })
                          }
                        />
                      </LabeledList.Item>
                    ))}
                  </LabeledList>
                </Section>
              </Flex.Item>
            ) : null}
          </Section>
        ))}
    </Section>
  );
};
