import { useBackend } from '../../backend';
import { Button, Section } from '../../components';

export const BodyDesignerStockRecords = (props: {
  stock_bodyrecords: string[];
}) => {
  const { act } = useBackend();
  const { stock_bodyrecords } = props;
  return (
    <Section
      title="Stock Records"
      buttons={
        <Button icon="arrow-left" onClick={() => act('menu', { menu: 'Main' })}>
          Back
        </Button>
      }
    >
      {stock_bodyrecords.map((record) => (
        <Button
          icon="eye"
          key={record}
          onClick={() => act('view_stock_brec', { view_stock_brec: record })}
        >
          {record}
        </Button>
      ))}
    </Section>
  );
};
