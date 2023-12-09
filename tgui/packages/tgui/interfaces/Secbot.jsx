import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const Secbot = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    on,
    open,
    locked,
    idcheck,
    check_records,
    check_arrest,
    arrest_type,
    declare_arrests,
    bot_patrolling,
    patrol,
  } = data;

  return (
    <Window width={390} height={320}>
      <Window.Content scrollable>
        <Section
          title="Automatic Security Unit v2.0"
          buttons={
            <Button icon="power-off" selected={on} onClick={() => act('power')}>
              {on ? 'On' : 'Off'}
            </Button>
          }>
          <LabeledList>
            <LabeledList.Item
              label="Maintenance Panel"
              color={open ? 'bad' : 'good'}>
              {open ? 'Open' : 'Closed'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Behavior Controls"
              color={locked ? 'good' : 'bad'}>
              {locked ? 'Locked' : 'Unlocked'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {(!locked && (
          <Section title="Behavior Controls">
            <LabeledList>
              <LabeledList.Item label="Check for Weapon Authorization">
                <Button
                  icon={idcheck ? 'toggle-on' : 'toggle-off'}
                  selected={idcheck}
                  onClick={() => act('idcheck')}>
                  {idcheck ? 'Yes' : 'No'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Check Security Records">
                <Button
                  icon={check_records ? 'toggle-on' : 'toggle-off'}
                  selected={check_records}
                  onClick={() => act('ignorerec')}>
                  {check_records ? 'Yes' : 'No'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Check Arrest Status">
                <Button
                  icon={check_arrest ? 'toggle-on' : 'toggle-off'}
                  selected={check_arrest}
                  onClick={() => act('ignorearr')}>
                  {check_arrest ? 'Yes' : 'No'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Operating Mode">
                <Button
                  icon={arrest_type ? 'toggle-on' : 'toggle-off'}
                  selected={arrest_type}
                  onClick={() => act('switchmode')}>
                  {arrest_type ? 'Detain' : 'Arrest'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Report Arrests">
                <Button
                  icon={declare_arrests ? 'toggle-on' : 'toggle-off'}
                  selected={declare_arrests}
                  onClick={() => act('declarearrests')}>
                  {declare_arrests ? 'Yes' : 'No'}
                </Button>
              </LabeledList.Item>
              {!!bot_patrolling && (
                <LabeledList.Item label="Auto Patrol">
                  <Button
                    icon={patrol ? 'toggle-on' : 'toggle-off'}
                    selected={patrol}
                    onClick={() => act('patrol')}>
                    {patrol ? 'Yes' : 'No'}
                  </Button>
                </LabeledList.Item>
              )}
            </LabeledList>
          </Section>
        )) ||
          null}
      </Window.Content>
    </Window>
  );
};
