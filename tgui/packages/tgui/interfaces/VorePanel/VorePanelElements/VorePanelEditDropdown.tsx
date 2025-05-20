import { useBackend } from 'tgui/backend';
import { Box, Dropdown } from 'tgui-core/components';

import type { DropdownEntry } from '../types';

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
