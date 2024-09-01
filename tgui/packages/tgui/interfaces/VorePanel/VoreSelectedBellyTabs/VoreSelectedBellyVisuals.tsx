import { classes } from 'common/react';

import { useBackend } from '../../../backend';
import {
  Box,
  Button,
  Flex,
  LabeledList,
  Section,
  Stack,
} from '../../../components';
import { selectedData } from '../types';

export const VoreSelectedBellyVisuals = (props: { belly: selectedData }) => {
  const { act } = useBackend();

  const { belly } = props;
  const {
    belly_fullscreen,
    possible_fullscreens,
    disable_hud,
    belly_fullscreen_color,
    belly_fullscreen_color_secondary,
    belly_fullscreen_color_trinary,
    colorization_enabled,
    vore_sprite_flags,
    affects_voresprite,
    absorbed_voresprite,
    absorbed_multiplier,
    item_voresprite,
    item_multiplier,
    health_voresprite,
    resist_animation,
    voresprite_size_factor,
    belly_sprite_option_shown,
    belly_sprite_to_affect,
    undergarment_chosen,
    undergarment_if_none,
    tail_option_shown,
    tail_to_change_to,
  } = belly;

  return (
    <>
      <Section title="Vore Sprites">
        <Flex direction="row">
          <LabeledList>
            <LabeledList.Item label="Affect Vore Sprites">
              <Button
                onClick={() =>
                  act('set_attribute', { attribute: 'b_affects_vore_sprites' })
                }
                icon={affects_voresprite ? 'toggle-on' : 'toggle-off'}
                selected={affects_voresprite}
              >
                {affects_voresprite ? 'Yes' : 'No'}
              </Button>
            </LabeledList.Item>
            {affects_voresprite ? (
              <span>
                <LabeledList.Item label="Vore Sprite Mode">
                  {(vore_sprite_flags.length && vore_sprite_flags.join(', ')) ||
                    'None'}
                  <Button
                    onClick={() =>
                      act('set_attribute', { attribute: 'b_vore_sprite_flags' })
                    }
                    ml={1}
                    icon="plus"
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Count Absorbed prey for vore sprites">
                  <Button
                    onClick={() =>
                      act('set_attribute', {
                        attribute: 'b_count_absorbed_prey_for_sprites',
                      })
                    }
                    icon={absorbed_voresprite ? 'toggle-on' : 'toggle-off'}
                    selected={absorbed_voresprite}
                  >
                    {absorbed_voresprite ? 'Yes' : 'No'}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Absorbed Multiplier">
                  <Button
                    onClick={() =>
                      act('set_attribute', {
                        attribute: 'b_absorbed_multiplier',
                      })
                    }
                  >
                    {absorbed_multiplier}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Count items for vore sprites">
                  <Button
                    onClick={() =>
                      act('set_attribute', {
                        attribute: 'b_count_items_for_sprites',
                      })
                    }
                    icon={item_voresprite ? 'toggle-on' : 'toggle-off'}
                    selected={item_voresprite}
                  >
                    {item_voresprite ? 'Yes' : 'No'}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Items Multiplier">
                  <Button
                    onClick={() =>
                      act('set_attribute', { attribute: 'b_item_multiplier' })
                    }
                  >
                    {item_multiplier}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Prey health affects vore sprites">
                  <Button
                    onClick={() =>
                      act('set_attribute', {
                        attribute: 'b_health_impacts_size',
                      })
                    }
                    icon={health_voresprite ? 'toggle-on' : 'toggle-off'}
                    selected={health_voresprite}
                  >
                    {health_voresprite ? 'Yes' : 'No'}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Animation when prey resist">
                  <Button
                    onClick={() =>
                      act('set_attribute', { attribute: 'b_resist_animation' })
                    }
                    icon={resist_animation ? 'toggle-on' : 'toggle-off'}
                    selected={resist_animation}
                  >
                    {resist_animation ? 'Yes' : 'No'}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Vore Sprite Size Factor">
                  <Button
                    onClick={() =>
                      act('set_attribute', {
                        attribute: 'b_size_factor_sprites',
                      })
                    }
                  >
                    {voresprite_size_factor}
                  </Button>
                </LabeledList.Item>
                {belly_sprite_option_shown ? (
                  <LabeledList.Item label="Belly Sprite to affect">
                    <Button
                      onClick={() =>
                        act('set_attribute', {
                          attribute: 'b_belly_sprite_to_affect',
                        })
                      }
                    >
                      {belly_sprite_to_affect}
                    </Button>
                  </LabeledList.Item>
                ) : (
                  ''
                )}
                {tail_option_shown &&
                vore_sprite_flags.includes('Undergarment addition') ? (
                  <div>
                    <LabeledList.Item label="Undergarment type to affect">
                      <Button
                        onClick={() =>
                          act('set_attribute', {
                            attribute: 'b_undergarment_choice',
                          })
                        }
                      >
                        {undergarment_chosen}
                      </Button>
                    </LabeledList.Item>
                    <LabeledList.Item label="Undergarment if none equipped">
                      <Button
                        onClick={() =>
                          act('set_attribute', {
                            attribute: 'b_undergarment_if_none',
                          })
                        }
                      >
                        {undergarment_if_none}
                      </Button>
                    </LabeledList.Item>
                  </div>
                ) : (
                  ''
                )}
                {tail_option_shown &&
                vore_sprite_flags.includes('Tail adjustment') ? (
                  <LabeledList.Item label="Tail to change to">
                    <Button
                      onClick={() =>
                        act('set_attribute', {
                          attribute: 'b_tail_to_change_to',
                        })
                      }
                    >
                      {tail_to_change_to}
                    </Button>
                  </LabeledList.Item>
                ) : (
                  ''
                )}
              </span>
            ) : (
              ''
            )}
          </LabeledList>
        </Flex>
      </Section>
      <Section title="Belly Fullscreens Preview and Coloring">
        <Stack align="center">
          <Stack.Item shrink>
            <Box
              backgroundColor={belly_fullscreen_color}
              width="20px"
              height="20px"
            />
          </Stack.Item>
          <Stack.Item grow>
            <Button
              fluid
              icon="eye-dropper"
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_fullscreen_color',
                  val: null,
                })
              }
            >
              Select Primary Color
            </Button>
          </Stack.Item>
          <Stack.Item shrink>
            <Box
              backgroundColor={belly_fullscreen_color_secondary}
              width="20px"
              height="20px"
            />
          </Stack.Item>
          <Stack.Item grow>
            <Button
              fluid
              icon="eye-dropper"
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_fullscreen_color_secondary',
                  val: null,
                })
              }
            >
              Select Secondary Color
            </Button>
          </Stack.Item>
          <Stack.Item shrink>
            <Box
              backgroundColor={belly_fullscreen_color_trinary}
              width="20px"
              height="20px"
            />
          </Stack.Item>
          <Stack.Item grow>
            <Button
              fluid
              icon="eye-dropper"
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_fullscreen_color_trinary',
                  val: null,
                })
              }
            >
              Select Trinary Color
            </Button>
          </Stack.Item>
        </Stack>
        <Box mt={1}>
          <LabeledList>
            <LabeledList.Item label="Enable Coloration">
              <Button
                onClick={() =>
                  act('set_attribute', { attribute: 'b_colorization_enabled' })
                }
                icon={colorization_enabled ? 'toggle-on' : 'toggle-off'}
                selected={colorization_enabled}
              >
                {colorization_enabled ? 'Yes' : 'No'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Preview Belly">
              <Button
                onClick={() =>
                  act('set_attribute', { attribute: 'b_preview_belly' })
                }
              >
                Preview
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Clear Preview">
              <Button
                onClick={() =>
                  act('set_attribute', { attribute: 'b_clear_preview' })
                }
              >
                Clear
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Box>
      </Section>
      <Section>
        <Section title="Vore FX">
          <LabeledList>
            <LabeledList.Item label="Disable Prey HUD">
              <Button
                onClick={() =>
                  act('set_attribute', { attribute: 'b_disable_hud' })
                }
                icon={disable_hud ? 'toggle-on' : 'toggle-off'}
                selected={disable_hud}
              >
                {disable_hud ? 'Yes' : 'No'}
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Belly Fullscreens Styles">
          Belly styles:
          <Button
            fluid
            selected={belly_fullscreen === '' || belly_fullscreen === null}
            onClick={() =>
              act('set_attribute', { attribute: 'b_fullscreen', val: null })
            }
          >
            Disabled
          </Button>
          {Object.keys(possible_fullscreens).map((key, index) => (
            <span key={index} style={{ width: '256px' }}>
              <Button
                key={key}
                width="256px"
                height="256px"
                selected={key === belly_fullscreen}
                onClick={() =>
                  act('set_attribute', { attribute: 'b_fullscreen', val: key })
                }
              >
                <Box
                  className={classes(['vore240x240', key])}
                  style={{
                    transform: 'translate(0%, 4%)',
                  }}
                />
              </Button>
            </span>
          ))}
        </Section>
      </Section>
    </>
  );
};
