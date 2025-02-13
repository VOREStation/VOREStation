import { useBackend } from 'tgui/backend';
import { NtosWindow } from 'tgui/layouts';
import { Box, Button, NoticeBox, Section } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { IdentificationComputerRegions } from './IdentificationComputer';

type Data = {
  message: string | null;
  running: BooleanLike;
  rate: number;
  factor: number;
  regions: string[];
};

export const NtosAccessDecrypter = (props) => {
  const { act, data } = useBackend<Data>();

  const { message, running, rate, factor, regions } = data;

  const generate10String = (length: number) => {
    let outString = '';
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

  return (
    <NtosWindow width={600} height={600} theme="syndicate">
      <NtosWindow.Content>
        {(message && <NoticeBox>{message}</NoticeBox>) ||
          (running && (
            <Section>
              Attempting to decrypt network access codes. Please wait. Rate:{' '}
              {rate} PHash/s
              <Box>
                {/* I don't care anymore */}
                {generate10String(lineLength)}
              </Box>
              <Box>{generate10String(lineLength)}</Box>
              <Box>{generate10String(lineLength)}</Box>
              <Box>{generate10String(lineLength)}</Box>
              <Box>{generate10String(lineLength)}</Box>
              <Button fluid icon="ban" onClick={() => act('PRG_reset')}>
                Abort
              </Button>
            </Section>
          )) || (
            <Section title="Pick access code to decrypt">
              {(regions.length && (
                <IdentificationComputerRegions actName="PRG_execute" />
              )) || <Box>Please insert ID card.</Box>}
            </Section>
          )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};
