import type { DroneData, MouseData } from './types';

type describeReturnData = { text: string; state: boolean };

export function describeMouseData(data: MouseData): describeReturnData {
  const returnData = { text: 'Spawn as mouse.', state: true };
  if (data.disabled) {
    returnData.text = 'Spawning as a mouse is currently disabled.';
    returnData.state = false;
    return returnData;
  }
  if (data.banned) {
    returnData.text =
      'You cannot become a mouse because you are banned from playing ghost roles.';
    returnData.state = false;
    return returnData;
  }
  if (data.bad_turf) {
    returnData.text = 'You may not spawn as a mouse on this Z-level.';
    returnData.state = false;
    return returnData;
  }
  if (data.respawn_time) {
    returnData.text =
      'You must wait ' +
      data.respawn_time +
      ' before being able to respawn again.';
    returnData.state = false;
    return returnData;
  }
  if (!data.found_vents) {
    returnData.text = 'Unable to find any unwelded vents to spawn mice at.';
    returnData.state = false;
  }
  return returnData;
}

export function describeDroneData(data: DroneData): describeReturnData {
  const returnData = {
    text: 'If there is a powered, enabled fabricator in the game world with a prepared chassis, join as a maintenance drone.',
    state: true,
  };
  if (data.disabled) {
    returnData.text = 'Spawning as a drone is currently disabled.';
    returnData.state = false;
    return returnData;
  }
  if (data.banned) {
    returnData.text =
      'You are banned from playing synthetics and cannot spawn as a drone.';
    returnData.state = false;
    return returnData;
  }
  if (data.days_to_play) {
    returnData.text =
      'You have not been playing on the server long enough to join as drone.';
    returnData.state = false;
    return returnData;
  }
  if (data.respawn_time) {
    returnData.text =
      'You must wait ' +
      data.respawn_time +
      ' before being able to respawn again.';
    returnData.state = false;
    return returnData;
  }
  if (!Object.keys(data.fabricators).length) {
    returnData.text = 'There are no available drone spawn points, sorry.';
    returnData.state = false;
  }
  return returnData;
}
