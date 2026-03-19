import { Box } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

export const TechWebRecipeIcon = (props: {
  icon: string;
  name: string;
  canPrint?: boolean;
  action?: () => void;
}) => {
  const { icon, name, canPrint, action } = props;

  const match = icon.match(/(\d+)x(\d+)/);
  const width = match ? parseInt(match[1], 10) : 32;
  const height = match ? parseInt(match[2], 10) : 32;
  const transformValue = match ? Math.max(width, height) : undefined;

  const offset = transformValue
    ? ((width - height) / 2) * (32 / transformValue)
    : 0;

  return (
    <Box
      className={classes([
        'FabricatorRecipe__Title',
        !canPrint && 'FabricatorRecipe__Title--disabled',
      ])}
      onClick={() => {
        if (canPrint && action) {
          action();
        }
      }}
    >
      <Box className="FabricatorRecipe__Icon">
        <Box
          className={icon.startsWith('design') ? icon : `design32x32 ${icon}`}
          style={{
            transform: transformValue
              ? `scale(${32 / transformValue},${32 / transformValue})`
              : undefined,
            transformOrigin: 'top left',
            margin: `${offset < 0 ? -offset : 0}px ${offset > 0 ? offset : 0}px`,
          }}
        />
      </Box>
      <Box className="FabricatorRecipe__Label">{name}</Box>
    </Box>
  );
};
