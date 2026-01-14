import type { ReactNode } from 'react';
import { Section } from 'tgui-core/components';

export const Footer = (props: { dateDropdown: ReactNode | null }) => {
  const { dateDropdown } = props;

  return (
    <Section>
      {dateDropdown}
      <h3>VOREStation License</h3>
      <p>
        {'All code after '}
        <a
          href={
            'https://github.com/VOREStation/VOREStation/commit/' +
            '333c566b88108de218d882840e61928a9b759d8f'
          }
        >
          commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38
          PM PST
        </a>
        {' is licensed under '}
        <a href="https://www.gnu.org/licenses/agpl-3.0.html">GNU AGPL v3</a>
        {'. All code before that commit is licensed under '}
        <a href="https://www.gnu.org/licenses/gpl-3.0.html">GNU GPL v3</a>
        {', including tools unless their readme specifies otherwise. See '}
        <a href="https://github.com/VOREStation/VOREStation/blob/master/LICENSE">
          LICENSE
        </a>
        {' and '}
        <a href="https://github.com/VOREStation/VOREStation/blob/master/LICENSE-GPL3.txt">
          GPLv3.txt
        </a>
        {' for more details.'}
      </p>
      <p>
        The TGS DMAPI API is licensed as a subproject under the MIT license.
        {' See the footer of '}
        <a
          href={
            'https://github.com/VOREStation/VOREStation/blob/master' +
            '/code/__DEFINES/tgs.dm'
          }
        >
          code/__DEFINES/tgs.dm
        </a>
        {' and '}
        <a
          href={
            'https://github.com/VOREStation/VOREStation/blob/master' +
            '/code/modules/tgs/LICENSE'
          }
        >
          code/modules/tgs/LICENSE
        </a>
        {' for the MIT license.'}
      </p>
      <p>
        {'All assets including icons and sound are under a '}
        <a href="https://creativecommons.org/licenses/by-sa/3.0/">
          Creative Commons 3.0 BY-SA license
        </a>
        {' unless otherwise indicated.'}
      </p>
    </Section>
  );
};
