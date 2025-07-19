import { Stack } from 'tgui-core/components';
import { formatSiUnit } from 'tgui-core/format';

import { MaterialIcon } from './MaterialIcon';
import { type Design, type MaterialMap } from './Types';

export type MaterialCostSequenceProps = {
  /**
   * A map of available materials.
   */
  available?: MaterialMap;

  /**
   * If provided, the materials to be consumed. By default, generated from
   * `design`; otherwise, an empty list.
   */
  costMap?: MaterialMap;

  /**
   * A design to generate the cost map from.
   */
  design?: Design;

  /**
   * The amount of times the provided design will be printed. By default, one.
   */
  amount?: number;

  /**
   * The `align-items` flex property provided to the generated list.
   */
  align?: string;

  /**
   * The `justify-content` flex property provided to the generated list.
   */
  justify?: string;
};

/**
 * A horizontal list of material costs, with labels.
 *
 * For a given material set that can only be printed once, the label for
 * offending materials is orange.
 *
 * For a given material set that can't be printed at all, the label for
 * offending materials is red.
 *
 * Otherwise, the labels are white.
 */
export const MaterialCostSequence = (props: MaterialCostSequenceProps) => {
  const { design, amount, available, align, justify } = props;
  let { costMap } = props;

  if (!costMap && !design) {
    return null;
  }

  costMap ??= {};

  if (design) {
    for (const [name, value] of Object.entries(design.cost)) {
      costMap[name] = (costMap[name] || 0) + value;
    }
  }

  return (
    <Stack wrap justify={justify ?? 'space-around'} align={align ?? 'center'}>
      {Object.entries(costMap).map(([material, quantity]) => (
        <Stack.Item key={material} style={{ padding: '0.25em' }}>
          <Stack direction={'column'} align="center">
            <Stack.Item>
              <MaterialIcon materialName={material} />
            </Stack.Item>
            <Stack.Item
              style={
                available && {
                  color:
                    (amount || 1) * quantity * 2 <= available[material]
                      ? '#fff'
                      : (amount || 1) * quantity <= available[material]
                        ? '#f08f11'
                        : '#db2828',
                }
              }
            >
              {formatSiUnit((amount || 1) * quantity)}
            </Stack.Item>
          </Stack>
        </Stack.Item>
      ))}
    </Stack>
  );
};
