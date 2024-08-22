import { useBackend } from '../../backend';
import { Button, Section } from '../../components';
import { bodyrecord } from './types';

export const BodyDesignerBodyRecords = (props: {
  bodyrecords: bodyrecord[];
}) => {
  const { act } = useBackend();
  const { bodyrecords } = props;
  return (
    <Section
      title="Body Records"
      buttons={
        <Button icon="arrow-left" onClick={() => act('menu', { menu: 'Main' })}>
          Back
        </Button>
      }
    >
      {bodyrecords
        ? bodyrecords.map((record) => (
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
  );
};
