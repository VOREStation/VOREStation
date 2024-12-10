import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Box, Button, Chart, Divider, Section, Table } from '../components';
import { Window } from '../layouts';

type Data = {
  stationName: string;
  balance: number;
  screen: string;
  viewMode: string | undefined;
  stocks:
    | {
        REF: string;
        valueChange: number;
        bankrupt: BooleanLike;
        ID: string;
        Name: string;
        Value: number;
        Owned: number;
        Avail: number;
        Unification: string;
        Products: string[];
      }[]
    | [];
  logs:
    | {
        type: string;
        time: number;
        user_name: string;
        stocks: string[];
        shareprice: number;
        money: number;
        company_name: string;
      }[]
    | [];
  name: string | undefined;
  events: { current_title: string; current_desc: string }[] | undefined;
  articles:
    | {
        headline: string;
        subtitle: string;
        article: string;
        author: string;
        spacetime: string;
        outlet: string;
      }[]
    | undefined;
  maxValue: number | undefined;
  values: number[][] | undefined;
};

export const StockExchange = (props) => {
  const { data } = useBackend<Data>();

  const { screen, stationName } = data;

  let body;
  if (screen === 'stocks') {
    body = <StockExchangeStockList />;
  } else if (screen === 'logs') {
    body = <StockExchangeLogs />;
  } else if (screen === 'archive') {
    body = <StockExchangeArchive />;
  } else if (screen === 'graph') {
    body = <StockExchangeGraph />;
  }

  return (
    <Window width={600} height={600}>
      <Window.Content scrollable>
        <Section title={`${stationName} Stock Exchange`}>{body}</Section>
      </Window.Content>
    </Window>
  );
};

const StockExchangeStockList = (props) => {
  const { act, data } = useBackend<Data>();

  const { balance, stationName, viewMode } = data;

  let subTemplate = <StockExchangeFullView />;

  if (viewMode === 'Full') {
    subTemplate = <StockExchangeFullView />;
  } else if (viewMode === 'Compressed') {
    subTemplate = <StockExchangeCompactView />;
  }

  return (
    <Box>
      <span>
        Welcome, <b>{stationName} Cargo Department</b> |
      </span>
      <span>
        <b>Credits:</b> {balance}
      </span>
      <br />
      <b>View mode: </b>
      <Button onClick={() => act('stocks_cycle_view')}>{viewMode}</Button>
      <br />

      <b>Stock Transaction Log: </b>
      <Button icon="list" onClick={() => act('stocks_check')}>
        Check
      </Button>
      <br />
      <b>This is a work in progress. Certain features may not be available.</b>

      <Section title="Listed Stocks">{subTemplate}</Section>
    </Box>
  );
};

const StockExchangeFullView = (props) => {
  const { act, data } = useBackend<Data>();

  const { stocks = [] } = data;

  return (
    <Box>
      <b>Actions:</b> + Buy, - Sell, (A)rchives, (H)istory
      <Divider />
      <Table>
        <Table.Row>
          <Table.Cell bold>&nbsp;</Table.Cell>
          <Table.Cell>ID</Table.Cell>
          <Table.Cell>Name</Table.Cell>
          <Table.Cell>Value</Table.Cell>
          <Table.Cell>Owned</Table.Cell>
          <Table.Cell>Avail</Table.Cell>
          <Table.Cell>Actions</Table.Cell>
        </Table.Row>
        <Divider />
        {stocks.map((stock) => (
          <Table.Row key={stock.ID}>
            <Table.Cell bold>&nbsp;</Table.Cell>
            <Table.Cell color="label">{stock.ID}</Table.Cell>
            <Table.Cell color="label">{stock.Name}</Table.Cell>
            <Table.Cell color="label">{stock.Value}</Table.Cell>
            <Table.Cell color="label">{stock.Owned}</Table.Cell>
            <Table.Cell color="label">{stock.Avail}</Table.Cell>
            <Table.Cell color="label">
              <Button
                icon="plus"
                disabled={false}
                onClick={() => act('stocks_buy', { share: stock.REF })}
              />
              <Button
                icon="minus"
                disabled={false}
                onClick={() => act('stocks_sell', { share: stock.REF })}
              />
              <br />
              <Button
                onClick={() => act('stocks_archive', { share: stock.REF })}
              >
                A
              </Button>
              <Button
                onClick={() => act('stocks_history', { share: stock.REF })}
              >
                H
              </Button>
              <br />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Box>
  );
};

const StockExchangeCompactView = (props) => {
  const { act, data } = useBackend<Data>();

  const { stocks = [] } = data;

  return (
    <Box>
      {stocks.map((stock) => (
        <Box key={stock.ID}>
          <span>{stock.Name}</span> <span>{stock.ID}</span>
          {stock.bankrupt === 1 && <b color="red">BANKRUPT</b>}
          <br />
          <b>Unified shares</b> {stock.Unification} ago.
          <br />
          <b>Current value per share:</b> {stock.Value} |
          <Button onClick={() => act('stocks_history', { share: stock.REF })}>
            View history
          </Button>
          <br />
          You currently own <b>{stock.Owned}</b> shares in this company.
          <br />
          There are {stock.Avail} purchasable shares on the market currently.
          <br />
          {stock.bankrupt === 1 ? (
            <span>You cannot buy or sell shares in a bankrupt company!</span>
          ) : (
            <span>
              <Button onClick={() => act('stocks_buy', { share: stock.REF })}>
                Buy shares
              </Button>
              |
              <Button onClick={() => act('stocks_sell', { share: stock.REF })}>
                Sell shares
              </Button>
            </span>
          )}
          <br />
          <b>Prominent products:</b>
          <br />
          <i>{stock.Products}</i>
          <br />
          <Button onClick={() => act('stocks_archive', { share: stock.REF })}>
            View news archives
          </Button>
          {/* [news ? " <span style='color:red'>(updated)</span>" : null] */}
          <Divider />
        </Box>
      ))}
    </Box>
  );
};

// "<div><a href='byond://?src=[REF(src)];show_logs=1'>Refresh</a></div></br>"
const StockExchangeLogs = (props) => {
  const { act, data } = useBackend<Data>();

  const { logs = [] } = data;

  return (
    <Box>
      <h2>Stock Transaction Logs</h2>
      <br />
      <Button onClick={() => act('stocks_backbutton')}>Go back</Button>
      <Divider />
      <div>
        {logs.map((log) => (
          <Box key={log.time}>
            {log.type !== 'borrow' ? (
              <div>
                {log.time} | <b>{log.user_name}</b>
                {log.type === 'transaction_bought' ? (
                  <span>bought</span>
                ) : (
                  <span>sold</span>
                )}
                <b>{log.stocks}</b> stocks at {log.shareprice} a share for
                <b>{log.money}</b> total credits
                {log.type === 'transaction_bought' ? (
                  <span>in</span>
                ) : (
                  <span>from</span>
                )}
                <b>{log.company_name}</b>.
                <br />
              </div>
            ) : (
              <div>
                {log.time} | <b>{log.user_name}</b> borrowed <b>{log.stocks}</b>
                stocks with a deposit of <b>{log.money}</b> credits in
                <b>{log.company_name}</b>.<br />
              </div>
            )}
            <Divider />
          </Box>
        ))}
      </div>
    </Box>
  );
};

const StockExchangeArchive = (props) => {
  const { act, data } = useBackend<Data>();

  const { name, events = [], articles = [] } = data;

  return (
    <Box>
      <h2>News feed for {name}</h2>
      <Button onClick={() => act('stocks_backbutton')}>Go back</Button>
      <h3>Events</h3>
      <Divider />
      <div>
        {events.map((event) => (
          <Box key={event.current_title}>
            <div>
              <b>{event.current_title}</b>
              <br />
              {event.current_desc}
            </div>
            <Divider />
          </Box>
        ))}
      </div>
      <br />
      <h3>Articles</h3>
      <Divider />
      <div>
        {articles.map((article) => (
          <Box key={article.headline}>
            <div>
              <b>{article.headline}</b>
              <i>{article.subtitle}</i>
              <br />
              {article.article}
              <br />- {article.author}, {article.spacetime} (via
              <i>{article.outlet}</i>)
            </div>
            <Divider />
          </Box>
        ))}
      </div>
    </Box>
  );
};

const StockExchangeGraph = (props) => {
  const { act, data } = useBackend<Data>();

  const { name, maxValue, values = [] } = data;

  return (
    <Box>
      <Button onClick={() => act('stocks_backbutton')}>Go back</Button>
      <Divider />
      <Section position="relative" height="100%">
        <Chart.Line
          fillPositionedParent
          data={values}
          rangeX={[0, values.length - 1]}
          rangeY={[0, maxValue!]}
          strokeColor="rgba(0, 181, 173, 1)"
          fillColor="rgba(0, 181, 173, 0.25)"
        />
      </Section>
      <Divider />
      <p>{name} share value per share</p>
    </Box>
  );
};
