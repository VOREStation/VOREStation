import { classes } from '../../.././common/react';
import { Box, Button, LabeledList } from '../../components';
import { modalOpen } from '.././common/ComplexModal';

export const ChemMasterProductionChemical = (props: {
  pillsprite: string;
  bottlesprite: string;
}) => {
  const { pillsprite, bottlesprite } = props;

  return (
    <LabeledList>
      <LabeledList.Item label="Pills">
        <Button
          icon="circle"
          mr="0.5rem"
          onClick={() => modalOpen('create_pill')}
        >
          One (60u max)
        </Button>
        <Button
          icon="plus-circle"
          mb="0.5rem"
          onClick={() => modalOpen('create_pill_multiple')}
        >
          Multiple
        </Button>
        <br />
        <Button onClick={() => modalOpen('change_pill_style')}>
          <div
            style={{
              display: 'inline-block',
              width: '16px',
              height: '16px',
              verticalAlign: 'middle',
              backgroundSize: '200%',
              backgroundPosition: 'left -10px bottom -6px',
            }}
          >
            <Box
              className={classes(['chem_master32x32', 'pill' + pillsprite])}
              style={{
                bottom: '10px',
                right: '10px',
                position: 'relative',
              }}
            />
          </div>
          Style
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="Patches">
        <Button
          icon="square"
          mr="0.5rem"
          onClick={() => modalOpen('create_patch')}
        >
          One (60u max)
        </Button>
        <Button
          icon="plus-square"
          onClick={() => modalOpen('create_patch_multiple')}
        >
          Multiple
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="Bottle">
        <Button
          icon="wine-bottle"
          mr="0.5rem"
          mb="0.5rem"
          onClick={() => modalOpen('create_bottle')}
        >
          Create bottle (60u max)
        </Button>
        <Button
          icon="plus-square"
          onClick={() => modalOpen('create_bottle_multiple')}
        >
          Multiple
        </Button>
        <br />
        <Button mb="0.5rem" onClick={() => modalOpen('change_bottle_style')}>
          <div
            style={{
              display: 'inline-block',
              width: '16px',
              height: '16px',
              verticalAlign: 'middle',
              backgroundSize: '200%',
              backgroundPosition: 'left -10px bottom -6px',
            }}
          >
            <Box
              className={classes([
                'chem_master32x32',
                'bottle-' + bottlesprite,
              ])}
              style={{
                bottom: '10px',
                right: '10px',
                position: 'relative',
              }}
            />
          </div>
          Style
        </Button>
      </LabeledList.Item>
    </LabeledList>
  );
};
