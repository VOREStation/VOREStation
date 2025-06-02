import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Image, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { resolveAsset } from '../assets';

type Data = {
  slots: slot[];
  specialSlots: slot[];
  internals: string;
  internalsValid: BooleanLike;
  sensors: BooleanLike;
  handcuffed: BooleanLike;
  handcuffedParams: { slot: number };
  legcuffed: BooleanLike;
  legcuffedParams: { slot: number };
  accessory: BooleanLike;
};

type slot = {
  name: string;
  item: string;
  icon: string;
  act: string;
  params: { slot: number };
};

type GridInfo = {
  gridRow: string;
  gridColumn: string;
};

type SlotInfo = {
  grid: GridInfo;
  image: string;
};

const gridAt = (row: number, col: number): GridInfo => {
  return { gridRow: `${row}`, gridColumn: `${col}` };
};

const KNOWN_SLOTS: Record<string, SlotInfo> = {
  // Row 1
  Glasses: {
    grid: gridAt(1, 2),
    image: 'inventory-glasses.png',
  },
  Hat: {
    grid: gridAt(1, 3),
    image: 'inventory-head.png',
  },
  'Left Ear': {
    grid: gridAt(1, 4),
    image: 'inventory-ears.png',
  },
  // Row 2
  Mask: {
    grid: gridAt(2, 3),
    image: 'inventory-mask.png',
  },
  'Right Ear': {
    grid: gridAt(2, 4),
    image: 'inventory-ears.png',
  },
  // Row 3
  Uniform: {
    grid: gridAt(3, 2),
    image: 'inventory-uniform.png',
  },
  Suit: {
    grid: gridAt(3, 3),
    image: 'inventory-suit.png',
  },
  Gloves: {
    grid: gridAt(3, 4),
    image: 'inventory-gloves.png',
  },
  'Left Hand': {
    grid: gridAt(3, 5),
    image: 'inventory-hand_l.png',
  },
  'Right Hand': {
    grid: gridAt(3, 6),
    image: 'inventory-hand_r.png',
  },
  // Row 4
  Shoes: {
    grid: gridAt(4, 3),
    image: 'inventory-shoes.png',
  },
  // Row 5
  ID: {
    grid: gridAt(5, 1),
    image: 'inventory-id.png',
  },
  'Suit Storage': {
    grid: gridAt(5, 2),
    image: 'inventory-suit_storage.png',
  },
  Belt: {
    grid: gridAt(5, 3),
    image: 'inventory-belt.png',
  },
  Back: {
    grid: gridAt(5, 4),
    image: 'inventory-back.png',
  },
};

const getSlot = (slot: slot): SlotInfo => {
  if (KNOWN_SLOTS[slot.name]) {
    return KNOWN_SLOTS[slot.name];
  }
  return {
    grid: gridAt(1, 1),
    image: 'inventory-pocket.png',
  };
};

export const SlotButton = (props: { slot: slot }) => {
  const { slot } = props;
  const { act } = useBackend();
  const data = getSlot(slot);

  return (
    <Button
      key={slot.name}
      style={{ ...data.grid }}
      width="64px"
      height="64px"
      position="relative"
      onClick={() => act(slot.act, slot.params)}
    >
      <Stack
        align="center"
        justify="center"
        position="absolute"
        top={0}
        left={0}
        right={0}
        bottom={0}
      >
        <Stack.Item>
          <Image
            fixErrors
            src={resolveAsset(data.image)}
            width="64px"
            height="64px"
          />
        </Stack.Item>
      </Stack>
      {slot.icon ? (
        <Stack
          align="center"
          justify="center"
          position="absolute"
          top={0}
          left={0}
          right={0}
          bottom={0}
        >
          <Stack.Item>
            <Image
              src={`data:image/jpeg;base64,${slot.icon}`}
              width="64px"
              height="64px"
            />
          </Stack.Item>
        </Stack>
      ) : null}
    </Button>
  );
};

export const InventoryPanelHuman = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    slots,
    specialSlots,
    internalsValid,
    sensors,
    handcuffed,
    handcuffedParams,
    legcuffed,
    legcuffedParams,
    accessory,
  } = data;

  return (
    <Window width={435} height={550}>
      <Window.Content scrollable>
        <Section>
          <Box
            style={{
              display: 'grid',
              gridTemplateColumns: '1fr 1fr 1fr 1fr 1fr 1fr',
              gridTemplateRows: '1fr 1fr 1fr 1fr 1fr',
            }}
            height="100%"
            width="100%"
          >
            {slots?.length
              ? slots.map((slot) => <SlotButton key={slot.name} slot={slot} />)
              : null}
            {specialSlots?.length
              ? specialSlots.map((slot) => (
                  <SlotButton key={slot.name} slot={slot} />
                ))
              : null}
          </Box>
        </Section>
        <Section title="Actions">
          <Button
            fluid
            icon="running"
            onClick={() => act('targetSlot', { slot: 'splints' })}
          >
            Remove Splints
          </Button>
          <Button
            fluid
            icon="hand-paper"
            onClick={() => act('targetSlot', { slot: 'pockets' })}
          >
            Empty Pockets
          </Button>
          <Button
            fluid
            icon="socks"
            onClick={() => act('targetSlot', { slot: 'underwear' })}
          >
            Remove or Replace Underwear
          </Button>
          {(internalsValid && (
            <Button
              fluid
              icon="lungs"
              onClick={() => act('targetSlot', { slot: 'internals' })}
            >
              Set Internals
            </Button>
          )) ||
            null}
          {(sensors && (
            <Button
              fluid
              icon="book-medical"
              onClick={() => act('targetSlot', { slot: 'sensors' })}
            >
              Set Sensors
            </Button>
          )) ||
            null}
          {(handcuffed && (
            <Button
              fluid
              color="bad"
              icon="unlink"
              onClick={() => act('targetSlot', handcuffedParams)}
            >
              Handcuffed
            </Button>
          )) ||
            null}
          {(legcuffed && (
            <Button
              fluid
              color="bad"
              icon="unlink"
              onClick={() => act('targetSlot', legcuffedParams)}
            >
              Legcuffed
            </Button>
          )) ||
            null}
          {(accessory && (
            <Button
              fluid
              color="bad"
              icon="unlink"
              onClick={() => act('targetSlot', { slot: 'tie' })}
            >
              Remove Accessory
            </Button>
          )) ||
            null}
        </Section>
      </Window.Content>
    </Window>
  );
};
