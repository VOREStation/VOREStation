import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, LabeledList, NoticeBox, Section } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

type Data = {
  tank_one: string;
  tank_two: string;
  attached_device: string;
  valve: BooleanLike;
};

export const TransferValve = (props) => {
  const { act, data } = useBackend<Data>();
  const { tank_one, tank_two, attached_device, valve } = data;
  return (
    <Window>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Valve Status">
              <Button
                icon={valve ? 'unlock' : 'lock'}
                disabled={!tank_one || !tank_two}
                onClick={() => act('toggle')}
              >
                {valve ? 'Open' : 'Closed'}
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Assembly"
          buttons={
            <Button
              textAlign="center"
              width="150px"
              icon="cog"
              disabled={!attached_device}
              onClick={() => act('device')}
            >
              Configure Assembly
            </Button>
          }
        >
          <LabeledList>
            {attached_device ? (
              <LabeledList.Item label="Attachment">
                <Button
                  icon="eject"
                  disabled={!attached_device}
                  onClick={() => act('remove_device')}
                >
                  {attached_device}
                </Button>
              </LabeledList.Item>
            ) : (
              <NoticeBox textAlign="center">Attach Assembly</NoticeBox>
            )}
          </LabeledList>
        </Section>
        <Section title="Attachment One">
          <LabeledList>
            {tank_one ? (
              <LabeledList.Item label="Attachment">
                <Button
                  icon="eject"
                  disabled={!tank_one}
                  onClick={() => act('tankone')}
                >
                  {tank_one}
                </Button>
              </LabeledList.Item>
            ) : (
              <NoticeBox textAlign="center">Attach Tank</NoticeBox>
            )}
          </LabeledList>
        </Section>
        <Section title="Attachment Two">
          <LabeledList>
            {tank_two ? (
              <LabeledList.Item label="Attachment">
                <Button
                  icon="eject"
                  disabled={!tank_two}
                  onClick={() => act('tanktwo')}
                >
                  {tank_two}
                </Button>
              </LabeledList.Item>
            ) : (
              <NoticeBox textAlign="center">Attach Tank</NoticeBox>
            )}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
