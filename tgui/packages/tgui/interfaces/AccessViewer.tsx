import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, LabeledList, Section } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  access_list: Access[];
  name: string;
  coords: string;
  req_access: number[];
  req_one_access: number[];
};

type Access = {
  name: string;
  id: number;
  has_req: BooleanLike;
  has_req_one: BooleanLike;
};

export const AccessViewer = (props) => {
  const { act, data } = useBackend<Data>();
  const { access_list, name, coords, req_access, req_one_access } = data;

  // Get all ids provided, remove each one as we check the access list of real datums
  // If any remain by the end then they don't have a datum, and are invalid
  const invalid_access: number[] = [];
  invalid_access.concat(req_access);
  invalid_access.concat(req_one_access);

  access_list.map((entry) => {
    entry.has_req = req_access.includes(entry.id);
    entry.has_req_one = req_one_access.includes(entry.id);
    invalid_access.filter((check) => check === entry.id);
  });

  return (
    <Window width={520} height={540}>
      <Window.Content scrollable>
        <Section title={`${name}'s access at ${coords}`}>
          <LabeledList>
            {access_list.map((entry) => (
              <LabeledList.Item
                label={`${entry.id}: ${entry.name}`}
                key={entry.id}
              >
                <Button
                  color={entry.has_req ? 'good' : 'bad'}
                  onClick={() => act('req_all', { set_id: entry.id })}
                >
                  Requires
                </Button>
                <Button
                  color={entry.has_req_one ? 'good' : 'bad'}
                  onClick={() => act('req_one', { set_id: entry.id })}
                >
                  Have Any
                </Button>
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
        {!!invalid_access.length && (
          <Section title="Invalid IDs">
            <LabeledList>
              <LabeledList.Item label="Coords">{coords}</LabeledList.Item>
              {invalid_access.map((invalid) => (
                <LabeledList.Item
                  key={invalid}
                >{`Bad key ${invalid}`}</LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
