module.exports = {
  root: true,
  parserOptions: {
    ecmaVersion: 12,
    sourceType: "module",
  },
  plugins: ["unicorn"],
  extends: ["eslint:recommended", "prettier", "plugin:unicorn/recommended"],
  env: {
    es2021: true,
    node: true,
  },
};
