import { useBackend } from '../../../backend';
import { Button, LabeledList, Section } from '../../../components';

export const VoreSelectedBellyInteractions = (props) => {
  const { act } = useBackend();

  const { belly } = props;
  const { escapable, interacts } = belly;

  return (
    <Section
      title="Belly Interactions"
      buttons={
        <Button
          onClick={() => act('set_attribute', { attribute: 'b_escapable' })}
          icon={escapable ? 'toggle-on' : 'toggle-off'}
          selected={escapable}
        >
          {escapable ? 'Interactions On' : 'Interactions Off'}
        </Button>
      }
    >
      {escapable ? (
        <LabeledList>
          <LabeledList.Item label="Escape Chance">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_escapechance' })
              }
            >
              {interacts.escapechance + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Absorbed Escape Chance">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_escapechance_absorbed' })
              }
            >
              {interacts.escapechance_absorbed + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Escape Time">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_escapetime' })
              }
            >
              {interacts.escapetime / 10 + 's'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Divider />
          <LabeledList.Item label="Transfer Chance">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_transferchance' })
              }
            >
              {interacts.transferchance + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Transfer Location">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_transferlocation' })
              }
            >
              {interacts.transferlocation
                ? interacts.transferlocation
                : 'Disabled'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Divider />
          <LabeledList.Item label="Secondary Transfer Chance">
            <Button
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_transferchance_secondary',
                })
              }
            >
              {interacts.transferchance_secondary + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Secondary Transfer Location">
            <Button
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_transferlocation_secondary',
                })
              }
            >
              {interacts.transferlocation_secondary
                ? interacts.transferlocation_secondary
                : 'Disabled'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Divider />
          <LabeledList.Item label="Absorb Chance">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_absorbchance' })
              }
            >
              {interacts.absorbchance + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Digest Chance">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_digestchance' })
              }
            >
              {interacts.digestchance + '%'}
            </Button>
          </LabeledList.Item>
        </LabeledList>
      ) : (
        'These options only display while interactions are turned on.'
      )}
    </Section>
  );
};
