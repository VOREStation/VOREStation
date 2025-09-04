import { sortBy } from 'es-toolkit';
import { useState } from 'react';
import { AnimatedNumber, Button, Stack } from 'tgui-core/components';
import { formatSiUnit } from 'tgui-core/format';
import { classes } from 'tgui-core/react';
import { toTitleCase } from 'tgui-core/string';
import { MaterialIcon } from '../Fabrication/MaterialIcon';
import type { Material } from '../Fabrication/Types';

// by popular demand of discord people (who are always right and never wrong)
// this is completely made up
const MATERIAL_RARITY: Record<string, number> = {
  steel: 0,
  glass: 1,
  silver: 2,
  graphite: 3,
  plasteel: 4,
  durasteel: 5,
  verdantium: 6,
  morphium: 7,
  mhydrogen: 8,
  gold: 9,
  diamond: 10,
  supermatter: 11,
  osmium: 12,
  phoron: 13,
  uranium: 14,
  titanium: 15,
  lead: 16,
  platinum: 17,
  plastic: 18,
};

export type MaterialAccessBarProps = {
  /**
   * All materials currently available to the user.
   */
  availableMaterials: Material[];

  /**
   * Definition of how much units 1 sheet has.
   */
  SHEET_MATERIAL_AMOUNT: number;

  /**
   * Invoked when the user requests that a material be ejected.
   */
  onEjectRequested?: (material: Material, quantity: number) => void;
};

/**
 * The formatting function applied to the quantity labels in the bar.
 */
const LABEL_FORMAT = (value: number) => formatSiUnit(value, 0);

export const MaterialAccessBar = (props: MaterialAccessBarProps) => {
  const { availableMaterials, SHEET_MATERIAL_AMOUNT, onEjectRequested } = props;

  return (
    <Stack wrap>
      {sortBy(availableMaterials, [(m: Material) => MATERIAL_RARITY[m.name]])
        .filter((material) => material.amount > 0)
        .map((material) => (
          <Stack.Item grow basis={4.5} key={material.ref}>
            <MaterialCounter
              material={material}
              SHEET_MATERIAL_AMOUNT={SHEET_MATERIAL_AMOUNT}
              onEjectRequested={(quantity) =>
                onEjectRequested?.(material, quantity)
              }
            />
          </Stack.Item>
        ))}
    </Stack>
  );
};

type MaterialCounterProps = {
  material: Material;
  SHEET_MATERIAL_AMOUNT: number;
  onEjectRequested: (quantity: number) => void;
};

const MaterialCounter = (props: MaterialCounterProps) => {
  const { material, onEjectRequested, SHEET_MATERIAL_AMOUNT } = props;

  const [hovering, setHovering] = useState(false);
  const sheets = material.amount / SHEET_MATERIAL_AMOUNT;

  return (
    <div
      onMouseEnter={() => setHovering(true)}
      onMouseLeave={() => setHovering(false)}
      className={classes([
        'MaterialDock',
        hovering && 'MaterialDock--active',
        sheets < 1 && 'MaterialDock--disabled',
      ])}
    >
      <Stack vertical>
        <Stack.Item>
          <Stack
            vertical
            className="MaterialDock__Label"
            textAlign="center"
            onClick={() => onEjectRequested(1)}
          >
            <Stack.Item>
              <MaterialIcon materialName={material.name} sheets={sheets} />
            </Stack.Item>
            <Stack.Item>
              <AnimatedNumber value={sheets} format={LABEL_FORMAT} />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        {hovering && (
          <Stack.Item className="MaterialDock__Dock">
            <Stack vertical>
              <Stack.Item>
                <EjectButton
                  sheets={sheets}
                  amount={50}
                  onEject={onEjectRequested}
                />
              </Stack.Item>
              <Stack.Item>
                <EjectButton
                  sheets={sheets}
                  amount={25}
                  onEject={onEjectRequested}
                />
              </Stack.Item>
              <Stack.Item>
                <EjectButton
                  sheets={sheets}
                  amount={10}
                  onEject={onEjectRequested}
                />
              </Stack.Item>
              <Stack.Item>
                <EjectButton
                  sheets={sheets}
                  amount={5}
                  onEject={onEjectRequested}
                />
              </Stack.Item>
              <Stack.Item>{toTitleCase(material.name)}</Stack.Item>
            </Stack>
          </Stack.Item>
        )}
      </Stack>
    </div>
  );
};

type EjectButtonProps = {
  amount: number;
  sheets: number;
  onEject: (quantity: number) => void;
};

const EjectButton = (props: EjectButtonProps) => {
  const { amount, sheets, onEject } = props;

  return (
    <Button
      fluid
      color={'transparent'}
      className={classes([
        'Fabricator__PrintAmount',
        amount > sheets && 'Fabricator__PrintAmount--disabled',
      ])}
      onClick={() => onEject(amount)}
    >
      &times;{amount}
    </Button>
  );
};
