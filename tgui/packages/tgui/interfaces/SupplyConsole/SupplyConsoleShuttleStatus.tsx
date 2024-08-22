import { useBackend } from '../../backend';
import { AnimatedNumber, Button, LabeledList, Section } from '../../components';
import { formatTime } from '../../format';
import { Data } from './types';

export const SupplyConsoleShuttleStatus = (props) => {
  const { act, data } = useBackend<Data>();

  const { supply_points, shuttle, shuttle_auth } = data;

  let shuttle_buttons: React.JSX.Element | string = '';
  let showShuttleForce = false;

  if (shuttle_auth) {
    if (shuttle.launch === 1 && shuttle.mode === 0) {
      shuttle_buttons = (
        <Button
          icon="rocket"
          onClick={() => act('send_shuttle', { mode: 'send_away' })}
        >
          Send Away
        </Button>
      );
    } else if (
      shuttle.launch === 2 &&
      (shuttle.mode === 3 || shuttle.mode === 1)
    ) {
      shuttle_buttons = (
        <Button
          icon="ban"
          onClick={() => act('send_shuttle', { mode: 'cancel_shuttle' })}
        >
          Cancel Launch
        </Button>
      );
    } else if (shuttle.launch === 1 && shuttle.mode === 5) {
      shuttle_buttons = (
        <Button
          icon="rocket"
          onClick={() => act('send_shuttle', { mode: 'send_to_station' })}
        >
          Send Shuttle
        </Button>
      );
    }
    if (shuttle.force) {
      showShuttleForce = true;
    }
  }

  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Supply Points">
          <AnimatedNumber value={supply_points} />
        </LabeledList.Item>
      </LabeledList>
      <Section title="Supply Shuttle" mt={2}>
        <LabeledList>
          <LabeledList.Item
            label="Location"
            buttons={
              <>
                {shuttle_buttons}
                {showShuttleForce ? (
                  <Button
                    icon="exclamation-triangle"
                    onClick={() =>
                      act('send_shuttle', { mode: 'force_shuttle' })
                    }
                  >
                    Force Launch
                  </Button>
                ) : (
                  ''
                )}
              </>
            }
          >
            {shuttle.location}
          </LabeledList.Item>
          <LabeledList.Item label="Engine">{shuttle.engine}</LabeledList.Item>
          {shuttle.mode === 4 ? (
            <LabeledList.Item label="ETA">
              {shuttle.time > 1 ? formatTime(shuttle.time) : 'LATE'}
            </LabeledList.Item>
          ) : (
            ''
          )}
        </LabeledList>
      </Section>
    </Section>
  );
};
