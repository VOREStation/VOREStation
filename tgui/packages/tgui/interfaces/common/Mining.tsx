import { useBackend } from '../../backend';
import { Box, Button, NoticeBox } from '../../components';

type Data = { has_id: boolean; id: { name: string; points: number } };

export const MiningUser = (props) => {
  const { act, data } = useBackend<Data>();
  const { insertIdText } = props;
  const { has_id, id } = data;
  return (
    <NoticeBox success={has_id}>
      {has_id ? (
        <>
          <Box
            inline
            verticalAlign="middle"
            style={{
              float: 'left',
            }}
          >
            Logged in as {id.name}.<br />
            You have {id.points.toLocaleString('en-US')} points.
          </Box>
          <Button
            icon="eject"
            style={{
              float: 'right',
            }}
            onClick={() => act('logoff')}
          >
            Eject ID
          </Button>
          <Box
            style={{
              clear: 'both',
            }}
          />
        </>
      ) : (
        insertIdText
      )}
    </NoticeBox>
  );
};
