import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Section, Stack } from 'tgui-core/components';

type Data = {
  currTag: string;
  taggerLevels: { z: number; location: string }[];
  taggerLocs: { tag: string; level: number }[];
};

export const DestinationTagger = (props) => {
  const { act, data } = useBackend<Data>();

  const { currTag, taggerLevels = [], taggerLocs } = data;

  const unique_levels = taggerLevels.filter((obj, index) => {
    return index === taggerLevels.findIndex((o) => obj.location === o.location);
  });

  return (
    <Window width={450} height={310}>
      <Window.Content scrollable>
        <Section title="Tagger Locations">
          {unique_levels.map((level) => (
            <Section key={level.location} title={level.location}>
              <Stack wrap="wrap" justify="center">
                {taggerLocs.map(
                  (tag) =>
                    level.z === tag.level && (
                      <Stack.Item key={tag.tag}>
                        <Button
                          icon={
                            currTag === tag.tag ? 'check-square-o' : 'square-o'
                          }
                          selected={currTag === tag.tag}
                          onClick={() => act('set_tag', { tag: tag.tag })}
                        >
                          {tag.tag}
                        </Button>
                      </Stack.Item>
                    ),
                )}
              </Stack>
            </Section>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
