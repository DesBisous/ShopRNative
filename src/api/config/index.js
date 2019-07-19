import axios from 'axios';
import DeviceInfo from 'react-native-device-info';
import Toast from 'react-native-root-toast';
import { getVersion } from '../../utils/asyncStorage';
import { getCurBaseConfig } from './config';
import layouts from '../../styles/common/layouts';

// 全局配置
const instance = axios.create({
	timeout: 30000,
	headers: {
		Accept: 'application/json',
		'Content-Type': 'application/json',
		phoneType: 'iOS',
		phoneSys: DeviceInfo.getSystemVersion(), // 系统版本
		phoneModel: DeviceInfo.getModel(), // 手机型号
		phoneBrand: DeviceInfo.getBrand(), // 品牌
		imei: DeviceInfo.getUniqueID(), // 设备标识
	},
});

// 添加请求拦截器
instance.interceptors.request.use(
	async config => {
		// 设置baseUrl
		const backendBaseUrl = (await getCurBaseConfig()).backendBaseUrl;
		config.baseURL = backendBaseUrl;
		// version
		const version = await getVersion();
		config.headers.versionName = version.name;
		config.headers.versionNo = version.no;
		console.log(config);
		return config;
	},
	// 对请求错误做些什么
	error => Promise.reject(error)
);

// 添加响应拦截器
instance.interceptors.response.use(
	// 对响应数据做点什么
	response => ({
		code: 1,
		data: response.data,
		msg: '请求成功',
	}),
	// 对响应错误做点什么
	error => {
		let errorMsg = null;
		if (__DEV__) {
			console.log(error);
		}
		if (error.response) {
			switch (error.response.status) {
				case 400:
					errorMsg = `请求无效[${error.response.status}]`;
					break;
				case 401:
					errorMsg = `登录失效，请重新登录[${error.response.status}]`;
					break;
				case 404:
					errorMsg = `请求不存在[${error.response.status}]`;
					break;
				case 500:
					errorMsg = `服务器错误[${error.response.status}]`;
					break;
				case 501:
					errorMsg = `服务器维护或宕机[${error.response.status}]`;
					break;
				default:
					errorMsg = `网络异常[${error.response.status}]`;
					break;
			}
		} else if (error.request) {
			// 超时
			if (error.request.readyState === 4 && error.request.status === 0) {
				errorMsg = '请求超时';
			} else {
				errorMsg = '请求失败';
			}
		}
		Toast.show(errorMsg || error, layouts.toast);
		return {
			code: 0,
			msg: errorMsg,
		};
	}
);

export default instance;
