import { useBackend } from '../../backend';
import { Box, Button, ColorBox, LabeledList, Section } from '../../components';
import { Data, SPRITE_ACCESSORY_COLOR_CHANNEL_NAMES } from './types';

export const AppearanceChangerColors = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    change_eye_color,
    change_skin_tone,
    change_skin_color,
    change_hair_color,
    change_facial_hair_color,
    eye_color,
    skin_color,
    hair_color,
    facial_hair_color,
    ears_color,
    ears2_color,
    tail_color,
    tail2_color,
    tail3_color,
    wing_color,
    wing2_color,
    wing3_color,
    ear_secondary_colors,
  } = data;

  return (
    <Section title="Colors" fill scrollable>
      {change_eye_color ? (
        <Box>
          <ColorBox color={eye_color} mr={1} />
          <Button onClick={() => act('eye_color')}>Change Eye Color</Button>
        </Box>
      ) : (
        ''
      )}
      {change_skin_tone ? (
        <Box>
          <Button onClick={() => act('skin_tone')}>Change Skin Tone</Button>
        </Box>
      ) : (
        ''
      )}
      {change_skin_color ? (
        <Box>
          <ColorBox color={skin_color} mr={1} />
          <Button onClick={() => act('skin_color')}>Change Skin Color</Button>
        </Box>
      ) : (
        ''
      )}
      {change_hair_color ? (
        <>
          <Box>
            <ColorBox color={hair_color} mr={1} />
            <Button onClick={() => act('hair_color')}>Change Hair Color</Button>
          </Box>
          <Box>
            <ColorBox color={ears_color} mr={1} />
            <Button onClick={() => act('ears_color')}>
              Change Ears Color (Primary)
            </Button>
          </Box>
          <Box>
            <ColorBox color={ears2_color} mr={1} />
            <Button onClick={() => act('ears2_color')}>
              Change Ears Color (Secondary)
            </Button>
          </Box>
          {data.ear_secondary_colors.map((color, index) => (
            <Box key={index}>
              <ColorBox color={color} mr={1} />
              <Button
                onClick={() =>
                  act('ears_secondary_color', { channel: index + 1 })
                }
              >
                Change Secondary Ears Color (
                {SPRITE_ACCESSORY_COLOR_CHANNEL_NAMES[index]})
              </Button>
            </Box>
          ))}
          <Box>
            <ColorBox color={tail_color} mr={1} />
            <Button onClick={() => act('tail_color')}>Change Tail Color</Button>
          </Box>
          <Box>
            <ColorBox color={tail2_color} mr={1} />
            <Button onClick={() => act('tail2_color')}>
              Change Secondary Tail Color
            </Button>
          </Box>
          <Box>
            <ColorBox color={tail3_color} mr={1} />
            <Button onClick={() => act('tail3_color')}>
              Change Tertiary Tail Color
            </Button>
          </Box>
          <Box>
            <ColorBox color={wing_color} mr={1} />
            <Button onClick={() => act('wing_color')}>Change Wing Color</Button>
          </Box>
          <Box>
            <ColorBox color={wing2_color} mr={1} />
            <Button onClick={() => act('wing2_color')}>
              Change Secondary Wing Color
            </Button>
          </Box>
          <Box>
            <ColorBox color={wing3_color} mr={1} />
            <Button onClick={() => act('wing3_color')}>
              Change Tertiary Wing Color
            </Button>
          </Box>
        </>
      ) : null}
      {change_facial_hair_color ? (
        <Box>
          <ColorBox color={facial_hair_color} mr={1} />
          <Button onClick={() => act('facial_hair_color')}>
            Change Facial Hair Color
          </Button>
        </Box>
      ) : null}
    </Section>
  );
};

export const AppearanceChangerMarkings = (props) => {
  const { act, data } = useBackend<Data>();

  const { markings } = data;

  return (
    <Section title="Markings" fill scrollable>
      <Box>
        <Button onClick={() => act('marking', { todo: 1, name: 'na' })}>
          Add Marking
        </Button>
      </Box>
      <LabeledList>
        {markings.map((m) => (
          <LabeledList.Item key={m.marking_name} label={m.marking_name}>
            <ColorBox color={m.marking_color} mr={1} />
            <Button
              onClick={() => act('marking', { todo: 4, name: m.marking_name })}
            >
              Change Color
            </Button>
            <Button
              onClick={() => act('marking', { todo: 0, name: m.marking_name })}
            >
              -
            </Button>
            <Button
              onClick={() => act('marking', { todo: 3, name: m.marking_name })}
            >
              Move down
            </Button>
            <Button
              onClick={() => act('marking', { todo: 2, name: m.marking_name })}
            >
              Move up
            </Button>
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};
