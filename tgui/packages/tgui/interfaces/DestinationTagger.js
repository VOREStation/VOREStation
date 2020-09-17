import { round } from 'common/math';
import { Fragment } from 'inferno';
import { useBackend } from "../backend";
import { Box, Button, Flex, Icon, LabeledList, ProgressBar, Section, Table } from "../components";
import { Window } from "../layouts";

export const DestinationTagger = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    currTag,
    taggerLocs,
  } = data;

  return (
    <Window width={450} height={310} resizable>
      <Window.Content>
        <Section title="Tagger Locations">
          <Flex wrap="wrap" spacing={1} justify="center">
            {taggerLocs.sort().map(tag => (
              <Flex.Item key={tag}>
                <Button
                  icon={(currTag === tag) ? "check-square-o" : "square-o"}
                  selected={currTag === tag}
                  content={tag}
                  onClick={() => act("set_tag", { tag: tag })} />
              </Flex.Item>
            ))}
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};