/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

const { rspack } = require('@rspack/core');
const path = require('path');

const createStats = (verbose) => ({
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
});

module.exports = (env = {}, argv) => {
  const mode = argv.mode || 'production';
  const bench = env.TGUI_BENCH;
  // @ts-check
  /** @type {import('@rspack/cli').Configuration} */
  const config = {
    mode: mode === 'production' ? 'production' : 'development',
    context: path.resolve(__dirname),
    target: ['web', 'browserslist:last 2 Edge versions'],
    entry: {
      tgui: ['./packages/tgui-polyfill', './packages/tgui'],
      'tgui-panel': ['./packages/tgui-polyfill', './packages/tgui-panel'],
      'tgui-say': ['./packages/tgui-polyfill', './packages/tgui-say'],
    },
    output: {
      path: argv.useTmpFolder
        ? path.resolve(__dirname, './public/.tmp')
        : path.resolve(__dirname, './public'),
      filename: '[name].bundle.js',
      chunkFilename: '[name].bundle.js',
      chunkLoadTimeout: 15000,
      publicPath: '/',
    },
    resolve: {
      extensions: ['.tsx', '.ts', '.js', '.jsx'],
    },
    module: {
      rules: [
        {
          test: /\.([tj]s(x)?|cjs)$/,
          exclude: /node_modules[\\/]core-js/,
          loader: 'builtin:swc-loader',
          /** @type {import('@rspack/core').SwcLoaderOptions} */
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
          type: 'javascript/auto',
        },
        {
          test: /\.css$/i,
          use: [
            {
              loader: rspack.CssExtractRspackPlugin.loader,
              options: {
                esModule: false,
              },
            },
            {
              loader: require.resolve('css-loader'),
              options: {
                esModule: false,
              },
            },
          ],
          type: 'javascript/auto',
        },
        {
          test: /\.(sass|scss)$/,
          use: [
            {
              loader: 'sass-loader',
              options: {
                api: 'modern-compiler',
                implementation: require.resolve('sass-embedded'),
              },
            },
          ],
          type: 'css',
        },
        {
          test: /\.(png|jpg|svg)$/,
          type: 'asset/inline',
        },
      ],
    },
    optimization: {
      emitOnErrors: false,
    },
    performance: {
      hints: false,
    },
    devtool: false,
    cache: {
      type: 'filesystem',
      cacheLocation: path.resolve(__dirname, `.yarn/rspack/${mode}`),
      buildDependencies: {
        config: [__filename],
      },
    },
    stats: createStats(true),
    plugins: [
      new rspack.EnvironmentPlugin({
        NODE_ENV: env.NODE_ENV || mode,
        WEBPACK_HMR_ENABLED: env.WEBPACK_HMR_ENABLED || argv.hot || false,
        DEV_SERVER_IP: env.DEV_SERVER_IP || null,
      }),
      new rspack.CssExtractRspackPlugin({
        filename: '[name].bundle.css',
        chunkFilename: '[name].bundle.css',
      }),
    ],
    experiments: {
      css: true,
    },
  };

  if (bench) {
    config.entry = {
      'tgui-bench': [
        './packages/tgui-polyfill',
        './packages/tgui-bench/entrypoint',
      ],
    };
  }

  // Development build specific options
  if (mode !== 'production') {
    config.devtool = 'cheap-module-source-map';
  }

  // Development server specific options
  if (argv.devServer) {
    config.devServer = {
      progress: false,
      quiet: false,
      noInfo: false,
      clientLogLevel: 'silent',
      stats: createStats(false),
    };
  }

  return config;
};
