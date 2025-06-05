import { useBackend } from 'tgui/backend';
import { Box, Button, Stack } from 'tgui-core/components';
import { type BooleanLike } from 'tgui-core/react';

export const VorePanelColorBox = (props: {
  back_color: string;
  pixelSize?: number;
  alpha?: number;
}) => {
  const { back_color, pixelSize = 20, alpha = 255 } = props;

  const parentSize = pixelSize + 'px';
  const childSize = pixelSize - 4 + 'px';

  return (
    <Box
      style={{
        border: '2px solid white',
      }}
      width={parentSize}
      height={parentSize}
    >
      <Box
        backgroundColor={
          back_color.startsWith('#') ? back_color : `#${back_color}`
        }
        style={{
          opacity: alpha / 255,
        }}
        width={childSize}
        height={childSize}
      />
    </Box>
  );
};

export const VorePanelEditToggle = (props: {
  editMode: boolean;
  persistEditMode: BooleanLike;
  toggleEditMode: React.Dispatch<React.SetStateAction<boolean>>;
}) => {
  const { act } = useBackend();
  const { editMode, persistEditMode, toggleEditMode } = props;

  return (
    <Stack>
      <Stack.Item>
        <Button
          icon="pencil"
          selected={editMode}
          tooltip={(editMode ? 'Dis' : 'En') + 'able edit mode.'}
          onClick={() => toggleEditMode(!editMode)}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          icon={persistEditMode ? 'lock-open' : 'lock'}
          selected={persistEditMode}
          tooltip={
            (persistEditMode ? 'Dis' : 'En') +
            'able edit mode active on window opening.'
          }
          onClick={() => act('toggle_editmode_persistence')}
        />
      </Stack.Item>
    </Stack>
  );
};
