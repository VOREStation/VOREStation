import { Box } from 'tgui-core/components';

import {
  type LoadoutData,
  type LoadoutDataConstant,
  type LoadoutDataStatic,
} from './data';

export const Loadout = (props: {
  data: LoadoutData;
  staticData: LoadoutDataStatic;
  serverData: LoadoutDataConstant;
}) => {
  const { data, staticData, serverData } = props;

  return (
    <LoadoutContent
      data={data}
      staticData={staticData}
      serverData={serverData}
    />
  );
};

export const LoadoutContent = (props: {
  data: LoadoutData;
  staticData: LoadoutDataStatic;
  serverData: LoadoutDataConstant;
}) => {
  const { data, staticData, serverData } = props;

  return <Box>Meow</Box>;
};
