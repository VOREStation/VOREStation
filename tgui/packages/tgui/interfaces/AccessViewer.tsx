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
  region: number;
  access_type: number;
  has_req: BooleanLike;
  has_req_one: BooleanLike;
};

enum region_ids {
  None = -1,
  All = 0,
  Security,
  Medbay,
  Research,
  Engineering,
  Command,
  General,
  Supply,
}

enum access_types {
  None = 0,
  Centcom = 1,
  Station = 2,
  Syndicate = 4,
  Private = 8,
}

export const AccessViewer = (props) => {
  const { act, data } = useBackend<Data>();
  const { access_list, name, coords, req_access, req_one_access } = data;

  const access_regions: Record<number, Access[]> = {
    [region_ids.None]: [],
    [region_ids.Security]: [],
    [region_ids.Medbay]: [],
    [region_ids.Research]: [],
    [region_ids.Engineering]: [],
    [region_ids.Command]: [],
    [region_ids.General]: [],
    [region_ids.Supply]: [],
  };

  access_list.map((entry) => {
    entry.has_req = req_access.includes(entry.id);
    entry.has_req_one = req_one_access.includes(entry.id);
    access_regions[entry.region].push(entry);
  });

  return (
    <Window width={620} height={540}>
      <Window.Content scrollable>
        <Section title={`${name}'s access at ${coords}`}>
          {Object.keys(access_regions).map((key) => (
            <Section key={key} title={region_ids[key]}>
              <LabeledList>
                {access_regions[key].map((entry: Access) => (
                  <LabeledList.Item
                    label={`${entry.id}: ${entry.name}`}
                    key={entry.id}
                  >
                    <Button.Checkbox
                      checked={entry.has_req}
                      color={entry.has_req ? 'good' : 'bad'}
                      onClick={() => act('req_all', { set_id: entry.id })}
                    >
                      Requires
                    </Button.Checkbox>
                    <Button.Checkbox
                      checked={entry.has_req_one}
                      color={entry.has_req_one ? 'good' : 'bad'}
                      onClick={() => act('req_one', { set_id: entry.id })}
                    >
                      Have Any
                    </Button.Checkbox>
                    {/* TODO - Some kind of display for these bitflags */}
                    access_type
                  </LabeledList.Item>
                ))}
              </LabeledList>
            </Section>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
