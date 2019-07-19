import { UPDATE_VERSION, GET_VERSION } from '../constants/version';

export function updateVersion(data) {
	return {
		type: UPDATE_VERSION,
		data,
	};
}

export function getVersion(data) {
	return {
		type: GET_VERSION,
		data,
	};
}
