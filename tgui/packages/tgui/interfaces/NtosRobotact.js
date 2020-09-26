import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { toTitleCase } from 'common/string';
import { useBackend, useSharedState } from '../backend';
import { AnimatedNumber, Box, Button, Flex, Fragment, Icon, NoticeBox, Section, Slider, ProgressBar, LabeledList, Table, Tabs } from '../components';
import { NtosWindow } from '../layouts';

export const NtosRobotact = (props, context) => {
  const { act, data } = useBackend(context);
  const { PC_device_theme } = data;
  return (
    <NtosWindow
      width={800}
      height={600}
      theme={PC_device_theme}>
      <NtosWindow.Content>
        <NtosRobotactContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const NtosRobotactContent = (props, context) => {
  const { act, data } = useBackend(context);
  const [tab_main, setTab_main] = useSharedState(context, 'tab_main', 1);
  const {
    charge,
    maxcharge,
    integrity,
    lampIntensity,
    cover,
    locomotion,
    wireModule,
    wireCamera,
    wireAI,
    wireLaw,
    sensors,
    printerPictures,
    printerToner,
    printerTonerMax,
    thrustersInstalled,
    thrustersStatus,
    components,
  } = data;
  const borgName = data.name || [];
  const borgType = data.designation || [];
  const masterAI = data.masterAI || [];
  const laws = data.Laws || [];
  const borgLog = data.borgLog || [];
  const borgUpgrades = data.borgUpgrades || [];
  return (
    <Flex
      direction={"column"}>
      <Flex.Item
        position="relative"
        mb={1}>
        <Tabs>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab_main === 1}
            onClick={() => setTab_main(1)}>
            Status
          </Tabs.Tab>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab_main === 2}
            onClick={() => setTab_main(2)}>
            Diagnostics
          </Tabs.Tab>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab_main === 3}
            onClick={() => setTab_main(3)}>
            Logs
          </Tabs.Tab>
        </Tabs>
      </Flex.Item>
      {tab_main === 1 && <NtosRobotactPrimary />}
      {tab_main === 2 && <NtosRobotactDiagnostics />}
      {tab_main === 3 && (
        <Flex.Item>
          <Section
            backgroundColor="black"
            height={40}>
            <NtosWindow.Content scrollable>
              {borgLog.map(log => (
                <Box
                  mb={1}
                  key={log}>
                  <font color="green">{log}</font>
                </Box>
              ))}
            </NtosWindow.Content>
          </Section>
        </Flex.Item>
      )}
    </Flex>
  );
};

const NtosRobotactPrimary = (props, context) => {
  const { act, data } = useBackend(context);
  const [tab_sub, setTab_sub] = useSharedState(context, 'tab_sub', 1);
  const {
    charge,
    maxcharge,
    integrity,
    lampIntensity,
    cover,
    sensors,
    printerPictures,
    printerToner,
    printerTonerMax,
    thrustersInstalled,
    thrustersStatus,
    components,
    isdrone,
  } = data;
  const borgName = data.name || [];
  const borgType = data.designation || [];
  const masterAI = data.masterAI || [];
  const laws = data.Laws || [];
  const borgLog = data.borgLog || [];
  const borgUpgrades = data.borgUpgrades || [];

  const toggleComponents = flow([
    filter(c => c.can_toggle),
    sortBy(c => c.name),
  ])(components);

  return (
    <Fragment>
      <Flex
        direction={"row"}>
        <Flex.Item
          width="30%">
          <Section
            title="Configuration"
            fill>
            <LabeledList>
              <LabeledList.Item
                label="Unit">
                {borgName.slice(0, 17)}
              </LabeledList.Item>
              <LabeledList.Item
                label="Type">
                {borgType}
              </LabeledList.Item>
              <LabeledList.Item
                label="AI">
                {masterAI.slice(0, 17)}
              </LabeledList.Item>
            </LabeledList>
          </Section>
        </Flex.Item>
        <Flex.Item
          grow={1}
          ml={1}>
          <Section
            title="Status"
            buttons={
              <Button
                icon="pen"
                content="Change Name"
                onClick={() => act("namepick")} />
            }>
            Charge:
            <Button
              content="Power Alert"
              disabled={charge}
              onClick={() => act('alertPower')} />
            <ProgressBar
              value={charge / maxcharge}
              ranges={{
                good: [0.5, Infinity],
                average: [0.1, 0.5],
                bad: [-Infinity, 0.1],
              }}>
              <AnimatedNumber value={charge} />
            </ProgressBar>
            Chassis Integrity:
            <ProgressBar
              value={integrity}
              minValue={0}
              maxValue={150}
              ranges={{
                bad: [-Infinity, 25],
                average: [25, 100],
                good: [100, Infinity],
              }} />
          </Section>
          <Section
            title="Lamp Power">
            <Slider
              value={lampIntensity}
              step={1}
              stepPixelSize={25}
              maxValue={6}
              minValue={1}
              onChange={(e, value) => act('lampIntensity', {
                ref: value,
              })} />
            Lamp power usage: {lampIntensity/2} watts
          </Section>
        </Flex.Item>
        <Flex.Item
          width="50%"
          ml={1}>
          <Section
            fitted>
            <Tabs
              fluid={1}
              textAlign="center">
              <Tabs.Tab
                icon=""
                lineHeight="23px"
                selected={tab_sub === 1}
                onClick={() => setTab_sub(1)}>
                Actions
              </Tabs.Tab>
              <Tabs.Tab
                icon=""
                lineHeight="23px"
                selected={tab_sub === 2}
                onClick={() => setTab_sub(2)}>
                Components
              </Tabs.Tab>
              <Tabs.Tab
                icon=""
                lineHeight="23px"
                selected={tab_sub === 3}
                onClick={() => setTab_sub(3)}>
                Upgrades
              </Tabs.Tab>
            </Tabs>
            {tab_sub === 1 && (
              <Box>
                <LabeledList>
                  {!!isdrone && (
                    <LabeledList.Item label="Mail Tag">
                      <Button
                        icon="pen"
                        content="Set"
                        onClick={() => act("setMailTag")} />
                    </LabeledList.Item>
                  )}
                  <LabeledList.Item
                    label="Harmlessly Spark">
                    <Button
                      content="Spark"
                      onClick={() => act("spark")} />
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Maintenance Cover">
                    <Button.Confirm
                      content="Unlock"
                      disabled={cover==="UNLOCKED"}
                      onClick={() => act('coverunlock')} />
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Sensor Overlay">
                    <Button
                      content={sensors}
                      onClick={() => act('toggleSensors')} />
                  </LabeledList.Item>
                  <LabeledList.Item
                    label={"Stored Photos (" + printerPictures + ")"}>
                    <Button
                      content="View"
                      disabled={!printerPictures}
                      onClick={() => act('viewImage')} />
                    <Button
                      content="Delete"
                      disabled={!printerPictures}
                      onClick={() => act('deleteImage')} />
                    <Button
                      content="Print"
                      disabled={!printerPictures}
                      onClick={() => act('printImage')} />
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Printer Toner">
                    <ProgressBar
                      value={printerToner / printerTonerMax} />
                  </LabeledList.Item>
                  {!!thrustersInstalled && (
                    <LabeledList.Item
                      label="Toggle Thrusters">
                      <Button
                        disabled
                        content={thrustersStatus}
                        onClick={() => act('toggleThrusters')} />
                    </LabeledList.Item>
                  )}
                </LabeledList>
              </Box>
            )}
            {tab_sub === 2 && (
              <Box>
                {(toggleComponents).map(c => (
                  <Button.Checkbox
                    key={c.name}
                    fluid
                    content={c.name}
                    checked={c.toggled}
                    onClick={() => act("toggleComponent", { name: c.name })} />
                ))}
              </Box>
            )}
            {tab_sub === 3 && (
              <Box>
                {borgUpgrades.map(upgrade => (
                  <Box
                    mb={1}
                    key={upgrade}>
                    {upgrade}
                  </Box>
                ))}
              </Box>
            )}
          </Section>
        </Flex.Item>
      </Flex>
      <Flex.Item
        height={20}
        mt={1}>
        <Section
          title="Laws"
          fill
          scrollable
          buttons={(
            <Fragment>
              <Button
                icon="external-link-alt"
                content="Law Management"
                onClick={() => act("lawpanel")} />
              <Button
                icon="volume-up"
                content="State Laws"
                onClick={() => act('lawstate')} />
            </Fragment>
          )}>
          {laws.map(law => (
            <Box
              mb={1}
              key={law}>
              {law}
            </Box>
          ))}
        </Section>
      </Flex.Item>
    </Fragment>
  );
};

const NtosRobotactDiagnostics = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    charge,
    maxcharge,
    integrity,
    lampIntensity,
    cover,
    locomotion,
    wireModule,
    wireCamera,
    wireAI,
    wireLaw,
    sensors,
    printerPictures,
    printerToner,
    printerTonerMax,
    thrustersInstalled,
    thrustersStatus,
    components,
    diagnosisAvailable,
  } = data;
  const borgName = data.name || [];
  const borgType = data.designation || [];
  const masterAI = data.masterAI || [];
  const laws = data.Laws || [];
  const borgLog = data.borgLog || [];
  const borgUpgrades = data.borgUpgrades || [];
  return (
    <Section noTopPadding scrollable>
      <Section level={2} title="Status">
        <Flex>
          <Flex.Item>
            <LabeledList>
              <LabeledList.Item
                label="AI Connection"
                color={wireAI==="FAULT"?'red': wireAI==="READY"?'yellow': 'green'}>
                {wireAI}
              </LabeledList.Item>
              <LabeledList.Item
                label="LawSync"
                color={wireLaw==="FAULT"?"red":"green"}>
                {wireLaw}
              </LabeledList.Item>
            </LabeledList>
          </Flex.Item>
          <Flex.Item>
            <LabeledList>
              <LabeledList.Item
                label="Camera"
                color={wireCamera==="FAULT"?'red': wireCamera==="DISABLED"?'yellow': 'green'}>
                {wireCamera}
              </LabeledList.Item>
              <LabeledList.Item
                label="Module Controller"
                color={wireModule==="FAULT"?"red":"green"}>
                {wireModule}
              </LabeledList.Item>
            </LabeledList>
          </Flex.Item>
          <Flex.Item>
            <LabeledList>
              <LabeledList.Item
                label="Motor Controller"
                color={locomotion==="FAULT"?'red': locomotion==="DISABLED"?'yellow': 'green'}>
                {locomotion}
              </LabeledList.Item>
              <LabeledList.Item
                label="Maintenance Cover"
                color={cover==="UNLOCKED"?"red":"green"}>
                {cover}
              </LabeledList.Item>
            </LabeledList>
          </Flex.Item>
        </Flex>
      </Section>
      <Section level={2} title="Components">
        <Flex wrap="wrap" spacing={1} justify="space-between">
          {sortBy(c => c.name)(components).map(c => (
            <Flex.Item key={c.name} basis="32%" mb={1}>
              <Section title={toTitleCase(c.name)} buttons={!!c.can_toggle && (
                <Button.Checkbox
                  content={c.toggled ? "Enabled" : "Disabled"}
                  checked={c.toggled}
                  onClick={() => act("toggleComponent", { name: c.name })} />
              )}>
                <LabeledList>
                  {diagnosisAvailable && (
                    <Fragment>
                      <LabeledList.Item label="Brute Damage">
                        {c.brute}
                      </LabeledList.Item>
                      <LabeledList.Item label="Electronics Damage">
                        {c.electronics}
                      </LabeledList.Item>
                      <LabeledList.Item label="Powered">
                        {c.powered ? "True" : "False"}
                      </LabeledList.Item>
                    </Fragment>
                  ) || (
                    <LabeledList.Item label="Warning" color="average">
                      Diagnosis unit offline. Advanced statistics unavailable.
                    </LabeledList.Item>
                  )}
                  <LabeledList.Item label="Toggled">
                    {c.toggled ? "True" : "False"}
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            </Flex.Item>
          ))}
        </Flex>
      </Section>
    </Section>
  );
};