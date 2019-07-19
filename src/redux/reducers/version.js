import { fromJS } from 'immutable';
import { UPDATE_VERSION } from '../constants/version';
import { setVersion } from '../../utils/asyncStorage';

const initialState = fromJS({
	no: 'v1.0.0',
	name: 'ShopRNative',
});

setVersion(JSON.stringify(initialState.toJS()));

export default function versionReducer(state = initialState, action) {
	switch (action.type) {
		case UPDATE_VERSION:
			setVersion({
				...state.toJS(),
				...action.data,
			});
			return fromJS({
				...state.toJS(),
				...action.data,
			});
		default:
			return state;
	}
}
