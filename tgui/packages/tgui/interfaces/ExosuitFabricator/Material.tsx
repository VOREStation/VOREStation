import { toFixed } from 'common/math';
import { classes } from 'common/react';
import { toTitleCase } from 'common/string';

import { useBackend, useSharedState } from '../../backend';
import {
  Box,
  Button,
  Flex,
  Icon,
  NumberInput,
  Tooltip,
} from '../../components';
import { formatMoney, formatSiUnit } from '../../format';
import { MATERIAL_KEYS } from './constants';
import { Data, material } from './types';

const EjectMaterial = (props: { material: material }) => {
  const { act } = useBackend();

  const { material } = props;

  const { name, removable, sheets } = material;

  const [removeMaterials, setRemoveMaterials] = useSharedState(
    'remove_mats_' + name,
    1,
  );

  if (removeMaterials > 1 && sheets < removeMaterials) {
    setRemoveMaterials(sheets || 1);
  }

  return (
    <>
      <NumberInput
        width="30px"
        animated
        value={removeMaterials}
        minValue={1}
        maxValue={sheets || 1}
        step={1}
        onDrag={(val) => {
          const newVal = val;
          if (Number.isInteger(newVal)) {
            setRemoveMaterials(newVal);
          }
        }}
      />
      <Button
        icon="eject"
        disabled={!removable}
        onClick={() =>
          act('remove_mat', {
            id: name,
            amount: removeMaterials,
          })
        }
      />
    </>
  );
};

export const Materials = (props: {
  displayAllMat?: boolean;
  disableEject?: boolean;
}) => {
  const { data } = useBackend<Data>();

  const { displayAllMat, disableEject = false } = props;

  const { materials = [] } = data;

  let display_materials = materials.filter(
    (mat) => displayAllMat || mat.amount > 0,
  );

  if (display_materials.length === 0) {
    return (
      <Box textAlign="center">
        <Icon textAlign="center" size={5} name="inbox" />
        <br />
        <b>No Materials Loaded.</b>
      </Box>
    );
  }

  return (
    <Flex wrap="wrap">
      {display_materials.map(
        (material) =>
          (
            <Flex.Item width="80px" key={material.name}>
              <MaterialAmount
                name={material.name}
                amount={material.amount}
                formatsi
              />
              {!disableEject && (
                <Box mt={1} style={{ textAlign: 'center' }}>
                  <EjectMaterial material={material} />
                </Box>
              )}
            </Flex.Item>
          ) || '',
      )}
    </Flex>
  );
};

export const MaterialAmount = (props: {
  name: string;
  amount: number;
  formatsi?: boolean;
  formatmoney?: boolean;
  color?: string;
  style?: {};
}) => {
  const { name, amount, formatsi, formatmoney, color, style } = props;

  let amountDisplay: string = '0';
  if (amount < 1 && amount > 0) {
    amountDisplay = toFixed(amount, 2);
  } else if (formatsi) {
    amountDisplay = formatSiUnit(amount, 0);
  } else if (formatmoney) {
    amountDisplay = formatMoney(amount);
  } else {
    amountDisplay = amount.toString();
  }

  return (
    <Flex direction="column" align="center">
      <Flex.Item>
        <Tooltip position="bottom" content={toTitleCase(name)}>
          <Box
            className={classes(['sheetmaterials32x32', MATERIAL_KEYS[name]])}
            position="relative"
            style={style}
          />
        </Tooltip>
      </Flex.Item>
      <Flex.Item>
        <Box textColor={color} style={{ textAlign: 'center' }}>
          {amountDisplay}
        </Box>
      </Flex.Item>
    </Flex>
  );
};
