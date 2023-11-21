import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const PortableTurret = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    locked,
    on,
    lethal,
    lethal_is_configurable,
    targetting_is_configurable,
    check_weapons,
    neutralize_noaccess,
    neutralize_norecord,
    neutralize_criminals,
    neutralize_all,
    neutralize_nonsynth,
    neutralize_unidentified,
    neutralize_down,
  } = data;
  return (
    <Window width={500} height={400} resizable>
      <Window.Content scrollable>
        <NoticeBox>
          Swipe an ID card to {locked ? 'unlock' : 'lock'} this interface.
        </NoticeBox>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Status">
              <Button
                icon={on ? 'power-off' : 'times'}
                content={on ? 'On' : 'Off'}
                selected={on}
                disabled={locked}
                onClick={() => act('power')}
              />
            </LabeledList.Item>
            {!!lethal_is_configurable && (
              <LabeledList.Item label="Lethals">
                <Button
                  icon={lethal ? 'exclamation-triangle' : 'times'}
                  content={lethal ? 'On' : 'Off'}
                  color={lethal ? 'bad' : ''}
                  disabled={locked}
                  onClick={() => act('lethal')}
                />
              </LabeledList.Item>
            )}
          </LabeledList>
        </Section>
        {!!targetting_is_configurable && (
          <Fragment>
            <Section title="Humanoid Targets">
              <Button.Checkbox
                fluid
                checked={neutralize_criminals}
                content="Wanted Criminals"
                disabled={locked}
                onClick={() => act('autharrest')}
              />
              <Button.Checkbox
                fluid
                checked={neutralize_norecord}
                content="No Sec Record"
                disabled={locked}
                onClick={() => act('authnorecord')}
              />
              <Button.Checkbox
                fluid
                checked={check_weapons}
                content="Unauthorized Weapons"
                disabled={locked}
                onClick={() => act('authweapon')}
              />
              <Button.Checkbox
                fluid
                checked={neutralize_noaccess}
                content="Unauthorized Access"
                disabled={locked}
                onClick={() => act('authaccess')}
              />
            </Section>
            <Section title="Other Targets">
              <Button.Checkbox
                fluid
                checked={neutralize_unidentified}
                content="Unidentified Lifesigns (Xenos, Animals, Etc)"
                disabled={locked}
                onClick={() => act('authxeno')}
              />
              <Button.Checkbox
                fluid
                checked={neutralize_nonsynth}
                content="All Non-Synthetics"
                disabled={locked}
                onClick={() => act('authsynth')}
              />
              <Button.Checkbox
                fluid
                checked={neutralize_down}
                content="Downed Targets"
                disabled={locked}
                onClick={() => act('authdown')}
              />
              <Button.Checkbox
                fluid
                checked={neutralize_all}
                content="All Entities"
                disabled={locked}
                onClick={() => act('authall')}
              />
            </Section>
          </Fragment>
        )}
      </Window.Content>
    </Window>
  );
};
