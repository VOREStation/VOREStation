import { useBackend } from 'tgui/backend';
import { Button, NoticeBox, Stack } from 'tgui-core/components';

import { buttonWidthNormal, lineHeightNormal } from '../constants';

export const FunTab = (props) => {
  const { act } = useBackend();
  return (
    <Stack fill vertical>
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            {/*
            <Button
              icon="robot"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('makeNerd')}
            >
              Make N.E.R.D.
            </Button>
            */}
            <Button
              icon="ghost"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('ghost_mode')}
            >
              Ghost Mode
            </Button>
          </Stack.Item>
          <Stack.Item>
            {/*
            <Button
              icon="flag"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('ctf_instagib')}
            >
              CTF Instagib Mode
            </Button>
            */}
            <Button
              icon="palette"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('paintball_mode')}
            >
              Paintball Mode
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="plus"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('mass_heal')}
            >
              Mass Heal everyone
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            <Button
              icon="bolt"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('power')}
            >
              All areas powered
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="moon"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('unpower')}
            >
              All areas unpowered
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="plug"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('quickpower')}
            >
              recharge SMESs
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            {/*
            <Button
              icon="user-ninja"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('anon_name')}
            >
              Anonymous Names
            </Button>
            */}
            <Button
              icon="power-off"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('gravity')}
            >
              Toggle Station Gravity
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="robot"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('tripleAI')}
            >
              Triple AI mode
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="bullhorn"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('onlyone')}
            >
              THERE CAN ONLY BE-
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            {/*
            <Button
              icon="grin-beam-sweat"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('guns')}
            >
              Summon Guns
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
              icon="magic"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('magic')}
            >
              Summon Magic
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
              icon="meteor"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('events')}
            >
              Summon Events
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
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            {/*
            <Button
              icon="hammer"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('eagles')}
            >
              Egalitarian Station
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
              icon="dollar-sign"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('ancap')}
            >
              Ancap Station
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
              icon="house"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('send_shuttle_back')}
            >
              Send Shuttle Back
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
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            {/*
            <Button
              icon="bullseye"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('customportal')}
            >
              Custom Portal Storm
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
            <Button
              icon="bomb"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('changebombcap')}
            >
              Change Bomb Cap
            </Button>
          </Stack.Item>
          <Stack.Item>
            {/*
            <Button
              icon="dollar-sign"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('department_cooldown_override')}
            >
              Dpt Order Cooldown
            </Button>
            */}
            <Button
              icon="pencil"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('alter_narsie')}
            >
              Alter Nar-Sie
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            <Button
              icon="shirt"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('remove_all_clothing')}
            >
              Remove ALL Clothing
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="shirt"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('remove_internal_clothing')}
            >
              Rem. &apos;internal&apos; Cloth.
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="person-rifle"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('send_strike_team')}
            >
              Send Strike Team
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
