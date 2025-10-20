import { useBackend } from 'tgui/backend';
import { Stack, TextArea } from 'tgui-core/components';
import { BorgHypoRecordingBlinker } from './BorgHypoRecordingBlinker';
import type { Data } from './types';

export const BorgHypoSearch = (props) => {
  const { act, data } = useBackend<Data>();
  const { uiChemicalsName } = data;
  return (
    <Stack>
      <Stack.Item basis="20%">
        <BorgHypoRecordingBlinker />
      </Stack.Item>
      <Stack.Item basis="80%">
        <TextArea
          placeholder={`Search ${uiChemicalsName.toLowerCase()}...`}
          fluid
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
