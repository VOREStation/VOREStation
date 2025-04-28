import { useContext, useEffect, useRef } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Stack } from 'tgui-core/components';

import { LobbyContext } from './constants';
import type { LobbyButtonProps, LobbyContextType } from './types';

export const TimedDivider = () => {
  const ref = useRef<HTMLDivElement>(null);

  const context = useContext(LobbyContext);
  const { animationsDisabled, animationsFinished } = context;

  useEffect(() => {
    if (!animationsFinished && !animationsDisabled) {
      setTimeout(() => {
        ref.current!.style.display = 'block';
      }, 1500);
    }
  }, [animationsFinished, animationsDisabled]);

  return (
    <Stack.Item>
      <div
        style={{
          borderStyle: 'solid',
          borderWidth: '1px',
          display: animationsFinished || animationsDisabled ? 'block' : 'none',
        }}
        className="dividerEffect"
        ref={ref}
      />
    </Stack.Item>
  );
};

export const LobbyButton = (props: LobbyButtonProps) => {
  const { children, index, className, ...rest } = props;

  const context = useContext<LobbyContextType>(LobbyContext);

  return (
    <Stack.Item
      className="buttonEffect"
      style={{
        animationDelay:
          context.animationsFinished || context.animationsDisabled
            ? '0s'
            : `${1.5 + index * 0.2}s`,
      }}
    >
      <CustomButton fluid className={'distinctButton ' + className} {...rest}>
        {children}
      </CustomButton>
    </Stack.Item>
  );
};

export const CustomButton = (props) => {
  const { act } = useBackend();

  return (
    // this works because of event propagation
    <Box onClick={() => act('keyboard')}>
      <Button {...props} />
    </Box>
  );
};
