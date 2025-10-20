import { useBackend } from 'tgui/backend';
import { Input, Stack } from 'tgui-core/components';
import { BorgHypoRecordingBlinker } from './BorgHypoRecordingBlinker';
import type { Data } from './types';

export const BorgHypoSearch = (props) => {
  const { act, data } = useBackend<Data>();
  const { uiChemicalsName } = data;
  return (
    <Stack align="baseline">
      <BorgHypoRecordingBlinker />
      <Stack.Item>
        <Input
          width="150px"
          placeholder={`Search ${uiChemicalsName.toLowerCase()}...`}
          onChange={(input) =>
            act('set_chemical_search', {
              uiChemicalSearch: input,
            })
          }
        />
      </Stack.Item>
    </Stack>
  );
};
