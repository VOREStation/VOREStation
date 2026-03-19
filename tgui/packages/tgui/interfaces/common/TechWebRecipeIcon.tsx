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
  const transformValue = match
    ? Math.max(parseInt(match[1], 10), parseInt(match[2], 10))
    : undefined;

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
          }}
        />
      </Box>
      <Box className="FabricatorRecipe__Label">{name}</Box>
    </Box>
  );
};
