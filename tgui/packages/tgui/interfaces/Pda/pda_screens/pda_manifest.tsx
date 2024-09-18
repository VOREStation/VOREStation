import { useBackend } from 'tgui/backend';
import { Box } from 'tgui/components';

import { CrewManifestContent } from '../../CrewManifest';

export const pda_manifest = (props) => {
  const { act, data } = useBackend();

  return (
    <Box color="white">
      <CrewManifestContent />
    </Box>
  );
};
