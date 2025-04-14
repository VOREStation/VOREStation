import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Input,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';

import { PaginationChevrons } from '..';
import type { Data } from '../data';

export const DesignList = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Section
      title={`Design List (Page ${data.design_page + 1})`}
      fill
      textAlign="center"
      buttons={
        <Stack>
          <Stack.Item>
            <Button icon="print" onClick={() => act('print', { print: 2 })}>
              Print This Page
            </Button>
          </Stack.Item>
          <PaginationChevrons target="design_page" />
        </Stack>
      }
    >
      <Input
        fluid
        expensive
        placeholder="Search for..."
        value={data.search}
        onChange={(v) => act('search', { search: v })}
        mb={1}
      />
      <Divider />
      <Section fill scrollable>
        {(!!data.designs?.length && (
          <LabeledList>
            {data.designs.map((design) => (
              <LabeledList.Item
                label={design.name}
                key={design.id}
                buttons={
                  !!(data.d_disk && !data.d_disk.stored) && (
                    <Button
                      icon="download"
                      onClick={() =>
                        act('copy_design', { copy_design_ID: design.id })
                      }
                    >
                      Save To Disk
                    </Button>
                  )
                }
              >
                {design.desc}
              </LabeledList.Item>
            ))}
          </LabeledList>
        )) || <Box color="warning">No designs found.</Box>}
      </Section>
    </Section>
  );
};
