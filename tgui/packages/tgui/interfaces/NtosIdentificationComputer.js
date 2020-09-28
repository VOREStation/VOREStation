import { sortBy } from 'common/collections';
import { Fragment } from 'inferno';
import { useBackend } from "../backend";
import { Box, Button, Flex, Input, LabeledList, Section, Table, Tabs } from "../components";
import { Window, NtosWindow } from "../layouts";
import { decodeHtmlEntities } from 'common/string';
import { COLORS } from "../constants";
import { IdentificationComputerContent } from "./IdentificationComputer";

export const NtosIdentificationComputer = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <NtosWindow width={600} height={700} resizable>
      <NtosWindow.Content scrollable>
        <IdentificationComputerContent ntos />
      </NtosWindow.Content>
    </NtosWindow>
  );
};