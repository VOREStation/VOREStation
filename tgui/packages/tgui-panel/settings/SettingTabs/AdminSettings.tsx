import { useDispatch, useSelector } from 'tgui/backend';
import { Button, LabeledList, Section } from 'tgui/components';

import { updateSettings } from '../actions';
import { selectSettings } from '../selectors';

export const AdminSettings = (props) => {
  const dispatch = useDispatch();
  const { hideImportantInAdminTab } = useSelector(selectSettings);
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Hide Important messages in admin only tabs">
          <Button.Checkbox
            checked={hideImportantInAdminTab}
            tooltip="Enabling this will hide all important messages in admin filter exclusive tabs."
            mr="5px"
            onClick={() =>
              dispatch(
                updateSettings({
                  hideImportantInAdminTab: !hideImportantInAdminTab,
                }),
              )
            }
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
