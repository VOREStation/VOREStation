import { Icon, Tooltip } from 'tgui-core/components';

export const CastlingUsed = (props: { used: boolean }) => {
  const { used } = props;

  return (
    <Tooltip content={`Castling ${used ? '' : 'un'}used`}>
      {used ? (
        <Icon.Stack>
          <Icon name="dungeon" />
          <Icon name="ban" color="red" />
        </Icon.Stack>
      ) : (
        <Icon name="dungeon" />
      )}
    </Tooltip>
  );
};
