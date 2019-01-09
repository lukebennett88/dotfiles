module.exports = {
  env: {
    browser: true,
    es6: true
  },
  extends: ["plugin:jsx-a11y/recommended", "plugin:prettier/recommended"],
  plugins: ["react"],
  globals: {
    graphql: false
  },
  parser: "babel-eslint",
  parserOptions: {
    sourceType: "module",
    ecmaFeatures: {
      experimentalObjectRestSpread: true,
      jsx: true
    }
  },
  plugins: ["jsx-a11y", "prettier", "react"]
};
