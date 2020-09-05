import { round } from 'common/math';
import { capitalize } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from "../backend";
import { Box, Button, Flex, Collapsible, Icon, LabeledList, NoticeBox, Section, Tabs } from "../components";
import { Window } from "../layouts";

export const XenoarchReplicator = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    tgui_construction,
  } = data;

  return (
    <Window theme="abductor" width={400} height={400} resizable>
      <Window.Content scrollable>
        {tgui_construction.map((button, i) => (
          <Button
            key={button.key}
            color={button.background}
            icon={button.icon}
            iconColor={button.foreground}
            fontSize={4}
            onClick={() => act("construct", { key: button.key })} />
        ))}
      </Window.Content>
    </Window>
  );
};