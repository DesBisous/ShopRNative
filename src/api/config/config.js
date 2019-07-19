import { getBaseConfig, setBaseConfig } from '../../utils/asyncStorage';

export const initialState = {
	configList: [
		// sit
		{
			backendBaseUrl: 'https://easy-mock.com/', //后台地址
			storeUrl: 'http://uatsch5.fujfu.com/', // 商城代码
		},
		// uat
		{
			backendBaseUrl: 'https://easy-mock.com/', //后台地址
			storeUrl: 'http://uatsch5.fujfu.com/', // 商城代码
		},
		// 生产
		{
			backendBaseUrl: 'https://easy-mock.com/', //后台地址
			storeUrl: 'http://ffq.flnet.com/', // 商城代码
		},
	],
	curConfig: 1,
};
setBaseConfig(initialState);
// AsyncStorage.setItem('baseConfig', JSON.stringify(initialState));

// 修改当前config
export async function changeCurBaseConfig(index) {
	const config = await getBaseConfig();
	setBaseConfig({
		...config,
		curConfig: index,
	});
}
// 添加config
export async function addBaseConfig(backendBaseUrl) {
	const config = await getBaseConfig();
	config.configList.push({
		...config.configList[0],
		backendBaseUrl,
	});
	setBaseConfig({
		...config,
		curConfig: config.configList.length - 1,
	});
}
// 获取当前config
export async function getCurBaseConfig() {
	const config = await getBaseConfig();
	return config.configList[config.curConfig];
}
// 获取当前 baseConfig
export async function getAllBaseConfig() {
	return await getBaseConfig();
}
