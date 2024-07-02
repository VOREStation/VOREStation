import { useBackend } from '../../backend';
import { Box, Button, Icon, Input } from '../../components';
import { FullscreenNotice } from '../common/FullscreenNotice';
import { Data } from './types';

export const MessageMonitorLogin = (props) => {
  const { act, data } = useBackend<Data>();

  const { isMalfAI } = data;

  return (
    <FullscreenNotice title="Welcome">
      <Box fontSize="1.5rem" bold>
        <Icon
          name="exclamation-triangle"
          verticalAlign="middle"
          size={3}
          mr="1rem"
        />
        Unauthorized
      </Box>
      <Box color="label" my="1rem">
        Decryption Key:
        <Input
          placeholder="Decryption Key"
          ml="0.5rem"
          onChange={(e, val) => act('auth', { key: val })}
        />
      </Box>
      {!!isMalfAI && (
        <Button icon="terminal" onClick={() => act('hack')}>
          Hack
        </Button>
      )}
      <Box color="label">
        Please authenticate with the server in order to show additional options.
      </Box>
    </FullscreenNotice>
  );
};
