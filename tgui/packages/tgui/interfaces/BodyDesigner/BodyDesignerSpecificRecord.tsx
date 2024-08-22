import { capitalize } from 'common/string';

import { useBackend } from '../../backend';
import {
  Box,
  Button,
  ByondUi,
  ColorBox,
  Flex,
  LabeledList,
  Section,
} from '../../components';
import { activeBodyRecord } from './types';

export const BodyDesignerSpecificRecord = (props: {
  activeBodyRecord: activeBodyRecord;
  mapRef: string;
}) => {
  const { act } = useBackend();
  const { activeBodyRecord, mapRef } = props;
  return activeBodyRecord ? (
    <Flex direction="column">
      <Flex.Item basis="165px">
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
          <LabeledList>
            <LabeledList.Item label="Name">
              {activeBodyRecord.real_name}
            </LabeledList.Item>
            <LabeledList.Item label="Species">
              {activeBodyRecord.speciesname}
            </LabeledList.Item>
            <LabeledList.Item label="Bio. Sex">
              <Button
                icon="pen"
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
            <LabeledList.Item label="Mind Compat">
              {activeBodyRecord.locked}
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
      </Flex.Item>
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
      <Flex.Item basis="300px">
        <Section title="Customize" height="300px" style={{ overflow: 'auto' }}>
          <LabeledList>
            <LabeledList.Item label="Scale">
              <Button
                icon="pen"
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
            {Object.keys(activeBodyRecord.styles).map((key) => {
              const style = activeBodyRecord.styles[key];
              return (
                <LabeledList.Item key={key} label={key}>
                  {style.styleHref ? (
                    <Button
                      icon="pen"
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
                </LabeledList.Item>
              );
            })}
            <LabeledList.Item label="Digitigrade">
              <Button
                icon="pen"
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
            <LabeledList.Item label="Body Markings">
              <Button
                icon="plus"
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
          </LabeledList>
        </Section>
      </Flex.Item>
    </Flex>
  ) : (
    <Box color="bad">ERROR: Record Not Found!</Box>
  );
};
