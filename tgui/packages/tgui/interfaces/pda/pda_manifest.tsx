import { useBackend } from '../../backend';
import { Box } from '../../components';
import { CrewManifestContent } from '../CrewManifest';

export const pda_manifest = (props) => {
  const { act, data } = useBackend();

  return (
    <Box color="white">
      <CrewManifestContent />
    </Box>
  );
};
