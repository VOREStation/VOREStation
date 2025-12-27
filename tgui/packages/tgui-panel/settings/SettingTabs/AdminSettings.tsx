import { Button, LabeledList, Section } from 'tgui-core/components';

import { useSettings } from '../use-settings';

export const AdminSettings = (props) => {
  const { settings, updateSettings } = useSettings();
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Hide Important messages in admin only tabs">
          <Button.Checkbox
            checked={settings.hideImportantInAdminTab}
            tooltip="Enabling this will hide all important messages in admin filter exclusive tabs."
            mr="5px"
            onClick={() =>
              updateSettings({
                hideImportantInAdminTab: !settings.hideImportantInAdminTab,
              })
            }
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
