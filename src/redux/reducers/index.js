import { combineReducers } from 'redux';
import version from './version';
import device from './device';

// Combine all
const rootReducer = combineReducers({
	version,
	device,
});

export default rootReducer;
