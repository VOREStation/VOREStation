import { useBackend } from 'tgui/backend';
import { Box, Section, Tabs } from 'tgui-core/components';

import { Data } from './types';

export const UplinkHeader = (props: {
  screen: number;
  setScreen: Function;
}) => {
  const { data } = useBackend<Data>();

  const { screen, setScreen } = props;

  const { discount_name, discount_amount, offer_expiry } = data;

  return (
    <Section>
      <Tabs
        style={{
          borderBottom: 'none',
          marginBottom: '0',
        }}
      >
        <Tabs.Tab selected={screen === 0} onClick={() => setScreen(0)}>
          Request Items
        </Tabs.Tab>
        <Tabs.Tab selected={screen === 1} onClick={() => setScreen(1)}>
          Exploitable Information
        </Tabs.Tab>
      </Tabs>
      <Section title="Item Discount">
        {(discount_amount < 100 && (
          <Box>
            {discount_name} - {discount_amount}% off. Offer expires at:{' '}
            {offer_expiry}
          </Box>
        )) || <Box>No items currently discounted.</Box>}
      </Section>
    </Section>
  );
};
