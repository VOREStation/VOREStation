import { useBackend } from "../backend";
import { Button, Divider, Section, Table } from "../components";
import { Window } from "../layouts";

export const StockExchange = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    stationName,
    balance,
    viewMode,
    stocks = [],
  } = data;

  return (
    <Window width={600} height={600} resizable>
      <Window.Content scrollable>
        <Section title={`${stationName} Stock Exchange`}>
          <span>Welcome, <b>{stationName} Cargo Department</b> | </span>
          <span><b>Credits:</b> {balance}</span><br />
          <b>View mode: </b>
          <Button content={viewMode}
            onClick={() => act("stocks_cycle_view")} /><br />

          <b>Stock Transaction Log: </b>
          <Button icon="list"
            content="Check"
            onClick={() => act("stocks_check")} /><br />
          <b>This is a work in progress. Certain features may not be available.</b>
        </Section>
        <Section title="Listed Stocks">
          <b>Actions:</b> + Buy, - Sell, (A)rchives, (H)istory
          <Divider />
          <Table>
            <Table.Row>
              <Table.Cell bold>
                &nbsp;
              </Table.Cell>
              <Table.Cell>
                ID
              </Table.Cell>
              <Table.Cell>
                Name
              </Table.Cell>
              <Table.Cell>
                Value
              </Table.Cell>
              <Table.Cell>
                Owned
              </Table.Cell>
              <Table.Cell>
                Avail
              </Table.Cell>
              <Table.Cell>
                Actions
              </Table.Cell>
            </Table.Row>
            <Divider />
            {stocks.map(stock => (
              <Table.Row key={stock.ID}>
                <Table.Cell bold>
                  &nbsp;
                </Table.Cell>
                <Table.Cell color="label">
                  {stock.ID}
                </Table.Cell>
                <Table.Cell color="label">
                  {stock.Name}
                </Table.Cell>
                <Table.Cell color="label">
                  {stock.Value}
                </Table.Cell>
                <Table.Cell color="label">
                  {stock.Owned}
                </Table.Cell>
                <Table.Cell color="label">
                  {stock.Avail}
                </Table.Cell>
                <Table.Cell color="label">
                  <Button icon="plus"
                    disabled={false}
                    onClick={() => act("stocks_buy")} /><br />
                  <Button icon="minus"
                    disabled={false}
                    onClick={() => act("stocks_sell")} /><br />
                  <Button content="A"
                    onClick={() => act("stocks_archive")} /><br />
                  <Button content="H"
                    onClick={() => act("stocks_history")} /><br />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
