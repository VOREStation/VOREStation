export function isValidHex(hex: string): boolean {
  return /^#[0-9A-Fa-f]{6}$/.test(hex);
}

export function computeMatrixFromPairs(
  pairs: { input: string; output: string }[],
): number[][] {
  const identityColors = ['#ff0000', '#00ff00', '#0000ff', '#ffffff'];

  const workingPairs = [...pairs];

  for (const idColor of identityColors) {
    const alreadyUsed = workingPairs.some(
      (p) => p.input.toLowerCase() === idColor,
    );
    if (!alreadyUsed) {
      workingPairs.push({
        input: idColor,
        output: idColor,
      });
    }
  }

  const rgbIn = workingPairs.map((p) => hexToRgb(p.input));
  const rgbOut = workingPairs.map((p) => hexToRgb(p.output));

  const matrix: number[][] = [];

  for (let channel = 0; channel < 3; channel++) {
    let attempts = 0;
    let weights: number[] = [];

    while (attempts < 5) {
      try {
        const a = rgbIn.map((rgb) => [rgb[0], rgb[1], rgb[2], 1]);
        const b = rgbOut.map((rgb) => rgb[channel]);

        weights = leastSquares(a, b);

        if (!weights.every((w) => w >= -10 && w <= 10)) {
          throw new Error('Computed weights out of range');
        }

        break;
      } catch (e) {
        const idx = rgbOut.length - 1;
        rgbOut[idx] = rgbOut[idx].map(
          (val) => val + Math.random() * 0.01 - 0.005,
        );
        attempts++;
      }
    }

    if (weights.length !== 4) {
      throw new Error(
        `Matrix computation failed for channel ${channel} after ${attempts} attempts`,
      );
    }

    matrix.push(weights);
  }

  return matrix;
}

function hexToRgb(hex: string): number[] {
  const clean = hex.replace('#', '').padEnd(6, '0');
  const r = parseInt(clean.slice(0, 2), 16) / 255;
  const g = parseInt(clean.slice(2, 4), 16) / 255;
  const b = parseInt(clean.slice(4, 6), 16) / 255;
  return [r, g, b];
}

function transpose(matrix: number[][]): number[][] {
  return matrix[0].map((_, i) => matrix.map((row) => row[i]));
}

function multiply(a: number[][], b: number[][]): number[][] {
  const result: number[][] = Array(a.length)
    .fill(0)
    .map(() => Array(b[0].length).fill(0));
  for (let i = 0; i < a.length; i++) {
    for (let j = 0; j < b[0].length; j++) {
      for (let k = 0; k < b.length; k++) {
        result[i][j] += a[i][k] * b[k][j];
      }
    }
  }
  return result;
}

function inverse(matrix: number[][]): number[][] {
  const size = matrix.length;
  const augmented = matrix.map((row, i) => [
    ...row,
    ...Array(size)
      .fill(0)
      .map((_, j) => (i === j ? 1 : 0)),
  ]);

  for (let i = 0; i < size; i++) {
    const diag = augmented[i][i];
    if (diag === 0) {
      throw new Error('Singular matrix');
    }
    for (let j = 0; j < size * 2; j++) augmented[i][j] /= diag;
    for (let k = 0; k < size; k++) {
      if (k === i) continue;
      const factor = augmented[k][i];
      for (let j = 0; j < size * 2; j++) {
        augmented[k][j] -= factor * augmented[i][j];
      }
    }
  }
  return augmented.map((row) => row.slice(size));
}

function leastSquares(a: number[][], b: number[]): number[] {
  const AT = transpose(a);
  const ATa = multiply(AT, a);
  const ATb = multiply(
    AT,
    b.map((v) => [v]),
  );
  const ATainv = inverse(ATa);
  const result = multiply(ATainv, ATb);
  return result.map((r) => r[0]);
}
