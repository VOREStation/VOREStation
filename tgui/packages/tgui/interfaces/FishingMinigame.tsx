import {
  Component,
  type ComponentProps,
  type PropsWithChildren,
  type ReactNode,
  useEffect,
  useState,
} from 'react';
import { Window } from 'tgui/layouts';
import { Box, Button, Icon, ProgressBar, Stack } from 'tgui-core/components';
import { clamp } from 'tgui-core/math';

enum GameOverState {
  GameRunning = 0,
  GameWin = 1,
  GameFail = 2,
  GameTitle = 3,
}

export const FishingMinigame = (props) => {
  return (
    <Window width={200} height={530}>
      <Window.Content>
        <GameWindow />
      </Window.Content>
    </Window>
  );
};

export const GameWindow = (props: {
  onWin?: () => void;
  onLose?: () => void;
}) => {
  const [gameOver, setGameOver] = useState(GameOverState.GameTitle);
  const [score, setScore] = useState((MAX_SCORE + MIN_SCORE) / 2);

  useEffect(() => {
    if (score === MIN_SCORE) {
      if (props.onLose) {
        props.onLose();
      }
      setGameOver(GameOverState.GameFail);
    } else if (score === MAX_SCORE) {
      if (props.onWin) {
        props.onWin();
      }
      setGameOver(GameOverState.GameWin);
    }
  }, [score]);

  return gameOver ? (
    <Stack align="center" justify="center" fill textAlign="center" fontSize={3}>
      <Stack.Item>
        <Box>
          {gameOver === GameOverState.GameFail
            ? 'You Lost!'
            : gameOver === GameOverState.GameWin
              ? 'You won!!!'
              : 'Fishy Fishy 905'}
        </Box>
        <Button
          onClick={() => {
            setScore((MAX_SCORE + MIN_SCORE) / 2);
            setGameOver(GameOverState.GameRunning);
          }}
          fluid
          mt={1}
        >
          {gameOver === GameOverState.GameTitle ? 'Start?' : 'Restart?'}
        </Button>
      </Stack.Item>
    </Stack>
  ) : (
    <Stack fill align="center" justify="center">
      <Stack.Item position="relative" mt={-4}>
        <Icon
          name="fish"
          spin
          color="red"
          size={2}
          position="absolute"
          top={-14}
          left={-14}
        />
        <Icon
          name="fish"
          spin
          color="blue"
          size={2}
          position="absolute"
          top={6}
          left={-13}
        />
        <Icon
          name="fish"
          spin
          color="darkblue"
          size={2}
          position="absolute"
          top={-3}
          left={-3}
        />
        <Icon
          name="fish"
          spin
          color="pink"
          size={2}
          position="absolute"
          top={10}
          left={10}
        />
        <Icon
          name="fish"
          spin
          color="yellow"
          size={2}
          position="absolute"
          top={-10}
          left={11}
        />
        <Box
          italic
          position="absolute"
          left={-13}
          top={2}
          style={{ transform: 'rotate(34deg)' }}
        >
          Fish...
        </Box>
        <Box
          italic
          position="absolute"
          left={10}
          top={1}
          style={{ transform: 'rotate(-53deg)' }}
        >
          Fish!
        </Box>
        <FishingRod position="absolute" top={-8} left={6} />
        <Box position="absolute" top={-18}>
          <Bar setScore={setScore} />
        </Box>
        <Box position="absolute" left={-12} top={0}>
          <ProgressBar
            className="FishingGame__ProgressBar"
            value={score}
            minValue={MIN_SCORE}
            maxValue={MAX_SCORE}
            width={HEIGHT + 7}
            style={{
              transform: 'rotate(-90deg)',
            }}
            ranges={{
              bad: [MIN_SCORE, MIN_SCORE / 2],
              average: [MIN_SCORE / 2, MAX_SCORE / 2],
              good: [MAX_SCORE / 2, MAX_SCORE],
            }}
          >
            &nbsp;
          </ProgressBar>
        </Box>
      </Stack.Item>
    </Stack>
  );
};

// Settings
const UPDATE_RATE = 20; // ms per update interval
const HEIGHT = 30; // total height
const DIFFICULTY = 8; // vertical size of bar
const FISH_SPASM_CHANCE = 5; // %chance of fish changing direction
const BAR_UP_SPEED = 0.4; // amount bar moves up per tick
const BAR_FALL_SPEED = 0.6; // amount bar moves down per tick
const MAX_SCORE = 200;
const MIN_SCORE = -200;
// Reactive escape hatch
let barTop = HEIGHT;
let fishTop = 0;
let fishDirection = 0.25;
let mouseDown = false;

export const Bar = (props: {
  setScore: React.Dispatch<React.SetStateAction<number>>;
}) => {
  const { setScore } = props;

  // Used to bridge non-reactive values back into reactive ones
  const [barTopR, setBarTopR] = useState(HEIGHT);
  const [fishTopR, setFishTopR] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      // Move bar
      if (mouseDown) {
        barTop = clamp(barTop - BAR_UP_SPEED, 0.25, HEIGHT);
      } else {
        barTop = clamp(barTop + BAR_FALL_SPEED, 0.25, HEIGHT);
      }

      // Move fish
      if (Math.random() > 1 - FISH_SPASM_CHANCE / 100) {
        fishDirection = -fishDirection;
      }

      fishTop = clamp(fishTop + fishDirection, 0.5, HEIGHT + 4);

      // Detect fish being inside the bar
      if (fishTop > barTop && fishTop < barTop + DIFFICULTY) {
        setScore((x) => clamp(x + 1, MIN_SCORE, MAX_SCORE));
      } else {
        setScore((x) => clamp(x - 1, MIN_SCORE, MAX_SCORE));
      }

      // Update visuals
      setBarTopR(barTop);
      setFishTopR(fishTop);
    }, UPDATE_RATE);

    return () => clearInterval(interval);
  }, []);

  return (
    <MouseTracker
      onMouseDown={(e) => {
        e.preventDefault();
        mouseDown = true;
      }}
      onMouseUp={(e) => {
        e.preventDefault();
        mouseDown = false;
      }}
    >
      <Box
        position="relative"
        width={2.5}
        height={HEIGHT + 0.25 + DIFFICULTY}
        style={{
          background: 'linear-gradient(#aacbf4, #4578e1)',
        }}
      >
        <Box
          position="absolute"
          top={barTopR}
          left={0.25}
          backgroundColor="#7fcd00"
          style={{
            border: '4px inset #6bb300',
          }}
          width={2}
          height={DIFFICULTY}
        />
        <Box
          position="absolute"
          top={fishTopR}
          left={0.1}
          width={2}
          height={2}
          style={{ userSelect: 'none' }}
        >
          <Icon name="fish" size={2} color="darkblue" />
        </Box>
      </Box>
    </MouseTracker>
  );
};

type MouseTrackerProps = PropsWithChildren<{
  onMouseDown?: (e: MouseEvent) => void;
  onMouseUp?: (e: MouseEvent) => void;
}>;

export class MouseTracker extends Component<MouseTrackerProps> {
  constructor(props: MouseTrackerProps) {
    super(props);
  }

  onMouseDown = (e) => {
    if (this.props.onMouseDown) {
      this.props.onMouseDown(e);
    }
  };

  onMouseUp = (e) => {
    if (this.props.onMouseUp) {
      this.props.onMouseUp(e);
    }
  };

  componentDidMount(): void {
    document.addEventListener('mousedown', this.onMouseDown);
    document.addEventListener('mouseup', this.onMouseUp);
  }

  componentWillUnmount(): void {
    document.removeEventListener('mousedown', this.onMouseDown);
    document.removeEventListener('mouseup', this.onMouseUp);
  }

  render(): ReactNode {
    return <span>{this.props.children}</span>;
  }
}

const FishingRod = (props: ComponentProps<typeof Box>) => {
  return (
    <Box {...props}>
      <svg viewBox="0 0 256 256">
        <g transform="rotate(-135 50 100) scale(1 -1)">
          <path
            fill="#626375"
            d="M137.561,331.913L11.774,457.7c-12.422,12.422-12.422,32.561,0,44.984l0,0
c12.422,12.422,32.561,12.422,44.984,0l125.786-125.786L137.561,331.913z"
          />
          <path
            fill="#75778C"
            d="M22.969,468.895l125.786-125.786l33.788,33.788l0,0l-44.984-44.984L11.774,457.7
c-12.422,12.421-12.422,32.561,0,44.984l0,0c1.932,1.932,4.053,3.563,6.301,4.895C10.849,495.377,12.481,479.385,22.969,468.895z"
          />
          <path
            fill="#C89173"
            d="M497.668,15.644L486.462,4.438c-5.917-5.917-15.509-5.917-21.424,0L121.728,347.746l32.631,32.631
L497.668,37.069C503.585,31.152,503.585,21.56,497.668,15.644z"
          />
          <path
            fill="#E0A381"
            d="M476.232,15.632c5.916-5.916,15.508-5.916,21.423,0L486.462,4.437
c-5.917-5.916-15.508-5.916-21.424,0L121.728,347.746l11.195,11.195L476.232,15.632z"
          />
          <circle fill="#C9CFF2" cx="188.08" cy="394.532" r="50.535" />
          <path
            fill="#E6E9FF"
            d="M163.544,369.988c17.832-17.832,45.672-19.548,65.437-5.158c-1.537-2.111-3.253-4.132-5.158-6.038
c-19.737-19.737-51.737-19.737-71.474,0c-19.737,19.737-19.737,51.737,0,71.474c1.904,1.904,3.926,3.621,6.038,5.158
C143.996,415.66,145.712,387.82,163.544,369.988z"
          />
          <circle fill="#626375" cx="188.08" cy="394.532" r="23.179" />
          <path
            fill="#4D4E5C"
            d="M232.276,488.79h-44.19c-4.637,0-8.396-3.759-8.396-8.396V394.53c0-4.637,3.759-8.396,8.396-8.396
s8.396,3.759,8.396,8.396v77.467h35.793c4.637,0,8.396,3.759,8.396,8.396C240.672,485.031,236.913,488.79,232.276,488.79z"
          />
          <path
            fill="#626375"
            d="M226.118,330.206c-6.169,0-11.542-1.828-15.651-5.937c-3.279-3.279-3.279-8.596,0-11.874
c3.279-3.279,8.596-3.279,11.874,0c3.692,3.69,26.277-1.584,53.287-28.594c27.011-27.012,32.285-49.595,28.594-53.287
c-1.639-1.639-2.46-3.788-2.46-5.937s0.819-4.298,2.46-5.937c3.279-3.279,8.596-3.279,11.874,0c1.415,1.413,7.2,1.9,17.348-2.553
c11.374-4.991,24.138-14.239,35.939-26.04c27.012-27.011,32.287-49.595,28.594-53.287c-1.639-1.639-2.458-3.788-2.458-5.937
c0-2.148,0.819-4.298,2.46-5.937c3.279-3.28,8.596-3.279,11.874,0c1.412,1.414,7.199,1.901,17.347-2.553
c11.374-4.991,24.138-14.239,35.939-26.04c27.012-27.011,32.287-49.595,28.594-53.287c-3.279-3.279-3.279-8.596,0.001-11.874
c3.279-3.279,8.596-3.279,11.874,0c15.901,15.902-2.35,50.791-28.594,77.036c-13.242,13.242-27.825,23.734-41.066,29.544
c-4.689,2.057-11.417,4.431-18.221,4.86c-1.081,17.491-15.738,40.622-34.467,59.35c-13.242,13.242-27.826,23.734-41.066,29.544
c-4.689,2.057-11.417,4.431-18.223,4.86c-1.08,17.491-15.737,40.621-34.467,59.35C268.04,315.139,243.819,330.206,226.118,330.206z"
          />
        </g>
      </svg>
    </Box>
  );
};
