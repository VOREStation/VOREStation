import { Fragment } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Input,
  LabeledList,
  Section,
  Stack,
  Table,
  Tabs,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { decodeHtmlEntities } from 'tgui-core/string';

import { CrewManifestContent } from './CrewManifest';

type Data = {
  manifest: { cat: string; elems: manifestEntry[] }[];
  station_name: string;
  mode: BooleanLike;
  printing: BooleanLike;
  have_id_slot: BooleanLike;
  have_printer: BooleanLike;
  target_name: string | null;
  target_owner: string | null;
  target_rank: string;
  scan_name: string;
  authenticated: BooleanLike;
  has_modify: BooleanLike;
  account_number: number | null;
  centcom_access: BooleanLike;
  all_centcom_access: access[];
  regions: region[] | null;
  id_rank: string | null;
  departments: {
    department_name: string;
    jobs: { display_name: string; target_rank: string; job: string }[];
  }[];
};

type manifestEntry = { name: string; rank: string; active: string };

type region = { name: string; accesses: access[] };

type access = {
  desc: string;
  ref: string;
  allowed: BooleanLike;
};

export const IdentificationComputer = () => {
  return (
    <Window width={600} height={700}>
      <Window.Content>
        <IdentificationComputerContent />
      </Window.Content>
    </Window>
  );
};

export const IdentificationComputerContent = (props) => {
  const { act, data } = useBackend<Data>();

  const { ntos } = props;

  const { mode, has_modify, printing, have_id_slot, have_printer } = data;

  let body: React.JSX.Element = (
    <IdentificationComputerAccessModification ntos={ntos} />
  );
  if (ntos && !have_id_slot) {
    body = <CrewManifestContent />;
  } else if (printing) {
    body = <IdentificationComputerPrinting />;
  } else if (mode === 1) {
    body = <CrewManifestContent />;
  }

  return (
    <>
      <Tabs>
        {(!ntos || !!have_id_slot) && (
          <Tabs.Tab
            icon="home"
            selected={mode === 0}
            onClick={() => act('mode', { mode_target: 0 })}
          >
            Access Modification
          </Tabs.Tab>
        )}
        <Tabs.Tab
          icon="home"
          selected={mode === 1}
          onClick={() => act('mode', { mode_target: 1 })}
        >
          Crew Manifest
        </Tabs.Tab>
        {!ntos ||
          (!!have_printer && (
            <Tabs.Tab
              style={{
                float: 'right',
              }}
              icon="print"
              onClick={() => (mode || has_modify) && act('print')}
              color={!mode && !has_modify ? 'transparent' : ''}
            >
              Print
            </Tabs.Tab>
          ))}
      </Tabs>
      {body}
    </>
  );
};

export const IdentificationComputerPrinting = (props) => {
  return <Section title="Printing">Please wait...</Section>;
};

export const IdentificationComputerAccessModification = (props: {
  ntos: boolean;
}) => {
  const { act, data } = useBackend<Data>();

  const { ntos } = props;

  const {
    station_name,
    target_name,
    target_owner = '',
    scan_name,
    authenticated,
    has_modify,
    account_number = '',
    centcom_access,
    all_centcom_access,
    id_rank,
    departments,
  } = data;

  return (
    <Section title="Access Modification" scrollable fill height="92%">
      {!authenticated && (
        <Box italic mb={1}>
          Please insert the IDs into the terminal to proceed.
        </Box>
      )}
      <LabeledList>
        <LabeledList.Item label="Target Identitity">
          <Button icon="eject" fluid onClick={() => act('modify')}>
            {target_name}
          </Button>
        </LabeledList.Item>
        {!ntos && (
          <LabeledList.Item label="Authorized Identitity">
            <Button icon="eject" fluid onClick={() => act('scan')}>
              {scan_name}
            </Button>
          </LabeledList.Item>
        )}
      </LabeledList>
      {!!authenticated && !!has_modify && (
        <>
          <Section title="Details">
            <LabeledList>
              <LabeledList.Item label="Registered Name">
                <Input
                  updateOnPropsChange
                  value={target_owner!}
                  fluid
                  onInput={(e, val) => act('reg', { reg: val })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Account Number">
                <Input
                  updateOnPropsChange
                  value={account_number!}
                  fluid
                  onInput={(e, val) => act('account', { account: val })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Dismissals">
                <Button.Confirm
                  color="bad"
                  icon="exclamation-triangle"
                  confirmIcon="fire"
                  fluid
                  confirmContent={
                    'You are dismissing ' + target_owner + ', confirm?'
                  }
                  onClick={() => act('terminate')}
                >
                  {'Dismiss ' + target_owner}
                </Button.Confirm>
              </LabeledList.Item>
            </LabeledList>
          </Section>
          <Section title="Assignment">
            <Table>
              {departments.map((dept) => (
                <Fragment key={dept.department_name}>
                  <Table.Row>
                    <Table.Cell header verticalAlign="middle">
                      {dept.department_name}
                    </Table.Cell>
                    <Table.Cell>
                      {dept.jobs.map((job) => (
                        <Button
                          key={job.job}
                          selected={job.job === id_rank}
                          onClick={() =>
                            act('assign', { assign_target: job.job })
                          }
                        >
                          {decodeHtmlEntities(job.display_name)}
                        </Button>
                      ))}
                    </Table.Cell>
                  </Table.Row>
                  <Box mt={-1}>&nbsp;</Box>{' '}
                  {/* Hacky little thing to add spacing */}
                </Fragment>
              ))}
              <Table.Row>
                <Table.Cell header verticalAlign="middle">
                  Special
                </Table.Cell>
                <Table.Cell>
                  <Button
                    onClick={() => act('assign', { assign_target: 'Custom' })}
                  >
                    Custom
                  </Button>
                </Table.Cell>
              </Table.Row>
            </Table>
          </Section>
          {(!!centcom_access && (
            <Section title="Central Command">
              {all_centcom_access.map((access) => (
                <Box key={access.ref}>
                  <Button
                    fluid
                    selected={access.allowed}
                    onClick={() =>
                      act('access', {
                        access_target: access.ref,
                        allowed: access.allowed,
                      })
                    }
                  >
                    {decodeHtmlEntities(access.desc)}
                  </Button>
                </Box>
              ))}
            </Section>
          )) || (
            <Section title={station_name}>
              <IdentificationComputerRegions actName="access" />
            </Section>
          )}
        </>
      )}
    </Section>
  );
};

export const IdentificationComputerRegions = (props: { actName: string }) => {
  const { act, data } = useBackend<Data>();

  const { actName } = props;

  const { regions } = data;

  if (regions) {
    regions.sort((a, b) => a.name.localeCompare(b.name));

    for (const region of regions) {
      region.accesses.sort((a, b) => a.desc.localeCompare(b.desc));
    }
  }

  return (
    <Stack wrap="wrap">
      {regions &&
        regions.map((region) => (
          <Stack.Item mb={1} basis="content" grow key={region.name}>
            <Section title={region.name} height="100%">
              {region.accesses.map((access) => (
                <Box key={access.ref}>
                  <Button
                    fluid
                    selected={access.allowed}
                    onClick={() =>
                      act(actName, {
                        access_target: access.ref,
                        allowed: access.allowed,
                      })
                    }
                  >
                    {decodeHtmlEntities(access.desc)}
                  </Button>
                </Box>
              ))}
            </Section>
          </Stack.Item>
        ))}
    </Stack>
  );
};
