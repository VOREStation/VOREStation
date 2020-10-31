import { filter } from 'common/collections';
import { decodeHtmlEntities, toTitleCase } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from "../../backend";
import { Box, Button, Flex, Icon, LabeledList, ProgressBar, Section } from "../../components";
import { SignalerContent } from '../Signaler';

export const pda_signaller = (props, context) => {
  return <SignalerContent />;
};