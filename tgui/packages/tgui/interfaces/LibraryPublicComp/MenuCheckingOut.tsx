import { useBackend } from 'tgui/backend';
import { Button, Divider, Section } from 'tgui-core/components';

import type { Data } from './types';

export const MenuCheckingOut = (props) => {
  const { act, data } = useBackend<Data>();

  const { buffer_book, buffer_mob, checkoutperiod } = data;

  return (
    <Section title="Check out a Book">
      <Button icon="eye" onClick={() => act('editbook', { editbook: 1 })}>
        Edit
      </Button>
      Book: {buffer_book} <br />
      <Button icon="eye" onClick={() => act('editmob', { editmob: 1 })}>
        Edit
      </Button>
      Recipient: {buffer_mob} <br />
      <Divider />
      <Button onClick={() => act('decreasetime', { decreasetime: 1 })}>
        -
      </Button>
      (Checkout Period: {checkoutperiod} minutes)
      <Button onClick={() => act('increasetime', { increasetime: 1 })}>
        +
      </Button>
      <Divider />
      <center>
        <Button icon="eye" onClick={() => act('checkout', { checkout: 1 })}>
          Commit Entry
        </Button>
      </center>
    </Section>
  );
};
