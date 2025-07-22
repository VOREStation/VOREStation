import { useBackend } from 'tgui/backend';
import { Box, Button, Divider, Stack, Table } from 'tgui-core/components';

import { getBoxColor } from '../../functions';
import type { Data, DatabaseRecord } from '../../types';

// This list is of the format: banid, bantime, bantype, reason, job, duration, expiration,
//     ckey, ackey, unbanned, unbanckey, unbantime, edits, ip, cid
export const DatabaseEntry = (props: { databaseRecord: DatabaseRecord }) => {
  const { act } = useBackend<Data>();

  const { databaseRecord } = props;

  const { data_list, auto } = databaseRecord;

  const [
    banid,
    bantime,
    bantype,
    reason,
    job,
    duration,
    expiration,
    ckey,
    ackey,
    unbanned,
    unbanckey,
    unbantime,
    edits,
    ip,
    cid,
  ] = data_list;

  return (
    <>
      <Table.Row backgroundColor={getBoxColor(!!unbanned, !!auto)[0]}>
        <Table.Cell
          align="center"
          collapsing
          color={bantype === 'PERMABAN' ? 'red' : undefined}
        >
          <Stack vertical>
            <Stack.Item>{bantype}</Stack.Item>
            {(bantype === 'JOB_PERMABAN' || bantype === 'JOB_TEMPBAN') && (
              <Stack.Item>{job}</Stack.Item>
            )}
            {(bantype === 'TEMPBAN' || bantype === 'JOB_TEMPBAN') && (
              <Stack.Item>
                <Stack>
                  <Stack.Item>{`(${duration} minutes)`}</Stack.Item>
                  <Stack.Item>
                    {`Expire${!duration || auto ? 'd' : 's'} ${expiration}`}
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            )}
          </Stack>
        </Table.Cell>
        <Table.Cell align="center">{ckey}</Table.Cell>
        <Table.Cell align="center">{ip}</Table.Cell>
        <Table.Cell align="center">{cid}</Table.Cell>
        <Table.Cell align="center">{bantime}</Table.Cell>
        <Table.Cell align="center">{ackey}</Table.Cell>
        <Table.Cell collapsing align="center">
          <Stack>
            {!!duration && !auto && bantype === 'TEMPBAN' && (
              <Stack.Item>
                <Button
                  onClick={() =>
                    act('banEdit', { action: 'duration', banid: banid })
                  }
                >
                  Duration
                </Button>
              </Stack.Item>
            )}
            {!unbanned && !auto && (
              <Stack.Item>
                <Button
                  onClick={() =>
                    act('banEdit', { action: 'reason', banid: banid })
                  }
                >
                  Reason
                </Button>
              </Stack.Item>
            )}
            {!unbanned && !auto && (
              <Stack.Item>
                <Button
                  onClick={() =>
                    act('banEdit', { action: 'unban', banid: banid })
                  }
                >
                  Unban
                </Button>
              </Stack.Item>
            )}
          </Stack>
        </Table.Cell>
      </Table.Row>
      <Table.Row backgroundColor={getBoxColor(!!unbanned, !!auto)[1]}>
        <Table.Cell colSpan={7}>
          <Stack vertical>
            <Stack.Item>
              <Stack>
                <Stack.Item>Reason:</Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Box italic>{`"${reason}"`}</Box>
            </Stack.Item>
          </Stack>
        </Table.Cell>
      </Table.Row>
      {!!edits && (
        <>
          <Table.Row backgroundColor={getBoxColor(!!unbanned, !!auto)[0]}>
            <Table.Cell colSpan={7}>
              <Box bold>EDITS</Box>
            </Table.Cell>
          </Table.Row>
          <Table.Row backgroundColor={getBoxColor(!!unbanned, !!auto)[1]}>
            <Table.Cell colSpan={7}>
              {/* eslint-disable-next-line react/no-danger*/}
              <div dangerouslySetInnerHTML={{ __html: edits }} />
            </Table.Cell>
          </Table.Row>
        </>
      )}
      {unbanned ? (
        <Table.Row backgroundColor={getBoxColor(!!unbanned, !!auto)[0]}>
          <Table.Cell colSpan={7}>
            <Box bold>{`UNBANNED by admin ${unbanckey} on ${unbantime}`}</Box>
          </Table.Cell>
        </Table.Row>
      ) : (
        !!auto && (
          <Table.Row backgroundColor={getBoxColor(!!unbanned, !!auto)[0]}>
            <Table.Cell colSpan={7}>
              <Box bold>{`EXPIRED at ${expiration}`}</Box>
            </Table.Cell>
          </Table.Row>
        )
      )}
      <Table.Row>
        <Table.Cell colSpan={7}>
          <Divider />
        </Table.Cell>
      </Table.Row>
    </>
  );
};
