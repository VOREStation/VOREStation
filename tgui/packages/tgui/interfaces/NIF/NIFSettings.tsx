import { useBackend } from '../../backend';
import { Button, Dropdown, Flex, LabeledList } from '../../components';
import { Data } from './types';

export const NIFSettings = (props) => {
  const { act, data } = useBackend<Data>();

  const { valid_themes, theme } = data;

  return (
    <LabeledList>
      <LabeledList.Item label="NIF Theme" verticalAlign="top">
        <Flex>
          <Flex.Item grow={1}>
            <Dropdown
              autoScroll={false}
              width="100%"
              selected={theme || 'default'}
              options={valid_themes}
              onSelected={(val) => act('setTheme', { theme: val })}
            />
          </Flex.Item>
          {theme ? (
            <Flex.Item>
              <Button
                width="22px"
                icon="undo"
                color="red"
                onClick={() => {
                  act('setTheme', { theme: null });
                }}
              />
            </Flex.Item>
          ) : (
            ''
          )}
        </Flex>
      </LabeledList.Item>
    </LabeledList>
  );
};
