import { BooleanLike } from 'common/react';

export type Data = {
  isOperating: BooleanLike;
  hasOccupant: BooleanLike;
  occupant: {
    name: string;
    stat: number;
    health: number;
    maxHealth: number;
    minHealth: number;
    bruteLoss: number;
    oxyLoss: number;
    toxLoss: number;
    fireLoss: number;
    bodyTemperature: number;
  };
  cellTemperature: number;
  cellTemperatureStatus: string;
  isBeakerLoaded: BooleanLike;
  beakerLabel: string | null;
  beakerVolume: number;
};
