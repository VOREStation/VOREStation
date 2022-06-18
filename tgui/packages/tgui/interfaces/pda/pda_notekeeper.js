/* eslint react/no-danger: "off" */
import { useBackend } from "../../backend";
import { Box, Button, Section } from "../../components";

export const pda_notekeeper = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    note,
  } = data;

  return (
    <Box>
      <Section>
        { /* As usual with dangerouslySetInnerHTML,
            this notekeeper was designed to use HTML injection.
            Fix when markdown is easier. */ }
        <div dangerouslySetInnerHTML={{ __html: note }} />
      </Section>
      <Button
        icon="pen"
        onClick={() => act("Edit")}
        content="Edit Notes" />
    </Box>
  );
};
