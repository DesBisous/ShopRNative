module.exports = {
	//此项是用来指定eslint解析器的，解析器必须符合规则，babel-eslint解析器是对babel解析器的包装使其与ESLint解析
	parser: 'babel-eslint',
	root: true,
	// 此项指定环境的全局变量，
	env: {
		browser: true,
		node: true,
	},
	// 脚本在执行期间访问的额外的全局变量
	// 当访问未定义的变量时，no-undef 规则将发出警告。如果你想在一个文件里使用全局变量，推荐你定义这些全局变量，这样 ESLint 就不会发出警告了。你可以使用注释或在配置文件中定义全局变量。
	globals: {
		__DEV__: true,
	},
	// 设置解析器选项（必须设置这个属性）
	parserOptions: {
		// 想使用的额外的语言特性:
		ecmaFeatures: {
			// http://es6.ruanyifeng.com/#docs/object#对象的扩展运算符
			experimentalObjectRestSpread: true,
			// 启用 JSX
			jsx: true,
		},
		//设置"script"（默认）或"module"如果你的代码是在ECMAScript中的模块
		sourceType: 'module',
	},
	// 此项是用来配置标准的js风格，就是说写代码的时候要规范的写，
	extends: ['airbnb', 'prettier', 'plugin:prettier/recommended'],
	// required to lint *.vue files
	plugins: ['react', 'react-native', 'prettier'],
	settings: {},
	// add your custom rules here
	/**
	 * "off" 或 0 - 关闭规则
	 * "warn" 或 1 - 开启规则，使用警告级别的错误：warn (不会导致程序退出),
	 * "error" 或 2 - 开启规则，使用错误级别的错误：error (当被触发的时候，程序会退出)
	 */
	rules: {
		'quote-props': 0,
		'eol-last': 0,
		'function-paren-newline': 0,
		'spaced-comment': 0,
		'no-tabs': 0,
		'class-methods-use-this': 0,
		'no-underscore-dangle': 0,
		'no-unused-expressions': 0,
		'arrow-body-style': 0,
		'max-len': 1,
		'global-require': 1,
		'no-unused-vars': 1,
		'object-shorthand': 1,
		'react/no-array-index-key': 1,
		'react/prefer-stateless-function': 0,
		'react/jsx-filename-extension': [1, { extensions: ['.js', '.jsx'] }],
		'react/forbid-prop-types': 0,
		'react/jsx-no-bind': 0,
		camelcase: 0,
		'prefer-destructuring': ['error', { object: true, array: false }],
	},
};
