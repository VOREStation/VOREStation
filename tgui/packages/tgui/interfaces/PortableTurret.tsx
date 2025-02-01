import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, LabeledList, NoticeBox, Section } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

type Data = {
  locked: BooleanLike;
  on: BooleanLike;
  lethal: BooleanLike;
  lethal_is_configurable: BooleanLike;
  targetting_is_configurable: BooleanLike;
  check_weapons: BooleanLike;
  neutralize_noaccess: BooleanLike;
  neutralize_norecord: BooleanLike;
  neutralize_criminals: BooleanLike;
  neutralize_all: BooleanLike;
  neutralize_nonsynth: BooleanLike;
  neutralize_unidentified: BooleanLike;
  neutralize_down: BooleanLike;
};

export const PortableTurret = (props) => {
  const { act, data } = useBackend<Data>();
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
    <Window width={500} height={400}>
      <Window.Content scrollable>
        <NoticeBox>
          Swipe an ID card to {locked ? 'unlock' : 'lock'} this interface.
        </NoticeBox>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Status">
              <Button
                icon={on ? 'power-off' : 'times'}
                selected={on}
                disabled={locked}
                onClick={() => act('power')}
              >
                {on ? 'On' : 'Off'}
              </Button>
            </LabeledList.Item>
            {!!lethal_is_configurable && (
              <LabeledList.Item label="Lethals">
                <Button
                  icon={lethal ? 'exclamation-triangle' : 'times'}
                  color={lethal ? 'bad' : ''}
                  disabled={locked}
                  onClick={() => act('lethal')}
                >
                  {lethal ? 'On' : 'Off'}
                </Button>
              </LabeledList.Item>
            )}
          </LabeledList>
        </Section>
        {!!targetting_is_configurable && (
          <>
            <Section title="Humanoid Targets">
              <Button.Checkbox
                fluid
                checked={neutralize_criminals}
                disabled={locked}
                onClick={() => act('autharrest')}
              >
                Wanted Criminals
              </Button.Checkbox>
              <Button.Checkbox
                fluid
                checked={neutralize_norecord}
                disabled={locked}
                onClick={() => act('authnorecord')}
              >
                No Sec Record
              </Button.Checkbox>
              <Button.Checkbox
                fluid
                checked={check_weapons}
                disabled={locked}
                onClick={() => act('authweapon')}
              >
                Unauthorized Weapons
              </Button.Checkbox>
              <Button.Checkbox
                fluid
                checked={neutralize_noaccess}
                disabled={locked}
                onClick={() => act('authaccess')}
              >
                Unauthorized Access
              </Button.Checkbox>
            </Section>
            <Section title="Other Targets">
              <Button.Checkbox
                fluid
                checked={neutralize_unidentified}
                disabled={locked}
                onClick={() => act('authxeno')}
              >
                Unidentified Lifesigns (Xenos, Animals, Etc)
              </Button.Checkbox>
              <Button.Checkbox
                fluid
                checked={neutralize_nonsynth}
                disabled={locked}
                onClick={() => act('authsynth')}
              >
                All Non-Synthetics
              </Button.Checkbox>
              <Button.Checkbox
                fluid
                checked={neutralize_down}
                disabled={locked}
                onClick={() => act('authdown')}
              >
                Downed Targets
              </Button.Checkbox>
              <Button.Checkbox
                fluid
                checked={neutralize_all}
                disabled={locked}
                onClick={() => act('authall')}
              >
                All Entities
              </Button.Checkbox>
            </Section>
          </>
        )}
      </Window.Content>
    </Window>
  );
};
