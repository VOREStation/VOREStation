import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, LabeledList, Section } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  suffix: string;
  power: BooleanLike;
  load: string;
  locked: BooleanLike;
  issilicon: BooleanLike;
  auto_return: BooleanLike;
  crates_only: BooleanLike;
  hatch: BooleanLike;
  safety: BooleanLike;
};

export const MuleBot = (props) => {
  const { act, data } = useBackend<Data>();
  const { suffix, load, hatch } = data;
  return (
    <Window width={350} height={500}>
      <Window.Content>
        <Section title="Multiple Utility Load Effector Mk. III">
          <LabeledList>
            <LabeledList.Item label="ID">{suffix}</LabeledList.Item>
            <LabeledList.Item
              label="Current Load"
              buttons={
                <Button
                  icon="eject"
                  disabled={!load}
                  onClick={() => act('unload')}
                >
                  Unload Now
                </Button>
              }
            >
              {load ? load : 'None.'}
            </LabeledList.Item>
          </LabeledList>
          {hatch ? <MuleBotOpen /> : <MuleBotClosed />}
        </Section>
      </Window.Content>
    </Window>
  );
};

const MuleBotClosed = (props) => {
  const { act, data } = useBackend<Data>();
  const { power, locked, issilicon, auto_return, crates_only } = data;

  return (
    <Section
      title="Controls"
      buttons={
        <Button
          icon="power-off"
          selected={power}
          disabled={locked && !issilicon}
          onClick={() => act('power')}
        >
          {power ? 'On' : 'Off'}
        </Button>
      }
    >
      {locked && !issilicon ? (
        <Box color="bad">This interface is currently locked.</Box>
      ) : (
        <>
          <Button fluid icon="stop" onClick={() => act('stop')}>
            Stop
          </Button>
          <Button fluid icon="truck-monster" onClick={() => act('go')}>
            Proceed
          </Button>
          <Button fluid icon="home" onClick={() => act('home')}>
            Return Home
          </Button>
          <Button
            fluid
            icon="map-marker-alt"
            onClick={() => act('destination')}
          >
            Set Destination
          </Button>
          <Button fluid icon="cog" onClick={() => act('sethome')}>
            Set Home
          </Button>
          <Button
            fluid
            icon="home"
            selected={auto_return}
            onClick={() => act('autoret')}
          >
            {'Auto Return Home: ' + (auto_return ? 'Enabled' : 'Disabled')}
          </Button>
          <Button
            fluid
            icon="biking"
            selected={!crates_only}
            onClick={() => act('cargotypes')}
          >
            {'Non-standard Cargo: ' + (crates_only ? 'Disabled' : 'Enabled')}
          </Button>
        </>
      )}
    </Section>
  );
};

const MuleBotOpen = (props) => {
  const { act, data } = useBackend<Data>();
  const { safety } = data;

  return (
    <Section title="Maintenance Panel">
      <Button
        fluid
        icon="skull-crossbones"
        color={safety ? 'green' : 'red'}
        onClick={() => act('safety')}
      >
        {'Safety: ' + (safety ? 'Engaged' : 'Disengaged (DANGER)')}
      </Button>
    </Section>
  );
};
