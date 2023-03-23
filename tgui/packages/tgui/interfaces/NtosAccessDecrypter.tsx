import { useBackend } from '../backend';
import { NtosWindow } from '../layouts';
import { IdentificationComputerRegions } from './IdentificationComputer';
import { NoticeBox, Box, Section, Button } from '../components';
import { BooleanLike } from 'common/react';

type Data = {
  message: string;
  running: BooleanLike;
  rate: number;
  factor: number;
  regions: [];
};

export const NtosAccessDecrypter = (props, context) => {
  const { act, data } = useBackend<Data>(context);

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
              Attempting to decrypt network access codes. Please wait. Rate: {rate} PHash/s
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
              {(regions.length && <IdentificationComputerRegions actName="PRG_execute" />) || (
                <Box>Please insert ID card.</Box>
              )}
            </Section>
          )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};
