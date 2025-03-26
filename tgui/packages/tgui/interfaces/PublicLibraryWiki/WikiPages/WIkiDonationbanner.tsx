import { useBackend } from 'tgui/backend';
import { Box, NoticeBox, Stack } from 'tgui-core/components';

export function WikiDonationBanner(props: {
  donated: number;
  goal: number;
  displayedMessage: string;
}) {
  const { donated, goal, displayedMessage } = props;

  const progress = donated / goal;

  if (progress < 0.33) {
    return (
      <NoticeBox danger>
        <WikiDonationContent
          donated={donated}
          goal={goal}
          message={displayedMessage}
        />
      </NoticeBox>
    );
  }

  if (progress < 0.66) {
    return (
      <NoticeBox warning>
        <WikiDonationContent
          donated={donated}
          goal={goal}
          message={displayedMessage}
        />
      </NoticeBox>
    );
  }

  if (progress < 1) {
    return (
      <NoticeBox info>
        <WikiDonationContent
          donated={donated}
          goal={goal}
          message={displayedMessage}
        />
      </NoticeBox>
    );
  }

  return (
    <NoticeBox success>
      <WikiDonationContent
        donated={donated}
        goal={goal}
        message={'Thank you for your AWESOME support!'}
      />
    </NoticeBox>
  );
}

const WikiDonationContent = (props: {
  donated: number;
  goal: number;
  message: string;
}) => {
  const { act } = useBackend();
  const { donated, goal, message } = props;

  return (
    <Stack vertical fill textAlign="center">
      <Stack.Item>
        <Box>{message}</Box>
      </Stack.Item>
      <Stack.Item>
        <Box>
          {donated} / {goal}
        </Box>
      </Stack.Item>
    </Stack>
  );
};
