import { storage } from 'common/storage';
import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Input,
  LabeledList,
  NumberInput,
  Section,
  Stack,
} from 'tgui-core/components';
import { type BooleanLike } from 'tgui-core/react';

// These are straight from https://docs.pishock.com/multishock/multishock-websocket-api.html
type MultishockAPIShocker = {
  name: string;
  identifier: number;
};

type MultishockAPIDevice = {
  name: string;
  id: number;
  shockers: Array<MultishockAPIShocker>;
};

type MultishockAPIAvailableDevices = Array<MultishockAPIDevice>;

// KEEP THIS UP TO DATE WITH code/__defines/shock.dm
enum ShockFlags {
  BurnDamage = 1,
  Digestion = 2,
}

type Data = {
  port: number;
  authKey: string;
  connected: BooleanLike;
  intensity: number;
  duration: number;
  selectedDevice: number;
  availableDevices: MultishockAPIAvailableDevices;
  enabledFlags: ShockFlags;
};

export const ShockConfigurator = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    port,
    connected,
    intensity,
    duration,
    selectedDevice,
    availableDevices,
    enabledFlags,
  } = data;

  const [authKey, setAuthKey] = useState('');

  useEffect(() => {
    const async_get = async () => {
      setAuthKey(await storage.get('shocker-authkey'));
    };
    async_get();
  });

  return (
    <Window width={400} height={600}>
      <Window.Content>
        <Section title="Status">
          <Stack>
            <Stack.Item grow>
              {connected ? (
                <Box inline color="good">
                  Connected
                </Box>
              ) : (
                <Box inline color="bad">
                  Disconnected
                </Box>
              )}
            </Stack.Item>
            <Stack.Item>
              <Button onClick={() => act('connect')}>
                {connected ? 'Disconnect' : 'Connect'}
              </Button>
              <Button ml={1} onClick={() => act('estop')}>
                E-STOP
              </Button>
            </Stack.Item>
          </Stack>
          <LabeledList>
            <LabeledList.Item label="MultiShock Port">
              <NumberInput
                value={port}
                minValue={0}
                maxValue={25565}
                step={1}
                onChange={(val) => act('port', { port: val })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="MultiShock Auth Key">
              <Input
                value={authKey}
                onChange={(val) => {
                  storage.set('shocker-authkey', val);
                  setAuthKey(val);
                }}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Shock Intensity">
              <NumberInput
                value={intensity}
                minValue={0}
                maxValue={100}
                step={1}
                onChange={(val) => act('intensity', { intensity: val })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Shock Duration (Seconds)">
              <NumberInput
                value={duration}
                minValue={0}
                maxValue={15}
                step={0.1}
                onChange={(val) => act('duration', { duration: val })}
              />
            </LabeledList.Item>
          </LabeledList>
          <Button onClick={() => act('test')}>Test Shocker</Button>
          <Box color="bad">
            ETIQUITTE NOTE: You must let your partners know you&apos;re using
            this!
          </Box>
        </Section>
        <Section title="Shock Sources">
          <Box>
            This section indicates when you would like to be shocked. Note: Burn
            + Digestion is not recommended, as it will shock you twice per
            digest tick.
          </Box>
          <Button.Checkbox
            checked={enabledFlags & ShockFlags.BurnDamage}
            selected={enabledFlags & ShockFlags.BurnDamage}
            onClick={() => act('set_flag', { flag: ShockFlags.BurnDamage })}
          >
            Burn
          </Button.Checkbox>
          <Button.Checkbox
            checked={enabledFlags & ShockFlags.Digestion}
            selected={enabledFlags & ShockFlags.Digestion}
            onClick={() => act('set_flag', { flag: ShockFlags.Digestion })}
          >
            Digestion
          </Button.Checkbox>
        </Section>
        <Section
          title="Devices"
          buttons={
            <Button
              icon="refresh"
              tooltip="Refresh"
              onClick={() => act('request_devices')}
            />
          }
        >
          {availableDevices && availableDevices.length ? (
            availableDevices.map((device) => (
              <Box key={device.id}>
                <Box bold>
                  Device: {device.name} - {device.id}
                </Box>
                <Box>
                  {device.shockers.map((shocker) => (
                    <Box ml={4} key={shocker.identifier}>
                      Shocker: {shocker.name} - {shocker.identifier}
                      <Button.Checkbox
                        ml={1}
                        checked={shocker.identifier === selectedDevice}
                        selected={shocker.identifier === selectedDevice}
                        onClick={() => {
                          if (shocker.identifier !== selectedDevice) {
                            act('setSelectedDevice', {
                              device: shocker.identifier,
                            });
                          } else {
                            act('setSelectedDevice', {
                              device: -1,
                            });
                          }
                        }}
                      >
                        Use This Device
                      </Button.Checkbox>
                    </Box>
                  ))}
                </Box>
              </Box>
            ))
          ) : (
            <Box color="bad">No Devices Found</Box>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
