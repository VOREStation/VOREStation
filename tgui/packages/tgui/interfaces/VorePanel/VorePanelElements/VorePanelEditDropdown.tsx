import { useBackend } from 'tgui/backend';
import { Box, Dropdown, Stack, Tooltip } from 'tgui-core/components';
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
  tooltip?: string;
}) => {
  const { act } = useBackend();

  const { entry, editMode, options, action, subAction, color, icon, tooltip } =
    props;

  return editMode ? (
    <Stack g={0.2}>
      <Stack.Item>
        <Dropdown
          color={color}
          onSelected={(value) =>
            act(action, { attribute: subAction, val: value })
          }
          options={options}
          selected={entry}
          icon={icon}
        />
      </Stack.Item>
      {tooltip && (
        <Stack.Item>
          <Tooltip content={tooltip}>
            <Box className="VorePanel__floatingButton">?</Box>
          </Tooltip>
        </Stack.Item>
      )}
    </Stack>
  ) : (
    <Box textColor={color}>{capitalize(entry)}</Box>
  );
};
