import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Stack } from 'tgui-core/components';

import {
  type GeneralData,
  type GeneralDataConstant,
  type GeneralDataStatic,
} from './data';

export const SubtabSettings = (props: {
  data: GeneralData;
  staticData: GeneralDataStatic;
  serverData: GeneralDataConstant;
}) => {
  const { act } = useBackend();
  const { data, staticData, serverData } = props;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <LabeledList>
          <LabeledList.Item label="Spawn Point">
            <Button onClick={() => act('spawnpoint')}>{data.spawnpoint}</Button>
          </LabeledList.Item>
        </LabeledList>
      </Stack.Item>
    </Stack>
  );
};
