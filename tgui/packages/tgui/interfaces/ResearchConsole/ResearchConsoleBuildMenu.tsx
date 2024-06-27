import { Fragment } from 'react';

import { useBackend } from '../../backend';
import { Box, Button, Divider, Flex, Input, Section } from '../../components';
import { paginationTitle } from './constants';
import { Data, design } from './types';

export const ResearchConsoleBuildMenu = (props) => {
  const { act, data } = useBackend<Data>();

  const { target, designs, buildName, buildFiveName } = props;

  if (!target) {
    return <Box color="bad">Error</Box>;
  }

  return (
    <Section
      title={paginationTitle('Designs', data['builder_page'])}
      buttons={<PaginationChevrons target={'builder_page'} />}
    >
      <Input
        fluid
        placeholder="Search for..."
        value={data.search}
        onInput={(e, v: string) => act('search', { search: v })}
        mb={1}
      />
      {designs && designs.length ? (
        designs.map((design: design) => (
          <Fragment key={design.id}>
            <Flex width="100%" justify="space-between">
              <Flex.Item width="40%" style={{ 'word-wrap': 'break-all' }}>
                {design.name}
              </Flex.Item>
              <Flex.Item width="15%" textAlign="center">
                <Button
                  mb={-1}
                  icon="wrench"
                  onClick={() =>
                    act(buildName, { build: design.id, imprint: design.id })
                  }
                >
                  Build
                </Button>
                {buildFiveName && (
                  <Button
                    mb={-1}
                    onClick={() =>
                      act(buildFiveName, {
                        build: design.id,
                        imprint: design.id,
                      })
                    }
                  >
                    x5
                  </Button>
                )}
              </Flex.Item>
              <Flex.Item width="45%" style={{ 'word-wrap': 'break-all' }}>
                <Box inline color="label">
                  {design.mat_list.join(' ')}
                </Box>
                <Box inline color="average" ml={1}>
                  {design.chem_list.join(' ')}
                </Box>
              </Flex.Item>
            </Flex>
            <Divider />
          </Fragment>
        ))
      ) : (
        <Box>
          No items could be found matching the parameters (page or search).
        </Box>
      )}
    </Section>
  );
};

export const PaginationChevrons = (props: { target: string }) => {
  const { act } = useBackend();

  const { target } = props;

  return (
    <>
      <Button icon="undo" onClick={() => act(target, { reset: true })} />
      <Button
        icon="chevron-left"
        onClick={() => act(target, { reverse: -1 })}
      />
      <Button
        icon="chevron-right"
        onClick={() => act(target, { reverse: 1 })}
      />
    </>
  );
};
