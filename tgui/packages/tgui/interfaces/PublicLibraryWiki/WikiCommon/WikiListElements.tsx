import { Box, Collapsible, LabeledList } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

export const WikiSpoileredList = (props: {
  entries: string[] | Record<string, string> | Record<string, number>;
  title: string;
}) => {
  const { entries, title } = props;

  if (Array.isArray(entries)) {
    return (
      <>
        <LabeledList.Divider />
        <LabeledList.Item label={title}>
          <Collapsible
            key={title}
            color="transparent"
            title={'Reveal ' + title}
          >
            {entries.map((entry) => (
              <Box key={capitalize(entry)}>- {entry}</Box>
            ))}
          </Collapsible>
        </LabeledList.Item>
      </>
    );
  }

  return (
    <>
      <LabeledList.Divider />
      <LabeledList.Item key={title} label={title}>
        <Collapsible color="transparent" title={'Reveal ' + title}>
          {Object.keys(entries).map((entry) => (
            <Box key={entry}>
              - {capitalize(entry)}: {entries[entry]}
            </Box>
          ))}
        </Collapsible>
      </LabeledList.Item>
    </>
  );
};

export const WikiList = (props: {
  entries: string[] | Record<string, string> | Record<string, number>;
  title: string;
}) => {
  const { entries, title } = props;

  if (Array.isArray(entries)) {
    return (
      <>
        <LabeledList.Divider />
        <LabeledList.Item label={title}>
          {entries.map((entry) => (
            <Box key={entry}>- {capitalize(entry)}</Box>
          ))}
        </LabeledList.Item>
      </>
    );
  }

  return (
    <>
      <LabeledList.Divider />
      <LabeledList.Item label={title}>
        {Object.keys(entries).map((entry) => (
          <Box key={entry}>
            - {capitalize(entry)}: {entries[entry]}
          </Box>
        ))}
      </LabeledList.Item>
    </>
  );
};
