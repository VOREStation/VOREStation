import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, LabeledList, Section } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

export type WireData = {
  wires: {
    seen_color: string;
    color_name: string;
    color: string;
    wire: string | null;
    cut: BooleanLike;
    attached: BooleanLike;
  }[];
  status: string[];
};

export const Wires = (props) => {
  const { data } = useBackend<WireData>();
  const { wires = [] } = data;

  return (
    <Window width={350} height={150 + wires.length * 30}>
      <Window.Content>
        <WiresWires />
        <WiresStatus />
      </Window.Content>
    </Window>
  );
};

export const WiresWires = (props) => {
  const { act, data } = useBackend<WireData>();

  const { wires = [] } = data;
  const statuses = data.status || [];

  return (
    <Section>
      <LabeledList>
        {wires.map((wire) => (
          <LabeledList.Item
            key={wire.seen_color}
            className="candystripe"
            label={wire.color_name}
            labelColor={wire.seen_color}
            color={wire.seen_color}
            buttons={
              <>
                <Button
                  onClick={() =>
                    act('cut', {
                      wire: wire.color,
                    })
                  }
                >
                  {wire.cut ? 'Mend' : 'Cut'}
                </Button>
                <Button
                  onClick={() =>
                    act('pulse', {
                      wire: wire.color,
                    })
                  }
                >
                  Pulse
                </Button>
                <Button
                  onClick={() =>
                    act('attach', {
                      wire: wire.color,
                    })
                  }
                >
                  {wire.attached ? 'Detach' : 'Attach'}
                </Button>
              </>
            }
          >
            {!!wire.wire && <i>({wire.wire})</i>}
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

export const WiresStatus = (props) => {
  const { act, data } = useBackend<WireData>();

  const { wires = [] } = data;
  const statuses = data.status || [];

  return statuses.length ? (
    <Section>
      {statuses.map((status) => (
        <Box key={status} color="lightgray" mt={0.1}>
          {status}
        </Box>
      ))}
    </Section>
  ) : null;
};
