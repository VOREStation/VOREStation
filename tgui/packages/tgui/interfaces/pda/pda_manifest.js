import { filter } from 'common/collections';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from "../../backend";
import { Box, Button, Flex, Icon, LabeledList, ProgressBar, Section } from "../../components";
import { CrewManifestContent } from '../CrewManifest';

export const pda_manifest = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Box color="white">
      <CrewManifestContent />
    </Box>
  );
};