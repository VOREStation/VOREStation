import { Box } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

/*
 */
export function mapTwoByTwo(a: any[][], c: any) {
  let result: any[] = [];
  for (let i = 0; i < a.length; i += 2) {
    result.push(c(a[i], a[i + 1], i));
  }
  return result;
}

export function reduceOrganStatus(
  A: (string | BooleanLike | React.ReactElement)[],
) {
  return A.length > 0
    ? A.reduce((a, s) =>
        a === null ? (
          s
        ) : (
          <>
            {a}
            {!!s && <Box>{s}</Box>}
          </>
        ),
      )
    : null;
}

export function germStatus(i: number): string {
  if (i > 100) {
    if (i < 300) {
      return 'mild infection';
    }
    if (i < 400) {
      return 'mild infection+';
    }
    if (i < 500) {
      return 'mild infection++';
    }
    if (i < 700) {
      return 'acute infection';
    }
    if (i < 800) {
      return 'acute infection+';
    }
    if (i < 900) {
      return 'acute infection++';
    }
    if (i >= 900) {
      return 'septic';
    }
  }

  return '';
}
