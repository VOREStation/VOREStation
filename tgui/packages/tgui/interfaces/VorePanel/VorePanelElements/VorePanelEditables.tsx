import { useBackend } from 'tgui/backend';
import { Box, Button, Dropdown, Input } from 'tgui-core/components';

import type { checkBoxEntry, DropdownEntry } from '../types';

export const VorePanelEditText = (props: {
  editMode: boolean;
  limit: number;
  entry: string;
  action: string;
  subAction: string;
  color?: string;
}) => {
  const { act } = useBackend();

  const { entry, editMode, limit, action, subAction, color } = props;

  return editMode ? (
    <Input
      fluid
      maxLength={limit}
      value={entry}
      onBlur={(value) => act(action, { attribute: subAction, val: value })}
    />
  ) : (
    <Box textColor={color}>{entry}</Box>
  );
};

export const VorePanelEditDropdown = (props: {
  editMode: boolean;
  options: (string | DropdownEntry)[];
  entry: string;
  action: string;
  subAction: string;
  color?: string;
}) => {
  const { act } = useBackend();

  const { entry, editMode, options, action, subAction, color } = props;

  return editMode ? (
    <Dropdown
      color={color}
      onSelected={(value) => act(action, { attribute: subAction, val: value })}
      options={options}
      selected={entry}
    />
  ) : (
    <Box textColor={color}>{entry}</Box>
  );
};

export const VorePanelEditCheckboxes = (props: {
  editMode: boolean;
  options: checkBoxEntry[];
  action: string;
  subAction: string;
}) => {
  const { act } = useBackend();

  const { editMode, options, action, subAction } = props;

  return editMode ? (
    options.map((value) => (
      <Button.Checkbox
        key={value.label}
        checked={value.selection}
        onClick={() => act(action, { attribute: subAction, val: value.label })}
      >
        {value.label}
      </Button.Checkbox>
    ))
  ) : (
    <Box>
      {(options.length &&
        options
          .filter((option) => option.selection)
          .map((value) => value.label)
          .join(', ')) ||
        'None'}
    </Box>
  );
};
