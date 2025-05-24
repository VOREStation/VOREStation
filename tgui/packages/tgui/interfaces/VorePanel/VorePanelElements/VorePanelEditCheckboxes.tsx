import { useBackend } from 'tgui/backend';
import { Box, Button, Floating, Stack } from 'tgui-core/components';

import type { checkBoxEntry } from '../types';

export const VorePanelEditCheckboxes = (props: {
  editMode: boolean;
  options: checkBoxEntry[];
  action: string;
  subAction: string;
  tooltipList?: Record<string, string>;
}) => {
  const { act } = useBackend();

  const { editMode, options, action, subAction, tooltipList } = props;

  return (
    <Stack>
      {editMode && (
        <Stack.Item>
          <Floating
            placement="bottom-end"
            contentClasses="VorePanel__fLoating"
            content={
              <Stack vertical fill>
                {options.map((value) => (
                  <Stack.Item key={value.label}>
                    <Button.Checkbox
                      tooltip={tooltipList && tooltipList[value.label]}
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
            <Box className="VorePanel__floatingButton">+/-</Box>
          </Floating>
        </Stack.Item>
      )}
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
    </Stack>
  );
};
