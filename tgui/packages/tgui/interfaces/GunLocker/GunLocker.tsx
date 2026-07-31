import { Box, Button, ProgressBar, Section, Stack } from 'tgui-core/components';
import { useBackend } from 'tgui/backend';
import type { BooleanLike } from 'tgui-core/react';

export type SlotData = {
  index: number;
  ref: string | null;
  name: string;
  charge: number;
  maxCharge: number;
  depleted: BooleanLike;
  iconKey: string | null;
}

export type GunLockerData = {
  welded: BooleanLike;
  locked: BooleanLike;
  open: BooleanLike;
  max_gun_rows: number;
  slots_per_row: number;
  slots: SlotData[];
};

export type GunLockerStaticData = {
  icon_urls: Record<string, string>;
};

export const GunLocker = (props) => {
  const { act, data, staticData: rawStatic } = useBackend<GunLockerData>();
  const staticData = (rawStatic || {}) as GunLockerStaticData;
  const { welded = false, locked = false, slots = [], slots_per_row = 4 } = data;
  const { icon_urls = {} } = staticData;

  const rows: SlotData[][] = [];
  const chunkSize = slots_per_row > 0 ? slots_per_row : 4;
  for (let i = 0; i < slots.length; i += chunkSize) {
    rows.push(slots.slice(i, i + chunkSize));
  }

return (
    <>
      <Section title="Cabinet Controls">
        <Stack align="center" justify="space-between">
          <Stack.Item>
            <Box inline color={locked ? 'red' : 'green'} bold mr={2}>
              {locked ? 'LOCKED' : 'UNLOCKED'}
            </Box>
            {welded && (
              <Box inline color="yellow" bold>
                (ERROR: LOCK DAMAGED)
              </Box>
            )}
          </Stack.Item>
          <Stack.Item>
            <Button
              icon={locked ? 'lock' : 'lock-open'}
              color={locked ? 'red' : 'green'}
              disabled={welded}
              onClick={() => act('toggle_lock')}
            >
              {locked ? 'Unlock Cabinet' : 'Lock Cabinet'}
            </Button>
          </Stack.Item>
        </Stack>
      </Section>
      <Section title="Weapon Rack">
        <Stack vertical>
          {rows.map((rowSlots, rowIndex) => (
            <Stack.Item key={rowIndex} mb={1}>
              <Stack>
                {rowSlots.map((slot) => {
                  const iconUrl = slot.iconKey ? icon_urls[slot.iconKey] : null;
                  const hasWeapon = Boolean(slot.ref);

                  return (
                    <Stack.Item key={slot.index} grow basis={0} mx={0.5}>
                      <Section title={`Slot ${slot.index}`}>
                        <Stack vertical align="center">
                          {/* Sprite Frame */}
                          <Stack.Item>
                            <Box
                              width="42px"
                              height="42px"
                              style={{
                                display: 'flex',
                                alignItems: 'center',
                                justifyContent: 'center',
                                backgroundColor: 'rgba(0, 0, 0, 0.25)',
                                borderRadius: '4px',
                                border: '1px solid rgba(255, 255, 255, 0.1)',
                              }}
                            >
                              {iconUrl ? (
                                <img
                                  src={iconUrl}
                                  alt={slot.name}
                                  style={{
                                    maxWidth: '36px',
                                    maxHeight: '36px',
                                    objectFit: 'contain',
                                  }}
                                />
                              ) : (
                                <Box color="label">—</Box>
                              )}
                            </Box>
                          </Stack.Item>
                          <Stack.Item mt={1} style={{ width: '100%' }}>
                            <Box
                              bold
                              textAlign="center"
                              color={hasWeapon ? 'default' : 'label'}
                              style={{
                                whiteSpace: 'nowrap',
                                overflow: 'hidden',
                                textOverflow: 'ellipsis',
                              }}
                            >
                              {slot.name}
                            </Box>
                          </Stack.Item>
                          {hasWeapon && slot.maxCharge > 0 && (
                            <Stack.Item mt={1} style={{ width: '100%' }}>
                              <ProgressBar
                                value={slot.charge}
                                maxValue={slot.maxCharge}
                                color={slot.depleted ? 'red' : 'blue'}
                              >
                                {slot.charge}/{slot.maxCharge}
                              </ProgressBar>
                            </Stack.Item>
                          )}
                          <Stack.Item mt={1}>
                            {hasWeapon ? (
                              <Button
                                icon="eject"
                                color="red"
                                disabled={locked || welded}
                                onClick={() =>
                                  act('eject_slot', { slot_index: slot.index })
                                }
                              >
                                Eject
                              </Button>
                            ) : (
                              <Button
                                icon="plus"
                                color="green"
                                disabled={locked || welded}
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
            </Stack.Item>
          ))}
        </Stack>
      </Section>
    </>
  );
};
