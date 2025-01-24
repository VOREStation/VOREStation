import { useBackend } from 'tgui/backend';
import { Button, Dropdown, LabeledList, Stack } from 'tgui-core/components';

import { Data } from './types';

export const NIFSettings = (props) => {
  const { act, data } = useBackend<Data>();

  const { valid_themes, theme } = data;

  return (
    <LabeledList>
      <LabeledList.Item label="NIF Theme" verticalAlign="top">
        <Stack>
          <Stack.Item grow>
            <Dropdown
              autoScroll={false}
              width="100%"
              selected={theme || 'default'}
              options={valid_themes}
              onSelected={(val) => act('setTheme', { theme: val })}
            />
          </Stack.Item>
          {theme ? (
            <Stack.Item>
              <Button
                width="22px"
                icon="undo"
                color="red"
                onClick={() => {
                  act('setTheme', { theme: null });
                }}
              />
            </Stack.Item>
          ) : (
            ''
          )}
        </Stack>
      </LabeledList.Item>
    </LabeledList>
  );
};
