import { useEffect, useState } from 'react';
import { Window } from 'tgui/layouts';
import { Box, Stack } from 'tgui-core/components';

// This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
// http://creativecommons.org/licenses/by-sa/4.0/
const NTLogoReact = (props) => {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      version="1.0"
      viewBox="0 0 425 200"
      fill="#00bbbb"
    >
      <path
        className="RIGSuit__FadeIn"
        d="m 178.00399,0.03869 -71.20393,0 a 6.7613422,6.0255495 0 0 0 -6.76134,6.02555 l 0,187.87147 a 6.7613422,6.0255495 0 0 0 6.76134,6.02554 l 53.1072,0 a 6.7613422,6.0255495 0 0 0 6.76135,-6.02554 l 0,-101.544018 72.21628,104.699398 a 6.7613422,6.0255495 0 0 0 5.76015,2.87016 l 73.55487,0 a 6.7613422,6.0255495 0 0 0 6.76135,-6.02554 l 0,-187.87147 a 6.7613422,6.0255495 0 0 0 -6.76135,-6.02555 l -54.71644,0 a 6.7613422,6.0255495 0 0 0 -6.76133,6.02555 l 0,102.61935 L 183.76413,2.90886 a 6.7613422,6.0255495 0 0 0 -5.76014,-2.87017 z"
      />
      <path
        className="RIGSuit__Animation__WipeLeft"
        style={{ animationDelay: '1s' }}
        d="M 4.8446333,22.10875 A 13.412039,12.501842 0 0 1 13.477588,0.03924 l 66.118315,0 a 5.3648158,5.000737 0 0 1 5.364823,5.00073 l 0,79.87931 z"
      />
      <path
        className="RIGSuit__Animation__WipeLeft"
        style={{ animationDelay: '2s' }}
        d="m 420.15535,177.89119 a 13.412038,12.501842 0 0 1 -8.63295,22.06951 l -66.11832,0 a 5.3648152,5.000737 0 0 1 -5.36482,-5.00074 l 0,-79.87931 z"
      />
    </svg>
  );
};

const LoadingText = (props: { onFinish?: () => void }) => {
  const onFinish = props.onFinish ? props.onFinish : () => {};
  useEffect(() => {
    const timer = setTimeout(() => {
      onFinish();
    }, 5000);

    return () => {
      clearTimeout(timer);
    };
  }, []);

  return (
    <Box>
      <Box className="RIGSuit__Animation__WipeLeft">RigOS Loading...</Box>
      <Box
        className="RIGSuit__Animation__WipeLeft"
        style={{ animationDelay: '1s' }}
      >
        Starting Power-On Self Test...
      </Box>
      <Box
        className="RIGSuit__Animation__WipeLeft"
        style={{ animationDelay: '2s' }}
      >
        POST:{' '}
        <Box inline color="good">
          GOOD.
        </Box>
      </Box>
      <Box
        className="RIGSuit__Animation__WipeLeft"
        style={{ animationDelay: '3s' }}
      >
        Loading UI...
      </Box>
      <Box
        className="RIGSuit__Animation__WipeLeft"
        style={{ animationDelay: '4s' }}
      >
        All Systems Ready!
      </Box>
    </Box>
  );
};

export const LoaderNT = (props: { onFinish?: () => void }) => {
  const [showLogo, setShowLogo] = useState(true);

  useEffect(() => {
    setTimeout(() => {
      setShowLogo(false);
    }, 3500);
  }, []);

  if (showLogo) {
    return (
      <Stack vertical fill justify="center">
        <Stack.Item>
          <NTLogoReact />
        </Stack.Item>
      </Stack>
    );
  }

  return <LoadingText onFinish={props.onFinish} />;
};

export const RIGSuitLoader = (props: { onFinish?: () => void }) => {
  // You can skip to the end by clicking
  const onFinish = props.onFinish ? props.onFinish : () => {};

  return (
    <Window height={400} width={600}>
      <Window.Content
        fitted
        onClick={() => onFinish()}
        style={{ cursor: 'pointer' }}
      >
        <Box backgroundColor="black" height="100%">
          <LoaderNT onFinish={props.onFinish} />
        </Box>
      </Window.Content>
    </Window>
  );
};
