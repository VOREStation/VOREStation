import { defineConfig } from '@rspack/cli';
import rspack from '@rspack/core';

/**
 * @param {boolean} verbose
 * @returns  {import('@rspack/core').StatsOptions}
 */
export function createStats(verbose) {
  return {
    assets: verbose,
    builtAt: verbose,
    cached: false,
    children: false,
    chunks: false,
    colors: true,
    entrypoints: true,
    hash: false,
    modules: false,
    performance: false,
    timings: verbose,
    version: verbose,
  };
}

const dir = import.meta.dirname;

export default defineConfig({
  context: dir,
  devtool: false,
  entry: {
    tgui: './packages/tgui',
    'tgui-panel': './packages/tgui-panel',
    'tgui-say': './packages/tgui-say',
  },
  mode: 'production',
  module: {
    rules: [
      {
        test: /\.([tj]s(x)?|cjs)$/,
        type: 'javascript/auto',
        use: [
          {
            loader: 'builtin:swc-loader',
            options: {
              jsc: {
                parser: {
                  syntax: 'typescript',
                  tsx: true,
                },
                transform: {
                  react: {
                    runtime: 'automatic',
                  },
                },
              },
            },
          },
        ],
      },
      {
        test: /\.(s)?css$/,
        type: 'javascript/auto',
        use: [
          rspack.CssExtractRspackPlugin.loader,
          'css-loader',
          {
            loader: 'sass-loader',
            options: {
              api: 'modern-compiler',
              implementation: 'sass-embedded',
            },
          },
        ],
      },
      {
        test: /\.(png|jpg)$/,
        oneOf: [
          {
            issuer: /\.(s)?css$/,
            type: 'asset/inline',
          },
          {
            type: 'asset/resource',
          },
        ],
        generator: {
          filename: '[name][ext]',
        },
      },

      {
        test: /\.svg$/,
        oneOf: [
          {
            issuer: /\.(s)?css$/,
            type: 'asset/inline',
          },
          {
            type: 'asset/resource',
          },
        ],
        generator: {
          filename: '[name][ext]',
        },
      },
    ],
  },
  optimization: {
    emitOnErrors: false,
  },
  output: {
    path: 'public',
    filename: '[name].bundle.js',
    chunkFilename: '[name].bundle.js',
    chunkLoadTimeout: 15000,
    publicPath: '/',
    assetModuleFilename: '[name][ext]',
  },
  performance: {
    hints: false,
  },
  plugins: [
    new rspack.CssExtractRspackPlugin({
      chunkFilename: '[name].bundle.css',
      filename: '[name].bundle.css',
    }),
    new rspack.EnvironmentPlugin({
      NODE_ENV: 'production',
    }),
  ],
  resolve: {
    extensions: ['.tsx', '.ts', '.js', '.jsx'],
    alias: {
      tgui: new URL('./packages/tgui', import.meta.url).pathname,
      'tgui-panel': new URL('./packages/tgui-panel', import.meta.url).pathname,
      'tgui-say': new URL('./packages/tgui-say', import.meta.url).pathname,
      'tgui-dev-server': new URL('./packages/tgui-dev-server', import.meta.url)
        .pathname,
    },
  },
  stats: createStats(true),
  target: ['web', 'browserslist:edge >= 123'],
});
