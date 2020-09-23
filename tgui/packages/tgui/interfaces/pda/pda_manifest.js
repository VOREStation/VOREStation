import { filter } from 'common/collections';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from "../../backend";
import { Box, Button, Flex, Icon, LabeledList, ProgressBar, Section } from "../../components";
<<<<<<< HEAD
import { CrewManifestContent } from '../CrewManifest';
=======
import { IdentificationComputerCrewManifest } from '../IdentificationComputer';
>>>>>>> 47878df... Merge pull request #7678 from ShadowLarkens/tgui_folder_update

export const pda_manifest = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Box color="white">
<<<<<<< HEAD
      <CrewManifestContent />
=======
      <IdentificationComputerCrewManifest />
>>>>>>> 47878df... Merge pull request #7678 from ShadowLarkens/tgui_folder_update
    </Box>
  );
};