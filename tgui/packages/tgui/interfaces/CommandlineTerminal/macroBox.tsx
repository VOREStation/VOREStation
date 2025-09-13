import 'tgui/styles/components/CommandlineComponents.scss';

import { Box, Divider, LabeledList, Section } from 'tgui-core/components';

import { MacroEntry } from './macroEntry';
export const MacroBox = (props: { macros: Record<string, string> }) => {
  return (
    <Box className="commandline_helpbox">
      <Section scrollable fill>
        <h2>Macros</h2>
        <Divider />
        <LabeledList>
          {Object.entries(props.macros).map(([name, command]) => (
            <MacroEntry key={name} name={name} command={command} />
          ))}
        </LabeledList>
        <Divider />
      </Section>
    </Box>
  );
};
