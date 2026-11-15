import { useBackend } from 'tgui/backend';
import { Button, Divider, Section, Stack } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';
import type { Data } from './types';

export const DestinationTaggerLevels = (props: { tagSearch: string }) => {
  const { act, data } = useBackend<Data>();

  const { level_names, taggerLocs } = data;
  const { tagSearch } = props;

  const temp: Record<string, Set<string>> = Object.entries(taggerLocs).reduce(
    (acc, [tag, locLevels]) => {
      if (!locLevels?.length) {
        if (!acc.Unused) {
          acc.Unused = new Set();
        }
        acc.Unused.add(tag);
        return acc;
      }

      locLevels.forEach((levelId) => {
        const level = level_names[levelId];
        if (!level) return;

        if (!acc[level]) {
          acc[level] = new Set();
        }

        acc[level].add(tag);
      });

      return acc;
    },
    {} as Record<string, Set<string>>,
  );

  const levelOrder = Object.fromEntries(
    Object.entries(level_names).map(([id, name]) => [name, Number(id)]),
  );

  const result: Record<string, string[]> = Object.fromEntries(
    Object.entries(temp)
      .sort(([a], [b]) => {
        if (a === 'Unused') return -1;
        if (b === 'Unused') return 1;

        return (levelOrder[a] ?? Infinity) - (levelOrder[b] ?? Infinity);
      })
      .map(([k, v]) => [k, [...v].sort()]),
  );

  return Object.keys(result).map((level, index) => (
    <>
      {index !== 0 && <Divider />}
      <LevelEntry
        key={level}
        level={level}
        result={result[level]}
        tagSearch={tagSearch}
      />
    </>
  ));
};

const LevelEntry = (props: {
  level: string;
  result: string[];
  tagSearch: string;
}) => {
  const { act, data } = useBackend<Data>();

  const { currTag } = data;
  const { level, result, tagSearch } = props;

  const tagSearcher = createSearch<string>(tagSearch, (tag) => tag);
  const toDisplay = result.filter(tagSearcher);

  return (
    <Section title={level}>
      <Stack wrap="wrap" justify="center">
        {toDisplay.map((tag) => (
          <Stack.Item key={tag}>
            <Button.Checkbox
              checked={currTag === tag}
              selected={currTag === tag}
              onClick={() => act('set_tag', { tag: tag })}
            >
              {tag}
            </Button.Checkbox>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};
