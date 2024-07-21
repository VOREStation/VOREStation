import { Box } from '../../components';
import { BodyScannerMainAbnormalities } from './BodyScannerMainAbnormalities';
import { BodyScannerMainDamage } from './BodyScannerMainDamage';
import { BodyScannerMainOccupant } from './BodyScannerMainOccupant';
import { BodyScannerMainOrgansExternal } from './BodyScannerMainOrgansExternal';
import { BodyScannerMainOrgansInternal } from './BodyScannerMainOrgansInternal';
import { BodyScannerMainReagents } from './BodyScannerMainReagents';
import { occupant } from './types';

export const BodyScannerMain = (props: { occupant: occupant }) => {
  const { occupant } = props;
  return (
    <Box>
      <BodyScannerMainOccupant occupant={occupant} />
      <BodyScannerMainReagents occupant={occupant} />
      <BodyScannerMainAbnormalities occupant={occupant} />
      <BodyScannerMainDamage occupant={occupant} />
      <BodyScannerMainOrgansExternal organs={occupant.extOrgan} />
      <BodyScannerMainOrgansInternal organs={occupant.intOrgan} />
    </Box>
  );
};
