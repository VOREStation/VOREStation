import { useBackend } from '../../backend';
import {
  Box,
  Button,
  Flex,
  Icon,
  ProgressBar,
  Section,
} from '../../components';
import { Data } from './types';

export const SleeperChemicals = (props) => {
  const { act, data } = useBackend<Data>();
  const { occupant, chemicals, maxchem, amounts } = data;
  return (
    <Section title="Chemicals" flexGrow>
      {chemicals.map((chem, i) => {
        let barColor = '';
        let odWarning;
        if (chem.overdosing) {
          barColor = 'bad';
          odWarning = (
            <Box color="bad">
              <Icon name="exclamation-circle" />
              &nbsp; Overdosing!
            </Box>
          );
        } else if (chem.od_warning) {
          barColor = 'average';
          odWarning = (
            <Box color="average">
              <Icon name="exclamation-triangle" />
              &nbsp; Close to overdosing
            </Box>
          );
        }
        return (
          <Box key={i} backgroundColor="rgba(0, 0, 0, 0.33)" mb="0.5rem">
            <Section
              title={chem.title}
              mx="0"
              lineHeight="18px"
              buttons={odWarning}
            >
              <Flex align="flex-start">
                <ProgressBar
                  minValue={0}
                  maxValue={1}
                  value={chem.occ_amount / maxchem}
                  color={barColor}
                  mr="0.5rem"
                >
                  {chem.pretty_amount}/{maxchem}u
                </ProgressBar>
                {amounts.map((a, i) => (
                  <Button
                    key={i}
                    disabled={
                      !chem.injectable ||
                      chem.occ_amount + a > maxchem ||
                      occupant.stat === 2
                    }
                    icon="syringe"
                    mb="0"
                    height="19px"
                    onClick={() =>
                      act('chemical', {
                        chemid: chem.id,
                        amount: a,
                      })
                    }
                  >
                    {a}
                  </Button>
                ))}
              </Flex>
            </Section>
          </Box>
        );
      })}
    </Section>
  );
};
