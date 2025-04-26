import { useEffect, useState } from 'react';
import { Window } from 'tgui/layouts';
import { Box, Stack } from 'tgui-core/components';

import { resolveAsset } from '../../assets';
import { useBackend } from '../../backend';
import { CommonwealthLogo } from './animated_logos/Commonwealth';
import { NTLogo } from './animated_logos/NT';
import { type Data } from './types';

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
      <Stack vertical fill justify="center" backgroundColor="black">
        <Stack.Item>
          <NTLogo />
        </Stack.Item>
      </Stack>
    );
  }

  return <LoadingText onFinish={props.onFinish} />;
};

export const LoaderCommonwealth = (props: { onFinish?: () => void }) => {
  const [showLogo, setShowLogo] = useState(true);

  useEffect(() => {
    setTimeout(() => {
      setShowLogo(false);
    }, 3500);
  }, []);

  if (showLogo) {
    return (
      <Stack vertical fill justify="center" backgroundColor="#5f95e3">
        <Stack.Item>
          <CommonwealthLogo />
        </Stack.Item>
      </Stack>
    );
  }

  return (
    <Box backgroundColor="black" height="100%">
      <LoadingText onFinish={props.onFinish} />
    </Box>
  );
};

export const LoaderProtean = (props: { onFinish?: () => void }) => {
  const [showLogo, setShowLogo] = useState(true);

  useEffect(() => {
    setTimeout(() => {
      setShowLogo(false);
    }, 3500);
  }, []);

  if (showLogo) {
    return (
      <Stack vertical fill justify="center" backgroundColor="#0e0e0e">
        <Stack.Item>
          <video
            autoPlay
            src={resolveAsset('tentacles.mp4')}
            height="100%"
            width="100%"
          />
        </Stack.Item>
      </Stack>
    );
  }

  return (
    <Box backgroundColor="black" height="100%">
      <LoadingText onFinish={props.onFinish} />
    </Box>
  );
};

export const RIGSuitLoader = (props: { onFinish?: () => void }) => {
  const { data } = useBackend<Data>();
  // You can skip to the end by clicking
  const onFinish = props.onFinish ? props.onFinish : () => {};

  let loader = <LoaderNT onFinish={props.onFinish} />;

  if (data.interface_intro === 'Commonwealth') {
    loader = <LoaderCommonwealth onFinish={props.onFinish} />;
  } else if (data.interface_intro === 'Protean') {
    loader = <LoaderProtean onFinish={props.onFinish} />;
  }

  return (
    <Window height={400} width={600}>
      <Window.Content
        fitted
        onClick={() => onFinish()}
        style={{ cursor: 'pointer' }}
      >
        <Box height="100%">{loader}</Box>
      </Window.Content>
    </Window>
  );
};
