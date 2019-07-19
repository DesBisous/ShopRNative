module.exports = {
	presets: ['module:metro-react-native-babel-preset'],
	plugins: [
		['transform-function-bind'],
		[
			'@babel/transform-runtime',
			{
				helpers: true,
				regenerator: false,
			},
		],
	],
	env: {
		development: {
			plugins: [],
		},
		production: {
			plugins: ['transform-remove-console'],
		},
	},
};
