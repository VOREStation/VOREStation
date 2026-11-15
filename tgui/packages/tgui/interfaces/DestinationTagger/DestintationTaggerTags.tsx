import { useBackend } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';
import type { Data } from './types';

export const DestintationTaggerTags = (props: { tagSearch: string }) => {
  const { act, data } = useBackend<Data>();

  const { currTag, taggerLocs } = data;
  const { tagSearch } = props;

  const tagSearcher = createSearch<string>(tagSearch, (tag) => tag);
  const toDisplay = Object.keys(taggerLocs)
    .filter(tagSearcher)
    .sort((a, b) => a.localeCompare(b));
  return (
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
  );
};
