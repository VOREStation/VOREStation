import { describe, it } from 'vitest';

// import { getGasColor, getGasFromId, getGasFromPath, getGasLabel } from './constants';
import { getGasColor, getGasFromId, getGasLabel } from './constants';

describe('gas helper functions', () => {
  it('should get the proper gas label', ({ expect }) => {
    // Testing for alphabetic gas id
    const gasId = 'oxygen';
    const gasLabel = getGasLabel(gasId);
    expect(gasLabel).toBe('O₂');
  });

  it('should get the proper gas label', ({ expect }) => {
    // Testing for underscore gas id
    const gasId = 'nitrous_oxide';
    const gasLabel = getGasLabel(gasId);
    expect(gasLabel).toBe('N₂O');
  });

  it('should get the proper gas label', ({ expect }) => {
    // Testing for wrong capitalization of two word gas
    const gasId = 'nitrous oxide';
    const gasLabel = getGasLabel(gasId); // This should set to Nitrous Oxide before checking
    expect(gasLabel).toBe('N₂O');
  });

  it('should get the proper gas label with a fallback', ({ expect }) => {
    const gasId = 'nonexistent';
    const gasLabel = getGasLabel(gasId, 'fallback');

    expect(gasLabel).toBe('fallback');
  });

  it('should return none if no gas and no fallback is found', ({ expect }) => {
    const gasId = 'nonexistent';
    const gasLabel = getGasLabel(gasId);

    expect(gasLabel).toBe('None');
  });

  it('should get the proper gas color', ({ expect }) => {
    const gasId = 'nitrous_oxide';
    const gasColor = getGasColor(gasId);

    expect(gasColor).toBe('red');
  });

  it('should return a string if no gas is found', ({ expect }) => {
    const gasId = 'nonexistent';
    const gasColor = getGasColor(gasId);

    expect(gasColor).toBe('black');
  });

  it('should return the gas object if found', ({ expect }) => {
    const gasId = 'nitrous_oxide';
    const gas = getGasFromId(gasId);

    expect(gas).toEqual({
      id: 'nitrous_oxide',
      // path: '/datum/gas/antinoblium',
      name: 'Nitrous Oxide',
      label: 'N₂O',
      color: 'red',
    });
  });

  it('should return undefined if no gas is found', ({ expect }) => {
    const gasId = 'nonexistent';
    const gas = getGasFromId(gasId);

    expect(gas).toBeUndefined();
  });

  /*
  it('should return the gas using a path', ({ expect }) => {
    const gasPath = '/datum/gas/antinoblium';
    const gas = getGasFromPath(gasPath);

    expect(gas).toEqual({
      id: 'antinoblium',
      path: '/datum/gas/antinoblium',
      name: 'Antinoblium',
      label: 'Anti-Noblium',
      color: 'maroon',
    });
  });
  */
});
