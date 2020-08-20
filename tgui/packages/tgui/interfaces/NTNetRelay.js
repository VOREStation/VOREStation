import { useBackend } from "../backend";
import { Button, Box, Icon, Flex, LabeledList, Section } from "../components";
import { Window } from "../layouts";
import { FullscreenNotice } from './common/FullscreenNotice';

export const NTNetRelay = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    dos_crashed,
    enabled,
    dos_overload,
    dos_capacity,
  } = data;

  let body = <NTNetRelayContent />;
  
  if (dos_crashed) {
    body = <NTNetRelayCrash />;
  }

  return (
    <Window
      width={dos_crashed ? 700 : 500}
      height={dos_crashed ? 600 : 300}
      resizable>
      <Window.Content scrollable>
        {body}
      </Window.Content>
    </Window>
  );
};

const NTNetRelayContent = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    dos_crashed,
    enabled,
    dos_overload,
    dos_capacity,
  } = data;

  return (
    <Section
      title="Status"
      buttons={
        <Button
          icon="power-off"
          selected={enabled}
          content={"Relay " + (enabled ? "On" : "Off")}
          onClick={() => act("toggle")} />
      }>
      <LabeledList>
        <LabeledList.Item label="Network Buffer Status">
          {dos_overload} / {dos_capacity} GQ
        </LabeledList.Item>
        <LabeledList.Item label="Options">
          <Button
            icon="exclamation-triangle"
            content="Purge network blacklist"
            onClick={() => act("purge")} />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const NTNetRelayCrash = (props, context) => {
  const { act, data } = useBackend(context);
  
  return (
    <FullscreenNotice title="ERROR">
      <Box fontSize="1.5rem" bold color="bad">
        <Icon
          name="exclamation-triangle"
          verticalAlign="middle"
          size={3}
          mr="1rem"
        />
        <h2>NETWORK BUFFERS OVERLOADED</h2>
        <h3>Overload Recovery Mode</h3>
        <i>
          This system is suffering temporary outage due to overflow of traffic buffers.
          Until buffered traffic is processed, all further requests will be dropped.
          Frequent occurences of this error may indicate insufficient hardware capacity of your network.
          Please contact your network planning department for instructions on how to resolve this issue.
        </i>
        <h3>ADMINISTRATIVE OVERRIDE</h3>
        <b> CAUTION - Data loss may occur </b>
      </Box>
      <Box>
        <Button
          icon="exclamation-triangle"
          content="Purge buffered traffic"
          onClick={() => act("restart")} />
      </Box>
    </FullscreenNotice>
  );
};