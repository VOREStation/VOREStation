import { Box, Section } from '../../components';

export const CfStep4 = (props) => {
  return (
    <Section minHeight="282px">
      <Box bold textAlign="center" fontSize="28px" mt={10}>
        Thank you for your purchase!
      </Box>
      <Box italic mt={1} textAlign="center">
        If you experience any difficulties with your new device, please contact
        your local network administrator.
      </Box>
    </Section>
  );
};
