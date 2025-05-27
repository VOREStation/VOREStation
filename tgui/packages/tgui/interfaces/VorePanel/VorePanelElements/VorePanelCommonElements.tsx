import { Box, Button } from 'tgui-core/components';

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
  toggleEditMode: React.Dispatch<React.SetStateAction<boolean>>;
}) => {
  const { editMode, toggleEditMode } = props;

  return (
    <Button
      icon="pencil"
      color={editMode ? 'green' : undefined}
      tooltip={(editMode ? 'Dis' : 'En') + 'able edit mode'}
      onClick={() => toggleEditMode(!editMode)}
    />
  );
};
