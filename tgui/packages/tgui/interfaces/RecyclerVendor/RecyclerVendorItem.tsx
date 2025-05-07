import { Box, Button } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

export const VendorItem = (props: {
  name: string;
  desc: string;
  advert: string;
  icon: string;
  cost: number;
  index: number;
  action: () => void;
}) => {
  const { name, desc, advert, icon, cost, index, action } = props;

  return (
    <Box className="RecyclerProductEntry">
      <Box className={classes(['MaintVendor32x32', icon])} />
      <Box>
        <Box className="RecyclerProductLabel">{name}</Box>
        <Box className="RecyclerProductDescription">{desc}</Box>
      </Box>
      <Box className="SplashBounce">{advert}</Box>
      <Box>
        <Button tooltip={`Purchase ${name}?`} onClick={() => action()}>
          Redeem - ♻️{cost}
        </Button>
      </Box>
    </Box>
  );
};
