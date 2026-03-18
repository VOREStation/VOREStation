import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Button,
  Dropdown,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';
import type { Data } from './types';

export const WhitelistRemoveEntry = (props: {
  type: string;
  entries: Record<string, string[] | null>;
}) => {
  const { act } = useBackend<Data>();
  const { type, entries } = props;
  const [selectedRole, setSelectedRole] = useState('');
  const [ckey, setCkey] = useState('');

  const ckeys = Object.keys(entries);
  useEffect(() => {
    if (!entries[ckey]?.length) {
      setSelectedRole('');
    }
    if (!entries[ckey]) {
      setCkey('');
    }
  }, [entries]);

  function handleCkey(newKey: string) {
    setCkey(newKey);
    if (entries[newKey]?.length) {
      setSelectedRole(entries[newKey][0]);
    }
  }

  return (
    <Stack.Item>
      <Section
        fill
        title={capitalize(type)}
        buttons={
          <Button
            disabled={!selectedRole || !ckey}
            onClick={() =>
              act('remove_alienwhitelist', {
                ckey: ckey.toLocaleLowerCase(),
                type: type,
                role: selectedRole,
              })
            }
          >
            Remove
          </Button>
        }
      >
        <LabeledList>
          <LabeledList.Item label="Ckey">
            <Dropdown onSelected={handleCkey} options={ckeys} selected={ckey} />
          </LabeledList.Item>
          <LabeledList.Item label="Role">
            <Dropdown
              onSelected={setSelectedRole}
              options={entries[ckey] ?? []}
              selected={selectedRole}
            />
          </LabeledList.Item>
        </LabeledList>
      </Section>
    </Stack.Item>
  );
};
