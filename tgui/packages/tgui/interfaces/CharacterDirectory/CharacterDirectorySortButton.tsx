import { Button, Icon, Table } from 'tgui-core/components';

export const SortButton = (props: {
  id: string;
  sortId: string;
  sortOrder: string;
  onSortOrder: Function;
  onSortId: Function;
  children: React.JSX.Element | string;
}) => {
  const { id, sortId, sortOrder, onSortOrder, onSortId, children } = props;

  // Hey, same keys mean same data~

  return (
    <Table.Cell collapsing>
      <Button
        width="100%"
        color={sortId !== id && 'transparent'}
        onClick={() => {
          if (sortId === id) {
            onSortOrder(!props.sortOrder);
          } else {
            onSortId(id);
            onSortOrder(true);
          }
        }}
      >
        {children}
        {sortId === id && (
          <Icon name={sortOrder ? 'sort-up' : 'sort-down'} ml="0.25rem;" />
        )}
      </Button>
    </Table.Cell>
  );
};
