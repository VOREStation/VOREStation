import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Button, Section, Box, Table } from '../components';
import { Window } from '../layouts';

export const PrisonerManagement = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    locked,
    chemImplants,
    trackImplants,
  } = data;
  return (
    <Window width={500} height={400} resizable>
      <Window.Content scrollable>
        {locked && (
          <Section title="Locked" textAlign="center">
            This interface is currently locked.
            <Box>
              <Button
                icon="unlock"
                onClick={() => act("lock")}>
                Unlock
              </Button>
            </Box>
          </Section>
        ) || (
          <Fragment>
            <Section title="Interface Lock" buttons={
              <Button
                icon="lock"
                onClick={() => act("lock")}>
                Lock Interface
              </Button>
            } />
            <Section title="Chemical Implants">
              {chemImplants.length && (
                <Table>
                  <Table.Row header>
                    <Table.Cell textAlign="center">Host</Table.Cell>
                    <Table.Cell textAlign="center">Units Remaining</Table.Cell>
                    <Table.Cell textAlign="center">Inject</Table.Cell>
                  </Table.Row>
                  {chemImplants.map(chem => (
                    <Table.Row key={chem.ref}>
                      <Table.Cell textAlign="center">
                        {chem.host}
                      </Table.Cell>
                      <Table.Cell textAlign="center">
                        {chem.units}u remaining
                      </Table.Cell>
                      <Table.Cell textAlign="center">
                        <Button onClick={() => act("inject", { imp: chem.ref, val: 1 })}>(1)</Button>
                        <Button onClick={() => act("inject", { imp: chem.ref, val: 5 })}>(5)</Button>
                        <Button onClick={() => act("inject", { imp: chem.ref, val: 10 })}>(10)</Button>
                      </Table.Cell>
                    </Table.Row>
                  ))}
                </Table>
              ) || (
                <Box color="average">
                  No chemical implants found.
                </Box>
              )}
            </Section>
            <Section title="Tracking Implants">
              {trackImplants.length && (
                <Table>
                  <Table.Row header>
                    <Table.Cell textAlign="center">Host</Table.Cell>
                    <Table.Cell textAlign="center">Location</Table.Cell>
                    <Table.Cell textAlign="center">Message</Table.Cell>
                  </Table.Row>
                  {trackImplants.map(track => (
                    <Table.Row key={track.ref}>
                      <Table.Cell textAlign="center">
                        {track.host} ({track.id})
                      </Table.Cell>
                      <Table.Cell textAlign="center">
                        {track.loc}
                      </Table.Cell>
                      <Table.Cell textAlign="center">
                        <Button onClick={() => act("warn", { imp: track.ref })}>Message</Button>
                      </Table.Cell>
                    </Table.Row>
                  ))}
                </Table>
              ) || (
                <Box color="average">
                  No chemical implants found.
                </Box>
              )}
            </Section>
          </Fragment>
        )}
      </Window.Content>
    </Window>
  );
};
