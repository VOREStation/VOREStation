import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { classes } from 'common/react';
import { createSearch } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Button, ByondUi, Input, Section, Dropdown } from '../components';
import { refocusLayout, Window } from '../layouts';


export const StationBlueprints = (props, context) => {
  return (
    <Window
      width={870}
      height={708}
      resizable>
      <StationBlueprintsContent />
    </Window>
  );
};

export const StationBlueprintsContent = (props, context) => {
  const { act, data, config } = useBackend(context);

  const { mapRef, areas, turfs } = data;
  return (
    <Fragment>
      <div className="CameraConsole__left">
        <Window.Content scrollable>
          Honk!
        </Window.Content>
      </div>
      <div className="CameraConsole__right">
        <ByondUi
          className="CameraConsole__map"
          params={{
            id: mapRef,
            type: 'map',
          }} />
      </div>
    </Fragment>
  );
};