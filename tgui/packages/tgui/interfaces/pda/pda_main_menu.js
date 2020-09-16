import { round } from 'common/math';
import { Fragment } from 'inferno';
import { useBackend } from "../backend";
import { Box, Button, Flex, Icon, LabeledList, ProgressBar, Section } from "../components";

export const pda_main_menu = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Section>
      Main Menu
    </Section>
  );
};