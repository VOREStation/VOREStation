import { useBackend } from 'tgui/backend';
import { Button, Section } from 'tgui-core/components';

import { Data } from './types';

export const AppearanceChangerBodyRecords = () => {
  const { act, data } = useBackend<Data>();
  const { character_records, stock_records } = data;
  return (
    <Section title="Bodyrecord Database">
      <Section title="Stock Records">
        {stock_records
          ? stock_records.map((record) => (
              <Button
                icon="eye"
                key={record}
                onClick={() =>
                  act('view_stock_brec', { view_stock_brec: record })
                }
              >
                {record}
              </Button>
            ))
          : ''}
      </Section>
      <Section title="Crew Records">
        {character_records
          ? character_records.map((record) => (
              <Button
                icon="eye"
                key={record.name}
                onClick={() => act('view_brec', { view_brec: record.recref })}
              >
                {record.name}
              </Button>
            ))
          : ''}
      </Section>
    </Section>
  );
};
