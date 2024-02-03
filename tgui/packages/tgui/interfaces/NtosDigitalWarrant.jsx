import { useBackend } from '../backend';
import { Button, LabeledList, Section, Table } from '../components';
import { NtosWindow } from '../layouts';
import { filter } from 'common/collections';
import { Fragment } from 'inferno';

export const NtosDigitalWarrant = (props) => {
  const { act, data } = useBackend();

  const { warrantname, warrantcharges, warrantauth, type, allwarrants } = data;

  let body = <AllWarrants />;

  if (warrantauth) {
    body = <ActiveWarrant />;
  }

  return (
    <NtosWindow width={500} height={350} resizable>
      <NtosWindow.Content scrollable>{body}</NtosWindow.Content>
    </NtosWindow>
  );
};

const AllWarrants = (props) => {
  const { act, data } = useBackend();

  const { allwarrants } = data;

  return (
    <Section title="Warrants">
      <Button icon="plus" fluid onClick={() => act('addwarrant')}>
        Create New Warrant
      </Button>
      <Section level={2} title="Arrest Warrants">
        <WarrantList type="arrest" />
      </Section>
      <Section level={2} title="Search Warrants">
        <WarrantList type="search" />
      </Section>
    </Section>
  );
};

const WarrantList = (props) => {
  const { act, data } = useBackend();

  const { type } = props;

  const { allwarrants } = data;

  const ourWarrants = filter((w) => w.arrestsearch === type)(allwarrants);

  return (
    <Table>
      <Table.Row header>
        <Table.Cell>{type === 'arrest' ? 'Name' : 'Location'}</Table.Cell>
        <Table.Cell>{type === 'arrest' ? 'Charges' : 'Reason'}</Table.Cell>
        <Table.Cell>Authorized By</Table.Cell>
        <Table.Cell collapsing>Edit</Table.Cell>
      </Table.Row>
      {(ourWarrants.length &&
        ourWarrants.map((warrant) => (
          <Table.Row key={warrant.id}>
            <Table.Cell>{warrant.warrantname}</Table.Cell>
            <Table.Cell>{warrant.charges}</Table.Cell>
            <Table.Cell>{warrant.auth}</Table.Cell>
            <Table.Cell collapsing>
              <Button
                icon="pen"
                onClick={() => act('editwarrant', { id: warrant.id })}
              />
            </Table.Cell>
          </Table.Row>
        ))) || (
        <Table.Row>
          <Table.Cell colspan="3" color="bad">
            No {type} warrants found.
          </Table.Cell>
        </Table.Row>
      )}
    </Table>
  );
};

const ActiveWarrant = (props) => {
  const { act, data } = useBackend();

  const { warrantname, warrantcharges, warrantauth, type } = data;

  const isArrest = type === 'arrest';

  const warrantnameLabel = type === 'arrest' ? 'Name' : 'Location';
  const warrantchargesLabel = type === 'arrest' ? 'Charges' : 'Reason';

  return (
    <Section
      title={isArrest ? 'Editing Arrest Warrant' : 'Editing Search Warrant'}
      buttons={
        <Fragment>
          <Button icon="save" onClick={() => act('savewarrant')}>
            Save
          </Button>
          <Button color="bad" icon="trash" onClick={() => act('deletewarrant')}>
            Delete
          </Button>
          <Button icon="undo" onClick={() => act('back')}>
            Back
          </Button>
        </Fragment>
      }>
      <LabeledList>
        <LabeledList.Item
          label={warrantnameLabel}
          buttons={
            (isArrest && (
              <Fragment>
                <Button icon="search" onClick={() => act('editwarrantname')} />
                <Button
                  icon="pen"
                  onClick={() => act('editwarrantnamecustom')}
                />
              </Fragment>
            )) || (
              <Button icon="pen" onClick={() => act('editwarrantnamecustom')} />
            )
          }>
          {warrantname}
        </LabeledList.Item>
        <LabeledList.Item
          label={warrantchargesLabel}
          buttons={
            <Button icon="pen" onClick={() => act('editwarrantcharges')} />
          }>
          {warrantcharges}
        </LabeledList.Item>
        <LabeledList.Item
          label="Authorized By"
          buttons={
            <Button
              icon="balance-scale"
              onClick={() => act('editwarrantauth')}
            />
          }>
          {warrantauth}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
