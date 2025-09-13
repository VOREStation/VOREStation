import 'tgui/styles/components/CommandlineComponents.scss';

import { Box, Divider, LabeledList, Section } from 'tgui-core/components';

export const HelpBox = () => {
  return (
    <Box className="commandline_helpbox">
      <Section>
        <h2>Prefix Legend</h2>
        <Divider />
        <LabeledList>
          <LabeledList.Item label=">">Select First Matching</LabeledList.Item>
          <LabeledList.Item label="><">Select Self</LabeledList.Item>
          <LabeledList.Item label=">@">Select All Matching</LabeledList.Item>
          <LabeledList.Item label=">@@">Select All</LabeledList.Item>
          <LabeledList.Item label=">!">
            Select All Not Matching
          </LabeledList.Item>
        </LabeledList>
        <Divider />
      </Section>
    </Box>
  );
};
