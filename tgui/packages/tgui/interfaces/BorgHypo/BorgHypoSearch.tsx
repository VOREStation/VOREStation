import { useBackend } from 'tgui/backend';
import { TextArea } from 'tgui-core/components';
import type { Data } from './types';

export const BorgHypoSearch = (props) => {
  const { act, data } = useBackend<Data>();
  // Extract `health` and `color` variables from the `data` object.
  const { uiChemicalSearch, uiChemicalsName } = data;
  return (
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
  );
};
