/**
 * @file
 * @copyright 2021 Aleksej Komarov
 * @license MIT
 */

import { Input, LabeledList, Section } from 'tgui-core/components';

export const meta = {
  title: 'Themes',
  render: (
    theme: string,
    setTheme: (value: React.SetStateAction<string>) => void,
  ) => <Story theme={theme} setTheme={setTheme} />,
};

function Story(props: {
  theme: string;
  setTheme: (value: React.SetStateAction<string>) => void;
}) {
  const { theme, setTheme } = props;

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
