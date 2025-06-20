import { useBackend } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';

import { buttonWidthNormal, lineHeightNormal } from '../constants';

export const FunTab = (props) => {
  const { act } = useBackend();
  return (
    <Stack fill vertical>
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            <Button
              icon="robot"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('makeNerd')}
            >
              Make N.E.R.D.
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="flag"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('ctf_instagib')}
            >
              CTF Instagib Mode
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
            <Button
              icon="user-ninja"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('anon_name')}
            >
              Anonymous Names
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
            <Button
              icon="grin-beam-sweat"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('guns')}
            >
              Summon Guns
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="magic"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('magic')}
            >
              Summon Magic
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="meteor"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('events')}
            >
              Summon Events
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            <Button
              icon="hammer"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('eagles')}
            >
              Egalitarian Station
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="dollar-sign"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('ancap')}
            >
              Ancap Station
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="house"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('send_shuttle_back')}
            >
              Send Shuttle Back
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            <Button
              icon="bullseye"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('customportal')}
            >
              Custom Portal Storm
            </Button>
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
            <Button
              icon="dollar-sign"
              lineHeight={lineHeightNormal}
              width={buttonWidthNormal}
              onClick={() => act('department_cooldown_override')}
            >
              Dpt Order Cooldown
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
