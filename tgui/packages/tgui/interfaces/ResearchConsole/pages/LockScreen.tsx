import { useEffect, useRef } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';

export const LockScreen = (props) => {
  const { act } = useBackend();
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const image = useRef<HTMLImageElement>(document.createElement('img'));

  useEffect(() => {
    image.current.src = `${Byond.iconRefMap['icons/obj/machines/research.dmi']}?state=protolathe`;
  }, [image]);

  let randomSizeDiff = 0;
  useEffect(() => {
    randomSizeDiff = Math.floor(Math.random() * 25);

    let x = 0;
    let y = 0;
    let x_i = 4;
    let y_i = 4;
    const interval = setInterval(
      () => {
        const current = canvasRef.current;
        if (!current) {
          return;
        }

        const context = current.getContext('2d');
        if (!context) {
          return;
        }

        if (x < 0 || x > current.width - 64) {
          x_i = -x_i;
        }
        x += x_i;

        if (y < 0 || y > current.height - 64) {
          y_i = -y_i;
        }
        y += y_i;

        context.imageSmoothingEnabled = false;
        context.drawImage(image.current, x, y, 64, 64);
      },
      (1 / 60) * 1000, // 60fps
    );

    () => clearInterval(interval);
  }, []);

  return (
    <Section title="Locked" textAlign="center" fontSize={2} fill>
      <Box mb={2}>This interface is currently locked.</Box>
      <Box>
        Would you like to{' '}
        <Button icon="lock-open" onClick={() => act('lock')}>
          Unlock
        </Button>{' '}
        it?
      </Box>
      <Stack align="center" justify="center" fill mt={-5}>
        <Stack.Item>
          <canvas
            ref={canvasRef}
            width={582 + randomSizeDiff}
            height={300 + randomSizeDiff}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};
