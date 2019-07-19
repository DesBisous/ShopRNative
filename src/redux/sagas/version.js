import { put, call, select, takeEvery } from 'redux-saga/effects';
import { getVersionState } from './selectors';
import { updateVersion } from '../actions/version';
import { GET_VERSION } from '../constants/version';

function* getVersion({ data }) {
	try {
		let version = yield select(getVersionState);
		version = version.toJS();
		version.no = 'v1.0.1';
		yield put(updateVersion(version));
	} catch (err) {
		throw err;
	}
}

function* version() {
	yield takeEvery(GET_VERSION, getVersion);
}

export default version;
