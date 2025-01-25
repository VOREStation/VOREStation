import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Icon,
  Knob,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

type Data = {
  broken: BooleanLike;
  panelopen: BooleanLike;
  locked: BooleanLike;
  open: BooleanLike;
  safeties: BooleanLike;
  uv_active: BooleanLike;
  uv_super: number;
  helmet: string | null;
  suit: string | null;
  mask: string | null;
  storage: null;
  occupied: BooleanLike;
};

export const SuitStorageUnit = (props) => {
  const { data } = useBackend<Data>();
  const { panelopen, uv_active, broken } = data;

  let subTemplate = <SuitStorageUnitContent />;

  if (panelopen) {
    subTemplate = <SuitStorageUnitPanel />;
  } else if (uv_active) {
    subTemplate = <SuitStorageUnitUV />;
  } else if (broken) {
    subTemplate = <SuitStorageUnitBroken />;
  }

  return (
    <Window width={430} height={370}>
      <Window.Content>{subTemplate}</Window.Content>
    </Window>
  );
};

const SuitStorageUnitContent = (props) => {
  const { act, data } = useBackend<Data>();
  const { locked, open, safeties, occupied, suit, helmet, mask } = data;

  return (
    <Section
      title="Storage"
      minHeight="260px"
      buttons={
        <>
          {!open && (
            <Button
              icon={locked ? 'unlock' : 'lock'}
              onClick={() => act('lock')}
            >
              {locked ? 'Unlock' : 'Lock'}
            </Button>
          )}
          {!locked && (
            <Button
              icon={open ? 'sign-out-alt' : 'sign-in-alt'}
              onClick={() => act('door')}
            >
              {open ? 'Close' : 'Open'}
            </Button>
          )}
        </>
      }
    >
      {!!(occupied && safeties) && (
        <NoticeBox>
          Biological entity detected in suit chamber. Please remove before
          continuing with operation.
          <Button
            fluid
            icon="eject"
            color="red"
            onClick={() => act('eject_guy')}
          >
            Eject Entity
          </Button>
        </NoticeBox>
      )}
      {(locked && (
        <Box mt={6} bold textAlign="center" fontSize="40px">
          <Box>Unit Locked</Box>
          <Icon name="lock" />
        </Box>
      )) ||
        (open && (
          <LabeledList>
            <LabeledList.Item label="Helmet">
              <Button
                icon={helmet ? 'square' : 'square-o'}
                disabled={!helmet}
                onClick={() =>
                  act('dispense', {
                    item: 'helmet',
                  })
                }
              >
                {helmet || 'Empty'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Suit">
              <Button
                icon={suit ? 'square' : 'square-o'}
                disabled={!suit}
                onClick={() =>
                  act('dispense', {
                    item: 'suit',
                  })
                }
              >
                {suit || 'Empty'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Mask">
              <Button
                icon={mask ? 'square' : 'square-o'}
                disabled={!mask}
                onClick={() =>
                  act('dispense', {
                    item: 'mask',
                  })
                }
              >
                {mask || 'Empty'}
              </Button>
            </LabeledList.Item>
          </LabeledList>
        )) || (
          <Button
            fluid
            icon="recycle"
            disabled={occupied && safeties}
            textAlign="center"
            onClick={() => act('uv')}
          >
            Decontaminate
          </Button>
        )}
    </Section>
  );
};

const SuitStorageUnitPanel = (props) => {
  const { act, data } = useBackend<Data>();
  const { safeties, uv_super } = data;

  return (
    <Section title="Maintenance Panel">
      <Box color="grey">
        The panel is ridden with controls, button and meters, labeled in strange
        signs and symbols that you cannot understand. Probably the manufactoring
        world&apos;s language. Among other things, a few controls catch your
        eye.
      </Box>
      <br />
      <Box>
        A small dial with a biohazard symbol next to it. It&apos;s pointing
        towards a gauge that reads {uv_super ? '15nm' : '185nm'}.
        <Stack mt={1} align="center" textAlign="center">
          <Stack.Item basis="50%" textAlign="center">
            <Knob
              size={2}
              inline
              value={uv_super}
              minValue={0}
              maxValue={1}
              step={1}
              stepPixelSize={40}
              color={uv_super ? 'red' : 'green'}
              format={(val) => (val ? '15nm' : '185nm')}
              onChange={(e, val) => act('toggleUV')}
            />
          </Stack.Item>
          <Stack.Item basis="50%" textAlign="center">
            <Icon name="biohazard" size={3} color="orange" />
          </Stack.Item>
        </Stack>
      </Box>
      <br />
      <Box>
        A thick old-style button, with 2 grimy LED lights next to it. The{' '}
        {safeties ? (
          <Box textColor="green">GREEN</Box>
        ) : (
          <Box textColor="red">RED</Box>
        )}{' '}
        LED is on.
        <Stack mt={1} align="center" textAlign="center">
          <Stack.Item basis="50%" textAlign="center">
            <Button
              fontSize="2rem"
              color="grey"
              inline
              icon="caret-square-right"
              style={{
                border: '4px solid #777',
                borderStyle: 'outset',
              }}
              onClick={() => act('togglesafeties')}
            />
          </Stack.Item>
          <Stack.Item basis="50%" textAlign="center">
            <Icon name="circle" color={safeties ? 'black' : 'red'} mr={2} />
            <Icon name="circle" color={safeties ? 'green' : 'black'} />
          </Stack.Item>
        </Stack>
      </Box>
    </Section>
  );
};

const SuitStorageUnitUV = (props) => {
  return (
    <NoticeBox>
      Contents are currently being decontaminated. Please wait.
    </NoticeBox>
  );
};

const SuitStorageUnitBroken = (props) => {
  return (
    <NoticeBox danger>
      Unit chamber is too contaminated to continue usage. Please call for a
      qualified individual to perform maintenance.
    </NoticeBox>
  );
};
