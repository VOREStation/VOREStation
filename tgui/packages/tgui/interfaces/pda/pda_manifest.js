import { useBackend } from '../../backend';
import { Box } from '../../components';
import { CrewManifestContent } from '../CrewManifest';

export const pda_manifest = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Box color="white">
      <CrewManifestContent />
    </Box>
  );
};
