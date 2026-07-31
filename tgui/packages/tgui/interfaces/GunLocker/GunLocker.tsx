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
  slots: SlotData[];
}

export type GunLockerStaticData = {
  icon_urls: Record<string, string>;
}

export const GunLocker = (props) => {
  const { act, data, staticData: rawStatic } = useBackend<GunLockerData>();
  const staticData = (rawStatic || {}) as GunLockerStaticData;
  const { welded = false, locked = false, slots = [] } = data;
  const { icon_urls = {} } = staticData;

  return (
    <>
      <Section title="Cabinet Controls">
        <Stack align="center" justify="space-between">
          <Stack.Item>
            <Box inline color={locked ? 'red' : 'green'} bold mr={2}>
              {locked ? 'LOCKED' : 'UNLOCKED'}
            </Box>
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
        {slots.map((slot) => {
          const iconUrl = slot.iconKey ? icon_urls[slot.iconKey] : null;
          const hasWeapon = Boolean(slot.ref);

          return (
            <Section key={slot.index} title={`Slot ${slot.index}`}>
              <Stack align="center">
                <Stack.Item>
                  <Box
                    width="36px"
                    height="36px"
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
                          maxWidth: '32px',
                          maxHeight: '32px',
                          objectFit: 'contain',
                        }}
                      />
                    ) : (
                      <Box color="label">—</Box>
                    )}
                  </Box>
                </Stack.Item>
                <Stack.Item grow>
                  <Box bold color={hasWeapon ? 'default' : 'label'}>
                    {slot.name}
                  </Box>
                  {hasWeapon && slot.maxCharge > 0 && (
                    <ProgressBar
                      value={slot.charge}
                      maxValue={slot.maxCharge}
                      color={slot.depleted ? 'red' : 'blue'}
                      mt={1}
                    >
                      {slot.charge} / {slot.maxCharge}
                    </ProgressBar>
                  )}
                </Stack.Item>
                <Stack.Item>
                  {hasWeapon ? (
                    <Button
                      icon="eject"
                      color="red"
                      disabled={locked || welded}
                      onClick={() => act('eject_slot', { slot_index: slot.index })}
                    >
                      Eject
                    </Button>
                  ) : (
                    <Button
                      icon="plus"
                      color="green"
                      disabled={locked || welded}
                      onClick={() => act('insert_slot', { slot_index: slot.index })}
                    >
                      Insert
                    </Button>
                  )}
                </Stack.Item>
              </Stack>
            </Section>
          );
        })}
      </Section>
    </>
  );
};
