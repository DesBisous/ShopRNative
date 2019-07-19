import { all } from 'redux-saga/effects';
import version from './version';

export default function* rootSagas() {
	yield all([version()]);
}
