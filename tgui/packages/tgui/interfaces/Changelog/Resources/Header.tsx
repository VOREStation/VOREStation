import type { ReactNode } from 'react';
import { Section } from 'tgui-core/components';

export const Header = (props: { dateDropdown: ReactNode | null }) => {
  const { dateDropdown } = props;

  return (
    <Section>
      <h1>VOREStation Changelist</h1>
      <p>
        {'The GitHub repository can be found '}
        <a href="https://github.com/VOREStation/VOREStation">here</a>
        {', recent GitHub contributors can be found '}
        <a href="https://github.com/VOREStation/VOREStation/pulse/monthly">
          here
        </a>
        .
      </p>
      <p>
        {'Visit our wiki '}
        <a href="https://wiki.vore-station.net/Main_Page">here</a>
        {', check out our discord server '}
        <a href="https://discord.gg/Zd5WMuq">here</a>.
      </p>
      {dateDropdown}
    </Section>
  );
};
