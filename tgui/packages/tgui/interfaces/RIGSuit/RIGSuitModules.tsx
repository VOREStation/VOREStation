import { capitalize, toTitleCase } from 'common/string';

import { useBackend } from '../../backend';
import { Box, Button, Flex, LabeledList, Section } from '../../components';
import { Data } from './types';

export const RIGSuitModules = (props) => {
  const { act, data } = useBackend<Data>();

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
            key={i}
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
                ) : (
                  ''
                )}
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
                ) : (
                  ''
                )}
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
                ) : (
                  ''
                )}
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
            ) : (
              ''
            )}
          </Section>
        ))}
    </Section>
  );
};
