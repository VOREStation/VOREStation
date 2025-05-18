import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Dropdown,
  Floating,
  Input,
  Stack,
} from 'tgui-core/components';

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

  function doAct(value: string) {
    if (entry === value) return;
    act(action, { attribute: subAction, val: value });
  }

  return editMode ? (
    <Input fluid maxLength={limit} value={entry} onBlur={(value) => doAct} />
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

  return (
    <Stack>
      <Stack.Item grow>
        <Box>
          {(options.length &&
            options
              .filter((option) => option.selection)
              .map((value) => value.label)
              .join(', ')) ||
            'None'}
        </Box>
      </Stack.Item>
      <Stack.Item>
        {editMode && (
          <Floating
            placement="bottom-end"
            contentClasses="VorePanel__fLoating"
            content={
              <Stack vertical fill>
                {options.map((value) => (
                  <Stack.Item key={value.label}>
                    <Button.Checkbox
                      checked={value.selection}
                      onClick={() =>
                        act(action, {
                          attribute: subAction,
                          val: value.label,
                        })
                      }
                    >
                      {value.label}
                    </Button.Checkbox>
                  </Stack.Item>
                ))}
              </Stack>
            }
          >
            <Box backgroundColor="blue">+/-</Box>
          </Floating>
        )}
      </Stack.Item>
    </Stack>
  );
};
