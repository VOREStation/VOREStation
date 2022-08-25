import { useBackend } from '../backend';
import { Button, Icon } from '../components';
import { Window } from '../layouts';

export const JanitorCart = (props, context) => {
  const { act, data } = useBackend(context);

  const { mybag, mybucket, mymop, myspray, myreplacer, signs, icons } = data;

  return (
    <Window width={210} height={180}>
      <Window.Content>
        <Button
          width="64px"
          height="64px"
          position="relative"
          tooltip={mybag ? mybag : 'Garbage Bag Slot'}
          tooltipPosition="bottom-end"
          color={mybag ? 'grey' : 'transparent'}
          style={{
            border: mybag ? null : '2px solid grey',
          }}
          onClick={() => act('bag')}>
          <JanicartIcon iconkey="mybag" />
        </Button>
        <Button
          width="64px"
          height="64px"
          position="relative"
          tooltip={mybucket ? mybucket : 'Bucket Slot'}
          tooltipPosition="bottom"
          color={mybucket ? 'grey' : 'transparent'}
          style={{
            border: mybucket ? null : '2px solid grey',
          }}
          onClick={() => act('bucket')}>
          <JanicartIcon iconkey="mybucket" />
        </Button>
        <Button
          width="64px"
          height="64px"
          position="relative"
          tooltip={mymop ? mymop : 'Mop Slot'}
          tooltipPosition="bottom-end"
          color={mymop ? 'grey' : 'transparent'}
          style={{
            border: mymop ? null : '2px solid grey',
          }}
          onClick={() => act('mop')}>
          <JanicartIcon iconkey="mymop" />
        </Button>
        <Button
          width="64px"
          height="64px"
          position="relative"
          tooltip={myspray ? myspray : 'Spray Slot'}
          tooltipPosition="top-end"
          color={myspray ? 'grey' : 'transparent'}
          style={{
            border: myspray ? null : '2px solid grey',
          }}
          onClick={() => act('spray')}>
          <JanicartIcon iconkey="myspray" />
        </Button>
        <Button
          width="64px"
          height="64px"
          position="relative"
          tooltip={myreplacer ? myreplacer : 'Light Replacer Slot'}
          tooltipPosition="top"
          color={myreplacer ? 'grey' : 'transparent'}
          style={{
            border: myreplacer ? null : '2px solid grey',
          }}
          onClick={() => act('replacer')}>
          <JanicartIcon iconkey="myreplacer" />
        </Button>
        <Button
          width="64px"
          height="64px"
          position="relative"
          tooltip={signs ? signs : 'Signs Slot'}
          tooltipPosition="top-start"
          color={signs ? 'grey' : 'transparent'}
          style={{
            border: signs ? null : '2px solid grey',
          }}
          onClick={() => act('sign')}>
          <JanicartIcon iconkey="signs" />
        </Button>
      </Window.Content>
    </Window>
  );
};

const iconkeysToIcons = {
  'mybag': 'trash',
  'mybucket': 'fill',
  'mymop': 'broom',
  'myspray': 'spray-can',
  'myreplacer': 'lightbulb',
  'signs': 'sign',
};

const JanicartIcon = (props, context) => {
  const { data } = useBackend(context);

  const { iconkey } = props;

  const { icons } = data;

  if (iconkey in icons) {
    return (
      <img
        src={icons[iconkey].substr(1, icons[iconkey].length - 1)}
        style={{
          position: 'absolute',
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          width: '64px',
          height: '64px',
          '-ms-interpolation-mode': 'nearest-neighbor',
        }}
      />
    );
  }

  return (
    <Icon
      style={{
        position: 'absolute',
        left: '4px',
        right: 0,
        top: '20px',
        bottom: 0,
        width: '64px',
        height: '64px',
      }}
      fontSize={2}
      name={iconkeysToIcons[iconkey]}
    />
  );
};
