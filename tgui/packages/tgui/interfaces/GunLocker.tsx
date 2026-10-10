import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  DmIcon,
  Icon,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type SlotData = {
  index: number;
  ref: string | null;
  icon: string | null;
  state: string | null;
  name: string;
  charge: number;
  maxCharge: number;
  depleted: BooleanLike;
};

type Data = {
  welded: BooleanLike;
  locked: BooleanLike;
  open: BooleanLike;
  slots: SlotData[];
};

export const GunLocker = (props) => {
  const { act, data } = useBackend<Data>();
  const { welded, locked, open, slots = [] } = data;

  return (
    <Window width={635} height={400}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section title="Cabinet Controls">
              <Stack align="center" justify="space-between">
                <Stack.Item>
                  <Box inline color={locked ? 'red' : 'green'} bold mr={2}>
                    {locked ? 'LOCKED' : 'UNLOCKED'}
                  </Box>
                  <Box inline color={welded ? 'yellow' : 'transparent'} bold>
                    {welded ? 'ERROR: LOCK DAMAGED' : ''}
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon={locked ? 'lock' : 'lock-open'}
                    color={locked ? 'red' : 'green'}
                    disabled={welded || open}
                    onClick={() => act('toggle_lock')}
                  >
                    {locked ? 'Unlock Cabinet' : 'Lock Cabinet'}
                  </Button>
                  <Button
                    icon={open ? 'door-open' : 'door-closed'}
                    color={open ? 'green' : 'red'}
                    onClick={() => act('open')}
                  >
                    {open ? 'Close Door' : 'Open Door'}
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Section title="Weapon Rack" fill>
              <Stack fill g={5}>
                {slots.map((slot) => {
                  const hasWeapon = slot.icon;

                  return (
                    <Stack.Item key={slot.index}>
                      <Section fill title={`Slot ${slot.index}`}>
                        <Stack g={1.5} vertical align="center">
                          <Stack.Item>
                            <Box
                              width="128px"
                              height="128px"
                              backgroundColor="rgba(0, 0, 0, 0.25)"
                              style={{
                                display: 'flex',
                                alignItems: 'center',
                                justifyContent: 'center',
                                borderRadius: '4px',
                                border: '1px solid rgba(255, 255, 255, 0.1)',
                              }}
                            >
                              {hasWeapon && slot.icon && slot.state ? (
                                <AppearanceDisplay
                                  icon={slot.icon}
                                  state={slot.state}
                                />
                              ) : (
                                <Box color="label">—</Box>
                              )}
                            </Box>
                          </Stack.Item>
                          <Stack.Item>
                            <Box
                              bold
                              textAlign="center"
                              color={hasWeapon ? 'default' : 'label'}
                              nowrap
                              overflow="hidden"
                              fontSize="11px"
                              style={{
                                textOverflow: 'ellipsis',
                              }}
                            >
                              {slot.name}
                            </Box>
                          </Stack.Item>
                          {hasWeapon && slot.maxCharge > 0 && (
                            <Stack.Item mt={0.5}>
                              <ProgressBar
                                value={slot.charge}
                                maxValue={slot.maxCharge}
                                color={slot.depleted ? 'red' : 'blue'}
                              >
                                {slot.charge}/{slot.maxCharge}
                              </ProgressBar>
                            </Stack.Item>
                          )}
                          <Stack.Item>
                            {hasWeapon ? (
                              <Button
                                icon="eject"
                                color="red"
                                disabled={!open}
                                onClick={() =>
                                  act('eject_slot', {
                                    ref: slot.ref,
                                    slot_index: slot.index,
                                  })
                                }
                              >
                                Eject
                              </Button>
                            ) : (
                              <Button
                                icon="plus"
                                color="green"
                                disabled={!open}
                                onClick={() =>
                                  act('insert_slot', { slot_index: slot.index })
                                }
                              >
                                Insert
                              </Button>
                            )}
                          </Stack.Item>
                        </Stack>
                      </Section>
                    </Stack.Item>
                  );
                })}
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

export const AppearanceDisplay = (props: { icon: string; state: string }) => {
  const { icon, state } = props;

  if (icon) {
    return (
      <DmIcon
        icon={icon}
        icon_state={state}
        ml={-1}
        mt={-1}
        height="96px"
        width="96px"
      />
    );
  } else {
    return <Icon name="spinner" size={2.2} spin color="gray" />;
  }
};
