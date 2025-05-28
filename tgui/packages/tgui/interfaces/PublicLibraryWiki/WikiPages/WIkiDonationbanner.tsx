import type { Dispatch, SetStateAction } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, NoticeBox, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { WikiAdColors, WikiDonIcons } from '../constants';

export function WikiDonationBanner(props: {
  donated: number;
  goal: number;
  displayedMessage: string;
  hasDonated: BooleanLike;
  onDisplayedDonations: Dispatch<SetStateAction<boolean>>;
}) {
  const { donated, goal, displayedMessage, hasDonated, onDisplayedDonations } =
    props;

  const progress = donated / goal;

  if (hasDonated) {
    return (
      <NoticeBox success>
        <WikiDonationContent
          hideButtons
          donated={donated}
          goal={goal}
          message={displayedMessage}
          onDisplayedDonations={onDisplayedDonations}
        />
      </NoticeBox>
    );
  }

  if (progress < 0.33) {
    return (
      <NoticeBox danger>
        <WikiDonationContent
          donated={donated}
          goal={goal}
          message={displayedMessage}
          onDisplayedDonations={onDisplayedDonations}
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
          onDisplayedDonations={onDisplayedDonations}
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
          onDisplayedDonations={onDisplayedDonations}
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
        onDisplayedDonations={onDisplayedDonations}
      />
    </NoticeBox>
  );
}

const WikiDonationContent = (props: {
  donated: number;
  goal: number;
  message: string;
  hideButtons?: boolean;
  onDisplayedDonations: Dispatch<SetStateAction<boolean>>;
}) => {
  const { donated, goal, message, onDisplayedDonations, hideButtons } = props;

  return (
    <>
      <Button
        position="absolute"
        right="6px"
        color="transparent"
        onClick={() => onDisplayedDonations(false)}
      >
        X
      </Button>
      <Stack vertical fill textAlign="center">
        <Stack.Item>
          <Box>{message}</Box>
        </Stack.Item>
        <Stack.Item>
          <Box>
            {donated} / {goal}₮
          </Box>
        </Stack.Item>
        {!hideButtons && donated < goal && (
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
              <Stack.Item grow />
            </Stack>
          </Stack.Item>
        )}
      </Stack>
    </>
  );
};

// Intentionally not state safe
const DonationButtons = (props) => {
  const { act } = useBackend();

  const donation = Math.round(Math.random() * 100 + 10);

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
      {'Donate ' + donation + '₮'}
    </Button>
  );
};
