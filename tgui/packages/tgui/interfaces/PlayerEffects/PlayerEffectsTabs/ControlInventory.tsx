import { useBackend } from 'tgui/backend';
import { Button, Section } from 'tgui-core/components';

export const ControlInventory = (props) => {
  const { act } = useBackend();

  return (
    <Section title="Inventory Controls">
      <Button fluid onClick={() => act('drop_all')}>
        Drop Everything
      </Button>
      <Button fluid onClick={() => act('drop_specific')}>
        Drop Specific Item
      </Button>
      <Button fluid onClick={() => act('drop_held')}>
        Drop Held Items
      </Button>
      <Button fluid onClick={() => act('list_all')}>
        List All Items
      </Button>
      <Button fluid onClick={() => act('give_item')}>
        Add Marked Item To Hands
      </Button>
      <Button fluid onClick={() => act('equip_item')}>
        Equip Marked Item To Inventory
      </Button>
    </Section>
  );
};
