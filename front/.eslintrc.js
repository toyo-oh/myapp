// https://www.nuxtjs.cn/guide/development-tools
module.exports = {
  root: true,
  env: {
    browser: true,
    node: true,
    jest: true,
  },
  parserOptions: {
    parser: "babel-eslint",
  },
  extends: ["eslint:recommended", "plugin:vue/recommended", "plugin:prettier/recommended"],
  // required to lint *.vue files
  plugins: ["vue"],
  // add your custom rules here
  rules: {
    semi: [2, "never"],
    "no-console": "off",
    "vue/max-attributes-per-line": "off",
    "vue/multi-word-component-names": "off",
    "prettier/prettier": ["error", { semi: false, bracketSameLine: true, printWidth: 100 }],
  },
}
