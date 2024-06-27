import { BooleanLike } from 'common/react';

import { useBackend, useSharedState } from '../backend';
import {
  Button,
  Input,
  LabeledList,
  NoticeBox,
  Section,
  Table,
  Tabs,
} from '../components';
import { Window } from '../layouts';

type Data = {
  ion_law_nr: string;
  ion_law: string;
  zeroth_law: string;
  inherent_law: string;
  supplied_law: string;
  supplied_law_position: number;
  zeroth_laws: law[];
  ion_laws: law[];
  inherent_laws: law[];
  supplied_laws: law[];
  has_zeroth_laws: number;
  has_ion_laws: number;
  has_inherent_laws: number;
  has_supplied_laws: number;
  isAI: BooleanLike;
  isMalf: BooleanLike;
  isSlaved: BooleanLike;
  isAdmin: BooleanLike;
  channel: string;
  channels: { channel: string }[];
  law_sets: law_pack[];
};

type law_pack = {
  name: string;
  header: string;
  ref: string;
  laws: {
    zeroth_laws: law[];
    has_zeroth_laws: number;
    ion_laws: law[];
    has_ion_laws: number;
    inherent_laws: law[];
    has_inherent_laws: number;
    supplied_laws: law[];
    has_supplied_laws: number;
  };
};

type law = {
  law: string;
  index: number;
  state: number;
  ref: string;
  zero: boolean; // Local UI var
};

export const LawManager = (props) => {
  const { data } = useBackend<Data>();

  const { isSlaved } = data;

  return (
    <Window width={800} height={600}>
      <Window.Content scrollable>
        {isSlaved ? <NoticeBox info>Law-synced to {isSlaved}</NoticeBox> : ''}
        <LawManagerContent />
      </Window.Content>
    </Window>
  );
};

const LawManagerContent = (props) => {
  const [tabIndex, setTabIndex] = useSharedState<number>('lawsTabIndex', 0);

  const tab: React.JSX.Element[] = [];

  tab[0] = <LawManagerLaws />;
  tab[1] = <LawManagerLawSets />;

  return (
    <>
      <Tabs>
        <Tabs.Tab selected={tabIndex === 0} onClick={() => setTabIndex(0)}>
          Law Management
        </Tabs.Tab>
        <Tabs.Tab selected={tabIndex === 1} onClick={() => setTabIndex(1)}>
          Law Sets
        </Tabs.Tab>
      </Tabs>
      {tab[tabIndex]}
    </>
  );
};

const LawManagerLaws = (props) => {
  const { act, data } = useBackend<Data>();

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

  let allLaws = zeroth_laws
    .map((law) => {
      law.zero = true;
      return law;
    })
    .concat(inherent_laws);

  return (
    <Section>
      {has_ion_laws ? (
        <LawsTable laws={ion_laws} title={ion_law_nr + ' Laws:'} mt={-2} />
      ) : (
        ''
      )}
      {has_zeroth_laws || has_inherent_laws ? (
        <LawsTable laws={allLaws} title="Inherent Laws" mt={-2} />
      ) : (
        ''
      )}
      {has_supplied_laws ? (
        <LawsTable laws={supplied_laws} title="Supplied Laws" mt={-2} />
      ) : (
        ''
      )}
      <Section title="Controls" mt={-2}>
        <LabeledList>
          <LabeledList.Item label="Statement Channel">
            {channels.map((chan) => (
              <Button
                key={chan.channel}
                selected={channel === chan.channel}
                onClick={() =>
                  act('law_channel', { law_channel: chan.channel })
                }
              >
                {chan.channel}
              </Button>
            ))}
          </LabeledList.Item>
          <LabeledList.Item label="State Laws">
            <Button icon="volume-up" onClick={() => act('state_laws')}>
              State Laws
            </Button>
          </LabeledList.Item>
          {isAI ? (
            <LabeledList.Item label="Law Notification">
              <Button icon="exclamation" onClick={() => act('notify_laws')}>
                Notify
              </Button>
            </LabeledList.Item>
          ) : (
            ''
          )}
        </LabeledList>
      </Section>
      {isMalf ? (
        <Section title="Add Laws" mt={-2}>
          <Table>
            <Table.Row header>
              <Table.Cell collapsing>Type</Table.Cell>
              <Table.Cell>Law</Table.Cell>
              <Table.Cell collapsing>Index</Table.Cell>
              <Table.Cell collapsing>Add</Table.Cell>
            </Table.Row>
            {isAdmin && !has_zeroth_laws ? (
              <Table.Row>
                <Table.Cell collapsing>Zero</Table.Cell>
                <Table.Cell>
                  <Input
                    value={zeroth_law}
                    fluid
                    onChange={(e, val: string) =>
                      act('change_zeroth_law', { val: val })
                    }
                  />
                </Table.Cell>
                <Table.Cell>N/A</Table.Cell>
                <Table.Cell collapsing>
                  <Button icon="plus" onClick={() => act('add_zeroth_law')}>
                    Add
                  </Button>
                </Table.Cell>
              </Table.Row>
            ) : (
              ''
            )}
            <Table.Row>
              <Table.Cell collapsing>Ion</Table.Cell>
              <Table.Cell>
                <Input
                  value={ion_law}
                  fluid
                  onChange={(e, val: string) =>
                    act('change_ion_law', { val: val })
                  }
                />
              </Table.Cell>
              <Table.Cell>N/A</Table.Cell>
              <Table.Cell collapsing>
                <Button icon="plus" onClick={() => act('add_ion_law')}>
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
                  onChange={(e, val: string) =>
                    act('change_inherent_law', { val: val })
                  }
                />
              </Table.Cell>
              <Table.Cell>N/A</Table.Cell>
              <Table.Cell>
                <Button icon="plus" onClick={() => act('add_inherent_law')}>
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
                  onChange={(e, val: string) =>
                    act('change_supplied_law', { val: val })
                  }
                />
              </Table.Cell>
              <Table.Cell>
                <Button
                  icon="pen"
                  onClick={() => act('change_supplied_law_position')}
                >
                  {supplied_law_position}
                </Button>
              </Table.Cell>
              <Table.Cell>
                <Button icon="plus" onClick={() => act('add_supplied_law')}>
                  Add
                </Button>
              </Table.Cell>
            </Table.Row>
          </Table>
        </Section>
      ) : (
        ''
      )}
    </Section>
  );
};

const LawsTable = (props: {
  title: string;
  noButtons?: BooleanLike;
  [rest: string]: any;
}) => {
  const { act, data } = useBackend<Data>();

  const { isMalf, isAdmin } = data;

  const { laws, title, noButtons, ...rest } = props;

  return (
    <Section title={title} {...rest}>
      <Table>
        <Table.Row header>
          <Table.Cell collapsing>Index</Table.Cell>
          <Table.Cell>Law</Table.Cell>
          {!noButtons ? <Table.Cell collapsing>State</Table.Cell> : ''}
          {isMalf && !noButtons ? (
            <>
              <Table.Cell collapsing>Edit</Table.Cell>
              <Table.Cell collapsing>Delete</Table.Cell>
            </>
          ) : (
            ''
          )}
        </Table.Row>
        {laws.map((law: law) => (
          <Table.Row key={law.index}>
            <Table.Cell collapsing>{law.index}.</Table.Cell>
            <Table.Cell color={law.zero ? 'bad' : undefined}>
              {law.law}
            </Table.Cell>
            {!noButtons ? (
              <Table.Cell collapsing>
                <Button
                  fluid
                  icon="volume-up"
                  selected={law.state}
                  onClick={() =>
                    act('state_law', { ref: law.ref, state_law: !law.state })
                  }
                >
                  {law.state ? 'Yes' : 'No'}
                </Button>
              </Table.Cell>
            ) : (
              ''
            )}
            {isMalf && !noButtons ? (
              <>
                <Table.Cell collapsing>
                  <Button
                    disabled={law.zero && !isAdmin}
                    icon="pen"
                    onClick={() => act('edit_law', { edit_law: law.ref })}
                  >
                    Edit
                  </Button>
                </Table.Cell>
                <Table.Cell collapsing>
                  <Button
                    disabled={law.zero && !isAdmin}
                    color="bad"
                    icon="trash"
                    onClick={() => act('delete_law', { delete_law: law.ref })}
                  >
                    Delete
                  </Button>
                </Table.Cell>
              </>
            ) : (
              ''
            )}
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

const LawManagerLawSets = (props) => {
  const { act, data } = useBackend<Data>();

  const { isMalf, law_sets, ion_law_nr } = data;

  return (
    <>
      <NoticeBox>
        Remember: Stating laws other than those currently loaded may be grounds
        for decommissioning! - NanoTrasen
      </NoticeBox>
      {law_sets.length
        ? law_sets.map((laws) => (
            <Section
              key={laws.name}
              title={laws.name}
              buttons={
                <>
                  <Button
                    disabled={!isMalf}
                    icon="sync"
                    onClick={() =>
                      act('transfer_laws', { transfer_laws: laws.ref })
                    }
                  >
                    Load Laws
                  </Button>
                  <Button
                    icon="volume-up"
                    onClick={() =>
                      act('state_law_set', { state_law_set: laws.ref })
                    }
                  >
                    State Laws
                  </Button>
                </>
              }
            >
              {laws.laws.has_ion_laws ? (
                <LawsTable
                  noButtons
                  laws={laws.laws.ion_laws}
                  title={ion_law_nr + ' Laws:'}
                />
              ) : (
                ''
              )}
              {laws.laws.has_zeroth_laws || laws.laws.has_inherent_laws ? (
                <LawsTable
                  noButtons
                  laws={laws.laws.zeroth_laws.concat(laws.laws.inherent_laws)}
                  title={laws.header}
                />
              ) : (
                ''
              )}
              {laws.laws.has_supplied_laws ? (
                <LawsTable
                  noButtons
                  laws={laws.laws.supplied_laws}
                  title="Supplied Laws"
                />
              ) : (
                ''
              )}
            </Section>
          ))
        : ''}
    </>
  );
};
