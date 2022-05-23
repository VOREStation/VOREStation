import { round } from 'common/math';
import { Fragment } from 'inferno';
import { useBackend } from "../backend";
import { Box, Button, Flex, NoticeBox, LabeledList, Section } from "../components";
import { Window } from "../layouts";

export const TelecommsMachineBrowser = (props, context) => {
  const { act, data } = useBackend(context);
  
  const {
    network,
    temp,
    machinelist,
    selectedMachine,
  } = data;
  
  return (
    <Window
      width={575}
      height={450}
      resizable>
      <Window.Content scrollable>
        {temp ? (
          <NoticeBox danger={temp.color === "bad"} warning={temp.color !== "bad"}>
            <Box display="inline-box" verticalAlign="middle">
              {temp.text}
            </Box>
            <Button
              icon="times-circle"
              float="right"
              onClick={() => act('cleartemp')} />
            <Box clear="both" />
          </NoticeBox>
        ) : null}
        <Section title="Network Control">
          <LabeledList>
            <LabeledList.Item
              label="Current Network"
              buttons={(
                <Fragment>
                  <Button
                    icon="search"
                    content="Probe Network"
                    onClick={() => act("scan")} />
                  <Button
                    color="bad"
                    icon="exclamation-triangle"
                    content="Flush Buffer"
                    disabled={machinelist.length === 0}
                    onClick={() => act('release')} />
                </Fragment>
              )}>
              <Button
                content={network}
                icon="pen"
                onClick={() => act('network')} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {(machinelist && machinelist.length) ? (
          <TelecommsBrowser
            title={selectedMachine
              ? selectedMachine.name
                + " (" + selectedMachine.id + ")"
              : "Detected Network Entities"}
            list={selectedMachine ? selectedMachine.links : machinelist}
            showBack={selectedMachine} />
        ) : (
          <Section title="No Devices Found">
            <Button
              icon="search"
              content="Probe Network"
              onClick={() => act("scan")} />
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};

const TelecommsBrowser = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    list,
    title,
    showBack,
  } = props;

  return (
    <Section
      title={title}
      buttons={showBack && (
        <Button
          icon="undo"
          content="Back to Main Menu"
          onClick={() => act("mainmenu")} />
      )}>
      <Box color="label"><u>Linked entities</u></Box>
      <LabeledList>
        {list.length ? list.map(machine => (
          <LabeledList.Item
            key={machine.id}
            label={machine.name + " (" + machine.id + ")"}>
            <Button
              content="View"
              icon="eye"
              onClick={() => act("view", { id: machine.id })} />
          </LabeledList.Item>
        )) : (
          <LabeledList.Item color="bad">
            No links detected.
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};