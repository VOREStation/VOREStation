import { useBackend } from '../../backend';
import { Box, Button, Input, LabeledList, Section } from '../../components';
import { paginationTitle } from './constants';
import { PaginationChevrons } from './ResearchConsoleBuildMenu';
import { Data } from './types';

export const ResearchConsoleViewDesigns = (props) => {
  const { act, data } = useBackend<Data>();

  const { designs } = data;

  return (
    <Section
      title={paginationTitle(
        'Researched Technologies & Designs',
        data['design_page'],
      )}
      buttons={
        <>
          <Button icon="print" onClick={() => act('print', { print: 2 })}>
            Print This Page
          </Button>
          {<PaginationChevrons target={'design_page'} /> || null}
        </>
      }
    >
      <Input
        fluid
        placeholder="Search for..."
        value={data.search}
        onInput={(e, v: string) => act('search', { search: v })}
        mb={1}
      />
      {(designs && designs.length && (
        <LabeledList>
          {designs.map((design) => (
            <LabeledList.Item label={design.name} key={design.name}>
              {design.desc}
            </LabeledList.Item>
          ))}
        </LabeledList>
      )) || <Box color="warning">No designs found.</Box>}
    </Section>
  );
};
