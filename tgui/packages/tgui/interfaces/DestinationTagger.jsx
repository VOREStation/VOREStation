import { useBackend } from '../backend';
import { Button, Flex, Section } from '../components';
import { Window } from '../layouts';

export const DestinationTagger = (props) => {
  const { act, data } = useBackend();

  const { currTag, taggerLocs } = data;

  return (
    <Window width={450} height={310}>
      <Window.Content>
        <Section title="Tagger Locations">
          <Flex wrap="wrap" spacing={1} justify="center">
            {taggerLocs.sort().map((tag) => (
              <Flex.Item key={tag}>
                <Button
                  icon={currTag === tag ? 'check-square-o' : 'square-o'}
                  selected={currTag === tag}
                  onClick={() => act('set_tag', { tag: tag })}
                >
                  {tag}
                </Button>
              </Flex.Item>
            ))}
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
