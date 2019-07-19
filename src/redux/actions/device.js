import {
	SET_DIRECTORIES,
	SET_DEVICEINFO,
	SET_GEOLOCATION,
} from '../constants/device';

// 存储通讯录联系人列表
export function setDirectories(data) {
	return {
		type: SET_DIRECTORIES,
		data,
	};
}
// 存储设备信息
export function setDeviceinfo(data) {
	return {
		type: SET_DEVICEINFO,
		data,
	};
}
// 存储定位信息
export function setGeolocation(data) {
	return {
		type: SET_GEOLOCATION,
		data,
	};
}
