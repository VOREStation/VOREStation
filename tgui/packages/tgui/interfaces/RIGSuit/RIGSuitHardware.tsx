import { useBackend } from 'tgui/backend';
import {
  Box,
  DmIcon,
  Icon,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { type BooleanLike } from 'tgui-core/react';
import { capitalize } from 'tgui-core/string';

import type { Data } from './types';

export const RIGSuitHardware = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    sealed,
    aioverride,
    cooling,
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
      <Stack fill align="center" justify="space-around">
        <Stack.Item grow>
          <Stack align="center" justify="center">
            <Stack.Item>
              <Box
                className="RIGSuit__FadeIn"
                style={{
                  display: 'grid',
                  gridTemplateColumns: '1fr 1fr',
                  gap: '10px',
                  width: 'fit-content',
                }}
                textColor="#fff"
              >
                <HardwarePiece
                  disabled={sealing}
                  icon="head"
                  name={helmet}
                  selected={helmetDeployed}
                  onClick={() => act('toggle_piece', { piece: 'helmet' })}
                />
                <HardwarePiece
                  disabled={sealing}
                  icon="body"
                  name={chest}
                  selected={chestDeployed}
                  onClick={() => act('toggle_piece', { piece: 'chest' })}
                />
                <HardwarePiece
                  disabled={sealing}
                  icon="gloves"
                  name={gauntlets}
                  selected={gauntletsDeployed}
                  onClick={() => act('toggle_piece', { piece: 'gauntlets' })}
                />
                <HardwarePiece
                  disabled={sealing}
                  icon="boots"
                  name={boots}
                  selected={bootsDeployed}
                  onClick={() => act('toggle_piece', { piece: 'boots' })}
                />
              </Box>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item
          style={{
            borderLeft: '2px solid #246984',
            borderRight: '2px solid #246984',
          }}
          height={15}
          width={0}
        >
          &nbsp;
        </Stack.Item>
        <Stack.Item grow>
          <Stack fill align="center" justify="center">
            <Stack.Item>
              <Box
                className="RIGSuit__FadeIn"
                style={{
                  display: 'grid',
                  gridTemplateColumns: '1fr 1fr',
                  gap: '10px',
                  width: 'fit-content',
                }}
              >
                <Tooltip
                  content={
                    'Suit Seals: ' + sealing
                      ? 'Sealing'
                      : sealed
                        ? 'Sealed'
                        : 'UNSEALED'
                  }
                >
                  <Box
                    position="relative"
                    className="RIGSuit__Icon"
                    style={{
                      filter: sealing
                        ? 'grayscale(100%) brightness(0.5)'
                        : sealed
                          ? undefined
                          : 'grayscale(80%)',
                    }}
                    onClick={() => act('toggle_seals')}
                  >
                    <DmIcon
                      height={6}
                      width={6}
                      icon="icons/hud/rig_ui_slots.dmi"
                      icon_state="base"
                    />
                    <Box position="absolute" top={0.5} left={0.5}>
                      <Icon name="power-off" size={5} color="#5c9fd8" />
                    </Box>
                  </Box>
                </Tooltip>

                <Tooltip
                  content={
                    aioverride
                      ? 'Toggle AI Control Off'
                      : 'Toggle AI Control On'
                  }
                >
                  <Box
                    position="relative"
                    className="RIGSuit__Icon"
                    style={{
                      filter: aioverride ? undefined : 'grayscale(80%)',
                    }}
                    onClick={() => act('toggle_ai_control')}
                  >
                    <DmIcon
                      height={6}
                      width={6}
                      icon="icons/hud/rig_ui_slots.dmi"
                      icon_state="base"
                    />
                    <Box position="absolute" top={0.7} left={0.5}>
                      <Icon name="robot" size={4} color="#5c9fd8" />
                    </Box>
                  </Box>
                </Tooltip>

                <Tooltip content={cooling ? 'Cooling: On' : 'Cooling: Off'}>
                  <Box
                    position="relative"
                    className="RIGSuit__Icon"
                    style={{
                      filter: cooling ? undefined : 'grayscale(80%)',
                    }}
                    onClick={() => act('toggle_cooling')}
                  >
                    <DmIcon
                      height={6}
                      width={6}
                      icon="icons/hud/rig_ui_slots.dmi"
                      icon_state="base"
                    />
                    <Box position="absolute" top={1} left={1}>
                      <Icon name="wind" size={4} color="#5c9fd8" />
                    </Box>
                  </Box>
                </Tooltip>

                <Tooltip content="Tank Settings">
                  <Box
                    position="relative"
                    className="RIGSuit__Icon"
                    onClick={() => act('tank_settings')}
                  >
                    <DmIcon
                      height={6}
                      width={6}
                      icon="icons/hud/rig_ui_slots.dmi"
                      icon_state="base"
                    />
                    <Box position="absolute" top={1} left={0.5}>
                      <Icon name="lungs" size={4} color="#5c9fd8" />
                    </Box>
                  </Box>
                </Tooltip>
              </Box>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const HardwarePiece = (props: {
  name: string;
  icon: string;
  selected: BooleanLike;
  disabled: BooleanLike;
  onClick: () => void;
}) => {
  let filter;
  if (props.disabled) {
    filter = 'grayscale(100%) brightness(0.5)';
  } else if (props.selected) {
    filter = undefined;
  } else {
    filter = 'grayscale(80%)';
  }

  return (
    <Tooltip content={capitalize(props.name) || 'ERROR'}>
      <Box className="RIGSuit__Icon">
        <DmIcon
          height={6}
          width={6}
          icon="icons/hud/rig_ui_slots.dmi"
          icon_state={props.icon}
          style={{
            cursor: 'pointer',
            filter,
          }}
          onClick={props.onClick}
        />
      </Box>
    </Tooltip>
  );
};
