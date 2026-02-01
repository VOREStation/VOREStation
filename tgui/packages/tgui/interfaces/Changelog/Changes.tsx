import dateformat from 'dateformat';
import { Fragment } from 'react';
import { Box, Section, Table } from 'tgui-core/components';
import { ChangeRow } from './ChangeRow';
import type { ChangelogEntry } from './types';

export const Changes = (props: { data: ChangelogEntry | string }) => {
  const { data } = props;

  if (typeof data !== 'object' || Object.keys(data).length === 0) {
    return null;
  }

  return (
    <>
      {Object.entries(data)
        .reverse()
        .map(([date, authors]) => (
          <Section key={date} title={dateformat(date, 'd mmmm yyyy', true)}>
            <Box ml={3}>
              {Object.entries(authors).map(([name, changes]) => (
                <Fragment key={name}>
                  <h4>{name} changed:</h4>
                  <Box ml={3}>
                    <Table>
                      {changes.map((change) =>
                        Object.entries(change).map(([changeType, content]) => (
                          <ChangeRow
                            key={changeType + content}
                            kind={changeType}
                            content={content}
                          />
                        )),
                      )}
                    </Table>
                  </Box>
                </Fragment>
              ))}
            </Box>
          </Section>
        ))}
    </>
  );
};
