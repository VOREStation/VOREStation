import { useBackend } from 'tgui/backend';
import { Button, NoticeBox, Stack } from 'tgui-core/components';

export const FunForYouTab = (props) => {
  const { act } = useBackend();
  return (
    <Stack fill vertical>
      <Stack.Item>
        <Stack>
          <Stack.Item>
            {/*
            <NoticeBox danger mb={0} width={19.6}>
              <Button
                color="red"
                icon="user-secret"
                fluid
                onClick={() => act('antag_all')}
              >
                Everyone is the antag
              </Button>
            </NoticeBox>
            */}
            <NoticeBox width={19.6} mb={0}>
              Your admin button here, coder!
            </NoticeBox>
          </Stack.Item>
          <Stack.Item>
            {/*
            <NoticeBox danger width={19.6} mb={0}>
              <Button
                color="red"
                icon="brain"
                fluid
                onClick={() => act('massbraindamage')}
              >
                Everyone gets brain damage
              </Button>
            </NoticeBox>
            */}
            <NoticeBox width={19.6} mb={0}>
              Your admin button here, coder!
            </NoticeBox>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack>
          <Stack.Item>
            {/*
            <NoticeBox danger mb={0} width={19.6}>
              <Button
                color="red"
                icon="hand-lizard"
                fluid
                onClick={() => act('allspecies')}
              >
                {"Change everyone's species"}
              </Button>
            </NoticeBox>
            */}
            <NoticeBox danger mb={0} width={19.6}>
              <Button
                color="red"
                icon="paw"
                fluid
                onClick={() => act('corgie')}
              >
                Change everyone to corgies
              </Button>
            </NoticeBox>
          </Stack.Item>
          <Stack.Item>
            <NoticeBox danger width={19.6} mb={0}>
              <Button
                color="red"
                icon="paw"
                fluid
                onClick={() => act('monkey')}
              >
                Change everyone to monkeys
              </Button>
            </NoticeBox>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        {/*
        <NoticeBox danger mb={0}>
          <Button
            color="black"
            icon="fire"
            fluid
            onClick={() => act('floorlava')}
          >
            The floor is lava! (DANGEROUS: extremely lame)
          </Button>
        </NoticeBox>
        */}
        <NoticeBox mb={0}>Your admin button here, coder!</NoticeBox>
      </Stack.Item>
      <Stack.Item>
        <NoticeBox danger mb={0}>
          {/*
          <Button color="black" icon="fire" fluid onClick={() => act('anime')}>
            Chinese Cartoons! (DANGEROUS: no going back, also fuck you)
          </Button>
          */}
          <Button
            color="black"
            icon="fire"
            fluid
            onClick={() => act('supermatter_cascade')}
          >
            Supermatter Cascade! (DANGEROUS: ends round, also big boom)
          </Button>
        </NoticeBox>
      </Stack.Item>
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            {/*
            <NoticeBox danger width={19.6} mb={0}>
              <Button
                color="red"
                icon="cat"
                fluid
                onClick={() => act('masspurrbation')}
              >
                Mass Purrbation
              </Button>
            </NoticeBox>
            */}
            <NoticeBox width={19.6} mb={0}>
              Your admin button here, coder!
            </NoticeBox>
          </Stack.Item>
          <Stack.Item>
            {/*
            <NoticeBox info width={19.6} mb={0}>
              <Button
                color="blue"
                icon="user"
                fluid
                onClick={() => act('massremovepurrbation')}
              >
                Cure Purrbation
              </Button>
            </NoticeBox>
            */}
            <NoticeBox width={19.6} mb={0}>
              Your admin button here, coder!
            </NoticeBox>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack>
          <Stack.Item>
            {/*
            <NoticeBox danger width={19.6} mb={0}>
              <Button
                color="red"
                icon="flushed"
                fluid
                onClick={() => act('massimmerse')}
              >
                Fully Immerse Everyone
              </Button>
            </NoticeBox>
            */}
            <NoticeBox width={19.6} mb={0}>
              Your admin button here, coder!
            </NoticeBox>
          </Stack.Item>
          <Stack.Item>
            {/*
            <NoticeBox info width={19.6} mb={0}>
              <Button
                color="blue"
                icon="sync-alt"
                fluid
                onClick={() => act('unmassimmerse')}
              >
                Shatter the Immersion
              </Button>
            </NoticeBox>
            */}
            <NoticeBox width={19.6} mb={0}>
              Your admin button here, coder!
            </NoticeBox>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        {/*
        <Stack fill>
          <Stack.Item>
            <NoticeBox danger width={19.6} mb={0}>
              <Button
                color="red"
                icon="comment-slash"
                fluid
                onClick={() => act('towerOfBabel')}
              >
                Tower of Babel
              </Button>
            </NoticeBox>
          </Stack.Item>
          <Stack.Item>
            <NoticeBox info width={19.6} mb={0}>
              <Button
                color="blue"
                icon="comment"
                fluid
                onClick={() => act('cureTowerOfBabel')}
              >
                Undo Tower of Babel
              </Button>
            </NoticeBox>
          </Stack.Item>
        </Stack>
        */}
        <Stack.Item>
          <NoticeBox danger mb={0}>
            <Button
              color="black"
              icon="fire"
              fluid
              onClick={() => act('summon_narsie')}
            >
              Summon Nar-Sie! (DANGEROUS: ends round)
            </Button>
          </NoticeBox>
        </Stack.Item>
      </Stack.Item>
      <Stack>
        <Stack.Item>
          <NoticeBox width={19.6} mb={0}>
            Your admin button here, coder!
          </NoticeBox>
        </Stack.Item>
        <Stack.Item>
          <NoticeBox width={19.6} mb={0}>
            Your admin button here, coder!
          </NoticeBox>
        </Stack.Item>
      </Stack>
    </Stack>
  );
};
