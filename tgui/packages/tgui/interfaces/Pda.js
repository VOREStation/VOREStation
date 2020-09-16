import { round } from 'common/math';
import { Fragment } from 'inferno';
import { useBackend } from "../backend";
import { Box, Button, Flex, Icon, LabeledList, ProgressBar, Section } from "../components";
import { Window } from "../layouts";

export const Pda = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Window width={580} height={670}>
      <Window.Content scrollable>
        PDA!
      </Window.Content>
    </Window>
  );
};