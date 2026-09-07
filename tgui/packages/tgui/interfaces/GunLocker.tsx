import { useEffect, useState } from 'react';
import type { BooleanLike } from 'tgui-core/react';
import { Box, Button, Icon, Image, ProgressBar, Section, Stack } from 'tgui-core/components';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';

type SlotData = {
  index: number;
  ref: string | null;
  name: string;
  charge: number;
  maxCharge: number;
  depleted: BooleanLike;
};

type Data = {
  welded: BooleanLike;
  locked: BooleanLike;
  open: BooleanLike;
  max_gun_rows: number;
  slots_per_row: number;
  slots: SlotData[];
};

export const GunLocker = (props) => {
  const { act, data } = useBackend<Data>();
  const { welded, locked, open, slots = [], slots_per_row } = data;

  const rows: SlotData[][] = [];
  const chunkSize = slots_per_row > 0 ? slots_per_row : slots.length;
  for (let i = 0; i < slots.length; i += chunkSize) {
    rows.push(slots.slice(i, i + chunkSize));
  }

  return (
    <Window width={600} height={400}>
      <Window.Content>
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
                disabled={(welded || open)}
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

        <Section title="Weapon Rack" fill>
          <Box
            style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(auto-fill, minmax(140px, 1fr))',
              gap: '8px',
              alignItems: 'start',
            }}
          >
            {slots.map((slot) => {
              const hasWeapon = (slot.ref);

              return (
                <Section
                  key={slot.index}
                  title={`Slot ${slot.index}`}
                  mt={0}
                  style={{ marginTop: 0 }}
                >
                  <Stack vertical align="center">
                    <Stack.Item>
                      <Box
                        width="128px"
                        height="128px"
                        style={{
                          display: 'flex',
                          alignItems: 'center',
                          justifyContent: 'center',
                          backgroundColor: 'rgba(0, 0, 0, 0.25)',
                          borderRadius: '4px',
                          border: '1px solid rgba(255, 255, 255, 0.1)',
                        }}
                      >
                        {hasWeapon && slot.ref ? (
                          <AppearanceDisplay iconSrc={slot.ref} />
                        ) : (
                          <Box color="label">—</Box>
                        )}
                      </Box>
                    </Stack.Item>
                    <Stack.Item mt={1}>
                      <Box
                        bold
                        textAlign="center"
                        color={hasWeapon ? 'default' : 'label'}
                        style={{
                          whiteSpace: 'nowrap',
                          overflow: 'hidden',
                          textOverflow: 'ellipsis',
                          fontSize: '11px',
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
                    <Stack.Item mt={1}>
                      {hasWeapon ? (
                        <Button
                          icon="eject"
                          color="red"
                          disabled={!open}
                          onClick={() =>
                            act('eject_slot', { ref: slot.ref, slot_index: slot.index })
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
              );
            })}
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
/**
 * Waits until two XMLHttpRequests have loaded at iconSrc before calling cb().
 * @param iconSrc
 * @param cb
 */
function getTwice(iconSrc: string, cb: () => void) {
  const xhr = new XMLHttpRequest();
  // Block effect until we load
  xhr.open('GET', iconSrc + '?preload');
  xhr.send();
  xhr.onload = () => {
    const xhr = new XMLHttpRequest();
    // Block effect until we load
    xhr.open('GET', iconSrc + '?preload2');
    xhr.send();
    xhr.onload = cb;
  };
}

export const AppearanceDisplay = (props: { iconSrc: string }) => {
  const { iconSrc } = props;
  const [icon, setIcon] = useState<string>();

  // This forces two XMLHttpRequests to go through
  // before we try and render the icon for real.
  // Basically just makes sure BYOND knows we really want this icon instead of possibly getting back a transparent png.
  useEffect(() => {
    getTwice(iconSrc, () => {
      setIcon(iconSrc);
    });
  }, [iconSrc]);

  if (icon) {
    return (
      <Image fixErrors src={icon} ml={-1} mt={-1} height="96px" width="96px" />
    );
  } else {
    return <Icon name="spinner" size={2.2} spin color="gray" />;
  }
};
