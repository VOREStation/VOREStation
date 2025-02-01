import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Section } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

type Data = {
  categories: {
    category: string;
    alarms: {
      name: string;
      origin_lost: BooleanLike;
      has_cameras: number;
      cameras: {
        name: string;
        deact: BooleanLike;
        camera: string;
        omni: BooleanLike;
        x: number;
        y: number;
        z: number;
      }[];
      lost_sources: string;
    }[];
  }[];
};

export const StationAlertConsole = () => {
  return (
    <Window width={425} height={600}>
      <Window.Content scrollable>
        <StationAlertConsoleContent />
      </Window.Content>
    </Window>
  );
};

export const StationAlertConsoleContent = (props) => {
  const { act, data } = useBackend<Data>();
  const { categories = [] } = data;
  return categories.map((category) => (
    <Section key={category.category} title={category.category}>
      <ul>
        {category.alarms.length === 0 && (
          <li className="color-good">Systems Nominal</li>
        )}
        {category.alarms.map((alarm) => {
          let footer: React.JSX.Element | string = '';

          // To be clear, this is never the case unless the user is an AI.
          if (alarm.has_cameras) {
            footer = (
              <Section>
                {alarm.cameras.map((camera) => (
                  <Button
                    key={camera.name}
                    disabled={camera.deact}
                    icon="video"
                    onClick={() =>
                      act('switchTo', {
                        camera: camera.camera,
                      })
                    }
                  >
                    {camera.name + (camera.deact ? ' (deactived)' : '')}
                  </Button>
                ))}
              </Section>
            );
          } else if (alarm.lost_sources) {
            footer = (
              <Box color="bad">Lost Alarm Sources: {alarm.lost_sources}</Box>
            );
          }

          return (
            <li key={alarm.name}>
              {alarm.name}
              {alarm.origin_lost ? (
                <Box color="bad">Alarm Origin Lost.</Box>
              ) : (
                ''
              )}
              {footer}
            </li>
          );
        })}
      </ul>
    </Section>
  ));
};
