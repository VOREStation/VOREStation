import { useBackend } from 'tgui/backend';
import { Box, LabeledList, ProgressBar, Section } from 'tgui-core/components';
import type { Data } from '../types';

/** Displays the current Cartridge status. */
export const SynthCartGuage = (props) => {
  const { data } = useBackend<Data>();
  const { isThereCart, cartFillStatus = 0 } = data;
  const adjustedCartChange = cartFillStatus / 100;

  return (
    <Section title="Cartridge Status">
      {isThereCart ? (
        <LabeledList.Item label="Product Remaining">
          <ProgressBar
            color={cartFillStatus ? 'purple' : 'red'}
            value={adjustedCartChange}
            width={20}
          />
        </LabeledList.Item>
      ) : (
        <LabeledList.Item label="Cartridge Problem">
          <Box color="label">
            One or more cartridges are missing or damaged. <br />
            <br />
            Sabresnacks Co. recommends ordering a genuine Sabresnacks
            replacement cartridge through your local logistical cargo service.
          </Box>
        </LabeledList.Item>
      )}
    </Section>
  );
};
