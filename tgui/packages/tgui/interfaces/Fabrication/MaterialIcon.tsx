import { Icon } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

export type MaterialIconProps = {
  /**
   * The name of the material.
   */
  materialName: string;

  /**
   * The number of sheets of the material.
   */
  sheets?: number;
};

/**
 * A 32x32 material icon. Animates between different stack sizes of the given
 * material.
 */
export const MaterialIcon = (props: MaterialIconProps) => {
  const { materialName, sheets = 0 } = props;
  const icon_name = materialName;

  if (!icon_name) {
    return <Icon name="question-circle" />;
  }

  return (
    <div className={'FabricatorMaterialIcon'}>
      <div
        className={classes([
          'FabricatorMaterialIcon__Icon',
          'FabricatorMaterialIcon__Icon--active',
          'sheetmaterials_batched32x32',
          icon_name,
        ])}
      />
    </div>
  );
};
