import { capitalize } from 'common/string';
import { useBackend } from '../backend';
import { Box, ByondUi, Button, Flex, LabeledList, Section, ColorBox } from '../components';
import { Window } from '../layouts';

export const BodyDesigner = (props, context) => {
  const { act, data } = useBackend(context);

  const { menu, disk, diskStored, activeBodyRecord } = data;

  let body = MenuToTemplate[menu];

  return (
    <Window width={400} height={650}>
      <Window.Content>
        {disk ? (
          <Box>
            <Button
              icon="save"
              content="Save To Disk"
              onClick={() => act('savetodisk')}
              disabled={!activeBodyRecord}
            />
            <Button
              icon="save"
              content="Load From Disk"
              onClick={() => act('loadfromdisk')}
              disabled={!diskStored}
            />
            <Button
              icon="eject"
              content="Eject"
              onClick={() => act('ejectdisk')}
            />
          </Box>
        ) : null}
        {body}
      </Window.Content>
    </Window>
  );
};

const BodyDesignerMain = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Section title="Database Functions">
      <Button
        icon="eye"
        content="View Individual Body Records"
        onClick={() => act('menu', { menu: 'Body Records' })}
      />
      <Button
        icon="eye"
        content="View Stock Body Records"
        onClick={() => act('menu', { menu: 'Stock Records' })}
      />
    </Section>
  );
};

const BodyDesignerBodyRecords = (props, context) => {
  const { act, data } = useBackend(context);
  const { bodyrecords } = data;
  return (
    <Section
      title="Body Records"
      buttons={
        <Button
          icon="arrow-left"
          content="Back"
          onClick={() => act('menu', { menu: 'Main' })}
        />
      }>
      {bodyrecords.map((record) => (
        <Button
          icon="eye"
          key={record.name}
          content={record.name}
          onClick={() => act('view_brec', { view_brec: record.recref })}
        />
      ))}
    </Section>
  );
};

const BodyDesignerStockRecords = (props, context) => {
  const { act, data } = useBackend(context);
  const { stock_bodyrecords } = data;
  return (
    <Section
      title="Stock Records"
      buttons={
        <Button
          icon="arrow-left"
          content="Back"
          onClick={() => act('menu', { menu: 'Main' })}
        />
      }>
      {stock_bodyrecords.map((record) => (
        <Button
          icon="eye"
          key={record}
          content={record}
          onClick={() => act('view_stock_brec', { view_stock_brec: record })}
        />
      ))}
    </Section>
  );
};

const BodyDesignerSpecificRecord = (props, context) => {
  const { act, data } = useBackend(context);
  const { activeBodyRecord, mapRef } = data;
  return activeBodyRecord ? (
    <Flex direction="column">
      <Flex.Item basis="165px">
        <Section
          title="Specific Record"
          buttons={
            <Button
              icon="arrow-left"
              content="Back"
              onClick={() => act('menu', { menu: 'Main' })}
            />
          }>
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
                content={capitalize(activeBodyRecord.gender)}
                onClick={() =>
                  act('href_conversion', {
                    target_href: 'bio_gender',
                    target_value: 1,
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="Synthetic">
              {activeBodyRecord.synthetic}
            </LabeledList.Item>
            <LabeledList.Item label="Mind Compat">
              {activeBodyRecord.locked}
              <Button
                ml={1}
                icon="eye"
                content="View OOC Notes"
                disabled={!activeBodyRecord.booc}
                onClick={() => act('boocnotes')}
              />
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
                content={activeBodyRecord.scale}
                onClick={() =>
                  act('href_conversion', {
                    target_href: 'size_multiplier',
                    target_value: 1,
                  })
                }
              />
            </LabeledList.Item>
            {Object.keys(activeBodyRecord.styles).map((key) => {
              const style = activeBodyRecord.styles[key];
              return (
                <LabeledList.Item key={key} label={key}>
                  {style.styleHref ? (
                    <Button
                      icon="pen"
                      content={style.style}
                      onClick={() =>
                        act('href_conversion', {
                          target_href: style.styleHref,
                          target_value: 1,
                        })
                      }
                    />
                  ) : null}
                  {style.colorHref ? (
                    <Box>
                      <Button
                        icon="pen"
                        content={style.color}
                        onClick={() =>
                          act('href_conversion', {
                            target_href: style.colorHref,
                            target_value: 1,
                          })
                        }
                      />
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
                  ) : null}
                  {style.colorHref2 ? (
                    <Box>
                      <Button
                        icon="pen"
                        content={style.color2}
                        onClick={() =>
                          act('href_conversion', {
                            target_href: style.colorHref2,
                            target_value: 1,
                          })
                        }
                      />
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
                  ) : null}
                </LabeledList.Item>
              );
            })}
            <LabeledList.Item label="Body Markings">
              <Button
                icon="plus"
                content="Add Marking"
                onClick={() =>
                  act('href_conversion', {
                    target_href: 'marking_style',
                    target_value: 1,
                  })
                }
              />
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
                            content={key}
                            onClick={() =>
                              act('href_conversion', {
                                target_href: 'marking_color',
                                target_value: key,
                              })
                            }
                          />
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

const BodyDesignerOOCNotes = (props, context) => {
  const { act, data } = useBackend(context);
  const { activeBodyRecord } = data;
  return (
    <Section
      title="Body OOC Notes (This is OOC!)"
      height="100%"
      scrollable
      buttons={
        <Button
          icon="arrow-left"
          content="Back"
          onClick={() => act('menu', { menu: 'Specific Record' })}
        />
      }
      style={{ 'word-break': 'break-all' }}>
      {(activeBodyRecord && activeBodyRecord.booc) ||
        'ERROR: Body record not found!'}
    </Section>
  );
};

const MenuToTemplate = {
  'Main': <BodyDesignerMain />,
  'Body Records': <BodyDesignerBodyRecords />,
  'Stock Records': <BodyDesignerStockRecords />,
  'Specific Record': <BodyDesignerSpecificRecord />,
  'OOC Notes': <BodyDesignerOOCNotes />,
};
