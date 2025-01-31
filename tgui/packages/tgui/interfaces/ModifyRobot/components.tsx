import { NoticeBox } from 'tgui-core/components';

export const NoSpriteWarning = (props: { name: string }) => {
  const { name } = props;

  return (
    <NoticeBox warning>
      Warning, {name} has not yet chosen a sprite. Functionality might be
      limited.
    </NoticeBox>
  );
};
