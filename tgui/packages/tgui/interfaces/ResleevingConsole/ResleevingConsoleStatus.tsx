import { useBackend } from '../../backend';
import { Box, LabeledList, Section } from '../../components';
import { Data } from './types';

export const ResleevingConsoleStatus = (props) => {
  const { data } = useBackend<Data>();
  const { pods, spods, sleevers } = data;
  return (
    <Section title="Status">
      <LabeledList>
        <LabeledList.Item label="Pods">
          {pods && pods.length ? (
            <Box color="good">{pods.length} connected</Box>
          ) : (
            <Box color="bad">None connected!</Box>
          )}
        </LabeledList.Item>
        <LabeledList.Item label="SynthFabs">
          {spods && spods.length ? (
            <Box color="good">{spods.length} connected</Box>
          ) : (
            <Box color="bad">None connected!</Box>
          )}
        </LabeledList.Item>
        <LabeledList.Item label="Sleevers">
          {sleevers && sleevers.length ? (
            <Box color="good">{sleevers.length} Connected</Box>
          ) : (
            <Box color="bad">None connected!</Box>
          )}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
