import { useBackend } from '../../../backend';
import { Button, LabeledList } from '../../../components';
import { digestModeToColor } from '../constants';
import { selectedData } from '../types';

export const VoreSelectedBellyControls = (props: { belly: selectedData }) => {
  const { act } = useBackend();

  const { belly } = props;
  const { belly_name, mode, item_mode, addons } = belly;

  return (
    <LabeledList>
      <LabeledList.Item
        label="Name"
        buttons={
          <>
            <Button
              icon="arrow-up"
              tooltipPosition="left"
              tooltip="Move this belly tab up."
              onClick={() => act('move_belly', { dir: -1 })}
            />
            <Button
              icon="arrow-down"
              tooltipPosition="left"
              tooltip="Move this belly tab down."
              onClick={() => act('move_belly', { dir: 1 })}
            />
          </>
        }
      >
        <Button onClick={() => act('set_attribute', { attribute: 'b_name' })}>
          {belly_name}
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="Mode">
        <Button
          color={digestModeToColor[mode]}
          onClick={() => act('set_attribute', { attribute: 'b_mode' })}
        >
          {mode}
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="Mode Addons">
        {(addons.length && addons.join(', ')) || 'None'}
        <Button
          onClick={() => act('set_attribute', { attribute: 'b_addons' })}
          ml={1}
          icon="plus"
        />
      </LabeledList.Item>
      <LabeledList.Item label="Item Mode">
        <Button
          onClick={() => act('set_attribute', { attribute: 'b_item_mode' })}
        >
          {item_mode}
        </Button>
      </LabeledList.Item>
      <LabeledList.Item>
        <Button.Confirm
          fluid
          icon="exclamation-triangle"
          confirmIcon="trash"
          color="red"
          confirmContent="This is irreversable!"
          onClick={() => act('set_attribute', { attribute: 'b_del' })}
        >
          Delete Belly
        </Button.Confirm>
      </LabeledList.Item>
    </LabeledList>
  );
};
