import { useBackend } from 'tgui/backend';
import { Input, Stack } from 'tgui-core/components';
import { BorgHypoRecordingBlinker } from './BorgHypoRecordingBlinker';
import type { Data } from './types';

export const BorgHypoSearch = (props) => {
  const { act, data } = useBackend<Data>();
  const { isDispensingDrinks } = data;
  const uiChemicalsName = isDispensingDrinks ? 'drinks' : 'chemicals';
  return (
    <Stack align="baseline">
      <BorgHypoRecordingBlinker />
      <Stack.Item>
        <Input
          width="150px"
          placeholder={`Search ${uiChemicalsName}...`}
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
