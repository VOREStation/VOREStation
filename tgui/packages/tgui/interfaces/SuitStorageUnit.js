import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, Icon, LabeledList, Knob, NoticeBox, Section, Flex } from '../components';
import { Window } from '../layouts';

export const SuitStorageUnit = (props, context) => {
  const { act, data } = useBackend(context);
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
    <Window width={400} height={365} resizable>
      <Window.Content>{subTemplate}</Window.Content>
    </Window>
  );
};

const SuitStorageUnitContent = (props, context) => {
  const { act, data } = useBackend(context);
  const { locked, open, safeties, occupied, suit, helmet, mask } = data;

  return (
    <Section
      title="Storage"
      minHeight="260px"
      buttons={
        <Fragment>
          {!open && (
            <Button
              icon={locked ? 'unlock' : 'lock'}
              content={locked ? 'Unlock' : 'Lock'}
              onClick={() => act('lock')}
            />
          )}
          {!locked && (
            <Button
              icon={open ? 'sign-out-alt' : 'sign-in-alt'}
              content={open ? 'Close' : 'Open'}
              onClick={() => act('door')}
            />
          )}
        </Fragment>
      }>
      {!!(occupied && safeties) && (
        <NoticeBox>
          Biological entity detected in suit chamber. Please remove before
          continuing with operation.
          <Button
            fluid
            icon="eject"
            color="red"
            content="Eject Entity"
            onClick={() => act('eject_guy')}
          />
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
                content={helmet || 'Empty'}
                disabled={!helmet}
                onClick={() =>
                  act('dispense', {
                    item: 'helmet',
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="Suit">
              <Button
                icon={suit ? 'square' : 'square-o'}
                content={suit || 'Empty'}
                disabled={!suit}
                onClick={() =>
                  act('dispense', {
                    item: 'suit',
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="Mask">
              <Button
                icon={mask ? 'square' : 'square-o'}
                content={mask || 'Empty'}
                disabled={!mask}
                onClick={() =>
                  act('dispense', {
                    item: 'mask',
                  })
                }
              />
            </LabeledList.Item>
          </LabeledList>
        )) || (
          <Button
            fluid
            icon="recycle"
            content="Decontaminate"
            disabled={occupied && safeties}
            textAlign="center"
            onClick={() => act('uv')}
          />
        )}
    </Section>
  );
};

const SuitStorageUnitPanel = (props, context) => {
  const { act, data } = useBackend(context);
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
        <Flex mt={1} align="center" textAlign="center">
          <Flex.Item basis="50%" textAlign="center">
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
          </Flex.Item>
          <Flex.Item basis="50%" textAlign="center">
            <Icon name="biohazard" size={3} color="orange" />
          </Flex.Item>
        </Flex>
      </Box>
      <br />
      <Box>
        A thick old-style button, with 2 grimy LED lights next to it. The{' '}
        {safeties ? (
          <font color="green">GREEN</font>
        ) : (
          <font color="red">RED</font>
        )}{' '}
        LED is on.
        <Flex mt={1} align="center" textAlign="center">
          <Flex.Item basis="50%" textAlign="center">
            <Button
              fontSize="2rem"
              color="grey"
              inline
              icon="caret-square-right"
              style={{
                'border': '4px solid #777',
                'border-style': 'outset',
              }}
              onClick={() => act('togglesafeties')}
            />
          </Flex.Item>
          <Flex.Item basis="50%" textAlign="center">
            <Icon name="circle" color={safeties ? 'black' : 'red'} mr={2} />
            <Icon name="circle" color={safeties ? 'green' : 'black'} />
          </Flex.Item>
        </Flex>
      </Box>
    </Section>
  );
};

const SuitStorageUnitUV = (props, context) => {
  return (
    <NoticeBox>
      Contents are currently being decontaminated. Please wait.
    </NoticeBox>
  );
};

const SuitStorageUnitBroken = (props, context) => {
  return (
    <NoticeBox danger>
      Unit chamber is too contaminated to continue usage. Please call for a
      qualified individual to perform maintenance.
    </NoticeBox>
  );
};
