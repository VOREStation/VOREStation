/**
 * @file
 * @copyright 2021 Aleksej Komarov
 * @license MIT
 */

import { useState } from 'react';
import { Input, LabeledList, Section } from 'tgui-core/components';

export const meta = {
  title: 'Themes',
  render: () => <Story />,
};

function Story() {
  const [theme, setTheme] = useState('');

  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Use theme">
          <Input
            placeholder="theme_name"
            value={theme}
            onChange={(value) => setTheme(value)}
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
}
