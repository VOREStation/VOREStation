import { useBackend } from 'tgui/backend';
import { NtosWindow } from 'tgui/layouts';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  error: string;
  target: BooleanLike;
  speed: number;
  overload: number;
  capacity: number;
  relays: { id: number }[];
  focus: number | null;
};

export const NtosNetDos = () => {
  return (
    <NtosWindow width={400} height={250} theme="syndicate">
      <NtosWindow.Content>
        <NtosNetDosContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const NtosNetDosContent = (props) => {
  const { act, data } = useBackend<Data>();

  const { relays = [], focus, target, speed, overload, capacity, error } = data;

  if (error) {
    return (
      <>
        <NoticeBox>{error}</NoticeBox>
        <Button fluid textAlign="center" onClick={() => act('PRG_reset')}>
          Reset
        </Button>
      </>
    );
  }

  const generate10String = (length: number): string => {
    let outString = '';
    const factor = overload / capacity;
    while (outString.length < length) {
      if (Math.random() > factor) {
        outString += '0';
      } else {
        outString += '1';
      }
    }
    return outString;
  };

  const lineLength = 45;

  if (target) {
    return (
      <Section fontFamily="monospace" textAlign="center">
        <Box>CURRENT SPEED: {speed} GQ/s</Box>
        <Box>
          {/* I don't care anymore */}
          {generate10String(lineLength)}
        </Box>
        <Box>{generate10String(lineLength)}</Box>
        <Box>{generate10String(lineLength)}</Box>
        <Box>{generate10String(lineLength)}</Box>
        <Box>{generate10String(lineLength)}</Box>
      </Section>
    );
  }

  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Target">
          {relays.map((relay) => (
            <Button
              key={relay.id}
              selected={focus === relay.id}
              onClick={() =>
                act('PRG_target_relay', {
                  targid: relay.id,
                })
              }
            >
              {relay.id}
            </Button>
          ))}
        </LabeledList.Item>
      </LabeledList>
      <Button
        fluid
        bold
        color="bad"
        textAlign="center"
        disabled={!focus}
        mt={1}
        onClick={() => act('PRG_execute')}
      >
        EXECUTE
      </Button>
    </Section>
  );
};
