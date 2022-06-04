import { sortBy } from 'common/collections';
import { Fragment } from 'inferno';
import { useBackend } from "../backend";
import { Box, Button, Flex, Input, LabeledList, Section, Table, Tabs } from "../components";
import { Window } from "../layouts";
import { decodeHtmlEntities } from 'common/string';
import { CrewManifestContent } from './CrewManifest';

export const IdentificationComputer = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Window width={600} height={700}>
      <Window.Content resizable>
        <IdentificationComputerContent />
      </Window.Content>
    </Window>
  );
};

export const IdentificationComputerContent = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    ntos,
  } = props;

  const {
    mode,
    has_modify,
    printing,
  } = data;

  let body = <IdentificationComputerAccessModification ntos={ntos} />;
  if (ntos && !data.have_id_slot) {
    body = <CrewManifestContent />;
  } else if (printing) {
    body = <IdentificationComputerPrinting />;
  } else if (mode === 1) {
    body = <CrewManifestContent />;
  }

  return (
    <Fragment>
      <Tabs>
        {(!ntos || !!data.have_id_slot) && (
          <Tabs.Tab icon="home" selected={mode === 0} onClick={() => act("mode", { "mode_target": 0 })}>
            Access Modification
          </Tabs.Tab>
        )}
        <Tabs.Tab icon="home" selected={mode === 1} onClick={() => act("mode", { "mode_target": 1 })}>
          Crew Manifest
        </Tabs.Tab>
        {!ntos || !!data.have_printer && (
          <Tabs.Tab float="right" icon="print" onClick={() => act("print")} disabled={!mode && !has_modify} color="">
            Print
          </Tabs.Tab>
        )}
      </Tabs>
      {body}
    </Fragment>
  );
};

export const IdentificationComputerPrinting = (props, context) => {
  return (
    <Section title="Printing">
      Please wait...
    </Section>
  );
};

export const IdentificationComputerAccessModification = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    ntos,
  } = props;

  const {
    station_name,
    target_name,
    target_owner,
    scan_name,
    authenticated,
    has_modify,
    account_number,
    centcom_access,
    all_centcom_access,
    regions,
    id_rank,
    departments,
  } = data;

  return (
    <Section title="Access Modification">
      {!authenticated && (
        <Box italic mb={1}>
          Please insert the IDs into the terminal to proceed.
        </Box>
      )}
      <LabeledList>
        <LabeledList.Item label="Target Identitity">
          <Button
            icon="eject"
            fluid
            content={target_name}
            onClick={() => act("modify")} />
        </LabeledList.Item>
        {!ntos && (
          <LabeledList.Item label="Authorized Identitity">
            <Button
              icon="eject"
              fluid
              content={scan_name}
              onClick={() => act("scan")} />
          </LabeledList.Item>
        )}
      </LabeledList>
      {!!authenticated && !!has_modify && (
        <Fragment>
          <Section title="Details" level={2}>
            <LabeledList>
              <LabeledList.Item label="Registered Name">
                <Input
                  value={target_owner}
                  fluid
                  onInput={(e, val) => act("reg", { reg: val })} />
              </LabeledList.Item>
              <LabeledList.Item label="Account Number">
                <Input
                  value={account_number}
                  fluid
                  onInput={(e, val) => act("account", { account: val })} />
              </LabeledList.Item>
              <LabeledList.Item label="Dismissals">
                <Button.Confirm
                  color="bad"
                  icon="exclamation-triangle"
                  confirmIcon="fire"
                  fluid
                  content={"Dismiss " + target_owner}
                  confirmContent={"You are dismissing " + target_owner + ", confirm?"}
                  onClick={() => act("terminate")} />
              </LabeledList.Item>
            </LabeledList>
          </Section>
          <Section title="Assignment" level={2}>
            <Table>
              {departments.map(dept => (
                <Fragment key={dept.department_name}>
                  <Table.Row>
                    <Table.Cell header verticalAlign="middle">{dept.department_name}</Table.Cell>
                    <Table.Cell>
                      {dept.jobs.map(job => (
                        <Button
                          key={job.job}
                          selected={job.job === id_rank}
                          onClick={() => act("assign", { "assign_target": job.job })}>
                          {decodeHtmlEntities(job.display_name)}
                        </Button>
                      ))}
                    </Table.Cell>
                  </Table.Row>
                  <Box mt={-1}>&nbsp;</Box> {/* Hacky little thing to add spacing */}
                </Fragment>
              ))}
              <Table.Row>
                <Table.Cell header verticalAlign="middle">
                  Special
                </Table.Cell>
                <Table.Cell>
                  <Button
                    onClick={() => act("assign", { "assign_target": "Custom" })}>
                    Custom
                  </Button>
                </Table.Cell>
              </Table.Row>
            </Table>
          </Section>
          {!!centcom_access && (
            <Section title="Central Command" level={2}>
              {all_centcom_access.map(access => (
                <Box key={access.ref}>
                  <Button
                    fluid
                    selected={access.allowed}
                    onClick={() => act("access", { access_target: access.ref, allowed: access.allowed })}>
                    {decodeHtmlEntities(access.desc)}
                  </Button>
                </Box>
              ))}
            </Section>
          ) || (
            <Section title={station_name} level={2}>
              <IdentificationComputerRegions actName="access" />
            </Section>
          )}
        </Fragment>
      )}
    </Section>
  );
};

export const IdentificationComputerRegions = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    actName,
  } = props;

  const {
    regions,
  } = data;

  return (
    <Flex wrap="wrap" spacing={1}>
      {sortBy(r => r.name)(regions).map(region => (
        <Flex.Item mb={1} basis="content" grow={1} key={region.name}>
          <Section title={region.name} height="100%">
            {sortBy(a => a.desc)(region.accesses).map(access => (
              <Box key={access.ref}>
                <Button
                  fluid
                  selected={access.allowed}
                  onClick={() => act(actName, { access_target: access.ref, allowed: access.allowed })}>
                  {decodeHtmlEntities(access.desc)}
                </Button>
              </Box>
            ))}
          </Section>
        </Flex.Item>
      ))}
    </Flex>
  );
};
