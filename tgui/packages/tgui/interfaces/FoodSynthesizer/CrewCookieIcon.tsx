import { useBackend } from 'tgui/backend';
import { Icon, Image, Section } from 'tgui-core/components';
import type { Data } from './types';

export const CrewCookieIcon = (props) => {
  const { act, data } = useBackend<Data>();
  const { crewicon } = data;

  return (
    <Section>
      {crewicon ? (
        <Image
          src={crewicon.substring(1, crewicon.length - 1)}
          width="128px"
          height="128px"
        />
      ) : (
        <Icon width="128px" height="128px" fontSize={4} name="camera" />
      )}
    </Section>
  );
};
