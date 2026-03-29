import type { ComponentProps } from 'react';
import { Box, type Floating, Tooltip } from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import { MaterialCostSequence } from '../Fabrication/MaterialCostSequence';
import type { Design, MaterialMap } from '../Fabrication/Types';

export function buildIconData(icon: string): {
  width: number;
  height: number;
  transformValue?: number;
  offset: number;
} {
  const match = icon.match(/(\d+)x(\d+)/);
  const width = match ? parseInt(match[1], 10) : 32;
  const height = match ? parseInt(match[2], 10) : 32;
  const transformValue = match ? Math.max(width, height) : undefined;

  const offset = transformValue
    ? ((width - height) / 2) * (32 / transformValue)
    : 0;

  return {
    width: width,
    height: height,
    transformValue: transformValue,
    offset: offset,
  };
}
export const TechWebRecipeIcon = (props: {
  icon: string;
  name: string;
  design?: Design;
  availableMaterials?: MaterialMap;
  position?: ComponentProps<typeof Floating>['placement'];
  canPrint?: boolean;
  action?: () => void;
}) => {
  const { icon, name, position, design, availableMaterials, canPrint, action } =
    props;

  const { transformValue, offset } = buildIconData(icon);

  const iconContent = (
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
            margin: `${offset > 0 ? offset : 0}px ${offset < 0 ? -offset : 0}px`,
          }}
        />
      </Box>
      <Box className="FabricatorRecipe__Label">{name}</Box>
    </Box>
  );

  return availableMaterials && design ? (
    <Tooltip
      position={position}
      content={
        <MaterialCostSequence
          design={design}
          amount={1}
          available={availableMaterials}
        />
      }
    >
      {iconContent}
    </Tooltip>
  ) : (
    iconContent
  );
};
