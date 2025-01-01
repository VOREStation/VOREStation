import { capitalize } from 'common/string';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  ColorBox,
  Flex,
  LabeledList,
  Section,
} from 'tgui/components';
import { ByondUi } from 'tgui-core/components';

import { activeBodyRecord } from './types';

export const BodyDesignerSpecificRecord = (props: {
  activeBodyRecord: activeBodyRecord;
  mapRef: string;
}) => {
  const { act } = useBackend();
  const { activeBodyRecord, mapRef } = props;
  return activeBodyRecord ? (
    <Flex direction="column">
      <Section
        title="Specific Record"
        buttons={
          <Button
            icon="arrow-left"
            onClick={() => act('menu', { menu: 'Main' })}
          >
            Back
          </Button>
        }
      >
        <Flex.Item basis="175px">
          <Flex.Item basis="130px">
            <ByondUi
              style={{
                width: '100%',
                height: '128px',
              }}
              params={{
                id: mapRef,
                type: 'map',
              }}
            />
          </Flex.Item>
        </Flex.Item>
      </Section>
      <Flex.Item basis="600px">
        <Flex direction="row">
          <Flex.Item basis="48%">
            <Section title="General">
              <LabeledList>
                <LabeledList.Item label="Name">
                  <Button
                    icon="pen"
                    disabled={activeBodyRecord.locked === 1}
                    onClick={() =>
                      act('href_conversion', {
                        target_href: 'rename',
                        target_value: 1,
                      })
                    }
                  >
                    {activeBodyRecord.real_name}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Species">
                  <Button
                    icon="pen"
                    disabled={activeBodyRecord.locked === 1}
                    onClick={() =>
                      act('href_conversion', {
                        target_href: 'custom_species',
                        target_value: 1,
                      })
                    }
                  >
                    {activeBodyRecord.speciesname}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Bio. Sex">
                  <Button
                    icon="pen"
                    disabled={activeBodyRecord.locked === 1}
                    onClick={() =>
                      act('href_conversion', {
                        target_href: 'bio_gender',
                        target_value: 1,
                      })
                    }
                  >
                    {capitalize(activeBodyRecord.gender)}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Synthetic">
                  {activeBodyRecord.synthetic}
                </LabeledList.Item>
                <LabeledList.Item label="Weight">
                  <Button
                    icon="pen"
                    disabled={activeBodyRecord.locked === 1}
                    onClick={() =>
                      act('href_conversion', {
                        target_href: 'weight',
                        target_value: 1,
                      })
                    }
                  >
                    {activeBodyRecord.weight}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Blood">
                  <Button
                    icon="pen"
                    disabled={activeBodyRecord.locked === 1}
                    onClick={() =>
                      act('href_conversion', {
                        target_href: 'blood_type',
                        target_value: 1,
                      })
                    }
                  >
                    {capitalize(activeBodyRecord.blood_type)}
                  </Button>
                  <Button
                    icon="pen"
                    disabled={activeBodyRecord.locked === 1}
                    onClick={() =>
                      act('href_conversion', {
                        target_href: 'blood_reagents',
                        target_value: 1,
                      })
                    }
                  >
                    {activeBodyRecord.blood_reagents}
                  </Button>
                  <Button
                    icon="pen"
                    backgroundColor={activeBodyRecord.blood_color}
                    disabled={activeBodyRecord.locked === 1}
                    onClick={() =>
                      act('href_conversion', {
                        target_href: 'blood_color',
                        target_value: 1,
                      })
                    }
                  >
                    Color
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Species Sound">
                  <Button
                    icon="pen"
                    disabled={activeBodyRecord.locked === 1}
                    onClick={() =>
                      act('href_conversion', {
                        target_href: 'species_sound_options',
                        target_value: 1,
                      })
                    }
                  >
                    {activeBodyRecord.species_sound}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Mind Compat">
                  {activeBodyRecord.locked ? 'Low' : 'High'}
                  <Button
                    ml={1}
                    icon="eye"
                    disabled={!activeBodyRecord.booc}
                    onClick={() => act('boocnotes')}
                  >
                    View OOC Notes
                  </Button>
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <Section title="Flavor Text">
              <LabeledList>
                {Object.keys(activeBodyRecord.flavors).map((key) => {
                  return (
                    <LabeledList.Item key={key} label={capitalize(key)}>
                      <Button
                        icon="pen"
                        disabled={activeBodyRecord.locked === 1}
                        onClick={() =>
                          act('href_conversion', {
                            target_href: 'flavor_text',
                            target_value: key,
                          })
                        }
                      >
                        Edit
                      </Button>
                      <br />
                      {activeBodyRecord.flavors[key]}
                    </LabeledList.Item>
                  );
                })}
              </LabeledList>
            </Section>
          </Flex.Item>
          <Flex.Item basis="50%">
            <Section title="Unique Identifiers">
              <LabeledList.Item label="Scale">
                <Button
                  icon="pen"
                  disabled={activeBodyRecord.locked === 1}
                  onClick={() =>
                    act('href_conversion', {
                      target_href: 'size_multiplier',
                      target_value: 1,
                    })
                  }
                >
                  {activeBodyRecord.scale}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Scaled Appearance">
                <Button
                  icon="pen"
                  disabled={activeBodyRecord.locked === 1}
                  onClick={() =>
                    act('href_conversion', {
                      target_href: 'toggle_fuzzy',
                      target_value: 1,
                    })
                  }
                >
                  {activeBodyRecord.scale_appearance}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Scaling Center">
                <Button
                  icon="pen"
                  disabled={activeBodyRecord.locked === 1}
                  onClick={() =>
                    act('href_conversion', {
                      target_href: 'toggle_offset_override',
                      target_value: 1,
                    })
                  }
                >
                  {activeBodyRecord.offset_override}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Digitigrade">
                <Button
                  icon="pen"
                  disabled={activeBodyRecord.locked === 1}
                  onClick={() =>
                    act('href_conversion', {
                      target_href: 'digitigrade',
                      target_value: 1,
                    })
                  }
                >
                  {activeBodyRecord.digitigrade ? 'Yes' : 'No'}
                </Button>
              </LabeledList.Item>
              {Object.keys(activeBodyRecord.styles).map((key) => {
                const style = activeBodyRecord.styles[key];
                return (
                  <LabeledList.Item key={key} label={key}>
                    {style.styleHref ? (
                      <Button
                        icon="pen"
                        disabled={activeBodyRecord.locked === 1}
                        onClick={() =>
                          act('href_conversion', {
                            target_href: style.styleHref,
                            target_value: 1,
                          })
                        }
                      >
                        {style.style}
                      </Button>
                    ) : (
                      ''
                    )}
                    {style.colorHref ? (
                      <Box>
                        <Button
                          icon="pen"
                          disabled={activeBodyRecord.locked === 1}
                          onClick={() =>
                            act('href_conversion', {
                              target_href: style.colorHref,
                              target_value: 1,
                            })
                          }
                        >
                          {style.color}
                        </Button>
                        <ColorBox
                          verticalAlign="top"
                          width="32px"
                          height="20px"
                          color={style.color}
                          style={{
                            border: '1px solid #fff',
                          }}
                        />
                      </Box>
                    ) : (
                      ''
                    )}
                    {style.colorHref2 ? (
                      <Box>
                        <Button
                          icon="pen"
                          disabled={activeBodyRecord.locked === 1}
                          onClick={() =>
                            act('href_conversion', {
                              target_href: style.colorHref2,
                              target_value: 1,
                            })
                          }
                        >
                          {style.color2}
                        </Button>
                        <ColorBox
                          verticalAlign="top"
                          width="32px"
                          height="20px"
                          color={style.color2}
                          style={{
                            border: '1px solid #fff',
                          }}
                        />
                      </Box>
                    ) : (
                      ''
                    )}
                    {style.colorHref3 ? (
                      <Box>
                        <Button
                          icon="pen"
                          disabled={activeBodyRecord.locked === 1}
                          onClick={() =>
                            act('href_conversion', {
                              target_href: style.colorHref3,
                              target_value: 1,
                            })
                          }
                        >
                          {style.color3}
                        </Button>
                        <ColorBox
                          verticalAlign="top"
                          width="32px"
                          height="20px"
                          color={style.color3}
                          style={{
                            border: '1px solid #fff',
                          }}
                        />
                      </Box>
                    ) : (
                      ''
                    )}
                  </LabeledList.Item>
                );
              })}
              <LabeledList.Item label="Body Markings">
                <Button
                  icon="plus"
                  disabled={activeBodyRecord.locked === 1}
                  onClick={() =>
                    act('href_conversion', {
                      target_href: 'marking_style',
                      target_value: 1,
                    })
                  }
                >
                  Add Marking
                </Button>
                <Flex wrap="wrap" justify="center" align="center">
                  {Object.keys(activeBodyRecord.markings).map((key) => {
                    const marking = activeBodyRecord.markings[key];
                    return (
                      <Flex.Item basis="100%" key={key}>
                        <Flex>
                          <Flex.Item>
                            <Button
                              mr={0.2}
                              fluid
                              icon="times"
                              color="red"
                              disabled={activeBodyRecord.locked === 1}
                              onClick={() =>
                                act('href_conversion', {
                                  target_href: 'marking_remove',
                                  target_value: key,
                                })
                              }
                            />
                          </Flex.Item>
                          <Flex.Item grow={1}>
                            <Button
                              fluid
                              backgroundColor={marking}
                              disabled={activeBodyRecord.locked === 1}
                              onClick={() =>
                                act('href_conversion', {
                                  target_href: 'marking_color',
                                  target_value: key,
                                })
                              }
                            >
                              {key}
                            </Button>
                          </Flex.Item>
                        </Flex>
                      </Flex.Item>
                    );
                  })}
                </Flex>
              </LabeledList.Item>
            </Section>
          </Flex.Item>
        </Flex>
      </Flex.Item>
    </Flex>
  ) : (
    <Box color="bad">ERROR: Record Not Found!</Box>
  );
};
