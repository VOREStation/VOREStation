import { useBackend } from 'tgui/backend';

import { Box } from '../../../components';
import { Target } from '../types';

export const ModifyRobotModules = (props: { target: Target }) => {
  const { target } = props;
  const { act } = useBackend();

  return <Box />;
};
