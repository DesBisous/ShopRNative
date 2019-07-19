import AsyncStorage from '@react-native-community/async-storage';

const tryCatch = async func => {
	try {
		return await func();
	} catch (e) {
		// error reading value
	}
};

module.exports = {
	// 版本信息
	getVersion: async () =>
		await tryCatch(async () =>
			JSON.parse(await AsyncStorage.getItem('version'))
		),
	setVersion: async value =>
		await tryCatch(
			async () => await AsyncStorage.setItem('version', JSON.stringify(value))
		),

	// 地址 baseConfig
	getBaseConfig: async () =>
		await tryCatch(async () =>
			JSON.parse(await AsyncStorage.getItem('baseConfig'))
		),
	setBaseConfig: async value =>
		await tryCatch(
			async () =>
				await AsyncStorage.setItem('baseConfig', JSON.stringify(value))
		),

	// 路由
	getCurrentScene: async () =>
		await tryCatch(async () =>
			JSON.parse(await AsyncStorage.getItem('currentScene'))
		),
	setCurrentScene: async value =>
		await tryCatch(
			async () =>
				await AsyncStorage.setItem('currentScene', JSON.stringify(value))
		),
};
