import { Box, Collapsible, Section } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { digestModeToPreyMode, reagentToColor } from './constants';
import { digestModeToColor } from './constants';
import type { insideData } from './types';
import { VoreContentsPanel } from './VoreContentsPanel';

export const VoreInsidePanel = (props: {
  inside: insideData;
  show_pictures: BooleanLike;
  icon_overflow: BooleanLike;
}) => {
  const { inside, show_pictures, icon_overflow } = props;

  const {
    absorbed,
    belly_name,
    belly_mode,
    desc,
    pred,
    contents,
    ref,
    liq_lvl,
    liq_reagent_type,
    liuq_name,
  } = inside;

  if (!belly_name) {
    return <Section title="Inside">You aren&apos;t inside anyone.</Section>;
  }

  return (
    <Section title="Inside" fill scrollable>
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
      {liq_lvl! > 0 ? (
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
      ) : (
        ''
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
      <Box color="label">{desc}</Box>
      {(contents!.length && (
        <Collapsible title="Belly Contents">
          <VoreContentsPanel
            contents={contents!}
            belly={ref}
            show_pictures={show_pictures}
            icon_overflow={icon_overflow}
          />
        </Collapsible>
      )) ||
        'There is nothing else around you.'}
    </Section>
  );
};
