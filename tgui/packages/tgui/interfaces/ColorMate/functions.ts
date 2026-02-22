export function isValidHex(hex: string): boolean {
  return /^#[0-9A-Fa-f]{6}$/.test(hex);
}

export function computeMatrixFromPairs(
  pairs: { input: string; output: string }[],
): number[][] {
  const rgbIn = pairs.map((p) => hexToRgb255(p.input));
  const rgbOut = pairs.map((p) => hexToRgb255(p.output));

  if (rgbIn.length === 0) {
    throw new Error('At least one color pair is required');
  }

  const matrix: number[][] = [];

  for (let channel = 0; channel < 3; channel++) {
    const a = rgbIn.map((rgb) => [rgb[0], rgb[1], rgb[2], 1]);
    const b = rgbOut.map((rgb) => rgb[channel]);

    const weights = leastSquares(a, b);

    if (weights.length !== 4) {
      throw new Error(`Matrix computation failed for channel ${channel}`);
    }

    matrix.push(weights);
  }

  return matrix;
}

function hexToRgb255(hex: string): number[] {
  const clean = hex.replace('#', '').padStart(6, '0');
  const r = parseInt(clean.slice(0, 2), 16);
  const g = parseInt(clean.slice(2, 4), 16);
  const b = parseInt(clean.slice(4, 6), 16);
  return [r, g, b];
}

function gaussElim(a: number[][], b: number[]): number[] {
  const n = a.length;
  const m = a[0].length;
  const aug = a.map((row, i) => [...row, b[i]]);

  let rank = 0;
  for (let col = 0; col < m && rank < n; col++) {
    let best = rank;
    for (let row = rank + 1; row < n; row++) {
      if (Math.abs(aug[row][col]) > Math.abs(aug[best][col])) {
        best = row;
      }
    }

    if (Math.abs(aug[best][col]) < 1e-12) {
      continue;
    }

    [aug[rank], aug[best]] = [aug[best], aug[rank]];

    for (let row = rank + 1; row < n; row++) {
      const factor = aug[row][col] / aug[rank][col];
      for (let j = col; j <= m; j++) {
        aug[row][j] -= factor * aug[rank][j];
      }
    }

    rank++;
  }

  const x = new Array(m).fill(0);
  for (let i = Math.min(rank, m) - 1; i >= 0; i--) {
    if (Math.abs(aug[i][i]) < 1e-12) continue;
    let sum = aug[i][m];
    for (let j = i + 1; j < m; j++) {
      sum -= aug[i][j] * x[j];
    }
    x[i] = sum / aug[i][i];
  }

  return x;
}

function leastSquares(a: number[][], b: number[]): number[] {
  const rows = a.length;
  const cols = a[0].length;

  const ATa: number[][] = Array.from({ length: cols }, () =>
    new Array(cols).fill(0),
  );
  const ATb = new Array(cols).fill(0);

  for (let i = 0; i < cols; i++) {
    for (let j = 0; j < cols; j++) {
      for (let k = 0; k < rows; k++) {
        ATa[i][j] += a[k][i] * a[k][j];
      }
    }
    for (let k = 0; k < rows; k++) {
      ATb[i] += a[k][i] * b[k];
    }
  }

  return gaussElim(ATa, ATb);
}

export function transformColor(
  r: number,
  g: number,
  b: number,
  matrix: number[][],
): number[] {
  const outR = clamp(
    matrix[0][0] * r + matrix[0][1] * g + matrix[0][2] * b + matrix[0][3],
  );
  const outG = clamp(
    matrix[1][0] * r + matrix[1][1] * g + matrix[1][2] * b + matrix[1][3],
  );
  const outB = clamp(
    matrix[2][0] * r + matrix[2][1] * g + matrix[2][2] * b + matrix[2][3],
  );

  return [outR, outG, outB];
}

function clamp(v: number): number {
  return Math.max(0, Math.min(255, Math.round(v)));
}
