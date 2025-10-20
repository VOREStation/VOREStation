import { useBackend } from 'tgui/backend';
import { Stack, TextArea } from 'tgui-core/components';
import { BorgHypoRecordingBlinker } from './BorgHypoRecordingBlinker';
import type { Data } from './types';

export const BorgHypoSearch = (props) => {
  const { act, data } = useBackend<Data>();
  // Extract `health` and `color` variables from the `data` object.
  const { uiChemicalsName } = data;
  return (
    <Stack direction="row" align="flex-start" g={0.3} height="20x">
      <Stack.Item basis="20%" grow>
        <BorgHypoRecordingBlinker />
      </Stack.Item>
      <Stack.Item basis="80%" grow>
        <TextArea
          placeholder={`Search ${uiChemicalsName.toLowerCase()}...`}
          fluid
          height="20px"
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
