import { useBackend } from '../../backend';
import { Button, Section } from '../../components';

export const BodyDesignerMain = (props) => {
  const { act } = useBackend();
  return (
    <Section title="Database Functions">
      <Button icon="eye" onClick={() => act('menu', { menu: 'Body Records' })}>
        View Individual Body Records
      </Button>
      <Button icon="eye" onClick={() => act('menu', { menu: 'Stock Records' })}>
        View Stock Body Records
      </Button>
    </Section>
  );
};
