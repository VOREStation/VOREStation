import { filter } from 'common/collections';
import { decodeHtmlEntities, toTitleCase } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from "../../backend";
import { Box, Button, Flex, Icon, LabeledList, ProgressBar, Section } from "../../components";

export const pda_janitor = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    janitor,
  } = data;

  return (
    <Box>
      <LabeledList>
        <LabeledList.Item label="Current Location">
          {janitor.user_loc.x === 0 && (
            <Box color="bad">Unknown</Box>
          ) || (
            <Box>
              {janitor.user_loc.x} / {janitor.user_loc.y}
            </Box>
          )}
        </LabeledList.Item>
      </LabeledList>
      <Section level={2} title="Mop Locations">
        {janitor.mops && (
          <ul>
            {janitor.mops.map((mop, i) => (
              <li key={i}>
                {mop.x} / {mop.y} - {mop.dir} - Status: {mop.status}
              </li>
            ))}
          </ul>
        ) || (
          <Box color="bad">
            No mops detected nearby.
          </Box>
        )}
      </Section>
      <Section level={2} title="Mop Bucket Locations">
        {janitor.buckets && (
          <ul>
            {janitor.buckets.map((bucket, i) => (
              <li key={i}>
                {bucket.x} / {bucket.y} - {bucket.dir} - Capacity: {bucket.volume}/{bucket.max_volume}
              </li>
            ))}
          </ul>
        ) || (
          <Box color="bad">
            No buckets detected nearby.
          </Box>
        )}
      </Section>
      <Section level={2} title="Cleanbot Locations">
        {janitor.cleanbots && (
          <ul>
            {janitor.cleanbots.map((cleanbot, i) => (
              <li key={i}>
                {cleanbot.x} / {cleanbot.y} - {cleanbot.dir} - Status: {cleanbot.status}
              </li>
            ))}
          </ul>
        ) || (
          <Box color="bad">
            No cleanbots detected nearby.
          </Box>
        )}
      </Section>
      <Section level={2} title="Janitorial Cart Locations">
        {janitor.carts && (
          <ul>
            {janitor.carts.map((cart, i) => (
              <li key={i}>
                {cart.x} / {cart.y} - {cart.dir} - Water Level: {cart.volume}/{cart.max_volume}
              </li>
            ))}
          </ul>
        ) || (
          <Box color="bad">
            No janitorial carts detected nearby.
          </Box>
        )}
      </Section>
    </Box>
  );
};