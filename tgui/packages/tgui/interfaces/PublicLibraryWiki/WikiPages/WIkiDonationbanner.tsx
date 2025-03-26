import { useBackend } from 'tgui/backend';
import { Box, Button, NoticeBox, Stack } from 'tgui-core/components';

import { WikiAdColors, WikiDonIcons } from '../constants';

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
      {donated < goal && (
        <Stack.Item>
          <Stack fill>
            <Stack.Item grow />
            <Stack.Item>
              <DonationButtons />
            </Stack.Item>
            <Stack.Item>
              <DonationButtons />
            </Stack.Item>
            <Stack.Item>
              <DonationButtons />
            </Stack.Item>
            <Stack.Item>
              <DonationButtons />
            </Stack.Item>
            <Stack.Item>
              <DonationButtons />
            </Stack.Item>
            <Stack.Item>
              <DonationButtons />
            </Stack.Item>
            <Stack.Item>
              <DonationButtons />
            </Stack.Item>
            <Stack.Item>
              <DonationButtons />
            </Stack.Item>
            <Stack.Item grow />
          </Stack>
        </Stack.Item>
      )}
    </Stack>
  );
};

const DonationButtons = (props) => {
  const { act } = useBackend();

  const donation = (Math.random() * 100 + 10).toFixed();
  return (
    <Button
      color={WikiAdColors[Math.floor(Math.random() * WikiAdColors.length)]}
      icon={WikiDonIcons[Math.floor(Math.random() * WikiDonIcons.length)]}
      iconSpin={Math.random() > 0.5}
      onClick={() =>
        act('donate', {
          donate: donation,
        })
      }
    >
      {'Donate ' + donation}
    </Button>
  );
};
