import { Box } from 'tgui-core/components';

export const VorePanelColorBox = (props: {
  back_color: string;
  size?: string;
}) => {
  const { back_color, size = '20px' } = props;
  return (
    <Box
      backgroundColor={
        back_color.startsWith('#') ? back_color : `#${back_color}`
      }
      style={{
        border: '2px solid white',
      }}
      width={size}
      height={size}
    />
  );
};
