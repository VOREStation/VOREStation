import { Icon, Table } from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import { icons } from './constatnts';

export const ChangeRow = (props: { kind: string; content: string }) => {
  return (
    <Table.Row>
      <Table.Cell
        className={classes(['Changelog__Cell', 'Changelog__Cell--Icon'])}
      >
        <Icon
          color={
            icons[props.kind] ? icons[props.kind].color : icons.unknown.color
          }
          name={icons[props.kind] ? icons[props.kind].icon : icons.unknown.icon}
        />
      </Table.Cell>
      <Table.Cell className="Changelog__Cell">{props.content}</Table.Cell>
    </Table.Row>
  );
};
