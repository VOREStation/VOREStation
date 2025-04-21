import { Stack } from 'tgui-core/components';

import { useBackend } from '../../../../backend';
import { logger } from '../../../../logging';
import {
  type LoadoutData,
  type LoadoutDataConstant,
  type LoadoutDataStatic,
} from './data';

export const SubtabEquipment = (props: {
  data: LoadoutData;
  staticData: LoadoutDataStatic;
  serverData: LoadoutDataConstant;
}) => {
  const { act } = useBackend();
  const { data, staticData, serverData } = props;

  logger.log(data);

  return (
    <Stack fill vertical>
      {data.underwear.map((underwear) => (
        <Stack.Item key={underwear.category}>{underwear.category}</Stack.Item>
      ))}
    </Stack>
  );
};
