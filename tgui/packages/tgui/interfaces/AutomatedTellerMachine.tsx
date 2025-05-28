import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  DmIcon,
  Icon,
  Input,
  LabeledList,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';

export type Transaction = {
  date: string;
  time: number;
  target_name: string;
  purpose: string;
  amount: number;
  source_terminal: string;
};

export type Account = {
  owner_name: string;
  money: number;
  security_level: number;
  transactions: Transaction[];
};

export type AutomatedTellerMachineData = {
  machine_id: string;
  emagged: number;
  held_card: string | null;
  locked_down: number;
  suspended: boolean;
  authenticated_account: Account;
};

export const AutomatedTellerMachine = (props) => {
  const { act, data } = useBackend<AutomatedTellerMachineData>();

  return (
    <Window width={680} height={550}>
      <Window.Content>
        <Section title={'Automatic Teller Machine - ' + data.machine_id} fill>
          {data.authenticated_account ? (
            <AuthenticatedScreen />
          ) : (
            <LoginScreen machine_id={data.machine_id} card={data.held_card} />
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

enum Menu {
  Main = 'main',
  Withdraw = 'withdraw',
  Balance = 'balance',
  Transfer = 'transfer',
  More = 'more',
}

const AuthenticatedScreen = (props) => {
  const [menu, setMenu] = useState(Menu.Main);

  switch (menu) {
    case Menu.Main: {
      return <MainMenu setMenu={setMenu} />;
    }
    case Menu.Withdraw: {
      return <WithdrawMenu setMenu={setMenu} />;
    }
    case Menu.Balance: {
      return <BalanceMenu setMenu={setMenu} />;
    }
    case Menu.Transfer: {
      return <TransferMenu setMenu={setMenu} />;
    }
    case Menu.More: {
      return <MoreMenu setMenu={setMenu} />;
    }
  }
};

const MainMenu = (props: {
  setMenu: React.Dispatch<React.SetStateAction<Menu>>;
}) => {
  const { setMenu } = props;
  const { act, data } = useBackend<AutomatedTellerMachineData>();

  return (
    <Stack fill fontSize={2}>
      <Stack.Item grow>
        <Stack vertical fill>
          <Stack.Item>
            <Button fluid onClick={() => setMenu(Menu.Withdraw)}>
              <Icon name="money-bill-wave" width={2} mr={2} />
              Withdraw
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button fluid onClick={() => setMenu(Menu.More)}>
              <Icon name="bars" width={2} mr={2} />
              More Services
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item grow textAlign="right">
        <Stack vertical fill>
          <Stack.Item>
            <Button fluid onClick={() => setMenu(Menu.Balance)}>
              Balance
              <Icon name="dollar-sign" width={2} ml={2} />
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button fluid onClick={() => setMenu(Menu.Transfer)}>
              Transfer
              <Icon name="money-check-alt" width={2} ml={2} />
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button fluid onClick={() => act('logout')}>
              {data.held_card ? 'Return Card' : 'Logout'}
              <Icon name="sign-out-alt" width={2} ml={2} />
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const WithdrawMenu = (props: {
  setMenu: React.Dispatch<React.SetStateAction<Menu>>;
}) => {
  const { act, data } = useBackend<AutomatedTellerMachineData>();
  const { setMenu } = props;
  const [custom, setCustom] = useState(false);
  const [useCard, setUseCard] = useState(false);

  const withdrawFunction = (val) => {
    if (useCard) {
      act('e_withdrawal', { funds_amount: val });
    } else {
      act('withdrawal', { funds_amount: val });
    }
    setMenu(Menu.Main);
  };

  if (custom) {
    return (
      <CustomWithdrawal
        withdrawFunction={withdrawFunction}
        useCard={useCard}
        setCustom={setCustom}
        setMenu={setMenu}
      />
    );
  }

  return (
    <Section
      title="Withdrawals"
      buttons={
        <Button icon="arrow-left" onClick={() => setMenu(Menu.Main)}>
          Back To Main Menu
        </Button>
      }
    >
      <Box fontSize={2} mb={1}>
        Account Balance: ${data.authenticated_account.money}
      </Box>
      <Box fontSize={2} mb={4}>
        <Stack align="center">
          <Stack.Item grow>
            <Button
              fluid
              icon="money-bill-wave"
              selected={!useCard}
              onClick={() => setUseCard(false)}
            >
              Cash
            </Button>
          </Stack.Item>
          <Stack.Item grow>
            <Button
              fluid
              icon="credit-card"
              selected={useCard}
              onClick={() => setUseCard(true)}
            >
              Chargecard
            </Button>
          </Stack.Item>
        </Stack>
      </Box>
      <Stack fontSize={2}>
        <Stack.Item grow>
          <Stack vertical fill>
            <Stack.Item>
              <Button fluid onClick={() => withdrawFunction(10)}>
                $10
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button fluid onClick={() => withdrawFunction(100)}>
                $100
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button fluid onClick={() => withdrawFunction(500)}>
                $500
              </Button>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow textAlign="right">
          <Stack vertical fill>
            <Stack.Item>
              <Button fluid onClick={() => withdrawFunction(50)}>
                $50
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button fluid onClick={() => withdrawFunction(200)}>
                $200
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button fluid onClick={() => setCustom(true)}>
                Other
              </Button>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const CustomWithdrawal = (props: {
  withdrawFunction: (val: number) => void;
  useCard: boolean;
  setCustom: React.Dispatch<React.SetStateAction<boolean>>;
  setMenu: React.Dispatch<React.SetStateAction<Menu>>;
}) => {
  const { act, data } = useBackend<AutomatedTellerMachineData>();
  const { withdrawFunction, useCard, setCustom, setMenu } = props;
  const [money, setMoney] = useState(1000);
  return (
    <Section
      title="Withdrawal"
      buttons={
        <Button icon="arrow-left" onClick={() => setCustom(false)}>
          Back To Withdrawals
        </Button>
      }
      fill
    >
      <Stack
        align="center"
        justify="center"
        fill
        fontSize={4}
        textAlign="center"
      >
        <Stack.Item>
          <Stack vertical>
            <Stack.Item fontSize={3}>
              Available: ${data.authenticated_account.money}
            </Stack.Item>
            <Stack.Item>
              <Input
                fluid
                value={money.toString()}
                maxLength={10}
                onChange={(val) => {
                  const value = parseInt(val, 10);
                  if (isNaN(value)) {
                    setMoney(0);
                  } else {
                    setMoney(value);
                  }
                }}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon={useCard ? 'credit-card' : 'money-bill-wave'}
                fluid
                fontSize={3}
                onClick={() => withdrawFunction(money)}
              >
                {useCard ? 'Load' : 'Withdraw'} ${money}
              </Button>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const BalanceMenu = (props: {
  setMenu: React.Dispatch<React.SetStateAction<Menu>>;
}) => {
  const { act, data } = useBackend<AutomatedTellerMachineData>();
  const { setMenu } = props;
  return (
    <Section
      title="Balance"
      buttons={
        <Button icon="arrow-left" onClick={() => setMenu(Menu.Main)}>
          Back To Main Menu
        </Button>
      }
      fill
    >
      <Stack justify="space-between">
        <Stack.Item>
          <Box fontSize={1.5} mb={1}>
            Current Funds: ${data.authenticated_account.money}
          </Box>
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="money-bill-alt"
            onClick={() => act('balance_statement')}
          >
            Print Balance Statement
          </Button>
          <Button icon="money-check" onClick={() => act('print_transaction')}>
            Print Transactions
          </Button>
        </Stack.Item>
      </Stack>
      <TransactionLog transactions={data.authenticated_account.transactions} />
    </Section>
  );
};

const TransactionLog = (props: { transactions: Transaction[] }) => {
  const { transactions } = props;

  return (
    <Section fill scrollable height="95%">
      <Table collapsing={false} className="AutomatedTellerMachine__Table">
        <Table.Row header>
          <Table.Cell header>Date</Table.Cell>
          <Table.Cell header>Time</Table.Cell>
          <Table.Cell header>Target</Table.Cell>
          <Table.Cell header>Purpose</Table.Cell>
          <Table.Cell header>Value</Table.Cell>
          <Table.Cell header>Source Terminal ID</Table.Cell>
        </Table.Row>
        {transactions.map((transaction, index) => (
          <Table.Row key={index}>
            <Table.Cell>{transaction.date}</Table.Cell>
            <Table.Cell>{transaction.time}</Table.Cell>
            <Table.Cell>{transaction.target_name}</Table.Cell>
            <Table.Cell>{transaction.purpose}</Table.Cell>
            <Table.Cell>${transaction.amount}</Table.Cell>
            <Table.Cell>{transaction.source_terminal}</Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

const MoreMenu = (props: {
  setMenu: React.Dispatch<React.SetStateAction<Menu>>;
}) => {
  const { act, data } = useBackend<AutomatedTellerMachineData>();
  const { setMenu } = props;
  return (
    <Section
      title="More Services"
      buttons={
        <Button icon="arrow-left" onClick={() => setMenu(Menu.Main)}>
          Back To Main Menu
        </Button>
      }
    >
      <Box fontSize={2} mb={1}>
        Account Security Settings
      </Box>
      <Button
        fluid
        style={{ whiteSpace: 'normal', wordBreak: 'break-word' }}
        selected={data.authenticated_account.security_level === 0}
        onClick={() => act('change_security_level', { new_security_level: 0 })}
      >
        Zero - Either the account number or card is required to access this
        account. EFTPOS transactions will require a card and ask for a pin, but
        not verify the pin is correct.
      </Button>
      <Button
        fluid
        style={{ whiteSpace: 'normal', wordBreak: 'break-word' }}
        selected={data.authenticated_account.security_level === 1}
        onClick={() => act('change_security_level', { new_security_level: 1 })}
      >
        One - An account number and pin must be manually entered to access this
        account and process transactions.
      </Button>
      <Button
        fluid
        style={{ whiteSpace: 'normal', wordBreak: 'break-word' }}
        selected={data.authenticated_account.security_level === 2}
        onClick={() => act('change_security_level', { new_security_level: 2 })}
      >
        Two - In addition to account number and pin, a card is required to
        access this account and process transactions.
      </Button>
    </Section>
  );
};

const TransferMenu = (props: {
  setMenu: React.Dispatch<React.SetStateAction<Menu>>;
}) => {
  const { act, data } = useBackend<AutomatedTellerMachineData>();
  const [accountNum, setAccountNum] = useState(100000);
  const updateAccountNum = (val) => {
    const newVal = parseInt(val, 10);
    if (isNaN(newVal)) {
      setAccountNum(100000);
    } else {
      setAccountNum(newVal);
    }
  };

  const [money, setMoney] = useState(0);
  const updateMoney = (val) => {
    const newVal = parseInt(val, 10);
    if (isNaN(newVal)) {
      setMoney(0);
    } else {
      setMoney(newVal);
    }
  };

  const [purpose, setPurpose] = useState('Funds transfer');

  const { setMenu } = props;
  return (
    <Section
      title="Transfer Money"
      buttons={
        <Button icon="arrow-left" onClick={() => setMenu(Menu.Main)}>
          Back To Main Menu
        </Button>
      }
      fill
      textAlign="center"
    >
      <Box fontSize={2}>
        <Box fontSize={3} mb={2}>
          Available: ${data.authenticated_account.money}
        </Box>

        <LabeledList>
          <LabeledList.Item label="Target Account Number">
            <Input
              fluid
              maxLength={6}
              value={accountNum.toString()}
              onChange={(val) => updateAccountNum(val)}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Funds To Transfer">
            <Input
              fluid
              maxLength={10}
              value={money.toString()}
              onChange={(val) => updateMoney(val)}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Transaction Purpose">
            <Input
              fluid
              maxLength={20}
              value={purpose}
              onChange={(val) => setPurpose(val)}
            />
          </LabeledList.Item>
        </LabeledList>
        <Button
          icon="exchange-alt"
          fluid
          mt={1}
          onClick={() =>
            act('transfer', {
              funds_amount: money,
              target_acc_number: accountNum,
            })
          }
        >
          Transfer Funds
        </Button>
      </Box>
    </Section>
  );
};

const LoginScreen = (props: { machine_id: string; card: string | null }) => {
  const { act } = useBackend();
  const { machine_id, card } = props;

  const [account, setAccount] = useState('');
  const [pin, setPin] = useState('');

  return (
    <Stack align="flex-start" justify="space-between" fill>
      <Stack.Item grow height="100%">
        <Stack vertical fill>
          <Stack.Item>
            <Button
              fontSize={2}
              fluid
              height={8}
              verticalAlignContent="middle"
              onClick={() => act('insert_card')}
            >
              <Stack align="center" justify="center">
                <Stack.Item>
                  <Icon name="id-card" />
                </Stack.Item>
                <Stack.Item
                  grow
                  style={{ whiteSpace: 'normal', wordBreak: 'break-word' }}
                  textAlign="center"
                >
                  {card ? card : 'Insert ID'}
                </Stack.Item>
              </Stack>
            </Button>
          </Stack.Item>
          <Stack.Item fontSize={1.5} mt={10}>
            <LabeledList>
              <LabeledList.Item label="Account">
                <Input
                  fluid
                  value={account}
                  onChange={(val) => setAccount(val)}
                />
              </LabeledList.Item>
              <LabeledList.Item label="PIN">
                <Input fluid value={pin} onChange={(val) => setPin(val)} />
              </LabeledList.Item>
            </LabeledList>
            <Button
              fontSize={4}
              fluid
              mt={2}
              textAlign="center"
              onClick={() =>
                act('attempt_auth', {
                  account_num: account,
                  account_pin: pin,
                })
              }
            >
              <Stack>
                <Stack.Item>
                  <Icon name="sign-in-alt" />
                </Stack.Item>
                <Stack.Item grow textAlign="center">
                  Log In
                </Stack.Item>
              </Stack>
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item
        ml={-5}
        mr={-5}
        onClick={() => act('insert_card')}
        style={{ cursor: 'pointer' }}
      >
        <Stack align="center" justify="center" fill vertical>
          <Stack.Item>
            <Box height={10}>
              <CardSlot />
            </Box>
          </Stack.Item>
          <Stack.Item>
            <AnimatedIDCard />
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

export const CardSlot = (props) => {
  return (
    <svg xmlns="http://www.w3.org/2000/svg" version="1.0" viewBox="0 0 100 40">
      {/* Top */}
      <rect
        rx="5"
        x="0"
        y="0"
        width="100"
        height="20"
        strokeWidth={0}
        fill="grey"
      />
      {/* Faceplate */}
      <rect x="0" y="10" width="100" height="30" fill="#aaa" />
      {/* Slot */}
      <rect
        rx="5"
        ry="5"
        x="10"
        y="25"
        width="80"
        height="10"
        fill="#000"
        stroke="#444"
      />
      {/* Arrows */}
      <polyline transform="translate(30, 15)" points="0 5, 5 0, 10 5" />
      <polyline transform="translate(60, 15)" points="0 5, 5 0, 10 5" />
      {/* Card */}
      <g transform="translate(45, 11)">
        {/* Slot */}
        <rect rx="2" x="0" y="0" width="10" height="2.5" />
        {/* Card Outline */}
        <rect
          rx="1"
          x="2"
          y="2"
          width="6"
          height="8"
          fill="transparent"
          stroke="black"
        />
        {/* Chip */}
        <rect rx="0.5" x="4" y="3" width="2" height="3" />
      </g>
    </svg>
  );
};

export const AnimatedIDCard = (props) => {
  const [glitch, setGlitch] = useState(false);

  useEffect(() => {
    if (Math.random() * 100 < 1) {
      // 1% chance
      setGlitch(true);
    }
  }, []);

  return (
    <Box
      className={
        glitch
          ? 'AutomatedTellerMachine__Card--glitch'
          : 'AutomatedTellerMachine__Card'
      }
      mt={-8}
    >
      <DmIcon
        icon="icons/obj/card_new.dmi"
        icon_state="civilian-id"
        width={32}
        height={32}
        style={{
          transform: 'rotate(90deg)',
          transformOrigin: 'center',
        }}
      />
    </Box>
  );
};
