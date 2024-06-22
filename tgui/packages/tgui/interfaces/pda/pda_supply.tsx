import { useBackend } from '../../backend';
import { Box, LabeledList, Section } from '../../components';

type Data = {
  supply: {
    shuttle_moving: number;
    shuttle_eta: number;
    shuttle_loc: string;
    approved: {
      Number: number;
      Name: string;
      ApprovedBy: string;
      Comment: string;
    }[];
    requests: {
      Number: string;
      Name: string;
      OrderedBy: string;
      Comment: string;
    }[];
  };
};

export const pda_supply = (props) => {
  const { act, data } = useBackend<Data>();

  const { supply } = data;

  return (
    <Box>
      <LabeledList>
        <LabeledList.Item label="Location">
          {supply.shuttle_moving
            ? 'Moving to station ' + supply.shuttle_eta
            : 'Shuttle at ' + supply.shuttle_loc}
        </LabeledList.Item>
      </LabeledList>
      <Section>
        <Box color="good" bold>
          Current Approved Orders
        </Box>
        {(supply.approved.length &&
          supply.approved.map((crate) => (
            <Box key={crate.Number} color="average">
              #{crate.Number} - {crate.Name} approved by {crate.ApprovedBy}
              <br />
              {crate.Comment}
            </Box>
          ))) || <Box>None!</Box>}
        <Box color="good" bold>
          Current Requested Orders
        </Box>
        {(supply.requests.length &&
          supply.requests.map((crate) => (
            <Box key={crate.Number} color="average">
              #{crate.Number} - {crate.Name} requested by {crate.OrderedBy}
              <br />
              {crate.Comment}
            </Box>
          ))) || <Box>None!</Box>}
      </Section>
    </Box>
  );
};
