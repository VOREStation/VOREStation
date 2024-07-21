import { BooleanLike } from 'common/react';

import { Box, Collapsible, Section } from '../../components';
import { digestModeToColor, digestModeToPreyMode } from './constants';
import { insideData } from './types';
import { VoreContentsPanel } from './VoreContentsPanel';

export const VoreInsidePanel = (props: {
  inside: insideData;
  show_pictures: BooleanLike;
}) => {
  const { inside, show_pictures } = props;

  const { absorbed, belly_name, belly_mode, desc, pred, contents, ref } =
    inside;

  if (!belly_name) {
    return <Section title="Inside">You aren&apos;t inside anyone.</Section>;
  }

  return (
    <Section title="Inside">
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
      &nbsp;
      <Box color="yellow" inline>
        and you are
      </Box>
      &nbsp;
      <Box color={digestModeToColor[belly_mode]} inline>
        {digestModeToPreyMode[belly_mode]}
      </Box>
      &nbsp;
      <Box color="label">{desc}</Box>
      {(contents.length && (
        <Collapsible title="Belly Contents">
          <VoreContentsPanel
            contents={contents}
            belly={ref}
            show_pictures={show_pictures}
          />
        </Collapsible>
      )) ||
        'There is nothing else around you.'}
    </Section>
  );
};
