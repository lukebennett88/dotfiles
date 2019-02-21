module.exports = {
  env: {
    applescript: true,
    browser: true,
    commonjs: true,
    es6: true,
    jest: true,
    jquery: true,
    mongo: true,
    node: true,
    serviceworker: true,
    worker: true,
  },
  extends: ['plugin:jsx-a11y/recommended', 'plugin:prettier/recommended'],
  parser: 'babel-eslint',
  parserOptions: {
    ecmaVersion: 2018,
    sourceType: 'module',
    ecmaFeatures: {
      jsx: true,
      impliedStrict: true,
    },
  },
  globals: {
    graphql: false,
  },
  plugins: ['jsx-a11y', 'prettier', 'react'],
};
