module.exports = {
  env: {
    browser: true,
    node: true,
    commonjs: true,
    es6: true,
    worker: true,
    jest: true,
    jquery: true,
    mongo: true,
    applescript: true,
    serviceworker: true
  },
  extends: ["plugin:jsx-a11y/recommended", "plugin:prettier/recommended"],
  parser: "babel-eslint",
  parserOptions: {
    ecmaVersion: 2018,
    sourceType: "module",
    ecmaFeatures: {
      jsx: true,
      impliedStrict: true
    }
  },
  plugins: ["jsx-a11y", "prettier", "react"],
  rules: {
    "no-console": 1
  }
};
