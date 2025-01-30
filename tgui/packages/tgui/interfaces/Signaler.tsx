import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, NumberInput, Section, Table } from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';

export const Signaler = () => {
  return (
    <Window width={280} height={132}>
      <Window.Content>
        <SignalerContent />
      </Window.Content>
    </Window>
  );
};

type Data = {
  code: number;
  frequency: number;
  minFrequency: number;
  maxFrequency: number;
};

export const SignalerContent = (props) => {
  const { act, data } = useBackend<Data>();
  const { code, frequency, minFrequency, maxFrequency } = data;
  return (
    <Section>
      <Table>
        <Table.Row>
          <Table.Cell color="label">Frequency:</Table.Cell>
          <Table.Cell>
            <NumberInput
              animated
              unit="kHz"
              step={0.2}
              stepPixelSize={6}
              minValue={minFrequency / 10}
              maxValue={maxFrequency / 10}
              value={frequency / 10}
              format={(value) => toFixed(value, 1)}
              width="80px"
              onDrag={(value) =>
                act('freq', {
                  freq: value,
                })
              }
            />
          </Table.Cell>
          <Table.Cell>
            <Button
              ml={1.3}
              icon="sync"
              onClick={() =>
                act('reset', {
                  reset: 'freq',
                })
              }
            >
              Reset
            </Button>
          </Table.Cell>
        </Table.Row>
        <Table.Row mt={0.6}>
          <Table.Cell color="label">Code:</Table.Cell>
          <Table.Cell>
            <NumberInput
              animated
              step={1}
              stepPixelSize={6}
              minValue={1}
              maxValue={100}
              value={code}
              width="80px"
              onDrag={(value) =>
                act('code', {
                  code: value,
                })
              }
            />
          </Table.Cell>
          <Table.Cell>
            <Button
              ml={1.3}
              icon="sync"
              onClick={() =>
                act('reset', {
                  reset: 'code',
                })
              }
            >
              Reset
            </Button>
          </Table.Cell>
        </Table.Row>
        <Table.Row mt={0.8}>
          <Table.Cell>
            <Button
              mb={-0.1}
              fluid
              icon="arrow-up"
              textAlign="center"
              onClick={() => act('signal')}
            >
              Send Signal
            </Button>
          </Table.Cell>
        </Table.Row>
      </Table>
    </Section>
  );
};
