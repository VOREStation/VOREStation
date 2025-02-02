import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Section } from 'tgui-core/components';

type Data = {
  remaining: number;
  question: string;
  choices: string[];
  user_vote: string | null;
  counts: Record<string, number>;
  show_counts: boolean;
};

export const VotePanel = (props, context) => {
  const { act, data } = useBackend<Data>();
  const { remaining, question, choices, user_vote, counts, show_counts } = data;

  return (
    <Window width={400} height={360}>
      <Window.Content>
        <Section fill scrollable title={question}>
          <Box mb={1.5} ml={0.5}>
            Time remaining: {remaining.toFixed(0)}s
          </Box>
          {choices.map((choice, i) => (
            <Box key={i}>
              <Button
                mb={1}
                fluid
                lineHeight={3}
                content={
                  choice +
                  (show_counts ? ' (' + (counts[choice] || 0) + ')' : '')
                }
                onClick={() => act('vote', { target: choice })}
                selected={choice === user_vote}
              />
            </Box>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
