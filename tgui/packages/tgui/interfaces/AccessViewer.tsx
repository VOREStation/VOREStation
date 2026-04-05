import { Fragment, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Divider, Input, Section, Table } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { createSearch } from 'tgui-core/string';

type Data = {
  access_list: Access[];
  name?: string;
  coords?: string;
  req_access?: number[];
  req_one_access?: number[];
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
  const [searchText, setSearchText] = useState('');

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

  const search = createSearch<Access>(searchText.toLowerCase(), (entry) =>
    `${entry.id}: ${entry.name}`.toLowerCase(),
  );

  access_list.forEach((entry) => {
    entry.has_req = req_access?.includes(entry.id);
    entry.has_req_one = req_one_access?.includes(entry.id);

    if (search(entry)) {
      access_regions[entry.region].push(entry);
    }
  });
  return (
    <Window width={620} height={540}>
      <Window.Content>
        <Section
          fill
          title={`${name}'s access at ${coords}`}
          scrollable
          buttons={
            <Input
              width="200px"
              value={searchText}
              onChange={setSearchText}
              placeholder="Search for access..."
            />
          }
        >
          <Table>
            {Object.keys(access_regions).map((key, index) => (
              <Fragment key={key}>
                {index > 0 && (
                  <Table.Row>
                    <Table.Cell colSpan={4}>
                      <Divider />
                    </Table.Cell>
                  </Table.Row>
                )}
                <Table.Row header>
                  <Table.Cell colSpan={4}>{region_ids[key]}</Table.Cell>
                </Table.Row>
                <Table.Row>
                  <Table.Cell colSpan={4}>
                    <Divider />
                  </Table.Cell>
                </Table.Row>
                {access_regions[key].map((entry: Access) => (
                  <Table.Row key={entry.id}>
                    <Table.Cell
                      collapsing
                    >{`${entry.id}: ${entry.name}`}</Table.Cell>
                    <Table.Cell collapsing>
                      <Button.Checkbox
                        checked={entry.has_req}
                        onClick={() => act('req_all', { set_id: entry.id })}
                      >
                        Requires
                      </Button.Checkbox>
                    </Table.Cell>
                    <Table.Cell collapsing>
                      <Button.Checkbox
                        checked={entry.has_req_one}
                        onClick={() => act('req_one', { set_id: entry.id })}
                      >
                        Have Any
                      </Button.Checkbox>
                    </Table.Cell>
                    <Table.Cell collapsing>
                      {/* TODO - Some kind of display for these bitflags */}
                      access_type
                    </Table.Cell>
                  </Table.Row>
                ))}
              </Fragment>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
