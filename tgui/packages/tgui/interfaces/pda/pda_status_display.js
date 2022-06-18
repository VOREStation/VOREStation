import { useBackend } from "../../backend";
import { Box, Button, LabeledList } from "../../components";

export const pda_status_display = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    records,
  } = data;

  return (
    <Box>
      <LabeledList>
        <LabeledList.Item label="Code">
          <Button
            color="transparent"
            icon="trash"
            content="Clear"
            onClick={() => act("Status", { statdisp: "blank" })} />
          <Button
            color="transparent"
            icon="cog"
            content="Evac ETA"
            onClick={() => act("Status", { statdisp: "shuttle" })} />
          <Button
            color="transparent"
            icon="cog"
            content="Message"
            onClick={() => act("Status", { statdisp: "message" })} />
          <Button
            color="transparent"
            icon="exclamation-triangle"
            content="ALERT"
            onClick={() => act("Status", { statdisp: "alert" })} />
        </LabeledList.Item>
        <LabeledList.Item label="Message line 1">
          <Button
            content={records.message1 + " (set)"}
            icon="pen"
            onClick={() => act("Status", { statdisp: "setmsg1" })} />
        </LabeledList.Item>
        <LabeledList.Item label="Message line 2">
          <Button
            content={records.message2 + " (set)"}
            icon="pen"
            onClick={() => act("Status", { statdisp: "setmsg2" })} />
        </LabeledList.Item>
      </LabeledList>
    </Box>
  );
};
