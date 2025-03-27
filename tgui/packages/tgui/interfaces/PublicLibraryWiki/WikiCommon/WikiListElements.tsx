import { Box, Collapsible, LabeledList } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

export const WikiSpoileredList = (props: {
  ourKey: string;
  entries: string[] | Record<string, string> | Record<string, number>;
  title: string;
}) => {
  const { entries, title, ourKey } = props;

  if (Array.isArray(entries) && entries.length) {
    return (
      <>
        <LabeledList.Divider />
        <LabeledList.Item label={title}>
          <Collapsible
            key={ourKey}
            color="transparent"
            title={'Reveal ' + title}
          >
            {entries.map((entry) => (
              <Box key={entry}>- {capitalize(entry)}</Box>
            ))}
          </Collapsible>
        </LabeledList.Item>
      </>
    );
  }

  return (
    <>
      <LabeledList.Divider />
      <LabeledList.Item label={title}>
        <Collapsible key={ourKey} color="transparent" title={'Reveal ' + title}>
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

  if (Array.isArray(entries) && entries.length) {
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
