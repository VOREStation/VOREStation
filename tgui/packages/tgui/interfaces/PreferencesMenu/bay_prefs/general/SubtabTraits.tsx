import { Stack } from 'tgui-core/components';

import { useBackend } from '../../../../backend';
import {
  type GeneralData,
  type GeneralDataConstant,
  type GeneralDataStatic,
} from './data';

export const SubtabTraits = (props: {
  data: GeneralData;
  staticData: GeneralDataStatic;
  serverData: GeneralDataConstant;
}) => {
  const { act } = useBackend();
  const { data, staticData, serverData } = props;

  return (
    <Stack vertical fill>
      <Stack.Item>Meow</Stack.Item>
    </Stack>
  );
};
