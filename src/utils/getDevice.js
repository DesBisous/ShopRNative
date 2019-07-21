import { NativeModules, Alert } from 'react-native';
import DeviceInfo from 'react-native-device-info';
import { NetworkInfo } from 'react-native-network-info';
//RN调iOS原生定位权限有权限返回 1，没权限返回 0
const GetLocationManager = NativeModules.GetLocationRecognition;
//RN调iOS原生通讯录权限有权限返回 1，没权限返回 0
const GetPermissionsManager = NativeModules.GetPermissionsRecognition;
//RN进入iOS原生通讯录返回所有给RN
const GetSectionContactsManager = NativeModules.GetSectionContactsRecognition;
//sim
const GetSimInfoManager = NativeModules.GetSimInfoRecognition;

// 获取定位信息
export function getGeolocation() {
	GetLocationManager.getLocation((positionError, positionEvents) => {
		if (positionError) {
			console.log(positionError);
		} else if (positionEvents.getLocation) {
			navigator.geolocation.getCurrentPosition(
				({ coords: { latitude, longitude } }) => {
					this.props.deviceActions.setGeolocation({
						latitude,
						longitude,
					});
				}
			);
		} else {
			Alert.alert(
				'提示',
				'请在iPhone的“设置-ShopRNative-允许访问位置,允许ShopRNative访问您的位置'
			);
		}
	});
}
// 获取通讯录信息
export function getDirectories() {
	GetPermissionsManager.getPermissions((permissionError, permissionEvents) => {
		if (permissionError) {
			console.log(permissionError);
		} else if (permissionEvents.getPermissions) {
			GetSectionContactsManager.getSectionContacts((error, events) => {
				if (error) {
					console.log(error);
				} else {
					const { contacts } = events;
					this.props.deviceActions.setDirectories(
						JSON.parse(contacts).contacts
					);
				}
			});
		} else {
			Alert.alert(
				'提示',
				'请在iPhone的“设置-ShopRNative-允许访问通讯录,允许ShopRNative访问您的通讯录'
			);
		}
	});
}
// 获取设备基本信息
export function getDeviceinfo() {
	this.props.deviceActions.setDeviceinfo({
		type: 'iOS',
		channel: 'AppStore',
		systemName: DeviceInfo.getSystemName(), // 系统名称
		osVersion: DeviceInfo.getSystemVersion(), // 系统版本
		deviceName: DeviceInfo.getDeviceName(), // 设备名称
		moduleName: DeviceInfo.getModel(), // 手机型号
		phoneCompany: DeviceInfo.getBrand(), // 品牌
		imei: DeviceInfo.getUniqueID(), // 设备标识
		carrier: DeviceInfo.getCarrier(), // 运营商
	});
}
// 获取wifi信息
export async function getWifiInfo() {
	const wifi = {
		ssid: '',
		bssid: '',
		ipAddress: '',
		ipv4Address: '',
		broadcast: '',
		subnet: '',
	};
	wifi.ssid = await NetworkInfo.getSSID();
	wifi.bssid = await NetworkInfo.getBSSID();
	wifi.ipAddress = await NetworkInfo.getIPAddress();
	wifi.ipv4Address = await NetworkInfo.getIPV4Address();
	wifi.broadcast = await NetworkInfo.getBroadcast();
	wifi.subnet = await NetworkInfo.getSubnet();
	// 开发者账号没有获取WIFI权限，明天问一下
	console.log(wifi);
	this.props.deviceActions.setDeviceinfo(wifi);
}
// 获取sim卡信息
export function getSimInfo() {
	GetSimInfoManager.getSimInfo((error, events) => {
		if (error) {
			console.log(error);
		} else {
			console.log(events);
			this.props.deviceActions.setDeviceinfo(events);
		}
	});
}
