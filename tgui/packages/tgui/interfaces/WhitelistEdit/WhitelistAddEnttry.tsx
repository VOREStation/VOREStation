import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Button,
  Dropdown,
  Input,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';
import type { Data } from './types';

export const WhitelistAddEnttry = (props: {
  type: string;
  entries: string[];
}) => {
  const { act } = useBackend<Data>();
  const { type, entries } = props;
  const [selectedRole, setSelectedRole] = useState('');
  const [ckey, setCkey] = useState('');
  return (
    <Stack.Item>
      <Section
        fill
        title={capitalize(type)}
        buttons={
          <Button
            disabled={!selectedRole || !ckey}
            onClick={() =>
              act('add_alienwhitelist', {
                ckey: ckey.toLocaleLowerCase(),
                type: type,
                role: selectedRole,
              })
            }
            color="green"
          >
            Add
          </Button>
        }
      >
        <LabeledList>
          <LabeledList.Item label="Role">
            <Dropdown
              searchInput
              onSelected={setSelectedRole}
              options={entries}
              selected={selectedRole}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Ckey">
            <Stack>
              <Stack.Item>
                <Input fluid value={ckey} onChange={setCkey} />
              </Stack.Item>
              <Stack.Item>
                <Button
                  disabled={!ckey}
                  color="red"
                  onClick={() => setCkey('')}
                >
                  X
                </Button>
              </Stack.Item>
            </Stack>
          </LabeledList.Item>
        </LabeledList>
      </Section>
    </Stack.Item>
  );
};
