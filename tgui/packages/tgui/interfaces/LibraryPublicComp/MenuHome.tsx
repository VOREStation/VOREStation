import { useBackend } from 'tgui/backend';
import { Section } from 'tgui-core/components';

import type { Data } from './types';

export const MenuHome = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Section title="Home">
      <center>
        <br />
        <h2>NTos Library Manager V2.1</h2>
        <br />
        <h3>Welcome librarian.</h3>
        <h3>The archive of the future awaits you.</h3>
      </center>
    </Section>
  );
};
