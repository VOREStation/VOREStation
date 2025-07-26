/* eslint-disable react/no-danger */
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';

type Data = {
  header: string;
  content: string;
};

export const CharacterSetup = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Window width={800} height={800}>
      <Window.Content>
        {/** biome-ignore lint/security/noDangerouslySetInnerHtml: For now needed */}
        <div dangerouslySetInnerHTML={{ __html: data.header }} />
        {/** biome-ignore lint/security/noDangerouslySetInnerHtml: For now needed */}
        <div dangerouslySetInnerHTML={{ __html: data.content }} />
      </Window.Content>
    </Window>
  );
};
