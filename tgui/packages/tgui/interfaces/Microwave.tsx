import { resolveAsset } from 'tgui/assets';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  DmIcon,
  Icon,
  Image,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { classes } from 'tgui-core/react';

import { AnimatedArrows } from './common/AnimatedArrows';

type Item = {
  name: string;
  amt: number;
  extra: string;
  icon: { icon: string; icon_state: string };
};

type Reagent = {
  name: string;
  amt: number;
  extra: string;
  color: string;
};

type Data = {
  broken: BooleanLike;
  operating: BooleanLike;
  dirty: BooleanLike;
  items: Item[];
  reagents: Reagent[];
  recipe: string | null;
  recipe_name: string | null;
};

export const Microwave = (props) => {
  const { config, data } = useBackend<Data>();

  const { broken, operating, dirty, items } = data;

  let inner;

  const first_item = items[0] || null;

  if (broken) {
    inner = (
      <Section fill>
        <Stack vertical fill align="center" justify="center">
          <Stack.Item>
            <Box color="bad" fontSize={6}>
              Bzzzzttttt!!
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Stack align="center" justify="space-around">
              <Stack.Item>
                <Icon name="fire" color="orange" size={10} />
              </Stack.Item>
              <Stack.Item>
                <Icon name="fire" color="orange" size={10} />
              </Stack.Item>
              <Stack.Item>
                <Icon name="fire" color="orange" size={10} />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Section>
    );
  } else if (operating) {
    inner = (
      <Section fill>
        <Stack fill vertical align="center" justify="center">
          <Stack.Item>
            <Box position="relative" className="Microwave__Hover">
              <Image src={resolveAsset('microwave.png')} />
              {first_item ? (
                <Box
                  position="absolute"
                  className="Microwave__Hover"
                  left={8}
                  top={10}
                >
                  <DmIcon
                    icon={first_item.icon.icon}
                    icon_state={first_item.icon.icon_state}
                    width="64px"
                    height="64px"
                  />
                </Box>
              ) : null}
              <Image
                position="absolute"
                left={0}
                top={0}
                src={resolveAsset('microwave.gif')}
              />
            </Box>
          </Stack.Item>
        </Stack>
      </Section>
    );
  } else if (dirty) {
    inner = (
      <Section fill textAlign="center">
        <Stack fill vertical align="center" justify="center" fontSize={2}>
          <Stack.Item>
            <Box color="bad">
              This microwave is dirty!
              <br />
              Please clean it before use!
            </Box>
          </Stack.Item>
        </Stack>
      </Section>
    );
  } else if (items.length) {
    inner = <MicrowaveContents />;
  } else {
    inner = (
      <Section fill>
        <Stack fill align="center" justify="center">
          <Stack.Item>
            <Box color="bad" fontSize={2}>
              {config.title} is empty.
            </Box>
          </Stack.Item>
        </Stack>
      </Section>
    );
  }

  return (
    <Window width={520} height={300}>
      <Window.Content>{inner}</Window.Content>
    </Window>
  );
};

const MicrowaveContents = (props) => {
  const { act, data } = useBackend<Data>();

  const { items, reagents, recipe, recipe_name } = data;

  return (
    <Section
      fill
      title="Ingredients"
      scrollable
      buttons={
        <Stack>
          <Stack.Item>
            <Button icon="radiation" onClick={() => act('cook')}>
              Microwave
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button icon="eject" onClick={() => act('dispose')}>
              Eject
            </Button>
          </Stack.Item>
        </Stack>
      }
    >
      <Stack fill align="center">
        <Stack.Item basis="70%">
          <Box>
            {items.map((item) => (
              <Tooltip
                content={item.name + ' - ' + item.amt + ' ' + item.extra}
                position="top"
                key={item.name}
              >
                <Box
                  backgroundColor="black"
                  height="64px"
                  width="64px"
                  position="relative"
                  m={1}
                  style={{ border: '1px solid #4444ab', float: 'left' }}
                >
                  <Box position="absolute" top={0} right={0}>
                    x{item.amt}
                  </Box>
                  <DmIcon
                    icon={item.icon?.icon}
                    icon_state={item.icon?.icon_state}
                    width="64px"
                    height="64px"
                  />
                </Box>
              </Tooltip>
            ))}
            {reagents.map((r) => (
              <Tooltip
                content={`${r.name} - ${r.amt} ${r.extra}`}
                key={r.name}
                position="top"
              >
                <Box
                  backgroundColor="black"
                  height="64px"
                  width="64px"
                  position="relative"
                  m={1}
                  style={{ border: '1px solid #4444ab', float: 'left' }}
                >
                  <Box position="absolute" top={0} right={0}>
                    {r.amt}
                  </Box>
                  {/* To be clear: This is fucking cursed
                      We're directly loading the rectangular glass and
                      manually colorizing a div that's set to be the right shape */}
                  <Box
                    position="absolute"
                    left="24px"
                    top="26px"
                    width="16px"
                    height="20px"
                    backgroundColor={r.color}
                  />
                  <DmIcon
                    position="absolute"
                    width="64px"
                    height="64px"
                    icon="icons/pdrink.dmi"
                    icon_state="square"
                  />
                </Box>
              </Tooltip>
            ))}
          </Box>
        </Stack.Item>
        <Stack.Item basis="10%">
          <AnimatedArrows on inline />
        </Stack.Item>
        <Stack.Item>
          <Tooltip
            content={'Predicted Result - ' + (recipe_name || 'Burned Mess')}
            position="top"
          >
            <Box
              inline
              backgroundColor="black"
              height="64px"
              width="64px"
              position="relative"
              style={{ border: '1px solid #4444ab' }}
            >
              {recipe ? (
                <Box
                  ml="16px"
                  mt="16px"
                  className={classes(['kitchen_recipes32x32', recipe])}
                  style={{
                    transform: 'scale(3)',
                    imageRendering: 'pixelated',
                  }}
                />
              ) : (
                <DmIcon
                  icon="icons/obj/food.dmi"
                  icon_state="badrecipe"
                  width="64px"
                  height="64px"
                />
              )}
            </Box>
          </Tooltip>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
