import { Box, Section } from '../../components';

export const CfStep3 = (props: { totalprice: number }) => {
  const { totalprice } = props;
  return (
    <Section title="Step 3: Payment" minHeight="282px">
      <Box italic textAlign="center" fontSize="20px">
        Your device is ready for fabrication...
      </Box>
      <Box bold mt={2} textAlign="center" fontSize="16px">
        <Box inline>Please swipe your ID now to authorize payment of:</Box>
        &nbsp;
        <Box inline color="good">
          {totalprice}₮
        </Box>
      </Box>
    </Section>
  );
};
