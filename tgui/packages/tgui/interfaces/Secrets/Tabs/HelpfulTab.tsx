import { useBackend } from 'tgui/backend';
import { Button, NoticeBox, Stack } from 'tgui-core/components';

import { buttonWidthNormal, lineHeightNormal } from '../constants';

export const HelpfulTab = (props) => {
  const { act } = useBackend();
  return (
    <Stack fill vertical>
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            <NoticeBox
              mb={-0.5}
              width={buttonWidthNormal}
              height={lineHeightNormal}
            >
              Your admin button here, coder!
            </NoticeBox>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="plus"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('clear_virus')}
            >
              Cure all diseases
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="biohazard"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('virus')}
            >
              Trigger Outbreak
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            <Button
              icon="grin-beam-sweat"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('blackout')}
            >
              Break all lights
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="grin-beam-sweat"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('partial_blackout')}
            >
              Break some lights
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="magic"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('whiteout')}
            >
              Fix all lights
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            <Button
              icon="bomb"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('list_bombers')}
            >
              List Bombers
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="signal"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('list_signalers')}
            >
              List Signalers
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="robot"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('list_lawchanges')}
            >
              List laws
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            <Button
              icon="address-book"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('manifest')}
            >
              Show Manifest
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="dna"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('dna')}
            >
              Show DNA
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="fingerprint"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('fingerprints')}
            >
              Show Fingerprints
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            {/*
            <Button
              icon="flag"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('ctfbutton')}
            >
              Toggle CTF
            </Button>
            */}
            <NoticeBox
              mb={-0.5}
              width={buttonWidthNormal}
              height={lineHeightNormal}
            >
              Your admin button here, coder!
            </NoticeBox>
          </Stack.Item>
          <Stack.Item>
            {/*
            <Button
              icon="sync-alt"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('tdomereset')}
            >
              Reset Thunderdome
            </Button>
            */}
            <Button
              icon="handcuffs"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('prison_warp')}
            >
              Prison Warp
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="moon"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('night_shift_set')}
            >
              Set Nightshift
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack fill>
          {/*
          <Stack.Item>
            <Button
              icon="pencil-alt"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('set_name')}
            >
              Rename Station
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="eraser"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('reset_name')}
            >
              Default Station Name
            </Button>
          </Stack.Item>
          */}
          <Stack.Item>
            <Button
              icon="biohazard"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('trigger_xenomorph_infestation')}
            >
              Xenomorph Infest.
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="biohazard"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('trigger_cortical_borer_infestation')}
            >
              Cortical Borer Infest.
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="ferry"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('jump_shuttle')}
            >
              Jump Shuttle
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            <Button
              icon="ferry"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('launch_shuttle_forced')}
            >
              Force Shuttle Launch
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="ferry"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('launch_shuttle')}
            >
              Launch Shuttle
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="ferry"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('move_shuttle')}
            >
              Move Shuttle
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
