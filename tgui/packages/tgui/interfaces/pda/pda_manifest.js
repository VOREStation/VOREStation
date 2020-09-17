import { filter } from 'common/collections';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from "../../backend";
import { Box, Button, Flex, Icon, LabeledList, ProgressBar, Section } from "../../components";
import { IdentificationComputerCrewManifest } from '../IdentificationComputer';

export const pda_manifest = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Box color="white">
      <IdentificationComputerCrewManifest />
    </Box>
  );
};