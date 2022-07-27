import { Fragment } from 'inferno';
import { useBackend, useSharedState } from "../backend";
import { Button, LabeledList, Section, Tabs, NoticeBox, Table, Input } from "../components";
import { Window } from "../layouts";

export const LawManager = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    isSlaved,
  } = data;

  return (
    <Window width={800} height={600} resizable>
      <Window.Content scrollable>
        {isSlaved && <NoticeBox info>Law-synced to {isSlaved}</NoticeBox> || null}
        <LawManagerContent />
      </Window.Content>
    </Window>
  );
};

const LawManagerContent = (props, context) => {
  const [tabIndex, setTabIndex] = useSharedState(context, 'lawsTabIndex', 0);

  return (
    <Fragment>
      <Tabs>
        <Tabs.Tab
          selected={tabIndex === 0}
          onClick={() => setTabIndex(0)}>
          Law Management
        </Tabs.Tab>
        <Tabs.Tab
          selected={tabIndex === 1}
          onClick={() => setTabIndex(1)}>
          Law Sets
        </Tabs.Tab>
      </Tabs>
      {tabIndex === 0 && <LawManagerLaws /> || null}
      {tabIndex === 1 && <LawManagerLawSets /> || null}
    </Fragment>
  );
};

const LawManagerLaws = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    ion_law_nr,
    ion_law,
    zeroth_law,
    inherent_law,
    supplied_law,
    supplied_law_position,
    zeroth_laws,
    has_zeroth_laws,
    ion_laws,
    has_ion_laws,
    inherent_laws,
    has_inherent_laws,
    supplied_laws,
    has_supplied_laws,
    isAI,
    isMalf,
    isAdmin,
    channel,
    channels,
  } = data;

  let allLaws = zeroth_laws.map(law => { law.zero = true; return law; }).concat(inherent_laws);

  return (
    <Section>
      {has_ion_laws && (
        <LawsTable laws={ion_laws} title={ion_law_nr + " Laws:"} mt={-2} />
      ) || null}
      {(has_zeroth_laws || has_inherent_laws) && (
        <LawsTable laws={allLaws} title="Inherent Laws" mt={-2} />
      ) || null}
      {has_supplied_laws && (
        <LawsTable laws={supplied_laws} title="Supplied Laws" mt={-2} />
      ) || null}
      <Section level={2} title="Controls" mt={-2}>
        <LabeledList>
          <LabeledList.Item label="Statement Channel">
            {channels.map(chan => (
              <Button
                key={chan.channel}
                content={chan.channel}
                selected={channel === chan.channel}
                onClick={() => act("law_channel", { law_channel: chan.channel })} />
            ))}
          </LabeledList.Item>
          <LabeledList.Item label="State Laws">
            <Button
              icon="volume-up"
              onClick={() => act("state_laws")}>
              State Laws
            </Button>
          </LabeledList.Item>
          {isAI && (
            <LabeledList.Item label="Law Notification">
              <Button
                icon="exclamation"
                onClick={() => act("notify_laws")}>
                Notify
              </Button>
            </LabeledList.Item>
          ) || null}
        </LabeledList>
      </Section>
      {isMalf && (
        <Section level={2} title="Add Laws" mt={-2}>
          <Table>
            <Table.Row header>
              <Table.Cell collapsing>Type</Table.Cell>
              <Table.Cell>Law</Table.Cell>
              <Table.Cell collapsing>Index</Table.Cell>
              <Table.Cell collapsing>Add</Table.Cell>
            </Table.Row>
            {isAdmin && !has_zeroth_laws && (
              <Table.Row>
                <Table.Cell collapsing>Zero</Table.Cell>
                <Table.Cell>
                  <Input
                    value={zeroth_law}
                    fluid
                    onChange={(e, val) => act("change_zeroth_law", { val: val })} />
                </Table.Cell>
                <Table.Cell>N/A</Table.Cell>
                <Table.Cell collapsing>
                  <Button icon="plus" onClick={() => act("add_zeroth_law")}>
                    Add
                  </Button>
                </Table.Cell>
              </Table.Row>
            ) || null}
            <Table.Row>
              <Table.Cell collapsing>Ion</Table.Cell>
              <Table.Cell>
                <Input
                  value={ion_law}
                  fluid
                  onChange={(e, val) => act("change_ion_law", { val: val })} />
              </Table.Cell>
              <Table.Cell>N/A</Table.Cell>
              <Table.Cell collapsing>
                <Button icon="plus" onClick={() => act("add_ion_law")}>
                  Add
                </Button>
              </Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell>Inherent</Table.Cell>
              <Table.Cell>
                <Input
                  value={inherent_law}
                  fluid
                  onChange={(e, val) => act("change_inherent_law", { val: val })} />
              </Table.Cell>
              <Table.Cell>N/A</Table.Cell>
              <Table.Cell>
                <Button icon="plus" onClick={() => act("add_inherent_law")}>
                  Add
                </Button>
              </Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell>Supplied</Table.Cell>
              <Table.Cell>
                <Input
                  value={supplied_law}
                  fluid
                  onChange={(e, val) => act("change_supplied_law", { val: val })} />
              </Table.Cell>
              <Table.Cell>
                <Button icon="pen" onClick={() => act("change_supplied_law_position")}>
                  {supplied_law_position}
                </Button>
              </Table.Cell>
              <Table.Cell>
                <Button icon="plus" onClick={() => act("add_supplied_law")}>
                  Add
                </Button>
              </Table.Cell>
            </Table.Row>
          </Table>
        </Section>
      ) || null}
    </Section>
  );
};

const LawsTable = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    isMalf,
    isAdmin,
  } = data;

  const {
    laws,
    title,
    noButtons,
    ...rest
  } = props;

  return (
    <Section level={2} title={title} {...rest}>
      <Table>
        <Table.Row header>
          <Table.Cell collapsing>Index</Table.Cell>
          <Table.Cell>Law</Table.Cell>
          {!noButtons && (
            <Table.Cell collapsing>State</Table.Cell>
          ) || null}
          {isMalf && !noButtons && (
            <Fragment>
              <Table.Cell collapsing>Edit</Table.Cell>
              <Table.Cell collapsing>Delete</Table.Cell>
            </Fragment>
          ) || null}
        </Table.Row>
        {laws.map(law => (
          <Table.Row key={law.index}>
            <Table.Cell collapsing>{law.index}.</Table.Cell>
            <Table.Cell color={law.zero ? "bad" : null}>{law.law}</Table.Cell>
            {!noButtons && (
              <Table.Cell collapsing>
                <Button
                  fluid
                  icon="volume-up"
                  selected={law.state}
                  onClick={() => act("state_law", { ref: law.ref, state_law: !law.state })}>
                  {law.state ? "Yes" : "No"}
                </Button>
              </Table.Cell>
            ) || null}
            {isMalf && !noButtons && (
              <Fragment>
                <Table.Cell collapsing>
                  <Button
                    disabled={law.zero && !isAdmin}
                    icon="pen"
                    onClick={() => act("edit_law", { edit_law: law.ref })}>
                    Edit
                  </Button>
                </Table.Cell>
                <Table.Cell collapsing>
                  <Button
                    disabled={law.zero && !isAdmin}
                    color="bad"
                    icon="trash"
                    onClick={() => act("delete_law", { delete_law: law.ref })}>
                    Delete
                  </Button>
                </Table.Cell>
              </Fragment>
            ) || null}
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};


const LawManagerLawSets = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    isMalf,
    law_sets,
  } = data;

  return (
    <Fragment>
      <NoticeBox>
        Remember: Stating laws other than those currently loaded may be grounds for decommissioning! - NanoTrasen
      </NoticeBox>
      {law_sets.length && law_sets.map(laws => (
        <Section key={laws.name} title={laws.name} buttons={
          <Fragment>
            <Button
              disabled={!isMalf}
              icon="sync"
              onClick={() => act("transfer_laws", { transfer_laws: laws.ref })}>
              Load Laws
            </Button>
            <Button
              icon="volume-up"
              onClick={() => act("state_law_set", { state_law_set: laws.ref })}>
              State Laws
            </Button>
          </Fragment>
        }>
          {laws.laws.has_ion_laws && (
            <LawsTable
              noButtons
              laws={laws.laws.ion_laws}
              title={laws.laws.ion_law_nr + " Laws:"} />
          ) || null}
          {(laws.laws.has_zeroth_laws || laws.laws.has_inherent_laws) && (
            <LawsTable
              noButtons
              laws={laws.laws.zeroth_laws.concat(laws.laws.inherent_laws)}
              title={laws.header} />
          ) || null}
          {laws.laws.has_supplied_laws && (
            <LawsTable
              noButtons
              laws={laws.laws.supplied_laws}
              title="Supplied Laws" />
          ) || null}
        </Section>
      )) || null}
    </Fragment>
  );
};
