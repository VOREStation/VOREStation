import { useBackend } from 'tgui/backend';
import { Input, LabeledList } from 'tgui-core/components';
import type { Data } from '../types';

export const ConfigField = (props) => {
  const { act, data } = useBackend<Data>();
  const { matrixcolors } = data;

  return (
    <LabeledList>
      <LabeledList.Item label="Config">
        <Input
          fluid
          value={Object.values(matrixcolors).toString()}
          onBlur={(value: string) => act('set_matrix_string', { value })}
        />
      </LabeledList.Item>
    </LabeledList>
  );
};
