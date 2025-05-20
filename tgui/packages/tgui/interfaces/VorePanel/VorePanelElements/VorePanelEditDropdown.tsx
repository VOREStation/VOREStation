import { useBackend } from 'tgui/backend';
import { Box, Dropdown } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import type { DropdownEntry } from '../types';

export const VorePanelEditDropdown = (props: {
  editMode: boolean;
  options: (string | DropdownEntry)[];
  entry: string;
  action: string;
  subAction: string;
  color?: string;
  icon?: string;
}) => {
  const { act } = useBackend();

  const { entry, editMode, options, action, subAction, color, icon } = props;

  return editMode ? (
    <Dropdown
      color={color}
      onSelected={(value) => act(action, { attribute: subAction, val: value })}
      options={options}
      selected={entry}
      icon={icon}
    />
  ) : (
    <Box textColor={color}>{capitalize(entry)}</Box>
  );
};
