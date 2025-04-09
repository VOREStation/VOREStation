import { useBackend } from 'tgui/backend';
import {
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import { capitalizeFirst } from 'tgui-core/string';

import type { Data } from './types';

export const BeakerDisplay = (props) => {
  const { act, data } = useBackend<Data>();
  const { has_beaker, beaker, has_blood } = data;
  const cant_empty = !has_beaker || !beaker?.volume;
  let content;

  if (!has_beaker) {
    content = <NoticeBox>No container loaded.</NoticeBox>;
  } else if (!beaker?.volume) {
    content = <NoticeBox>Container is empty.</NoticeBox>;
  } else if (!has_blood) {
    content = (
      <NoticeBox>No blood sample found in the loaded container.</NoticeBox>
    );
  } else {
    content = (
      <Stack vertical>
        <Stack.Item>
          <Info />
        </Stack.Item>
        <Stack.Item>
          <Antibodies />
        </Stack.Item>
      </Stack>
    );
  }

  return (
    <Section
      title="Container"
      buttons={
        <Stack>
          <Stack.Item>
            <Button
              icon="times"
              color="bad"
              disabled={cant_empty}
              onClick={() => act('destroy_eject_beaker')}
            >
              Empty and Eject
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="trash"
              disabled={cant_empty}
              onClick={() => act('empty_beaker')}
            >
              Empty
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="eject"
              disabled={!has_beaker}
              onClick={() => act('eject_beaker')}
            >
              Eject
            </Button>
          </Stack.Item>
        </Stack>
      }
    >
      {content}
    </Section>
  );
};

const Info = (props) => {
  const { data } = useBackend<Data>();
  const { beaker, blood } = data;
  if (!beaker || !blood) {
    return <NoticeBox>No container loaded</NoticeBox>;
  }

  return (
    <Stack>
      <Stack.Item grow={2}>
        <LabeledList>
          <LabeledList.Item label="DNA">
            {capitalizeFirst(blood.dna)}
          </LabeledList.Item>
          <LabeledList.Item label="Type">
            {capitalizeFirst(blood.type)}
          </LabeledList.Item>
        </LabeledList>
      </Stack.Item>
      <Stack.Item grow={2}>
        <LabeledList>
          <LabeledList.Item label="Container">
            <ProgressBar
              color="darkred"
              value={beaker.volume}
              minValue={0}
              maxValue={beaker.capacity}
              ranges={{
                good: [beaker.capacity * 0.85, beaker.capacity],
                average: [beaker.capacity * 0.25, beaker.capacity * 0.85],
                bad: [0, beaker.capacity * 0.25],
              }}
            />
          </LabeledList.Item>
        </LabeledList>
      </Stack.Item>
    </Stack>
  );
};

const Antibodies = (props) => {
  const { act, data } = useBackend<Data>();
  const { is_ready, resistances = [] } = data;
  if (!resistances) {
    return <NoticeBox>Nothing detected.</NoticeBox>;
  }

  return (
    <LabeledList>
      <LabeledList.Item label="Antibodies">
        {!resistances.length
          ? 'None'
          : resistances.map((resistance) => {
              return (
                <Button
                  key={resistance.name}
                  icon="eye-dropper"
                  disabled={!is_ready}
                  tooltip="Creates a vaccine bottle."
                  onClick={() =>
                    act('create_vaccine_bottle', {
                      index: resistance.id,
                    })
                  }
                >
                  {`${resistance.name}`}
                </Button>
              );
            })}
      </LabeledList.Item>
    </LabeledList>
  );
};
