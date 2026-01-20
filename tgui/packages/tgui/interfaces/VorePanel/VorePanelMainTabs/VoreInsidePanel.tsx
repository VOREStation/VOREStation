import { Box, Section, Stack } from 'tgui-core/components';
import {
  digestModeToColor,
  digestModeToPreyMode,
  reagentToColor,
} from '../constants';
import type { InsideData } from '../types';

export const VoreInsidePanel = (props: { inside: InsideData }) => {
  const { inside } = props;

  const {
    absorbed,
    belly_name,
    belly_mode,
    desc,
    pred,
    liq_lvl,
    liq_reagent_type,
    liuq_name,
  } = inside;

  if (!belly_name) {
    return (
      <Section fill title="Inside">
        You aren&apos;t inside anyone.
      </Section>
    );
  }

  return (
    <Section title="Inside" fill scrollable>
      <Stack vertical fill>
        <Stack.Item>
          <Box color="green" inline>
            You are currently {absorbed ? 'absorbed into' : 'inside'}
          </Box>
          &nbsp;
          <Box color="yellow" inline>
            {pred}&apos;s
          </Box>
          &nbsp;
          <Box color="red" inline>
            {belly_name}
          </Box>
          {!!liq_lvl && liq_lvl > 0 && (
            <>
              ,&nbsp;
              <Box color="yellow" inline>
                bathing in a pool of
              </Box>
              &nbsp;
              <Box color={reagentToColor[liq_reagent_type!]} inline>
                {liuq_name}
              </Box>
            </>
          )}
          &nbsp;
          <Box color="yellow" inline>
            and you are
          </Box>
          &nbsp;
          <Box color={digestModeToColor[belly_mode!]} inline>
            {digestModeToPreyMode[belly_mode!]}
          </Box>
          &nbsp;
          <Stack.Item>
            <Box color="label">{desc}</Box>
          </Stack.Item>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
