import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Icon,
  Image,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';

// --- Type Definitions ---

export interface GunInfo {
  readonly name: string;
  readonly charge: number;
  readonly maxCharge: number;
  readonly depleted: boolean;
}

export interface GunLockerData {
  readonly welded: boolean;
  readonly locked: boolean;
  readonly emagged: boolean;
  readonly open: boolean;
  readonly rackslot1: string | null;
  readonly rackslot2: string | null;
  readonly rackslot3: string | null;
  readonly rackslot4: string | null;
  readonly icons: Record<string, string>;
  readonly guninfo: Record<string, GunInfo>;
}

export type SlotKey = 'rackslot1' | 'rackslot2' | 'rackslot3' | 'rackslot4';

export interface GunLockerProps {}

// --- Component ---

export const GunLocker = (_props: GunLockerProps) => {
  const { act, data } = useBackend<GunLockerData>();
  const { welded, locked, emagged, open, icons, guninfo } = data;

  /**
   * Helper to render a single rack slot card using Stack layout
   */
  const renderSlotCard = (slotKey: SlotKey, slotNumber: number) => {
    const gunName = data[slotKey];
    const info = guninfo?.[slotKey];
    const rawIcon = icons?.[slotKey];
    const isOccupied = Boolean(gunName);
    const isDepleted = info?.depleted ?? false;

    // Sanitize Base64 string formatting from DM
    const iconSrc =
      rawIcon && rawIcon.startsWith("'") && rawIcon.endsWith("'")
        ? rawIcon.substring(1, rawIcon.length - 1)
        : rawIcon;

    // Calculate charge percentage for ammo meter
    const chargeRatio =
      info && info.maxCharge > 0
        ? Math.min(1, Math.max(0, info.charge / info.maxCharge))
        : 0;

    return (
      <Box
        p={1}
        style={{
          border: isDepleted
            ? '1px solid rgba(235, 75, 75, 0.5)'
            : '1px solid rgba(255, 255, 255, 0.1)',
          borderRadius: '4px',
          backgroundColor: isDepleted
            ? 'rgba(60, 10, 10, 0.25)'
            : 'rgba(0, 0, 0, 0.2)',
          height: '100%',
        }}
      >
        <Stack
          vertical
          align="center"
          justify="space-between"
          style={{ height: '100%' }}
        >
          {/* Slot Header */}
          <Stack.Item style={{ width: '100%' }}>
            <Stack justify="space-between" align="center">
              <Stack.Item>
                <Box bold color="label">
                  Slot {slotNumber}
                </Box>
              </Stack.Item>
              {isDepleted && (
                <Stack.Item>
                  <Box color="bad" bold fontSize="0.75rem">
                    <Icon name="exclamation-triangle" mr={0.5} />
                    DEPLETED
                  </Box>
                </Stack.Item>
              )}
            </Stack>
          </Stack.Item>

          {/* Weapon Icon Preview */}
          <Stack.Item>
            <Box
              style={{
                width: '64px',
                height: '64px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                position: 'relative',
              }}
            >
              {iconSrc ? (
                <Image
                  src={iconSrc}
                  style={{
                    maxWidth: '64px',
                    maxHeight: '64px',
                    objectFit: 'contain',
                  }}
                />
              ) : (
                <Icon name="crosshairs" size={2} color="muted" />
              )}
            </Box>
          </Stack.Item>

          {/* Weapon Name & Ammo Bar */}
          <Stack.Item style={{ width: '100%' }}>
            <Box textAlign="center" minHeight="38px">
              {gunName ? (
                <>
                  <Box
                    bold
                    fontSize="0.85rem"
                    mb={0.5}
                    style={{
                      overflow: 'hidden',
                      textOverflow: 'ellipsis',
                      whiteSpace: 'nowrap',
                    }}
                  >
                    {gunName}
                  </Box>
                  {info && info.maxCharge > 0 ? (
                    <ProgressBar
                      value={chargeRatio}
                      color={
                        isDepleted
                          ? 'bad'
                          : chargeRatio < 0.3
                            ? 'warning'
                            : 'good'
                      }
                    >
                      {info.charge} / {info.maxCharge}
                    </ProgressBar>
                  ) : (
                    <Box fontSize="0.75rem" color={isDepleted ? 'bad' : 'good'}>
                      {isDepleted ? 'Empty' : 'Loaded'}
                    </Box>
                  )}
                </>
              ) : (
                <Box color="muted" italic mt={0.5}>
                  [ Empty Slot ]
                </Box>
              )}
            </Box>
          </Stack.Item>

          {/* Slot Interaction Button */}
          <Stack.Item style={{ width: '100%' }}>
            <Button
              fluid
              icon={isOccupied ? 'eject' : 'plus'}
              color={
                isOccupied ? (isDepleted ? 'danger' : 'warning') : 'default'
              }
              onClick={() => act(slotKey)}
            >
              {isOccupied ? 'Take' : 'Insert'}
            </Button>
          </Stack.Item>
        </Stack>
      </Box>
    );
  };

  return (
    <Window width={420} height={480} title="Armory Cabinet">
      <Window.Content>
        <Stack vertical fill>
          {/* Cabinet Controls Section */}
          <Stack.Item mb={1}>
            <Section title="Cabinet Controls">
              <LabeledList>
                <LabeledList.Item label="Door Status">
                  <Box inline color={open ? 'good' : 'danger'} bold>
                    {open ? 'OPEN' : 'CLOSED'}
                  </Box>
                  {welded && (
                    <Box inline color="bad" ml={1}>
                      (DOORS DAMAGED)
                    </Box>
                  )}
                </LabeledList.Item>
                <LabeledList.Item label="Lock Mechanism">
                  <Box inline color={emagged ? 'bad' : locked ? 'danger' : 'good'}>
                    {emagged ? 'HARDWARE FAULT' : locked ? 'LOCKED' : 'UNLOCKED'}
                  </Box>
                </LabeledList.Item>
              </LabeledList>

              <Box mt={2}>
                <Stack>
                  <Stack.Item grow mr={1}>
                    <Button
                      fluid
                      icon={open ? 'door-closed' : 'door-open'}
                      disabled={locked || welded}
                      color={open ? 'warning' : 'default'}
                      onClick={() => act('open')}
                    >
                      {open ? 'Close Doors' : 'Open Doors'}
                    </Button>
                  </Stack.Item>
                  <Stack.Item grow>
                    <Button
                      fluid
                      icon={locked ? 'unlock' : 'lock'}
                      disabled={open || emagged}
                      color={locked ? 'good' : 'danger'}
                      onClick={() => act('lock')}
                    >
                      {locked ? 'Unlock' : 'Lock'}
                    </Button>
                  </Stack.Item>
                </Stack>
              </Box>
            </Section>
          </Stack.Item>

          {/* Weapon Racks Section */}
          <Stack.Item grow>
            <Section title="Weapon Racks" fill>
              {!open ? (
                <Box color="muted" textAlign="center" mt={5}>
                  <Icon name="lock" size={3} mb={2} />
                  <br />
                  Doors are closed. Open locker to inspect arms.
                </Box>
              ) : (
                <Stack vertical fill>
                  {/* Row 1: Slots 1 & 2 */}
                  <Stack.Item grow mb={1}>
                    <Stack fill>
                      <Stack.Item grow width="50%" mr={1}>
                        {renderSlotCard('rackslot1', 1)}
                      </Stack.Item>
                      <Stack.Item grow width="50%">
                        {renderSlotCard('rackslot2', 2)}
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>

                  {/* Row 2: Slots 3 & 4 */}
                  <Stack.Item grow>
                    <Stack fill>
                      <Stack.Item grow width="50%" mr={1}>
                        {renderSlotCard('rackslot3', 3)}
                      </Stack.Item>
                      <Stack.Item grow width="50%">
                        {renderSlotCard('rackslot4', 4)}
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                </Stack>
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
